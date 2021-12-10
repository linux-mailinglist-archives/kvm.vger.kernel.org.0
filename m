Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD1A4705D4
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 17:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243674AbhLJQkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 11:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243659AbhLJQkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 11:40:18 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEC2C0617A2
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 08:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Dy+EnFe1FApmZyKcptLtP5bmR0mNvgSWFdTb0xnTfpg=; b=jU22HAqWuJEvTxk9WlpqJzPSqC
        KeVfh4M0s59lHVYE5uYOy1DezU9tTK6rq56AKp404/2mdOH8czNrUbTJOoF187WPS0vODyGDhLYF7
        lc2CLNn2Q/FVlhvunetCdqjYye0vJEyJ7QBdSrSt/D7zDRTix1XgJzmlN4uhz4tuzmFSMj+R2zkKj
        M1gNm8aC8O3DGPv9ri7ALDw/5JwnPz46MK4CPoan3FLjXUytQvzrColxBwnmJqvkMx3YmIsgA6ozh
        hEiATMIPa92gifFTN1WuLWskqdUbzmMr6shUB5m8k44X+SBVBkLf5G3SR1ESsCOnh3sH34X7d1efS
        QHU8jp/A==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvisl-000abx-LD; Fri, 10 Dec 2021 16:36:27 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvisl-0000lr-AN; Fri, 10 Dec 2021 16:36:27 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: [PATCH v6 6/6] KVM: x86: First attempt at converting nested virtual APIC page to gpc
Date:   Fri, 10 Dec 2021 16:36:25 +0000
Message-Id: <20211210163625.2886-7-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210163625.2886-1-dwmw2@infradead.org>
References: <20211210163625.2886-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This is what evolved during the discussion at
https://lore.kernel.org/kvm/960E233F-EC0B-4FB5-BA2E-C8D2CCB38B12@infradead.org/T/#m11d75fcfe2da357ec1dabba0d0e3abb91fd13665

As discussed, an alternative approach might be to augment
kvm_arch_memslots_updated() to raise KVM_REQ_GET_NESTED_STATE_PAGES to
each vCPU (and make that req only do anything on a given vCPU if that
vCPU is actually in L2 guest mode).

That would mean the reload gets actively triggered even on memslot
changes rather than only on MMU notifiers as is the case now. It could
*potentially* mean we can drop the new 'check_guest_maps' function.

The 'check_guest_maps' function could be a lot simpler than it is,
though. It only really needs to get kvm->memslots->generation, then
check each gpc->generation against that, and each gpc->valid.

Also I suspect we *shouldn't* destroy the virtual_apic_cache in
nested_vmx_vmexit(). We can just leave it there for next time the
vCPU enters guest mode. If it happens to get invalidated in the
meantime, that's fine and we'll refresh it on the way back in.
We probably *would* want to actively do something on memslot changes
in that case though, to ensure that even if the vCPU isn't in guest
mode any more, we *release* the cached page.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/nested.c       | 50 ++++++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.c          | 12 +++++---
 arch/x86/kvm/vmx/vmx.h          |  2 +-
 arch/x86/kvm/x86.c              | 10 +++++++
 5 files changed, 63 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 392d13c36083..8216ae8d1b38 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1517,6 +1517,7 @@ struct kvm_x86_nested_ops {
 	int (*enable_evmcs)(struct kvm_vcpu *vcpu,
 			    uint16_t *vmcs_version);
 	uint16_t (*get_evmcs_version)(struct kvm_vcpu *vcpu);
+	void (*check_guest_maps)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_init_ops {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2f6f465e575f..09fab0f3c472 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -315,7 +315,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
 		kvm_release_page_clean(vmx->nested.apic_access_page);
 		vmx->nested.apic_access_page = NULL;
 	}
-	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
+	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm, &vmx->nested.virtual_apic_cache);
 	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
 	vmx->nested.pi_desc = NULL;
 
