Return-Path: <kvm+bounces-6463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E14D9832467
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 06:54:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA949284427
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 05:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89CFFDDD8;
	Fri, 19 Jan 2024 05:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DayTSKaJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24A4DDA2;
	Fri, 19 Jan 2024 05:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705643633; cv=none; b=U+jEHemEeVAPar4Ft9VCMwmFvnqZ3mzlSuprzWXCLtajkLZaQ7kHp1VAm0jrXZL30TkUPO7LmvXmUU+X6LEg3Ull15mVA68i6Aydm2hHrdCxjEcW8E/OhhecJ6SPfQwclRHOPxgctFJTXIEBQh3qWpCft+kW8+KLfNy1byvLdOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705643633; c=relaxed/simple;
	bh=Vp9nxJexgtr8mdtc7FvGbPvwmq4EfLjttckoabyscb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KjSGdN6vOdDDpySzqu8JguuYAIh9NxIyGiENHdqDH3YXlden6cCWYA+hXTKCpAO2m4528z9rEvSwxu5X5FC3RmIL4dn51zbqq/UMWtAWnauxBJeb0c0EiM0mwBTgwD6vSQE7pIyG74QTXOqY1aeznZ61RQ2Uj4jpSln1nDd5kOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DayTSKaJ; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705643632; x=1737179632;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Vp9nxJexgtr8mdtc7FvGbPvwmq4EfLjttckoabyscb0=;
  b=DayTSKaJcKXYuhevcmPTlCaBGS+77Hqh6oUBc76+1k91lKL090GsgHM7
   9kk2/IJi/y9M9EpWxMwwps+SU38WqnW3DtQO43EkX9VJCKd6l1Bzk4MAg
   2uTEcKoRu4MMo58dp+B4kwl4ydGxdXjv4VFR2w160pGdR+KRXUMPnxW9v
   hddtOZ3ta/kykhORWZHeAX3oZtLBBcj+IWjEMPW3SKQz93iD2oGFSbwvu
   3uH5u3VuE1p939E3KpnlqKnOjaVhnopwwkNzaYaBnfxJRaYmZDvq3ZT1p
   mi25HJ9ah5lp0o0Q2bGbKX9d8238JpW5xxdZCQV5yB/LIQ1tjaVfscBkn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="399541117"
X-IronPort-AV: E=Sophos;i="6.05,204,1701158400"; 
   d="scan'208";a="399541117"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 21:53:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,204,1701158400"; 
   d="scan'208";a="568772"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa004.fm.intel.com with ESMTP; 18 Jan 2024 21:53:49 -0800
Date: Fri, 19 Jan 2024 13:50:38 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
	Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Retry fault before acquiring mmu_lock
 if mapping is changing
Message-ID: <ZaoNrmgl+DUYdhGk@yilunxu-OptiPlex-7050>
References: <20240110012045.505046-1-seanjc@google.com>
 <ZalUDLVJSVN/rEf2@yilunxu-OptiPlex-7050>
 <ZaleXWn7reOI5yJY@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZaleXWn7reOI5yJY@google.com>

On Thu, Jan 18, 2024 at 09:22:37AM -0800, Sean Christopherson wrote:
> On Fri, Jan 19, 2024, Xu Yilun wrote:
> > On Tue, Jan 09, 2024 at 05:20:45PM -0800, Sean Christopherson wrote:
> > > Retry page faults without acquiring mmu_lock if the resolved gfn is covered
> > > by an active invalidation.  Contending for mmu_lock is especially
> > > problematic on preemptible kernels as the mmu_notifier invalidation task
> > > will yield mmu_lock (see rwlock_needbreak()), delay the in-progress
> > 
> > Is it possible fault-in task avoids contending mmu_lock by using _trylock()?
> > Like:
> > 
> > 	while (!read_trylock(&vcpu->kvm->mmu_lock))
> > 		cpu_relax();
> > 
> > 	if (is_page_fault_stale(vcpu, fault))
> > 		goto out_unlock;
> >   
> > 	r = kvm_tdp_mmu_map(vcpu, fault);
> > 
> > out_unlock:
> > 	read_unlock(&vcpu->kvm->mmu_lock)
> 
> It's definitely possible, but the downsides far outweigh any potential benefits.
> 
> Doing trylock means the CPU is NOT put into the queue for acquiring the lock,
> which means that forward progress isn't guaranteed.  E.g. in a pathological
> scenario (and by "pathological", I mean if NUMA balancing or KSM is active ;-)),
> it's entirely possible for a near-endless stream of mmu_lock writers to be in
> the queue, thus preventing the vCPU from acquiring mmu_lock in a timely manner.

Ah yes, I forgot the main purpose of yielding is to let vCPU make
forward progress when the fault-in page is not covered by the invalidation.

Thanks,
Yilun

> 
> And hacking the page fault path to bypass KVM's lock contention detection would
> be a very willful, deliberate violation of the intent of the MMU's yielding logic
> for preemptible kernels.
> 
> That said, I would love to revisit KVM's use of rwlock_needbreak(), at least in
> the TDP MMU.  As evidenced by this rash of issues, it's not at all obvious that
> yielding on mmu_lock contention is *ever* a net positive for KVM, or even for the
> kernel.  The shadow MMU is probably a different story since it can't parallelize
> page faults with other operations, e.g. yielding in kvm_zap_obsolete_pages() to
> allow vCPUs to make forward progress is probably a net positive.
> 
> But AFAIK, no one has done any testing to prove that yielding on contention in
> the TDP MMU is actually a good thing.  I'm 99% certain the only reason the TDP
> MMU yields on contention is because the shadow MMU yields on contention, i.e.
> I'm confident that no one ever did performance testing to shadow that there is
> any benefit whatsoever to yielding mmu_lock in the TDP MMU.


> 

