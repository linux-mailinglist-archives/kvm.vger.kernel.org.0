Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8C644CCC7
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbhKJWdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233955AbhKJWdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:33:33 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A461C061767
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:45 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 184-20020a6217c1000000b0049f9aad0040so2685134pfx.21
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kPwPnVTG4Sy/meC4ElsKY5OGWS2q6fgAYEMpbQOeHNY=;
        b=gO1pQ3nPCk/+kvKVw4tr9OzEHRrIQlWiBFLGqTLTtW/AQgMs8lQLtYak0CvzDW3m2u
         5j1oTymJjQGd3gKgzJkHfl88I2SdumZcbdfLAX99i/1Uiqw+SqrtCfj97duhqpqAjaol
         jHYv4rppazVVjQUSnOwefYsFpECDqlLd6xXvT2/ayjCvT+G3POS+6nv7CAUlcb5gBDZU
         e3xkvT0oEnvR2+oAgVNh3elHKBfxNWPZ5DwlaWWZXjdFsiX1vFJqjUGy9GUF0zExMnSR
         KnJxshLm+Ga9KtolvZrxRXT+FJxrrgOyKfjpgFgCqxSnjvweCmhww7E9iBOinsVGaTl8
         Rp4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kPwPnVTG4Sy/meC4ElsKY5OGWS2q6fgAYEMpbQOeHNY=;
        b=26BswbeMrj591Q8O2/u3/OWFDwVN9jegxKwOsiEdI59ZI6qb/v3V3koQBv4HAjyVjZ
         ZZYLia2DMtJZZm26V98pA8qdsPT8NSIU6jr+rrgJ71aKCrERX6MVBtqYCz9WNxxTx1Yo
         +qvAZpwHr1CTG2t0l4JAVpWwa2R646aiLQr2hSJdbI/09sDpK3AlREC+txxgribqScMG
         3N+S7RmJAnZJeMrU3wQrNmq8fzUL9lo/fWeXgtaPkLjJkPF6V4tw+YsVzq7hzDHSoAya
         NnPrLCk128iB5Y2BRex1k1ndUOnVLrhH4rSiGDsEZbk6F7NQGSiM9YlHS7r9MAXCtbki
         KBpA==
X-Gm-Message-State: AOAM531piDuoRCGYjN7bPgBctIqfWolCx+7Gl5vXFLGUj7WUbDr+MtLX
        I0iXFNj/Ig/Ek8YDGBuQrhoYEVDsmDOZ
X-Google-Smtp-Source: ABdhPJxESrBcOCdqxCcnFWr7i+KiODt1/OOmJvwZPi/0b7+sOYfoRTX0jhTercb/paKoe9/n+bm6nK/JLynv
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6586:7b2f:b259:2011])
 (user=bgardon job=sendgmr) by 2002:a17:902:e806:b0:142:830:eaa4 with SMTP id
 u6-20020a170902e80600b001420830eaa4mr2432339plg.16.1636583445154; Wed, 10 Nov
 2021 14:30:45 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:29:59 -0800
In-Reply-To: <20211110223010.1392399-1-bgardon@google.com>
Message-Id: <20211110223010.1392399-9-bgardon@google.com>
Mime-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [RFC 08/19] KVM: x86/mmu: Factor mt_mask out of make_spte
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

In service of removing the vCPU pointer from make_spte, factor the memory
type mask calculation out of make_spte.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/spte.c | 9 +++++----
 arch/x86/kvm/mmu/spte.h | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 3cf08a534a16..75c666d3e7f1 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -93,7 +93,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       struct kvm_memory_slot *slot, unsigned int pte_access,
 	       gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
 	       bool can_unsync, bool host_writable, bool ad_need_write_protect,
-	       u64 *new_spte)
+	       u64 mt_mask, u64 *new_spte)
 {
 	int level = sp->role.level;
 	u64 spte = SPTE_MMU_PRESENT_MASK;
@@ -130,8 +130,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (level > PG_LEVEL_4K)
 		spte |= PT_PAGE_SIZE_MASK;
 	if (tdp_enabled)
-		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
-			kvm_is_mmio_pfn(pfn));
+		spte |= mt_mask;
 
 	if (host_writable)
 		spte |= shadow_host_writable_mask;
@@ -197,10 +196,12 @@ bool vcpu_make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		    bool can_unsync, bool host_writable, u64 *new_spte)
 {
 	bool ad_need_write_protect = kvm_vcpu_ad_need_write_protect(vcpu);
+	u64 mt_mask = static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
+						       kvm_is_mmio_pfn(pfn));
 
 	return make_spte(vcpu, sp, slot, pte_access, gfn, pfn, old_spte,
 			 prefetch, can_unsync, host_writable,
-			 ad_need_write_protect, new_spte);
+			 ad_need_write_protect, mt_mask, new_spte);
 
 }
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index bcf58602f224..e739f2ebf844 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -333,7 +333,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       struct kvm_memory_slot *slot, unsigned int pte_access,
 	       gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
 	       bool can_unsync, bool host_writable, bool ad_need_write_protect,
-	       u64 *new_spte);
+	       u64 mt_mask, u64 *new_spte);
 bool vcpu_make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		    struct kvm_memory_slot *slot,
 		    unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
-- 
2.34.0.rc0.344.g81b53c2807-goog

