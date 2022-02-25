Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6164C4F4B
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 21:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbiBYUJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 15:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235855AbiBYUJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 15:09:10 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B041F082D
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:08:37 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id x16-20020a6bfe10000000b006409f03e39eso4506222ioh.7
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2FhdPG8SrYidEnmQD4gAlAl2q1sa7hOe/tXOOTUJkcQ=;
        b=LBRj7Po1ICNiFJyRUn+8q5qkr3AK7KE6iznbuUR9IeVurWUvmxRjDwHqedtoNF9dFM
         7V/3+SAVwJBPIYIcE5vdUwyNFshTGnGtvwXr1eAV5DmiIndw7mXnj6+q/qrjYX19cF2S
         3ozvj2RKr54QQUYGUfOfnU0lKzTqrWDYolrgOeRVQHWbUbDolc5GvfejIR4Mc+CG3WmR
         8qMTMDiNWKhL6+jZVvIMkMgClyQicmimXijWCkqlXuLkoOq/UDfJ6zZZSAf4EfLD0ixR
         MxSyvuj23trF1FnqHeILoC3AB54uOnJ8ee80HUQm1kUT3ak63XxobjKljqFbQRQeqGZ4
         ZRaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2FhdPG8SrYidEnmQD4gAlAl2q1sa7hOe/tXOOTUJkcQ=;
        b=AhwT7eHkWdQiZzUFS1GvDl3o1wZjW0LkRmJ3bflsybbpbfJPp7gKaxPT5U8NJkeVfW
         5FSRKRt4hIYsSgrY+JLvFTtAitIz7mrzZqNyGZzPsgx/ioQtEPxvxc2//wT1VTd2j2QP
         NsW7ECtFoIqU9iwgt5UwlSdzz+TFqasCi/oIvhVzHctEP63tu1SdPmiuxMOL3AWLYG31
         DICHN9hM214lxxdmN4d8lLc99HCHM2EVq/ygYUocFPmoAl1DpeAPPHn/c04UKvKz9MMf
         L9sMTZzcRequlj4gIC1lucu7mxpC7pR0pQm9MCSfVEdrSVYL3okCEiDfmyOAEB6xNb0g
         ohAw==
X-Gm-Message-State: AOAM533CEy5t8QeVkONelnflFZqcICMpET5ICKK7YsMmzMhSf2UdAe+I
        MfpPxNZGAgUvgWekLA0q36krZEb9Mp4NyFNzOWsINGj6a2Y1QrJtWDTBIAGgGgng+0RvRIAN2xb
        Yqeh+uB9eIQO4SsIWcgxrvEs4JWaUdHIx5bc3XibVDBTdJjJd1XBV34zWqQ==
X-Google-Smtp-Source: ABdhPJxjhN0iRjZ6XggJ6eByqcH+1NGx6/bFt4hzhLNwjXhXYSVubftcTwVqiKX7iobHqwwuyBRZ7H838cA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:c24a:0:b0:2c2:8100:11ec with SMTP id
 k10-20020a92c24a000000b002c2810011ecmr7528133ilo.69.1645819716951; Fri, 25
 Feb 2022 12:08:36 -0800 (PST)
Date:   Fri, 25 Feb 2022 20:08:20 +0000
In-Reply-To: <20220225200823.2522321-1-oupton@google.com>
Message-Id: <20220225200823.2522321-4-oupton@google.com>
Mime-Version: 1.0
References: <20220225200823.2522321-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 3/6] KVM: nVMX: Add a quirk for KVM tweaks to VMX control MSRs
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Oliver Upton <oupton@google.com>
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
 arch/x86/kvm/vmx/nested.c       |  3 +++
 arch/x86/kvm/vmx/vmx.c          |  3 +++
 3 files changed, 12 insertions(+), 5 deletions(-)

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
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 59164394569f..3b22b1072eff 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4813,6 +4813,9 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 	if (!nested_vmx_allowed(vcpu))
 		return;
 
+	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS))
+		return;
+
 	vmx = to_vmx(vcpu);
 	if (kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
 		vmx->nested.msrs.entry_ctls_high |=
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 77d74cbc2709..050820d931fe 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7246,6 +7246,9 @@ void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS))
+		return;
+
 	if (kvm_mpx_supported()) {
 		bool mpx_enabled = guest_cpuid_has(vcpu, X86_FEATURE_MPX);
 
-- 
2.35.1.574.g5d30c73bfb-goog

