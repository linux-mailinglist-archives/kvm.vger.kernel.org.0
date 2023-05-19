Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794C3708D0F
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 02:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjESAwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 20:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjESAwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 20:52:41 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5336910C9
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 17:52:40 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id e9e14a558f8ab-338280a9459so43810385ab.0
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 17:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684457559; x=1687049559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ux8TuKlucx7+2ANrW96xfpSzC0srXjlkGkFfov8Qh8A=;
        b=nfSM+9p6k+4DETvto+y0GWvj0T9Pn8cMCjrch3oOD/Wt9bRMqYA9UGLB5sbBIFm3bE
         ErGeQr5UdDquGK62ZHTcCSsHQAXPCCLZVOkbzbU6VHi8oy1BBkXlDTx1rUSKGHyXEkcw
         CRrFCWWvlBNXVCva7myDBYAhGGf/U7gd9GAipG1KEYCz1LLOkJLWaSE8T5nm1cEdVlR8
         5tP2tqRGprEouckvewWTYmoYRDgGUs1jXpJueLe9UdjlIwEd5LWNV3rcOeywTjR8qcTr
         7fzQ54BFSSQK1VZGjDitJwXDp65Cwumn+1ym/giNrZSEg0XMB2EwauEgdfRfOpuh9nka
         y5xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684457559; x=1687049559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ux8TuKlucx7+2ANrW96xfpSzC0srXjlkGkFfov8Qh8A=;
        b=K/rYb1bCdnkF/ysLhJ22MhsCuikegFMeP/bNO/ulPW074jdpZm16pY7jfWcSvyaONS
         1uw9k0v0AEcfjLttoeT6hAIxOu02CiStBr4ws84M9sTU0KUVzB1StRgDefLWsZnsGTO3
         D9PZ2789OZmHQVaYmD23aIkdG1b4MucB8GHeOq1aQzWNwEWqVHuMFdXrowprItppeDDx
         4Ja6r9fYHpwMpiKcjmCgOxSNtx9PMsL8JcqGYHnzj280hS9JRtzjFRw3BV0H4OfpE+qb
         vZp+lgMfZQSbDLrqQl8eJRSFln5UD880TYJ/+pbPefi0j5p08s0Y2Pv9pbAMD4BNmK8X
         Ab6A==
X-Gm-Message-State: AC+VfDzGJrxrjYIm7jx6qxcik9TxNSQIA34sdrbxt3juPK7tUnr6wWmV
        b/iOiizygjz+qYfmPbvQP4GMKJv5wAvE
X-Google-Smtp-Source: ACHHUZ4mrHRBUPTPC63HrBmyYMpoPQXoQJAtvWnxdjoUIHpL+YcJ3GzassZ0JGPJascAshL3vG7BYy3W5E7i
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6e02:786:b0:335:fee3:37c1 with SMTP id
 q6-20020a056e02078600b00335fee337c1mr28210ils.3.1684457559778; Thu, 18 May
 2023 17:52:39 -0700 (PDT)
Date:   Fri, 19 May 2023 00:52:29 +0000
In-Reply-To: <20230519005231.3027912-1-rananta@google.com>
Mime-Version: 1.0
References: <20230519005231.3027912-1-rananta@google.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230519005231.3027912-5-rananta@google.com>
Subject: [PATCH v4 4/6] KVM: arm64: Flush only the memslot after write-protect
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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

After write-protecting the region, currently KVM invalidates
the entire TLB entries using kvm_flush_remote_tlbs(). Instead,
scope the invalidation only to the targeted memslot. If
supported, the architecture would use the range-based TLBI
instructions to flush the memslot or else fallback to flushing
all of the TLBs.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e3673b4c10292..2ea6eb4ea763e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -996,7 +996,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	write_lock(&kvm->mmu_lock);
 	stage2_wp_range(&kvm->arch.mmu, start, end);
 	write_unlock(&kvm->mmu_lock);
-	kvm_flush_remote_tlbs(kvm);
+	kvm_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 /**
-- 
2.40.1.698.g37aff9b760-goog

