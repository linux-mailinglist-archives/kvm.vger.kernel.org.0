Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B85B4F6E12
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 00:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237395AbiDFWxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 18:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237376AbiDFWxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 18:53:08 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBBB2013F6
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 15:51:09 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x6-20020aa79566000000b004fb3bf117daso2259790pfq.17
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 15:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=Yd7kBzJhSKPEijEgeJE9tib2Ep9gaLFvQRnKmrO5VA0=;
        b=LhOzIW57AkiBW9IoFzE3fgd5Yl81Y8zZfQuvILL85/Gr+Vu+KTrYjls6vIaBMC9QJm
         N0bWU2ZL3o8Q4FjjaiiAMCmJwhdOMq+1lkCbcOTivrGxJbt1iTJxqyhCjxK1cQxlpOuv
         sS3YV0phZYezDxCCRpHgL3ZymQXNgk5xGvfBDsM5VuCC14JOMqO518SgXKHYShojsObo
         lpAtIbHwfSBQibWtJYtJkjfQwXwaTneaRe9NmvKWwmbb/RIToCES3F2NpFni/Arj4w/E
         /Dp+iR9SIjTuSMdDEDA+zXxsirE/C9uEh+6d7+WYpsLFxQb5a7Y4f6hsEc8Zu5/Y1r5g
         yILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=Yd7kBzJhSKPEijEgeJE9tib2Ep9gaLFvQRnKmrO5VA0=;
        b=Nqdvr9QVglaKSvwqx57NQ5+1WSwGkFsJvbOpImCJz6Kvwf0YpV6r5X9bNTsxpnhErg
         /5xUtKRm0UB2seE4kT5/pA6xQvr0GjZSJmOhDSjYh5s7oLISkbXdXe4RqNLxOqA2o1um
         n3t5J7WJS8Zkao0oesrZglGeJfp5QAmE+93+OUG91qP6xo3MRBcD9xHvwQW+sbPQ3/of
         BA4R3Cujic6cMvS0DOkDE2OprK8lq2hc5GkIrTycSTpZLRgI2YgeoH0eucoLzwEmVbn3
         ECwtCxId8gcSby4GK113s4BCa2RmHGz5mGDDAEBUmhjWv9ZW2rQGQv1xLtuGHM+KhoHX
         Ge4g==
X-Gm-Message-State: AOAM531HfF6CACKPpdRAYGy8I3JcfcQ7EbGL8FBiWBoY/zy8jI3JVC1m
        Yq6rgCdaU7RK6scYiwA8NWwIb8YM9EI=
X-Google-Smtp-Source: ABdhPJy4JrnizHX7G7WI5UE9Z8XjjQiqNO7CAlpFkjZZGkUTD+ezhhVU+1mJBJ7o+bw1LPRNJhg9tFsbK20=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1411:b0:4fd:e594:fac0 with SMTP id
 l17-20020a056a00141100b004fde594fac0mr11183238pfu.79.1649285468869; Wed, 06
 Apr 2022 15:51:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  6 Apr 2022 22:51:06 +0000
Message-Id: <20220406225106.55471-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH] KVM: x86: Deplete Paolo's brown paper bag supply by one
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

Fix an inverted check on CR0.PG when computing the cpu_role, the MMU is
direct and all CR4 bits ignored if paging is disabled, not enabled.

Fixes: d73678dc11ec ("KVM: x86/mmu: split cpu_role from mmu_role")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

I haven't done much testing on the rest of the MMU role patches, this just
popped up in very, very basic testing ;-)  I assume this will be squashed,
hence the snarky shortlog.

 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e41d7bba7a65..ab24fc161bac 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4699,7 +4699,7 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 	role.base.smm = is_smm(vcpu);
 	role.base.guest_mode = is_guest_mode(vcpu);
 
-	if (____is_cr0_pg(regs)) {
+	if (!____is_cr0_pg(regs)) {
 		role.base.direct = 1;
 		return role;
 	}

base-commit: 56ba4b488353a8925b30367d72e41d1996c23554
-- 
2.35.1.1094.g7c7d902a7c-goog

