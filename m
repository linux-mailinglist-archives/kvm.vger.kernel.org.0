Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9634D4C83B1
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 07:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbiCAGE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 01:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbiCAGEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 01:04:52 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C167C60CFB
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:09 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d6d36ec646so120355217b3.23
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=H7mi9apdEnxrzE+/TvNYFRdRST2jicY9ozMhi537JbY=;
        b=hI002BoVgiodXwx/65LBkcjZv1ADrdTRFD0xLhKH/uFgduG6Ah1QTZJ9ErBKQZxa/L
         FyT9dF2n58YJUnZ0WvPLIwxWSLmI/yNuMlEPvRxwBJws4eZ1ZO+LCC+t5CXYrw1hGCUZ
         RLicMCqS8yKJ4KklrkyC6+cwaT0rionteofH2cipj2xfL0CE+uSF9sTmneMKn7Xovkqu
         2U6NbpJWJWthhrz4G2BSpnsAM3DHezjXZEH7jy9Q4qp82wpJ3dDX0dHNZUxrYv5V7v9i
         cSVuZ+miCpeqpBTSLq6lphjG+H8W6WSUZXPxHVrx9emhLfcDXHBji9QxeYHe0j/X2edF
         HaWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=H7mi9apdEnxrzE+/TvNYFRdRST2jicY9ozMhi537JbY=;
        b=k0au36kodY201ats+eEwgfedw2LbQYGZDe1Ub8l9G2Gyn9CdjqFZQvMofOLpOdGvg+
         Ni+iWb9Gnb6DVaNo8mtN9VXgO6t95XDG9U4GabwzauvTUlb3wuoHlKHy5WjWG5wSVuIJ
         ev/EH+ZMq0+xyDd5sk177Q88u21Kbf8Ph77CgkpTahi8PxC+uEPu5JdHpwObHqyiomtq
         M31fpycnFA72xlxfB7Obmu8J29eS8yIyEn/ll7xsc89OFXIOPUVPH2YTauNL/PY95gtM
         fu6zXK9/+IfRyOrjsIhwZ87lqWooQOA/+Sm8wJi8ChtDgN+8j3jIPge5U5nm3A7g4OIL
         5QlA==
X-Gm-Message-State: AOAM531ltM2+XVTr3iRP5jFfjPCkooXDAeBlECaZxDYtXojHWaMsO3aA
        coeWCHymV8JZK6IeyCnJvZ6YT7yLkKYN83GQcfrrcv4gEMpSianVl5u5XQqGnLWSZBVJBGlA2TS
        fTI5JkW03Qnk2uQA8xNdsCQFVxbx/iUzUsNPJg60LHMW3LPBjwXmtqfAsEQ==
X-Google-Smtp-Source: ABdhPJwGj9YN7SV/EGBjvQBT2R9MW63u6mD5h/lVkWxZcAlfe8JkMTQhIKT2P+4mHi+Gn8dVMPIP0PlbplM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6902:534:b0:61d:a782:81b6 with SMTP id
 y20-20020a056902053400b0061da78281b6mr22155197ybs.253.1646114648862; Mon, 28
 Feb 2022 22:04:08 -0800 (PST)
Date:   Tue,  1 Mar 2022 06:03:47 +0000
In-Reply-To: <20220301060351.442881-1-oupton@google.com>
Message-Id: <20220301060351.442881-5-oupton@google.com>
Mime-Version: 1.0
References: <20220301060351.442881-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 4/8] KVM: x86: Introduce KVM_CAP_DISABLE_QUIRKS2
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

KVM_CAP_DISABLE_QUIRKS is irrevocably broken. The capability does not
advertise the set of quirks which may be disabled to userspace, so it is
impossible to predict the behavior of KVM. Worse yet,
KVM_CAP_DISABLE_QUIRKS will tolerate any value for cap->args[0], meaning
it fails to reject attempts to set invalid quirk bits.

The only valid workaround for the quirky quirks API is to add a new CAP.
Actually advertise the set of quirks that can be disabled to userspace
so it can predict KVM's behavior. Reject values for cap->args[0] that
contain invalid bits.

