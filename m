Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7E2452870
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 04:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346295AbhKPDT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 22:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238944AbhKPDSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 22:18:08 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43F9C125D66
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:32 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id p12-20020a17090b010c00b001a65bfe8054so677619pjz.8
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=z5GMv6NbiMRoCg4DiG3eqEEOfHTG8i5CBe13GQYa+1k=;
        b=A2uLziMDfGCU+rrQ2OKXdWg6gzg6DIqlGF5SKsaSoBg7uWPPxDJY0s748vK6+QQSOT
         xVg/6WqCuaWnBf1aaRCxe9xf7+yvVjEDPObAjPhySWzzmEz3J9u6ElblqUWlvjVY7gwQ
         9vmqP0gILIWkpqZSxKMwhFsYVRsxmzG1kGVsOQ9RkVhdZp5YZlMfLwDa9/owMnejuIjF
         Z/lLZlFfojUzhd72kFpUzI+tuPxreNL6xJRK2UkPOweqdhf/ZuW4ZbOZV0w9qjWt/Iav
         94QkxePOPuEsMnQQXmsxrwGip68cpaX8/znoVlNLgXNzuZrx410YEZT+0NYZ0TcODjgj
         S1PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=z5GMv6NbiMRoCg4DiG3eqEEOfHTG8i5CBe13GQYa+1k=;
        b=HibSbj7L+EXtO5ZPynPtb6Eik2wwrkd/yPaelbBIIHXmO1bt+qCK4ikCicKb3IfQAB
         jXahyn2tDI4rETLyhXhzyWTpGQDPHU9NVGWEhkR1R/VL6+WbG5MJ7u4Jy1anrLVg0Ze7
         RHG3PNqumr/bHCHBNlfbKGDUfFZGDzLuQAqfsO2VFqM2wAHmUGw5NHdcjKX4J9wbkuLW
         JeGHQv69PQTCdRySvkMPQeDU12EthrgDrTsiXke5yl+5zYcmMb9QCQHAAGD3C9s9BEzM
         58Btyg/5QrZD9NCmO6Ng9x4w8abDkRl25hBOCUvHQTTVvxIj2327KuQktrIwA/BC3kB5
         yaMw==
X-Gm-Message-State: AOAM533DuEwIlWANQ+s1BHPIqRRV9HBTxPtJ+sYIOO8PQ13Qbj6dd7cs
        Q6WAJImWJooB8CkTAomhHoXJf5JWizTM
X-Google-Smtp-Source: ABdhPJxHaYh7TLQhMk8Ll5lZtJAQgEuc1s0oBzh/SNTUN5Q0ypeYOJUqaOndyUFkEtIVwn11rQrJFTghwIqK
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:916d:2253:5849:9965])
 (user=bgardon job=sendgmr) by 2002:a17:90b:1b4a:: with SMTP id
 nv10mr3225743pjb.118.1637019992439; Mon, 15 Nov 2021 15:46:32 -0800 (PST)
Date:   Mon, 15 Nov 2021 15:46:02 -0800
In-Reply-To: <20211115234603.2908381-1-bgardon@google.com>
Message-Id: <20211115234603.2908381-15-bgardon@google.com>
Mime-Version: 1.0
References: <20211115234603.2908381-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH 14/15] KVM: x86/mmu: Make kvm_is_mmio_pfn usable outside of spte.c
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Export kvm_is_mmio_pfn from spte.c. It will be used in a subsequent
commit for in-place lpage promotion when disabling dirty logging.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/spte.c | 2 +-
 arch/x86/kvm/mmu/spte.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 7be41d2dbb02..13b6143f6333 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -68,7 +68,7 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
 	return spte;
 }
 
-static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
+bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 {
 	if (pfn_valid(pfn))
 		return !is_zero_pfn(pfn) && PageReserved(pfn_to_page(pfn)) &&
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index d7598506fbad..909c24c733c4 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -347,4 +347,5 @@ u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn);
 
 void kvm_mmu_reset_all_pte_masks(void);
 
+bool kvm_is_mmio_pfn(kvm_pfn_t pfn);
 #endif
-- 
2.34.0.rc1.387.gb447b232ab-goog

