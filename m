Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2DC50C668
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 04:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiDWCRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 22:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiDWCRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 22:17:15 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA6721B995
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:20 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id m192-20020a633fc9000000b003aa812fe25bso4873348pga.12
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=PyT8c4uOpMREZ0ICFl/zs2j7McPJGYK9LkWRLQoEbds=;
        b=fSMxFj4x5SruHcAurF3Hkt5R2t78474Ci8gOTMRUVZEAZUv5QFEaSVW5YASiuKZmHL
         458qRAV/dMQ1NTePpDszaMhgo3LMxvB9LsWHc2CbUusE/FTnw4mDV9crM7K5XeiIAo5K
         wjiF5ulN5I+Bf02AGazFTA4Ga/f0yuxapmWY9kVSagfsyn/Fg5rh5oJkg4uCwlp11bL7
         sZ95T/wkiLftfMbUY8EgYvDUveVfIGYnAKRt9/HDuArfmwub/1xO2Z/WKxtqzAaW9fi9
         YvckJBOmqnN38Yi/smWuAAzODcH80h/dt+XyNGN5/cuVrxGcltyBDotH/rC0ScFf878V
         Eibg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=PyT8c4uOpMREZ0ICFl/zs2j7McPJGYK9LkWRLQoEbds=;
        b=caZ4REd/lPkiNSRY8AXRugT3vbkdYWG+3z9wHMGEcmaPPbp0Jd1PXVv+AAYZ7LzpwJ
         QKhGxHx10TeuW3/3pEC/rdQaR6M80fWmysk3eRUWTMN3eUZvpnXjNxuFrvKNtg5WvTgu
         pV/jr8X0k0ud+rkyjsHHLWGrt6Fw+11NPBJy15RwcuALwtn99rC1KjhrlvUg3BtfXeuP
         X3Qm5Z/h7Tq+Xe3vnW5wGqI2WdAq9C+R2JMRf99wot99QopXoJGqDqbNeN2YwCHVc3my
         wSsObJISknT/+OeB+mh6OZDXFCgv5s2X/C8Q0MbsdPxTpsuTrpgrsfcDUbAZR5iDVcbX
         lVQg==
X-Gm-Message-State: AOAM532gcQvHKb5ZSt16r1srGE9Z3CTlmuGZcA1Yr4ZwnaCTLCTxa8ef
        zgFXgPQSEAgqE9gEGwXD0CTJKimB1o0=
X-Google-Smtp-Source: ABdhPJw5hXpv/3W1ZRCBDFE197HCr7uSU9IoBaxVUiWUd5dzGROUXkWDoEtWISqGRD7YhNCxphH44X2pfZQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:ed0e:0:b0:4fa:11ed:2ad1 with SMTP id
 u14-20020a62ed0e000000b004fa11ed2ad1mr8110804pfh.34.1650680059539; Fri, 22
 Apr 2022 19:14:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 02:14:04 +0000
In-Reply-To: <20220423021411.784383-1-seanjc@google.com>
Message-Id: <20220423021411.784383-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220423021411.784383-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 04/11] KVM: SVM: Stuff next_rip on emulated INT3 injection
 if NRIPS is supported
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If NRIPS is supported in hardware but disabled in KVM, set next_rip to
the next RIP when advancing RIP as part of emulating INT3 injection.
There is no flag to tell the CPU that KVM isn't using next_rip, and so
leaving next_rip is left as is will result in the CPU pushing garbage
onto the stack when vectoring the injected event.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Fixes: 66b7138f9136 ("KVM: SVM: Emulate nRIP feature when reinjecting INT3")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 82175a13c668..14bc4e87437b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -392,6 +392,10 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 		 */
 		(void)svm_skip_emulated_instruction(vcpu);
 		rip = kvm_rip_read(vcpu);
+
+		if (boot_cpu_has(X86_FEATURE_NRIPS))
+			svm->vmcb->control.next_rip = rip;
+
 		svm->int3_rip = rip + svm->vmcb->save.cs.base;
 		svm->int3_injected = rip - old_rip;
 	}
@@ -3703,7 +3707,7 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 	/*
 	 * If NextRIP isn't enabled, KVM must manually advance RIP prior to
 	 * injecting the soft exception/interrupt.  That advancement needs to
-	 * be unwound if vectoring didn't complete.  Note, the _new_ event may
+	 * be unwound if vectoring didn't complete.  Note, the new event may
 	 * not be the injected event, e.g. if KVM injected an INTn, the INTn
 	 * hit a #NP in the guest, and the #NP encountered a #PF, the #NP will
 	 * be the reported vectored event, but RIP still needs to be unwound.
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

