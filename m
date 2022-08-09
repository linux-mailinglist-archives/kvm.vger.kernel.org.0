Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E981B58DA7C
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 16:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244181AbiHIOo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 10:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239432AbiHIOoY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 10:44:24 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F691CB1D
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 07:44:24 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id s206so11561969pgs.3
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 07:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=sQaSKkyDjB+FQ3HzSLhOg2i25ze0crFVErbWzPkt/Zc=;
        b=TtPlrcxxlmo9ZkUT8y1+7uhoK/yYlArtMOuSYswo0SbRQ/o1/yipPl94rPdlURLWsP
         2q//srgE5YLXE/xmtbf2rOobJeXNWnA4oa2iHliH7RQ5wI1rvNvgi+SkREBo0nnngEnE
         4e+PLdfAgWqjeCYc1N0qJyZrJ9xDXVHnCq8W/BVTuJ5+hD7RdZ+oTh28P4WR6ZXIfgLT
         16NZLP1d5E3Rp3jUPAZccbo3EdEQkPYV08AauJAv5FNtMcFfUUmcowCOs0QbNVZxSkwJ
         RKh1NVDxSN8lEijoyShLcvsrlUthqosuXDtyzGtuBYJw2DA1bxyYalLy23o2QONPZQn8
         vrlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=sQaSKkyDjB+FQ3HzSLhOg2i25ze0crFVErbWzPkt/Zc=;
        b=hq7pcSZH5NHridTviwOPJJ3wglKOZyCDeWME2y6j3T9OKsJRwKILlsFn5Bk74Bfb1y
         Q9LMtZifpfzsynvAKxerw64lVKjzAWx3lo/YfgWepL57ja4HcMIFM1tfDhlkfuU83bsm
         jtoMCmh4I2Nq3XOEvkMyQHAenawFBQMrz5xIYsjz3SAjRMmaNmELPGQnyrC1DD9DcigQ
         40RqG7R7m80Ic735sYeAAAdPyStc2M5/tMCtUBIRfg9TB1KAWK0W8h2k9R58Z6LISrSp
         UPJVosZ2ux8pCuHnR72G0N+5xaznCt9vcetYx2VzJPSv5VsNX1ysuxvc0yjwDtFwDGhB
         qAtg==
X-Gm-Message-State: ACgBeo3Lw/dP63G/td6wLKu5nnlimDzTkJiiUovo018MjWzuIB55ooKR
        CgR0h6Q665g/a82G7Zl7fYv18A==
X-Google-Smtp-Source: AA6agR7a9nCuq1rJkBxpRBMDI+gJdD7UQJPvNPjQ6amUFvnHsxM4MKFggber94U1O+ZzMgKjahIipw==
X-Received: by 2002:a05:6a00:1a88:b0:52f:52df:ce1d with SMTP id e8-20020a056a001a8800b0052f52dfce1dmr9515422pfv.13.1660056263396;
        Tue, 09 Aug 2022 07:44:23 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u8-20020a170903124800b0016f15140e55sm10849480plh.189.2022.08.09.07.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 07:44:22 -0700 (PDT)
Date:   Tue, 9 Aug 2022 14:44:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 5/8] KVM: x86/mmu: Set disallowed_nx_huge_page in TDP
 MMU before setting SPTE
Message-ID: <YvJyw96QZdf6YPAX@google.com>
References: <20220805230513.148869-1-seanjc@google.com>
 <20220805230513.148869-6-seanjc@google.com>
 <YvHT0dA0BGgCQ8L+@yzhao56-desk.sh.intel.com>
 <331dc774-c662-9475-1175-725cb2382bb2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <331dc774-c662-9475-1175-725cb2382bb2@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 09, 2022, Paolo Bonzini wrote:
> On 8/9/22 05:26, Yan Zhao wrote:
> > hi Sean,
> > 
> > I understand this smp_rmb() is intended to prevent the reading of
> > p->nx_huge_page_disallowed from happening before it's set to true in
> > kvm_tdp_mmu_map(). Is this understanding right?
> > 
> > If it's true, then do we also need the smp_rmb() for read of sp->gfn in
> > handle_removed_pt()? (or maybe for other fields in sp in other places?)
> 
> No, in that case the barrier is provided by rcu_dereference().  In fact, I
> am not sure the barriers are needed in this patch either (but the comments
> are :)):

Yeah, I'm 99% certain the barriers aren't strictly required, but I didn't love the
idea of depending on other implementation details for the barriers.  Of course I
completely overlooked the fact that all other sp fields would need the same
barriers...

> - the write barrier is certainly not needed because it is implicit in
> tdp_mmu_set_spte_atomic's cmpxchg64
> 
> - the read barrier _should_ also be provided by rcu_dereference(pt), but I'm
> not 100% sure about that. The reasoning is that you have
> 
> (1)	iter->old spte = READ_ONCE(*rcu_dereference(iter->sptep));
> 	...
> (2)	tdp_ptep_t pt = spte_to_child_pt(old_spte, level);
> (3)	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(pt));
> 	...
> (4)	if (sp->nx_huge_page_disallowed) {
> 
> and (4) is definitely ordered after (1) thanks to the READ_ONCE hidden
> within (3) and the data dependency from old_spte to sp.

Yes, I think that's correct.  Callers must verify the SPTE is present before getting
the associated child shadow page.  KVM does have instances where a shadow page is
retrieved from the SPTE _pointer_, but that's the parent shadow page, i.e. isn't
guarded by the SPTE being present.

	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(iter->sptep));

Something like this is as a separate patch?

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index f0af385c56e0..9d982ccf4567 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -13,6 +13,12 @@
  * to be zapped while holding mmu_lock for read, and to allow TLB flushes to be
  * batched without having to collect the list of zapped SPs.  Flows that can
  * remove SPs must service pending TLB flushes prior to dropping RCU protection.
+ *
+ * The READ_ONCE() ensures that, if the SPTE points at a child shadow page, all
+ * fields in struct kvm_mmu_page will be read after the caller observes the
+ * present SPTE (KVM must check that the SPTE is present before following the
+ * SPTE's pfn to its associated shadow page).  Pairs with the implicit memory
+ * barrier in tdp_mmu_set_spte_atomic().
  */
 static inline u64 kvm_tdp_mmu_read_spte(tdp_ptep_t sptep)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bf2ccf9debca..ca50296e3696 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -645,6 +645,11 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
        lockdep_assert_held_read(&kvm->mmu_lock);

        /*
+        * The atomic CMPXCHG64 provides an implicit memory barrier and ensures
+        * that, if the SPTE points at a shadow page, all struct kvm_mmu_page
+        * fields are visible to readers before the SPTE is marked present.
+        * Pairs with ordering guarantees provided by kvm_tdp_mmu_read_spte().
+        *
         * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
         * does not hold the mmu_lock.
         */
