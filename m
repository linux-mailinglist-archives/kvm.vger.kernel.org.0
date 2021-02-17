Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C9731DBCE
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 16:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhBQO72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 09:59:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55819 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233685AbhBQO7J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 09:59:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613573863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v7QxUNvE1TTQeAPHwRI8Q0OyR14m+5XWMXhLRlivKxs=;
        b=EppWLTyw1YH5WYgwaPLH4eKj31HKvu6durGMpLra7mMqUJ2ysYHwGxgadOtAF0I+eB3HPF
        TzFADT9ywJKyIZy2xYf5JvHYcRWuv4YHRYZqDQICBDb1E0oY5foWcL5V3m0R4/pfHxE860
        AoHoll567fZPBCnk1t25GdEhOnGXb70=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-ogPkOPpgNTWAMjjETuyzBQ-1; Wed, 17 Feb 2021 09:57:39 -0500
X-MC-Unique: ogPkOPpgNTWAMjjETuyzBQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACFC21005501;
        Wed, 17 Feb 2021 14:57:37 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C81410023AF;
        Wed, 17 Feb 2021 14:57:34 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 4/7] KVM: nVMX: move inject_page_fault tweak to .complete_mmu_init
Date:   Wed, 17 Feb 2021 16:57:15 +0200
Message-Id: <20210217145718.1217358-5-mlevitsk@redhat.com>
In-Reply-To: <20210217145718.1217358-1-mlevitsk@redhat.com>
References: <20210217145718.1217358-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fixes a (mostly theoretical) bug which can happen if ept=0
on host and we run a nested guest which triggers a mmu context
reset while running nested.
In this case the .inject_page_fault callback will be lost.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 8 +-------
 arch/x86/kvm/vmx/nested.h | 1 +
 arch/x86/kvm/vmx/vmx.c    | 5 ++++-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0b6dab6915a3..f9de729dbea6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -419,7 +419,7 @@ static int nested_vmx_check_exception(struct kvm_vcpu *vcpu, unsigned long *exit
 }
 
 
-static void vmx_inject_page_fault_nested(struct kvm_vcpu *vcpu,
+void vmx_inject_page_fault_nested(struct kvm_vcpu *vcpu,
 		struct x86_exception *fault)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
@@ -2620,9 +2620,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
 	}
 
-	if (!enable_ept)
-		vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
-
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
 	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 				     vmcs12->guest_ia32_perf_global_ctrl)))
@@ -4224,9 +4221,6 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	if (nested_vmx_load_cr3(vcpu, vmcs12->host_cr3, false, &ignored))
 		nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_PDPTE_FAIL);
 
-	if (!enable_ept)
-		vcpu->arch.walk_mmu->inject_page_fault = kvm_inject_page_fault;
-
 	nested_vmx_transition_tlb_flush(vcpu, vmcs12, false);
 
 	vmcs_write32(GUEST_SYSENTER_CS, vmcs12->host_ia32_sysenter_cs);
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 197148d76b8f..2ab279744d38 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -36,6 +36,7 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
 void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu);
 bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
 				 int size);
+void vmx_inject_page_fault_nested(struct kvm_vcpu *vcpu,struct x86_exception *fault);
 
 static inline struct vmcs12 *get_vmcs12(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bf6ef674d688..c43324df4877 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3254,7 +3254,10 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
 
 static void vmx_complete_mmu_init(struct kvm_vcpu *vcpu)
 {
-
+	if (!enable_ept && is_guest_mode(vcpu)) {
+		WARN_ON(mmu_is_nested(vcpu));
+		vcpu->arch.mmu->inject_page_fault = vmx_inject_page_fault_nested;
+	}
 }
 
 static bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
-- 
2.26.2

