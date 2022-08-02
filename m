Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAE5588255
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 21:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbiHBTMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 15:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbiHBTMK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 15:12:10 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D4352DF0
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 12:12:08 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id f65so13142076pgc.12
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 12:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Lzh05/MVIvmRXluV/iPK6sjy7F3Sc7uR2smDUnmMA2U=;
        b=TQ/So6ZXRGZCtEIeql4A0pMhjBpWJPvD1ubzp4krRXbZGZ2NJ7EiRRSHnO4tm7wCfb
         tDTFF51uD20Llmy1oWg6WHRcPTiIqYWfsDmx5SxQsUuyVZe+IexZ1/aVgPiFjyJPAxit
         2d58th1+XjcXxmqVQKdUYb0qbvcl2LEtz4kKHI4DDpOVZxBlU9/Sl8YpAu0rczIw9xFN
         /GxIhRuYzhInj9FBkVul/gsDNr/vydv+N07bBw604r37TlfZWnpNeUeYGUjQM38Gq2t/
         oKPRXlyzCtpxkIWXHb2a865tF5CWmoFqXZ17E8DPQdOrLLNBBSVsoGwAaG41htuI1NKV
         viXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Lzh05/MVIvmRXluV/iPK6sjy7F3Sc7uR2smDUnmMA2U=;
        b=djovvmKYvk7M9Pw9PGZoiSQbNVgnPWCfOAx2rcLgoY9uWxfVodBpgQsObQ/s0s+145
         3/kZd1KioX/C+D7Ba2dRYAkvxI1PGY0z6I+RTudCZIkMXssubWeUX44obuWSv0GhFh8/
         BoHghjE0gQOv23xmW22lAPW+4IrP/Tuo7Ob42awFPD8kjgG+nUocPl2TJq+dwn2ys4k/
         wXa59tCPp55UXThkbCcBkARjFFpT4rX3E5tWQPsbO9pMyl0ggt8KRX3WjAet+pwaQh7C
         9qtCQLzlhNS4cJFQyvxzj5Pl+59uXBIFEChhXJEIUwDEsZSYJHKJLtgI3D6CyFxtYf+R
         9S9A==
X-Gm-Message-State: AJIora/XEWSqlqZ4CKxTut0NdI4IHCelLhDtHjijmS7q1aN2drvF7jQv
        icduoNFPTdooG218kxIg+ivuqB8oZ9a6/A==
X-Google-Smtp-Source: AGRyM1t2mbtKbhKp0Uretgl9LSAymIzwBRDCeZsdgPG2cmkUl9fOjI2q8KYEN3xgPJaVN4z2VFRQ7w==
X-Received: by 2002:a05:6a00:1797:b0:52a:f2e9:ddd2 with SMTP id s23-20020a056a00179700b0052af2e9ddd2mr21610419pfg.12.1659467528086;
        Tue, 02 Aug 2022 12:12:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 68-20020a621747000000b0052d3a442760sm6428870pfx.161.2022.08.02.12.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 12:12:07 -0700 (PDT)
Date:   Tue, 2 Aug 2022 19:12:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Make page tables for eager page splitting
 NUMA aware
Message-ID: <Yul3A4CmaAHMui2Z@google.com>
References: <20220801151928.270380-1-vipinsh@google.com>
 <YuhPT2drgqL+osLl@google.com>
 <YuhoJUoPBOu5eMz8@google.com>
 <YulRZ+uXFOE1y2dj@google.com>
 <YuldSf4T2j4rIrIo@google.com>
 <4ccbafb5-9157-ec73-c751-ec71164f8688@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ccbafb5-9157-ec73-c751-ec71164f8688@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022, Paolo Bonzini wrote:
> On 8/2/22 19:22, Sean Christopherson wrote:
> > Userspace can already force the ideal setup for eager page splitting by configuring
> > vNUMA-aware memslots and using a task with appropriate policy to toggle dirty
> > logging.  And userspace really should be encouraged to do that, because otherwise
> > walking the page tables in software to do the split is going to be constantly
> > accessing remote memory.
> 
> Yes, it's possible to locate the page tables on the node that holds the
> memory they're mapping by enable dirty logging from different tasks for
> different memslots, but that seems a bit weird.

Gah, I misread this patch.  More below.

