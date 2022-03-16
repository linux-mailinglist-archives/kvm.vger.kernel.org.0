Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627DE4DA723
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 01:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352879AbiCPA5B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 20:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352875AbiCPA5A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 20:57:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84525DE5F
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 17:55:47 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id l16-20020a25bf90000000b00628c3a412cdso764391ybk.10
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 17:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=odxwcNT6QFPw+yc9K3jXY6zXbyWGuQWl0E9RxekFmAA=;
        b=QBd/98QI7YR1Wcry1SkD4HErXuzfgLrTpJm7g7kzNqH9gdPyFhw72EvEDcDhM9bBr4
         RS4xa3pjVeOz7hfVBlMvdeJUIJXAbCnmmOPwglmNNh1zVU6yk91panMdYkv96GPuBCIZ
         rkK1KDi8pLvqixRAfJnxn1A1rq83Az9dCVga+XlTtxvdoY04hfvp6YMoe5hYZ+X89Vng
         Dra8NNKnDyqQ4dtcmfvoUF8mcLEXeYSHqlRI4Rwzfbi0PIfcdDTTlFdJFVyGamIDTl8y
         Uf3RZ1+MFjd3R+TAtBfGTmE/sxpVFGWxCQ7HEnVi5PBL+O6DIdVdu/CdLk9pxTZ4jK0Q
         jlBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=odxwcNT6QFPw+yc9K3jXY6zXbyWGuQWl0E9RxekFmAA=;
        b=YVhwMfc8ePIM9Fokr5Ou8TGZGlGat+KmkQEVsABVNLKOPL34kGAA1OmZ6VrxRuslOy
         auu8zqq6IL5cK9OVl9ve7TreIm9x0jHn2dh7kgEQboRykCZZTQ0qavuigv/Zs6ukrjm/
         km3dZRqsUTAzvoGoQ9hvSbNDDNPm6IcrBSC5mytKChHggx3H+c7CBALmvi+cuyH6G5wf
         CaKTeiRuY3ibUGXtPUlGaKMNaQ7B5mD8DRmWvZJUBL3i3s7nguezb8QMnaWFunDzoq5L
         FilsNizRrKQ3kRMFJqKAwcOAKhuXXIEsptd56UexDZxEZFweCfXd2Fhogi/Q5s7LVob5
         U8ZQ==
X-Gm-Message-State: AOAM530Ahel+xUUk5Hj5WyI9wEpoMG/h4eJbKLaO8PM8CVdnSnhD6sph
        DEapMZV+4e7vd8ystvrFvhxAMc4PxuM4GdFSoXtXRGZwChrgtMKf6Xsqjv9yHj3Hofvh8b7KGtd
        D2ddxCBa3MSbnqOO6HffCXuDO2UloOV2xQ0zS4Lz0xYDX4GAuisCenkAlSg==
X-Google-Smtp-Source: ABdhPJyOEhgzuOB4MjHgkvDK8IInav+cAxX4mMfgp81m1XJGUCw/bxX+UU6H5GHruJvmlHzeqFoKwZvMJV4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:c385:0:b0:614:d2fd:c9bc with SMTP id
 t127-20020a25c385000000b00614d2fdc9bcmr26841151ybf.270.1647392146944; Tue, 15
 Mar 2022 17:55:46 -0700 (PDT)
Date:   Wed, 16 Mar 2022 00:55:37 +0000
In-Reply-To: <20220316005538.2282772-1-oupton@google.com>
Message-Id: <20220316005538.2282772-2-oupton@google.com>
Mime-Version: 1.0
References: <20220316005538.2282772-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 1/2] KVM: x86: Allow userspace to opt out of hypercall patching
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Peter Shier <pshier@google.com>,
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

KVM handles the VMCALL/VMMCALL instructions very strangely. Even though
both of these instructions really should #UD when executed on the wrong
vendor's hardware (i.e. VMCALL on SVM, VMMCALL on VMX), KVM replaces the
guest's instruction with the appropriate instruction for the vendor.
Nonetheless, older guest kernels without commit c1118b3602c2 ("x86: kvm:
use alternatives for VMCALL vs. VMMCALL if kernel text is read-only")
do not patch in the appropriate instruction using alternatives, likely
motivating KVM's intervention.

Add a quirk allowing userspace to opt out of hypercall patching. If the
quirk is disabled, KVM synthesizes a #UD in the guest.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst  |  9 +++++++++
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/include/uapi/asm/kvm.h | 11 ++++++-----
 arch/x86/kvm/x86.c              | 11 +++++++++++
 4 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 507be67746b0..862314e156ae 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7233,6 +7233,15 @@ The valid bits in cap.args[0] are:
                                     Additionally, when this quirk is disabled,
                                     KVM clears CPUID.01H:ECX[bit 3] if
                                     IA32_MISC_ENABLE[bit 18] is cleared.
+
+ KVM_X86_QUIRK_FIX_HYPERCALL_INSN   By default, KVM rewrites guest
+                                    VMMCALL/VMCALL instructions to match the
+                                    vendor's hypercall instruction for the
+                                    system. When this quirk is disabled, KVM
+                                    will no longer rewrite invalid guest
+                                    hypercall instructions. Executing the
+                                    incorrect hypercall instruction will
+                                    generate a #UD within the guest.
 =================================== ============================================
 
 8. Other capabilities.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9694dd5e6ccc..832e9af24a85 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1996,6 +1996,7 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 	 KVM_X86_QUIRK_CD_NW_CLEARED |		\
 	 KVM_X86_QUIRK_LAPIC_MMIO_HOLE |	\
 	 KVM_X86_QUIRK_OUT_7E_INC_RIP |		\
-	 KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)
+	 KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT |	\
+	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN)
 
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index bf6e96011dfe..21614807a2cb 100644
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
+#define KVM_X86_QUIRK_FIX_HYPERCALL_INSN	(1 << 5)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d3a9ce07a565..685c4bc453b4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9291,6 +9291,17 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 	char instruction[3];
 	unsigned long rip = kvm_rip_read(vcpu);
 
+	/*
+	 * If the quirk is disabled, synthesize a #UD and let the guest pick up
+	 * the pieces.
+	 */
+	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_FIX_HYPERCALL_INSN)) {
+		ctxt->exception.error_code_valid = false;
+		ctxt->exception.vector = UD_VECTOR;
+		ctxt->have_exception = true;
+		return X86EMUL_PROPAGATE_FAULT;
+	}
+
 	static_call(kvm_x86_patch_hypercall)(vcpu, instruction);
 
 	return emulator_write_emulated(ctxt, rip, instruction, 3,
-- 
2.35.1.723.g4982287a31-goog

