Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE173F0EDC
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 01:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbhHRX46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 19:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbhHRX44 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 19:56:56 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DBCC0613CF
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 16:56:21 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x18-20020a056a000bd200b003e14701b71dso2133446pfu.21
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 16:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=Scvb2gfJzrYfNJq90EL74fT7SS7nVGstZhceM9SRTyY=;
        b=CPqsJcRdPyzWVw2UkNu0Wn9hUr9Qxq5bXEX1GOFSOmGUzn4ZXDSKec71mwcN+FHo9/
         J7Hl7xy+UKc/xgVNUN88urCR/U61zjMcY6asIwsJ1NN2YS9qGf+aKvKCDIrLpWvwMxY7
         2BngKUPmIzEBdYGZPYHGwKJ9jNq1gVsHj9z0RLCoU1r/NmEOi3G9vIVtbVYCcORZAjlI
         UndfdDGE3KQaTr65pLvCdgbH6llmSIJz96OFnUlXCMFadPkBkt7tK63U5VkNx63TbLCo
         ERRq3MYzS7Mvlz1HG8GN5rM0km+KLmdMUSZjv6uehqHwlltzlCfbOOiB7zBMlniQMnlZ
         qqtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=Scvb2gfJzrYfNJq90EL74fT7SS7nVGstZhceM9SRTyY=;
        b=MnyUH+A8DaHUFnxiu4wXvae5D8ApyB9Syoz3wrhduRN7Kh+fn01BPN3pdS0dO4slPc
         mOLETo7bqNpxs+1Shj5jqoYtmHAfLpsnclLjN3OXrEXmRE9jzcGt+SNoDjaCrAgOJJt3
         6EjNlgch+iraErQ2Etdj60SP3euyRdc6fL1/BCk2fgkWhIKmhnLyxu5o/NXpJuJJc4j6
         Lawy6q49gyQ0DtQsm1pO3fMlJZ+RlTisAyv58ZgizKTu2C3gfFYIGFmnvucJkL7xA3zg
         NuPHJfKYgGsEE8Wtodf9A6HxZkCNk0yDICHnItb1uGHAIeQUiW8ddrAGF/2gHOudDWbZ
         IPXQ==
X-Gm-Message-State: AOAM532GNovmsFw5hTAurydQaWh10f8i8ZghTXY1uUx/NRoJX4NpQ3iq
        1O7075HiZLNQ1+YPAF736KVqIJf8kuk=
X-Google-Smtp-Source: ABdhPJyqChTXz2F80g0qJy/+xySrxm2DGETkwfuo5JqfDwHZAekTYYLYUCbmnHGiPShsiTlZr2Nz/k/ji+0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e9c6:b029:12d:4cb3:3985 with SMTP
 id 6-20020a170902e9c6b029012d4cb33985mr9312260plk.56.1629330980601; Wed, 18
 Aug 2021 16:56:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 18 Aug 2021 23:56:15 +0000
Message-Id: <20210818235615.2047588-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH] KVM: x86/mmu: Complete prefetch for trailing SPTEs for
 direct, legacy MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make a final call to direct_pte_prefetch_many() if there are "trailing"
SPTEs to prefetch, i.e. SPTEs for GFNs following the faulting GFN.  The
call to direct_pte_prefetch_many() in the loop only handles the case
where there are !PRESENT SPTEs preceding a PRESENT SPTE.

E.g. if the faulting GFN is a multiple of 8 (the prefetch size) and all
SPTEs for the following GFNs are !PRESENT, the loop will terminate with
"start = sptep+1" and not prefetch any SPTEs.

Prefetching trailing SPTEs as intended can drastically reduce the number
of guest page faults, e.g. accessing the first byte of every 4kb page in
a 6gb chunk of virtual memory, in a VM with 8gb of preallocated memory,
the number of pf_fixed events observed in L0 drops from ~1.75M to <0.27M.

Note, this only affects memory that is backed by 4kb pages as KVM doesn't
prefetch when installing hugepages.  Shadow paging prefetching is not
affected as it does not batch the prefetches due to the need to process
the corresponding guest PTE.  The TDP MMU is not affected because it
doesn't have prefetching, yet...

Fixes: 957ed9effd80 ("KVM: MMU: prefetch ptes when intercepted guest #PF")
Cc: Sergey Senozhatsky <senozhatsky@google.com>
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Cc'd Ben as this highlights a potential gap with the TDP MMU, which lacks
prefetching of any sort.  For large VMs, which are likely backed by
hugepages anyways, this is a non-issue as the benefits of holding mmu_lock
for read likely masks the cost of taking more VM-Exits.  But VMs with a
small number of vCPUs won't benefit as much from parallel page faults,
e.g. there's no benefit at all if there's a single vCPU.

 arch/x86/kvm/mmu/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a272ccbddfa1..daf7df35f788 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2818,11 +2818,13 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
 			if (!start)
 				continue;
 			if (direct_pte_prefetch_many(vcpu, sp, start, spte) < 0)
-				break;
+				return;
 			start = NULL;
 		} else if (!start)
 			start = spte;
 	}
+	if (start)
+		direct_pte_prefetch_many(vcpu, sp, start, spte);
 }
 
 static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
-- 
2.33.0.rc1.237.g0d66db33f3-goog

