Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420A3767A8F
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237187AbjG2BQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237131AbjG2BQP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:16:15 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC881739
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:14 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-563fc38db94so1625470a12.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690593374; x=1691198174;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OXHhc2U25Tn9jZSaAqLCulQOLba1UW3VXuih6bIvn0s=;
        b=Tod3zMqUpSYaMSjMntQET7ADtNMiYMgbBq1at6tAEQOFQg+AzH1AB/EPsntvDm5vNj
         EIG9W/6ReBz3I+JF0tX8SPTOlSXnEzx9ES1GjZQ1n/MoCOi0fTE2yochXFZoYOjwC6mc
         U3t5LNtMvj5DqqX4aJ80m3rhTwam3UPQTo2VgxfpkXQkLR7j/mmDbfm7nz5BPfC0DIRw
         ipi5tkLT3PhkVV1UrAy//YPPYzAiTfYSNf2NW4oExuekrUxEKRzNGrgzOAYZyTstIeTY
         SHF0J2p3TR7x0+vKZfwMp/3jlFMAB27g/khgrIS61KbP9aelsIKxNogzIgGACNWWhEod
         n7PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690593374; x=1691198174;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OXHhc2U25Tn9jZSaAqLCulQOLba1UW3VXuih6bIvn0s=;
        b=IBxZdvUfqENjDn2+/gpxWw9iWWNW8OMxl/HPCLYGbKytvl2oEpV2NGDtNJdT6apMtE
         cS6Gs8vapvtUafCE15rFAl0tUEuUvCLEw13bSP7uHWvuq4nB+P2xJ5zBxqlFQoZd3+/b
         M7qVN5EUcKMtfjsiSXk5StM0FTzjL2z+yEwre1PAzOSh6CCh4Jh4r5L8ObrZZApn5GMY
         3VkE0XtlXQj61Ebup02cE/3243JR6bS62JdjRnXL3tgTBmxBqBpu9fSd5Sa9gtmOD/nt
         vo1S8x9VHCwgsvfLtXQ//sSJXI2u6Pg/1ZsSJYGIIcKUlq7zamxBS69G4NrPejfMKiDa
         DFgw==
X-Gm-Message-State: ABy/qLZdnoECNqJgmsJ+/l97BQ7iV44UGHOgfYOdZW2X6nwLnNZ9uGEE
        c9oK68OLLXwGUuPpxizlr+aaSpg/xq4=
X-Google-Smtp-Source: APBJJlH7vCkGKQZKjpj0ik6iY2LhHM7ilq1KS/soeEeTq5p/PnpLaOaPR70bJynHLI3xqkpO2y/gKTOUAlI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e74b:b0:1b8:a56e:1dcc with SMTP id
 p11-20020a170902e74b00b001b8a56e1dccmr11826plf.13.1690593374418; Fri, 28 Jul
 2023 18:16:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:15:48 -0700
In-Reply-To: <20230729011608.1065019-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729011608.1065019-2-seanjc@google.com>
Subject: [PATCH v2 01/21] KVM: nSVM: Check instead of asserting on nested TSC
 scaling support
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
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

Check for nested TSC scaling support on nested SVM VMRUN instead of
asserting that TSC scaling is exposed to L1 if L1's MSR_AMD64_TSC_RATIO
has diverged from KVM's default.  Userspace can trigger the WARN at will
by writing the MSR and then updating guest CPUID to hide the feature
(modifying guest CPUID is allowed anytime before KVM_RUN).  E.g. hacking
KVM's state_test selftest to do

		vcpu_set_msr(vcpu, MSR_AMD64_TSC_RATIO, 0);
		vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_TSCRATEMSR);

after restoring state in a new VM+vCPU yields an endless supply of:

  ------------[ cut here ]------------
  WARNING: CPU: 164 PID: 62565 at arch/x86/kvm/svm/nested.c:699
           nested_vmcb02_prepare_control+0x3d6/0x3f0 [kvm_amd]
  Call Trace:
   <TASK>
   enter_svm_guest_mode+0x114/0x560 [kvm_amd]
   nested_svm_vmrun+0x260/0x330 [kvm_amd]
   vmrun_interception+0x29/0x30 [kvm_amd]
   svm_invoke_exit_handler+0x35/0x100 [kvm_amd]
   svm_handle_exit+0xe7/0x180 [kvm_amd]
   kvm_arch_vcpu_ioctl_run+0x1eab/0x2570 [kvm]
   kvm_vcpu_ioctl+0x4c9/0x5b0 [kvm]
   __se_sys_ioctl+0x7a/0xc0
   __x64_sys_ioctl+0x21/0x30
   do_syscall_64+0x41/0x90
   entry_SYSCALL_64_after_hwframe+0x63/0xcd
  RIP: 0033:0x45ca1b

Note, the nested #VMEXIT path has the same flaw, but needs a different
fix and will be handled separately.

Fixes: 5228eb96a487 ("KVM: x86: nSVM: implement nested TSC scaling")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 96936ddf1b3c..0b90f5cf9df3 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -695,10 +695,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 
 	vmcb02->control.tsc_offset = vcpu->arch.tsc_offset;
 
-	if (svm->tsc_ratio_msr != kvm_caps.default_tsc_scaling_ratio) {
-		WARN_ON(!svm->tsc_scaling_enabled);
+	if (svm->tsc_scaling_enabled &&
+	    svm->tsc_ratio_msr != kvm_caps.default_tsc_scaling_ratio)
 		nested_svm_update_tsc_ratio_msr(vcpu);
-	}
 
 	vmcb02->control.int_ctl             =
 		(svm->nested.ctl.int_ctl & int_ctl_vmcb12_bits) |
-- 
2.41.0.487.g6d72f3e995-goog

