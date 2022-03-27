Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D254E8A20
	for <lists+kvm@lfdr.de>; Sun, 27 Mar 2022 22:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbiC0U7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 16:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiC0U7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 16:59:46 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C8EC05
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 13:58:07 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id t184-20020a6281c1000000b004e103c5f726so7293508pfd.8
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 13:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=XonkmmLfj4Wct1L8IBmrGiXwJl2mUMAxLc+XoNB7FkQ=;
        b=PfjgpQre+BTnF+Si7StcBuHOdZRl2W+8L4Em08Ajr2TGis+LMi5SHvZT8+51IVIAn5
         8H+RCxmedCcQmBgr4Wgj06ZHlll++/ggSwdRdo8sr8afYIE2YEnq7pLUKz5K2Y8hudkn
         4dXI1W8Y6g6E0hymMOvQ4o8TLzLUhSl3wDolmIGNzAbQxP8prwvnijD9qtuY3yP4SHm7
         kuHeYOUxlsd7iK7zAEGzyNTv5SOdaYGA0ZCm7G5QUAiRfuUnpYHpbAHmlUK2ls6cZ2Wu
         7+tCr7BGEp2h1fDS0YY6eZT7HfBl3niHNV5TEo0avD3QrE6RKKc2zxAqBOeYImhEFHvX
         8zVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=XonkmmLfj4Wct1L8IBmrGiXwJl2mUMAxLc+XoNB7FkQ=;
        b=nUH/L20W8t+DHBtRAIGa83nBS/SyrduHFbTbMQloRpi9CeivoWb1HQtq2GflHa4nPr
         xZSV+K9Vv3MX7i9ZqraDUizNMgi4Ie4WI33sZN8aDOu+oquHLCGJa+/WfO+cABSOcj1u
         R411Ne600/7kOC8g/BaiEFvgmpVeEOE5XyKdZdLhByrGXFd7Wwo2cPJs++oTlmKnskHj
         231Eneh/NBrItyuuq/AjZI1jmHj/aV4Z5x78eHbwh5mvsI7P85E9eAhVtpmossJX3UK6
         WW1WBcr0rsvZ2eG6ofydVP2Z7YivGcTdrPcjsws+jS08bIIQNrwB0F4NRllt1x9Gw9my
         oweQ==
X-Gm-Message-State: AOAM531MpHNJ/NmQDbgOOI4lUj9hHssY/z/k2nTpS+xFl0CQwpB2SS9p
        i/36xl3uvvVY3ZqZHbhf9HGfQNGWXLZh
X-Google-Smtp-Source: ABdhPJwNX3stSfD31SPexaUkVp2e8Ou343K+n8O5BPfRQaT8A2UVAx5EaTfXBzrGU/eISjsUQrYLX08rJYy7
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:3316:b0:4fa:80fd:f3f6 with SMTP
 id cq22-20020a056a00331600b004fa80fdf3f6mr20127184pfb.65.1648414686742; Sun,
 27 Mar 2022 13:58:06 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Sun, 27 Mar 2022 20:58:03 +0000
Message-Id: <20220327205803.739336-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH] KVM: x86/mmu: add lockdep check before lookup_address_in_mm()
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
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

Add a lockdep check before invoking lookup_address_in_mm().
lookup_address_in_mm() walks all levels of host page table without
accquiring any lock. This is usually unsafe unless we are walking the
kernel addresses (check other usage cases of lookup_address_in_mm and
lookup_address_in_pgd).

Walking host page table (especially guest addresses) usually requires
holding two types of locks: 1) mmu_lock in mm or the lock that protects
the reverse maps of host memory in range; 2) lock for the leaf paging
structures.

One exception case is when we take the mmu_lock of the secondary mmu.
Holding mmu_lock of KVM MMU in either read mode or write mode prevents host
level entities from modifying the host page table concurrently. This is
because all of them will have to invoke KVM mmu_notifier first before doing
the actual work. Since KVM mmu_notifier invalidation operations always take
the mmu write lock, we are safe if we hold the mmu lock here.

Note: this means that KVM cannot allow concurrent multiple mmu_notifier
invalidation callbacks by using KVM mmu read lock. Since, otherwise, any
host level entity can cause race conditions with this one. Walking host
page table here may get us stale information or may trigger NULL ptr
dereference that is hard to reproduce.

Having a lockdep check here will prevent or at least warn future
development that directly walks host page table simply in a KVM ioctl
function. In addition, it provides a record for any future development on
KVM mmu_notifier.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: David Matlack <dmatlack@google.com>

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1361eb4599b4..066bb5435156 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2820,6 +2820,24 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	 */
 	hva = __gfn_to_hva_memslot(slot, gfn);
 
+	/*
+	 * lookup_address_in_mm() walks all levels of host page table without
+	 * accquiring any lock. This is not safe when KVM does not take the
+	 * mmu_lock. Holding mmu_lock in either read mode or write mode prevents
+	 * host level entities from modifying the host page table. This is
+	 * because all of them will have to invoke KVM mmu_notifier first before
+	 * doing the actual work. Since KVM mmu_notifier invalidation operations
+	 * always take the mmu write lock, we are safe if we hold the mmu lock
+	 * here.
+	 *
+	 * Note: this means that KVM cannot allow concurrent multiple
+	 * mmu_notifier invalidation callbacks by using KVM mmu read lock.
+	 * Otherwise, any host level entity can cause race conditions with this
+	 * one. Walking host page table here may get us stale information or may
+	 * trigger NULL ptr dereference that is hard to reproduce.
+	 */
+	lockdep_assert_held(&kvm->mmu_lock);
+
 	pte = lookup_address_in_mm(kvm->mm, hva, &level);
 	if (unlikely(!pte))
 		return PG_LEVEL_4K;
-- 
2.35.1.1021.g381101b075-goog

