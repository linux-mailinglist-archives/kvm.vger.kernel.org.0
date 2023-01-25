Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6DF367B851
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 18:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236201AbjAYRWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 12:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236191AbjAYRWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 12:22:18 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6A0367E0
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 09:22:16 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id k18so18510515pll.5
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 09:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J5q09ceLJBkpBwTbTm4c7I5DmoetL/obPF+nJ893yTw=;
        b=GwTmmaRoIOeTt3q4z2fd6NmJrGhzMQzQPPL/YIra1PLM0ZhW18kPMbuBA0wdC9EAIN
         NSzHFH4sVBYNcJ4PdWgWpWzD5bFHXjI3nzHVd/SOd+X/5vEzlolKVPcGlhZLOUgCGbU7
         3whem4nEBodsJ2g8qpGKyhySk2Ot7+FIKWU5EJaGZFFjoub1pfvz0ZHahnC6RZ622qW9
         rsKr/KfwwQdXirtXDxufRLf6V7/2W79hjOf2A77LIVzHc+qFvBwJRMx9T/agRFwLh1h2
         ImzEXdOuJVlLzPrjk94FmmPh2DAK1+TZZhnBEWYxkaDchllcfzbP3gsn6ldljqzBzO0I
         57rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J5q09ceLJBkpBwTbTm4c7I5DmoetL/obPF+nJ893yTw=;
        b=E4TwfPIH78BdJ9dPo5f8taUSEGVSP5kbjMIBOCe9rZaEz2rGxyNPCGuJrFEaQElWPt
         Ro6G4aVkgv/W28C0SdZNMCn8aVF8k40rzqcOcD8G/svU7EREcz2AVrhMblSZCIFgqAo2
         q9Me5hKAvr3YrUO/6QNTCcy+Ko/A1xaw+gXFO4vzdWT5qKVTPbMyu4UGy6u1qNd4L1UC
         oGcYySOKxPrTP8iwq3kL0vvR6sXq1pYt0kvuC7rf/uXmoxahxLTPBxWFmKegnjYvdz0+
         9s89B/F88mPZoOXpoNB0vtcCQ3Ag+8SsLXqc3Hrd3UlLpfwRK+E7HMLEHfSKa53RnuOe
         dz0g==
X-Gm-Message-State: AO0yUKUd0rcpbmi70kFFZ+ssmT0ka/8aOtGhtXO7RQo7YHE3ELDJ4LJT
        PR3dlqs5eaIOaSIhd1aO2TfteQ==
X-Google-Smtp-Source: AK7set9xx1pXmn6wrJ+W9AiRYQuZ+Lo8dB0nJxH1gO0W40jM1S4cMhm0+BQvBvhXMpA7wv1arRY3WQ==
X-Received: by 2002:a17:903:2644:b0:189:b910:c6d2 with SMTP id je4-20020a170903264400b00189b910c6d2mr605376plb.1.1674667336060;
        Wed, 25 Jan 2023 09:22:16 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x5-20020a1709029a4500b00192a04bc620sm3850704plv.295.2023.01.25.09.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 09:22:14 -0800 (PST)
Date:   Wed, 25 Jan 2023 17:22:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v11 030/113] KVM: x86/mmu: Replace hardcoded value 0 for
 the initial value for SPTE
Message-ID: <Y9Fj/vgPEzfU1eof@google.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <dee30f0562d8be0102547d8eb9fc77736eae679d.1673539699.git.isaku.yamahata@intel.com>
 <20230125112434.0000512a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125112434.0000512a@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 25, 2023, Zhi Wang wrote:
> On Thu, 12 Jan 2023 08:31:38 -0800
> isaku.yamahata@intel.com wrote:
> 
> This refactor patch is quite hacky.
> 
> Why not change the purpose of vcpu->arch.mmu_shadow_page.gfp_zero and let the
> callers respect that the initial value of spte can be configurable? It will be
> generic and not TDX-specific, then kvm_init_shadow_page() is not required,
> mmu_topup_shadow_page_cache() can be left un-touched as the refactor can cover
> other architectures.
> 
> 1) Let it store the expected nonpresent value and rename it to nonpresent_spte.


I agree that handling this in the common code would be cleaner, but repurposing
gfp_zero gets kludgy because it would require a magic value to say "don't initialize
the data", e.g. x86's mmu_shadowed_info_cache isn't pre-filled.

And supporting a custom 64-bit init value for kmem_cache-backed caches would require
restricting such caches to be a multiple of 8 bytes in size.

How about this?  Lightly tested.

From: Sean Christopherson <seanjc@google.com>
Date: Wed, 25 Jan 2023 16:55:01 +0000
Subject: [PATCH] KVM: Allow page-sized MMU caches to be initialized with
 custom 64-bit values

Add support to MMU caches for initializing a page with a custom 64-bit
value, e.g. to pre-fill an entire page table with non-zero PTE values.
The functionality will be used by x86 to support Intel's TDX, which needs
to set bit 63 in all non-present PTEs in order to prevent !PRESENT page
faults from getting reflected into the guest (Intel's EPT Violation #VE
architecture made the less than brilliant decision of having the per-PTE
behavior be opt-out instead of opt-in).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_types.h |  1 +
 virt/kvm/kvm_main.c       | 16 ++++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 76de36e56cdf..67972db17b55 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -94,6 +94,7 @@ struct kvm_mmu_memory_cache {
 	int nobjs;
 	gfp_t gfp_zero;
 	gfp_t gfp_custom;
+	u64 init_value;
 	struct kmem_cache *kmem_cache;
 	int capacity;
 	void **objects;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331..78f1e49179a7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -380,12 +380,17 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
 static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 					       gfp_t gfp_flags)
 {
+	void *page;
+
 	gfp_flags |= mc->gfp_zero;
 
 	if (mc->kmem_cache)
 		return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
-	else
-		return (void *)__get_free_page(gfp_flags);
+
+	page = (void *)__get_free_page(gfp_flags);
+	if (page && mc->init_value)
+		memset64(page, mc->init_value, PAGE_SIZE / sizeof(mc->init_value));
+	return page;
 }
 
 int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
@@ -400,6 +405,13 @@ int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity,
 		if (WARN_ON_ONCE(!capacity))
 			return -EIO;
 
+		/*
+		 * Custom init values can be used only for page allocations,
+		 * and obviously conflict with __GFP_ZERO.
+		 */
+		if (WARN_ON_ONCE(mc->init_value && (mc->kmem_cache || mc->gfp_zero)))
+			return -EIO;
+
 		mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
 		if (!mc->objects)
 			return -ENOMEM;

base-commit: 503f0315c97739d3f8e645c500d81757dfbf76be
-- 

