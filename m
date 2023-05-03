Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EE16F5DEA
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 20:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjECS3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 14:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjECS3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 14:29:03 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2DB658E
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 11:29:02 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-559d36a91a9so57077087b3.1
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 11:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683138541; x=1685730541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rU7RFo/Qi6sAFl76yDK5utbxvptYWkIyT3bH8yXhY1Y=;
        b=RPZaNW/A8d2jFPzO5Uu6mxCjBBnsw736c6iwc2fjyW8mE2OJXdJEsKQGpx06e2NqDO
         JB46FqXGZ7WGezRBcWe8jWL+JiX+IDEHxOAK6jYXZGOxh+xnykTev40tymd/GSAU4hf9
         4hqcrlWTCBRW1FoJ7KItL1u+2KGt3wl+wWTQZyzcRM8aOTxDcCqnfopfrkBEGtDQnudd
         dA/MoBxmvAVZV10G61+rwJGi14dXUX2nVFJKeqdK7EjhTDtEmX0DrSPcJnWxY8HE9ScQ
         hERe1vFVfwavgFKEXQa4qM3xTjcaZGISPvPubszeUY0/QlqyDUMKDQlKc6BKIaQq1neS
         6HBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683138541; x=1685730541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rU7RFo/Qi6sAFl76yDK5utbxvptYWkIyT3bH8yXhY1Y=;
        b=GI3MwXEN3sGl7ia2NJr5hOPcvubzcsnT3negrL2E/ey3g/ggHRgjN9l4ftWl/9GQYh
         RQBj6OhdvGc3hd2sU3uoumJaUUNFrlWTJZttpwHRReV8onEuuvsw8KaM/xlPreL/TKB8
         clCJYfk6sKi6c9HqZcKyebTev86S/FmWxMVHEdJzwni5RVr/RaqEIFu07C35AkxonGdA
         LikcRIt8lzY0Q6GpdYtdDwoM5X+kbJBlx1AzI0PyZmiYNzTnlEEhuZljVdvDvkvSgQJP
         IKC/9qq2BWoYjWFYDBbTIk//PjmA12mWxY8b+WbNyx0DvZuDaeZw38rGCr14JCE9Kdql
         kMNA==
X-Gm-Message-State: AC+VfDykcszAfZgdrB5Y3mLvM5z3B4tkzG4+RAXAc7PwwIY3LClm8q4i
        UmY/gWkqQ2r6JZ6vNQ7luc3jK7o6HVM=
X-Google-Smtp-Source: ACHHUZ6f2gjDc37H1mSg+Zx7V96G1c7wz1OI8tjDQXwLTbONJnYUIqlGEuiFyIoVnxJaJdWrkqm+pZOGo5A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5305:0:b0:b92:5a75:9f55 with SMTP id
 h5-20020a255305000000b00b925a759f55mr13450125ybb.1.1683138541455; Wed, 03 May
 2023 11:29:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 May 2023 11:28:49 -0700
In-Reply-To: <20230503182852.3431281-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230503182852.3431281-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230503182852.3431281-3-seanjc@google.com>
Subject: [PATCH 2/5] KVM: SVM: Use kvm_pat_valid() directly instead of kvm_mtrr_valid()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wenyao Hai <haiwenyao@uniontech.com>,
        Ke Guo <guoke@uniontech.com>
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

From: Ke Guo <guoke@uniontech.com>

Use kvm_pat_valid() directly instead of bouncing through kvm_mtrr_valid().
The PAT is not an MTRR, and kvm_mtrr_valid() just redirects to
kvm_pat_valid(), i.e. for better or worse, KVM doesn't apply the "zap
SPTEs" logic to guest PAT changes when the VM has a passthrough device
with non-coherent DMA.

Signed-off-by: Ke Guo <guoke@uniontech.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index eb308c9994f9..db237ccdc957 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2935,7 +2935,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 		break;
 	case MSR_IA32_CR_PAT:
-		if (!kvm_mtrr_valid(vcpu, MSR_IA32_CR_PAT, data))
+		if (!kvm_pat_valid(data))
 			return 1;
 		vcpu->arch.pat = data;
 		svm->vmcb01.ptr->save.g_pat = data;
-- 
2.40.1.495.gc816e09b53d-goog

