Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9AB4EFDAB
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 03:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353631AbiDBBLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 21:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353634AbiDBBLH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 21:11:07 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADDE92D33
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 18:09:15 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id i16-20020a170902cf1000b001540b6a09e3so2277667plg.0
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 18:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=i0u4JArrhDsLDMn+I/rLz2mNP22Vvf7YGTWgik9+mpU=;
        b=qVDGL0IdD2Tdx7CvPjoGFys1TnI3wEvpBvsUv8P9V8q3FTljNfYJ2DPnWLfm/35OzJ
         PbT6IaDPucWH4KICB7hzdigaoj7xvylWvGxJeXIi+P9ovIJ148bq9LI//YlDaqEzycU2
         H/Pec4/sMRC9KWL7rORgGHEqFqi2d2F97le923SgGv2YQbfootQxz9AvlO1zdiO1VdEF
         3mWwX4hpVHo+UInfjOKAbUMF9PORaispXqGHyqdBTBY7jvasQQJ116Ey0kXxNHfncbBx
         UBr1yRcFTaFzGw3N7BwncRChA6aQNMe5g41GnN18St3Rs3Jk1uO1hEPfkW5BKVbj6Z8p
         cNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=i0u4JArrhDsLDMn+I/rLz2mNP22Vvf7YGTWgik9+mpU=;
        b=JT4Kk2zcvzF9fDIN6LGZmJnfKLtoYKvJjA+UE5qnMx1DXDidjnT0seV8q3SBlwaWUR
         74Rq9/H9pTrLsa8fpWyJ6Oy2a94mV9Vmmh7r7osmxD0zhaAxwpDHW0A0zaAzDvrmz8Rh
         oFTXgcgjRL4MKdjiffUgoIAVNcCsbHrWhNBaZ7TC2UgnmdYmM95uMUoBgrjDtLp374e+
         +54z1bjs1TGYNJmWuqddNjA/fvOyYM/FDOBVxn7tJMTB7kFRkz+FSVge6hY6xZPQaRnu
         pcrjRiJRApyXQ3duyCT++5KBzkaI61o0EL25+udnKOEkr+CTdIiJC8vCSDsijxoVfMyi
         Dk+Q==
X-Gm-Message-State: AOAM531JJrB5mInAL5BThVvIpt3wF3Ou78AFQgbMNYBcpQAV1MzU4Ows
        Jpm5YozfPFdxZc7HoPQKJunJj8b5IBs=
X-Google-Smtp-Source: ABdhPJw+XcYjlX+TSsfNHGCX0p23GeF8EZ6cBnRjeUKPNISQbQvhYa3RrRsEt0XFpT2wLgjalMQPqT+9e+Y=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:10c2:b0:4fd:a140:d5a9 with SMTP id
 d2-20020a056a0010c200b004fda140d5a9mr13602205pfu.77.1648861755423; Fri, 01
 Apr 2022 18:09:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  2 Apr 2022 01:09:01 +0000
In-Reply-To: <20220402010903.727604-1-seanjc@google.com>
Message-Id: <20220402010903.727604-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220402010903.727604-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 6/8] KVM: SVM: Re-inject INTn instead of retrying the insn on "failure"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
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

Re-inject INTn software interrupts instead of retrying the instruction if
the CPU encountered an intercepted exception while vectoring the INTn,
e.g. if KVM intercepted a #PF when utilizing shadow paging.  Retrying the
instruction is architecturally wrong e.g. will result in a spurious #DB
if there's a code breakpoint on the INT3/O, and lack of re-injection also
breaks nested virtualization, e.g. if L1 injects a software interrupt and
vectoring the injected interrupt encounters an exception that is
intercepted by L0 but not L1.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ecc828d6921e..00b1399681d1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3425,14 +3425,24 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 static void svm_inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 type;
 
 	WARN_ON(!gif_set(svm));
 
+	if (vcpu->arch.interrupt.soft) {
+		if (svm_update_soft_interrupt_rip(vcpu))
+			return;
+
+		type = SVM_EVTINJ_TYPE_SOFT;
+	} else {
+		type = SVM_EVTINJ_TYPE_INTR;
+	}
+
 	trace_kvm_inj_virq(vcpu->arch.interrupt.nr);
 	++vcpu->stat.irq_injections;
 
 	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
-		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
+				       SVM_EVTINJ_VALID | type;
 }
 
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
@@ -3787,9 +3797,13 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	case SVM_EXITINTINFO_TYPE_INTR:
 		kvm_queue_interrupt(vcpu, vector, false);
 		break;
+	case SVM_EXITINTINFO_TYPE_SOFT:
+		kvm_queue_interrupt(vcpu, vector, true);
+		break;
 	default:
 		break;
 	}
+
 }
 
 static void svm_cancel_injection(struct kvm_vcpu *vcpu)
-- 
2.35.1.1094.g7c7d902a7c-goog

