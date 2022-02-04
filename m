Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B464AA15D
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 21:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238376AbiBDUrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 15:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239447AbiBDUrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 15:47:16 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710F8C06173E
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 12:47:16 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id n20-20020a6bed14000000b0060faa0aefd3so4802796iog.20
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 12:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=q10VHDqouM37rkQYh0IkgU78Cyb+1oPxEBNHNGRfjiI=;
        b=L2A1PGzRbcIHMAFpP+fX1zTc7oSeyHkj12iiVi53T/B3NYVjyG8e87fjnoMru7ohY2
         Srev44iYY6Qi/uOwvUFwu+wDP3DTrkhaBHU+/dIdIFufoJ5x5LE8CKxVi6XgbAhQIZqn
         pPbyeayySefRylWA/hkdQHXDWaZACGJxUB5P+9wt6Sa1zgFBNBoHyQxjDV+qPV2saVKK
         WLzLzc8X5jPO8RnPTqXVZRHID2m9b/uFaHNycHinkSikUCeWIa7T7t1lFP9lGLWG1YFf
         +kcxufIzg/2Riq2gKoEAysbBZaQuUPlDMt5zxkTjRXtD29sHtvy6n/nbMXEwogtK2Kqi
         uckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=q10VHDqouM37rkQYh0IkgU78Cyb+1oPxEBNHNGRfjiI=;
        b=WzD0cnJnI/3cQ9yYUx6foal8A/D++AtzyVp/MHVyosfTZoljRRXWbPUFtZV58AHc2b
         fA/seN40do9rQKUOF2ob9j1p8t9r3gImEmKgIv0rvRs1OBwnsFbQZTqC7LOvgLdlzJkR
         DguJsMNJI+pyZzrwZMfK9vtSFMd42vzvgKIJZR5P72rN+v6D4lv1EkfQtLa+bYgzM2DL
         ppsgPPdwjowhvGy9iSILiYvQlFxxSuNG8OquCXY+Xc+lbSCAcZZdBg5hFeA3xS5ukjfc
         R0PtiXfySmv6WNW30yRUipVzng2du5jMbg1gLA4BgCL1cAKC37wFQ60gHsfetxDf/TGS
         rnmQ==
X-Gm-Message-State: AOAM532UVd0kPDvLyqF00LcuVkrQRC3yeiGTb27ioRoaoRtwlpzUkAAN
        teRX1UPd7ZybqGtcF510tFb3fCxdFD8oCa3aIr+J8HXhO79OLjSaxFGIRQimasXiu9DZxaBaSvQ
        QLs/oYLKsnZ8hfbAI9gXj5jT8F01cJUVpHafrmFrDHzEUjU+6n02idQQvCQ==
X-Google-Smtp-Source: ABdhPJw8/0UYmMtC4/WTYuUeyPluXrZz6iZ6IRmBiRvMgFdTcEOL/NS4Y1fFSa5jSqBKcYCWdtiNhqW0HQU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:dd0c:: with SMTP id f12mr385116ioc.203.1644007635787;
 Fri, 04 Feb 2022 12:47:15 -0800 (PST)
Date:   Fri,  4 Feb 2022 20:47:04 +0000
In-Reply-To: <20220204204705.3538240-1-oupton@google.com>
Message-Id: <20220204204705.3538240-7-oupton@google.com>
Mime-Version: 1.0
References: <20220204204705.3538240-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v2 6/7] selftests: KVM: Add test for BNDCFGS VMX control MSR bits
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

Test that the default behavior of KVM is to ignore userspace MSR writes
and conditionally expose the "{load,clear} IA32_BNDCFGS" bits in the VMX
control MSRs if the guest CPUID exposes MPX. Additionally, test that
when the corresponding quirk is disabled, userspace can still clear
these bits regardless of what is exposed in CPUID.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/include/x86_64/vmx.h        |  2 +
 .../kvm/x86_64/vmx_control_msrs_test.c        | 53 +++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 583ceb0d1457..811c66d9be74 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -80,6 +80,7 @@
 #define VM_EXIT_SAVE_IA32_EFER			0x00100000
 #define VM_EXIT_LOAD_IA32_EFER			0x00200000
 #define VM_EXIT_SAVE_VMX_PREEMPTION_TIMER	0x00400000
+#define VM_EXIT_CLEAR_BNDCFGS			0x00800000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -90,6 +91,7 @@
 #define VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL	0x00002000
 #define VM_ENTRY_LOAD_IA32_PAT			0x00004000
 #define VM_ENTRY_LOAD_IA32_EFER			0x00008000
+#define VM_ENTRY_LOAD_BNDCFGS			0x00010000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c
index ac5fdeb50eee..21e1dee0f83f 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c
@@ -96,6 +96,58 @@ static void load_perf_global_ctrl_test(struct kvm_vm *vm)
 			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,
 			     0,
 			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);
+
+	/* cleanup, enable the quirk again */
+	cap.args[0] = 0;
+	vm_enable_cap(vm, &cap);
+}
+
+static void bndcfgs_test(struct kvm_vm *vm)
+{
+	uint32_t entry_low, entry_high, exit_low, exit_high;
+	struct kvm_enable_cap cap = {0};
+
+	get_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, &entry_low, &entry_high);
+	get_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, &exit_low, &exit_high);
+
+	if (!(entry_high & VM_ENTRY_LOAD_BNDCFGS) ||
+	    !(exit_high & VM_EXIT_CLEAR_BNDCFGS)) {
+		print_skip("\"load/clear IA32_BNDCFGS\" VM-{Entry,Exit} controls not supported");
+		return;
+	}
+
+	/*
+	 * Test that KVM will set these bits regardless of userspace if the
+	 * guest CPUID exposes MPX.
+	 */
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, 0,
+			     VM_ENTRY_LOAD_BNDCFGS,
+			     VM_ENTRY_LOAD_BNDCFGS,
+			     0);
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, 0,
+			     VM_EXIT_CLEAR_BNDCFGS,
+			     VM_EXIT_CLEAR_BNDCFGS,
+			     0);
+
+	/*
+	 * Disable the quirk, giving userspace control of the VMX capability
+	 * MSRs.
+	 */
+	cap.cap = KVM_CAP_DISABLE_QUIRKS;
+	cap.args[0] = KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS;
+	vm_enable_cap(vm, &cap);
+
+	/*
+	 * Test that userspace can clear these bits, even if it exposes MPX.
+	 */
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, 0,
+			     VM_ENTRY_LOAD_BNDCFGS,
+			     0,
+			     VM_ENTRY_LOAD_BNDCFGS);
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, 0,
+			     VM_EXIT_CLEAR_BNDCFGS,
+			     0,
+			     VM_EXIT_CLEAR_BNDCFGS);
 }
 
 int main(void)
@@ -108,6 +160,7 @@ int main(void)
 	vm = vm_create_default(VCPU_ID, 0, NULL);
 
 	load_perf_global_ctrl_test(vm);
+	bndcfgs_test(vm);
 
 	kvm_vm_free(vm);
 }
-- 
2.35.0.263.gb82422642f-goog

