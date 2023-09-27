Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0E87AF9A5
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjI0Eq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjI0EqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:46:07 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E5E55A1
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 21:09:43 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-56f75e70190so10379832a12.3
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 21:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695787782; x=1696392582; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ql59ZozAfruWu53p0E9BV+7cxW/ZoWb0OlAlk4/Vjw=;
        b=UM/GOjCpoo8qNFNaAEdIRqNSP8oxkwyg8CSIMlQEktQ1SzaIbNW2OGCoIKcMw4yvs9
         MUzxsfh9FVdBYex84euDLepmXWYJG/N9SRsKd7CpE4HncOxFikLNWKN3qw3MraOHaxsj
         WdxfkTWwkhXxWtUPidRIqd8wiCttQWyfygU5Zb47uTUT9HHnmbVnb2BjbkUj9pxDWg2Y
         U2EC+9Gi57RS+xy/3SBOyYHLEshOQ5M/qbLw/IyGbV1hHM6mFMV1l9FB4MNnWrs6MdNI
         xyz1naUaEvcHlko2sc/bvYkhXFdPriJjJQ/okOPSNt6dqezBBSerPYyBJdtxc54akx8+
         M3/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695787782; x=1696392582;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ql59ZozAfruWu53p0E9BV+7cxW/ZoWb0OlAlk4/Vjw=;
        b=aaEZZk8LWESMFW3JymSXx9dgXH1Ml4+U4r/U468ABtkXHzVInL92O9YOhP79Yf3HOM
         MjTkWf7NbqVcJUNsPHwdygpwoQUs0FRUKcaY1SilZ3fozHuxsoFfYJNgYf167Graw79B
         yOEXdZkNnyi8I3MPa7rm75BeZhqGEBhU41JvouAjqVLrbxoYJAkHc7g4U4n1nz4t1pEK
         Wn/z3V/TxsPqzcpXdM8ps2YgVmDmB5bjCUceNEypi3ayc9DLmHhXi6O/0od6Gl28kcA2
         Gjg2xjBa9p2+Qb4ruXji/tYIEWpSJv1w/8Mnqi4RB0nPCm+JhtxjhlxoFvT9bluw4Bed
         l1+g==
X-Gm-Message-State: AOJu0YxQz2RzHAI37Y8kX1JEgYCMCNNeo/MXFvspwUid57OgIKepuSMC
        /AdpIsSUEBWGFnsXbgCskWclTjOTiPrC
X-Google-Smtp-Source: AGHT+IEmkcTNFiQOlPL5NwYJupyVhxFbA7jHApnSwyGleZLx9KVfWy152cd4H41ikrjuq2D2emu/i912bnN1
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a63:7e5c:0:b0:57c:856a:5010 with SMTP id
 o28-20020a637e5c000000b0057c856a5010mr7844pgn.10.1695787782528; Tue, 26 Sep
 2023 21:09:42 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Wed, 27 Sep 2023 04:09:39 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230927040939.342643-1-mizhang@google.com>
Subject: [PATCH] KVM: x86: Move kvm_check_request(KVM_REQ_NMI) after kvm_check_request(KVM_REQ_NMI)
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <likexu@tencent.com>, Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move kvm_check_request(KVM_REQ_NMI) after kvm_check_request(KVM_REQ_NMI).
When vPMU is active use, processing each KVM_REQ_PMI will generate a
KVM_REQ_NMI. Existing control flow after KVM_REQ_PMI finished will fail the
guest enter, jump to kvm_x86_cancel_injection(), and re-enter
vcpu_enter_guest(), this wasted lot of cycles and increase the overhead for
vPMU as well as the virtualization.

So move the code snippet of kvm_check_request(KVM_REQ_NMI) to make KVM
runloop more efficient with vPMU.

To evaluate the effectiveness of this change, we launch a 8-vcpu QEMU VM on
an Intel SPR CPU. In the VM, we run perf with all 48 events Intel vtune
uses. In addition, we use SPEC2017 benchmark programs as the workload with
the setup of using single core, single thread.

At the host level, we probe the invocations to vmx_cancel_injection() with
the following command:

    $ perf probe -a vmx_cancel_injection
    $ perf stat -a -e probe:vmx_cancel_injection -I 10000 # per 10 seconds

The following is the result that we collected at beginning of the spec2017
benchmark run (so mostly for 500.perlbench_r in spec2017). Kindly forgive
the incompleteness.

On kernel without the change:
    10.010018010              14254      probe:vmx_cancel_injection
    20.037646388              15207      probe:vmx_cancel_injection
    30.078739816              15261      probe:vmx_cancel_injection
    40.114033258              15085      probe:vmx_cancel_injection
    50.149297460              15112      probe:vmx_cancel_injection
    60.185103088              15104      probe:vmx_cancel_injection

On kernel with the change:
    10.003595390                 40      probe:vmx_cancel_injection
    20.017855682                 31      probe:vmx_cancel_injection
    30.028355883                 34      probe:vmx_cancel_injection
    40.038686298                 31      probe:vmx_cancel_injection
    50.048795162                 20      probe:vmx_cancel_injection
    60.069057747                 19      probe:vmx_cancel_injection

From the above, it is clear that we save 1500 invocations per vcpu per
second to vmx_cancel_injection() for workloads like perlbench.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 42a4e8f5e89a..302b6f8ddfb1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10580,12 +10580,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_SMI, vcpu))
 			process_smi(vcpu);
 #endif
-		if (kvm_check_request(KVM_REQ_NMI, vcpu))
-			process_nmi(vcpu);
 		if (kvm_check_request(KVM_REQ_PMU, vcpu))
 			kvm_pmu_handle_event(vcpu);
 		if (kvm_check_request(KVM_REQ_PMI, vcpu))
 			kvm_pmu_deliver_pmi(vcpu);
+		if (kvm_check_request(KVM_REQ_NMI, vcpu))
+			process_nmi(vcpu);
 		if (kvm_check_request(KVM_REQ_IOAPIC_EOI_EXIT, vcpu)) {
 			BUG_ON(vcpu->arch.pending_ioapic_eoi > 255);
 			if (test_bit(vcpu->arch.pending_ioapic_eoi,

base-commit: 73554b29bd70546c1a9efc9c160641ef1b849358
-- 
2.42.0.515.g380fc7ccd1-goog

