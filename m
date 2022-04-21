Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF11D509684
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 07:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384296AbiDUFQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 01:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384331AbiDUFQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 01:16:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF4F813D18
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 22:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650518024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=httJCT0Tg3TZnTNvm8TBcLaMq9M0mwNcCFiF9q7hQXs=;
        b=igqxYCTx1Gf0JhOi1ho38yrDaJ2MIyZtKQyFmA5CTmuE9kd3EyxTAc1YXbCoRKSRPOr5u+
        a9Y93uerCgpLM4YKqSvvNgS13yNtY4gKEFtWzNFWFB637ItNX3CWmRkjIQdtU1UEbv4Qgf
        xxCd78QziSgpIcyQZqe8FvwogifHp7Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-VNUGnnvNOnmOxtmgV5S5vw-1; Thu, 21 Apr 2022 01:13:38 -0400
X-MC-Unique: VNUGnnvNOnmOxtmgV5S5vw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C01BF803D65;
        Thu, 21 Apr 2022 05:13:37 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70F05145BA5A;
        Thu, 21 Apr 2022 05:13:32 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, x86@kernel.org,
        David Airlie <airlied@linux.ie>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [RFC PATCH v2 08/10] KVM: x86: rename .set_apic_access_page_addr to reload_apic_access_page
Date:   Thu, 21 Apr 2022 08:12:42 +0300
Message-Id: <20220421051244.187733-9-mlevitsk@redhat.com>
In-Reply-To: <20220421051244.187733-1-mlevitsk@redhat.com>
References: <20220421051244.187733-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 96e4e9842dfc6..997edb7453ac2 100644
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
index ae41d2df69fe9..f83cfcd7dd74c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1415,7 +1415,7 @@ struct kvm_x86_ops {
 	bool (*guest_apic_has_interrupt)(struct kvm_vcpu *vcpu);
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
-	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu);
+	void (*reload_apic_pages)(struct kvm_vcpu *vcpu);
 	void (*deliver_interrupt)(struct kvm_lapic *apic, int delivery_mode,
 				  int trig_mode, int vector);
 	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
@@ -1888,7 +1888,6 @@ int kvm_cpu_has_extint(struct kvm_vcpu *v);
 int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
-
 int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 		    unsigned long ipi_bitmap_high, u32 min,
 		    unsigned long icr, int op_64_bit);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cf8581978bce3..7defd31703c61 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6339,7 +6339,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	vmx_update_msr_bitmap_x2apic(vcpu);
 }
 
-static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
+static void vmx_reload_apic_access_page(struct kvm_vcpu *vcpu)
 {
 	struct page *page;
 
@@ -7777,7 +7777,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.enable_irq_window = vmx_enable_irq_window,
 	.update_cr8_intercept = vmx_update_cr8_intercept,
 	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
-	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
+	.reload_apic_pages = vmx_reload_apic_access_page,
 	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.apicv_post_state_restore = vmx_apicv_post_state_restore,
@@ -7940,12 +7940,12 @@ static __init int hardware_setup(void)
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
index ab336f7c82e4b..3ac2d0134271b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9949,12 +9949,12 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
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
@@ -10071,7 +10071,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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

