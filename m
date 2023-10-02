Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2302F7B4AF9
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 06:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjJBEJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 00:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjJBEI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 00:08:59 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3C6B8
        for <kvm@vger.kernel.org>; Sun,  1 Oct 2023 21:08:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d81503de9c9so24459551276.3
        for <kvm@vger.kernel.org>; Sun, 01 Oct 2023 21:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696219734; x=1696824534; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d9RyKi2tLeQpV4Sj/8aOYjchp6vn0YLRcfFMMaJdDOc=;
        b=nuhkbkB61/9L0+ARVQso1isocI+VwKg/Dkn+iHemmNXL6SFoB8XqE1HNZLdKmUe7b+
         LOnjL9SEyL7+3aZMWI/Aq3tFiB1+0UYl7zqDOKMaZcpaJCVdmxTEWmFpB8vMFgH28lsf
         8aJK+zQlpYFsXBgcHZxZjxmszV4/0hTQUCxZDgxhAipNfzIKgEQHjRGJRTe8ZY8uZfvo
         tpXBIjTdlWVj9ceHFTy1GnmAb/i/9nhm9a2/08iqzWPxmjhzcfph2iiyvm2ZJzcDHJ9Z
         kRnWhy4HlP1NtVkBg0nxwZkvk1TrtRRpU2eB4+XWtrh7rXiNrrV4YV1WVf6ZCVKsWfDc
         l7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696219734; x=1696824534;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d9RyKi2tLeQpV4Sj/8aOYjchp6vn0YLRcfFMMaJdDOc=;
        b=ilVS3f0zQmez1EseD0JrAgA0WSGWh3nvaa8BeFwBrLFWwV/5c92kGAXgy+FnKjmsg+
         R24ANTgOSSTNX5IZXrRRVPpOeaM6IQnoDA27ZRLlekr0xFWJST7ZxoVPnHW693SBjKTD
         xxeV4/ExrxCt0R61+OsMLrqOkv0bhmEZD3pqqA04TfHTI1UNg1AKZ4fwbYphy+h0IwDJ
         OEgrcy9GYYd10q3HBlLIESIaJX8sCbzYK/qix0Q4c3wRnc5UBHpO7f3mKY8dHcfKF3Zc
         ISElYW10vkU77QZll2qqoEs6UmIjY9zdvE2Gc2bru+A/Usi+g2A+fwG8lJ2CvaJ3mRDF
         gB5g==
X-Gm-Message-State: AOJu0YwOAmTJ7UQhn77DFfspqd1KjSsNybcNtXzPh25jjHZ/CnoA6sCq
        OH/RQ+vlmPvSuDlS/PjRCsGPZZqt6ico
X-Google-Smtp-Source: AGHT+IHYS1p5vGODFCUAA+svB2TN/dFLZ+w+KKKdhm3BjVhLIwbZUhrQ+K2+1+aqqgq9thHos0Ja3m2JENC/
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a25:ae84:0:b0:d0c:c83b:94ed with SMTP id
 b4-20020a25ae84000000b00d0cc83b94edmr151069ybj.10.1696219734572; Sun, 01 Oct
 2023 21:08:54 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon,  2 Oct 2023 04:08:39 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20231002040839.2630027-1-mizhang@google.com>
Subject: [PATCH v2] KVM: x86: Service NMI requests after PMI requests in
 VM-Enter path
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <likexu@tencent.com>, Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Service NMI requests after PMI requests in vcpu_enter_guest() so that KVM
does not need to cancel and redo the VM-Enter. Because APIC emulation
"injects" NMIs via KVM_REQ_NMI, handling PMI requests after NMI requests
means KVM won't detect the pending NMI request until the final check for
outstanding requests. Detecting requests at the final stage is costly as
KVM has already loaded guest state, potentially queued events for
injection, disabled IRQs, dropped SRCU, etc., most of which needs to be
unwound.

Move the code snippet processing KVM_REQ_NMI to the one after processing
KVM_REQ_PMI to make KVM vPMU more efficient. Note that changing the order
of the code snippets does make any functional change to KVM. KVM allows two
pending NMIs while x86 architecture allows only one pending. This is
because KVM may not be able to process NMI quickly. Therefore, if a PMI
generated NMI is coincident two other NMIs pending (or one other pending
NMI and KVM blocks NMI) in KVM, then it will be dropped and it is
architecturely ok, since x86 CPU does not guarantee the delivery of each
NMI.

Using SPEC2017 benchmark programs running along with Intel vtune in a VM
demonstrates that the following code change reduces 800~1500 canceled
VM-Enters per second.

Some glory details:

Probe the invocation to vmx_cancel_injection():

    $ perf probe -a vmx_cancel_injection
    $ perf stat -a -e probe:vmx_cancel_injection -I 10000 # per 10 seconds

Partial results when SPEC2017 with Intel vtune are running in the VM:

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

v1: https://lore.kernel.org/all/20230927040939.342643-1-mizhang@google.com/

Suggested-by: Sean Christopherson <seanjc@google.com>
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
2.42.0.582.g8ccd20d70d-goog

