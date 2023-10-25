Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C2A7D60DB
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 06:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjJYE0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 00:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbjJYE0a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 00:26:30 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1901134;
        Tue, 24 Oct 2023 21:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698207988; x=1729743988;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1zdjDP3Z0zigG3iX/C6RuVgtRdw2cSJlDEcn/F65EtA=;
  b=D9pp20sD6t2AB975mzbaA0hpYc5O6ITZUcH8NNDt9MzPAk66Ffuv6zfd
   K8jQnmfMI6gQixaGfTZZTHKcibvlMLbv57dQXpodFvOTVIkY+t7Cga3vD
   EzjuqVLWi7FYgWn0HnC7npZnZn3nMZ0ZOsWjsMBkr0iYKNcBxGjNe+w/p
   wdaVRBnOltxzt6kw5cWCVBNmYlf7pbUT66Rpi55Lm70dPWAKmjjQEZjDK
   MTrczSX2PPPlZeAZ7S+BqP3pzvYrFKxX1HfTHLSXWem6XrOttHh1mjtB8
   IQsJsQs3fMGj/ZSZtz9/wSkk8RlOV6BokVObCvTnRkmo0orB4aA9c9cUx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="451459479"
X-IronPort-AV: E=Sophos;i="6.03,249,1694761200"; 
   d="scan'208";a="451459479"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 21:26:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="932243175"
X-IronPort-AV: E=Sophos;i="6.03,249,1694761200"; 
   d="scan'208";a="932243175"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orsmga005.jf.intel.com with ESMTP; 24 Oct 2023 21:26:25 -0700
Date:   Wed, 25 Oct 2023 12:25:11 +0800
From:   Xu Yilun <yilun.xu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 2/3] KVM: Always flush async #PF workqueue when vCPU is
 being destroyed
Message-ID: <ZTiYp8nMGImoWzBZ@yilunxu-OptiPlex-7050>
References: <20231018204624.1905300-1-seanjc@google.com>
 <20231018204624.1905300-3-seanjc@google.com>
 <ZTd+i2I5n0NyzuuT@yilunxu-OptiPlex-7050>
 <ZTfnhEocglG1AsO8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTfnhEocglG1AsO8@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 08:49:24AM -0700, Sean Christopherson wrote:
> On Tue, Oct 24, 2023, Xu Yilun wrote:
> > On Wed, Oct 18, 2023 at 01:46:23PM -0700, Sean Christopherson wrote:
> > > @@ -126,7 +124,19 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
> > >  			list_first_entry(&vcpu->async_pf.done,
> > >  					 typeof(*work), link);
> > >  		list_del(&work->link);
> > > +
> > > +		spin_unlock(&vcpu->async_pf.lock);
> > > +
> > > +		/*
> > > +		 * The async #PF is "done", but KVM must wait for the work item
> > > +		 * itself, i.e. async_pf_execute(), to run to completion.  If
> > > +		 * KVM is a module, KVM must ensure *no* code owned by the KVM
> > > +		 * (the module) can be run after the last call to module_put(),
> > > +		 * i.e. after the last reference to the last vCPU's file is put.
> > > +		 */
> > > +		flush_work(&work->work);
> > 
> > I see the flush_work() is inside the check:
> > 
> >   while (!list_empty(&vcpu->async_pf.done))
> > 
> > Is it possible all async_pf are already completed but the work item,
> > i.e. async_pf_execute, is not completed before this check? That the
> > work is scheduled out after kvm_arch_async_page_present_queued() and
> > all APF_READY requests have been handled. In this case the work
> > synchronization will be skipped...
> 
> Good gravy.  Yes, I assumed KVM wouldn't be so crazy to delete the work before it
> completed, but I obviously didn't see this comment in async_pf_execute():
> 
> 	/*
> 	 * apf may be freed by kvm_check_async_pf_completion() after
> 	 * this point
> 	 */
> 
> The most straightforward fix I see is to also flush the work in
> kvm_check_async_pf_completion(), and then delete the comment.  The downside is
> that there's a small chance a vCPU could be delayed waiting for the work to
> complete, but that's a very, very small chance, and likely a very small delay.
> kvm_arch_async_page_present_queued() unconditionaly makes a new request, i.e. will
> effectively delay entering the guest, so the remaining work is really just:
> 
>  	trace_kvm_async_pf_completed(addr, cr2_or_gpa);
> 
> 	__kvm_vcpu_wake_up(vcpu);
> 
> 	mmput(mm);
> 
> Since mmput() can't drop the last reference to the page tables if the vCPU is
> still alive.

OK, seems the impact is minor. I'm good to it.

Thanks,
Yilun

> 
> I think I'll spin off the async #PF fix to a separate series.  There's are other
> tangetially related cleanups that can be done, e.g. there's no reason to pin the
> page tables while work is queued, async_pf_execute() can do mmget_not_zero() and
> then bail if the process is dying.  Then there's no need to do mmput() when
> canceling work.
