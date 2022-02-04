Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAD84AA15A
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 21:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238929AbiBDUrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 15:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238376AbiBDUrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 15:47:15 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884CCC061714
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 12:47:14 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 2-20020a251302000000b006118f867dadso15337010ybt.12
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 12:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wNEW0r3i/yh83WCbI4vGD4iW/NFLvLf/uskgDDYubyU=;
        b=lgiQcgh1u5e3NMCAjj06zrynEs5CTxVHFTw0NCCQvGgSZ9OVdxp8IAQoIIMjqYS8qE
         fyZRkR4vCH09+PiErMKnXoyBU6zN3ScDmMsuJcM0ZyOyp+Kstwh9YpueargozAgbjJpG
         xZHHfQw7Wr5bWLmg1BOnkge6i5yYYIrnTlMuX4ct90IRqgtLLUqseHFEDiOBJYCRpIag
         Kf9Ku09vF7bY9AmEJH0vOtxswhrEVKQM7GoqPRBag4MGQ12G+IsYoSucvGiK+40HaMNh
         1hOYKRgwyAPeBaSinGL+fGCz1mS2SctUbs3LLQwJxEmgTPBedoqvmSfhCKDz33McdmxF
         OelQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wNEW0r3i/yh83WCbI4vGD4iW/NFLvLf/uskgDDYubyU=;
        b=XHlbiP9jT14rfEpzlSOwkmSEsfRZkoPg2/K+nUPryR1ojFgYPtCHvD4xDbsie4g4fu
         jMA+/DGxVto/5uImCrxBwod/tK7Q6BEkMQfy1fK7P7AFvDXzAyHxfVHmtr8LdVqWpgOx
         BZCv3g/pvzzNH8PJ2MO5iAcjH7Lrg1+6ob8lqUAyBKk+nN6pg+lwt28OGUEpoOPWU616
         vgHDInhI2ChT7b9QBB6k2z1vSoYwlaIcnhwfAAlVGQ17hP7VvTImFHcJ5hKW3mtOLwjA
         PHUJEP2ILadQjFbZwZVFCqJwZR95ViKD8PqWx4KaxHgol7YUCD5PpFGGyGBg/B+b9LxW
         MhuA==
X-Gm-Message-State: AOAM5304hDaS9JbEUTZesFf2eYArnFANN8ESyWKqCaZfHE1NR6vS2j1P
        OQuGbg50vRHqjBvJll9KDMbxv3PcmqOdjNkGAqUSIuksKH6YryFuXNU+DPyHZvnVFRTJn+8GiJu
        4gZ1odFwOnjGuhPxac8XgAum4Lt45jqHKUZn9LYuydkMqt5JG6Tnzu7W7hQ==
X-Google-Smtp-Source: ABdhPJy6vD0hnzI7gYy8ASHpyxgqi8zQXXCmGl6zTD9fo3y9iT6maUpZwKD2KrEi7loIPIKBit/8lC5cGuw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5b:486:: with SMTP id n6mr999671ybp.547.1644007633725;
 Fri, 04 Feb 2022 12:47:13 -0800 (PST)
Date:   Fri,  4 Feb 2022 20:47:02 +0000
In-Reply-To: <20220204204705.3538240-1-oupton@google.com>
Message-Id: <20220204204705.3538240-5-oupton@google.com>
Mime-Version: 1.0
References: <20220204204705.3538240-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v2 4/7] KVM: nVMX: Add a quirk for KVM tweaks to VMX control MSRs
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM really has no business messing with the vCPU state. Nonetheless, it
has become ABI for KVM to adjust certain bits of the VMX entry/exit
control MSRs depending on the guest CPUID. Namely, the bits associated
with the IA32_PERF_GLOBAL_CTRL and IA32_BNDCFGS MSRs were conditionally
enabled if the guest CPUID allows for it.

Allow userspace to opt-out of changes to VMX control MSRs by adding a
new KVM quirk.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/include/uapi/asm/kvm.h | 11 ++++++-----
 arch/x86/kvm/vmx/vmx.c          |  3 +++
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index bf6e96011dfe..acbab6a97fae 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -428,11 +428,12 @@ struct kvm_sync_regs {
 	struct kvm_vcpu_events events;
 };
 
-#define KVM_X86_QUIRK_LINT0_REENABLED	   (1 << 0)
-#define KVM_X86_QUIRK_CD_NW_CLEARED	   (1 << 1)
-#define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	   (1 << 2)
-#define KVM_X86_QUIRK_OUT_7E_INC_RIP	   (1 << 3)
-#define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT (1 << 4)
+#define KVM_X86_QUIRK_LINT0_REENABLED		(1 << 0)
+#define KVM_X86_QUIRK_CD_NW_CLEARED		(1 << 1)
+#define KVM_X86_QUIRK_LAPIC_MMIO_HOLE		(1 << 2)
+#define KVM_X86_QUIRK_OUT_7E_INC_RIP		(1 << 3)
+#define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT	(1 << 4)
+#define KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS	(1 << 5)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 395787b7e7ac..60b1b76782e1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7231,6 +7231,9 @@ void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS))
+		return;
+
 	if (kvm_mpx_supported()) {
 		bool mpx_enabled = guest_cpuid_has(vcpu, X86_FEATURE_MPX);
 
-- 
2.35.0.263.gb82422642f-goog

