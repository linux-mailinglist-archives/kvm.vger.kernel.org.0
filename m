Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590845A72BE
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbiHaAhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiHaAg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:36:28 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E3DA1D25
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:26 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id s3-20020a17090a5d0300b001fb3ac54a03so5307359pji.2
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=tqSFf2c/aR0xKLJBDtSO/L4uHcT204aNH3nZsuo4w3I=;
        b=KErlEMAFoPTtFRi6Bojf/EJxZz4t2LYfQhsYhAPlw+jdz4eBgRUBZEhO6Hyc41ujO1
         sQEGPDQXJ0Bdy/9xAdVxhOjhkikMSI6dEBsVrw+M3bXKGR+EunIcRvOrh3xYizbSJtcG
         ziV0rcRn6eOA1jcEjUgc8yyP7GSfzC9A2LRJCCK9wHN/Wb1sz3EC5Etu+GJkqNCflwJ2
         bEYGOoqjLnJHngLHPQsyfoiaIr2GuihYJM3gouUKIyzLhgdFyTRQdfcOe1+pLIFXcsnl
         lxfjvcVvnSimrlJfiY73E9do/E0IxHmEsrR6nOU5AWsO66/ijfjeYvAq2c5TFToMWaAQ
         V4vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=tqSFf2c/aR0xKLJBDtSO/L4uHcT204aNH3nZsuo4w3I=;
        b=ceRAaoHgaeXZL7qn75jm5Svf0MO8n5iXBfIRrPgg176zxRzJmRk33WDjUvRiSH7YqP
         26FrHGGpBQ/u4OKr5fkc2/DG0ZQ2asZa5ZiDDWhQAjrUFIR67arl/8+FQzKQOwvmB2ev
         MFGPrUH+Vv0gmiQ2L+dg/V1/jm2UQddFGkltCPKaGmtTc7nNrTP9J6FG9Rq+o4lVumRJ
         TfkNlmueQuxkyepkdnMi5V+b0Tjkog2pp5aayatLD3qc5SESKevI1OJ8FLQIyy/1AcYZ
         9Ol0xU2dcY8dwj2L+PrMZaBuLRxq27IHm5WiuirdOTQfV37Rf6PGevLLFIdrCclrYTvL
         JQXA==
X-Gm-Message-State: ACgBeo1M0z17S+3R1K/q8TZpyIz7w5jhyN5+Km5AonslZ3xzDCMKVjJ1
        712T9eIPOVVFbov/mnRKDD1Rcw0N/PQ=
X-Google-Smtp-Source: AA6agR4NV6ilNxju28gGAtvFvCbwtdHUFc7GAdPfKwMLLiKqvqvTVqp9b9JTlBsJQYJm3qq2uA/+hIhhY2U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr26559pje.0.1661906112763; Tue, 30 Aug
 2022 17:35:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:34:49 +0000
In-Reply-To: <20220831003506.4117148-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831003506.4117148-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831003506.4117148-3-seanjc@google.com>
Subject: [PATCH 02/19] KVM: SVM: Don't put/load AVIC when setting virtual APIC mode
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index b1ade555e8d0..f3a74c8284cb 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -741,18 +741,6 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
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
@@ -1094,17 +1082,18 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 }
 
-
-void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
+void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
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
@@ -1118,6 +1107,16 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
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
+	avic_set_virtual_apic_mode(vcpu);
 
 	if (activated)
 		avic_vcpu_load(vcpu, vcpu->cpu);
-- 
2.37.2.672.g94769d06f0-goog