Finally, add documentation for the new capability and describe the
existing quirks.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst  | 50 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  7 +++++
 arch/x86/kvm/x86.c              |  8 ++++++
 include/uapi/linux/kvm.h        |  1 +
 4 files changed, 66 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f5d011351016..8f7240e79cc0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7079,6 +7079,56 @@ resource that is controlled with the H_SET_MODE hypercall.
 This capability allows a guest kernel to use a better-performance mode for
 handling interrupts and system calls.
 
+7.31 KVM_CAP_DISABLE_QUIRKS2
+----------------------------
+
+:Capability: KVM_CAP_DISABLE_QUIRKS2
+:Parameters: args[0] - set of KVM quirks to disable
+:Architectures: x86
+:Type: vm
+
+This capability, if enabled, will cause KVM to disable some behavior
+quirks.
+
+Calling KVM_CHECK_EXTENSION for this capability returns a bitmask of
+quirks that can be disabled in KVM.
+
+The argument to KVM_ENABLE_CAP for this capability is a bitmask of
+quirks to disable, and must be a subset of the bitmask returned by
+KVM_CHECK_EXTENSION.
+
+The valid bits in cap.args[0] are:
+
+=================================== ============================================
+ KVM_X86_QUIRK_LINT0_REENABLED      By default, the reset value for the LVT
+                                    LINT0 register is 0x700 (APIC_MODE_EXTINT).
+                                    When this quirk is disabled, the reset value
+                                    is 0x10000 (APIC_LVT_MASKED).
+
+ KVM_X86_QUIRK_CD_NW_CLEARED        By default, KVM clears CR0.CD and CR0.NW.
+                                    When this quirk is disabled, KVM does not
+                                    change the value of CR0.CD and CR0.NW.
+
+ KVM_X86_QUIRK_LAPIC_MMIO_HOLE      By default, the MMIO LAPIC interface is
+                                    available even when configured for x2APIC
+                                    mode. When this quirk is disabled, KVM
+                                    disables the MMIO LAPIC interface if the
+                                    LAPIC is in x2APIC mode.
+
+ KVM_X86_QUIRK_OUT_7E_INC_RIP       By default, KVM pre-increments %rip before
+                                    exiting to userspace for an OUT instruction
+                                    to port 0x7e. When this quirk is disabled,
+                                    KVM does not pre-increment %rip before
+                                    exiting to userspace.
+
+ KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT When this quirk is disabled, KVM sets
+                                    CPUID.01H:ECX[bit 3] (MONITOR/MWAIT) if
+                                    IA32_MISC_ENABLE[bit 18] (MWAIT) is set.
+                                    Additionally, when this quirk is disabled,
+                                    KVM clears CPUID.01H:ECX[bit 3] if
+                                    IA32_MISC_ENABLE[bit 18] is cleared.
+=================================== ============================================
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ccec837e520d..bc3405565967 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1963,4 +1963,11 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 #define KVM_CLOCK_VALID_FLAGS						\
 	(KVM_CLOCK_TSC_STABLE | KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC)
 
+#define KVM_X86_VALID_QUIRKS			\
+	(KVM_X86_QUIRK_LINT0_REENABLED |	\
+	 KVM_X86_QUIRK_CD_NW_CLEARED |		\
+	 KVM_X86_QUIRK_LAPIC_MMIO_HOLE |	\
+	 KVM_X86_QUIRK_OUT_7E_INC_RIP |		\
+	 KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c712c33c1521..ec9b602be8da 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4350,6 +4350,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
 		break;
 	}
+	case KVM_CAP_DISABLE_QUIRKS2:
+		r = KVM_X86_VALID_QUIRKS;
+		break;
 	default:
 		break;
 	}
@@ -5896,6 +5899,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		return -EINVAL;
 
 	switch (cap->cap) {
+	case KVM_CAP_DISABLE_QUIRKS2:
+		r = -EINVAL;
+		if (cap->args[0] & ~KVM_X86_VALID_QUIRKS)
+			break;
+		fallthrough;
 	case KVM_CAP_DISABLE_QUIRKS:
 		kvm->arch.disabled_quirks = cap->args[0];
 		r = 0;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d2f1efc3aa35..91a6fe4e02c0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1143,6 +1143,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_AIL_MODE_3 210
 #define KVM_CAP_S390_MEM_OP_EXTENSION 211
 #define KVM_CAP_PMU_CAPABILITY 212
+#define KVM_CAP_DISABLE_QUIRKS2 213
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.35.1.574.g5d30c73bfb-goog