But FWIW, my understanding is that Google's userspace already creates per-node
memslots with dedicated tasks for dirty logging operations.  There are multiple
advantages to such a setup, e.g. slots can be processed in parallel (with the
TDP MMU), and when the VM enters blackout the tasks can be affined to the physical
CPUs that were just vacated by the VM.

> Walking the page tables in software is going to do several remote memory
> accesses, but it will do that in a thread that probably is devoted to
> background tasks anyway.

I agree that enabling dirty logging isn't exactly performance critical, but reaping
the dirty log is very much in the critical path.  My point is that userspace that
cares about NUMA should be encouraged to create an optimal setup, at which point
this one-off override is unnecessary.

> The relative impact of remote memory accesses in the thread that enables
> dirty logging vs. in the vCPU thread should also be visible in the overall
> performance of dirty_log_perf_test.
> 
> So I agree with Vipin's patch and would even extend it to all page table
> allocations,

Ah crud, I misread the patch.  I was thinking tdp_mmu_spte_to_nid() was getting
the node for the existing shadow page, but it's actually getting the node for the
underlying physical huge page.

That means this patch is broken now that KVM doesn't require a "struct page" to
create huge SPTEs (commit  a8ac499bb6ab ("KVM: x86/mmu: Don't require refcounted
"struct page" to create huge SPTEs").  I.e. this will explode as pfn_to_page()
may return garbage.

	return page_to_nid(pfn_to_page(spte_to_pfn(spte)));

That said, I still don't like this patch, at least not as a one-off thing.  I do
like the idea of having page table allocations follow the node requested for the
target pfn, what I don't like is having one-off behavior that silently overrides
userspace policy.

I would much rather we solve the problem for all page table allocations, maybe
with a KVM_CAP or module param?  Unfortunately, that's a very non-trivial change
because it will probably require having a per-node cache in each of the per-vCPU
caches.

Hmm, actually, a not-awful alternative would be to have the fault path fallback
to the current task's policy if allocation fails.  I.e. make it best effort.

E.g. as a rough sketch...

---
 arch/x86/kvm/mmu/tdp_mmu.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bf2ccf9debca..e475f5b55794 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -273,10 +273,11 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,

 static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 {
+	struct kvm_mmu_memory_cache *cache = &vcpu->arch.mmu_shadow_page_cache;
 	struct kvm_mmu_page *sp;

 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	sp->spt = kvm_mmu_alloc_shadow_page_table(cache, GFP_NOWAIT, pfn);

 	return sp;
 }
@@ -1190,7 +1191,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			if (is_removed_spte(iter.old_spte))
 				break;

-			sp = tdp_mmu_alloc_sp(vcpu);
+			sp = tdp_mmu_alloc_sp(vcpu, fault->pfn);
 			tdp_mmu_init_child_sp(sp, &iter);

 			if (tdp_mmu_link_sp(vcpu->kvm, &iter, sp, account_nx, true)) {
@@ -1402,17 +1403,39 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }

-static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
+void *kvm_mmu_alloc_shadow_page_table(struct kvm_mmu_memory_cache *cache,
+				      gfp_t gfp, kvm_pfn_t pfn)
+{
+	struct page *page = kvm_pfn_to_refcounted_page(pfn);
+	struct page *spt_page;
+	int node;
+
+	gfp |= __GFP_ZERO | __GFP_ACCOUNT;
+
+	if (page) {
+		spt_page = alloc_pages_node(page_to_nid(page), gfp, 0);
+		if (spt_page)
+			return page_address(spt_page);
+	} else if (!cache) {
+		return (void *)__get_free_page(gfp);
+	}
+
+	if (cache)
+		return kvm_mmu_memory_cache_alloc(cache);
+
+	return NULL;
+}
+
+static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp,
+							 kvm_pfn_t pfn)
 {
 	struct kvm_mmu_page *sp;

-	gfp |= __GFP_ZERO;
-
 	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
 	if (!sp)
 		return NULL;

-	sp->spt = (void *)__get_free_page(gfp);
+	sp->spt = kvm_mmu_alloc_shadow_page_table(NULL, gfp, pfn);
 	if (!sp->spt) {
 		kmem_cache_free(mmu_page_header_cache, sp);
 		return NULL;
@@ -1436,7 +1459,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 	 * If this allocation fails we drop the lock and retry with reclaim
 	 * allowed.
 	 */
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
+	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT);
 	if (sp)
 		return sp;


base-commit: f8990bfe1eab91c807ca8fc0d48705e8f986b951
--

