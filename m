Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C61B6FFD54
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 01:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239597AbjEKXeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 19:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239575AbjEKXd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 19:33:59 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6463170D
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:33:57 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-25014b171a4so8892285a91.1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683848037; x=1686440037;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cOrgUlHpOAMPmZ+StptvgqaX6DcVrL8V0qVFj+MTpWU=;
        b=3Fa2pfYTrzongvw+2wZAPpSntt85/6aUe3Vtm86lOFwvxfbwMs78Q3I2sTq9MovEpR
         aoNsErsK+Bef8YseM7drICvYFVQQ5IyvsNcDQ8f5Cazlc0O8K+hQTEQEfX6wAs1yCaXp
         P/UK2gJ8FtA/wOLMlfom8DZmJ3NPPK87eRmkqG75tEijyAnLL7pcOd40Qle53l1an76L
         1f+9oIrohRY5Us6SCxGAi/r7Kt7ZZml42CCC6czfGkWfrisfMcu7Syp3vWjwiqpIV2Xn
         +LMr/4hhvfc1fyi6j49wvBy7ckFxzNq+xwti3aYTsbXS+zA8vlyzoXLHFxB49NLp0A53
         93Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683848037; x=1686440037;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cOrgUlHpOAMPmZ+StptvgqaX6DcVrL8V0qVFj+MTpWU=;
        b=DSJoONpaLUWSIXOzoYqNmS4lw+yDc6iOE/nuVVLWNa34xnp8yzWMdrg0WBY7jf3RKt
         JRB4Vm5R2lNykJ7l9cEwGPvmRuh33xE+hl5sEw/6jiAL+cTAf84PcWt1nJbVhfVFtxmo
         +7SUawxWj5Rht4RIRxxJ1qIX7P11zXcl2HJvKvIMRXxkS3qKAJn4oZS69pu6FVmARlKp
         aV2P0yXTqonPKmcPDM7P/yfZ+mD8dfCcGEPxP0z6Q9ZeJq6/Fb5l9r8DGrga5zgdzSZB
         JKde+GiGOb1CZHdNzHGvx1/SYpY4inStaUJFswZReRWyhkSwkAr5GBXY3Beew6csgZGz
         A41w==
X-Gm-Message-State: AC+VfDyrpwthvl+64sHj//sUhytgS0riM0bqlzMH+x40txaD6s3EsM/+
        TZyHomjbzw6ySwQMLIJHUqBhEoiz3PI=
X-Google-Smtp-Source: ACHHUZ4iV5UzOGo0s0EI3akrtwRyHYxvSNNz/jrEoxL9ORDVEiIunJIWVIcQPv8RbK2l2oGYvTLJ0CrLL6Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a612:b0:1a6:9363:163a with SMTP id
 u18-20020a170902a61200b001a69363163amr8568408plq.10.1683848037734; Thu, 11
 May 2023 16:33:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 May 2023 16:33:45 -0700
In-Reply-To: <20230511233351.635053-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230511233351.635053-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230511233351.635053-3-seanjc@google.com>
Subject: [PATCH v2 2/8] KVM: SVM: Use kvm_pat_valid() directly instead of kvm_mtrr_valid()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Wenyao Hai <haiwenyao@uniontech.com>,
        Ke Guo <guoke@uniontech.com>
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

From: Ke Guo <guoke@uniontech.com>

Use kvm_pat_valid() directly instead of bouncing through kvm_mtrr_valid().
The PAT is not an MTRR, and kvm_mtrr_valid() just redirects to
kvm_pat_valid(), i.e. is exempt from KVM's "zap SPTEs" logic that's
needed to honor guest MTRRs when the VM has a passthrough device with
non-coherent DMA (KVM does NOT set "ignore guest PAT" in this case, and so
enables hardware virtualization of the guest's PAT, i.e. doesn't need to
manually emulate the PAT memtype).

Signed-off-by: Ke Guo <guoke@uniontech.com>
[sean: massage changelog]
Reviewed-by: Kai Huang <kai.huang@intel.com>
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
2.40.1.606.ga4b1b128d6-goog

