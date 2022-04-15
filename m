Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21BA9501FCC
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 02:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344156AbiDOAvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 20:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234772AbiDOAvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 20:51:38 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A5CB82F5
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 17:49:11 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id q1-20020a17090a2dc100b001cba43e127dso3867229pjm.9
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 17:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=0dT7byw4Ro9Y3AnqDhqx7IwQWEEiDivwbCP/tbYK/Cs=;
        b=I7fG4skyJXElZ7VIi/kGDZJx+zejyRo6g0nY+7jJcOSv6ui8JajVENIOxSYfRPw5Es
         Jas14t09MvWbv6nBrY6obIugF5xf0hsBljfC2X+HhYEIhChQP8YvSEuOqk+iQr+8LYDp
         QaBoECQYwoM5zceYl0K417pRAhui3ymO1Q10mb8/Ycj4Okv6qp4QBtPpsNwt3PSWVaID
         CLKiXwXSU/mpTI5obYMWvrmkhvQmSlA61ljxJz9D4GYhWTFu5LqJXjbSd5P3OAWSSkTn
         9d3KKQQHFWrbcO2Ujkm9CPp/vB/Bqu5TIz+bKCf6hhAcEngeMKZIN2OsUJ+BYv2kA7gq
         sa9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=0dT7byw4Ro9Y3AnqDhqx7IwQWEEiDivwbCP/tbYK/Cs=;
        b=So94XpusQ9nsWN+oGuSQzUiS98JOtZefovT5jisr3jtBJxDcxy71FAm+SN+qjJ39XS
         gLM53gZxiMz77y6jFSePRD1Jgx0EsRtsx4kjkP9KJRjwcyFptIW+LHdwGFvggj0a5PpC
         yVj6+X07PNH7ahDiu7s4T7PH+cvsH+dTMLVtli56Vp5YiV7/uNPJjIx956zszFEygu4f
         DXWngVWOvlQStgb48VxzBg/2d1NEgJUObkWBmb9CyujiKJjPHa+cNZ5OcJeCWjWuGk07
         LdWZ8BjmDSaCjbsd/ENmH9RCvgalkAjqAtzRpT3xyiqe0cSnTIx7MylWzw5TsfkuOJ4Z
         L7YA==
X-Gm-Message-State: AOAM5308v9i6ZrQKkYy4/1JBsv1ga6C29OvGkaIH+cF7vxfPYyepJqVm
        NlGVtyV6NuaCReCYV1wVdAgQhXMB+bw=
X-Google-Smtp-Source: ABdhPJzlaUPVv+prZih6WUMXjdNNxlkNzroQEHeTtQbdmxjAOndq9+fAjCRz41yvJ2cXA2HyZ+ilzskLW+A=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:18a:b0:158:c459:ab48 with SMTP id
 z10-20020a170903018a00b00158c459ab48mr3383516plg.52.1649983751271; Thu, 14
 Apr 2022 17:49:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Apr 2022 00:49:09 +0000
Message-Id: <20220415004909.2216670-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH] KVM: x86/mmu: Check for host MMIO exclusion from mem encrypt
 iff necessary
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

When determining whether or not a SPTE needs to have SME/SEV's memory
encryption flag set, do the moderately expension host MMIO pfn check if
and only if the memory encryption mask is non-zero.

Note, KVM could further optimize the host MMIO checks by making a single
call to kvm_is_mmio_pfn(), but the tdp_enabled path (for EPT's memtype
handling) will likely be split out to a separate flow[*].  At that point,
a better approach would be to shove the call to kvm_is_mmio_pfn() into
VMX code so that AMD+NPT without SME doesn't get hit with an unnecessary
lookup.

[*] https://lkml.kernel.org/r/20220321224358.1305530-3-bgardon@google.com

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4739b53c9734..aab78574e03d 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -139,7 +139,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	else
 		pte_access &= ~ACC_WRITE_MASK;
 
-	if (!kvm_is_mmio_pfn(pfn))
+	if (shadow_me_mask && !kvm_is_mmio_pfn(pfn))
 		spte |= shadow_me_mask;
 
 	spte |= (u64)pfn << PAGE_SHIFT;

base-commit: 150866cd0ec871c765181d145aa0912628289c8a
-- 
2.36.0.rc0.470.gd361397f0d-goog

