Return-Path: <kvm+bounces-9117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6BD85B118
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 04:06:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 828E81F21549
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 03:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AE2E42A90;
	Tue, 20 Feb 2024 03:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IroqynKE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09B42E63B;
	Tue, 20 Feb 2024 03:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708398388; cv=none; b=gl5W3mqLwIXN49LHzEURFoZsKSTfyLaHMSh2BBQUXh20zKzvlYsE0uRTe910h7N6sfcb5OGcXG8j92H2O/RGiDq9kYeYEHSznA5FaNLs/EHbt1SbjiovWsptTcmuFQ6U0da/PQU8UVtvfhjKnCXv5DimybyJotZlrHvLF5FuaYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708398388; c=relaxed/simple;
	bh=sxcoThFXCwxz9XD07S+k0pMDrGjzfOvzTwbN/tn5kak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fWupJrxzhV/aHMtGMcCrXe6uLw+TEaaauzJRLLEQB/3yfNnXGMNsnY/H3jAPSnJqjN9Wi6mlS6EYKlfydQkTZWtr1ITk7ED7BJNMI/1zUL2US44YMAhP1aCgzJAlr04lKxsw/vCMRs9h7Tpq1i2p0/YegT54M29UgW15ou+m1Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IroqynKE; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708398387; x=1739934387;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sxcoThFXCwxz9XD07S+k0pMDrGjzfOvzTwbN/tn5kak=;
  b=IroqynKEq5enuZJQum9VLYXlWXTqzh8n0gAubp8grt+57csZNQOpoLNg
   9dz6xYQJA6lrGZqLwR9XMLbpQL75yiW0pR0t69fw8VBvN5T77gQ0OxfFX
   3dihAR8GqKj4cRci3NILgrQWekIDQiC7X0M6NU16RBubhXYrvnyyge9Wl
   wROGvtyzKxx3IUScUny9/4WlsBJh/Q69gDzDzMHCEds9WUD7vhDZXNOyR
   NZNIvhBqIcXin5Vmqmug7vgIRpNnZpnPANVUBoDBNLR/xWF5ew9XOR6aE
   kY+HdWSr/nhlV1SCmrlLoL6R01tQYgfK5KP1r6OoyM8PEG0SJDf9aD8zZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2629215"
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="2629215"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2024 19:06:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,171,1705392000"; 
   d="scan'208";a="42141634"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 19 Feb 2024 19:06:24 -0800
Date: Tue, 20 Feb 2024 11:02:31 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 1/4] KVM: Always flush async #PF workqueue when vCPU is
 being destroyed
Message-ID: <ZdQWRy6z3N1MFoiX@yilunxu-OptiPlex-7050>
References: <20240110011533.503302-1-seanjc@google.com>
 <20240110011533.503302-2-seanjc@google.com>
 <ZdNerMaewrcrwBlL@yilunxu-OptiPlex-7050>
 <ZdN4_ENRMqeBIBkn@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdN4_ENRMqeBIBkn@google.com>

On Mon, Feb 19, 2024 at 07:51:24AM -0800, Sean Christopherson wrote:
> On Mon, Feb 19, 2024, Xu Yilun wrote:
> > >  void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
> > > @@ -114,7 +132,6 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
> > >  #else
> > >  		if (cancel_work_sync(&work->work)) {
> > >  			mmput(work->mm);
> > > -			kvm_put_kvm(vcpu->kvm); /* == work->vcpu->kvm */
> > >  			kmem_cache_free(async_pf_cache, work);
> > >  		}
> > >  #endif
> > > @@ -126,7 +143,18 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
> > >  			list_first_entry(&vcpu->async_pf.done,
> > >  					 typeof(*work), link);
> > >  		list_del(&work->link);
> > > -		kmem_cache_free(async_pf_cache, work);
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
> > > +		kvm_flush_and_free_async_pf_work(work);
> > 
> > I have a new concern when I re-visit this patchset.
> > 
> > Form kvm_check_async_pf_completion(), I see async_pf.queue is always a
> > superset of async_pf.done (except wake-all work, which is not within
> > concern).  And done work would be skipped from sync (cancel_work_sync()) by:
> > 
> >                 if (!work->vcpu)
> >                         continue;
> > 
> > But now with this patch we also sync done works, how about we just sync all
> > queued work instead.
> 
> Hmm, IIUC, I think we can simply revert commit 22583f0d9c85 ("KVM: async_pf: avoid
> recursive flushing of work items").

Ah, yes. This also make me clear about the history of the confusing spin_lock.
Reverting is good to me.

Thanks,
Yilun