@@ -3199,10 +3199,12 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	}
 
 	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW)) {
-		map = &vmx->nested.virtual_apic_map;
+		struct gfn_to_pfn_cache *gpc = &vmx->nested.virtual_apic_cache;
 
-		if (!kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->virtual_apic_page_addr), map)) {
-			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, pfn_to_hpa(map->pfn));
+ 		if (!kvm_gfn_to_pfn_cache_init(vcpu->kvm, gpc, vcpu, true, true,
+					       vmcs12->virtual_apic_page_addr,
+					       PAGE_SIZE, true)) {
+			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, pfn_to_hpa(gpc->pfn));
 		} else if (nested_cpu_has(vmcs12, CPU_BASED_CR8_LOAD_EXITING) &&
 		           nested_cpu_has(vmcs12, CPU_BASED_CR8_STORE_EXITING) &&
 			   !nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
@@ -3227,6 +3229,9 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	if (nested_cpu_has_posted_intr(vmcs12)) {
 		map = &vmx->nested.pi_desc_map;
 
+		if (kvm_vcpu_mapped(map))
+			kvm_vcpu_unmap(vcpu, map, true);
+
 		if (!kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->posted_intr_desc_addr), map)) {
 			vmx->nested.pi_desc =
 				(struct pi_desc *)(((void *)map->hva) +
@@ -3271,6 +3276,29 @@ static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static void nested_vmx_check_guest_maps(struct kvm_vcpu *vcpu)
+{
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct gfn_to_pfn_cache *gpc;
+
+	int valid;
+
+	if (nested_cpu_has_posted_intr(vmcs12)) {
+		gpc = &vmx->nested.virtual_apic_cache;
+
+		read_lock(&gpc->lock);
+		valid = kvm_gfn_to_pfn_cache_check(vcpu->kvm, gpc,
+						   vmcs12->virtual_apic_page_addr,
+						   PAGE_SIZE);
+		read_unlock(&gpc->lock);
+		if (!valid) {
+			kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+			return;
+		}
+	}
+}
+
 static int nested_vmx_write_pml_buffer(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
 	struct vmcs12 *vmcs12;
@@ -3768,9 +3796,15 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 
 	max_irr = find_last_bit((unsigned long *)vmx->nested.pi_desc->pir, 256);
 	if (max_irr != 256) {
-		vapic_page = vmx->nested.virtual_apic_map.hva;
-		if (!vapic_page)
+		struct gfn_to_pfn_cache *gpc = &vmx->nested.virtual_apic_cache;
+
+		read_lock(&gpc->lock);
+		if (!kvm_gfn_to_pfn_cache_check(vcpu->kvm, gpc, gpc->gpa, PAGE_SIZE)) {
+			read_unlock(&gpc->lock);
 			goto mmio_needed;
+		}
+
+		vapic_page = gpc->khva;
 
 		__kvm_apic_update_irr(vmx->nested.pi_desc->pir,
 			vapic_page, &max_irr);
@@ -3780,6 +3814,7 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 			status |= (u8)max_irr;
 			vmcs_write16(GUEST_INTR_STATUS, status);
 		}
+		read_unlock(&gpc->lock);
 	}
 
 	nested_mark_vmcs12_pages_dirty(vcpu);
@@ -4599,7 +4634,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		kvm_release_page_clean(vmx->nested.apic_access_page);
 		vmx->nested.apic_access_page = NULL;
 	}
-	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
+	kvm_gfn_to_pfn_cache_unmap(vcpu->kvm, &vmx->nested.virtual_apic_cache);
 	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
 	vmx->nested.pi_desc = NULL;
 
@@ -6776,4 +6811,5 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
 	.write_log_dirty = nested_vmx_write_pml_buffer,
 	.enable_evmcs = nested_enable_evmcs,
 	.get_evmcs_version = nested_get_evmcs_version,
+	.check_guest_maps = nested_vmx_check_guest_maps,
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 63615d242bdf..d7c36ca544e3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3852,19 +3852,23 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 static bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	void *vapic_page;
+	struct gfn_to_pfn_cache *gpc = &vmx->nested.virtual_apic_cache;
 	u32 vppr;
 	int rvi;
 
 	if (WARN_ON_ONCE(!is_guest_mode(vcpu)) ||
 		!nested_cpu_has_vid(get_vmcs12(vcpu)) ||
-		WARN_ON_ONCE(!vmx->nested.virtual_apic_map.gfn))
+		WARN_ON_ONCE(gpc->gpa == GPA_INVALID))
 		return false;
 
 	rvi = vmx_get_rvi();
 
-	vapic_page = vmx->nested.virtual_apic_map.hva;
-	vppr = *((u32 *)(vapic_page + APIC_PROCPRI));
+	read_lock(&gpc->lock);
+	if (!kvm_gfn_to_pfn_cache_check(vcpu->kvm, gpc, gpc->gpa, PAGE_SIZE))
+		vppr = *((u32 *)(gpc->khva + APIC_PROCPRI));
+	else
+		vppr = 0xff;
+	read_unlock(&gpc->lock);
 
 	return ((rvi & 0xf0) > (vppr & 0xf0));
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 6c2c1aff1c3d..400e7bed11fc 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -204,7 +204,7 @@ struct nested_vmx {
 	 * pointers, so we must keep them pinned while L2 runs.
 	 */
 	struct page *apic_access_page;
-	struct kvm_host_map virtual_apic_map;
+	struct gfn_to_pfn_cache virtual_apic_cache;
 	struct kvm_host_map pi_desc_map;
 
 	struct kvm_host_map msr_bitmap_map;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5e7a4982fb90..e9d89bc3f7dd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9826,6 +9826,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
+		if (kvm_check_request(KVM_REQ_GPC_INVALIDATE, vcpu))
+			; /* Nothing to do. It just wanted to wake us */
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
@@ -9872,6 +9874,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	local_irq_disable();
 	vcpu->mode = IN_GUEST_MODE;
 
+	/*
+	 * If the guest requires direct access to mapped L1 pages, check
+	 * the caches are valid. Will raise KVM_REQ_GET_NESTED_STATE_PAGES
+	 * to go and revalidate them, if necessary.
+	 */
+	if (is_guest_mode(vcpu) && kvm_x86_ops.nested_ops->check_guest_maps)
+		kvm_x86_ops.nested_ops->check_guest_maps(vcpu);
+
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 
 	/*
-- 
2.31.1

