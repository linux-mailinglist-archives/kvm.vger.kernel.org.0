Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB07570DB7
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 00:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbiGKW6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 18:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiGKW6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 18:58:02 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B498050F
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 15:58:00 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 9-20020a631449000000b00412b1418c79so2425026pgu.2
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 15:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vtCvhz893+l2DWHLQu1OOqi/FdKA/QNbUD0v46ALnfE=;
        b=klVuCwNlrpf9V9c3vB1qT50TGfuZTGPAtq4m68XaeLg3IZRG1PeP05vQCRwcDWd8k0
         oiKwoClwp/LYykqPJby874JrhDURNL/SLKe2e4Tmdpz9l8NCctHyAGsopeBAPXzmlpJV
         Yk9hOKRKB122qQYW7FtQuGEOp61UHpg/fDipuZaYs0kBFSHsZMHHxeoghHAVRWp+I8UO
         tvck6KsYGtUe6hJ4ymqc3KFX0VsadD9H1LHKaqcRO0YYIEzcpSn9Z8hzbSa0dvoR6lPP
         WCJPyWegj9a5nSlUR2eMRWKWVVXHUF9R8GxwBIusLgDmFrt7Y+CgRdxvTsPVg4siGpkW
         B2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vtCvhz893+l2DWHLQu1OOqi/FdKA/QNbUD0v46ALnfE=;
        b=f9NNcDHzd+vdCxIu1VjkHvw+WQX2rLln6j2SJ8K9Kaq4xkvq7Jst8M5T84pTrglay/
         INmS/HJcWyxPWxG0Qi2dq7xSRIH3drm77fWSqGsmLvjM8SAms0jQrwjFJBIYl6j9TgCm
         kwXF4JMkmxrcCAUCpMoTUYdfWcoiBXv2R/q2HTRAdllTR+s6bIGeU2D/6nxuWU4kYhVO
         q40fmg2BFVw1htusHxudpliB0PT6NLimZvFqfB+oiz+Wh0CHjzgqCu4pATLbI+w5Vxfh
         yR7OxBaUqWgD2nxB4hZjA4QQ7RroA9ZXT0k6PNBT1nZz9uTPwPkYPTgAuidAaeSy/nr1
         3CKg==
X-Gm-Message-State: AJIora95d4X6P+J4gKwfRpk2621P+7MznYlQc0P2Uhldp80tBNjzEsNR
        oVl5q0GiU//XiGyJd6d5K/63Zb2/j54=
X-Google-Smtp-Source: AGRyM1vDQaY0dyCTNKdJTiZymYGnRQuB82JO2Ok2a3O4Wq18Bvvr73KLAnQUhOEviebiOkSIeVBvjBNh0ZM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ebd2:b0:16c:2607:acbe with SMTP id
 p18-20020a170902ebd200b0016c2607acbemr20255535plg.14.1657580280272; Mon, 11
 Jul 2022 15:58:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 11 Jul 2022 22:57:53 +0000
In-Reply-To: <20220711225753.1073989-1-seanjc@google.com>
Message-Id: <20220711225753.1073989-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220711225753.1073989-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH 3/3] KVM: x86: Tweak name of MONITOR/MWAIT #UD quirk to make
 it #UD specific
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a "UD" clause to KVM_X86_QUIRK_MWAIT_NEVER_FAULTS to make it clear
that the quirk only controls the #UD behavior of MONITOR/MWAIT.  KVM
doesn't currently enforce fault checks when MONITOR/MWAIT are supported,
but that could change in the future.  SVM also has a virtualization hole
in that it checks all faults before intercepts, and so "never faults" is
already a lie when running on SVM.

Fixes: bfbcc81bb82c ("KVM: x86: Add a quirk for KVM's "MONITOR/MWAIT are NOPs!" behavior")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst                          | 2 +-
 arch/x86/include/asm/kvm_host.h                         | 2 +-
 arch/x86/include/uapi/asm/kvm.h                         | 2 +-
 arch/x86/kvm/x86.c                                      | 2 +-
 tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bafaeedd455c..cd9361f22530 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7523,7 +7523,7 @@ The valid bits in cap.args[0] are:
                                     incorrect hypercall instruction will
                                     generate a #UD within the guest.
 
-KVM_X86_QUIRK_MWAIT_NEVER_FAULTS    By default, KVM emulates MONITOR/MWAIT (if
+KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS By default, KVM emulates MONITOR/MWAIT (if
                                     they are intercepted) as NOPs regardless of
                                     whether or not MONITOR/MWAIT are supported
                                     according to guest CPUID.  When this quirk
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index de5a149d0971..b9e85049743f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2097,6 +2097,6 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 	 KVM_X86_QUIRK_OUT_7E_INC_RIP |		\
 	 KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT |	\
 	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN |	\
-	 KVM_X86_QUIRK_MWAIT_NEVER_FAULTS)
+	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS)
 
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index ee3896416c68..a0c0ab0c898e 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -439,7 +439,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_OUT_7E_INC_RIP		(1 << 3)
 #define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT	(1 << 4)
 #define KVM_X86_QUIRK_FIX_HYPERCALL_INSN	(1 << 5)
-#define KVM_X86_QUIRK_MWAIT_NEVER_FAULTS	(1 << 6)
+#define KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS	(1 << 6)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 567d13405445..8065998c5bb6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2046,7 +2046,7 @@ EXPORT_SYMBOL_GPL(kvm_handle_invalid_op);
 
 static int kvm_emulate_monitor_mwait(struct kvm_vcpu *vcpu, const char *insn)
 {
-	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MWAIT_NEVER_FAULTS) &&
+	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS) &&
 	    !guest_cpuid_has(vcpu, X86_FEATURE_MWAIT))
 		return kvm_handle_invalid_op(vcpu);
 
diff --git a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
index 6a4ebcdfa374..094c68d744c0 100644
--- a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
+++ b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
@@ -113,7 +113,7 @@ int main(int argc, char *argv[])
 
 		disabled_quirks = 0;
 		if (testcase & MWAIT_QUIRK_DISABLED)
-			disabled_quirks |= KVM_X86_QUIRK_MWAIT_NEVER_FAULTS;
+			disabled_quirks |= KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS;
 		if (testcase & MISC_ENABLES_QUIRK_DISABLED)
 			disabled_quirks |= KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT;
 		vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, disabled_quirks);
-- 
2.37.0.144.g8ac04bfd2-goog

