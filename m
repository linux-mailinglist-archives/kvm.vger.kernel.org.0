Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91CA77631C2
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 11:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjGZJXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 05:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbjGZJXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 05:23:14 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52841724;
        Wed, 26 Jul 2023 02:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690363255; x=1721899255;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dIscOWIWHCI9r4JeyCNAPmzvUhGTdgQYIaWvBvlNF98=;
  b=jskK1EaQVpZcLzSysCGV8y5qMYmIMfZd47UMUfnmbhSKV2hTm7kkFW2+
   YgGpDCBYos7JaTE86zi7LK+wMoeIEwp0I9Xp1hE1qqbrbja5p6undX5vC
   yziJtZgHjcEToWMkYrXTEt5fuUMgQMsys1fojIIgngCqOEj/rSkp9lC7Y
   1VNIQdKmWUnr37BtBLuxEezD85FKaKEXq1ODQsbIDLUI1SoZ3cnuWJzjk
   63UQTZzxai8i1JnDS0GobW9vuYVnCInIlJt0RckCeQuWqQr6yyZfl8yR9
   47pMI07kL1RRHI4gpLwh4KNRETAxb3fjJSi5vuLJ79kBmMtKytk+5UEWK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="366848360"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="366848360"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 02:20:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="720396885"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="720396885"
Received: from pdeng6-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.174.155])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 02:20:19 -0700
Date:   Wed, 26 Jul 2023 17:20:16 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
Subject: Re: [PATCH 5/5] KVM: x86/mmu: Use dummy root, backed by zero page,
 for !visible guest roots
Message-ID: <20230726092016.icy7lmdrd2dvclpb@linux.intel.com>
References: <20230722012350.2371049-1-seanjc@google.com>
 <20230722012350.2371049-6-seanjc@google.com>
 <20230725113628.z7vzxk5g6zdqlftg@linux.intel.com>
 <ZL/v7xDEllr5rU6W@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZL/v7xDEllr5rU6W@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023 at 08:53:19AM -0700, Sean Christopherson wrote:
> On Tue, Jul 25, 2023, Yu Zhang wrote:
> > > diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> > > index 122bfc0124d3..e9d4d7b66111 100644
> > > --- a/arch/x86/kvm/mmu/paging_tmpl.h
> > > +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> > > @@ -646,6 +646,17 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> > >  	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
> > >  		goto out_gpte_changed;
> > >  
> > > +	/*
> > > +	 * Load a new root and retry the faulting instruction in the extremely
> > > +	 * unlikely scenario that the guest root gfn became visible between
> > > +	 * loading a dummy root and handling the resulting page fault, e.g. if
> > > +	 * userspace create a memslot in the interim.
> > > +	 */
> > > +	if (unlikely(kvm_mmu_is_dummy_root(vcpu->arch.mmu->root.hpa))) {
> > > +		kvm_mmu_unload(vcpu);
> > 
> > Do we really need a kvm_mmu_unload()? Could we just set
> > vcpu->arch.mmu->root.hpa to INVALID_PAGE here?
> 
> Oof, yeah.  Not only is a full unload overkill, if this code were hit it would
> lead to deadlock because kvm_mmu_free_roots() expects to be called *without*
> mmu_lock held.
> 
> Hmm, but I don't love the idea of open coding a free/reset of the current root.
> I'm leaning toward
> 
> 		kvm_make_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu);
> 
> since it's conceptually similar to KVM unloading roots when a memslot is deleted
> or moved, just reversed.  That would obviously tie this code to KVM's handling of
> the dummy root just as much as manually invalidating root.hpa (probably more so),
> but that might actually be a good thing because then the rule for the dummy root
> is that it's always considered obsolete (when checked), and that could be
> explicitly documented in is_obsolete_root().
> 

Oh, right. KVM_REQ_MMU_FREE_OBSOLETE_ROOTS should work. Thanks!

B.R.
Yu
