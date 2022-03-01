Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5792E4C83B4
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 07:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbiCAGE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 01:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbiCAGEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 01:04:52 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8FB60D87
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:10 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id g16-20020a05660226d000b00638d8e1828bso10018875ioo.13
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WmlQrPuUshRXR/ErY9Gh4Cre7PwL7ex7k3lY6rX2RPo=;
        b=qlaakjGDY1eQ1DwD8fqCv0wKsYf1fODdSr4UFxI7sB5iVaIzgwIx3MfWI51OCyz76z
         a3fN9qknJmxC+PGGIc1HBK3jPKtSO4pmHp2LAU37v23AddyZOZj4cSmwz0eD+stlEydd
         0LIxQCvvBWo0MWcs1DNkroxP/qC/AYc1mu4n3d2l1/516pgFlVNA+fCcSeJYQOlBZvQb
         4Fz/4L+clLo0jWjjMN/48o3y2Dm8/dhjAIfE5+jPlPNzfUwtWzQ2GLNymFYITJkW0Ucn
         7wBOs6Ztccw7o0DwSUHfTj88oI3WGvdnyY7KiTtk8L1bCPgT1SxkaiSYvcg+K5MZyPJ/
         VMpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WmlQrPuUshRXR/ErY9Gh4Cre7PwL7ex7k3lY6rX2RPo=;
        b=qFirXohF+pSmv40/XwCCSoXHrI8kPrO7tCPHQJZrJuTxyf8AxRXU/PYaYR3WRVjMZp
         z7hTzxeofzqFJFJlj4JHqEVDc6DDvM/fVBSoHHYWjf0KJ12VVrBKZrl3+7IjuG9jhrz6
         ZBIRt+pTeI8x74Xd3C2czoO4ScvjuMJhigLvHidyxSviRAArgW9g9zpK7I2Sm8SyDUxU
         03ogJGUqgF7d7/c9VELSuqWn8YjXquJp0QiEbuZoaCozvJys9mgZqLSDNnfQ3as/k7B9
         F6P7yIVcDIu3IgoCJfcJZQgSNsZYDgBtNxRGu19pn1S7tHZOsKtjhqRDuT7/PxL9gYaJ
         LUCg==
X-Gm-Message-State: AOAM530WDrjeNkg50e2yvrRnGTHWd8JnoH371z9sQuXxqDALK3Vwmymz
        4/GjZB531lx1zlu0UMrtqFwIQGplN04gExLbzXJdF81FANuvke0nK9LoVCw+P/Q0hW1UBjP1hnN
        eSZf7oTQjMIyxGNfBZzeBVwybSeGgIp/qdK3LWM6AYWet20VoHEAE6lS+TA==
X-Google-Smtp-Source: ABdhPJxWKF155htloiIQjrJG0ZroOywjHl0mTG3YWJLZpyvP9t8ajeZEwVYfx4gB7jKaReodZMR+MzfC4DM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:1594:b0:640:7236:e6ea with SMTP id
 e20-20020a056602159400b006407236e6eamr17788421iow.23.1646114650037; Mon, 28
 Feb 2022 22:04:10 -0800 (PST)
Date:   Tue,  1 Mar 2022 06:03:48 +0000
In-Reply-To: <20220301060351.442881-1-oupton@google.com>
Message-Id: <20220301060351.442881-6-oupton@google.com>
Mime-Version: 1.0
References: <20220301060351.442881-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 5/8] KVM: nVMX: Add a quirk for KVM tweaks to VMX control MSRs
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
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
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
 Documentation/virt/kvm/api.rst  | 24 ++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/include/uapi/asm/kvm.h | 11 ++++++-----
 arch/x86/kvm/vmx/vmx.c          |  3 +++
 4 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8f7240e79cc0..9bb79ca9de89 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7127,6 +7127,30 @@ The valid bits in cap.args[0] are:
                                     Additionally, when this quirk is disabled,
                                     KVM clears CPUID.01H:ECX[bit 3] if
                                     IA32_MISC_ENABLE[bit 18] is cleared.
+
+ KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS  By default, KVM adjusts the values of
+                                    IA32_VMX_TRUE_ENTRY_CTLS and
+                                    IA32_VMX_TRUE_EXIT_CTLS MSRs under the
+                                    following conditions:
+
+                                    - If CPUID.07H:EBX[bit 14] (MPX) is set, KVM
+                                      sets IA32_VMX_TRUE_ENTRY_CTLS[bit 48]
+                                      ('load IA32_BNDCFGS') and
+                                      IA32_VMX_TRUE_EXIT_CTLS[bit 55]
+                                      ('clear IA32_BNDCFGS'). Otherwise, these
+                                      corresponding MSR bits are cleared.
+                                    - If CPUID.0AH:EAX[bits 7:0] > 1, KVM sets
+                                      IA32_VMX_TRUE_ENTRY_CTLS[bit 45]
+                                      ('load IA32_PERF_GLOBAL_CTRL') and
+                                      IA32_VMX_TRUE_EXIT_CTLS[bit 44]
+                                      ('load IA32_PERF_GLOBAL_CTRL'). Otherwise,
+                                      these corresponding MSR bits are cleared.
+
+                                    When this quirk is disabled, KVM will not
+                                    change the values of
+                                    IA32_VMX_TRUE_ENTRY_CTLS or
+                                    IA32_VMX_TRUE_EXIT_CTLS based on the
+                                    aforementioned CPUID bits.
 =================================== ============================================
 
 8. Other capabilities.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bc3405565967..1b905e6c4760 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1968,6 +1968,7 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 	 KVM_X86_QUIRK_CD_NW_CLEARED |		\
 	 KVM_X86_QUIRK_LAPIC_MMIO_HOLE |	\
 	 KVM_X86_QUIRK_OUT_7E_INC_RIP |		\
-	 KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)
+	 KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT |	\
+	 KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS)
 
 #endif /* _ASM_X86_KVM_HOST_H */
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
index 224ef4c19a5d..21b98bad1319 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7250,6 +7250,9 @@ void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS))
+		return;
+
 	if (kvm_mpx_supported()) {
 		bool mpx_enabled = guest_cpuid_has(vcpu, X86_FEATURE_MPX);
 
-- 
2.35.1.574.g5d30c73bfb-goog

