Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467024C9337
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 19:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237013AbiCAS30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 13:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236910AbiCAS3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 13:29:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49A6D286FC
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 10:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646159316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xHLTg2ZynLQCsdLNoPMgFEBXTh+HTakHjwxMKQ+OnB8=;
        b=MPatA33FFi2aDjFYn6EhDHbCJoSxbPkMJP1dqrmwt35CnbpnPin/YNS5krTYyVYgxUAjlX
        1ErHeU9jp0QD4D6vP/aH8crktIKvu3pSnvNBGa+uhgmPZdV7gQrCxRylC3pkHMI/GYisOl
        cTvW3kMmvA9DWZ02G7bCr6Dxe68snOc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-oNTXenyBNvGXwAFj1JC4KA-1; Tue, 01 Mar 2022 13:28:33 -0500
X-MC-Unique: oNTXenyBNvGXwAFj1JC4KA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F8CA835DE0;
        Tue,  1 Mar 2022 18:28:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE20D86C41;
        Tue,  1 Mar 2022 18:28:23 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        x86@kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Joerg Roedel <joro@8bytes.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        dri-devel@lists.freedesktop.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 09/11] KVM: x86: rename .set_apic_access_page_addr to reload_apic_access_page
Date:   Tue,  1 Mar 2022 20:26:37 +0200
Message-Id: <20220301182639.559568-10-mlevitsk@redhat.com>
In-Reply-To: <20220301182639.559568-1-mlevitsk@redhat.com>
References: <20220301182639.559568-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be used on SVM to reload shadow page of the AVIC physid table

No functional change intended

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 2 +-
 arch/x86/include/asm/kvm_host.h    | 3 +--
 arch/x86/kvm/vmx/vmx.c             | 8 ++++----
 arch/x86/kvm/x86.c                 | 6 +++---
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index eb16e32117610..6473b61d241e2 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -82,7 +82,7 @@ KVM_X86_OP_OPTIONAL(hwapic_isr_update)
 KVM_X86_OP_OPTIONAL_RET0(guest_apic_has_interrupt)
 KVM_X86_OP_OPTIONAL(load_eoi_exitmap)
 KVM_X86_OP_OPTIONAL(set_virtual_apic_mode)
-KVM_X86_OP_OPTIONAL(set_apic_access_page_addr)
+KVM_X86_OP_OPTIONAL(reload_apic_pages)
 KVM_X86_OP(deliver_interrupt)
 KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
 KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 83f734e201e24..c73f8415533a6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1403,7 +1403,7 @@ struct kvm_x86_ops {
 	bool (*guest_apic_has_interrupt)(struct kvm_vcpu *vcpu);
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
-	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu);
+	void (*reload_apic_pages)(struct kvm_vcpu *vcpu);
 	void (*deliver_interrupt)(struct kvm_lapic *apic, int delivery_mode,
 				  int trig_mode, int vector);
 	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
@@ -1877,7 +1877,6 @@ int kvm_cpu_has_extint(struct kvm_vcpu *v);
 int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
-
 int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 		    unsigned long ipi_bitmap_high, u32 min,
 		    unsigned long icr, int op_64_bit);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b325f99b21774..4a9a4785b55e4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6353,7 +6353,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	vmx_update_msr_bitmap_x2apic(vcpu);
 }
 
-static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
+static void vmx_reload_apic_access_page(struct kvm_vcpu *vcpu)
 {
 	struct page *page;
 
@@ -7778,7 +7778,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.enable_irq_window = vmx_enable_irq_window,
 	.update_cr8_intercept = vmx_update_cr8_intercept,
 	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
-	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
+	.reload_apic_pages = vmx_reload_apic_access_page,
 	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.apicv_post_state_restore = vmx_apicv_post_state_restore,
@@ -7942,12 +7942,12 @@ static __init int hardware_setup(void)
 		enable_vnmi = 0;
 
 	/*
-	 * set_apic_access_page_addr() is used to reload apic access
+	 * kvm_vcpu_reload_apic_pages() is used to reload apic access
 	 * page upon invalidation.  No need to do anything if not
 	 * using the APIC_ACCESS_ADDR VMCS field.
 	 */
 	if (!flexpriority_enabled)
-		vmx_x86_ops.set_apic_access_page_addr = NULL;
+		vmx_x86_ops.reload_apic_pages = NULL;
 
 	if (!cpu_has_vmx_tpr_shadow())
 		vmx_x86_ops.update_cr8_intercept = NULL;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 14b964eb079e7..1a6cfc27c3b35 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9824,12 +9824,12 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
 }
 
-static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_reload_apic_pages(struct kvm_vcpu *vcpu)
 {
 	if (!lapic_in_kernel(vcpu))
 		return;
 
-	static_call_cond(kvm_x86_set_apic_access_page_addr)(vcpu);
+	static_call_cond(kvm_x86_reload_apic_pages)(vcpu);
 }
 
 void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
@@ -9945,7 +9945,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_LOAD_EOI_EXITMAP, vcpu))
 			vcpu_load_eoi_exitmap(vcpu);
 		if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
-			kvm_vcpu_reload_apic_access_page(vcpu);
+			kvm_vcpu_reload_apic_pages(vcpu);
 		if (kvm_check_request(KVM_REQ_HV_CRASH, vcpu)) {
 			vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 			vcpu->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
-- 
2.26.3

