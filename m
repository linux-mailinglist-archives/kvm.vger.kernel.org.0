Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A6950C71A
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 06:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbiDWDvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 23:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiDWDvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 23:51:21 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8CD1C58EA
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:25 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id ij17-20020a170902ab5100b00158f6f83068so5804411plb.19
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=nIl4luVOJWFkIclprxcKdIn+QCEjsjA9FteQ7s7ZGic=;
        b=Jks/1SdRI93xyP5uwMJ6C+K0aagltFg0tPscYlPq2RulXCzDR9bwmd/2YFjWammzja
         RnmNJkbEImsLiYjDKXLFudnHmutWlf9LMoek0VRl7qtsD7Dt5gjHzM1GsTD+er3aHqe8
         MyT0brKKquYdYgfR8hs28aTTvGl/5qXrE9GpOB0UIQPx+HdOQFo5cmvsblUiIPmNMR7t
         yGpq5BqTYAM1ST6Nx38oijcHR1KOwDrkNel658nL/5Dp5prtpqXGwrmxWGW78ByFcMxs
         +cDcAPTc7KEyWzhNoETs7kOxhnjOXZE+G8XKpf1xP2kxi+DaHPPwXT03r+cn6ouNMshM
         on1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=nIl4luVOJWFkIclprxcKdIn+QCEjsjA9FteQ7s7ZGic=;
        b=W9tbdhzhnEyn5lP0dQLUOYJm1RU4dIrpm2dfgQi/RzCJDCDpvdi2jxQAhuIoaDgczA
         S8ODlCjklveC+gNEwegquxBfA8CHv+AvSDW2AA/MxxE4yD/VCk6lbJVVT5v8NReq5xMg
         8NHiW+zKkPM1Cwzu/b4ONNeqsj1we/OgcIYLeZhlkPI/YXiPCoxU/Kwk83XKOGTVQyUR
         8G4TupHA2cyuHrMnFD03Me5dKRprpD3s76MwHLNVrDuodXJXOWt74qOkEpqSK5cxllg4
         QQt496NTtmthupmsRypx6sWu0cmVCRats1N3yKFy16yVpnaXPngeT82VqEexj55tHQmc
         O0gg==
X-Gm-Message-State: AOAM531jaPgKAl7Th5JW99Y76SrCO/u9O5G6gAXb/pDdtI55gAqBMqaD
        hn5QcJCUKPuJkxiKHZPHMAX15w/ocrc=
X-Google-Smtp-Source: ABdhPJz28rMsOFWsoRfGTKdC9uqo+Oi0ikmXtSwLqUR7BvCyXYi01bop8+pSXl7ackmkhJjqc0UalBUIsOE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:14c4:b0:50a:9524:67bf with SMTP id
 w4-20020a056a0014c400b0050a952467bfmr8129386pfu.55.1650685704656; Fri, 22 Apr
 2022 20:48:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 03:47:48 +0000
In-Reply-To: <20220423034752.1161007-1-seanjc@google.com>
Message-Id: <20220423034752.1161007-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220423034752.1161007-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 08/12] KVM: x86/mmu: Use IS_ENABLED() to avoid RETPOLINE for
 TDP page faults
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
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

Use IS_ENABLED() instead of an #ifdef to activate the anti-RETPOLINE fast
path for TDP page faults.  The generated code is identical, and the #ifdef
makes it dangerously difficult to extend the logic (guess who forgot to
add an "else" inside the #ifdef and ran through the page fault handler
twice).

No functional or binary change intented.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index c0c85cbfa159..9caa747ee033 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -248,10 +248,10 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
 	};
-#ifdef CONFIG_RETPOLINE
-	if (fault.is_tdp)
+
+	if (IS_ENABLED(CONFIG_RETPOLINE) && fault.is_tdp)
 		return kvm_tdp_page_fault(vcpu, &fault);
-#endif
+
 	return vcpu->arch.mmu->page_fault(vcpu, &fault);
 }
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

