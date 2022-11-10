Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA4A6247EA
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 18:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiKJRIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 12:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiKJRIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 12:08:37 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7114F014
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 09:08:35 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id io19so1905006plb.8
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 09:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nRQuXqcUtfQmNIksN5/1t8kBssbiiIxweCqGDd8OEas=;
        b=ELYRjI5dh4L1PT50/7AHYO926pWhOaTy/zi41yx6KPSbcyWjuFpGeYUPc94V8xxxn2
         TxsLPFJaIft4PmC91dzX8rfABlYRdBDPE1jhLVcP57skLwE+GkjQIiPGY1yyfwSD/MST
         HCIX9IPsr826w7PfXRZBQdOosRCTCVJcm84Mif9ZFSGr0707leBBV1v/0+xzDzq7BA/1
         J+XouLQiZ5Dl3GTLt2O21KOT57LNY0qxXdIxm9hOIKnt4mTPr55aeW6Rdl5zNyC1vn59
         gXL1aTr7tUES23PE9KpiZalFtXALVgO2DCAqg4v1D4IWnIl3VVxdPPIggt7wYjSBiiP/
         MBNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nRQuXqcUtfQmNIksN5/1t8kBssbiiIxweCqGDd8OEas=;
        b=f8SG/rlIQpp5TRZH1RyvsyDep4T36Bq+/U4CGG7gGggbehfWLj+OF6v9FipFfTOixj
         zweJ/fwMT419MHZdFjNT8/0ANeCz6ojDD3viv7nGLRiol2wdTv6vbQ1MZLKFzKhFGn0T
         DGZbZ7O4/oJzIsydme8ZiZtlXF3DqLj9D1foprftbG6zczZ/KzAXeTFfQyq4/pw5NhMW
         rWoRsYxXF8kC91IYTsUvaVAaGYXoDPlxR2KXxoe1vE8GhDuZibqKVLZEE0eFp9ZaCllx
         H2HOxjs9TMZ7xCWpZkrHcn6WKqJL4gVzBqsRyzdOLt/aLGiM5ht7o8xmMYlEfDBF57ps
         gTiQ==
X-Gm-Message-State: ACrzQf0MM0KBPJydhxzC9KWQmMg4g3qPYHfkq/LBwl8ShBb/tTlGMZU8
        g8V9qwz9zFMw2eDRHuexT6PpoA==
X-Google-Smtp-Source: AMsMyM7U9Pvd4i5mQq0KAvOvR31HkTpN+8MRdVU7e6tfFtDeUsNjpriH9ZsU6jtRaCNcD9vQfapZtA==
X-Received: by 2002:a17:90b:394c:b0:212:d9fe:a94 with SMTP id oe12-20020a17090b394c00b00212d9fe0a94mr1514938pjb.58.1668100115142;
        Thu, 10 Nov 2022 09:08:35 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d7-20020a170903230700b00172fad607b3sm11518854plh.207.2022.11.10.09.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 09:08:34 -0800 (PST)
Date:   Thu, 10 Nov 2022 17:08:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Don't rely on page-track mechanism to
 flush on memslot change
Message-ID: <Y20wDoCz90jhxrU6@google.com>
References: <20221110014821.1548347-1-seanjc@google.com>
 <20221110014821.1548347-2-seanjc@google.com>
 <Y2xheotNkWPVKsIl@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2xheotNkWPVKsIl@yzhao56-desk.sh.intel.com>
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

On Thu, Nov 10, 2022, Yan Zhao wrote:
> On Thu, Nov 10, 2022 at 01:48:20AM +0000, Sean Christopherson wrote:
> > Call kvm_mmu_zap_all_fast() directly when flushing a memslot instead of
> > bounding through the page-track mechanism.  KVM (unfortunately) needs to
> > zap and flush all page tables on memslot DELETE/MOVE irrespective of
> > whether KVM is shadowing guest page tables.
> > 
> > This will allow changing KVM to register a page-track notifier on the
> > first shadow root allocation, and will also allow deleting the misguided
> > kvm_page_track_flush_slot() hook itself once KVM-GT also moves to a
> > different method for reacting to memslot changes.
> >
> <...>
> > @@ -6021,7 +6014,6 @@ int kvm_mmu_init_vm(struct kvm *kvm)
> >  		return r;
> >  
> >  	node->track_write = kvm_mmu_pte_write;
> > -	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
> >  	kvm_page_track_register_notifier(kvm, node);
> >  
> >  	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index e46e458c5b08..5da86fe3c113 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12550,6 +12550,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
> >  void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> >  				   struct kvm_memory_slot *slot)
> >  {
> > +	kvm_mmu_zap_all_fast(kvm);
> > +
> >  	kvm_page_track_flush_slot(kvm, slot);
> Could we move this kvm_page_track_flush_slot() to right before
> kvm_commit_memory_region()?

More or less.  The page-track stuff is x86-specific, just move it into x86's
kvm_arch_commit_memory_region().

> As KVM now does not need track_flush_slot any more and kvmgt is the only user
> to track_flush_slot, we can rename it to track_slot_changed to notify
> the new/deleted/moved slot.
> Do you think it's good?

Given that KVM/KVM-GT have never propery supported the MOVE case, and (IIUC) that
there's no danger to the kernel if KVM-GT fails to write-protect a moved memslot,
I would say just change the hook to ->remove_memslot().  I.e. even if the memslot
is being moved, simply notify KVM-GT that the old memslot is being removed.

E.g.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5a2821ca03b8..437e3832e377 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12566,6 +12566,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
                                const struct kvm_memory_slot *new,
                                enum kvm_mr_change change)
 {
+       if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
+               kvm_page_track_remove_memslot(kvm, old);
+
        if (!kvm->arch.n_requested_mmu_pages &&
            (change == KVM_MR_CREATE || change == KVM_MR_DELETE)) {
                unsigned long nr_mmu_pages;
