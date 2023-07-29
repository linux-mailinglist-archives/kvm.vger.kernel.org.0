Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149C6767A95
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237221AbjG2BQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237199AbjG2BQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:16:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE7FAB
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:17 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c6db61f7f64so2604749276.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690593376; x=1691198176;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cVoVow+zuN1SKsgICwhs7CtUzu9pX/xAq3Gg5W6CKlA=;
        b=YegBHX6eDw1uj+xgCXD6YD39fb70h+W0KWhVQvpOym2+owNKwn7bsXsD7brfQlaUlf
         nRiXpfAJYv5tM2P5/LI8rEIIKE74oKUaMlxpjLkLbXER2QNSuON95aBZaC3p7+A0+c1M
         KDEVVdJ/DMoEy0OxipsHd0LzTQy1HfKDjpTDZlfJL7IycKCUN4TiYjmAvw7EqOVAxW2Y
         CfUFO9DxC+8zR88DMhZAb/dnigzi3xGo+v3rVtUc7OwKKF7Ukco8DWb6aBM/2P2esD0X
         sjqb1dFWw31Zz1Z+UhInJmfA/Ptn4X0BgSzE+utq/SBa9GhLjL0UghrF8bbcB2IClu3Z
         zZbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690593376; x=1691198176;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cVoVow+zuN1SKsgICwhs7CtUzu9pX/xAq3Gg5W6CKlA=;
        b=fzsYyiuDkJ+tdpefvojlQSDiuWVqgFEGr38FZcmKjP3Blg8rM7flVfrRNFZ3eFmtpx
         NmhAXg/xkac9oe08Q/uBrVdeOPKq72PlzDKBkvvJ+j6GU3YOtzfthrdT4Qo3EUS8voBm
         gunw1Rod0JjasDqj/hZj3rCmCQWBljflEMbsH4rXCZNKx/S005Or6On4cc3vqObYJmjI
         R/2sHxqJncqv+KHPizJ2G2eVX+wldW6H+9JuPstT/VWq/fTUACgGDJ8CsShcyDvIFm0z
         HbBM3xxyfM4AhgZiAURxqi3lfm8Zve3nVnRkJ53ILA1tiIjkYRDAloWG/DDLoq5uH6zQ
         OCyQ==
X-Gm-Message-State: ABy/qLYf3Iwz3G59toH4tWLdVP4kSHdxHu/jTLzH16BVHhsyYaohZk75
        3byL2mEjyOP5ASDLVipQ3gym7mqDkl0=
X-Google-Smtp-Source: APBJJlGnp2J4e6Im3FhJn6G1eZaI2N06RqoUjnlGB6FT2wg8J2TBPEbZo0STu1BHToWrHT5q+TNpNabVrXs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d2c9:0:b0:d05:7ba4:67f9 with SMTP id
 j192-20020a25d2c9000000b00d057ba467f9mr17210ybg.3.1690593376432; Fri, 28 Jul
 2023 18:16:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:15:49 -0700
In-Reply-To: <20230729011608.1065019-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729011608.1065019-3-seanjc@google.com>
Subject: [PATCH v2 02/21] KVM: nSVM: Load L1's TSC multiplier based on L1
 state, not L2 state
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

When emulating nested VM-Exit, load L1's TSC multiplier if L1's desired
ratio doesn't match the current ratio, not if the ratio L1 is using for
L2 diverges from the default.  Functionally, the end result is the same
as KVM will run L2 with L1's multiplier if L2's multiplier is the default,
i.e. checking that L1's multiplier is loaded is equivalent to checking if
L2 has a non-default multiplier.

However, the assertion that TSC scaling is exposed to L1 is flawed, as
userspace can trigger the WARN at will by writing the MSR and then
updating guest CPUID to hide the feature (modifying guest CPUID is
allowed anytime before KVM_RUN).  E.g. hacking KVM's state_test
selftest to do

                vcpu_set_msr(vcpu, MSR_AMD64_TSC_RATIO, 0);
                vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_TSCRATEMSR);

after restoring state in a new VM+vCPU yields an endless supply of:

  ------------[ cut here ]------------
  WARNING: CPU: 10 PID: 206939 at arch/x86/kvm/svm/nested.c:1105
           nested_svm_vmexit+0x6af/0x720 [kvm_amd]
  Call Trace:
   nested_svm_exit_handled+0x102/0x1f0 [kvm_amd]
   svm_handle_exit+0xb9/0x180 [kvm_amd]
   kvm_arch_vcpu_ioctl_run+0x1eab/0x2570 [kvm]
   kvm_vcpu_ioctl+0x4c9/0x5b0 [kvm]
   ? trace_hardirqs_off+0x4d/0xa0
   __se_sys_ioctl+0x7a/0xc0
   __x64_sys_ioctl+0x21/0x30
   do_syscall_64+0x41/0x90
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

Unlike the nested VMRUN path, hoisting the svm->tsc_scaling_enabled check
into the if-statement is wrong as KVM needs to ensure L1's multiplier is
loaded in the above scenario.   Alternatively, the WARN_ON() could simply
be deleted, but that would make KVM's behavior even more subtle, e.g. it's
not immediately obvious why it's safe to write MSR_AMD64_TSC_RATIO when
checking only tsc_ratio_msr.

Fixes: 5228eb96a487 ("KVM: x86: nSVM: implement nested TSC scaling")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 0b90f5cf9df3..c66c823ae222 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1100,8 +1100,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		vmcb_mark_dirty(vmcb01, VMCB_INTERCEPTS);
 	}
 
-	if (svm->tsc_ratio_msr != kvm_caps.default_tsc_scaling_ratio) {
-		WARN_ON(!svm->tsc_scaling_enabled);
+	if (kvm_caps.has_tsc_control &&
+	    vcpu->arch.tsc_scaling_ratio != vcpu->arch.l1_tsc_scaling_ratio) {
 		vcpu->arch.tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
 		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
 	}
-- 
2.41.0.487.g6d72f3e995-goog

