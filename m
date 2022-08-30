Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5896E5A7118
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 00:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiH3WtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 18:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiH3WtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 18:49:17 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC501573C
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 15:49:16 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id l65so2394486pfl.8
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 15:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=5oVGlJD5RlpBf+9i4Q45ZK+hg97pjNTENblv1UXq3mI=;
        b=a2RBon5JNWe3lm0XYeQauPY76q6W2TLM+z8FitojgMaKdSmaQlb6yyVmHkhA/GD2m/
         cC5zmwa1XAV64X5H6e35KV4icyiHKe3Wi0+1fN2+WWwAxXfms+jqFCSyBKSmUV5xUmG/
         o4ps6SIQQE5nCz5X75SpO3DbIgbzM+HEcQq2S7a3uHaigKrFVd9Mj/1ygcm7tcvZva6F
         m2llpT20jV3TgGoMSebcQ06SbKyy3PB7grIz7ahMHa6kUdYPxpOaFcqaZGUUXbszMaqg
         fraBOme/Rsv25LSBMP2rKk58LZr0e4SmoXiQFQt2sj5L9o/BiEaqxuRlS7+lf7RL1hp0
         174g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=5oVGlJD5RlpBf+9i4Q45ZK+hg97pjNTENblv1UXq3mI=;
        b=FoijrvcE4FCET1qzwyLwDGxg/wGvlgi1GksTQiRV7GHO5KyK03X1H10N/3MDD5r2J1
         DwDeEsooZX7Fz41Bu9kIRxrULAi57XLZt7B9KyFHarDNmXgU9Yr6l8Nj11DBAYSLXx82
         95+Nav8Db1GQhX+irSad8GjFjYxv3K21lIyFv9/KuLnSdBLgQgwmb2hW5ZAGuzCs2NMX
         5EO58fHpNmMDSaQdFg7gWJktf5I1VDw6WIuEru4+NNvHISMTkHpN6fmtPt6T8XpHwter
         BRAgyCrqyCHnMHQJZRXvbDiImnqftRHS4yRIm/eufJzNNl5lRdETM71R/tsJBOnGEGhN
         II2w==
X-Gm-Message-State: ACgBeo1uPMHnImZ7WMi4RPdhHXHWG5pTsNFEpjwW/0S8B75HFVTEhoks
        UDVnxfXe3i4Hwp9WBeLtSrG2kQ==
X-Google-Smtp-Source: AA6agR5ucf7AY4Hf9zxzxqljlu4xWd8WTb4l/ihE6IyhFh+R+7yPhC7zESFtQu1dU8jXxRWFTZHAbg==
X-Received: by 2002:a05:6a00:230f:b0:52f:6734:90fe with SMTP id h15-20020a056a00230f00b0052f673490femr23777723pfh.67.1661899755594;
        Tue, 30 Aug 2022 15:49:15 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k18-20020aa79732000000b00539aa7f0b53sm2237687pfg.104.2022.08.30.15.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 15:49:15 -0700 (PDT)
Date:   Tue, 30 Aug 2022 22:49:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatclack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v5 07/13] KVM: selftests: Change ____vm_create() to take
 struct kvm_vm_mem_params
Message-ID: <Yw6T591G5hGTBx2t@google.com>
References: <20220823234727.621535-1-ricarkol@google.com>
 <20220823234727.621535-8-ricarkol@google.com>
 <20220829172508.oc3rr44q2irwudi5@kamzik>
 <Yw6JAiIfenYafJnZ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yw6JAiIfenYafJnZ@google.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022, Ricardo Koller wrote:
> On Mon, Aug 29, 2022 at 07:25:08PM +0200, Andrew Jones wrote:
> > On Tue, Aug 23, 2022 at 11:47:21PM +0000, Ricardo Koller wrote:
> > I feel we'll be revisiting this frequently when more and more region types
> > are desired. For example, Sean wants a read-only memory region for ucall
> > exits. How about putting a mem slot array in struct kvm_vm, defining an
> > enum to index it (which will expand), and then single helper function,
> > something like
> > 
> >  inline struct userspace_mem_region *
> >  vm_get_mem_region(struct kvm_vm *vm, enum memslot_type mst)
> >  {
> >     return memslot2region(vm, vm->memslots[mst]);
> >  }


> > 
> > > +
> > >  /* Minimum allocated guest virtual and physical addresses */
> > >  #define KVM_UTIL_MIN_VADDR		0x2000
> > >  #define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
> > > @@ -637,19 +662,51 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> > >  			      vm_paddr_t paddr_min, uint32_t memslot);
> > >  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
> > >  
> > > +#define MEM_PARAMS_MAX_MEMSLOTS 3
> > 
> > And this becomes MEMSLOT_MAX of the enum proposed above
> > 
> >  enum memslot_type {
> >      MEMSLOT_CODE,
> >      MEMSLOT_PT,
> >      MEMSLOT_DATA,

"memslot" is going to be confusing, e.g. MEMSLOT_MAX is some arbitrary selftests
constant that has no relationship to maximum number of memslots.

> >      MEMSLOT_MAX,

I dislike "max" because it's ambiguous, e.g. is it the maximum number of regions,
or is the max valid region?

Maybe something like this?

	enum kvm_mem_region_type {
		MEM_REGION_CODE
		...
		NR_MEM_REGIONS,
	}

> > > +#else
> > > +	.mode = VM_MODE_DEFAULT,
> > > +#endif
> > > +	.region[0] = {
> > > +		.src_type = VM_MEM_SRC_ANONYMOUS,
> > > +		.guest_paddr = 0,
> > > +		.slot = 0,
> > > +		/*
> > > +		 * 4mb when page size is 4kb. Note that vm_nr_pages_required(),
> > > +		 * the function used by most tests to calculate guest memory
> > > +		 * requirements uses around ~520 pages for more tests.
> > 
> > ...requirements, currently returns ~520 pages for the majority of tests.
> > 
> > > +		 */
> > > +		.npages = 1024,
> > 
> > And here we double it, but it's still fragile. I see we override this
> > in __vm_create() below though, so now I wonder why we set it at all.
> > 
> 
> I would prefer having a default that can be used by a test as-is. WDYT?
> or should we make it explicit that the default needs some updates?

In that case, the default should be '0'.  There are two users of ____vm_create().
__vm_create() takes the number of "extra" pages and calculates the "base" number
of pages.  vm_create_barebones() passes '0', i.e. can use default.

If '0' as a default is too weird, make it an illegal value and force the caller
to define the number of pages.

It's not a coincidence that those are the only two callers, ____vm_create() isn't
intended to be used directly.  If a test wants to create a VM just to create a VM,
then it shoulid use vm_create_barebones().  If a test wants to doing anything
remotely useful with the VM, it should use __vm_create() or something higher up
the food chain.
