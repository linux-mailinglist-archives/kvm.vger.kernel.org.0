Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC84E5BF122
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiITXcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiITXcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:32:04 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC927785BC
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:51 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id u6-20020a17090a1f0600b002039826d478so1998252pja.4
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=whBnEK+HOKHkt5PuN+MXgSRnFM5gmru7Bat2+aOdg0k=;
        b=sHZkNAA/69NpV0Eb3zGTC9UX0VnPUJWlR8fC/bxFnhF8QXWtKgBbPINNSI4ROCbpFI
         IoljzlNVvOHvopdIRr4oo8aP1xWd91CmQlwLXgWv/zontpZNOsgGSYm5TJgQpIrEonEC
         sD+wALzvW24ifzHgB5zXxoHjGMeZLpNemhlga36GkpHpSgbDICwsV0/LR4eRnfUiny/k
         ch0eK9Ib0l4xiZfBV2M3WHYzAe44r1YPhq82nwr7HdwCdzIUxhR6+Yn//bckvrqyp9wz
         WeKWgpQ2wJGDXcvu34RXMtTQuN6ExPagwATR6PKomFkjRWZah9qDNFDh3w9KJeFvo1V/
         kYaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=whBnEK+HOKHkt5PuN+MXgSRnFM5gmru7Bat2+aOdg0k=;
        b=CoIuc6xXxW03iGt4pJq1kpQYpzTttGouZ9Yp3KQRbWBD3DDmGJQMroPPHfJ7MWTK1e
         YZxgrl5M9vvqzih0EZIvaWPFFZ2smKJRkiYYkOeup200psUPw/t/uzmHtVLF3cVIanVn
         jMJS3U7Rz0mChid9tsLFP11pEJEUMYBnJOBLdREscIevx+OMrJ91nwUZxj/IV44wOXPi
         cqKKvgEqIbLNUW+KoHe/TEOn/kIobFd4+nigSnSYV7JoWrtjHooISy8r0Dcqx2vbZVjG
         LRDO3HJvT6Mw9skrtZPrvVilD5/ZEX/8xjPKCyytZmP2qgSdwHfQ84bVD47HD0ng+OHO
         PGwg==
X-Gm-Message-State: ACrzQf3qpeoAHy3U0iPuYuKD4N6wpIhYaQ/KGzB09jtRzw1Vj2QSwS1H
        yJZIMgWMN2dwsNHfPmlCzGyJ13jqXig=
X-Google-Smtp-Source: AMsMyM7+WqRZ9/F6ZVFeRkBPmJ9gurF7tFxDD36jxZ9T33deQOh2arS7VM5HAkrNxB/WK6Zf0nVh6G6yYxw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:27a1:b0:548:ea2e:885c with SMTP id
 bd33-20020a056a0027a100b00548ea2e885cmr26132664pfb.55.1663716711405; Tue, 20
 Sep 2022 16:31:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:14 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-9-seanjc@google.com>
Subject: [PATCH v3 08/28] KVM: SVM: Don't put/load AVIC when setting virtual
 APIC mode
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the VMCB updates from avic_refresh_apicv_exec_ctrl() into
avic_set_virtual_apic_mode() and invert the dependency being said
functions to avoid calling avic_vcpu_{load,put}() and
avic_set_pi_irte_mode() when "only" setting the virtual APIC mode.

avic_set_virtual_apic_mode() is invoked from common x86 with preemption
enabled, which makes avic_vcpu_{load,put}() unhappy.  Luckily, calling
those and updating IRTE stuff is unnecessary as the only reason
avic_set_virtual_apic_mode() is called is to handle transitions between
xAPIC and x2APIC that don't also toggle APICv activation.  And if
activation doesn't change, there's no need to fiddle with the physical
APIC ID table or update IRTE.

The "full" refresh is guaranteed to be called if activation changes in
this case as the only call to the "set" path is:

	kvm_vcpu_update_apicv(vcpu);
	static_call_cond(kvm_x86_set_virtual_apic_mode)(vcpu);

and kvm_vcpu_update_apicv() invokes the refresh if activation changes:

	if (apic->apicv_active == activate)
		goto out;

	apic->apicv_active = activate;
	kvm_apic_update_apicv(vcpu);
	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);

Rename the helper to reflect that it is also called during "refresh".

  WARNING: CPU: 183 PID: 49186 at arch/x86/kvm/svm/avic.c:1081 avic_vcpu_put+0xde/0xf0 [kvm_amd]
  CPU: 183 PID: 49186 Comm: stable Tainted: G           O       6.0.0-smp--fcddbca45f0a-sink #34
  Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 10.48.0 01/27/2022
  RIP: 0010:avic_vcpu_put+0xde/0xf0 [kvm_amd]
   avic_refresh_apicv_exec_ctrl+0x142/0x1c0 [kvm_amd]
   avic_set_virtual_apic_mode+0x5a/0x70 [kvm_amd]
   kvm_lapic_set_base+0x149/0x1a0 [kvm]
   kvm_set_apic_base+0x8f/0xd0 [kvm]
   kvm_set_msr_common+0xa3a/0xdc0 [kvm]
   svm_set_msr+0x364/0x6b0 [kvm_amd]
   __kvm_set_msr+0xb8/0x1c0 [kvm]
   kvm_emulate_wrmsr+0x58/0x1d0 [kvm]
   msr_interception+0x1c/0x30 [kvm_amd]
   svm_invoke_exit_handler+0x31/0x100 [kvm_amd]
   svm_handle_exit+0xfc/0x160 [kvm_amd]
   vcpu_enter_guest+0x21bb/0x23e0 [kvm]
   vcpu_run+0x92/0x450 [kvm]
   kvm_arch_vcpu_ioctl_run+0x43e/0x6e0 [kvm]
   kvm_vcpu_ioctl+0x559/0x620 [kvm]

Fixes: 05c4fe8c1bd9 ("KVM: SVM: Refresh AVIC configuration when changing APIC mode")
Cc: stable@vger.kernel.org
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 31 +++++++++++++++----------------
 arch/x86/kvm/svm/svm.c  |  2 +-
 arch/x86/kvm/svm/svm.h  |  2 +-
 3 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 8f9426f21bbf..535e35edce1d 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -720,18 +720,6 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	avic_handle_ldr_update(vcpu);
 }
 
-void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
-{
-	if (!lapic_in_kernel(vcpu) || avic_mode == AVIC_MODE_NONE)
-		return;
-
-	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID) {
-		WARN_ONCE(true, "Invalid local APIC state (vcpu_id=%d)", vcpu->vcpu_id);
-		return;
-	}
-	avic_refresh_apicv_exec_ctrl(vcpu);
-}
-
 static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 {
 	int ret = 0;
@@ -1074,17 +1062,18 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 }
 
-
-void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
+void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb01.ptr;
-	bool activated = kvm_vcpu_apicv_active(vcpu);
+
+	if (!lapic_in_kernel(vcpu) || avic_mode == AVIC_MODE_NONE)
+		return;
 
 	if (!enable_apicv)
 		return;
 
-	if (activated) {
+	if (kvm_vcpu_apicv_active(vcpu)) {
 		/**
 		 * During AVIC temporary deactivation, guest could update
 		 * APIC ID, DFR and LDR registers, which would not be trapped
@@ -1098,6 +1087,16 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 		avic_deactivate_vmcb(svm);
 	}
 	vmcb_mark_dirty(vmcb, VMCB_AVIC);
+}
+
+void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
+{
+	bool activated = kvm_vcpu_apicv_active(vcpu);
+
+	if (!enable_apicv)
+		return;
+
+	avic_refresh_virtual_apic_mode(vcpu);
 
 	if (activated)
 		avic_vcpu_load(vcpu, vcpu->cpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f3813dbacb9f..2aa5069bafb2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4807,7 +4807,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.enable_nmi_window = svm_enable_nmi_window,
 	.enable_irq_window = svm_enable_irq_window,
 	.update_cr8_intercept = svm_update_cr8_intercept,
-	.set_virtual_apic_mode = avic_set_virtual_apic_mode,
+	.set_virtual_apic_mode = avic_refresh_virtual_apic_mode,
 	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
 	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
 	.apicv_post_state_restore = avic_apicv_post_state_restore,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6a7686bf6900..7a95f50e80e7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -646,7 +646,7 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void avic_ring_doorbell(struct kvm_vcpu *vcpu);
 unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu);
-void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
+void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
 
 
 /* sev.c */
-- 
2.37.3.968.ga6b4b080e4-goog

