Return-Path: <kvm+bounces-15916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA8498B226E
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 15:22:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7717B21A30
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 13:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1312B149C5E;
	Thu, 25 Apr 2024 13:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gLAhg7id"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896C61494BC
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 13:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714051343; cv=none; b=KlO4E2wFb+lmd29+vKujjAIAz8W1OJy7tq/5k+0cgzCaYcQA0zRfed6G63VcyKaL51CmU3FkBhwWNqw+4PYU8tMiLecvxRLKk11mGLCCb1jizH29d9EK5ZajZpxx8G+tMCRY9Y6aF0zE5xUdkH1OOvJKEHfxwTEeq58oQ85Sn1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714051343; c=relaxed/simple;
	bh=1yI1AmeOggJ3cHhFUvziR4XRUExHRkUgkfAFK+a/8B8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uEqCL7l1+2huyZmnuDIE+GG4C3bKKw+3q9ja45ZvQ9yddMPXNmigSBawmPPMi58M4DP0K1MWADk5PdjX5s9TZV8L32bhgHE7ATKJAatKs/uNWtfpkg7zuzfcfrGtHE/poUKBbXy6CCYPQO8LVi4o8/rrH5BofrpyfDVfO/TDy2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gLAhg7id; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714051341; x=1745587341;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1yI1AmeOggJ3cHhFUvziR4XRUExHRkUgkfAFK+a/8B8=;
  b=gLAhg7idIibt/OgkaodZxEe7xTO3wZE6nLvFd/SWwO+3SQBEYtLhNFoU
   IsOwne/CjWkRHOrTjbfYy2Kh7w7IicR9oSs4jWH/nGbJvn1HyWEflhmkE
   auKclex0URXlkNj4KbxfGzQJDK5quVSOC9nNqzSVlRgxAykwNzXLXrFRD
   8//kdUgfWl8wNdUpfhtPGoECgJNKPH1mLLgWt8eyQir1dBoZOFuP9CA+a
   OvBMw5RqGEBz8AFoUZ4gEDv/JaTpGp2ct/FyJkIepDZHkv7cw+z+rfNnC
   F/q2JyDgJiw8B8uPD3xn4rdC+ANd3fYJSaoWtbc82KGNf12VxIQ5hASd6
   A==;
X-CSE-ConnectionGUID: z+dk6Z9dQPi/GUG54+z0Xw==
X-CSE-MsgGUID: uEyeloFaSMSbcUX7BcJWOQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="10272209"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="10272209"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 06:22:20 -0700
X-CSE-ConnectionGUID: Jrjz/c8KR+O0UnUDjsYFag==
X-CSE-MsgGUID: pUqp5B0GQniwGLarYNEKaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="24942598"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa010.jf.intel.com with ESMTP; 25 Apr 2024 06:22:17 -0700
Date: Thu, 25 Apr 2024 21:36:24 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Tim Wiederhake <twiederh@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH for-9.1 0/7] target/i386/kvm: Cleanup the kvmclock
 feature name
Message-ID: <ZipcWGbYR2KCfmxp@intel.com>
References: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
 <fb252e78-2e71-4422-9499-9eac69102eec@intel.com>
 <ZioDhpYUOEdGbWgE@intel.com>
 <eb5cfa25-6490-4b8d-8552-4be2662d15d2@intel.com>
 <ZiowbFCZ75LOgBMC@intel.com>
 <6ee5cb90-d299-4977-8a2f-529f78dc3913@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ee5cb90-d299-4977-8a2f-529f78dc3913@intel.com>

On Thu, Apr 25, 2024 at 08:04:46PM +0800, Xiaoyao Li wrote:
> Date: Thu, 25 Apr 2024 20:04:46 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH for-9.1 0/7] target/i386/kvm: Cleanup the kvmclock
>  feature name
> 
> On 4/25/2024 6:29 PM, Zhao Liu wrote:
> > On Thu, Apr 25, 2024 at 04:40:10PM +0800, Xiaoyao Li wrote:
> > > Date: Thu, 25 Apr 2024 16:40:10 +0800
> > > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > > Subject: Re: [PATCH for-9.1 0/7] target/i386/kvm: Cleanup the kvmclock
> > >   feature name
> > > 
> > > On 4/25/2024 3:17 PM, Zhao Liu wrote:
> > > > Hi Xiaoyao,
> > > > 
> > > > On Wed, Apr 24, 2024 at 11:57:11PM +0800, Xiaoyao Li wrote:
> > > > > Date: Wed, 24 Apr 2024 23:57:11 +0800
> > > > > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > > > > Subject: Re: [PATCH for-9.1 0/7] target/i386/kvm: Cleanup the kvmclock
> > > > >    feature name
> > > > > 
> > > > > On 3/29/2024 6:19 PM, Zhao Liu wrote:
> > > > > > From: Zhao Liu <zhao1.liu@intel.com>
> > > > > > 
> > > > > > Hi list,
> > > > > > 
> > > > > > This series is based on Paolo's guest_phys_bits patchset [1].
> > > > > > 
> > > > > > Currently, the old and new kvmclocks have the same feature name
> > > > > > "kvmclock" in FeatureWordInfo[FEAT_KVM].
> > > > > > 
> > > > > > When I tried to dig into the history of this unusual naming and fix it,
> > > > > > I realized that Tim was already trying to rename it, so I picked up his
> > > > > > renaming patch [2] (with a new commit message and other minor changes).
> > > > > > 
> > > > > > 13 years age, the same name was introduced in [3], and its main purpose
> > > > > > is to make it easy for users to enable/disable 2 kvmclocks. Then, in
> > > > > > 2012, Don tried to rename the new kvmclock, but the follow-up did not
> > > > > > address Igor and Eduardo's comments about compatibility.
> > > > > > 
> > > > > > Tim [2], not long ago, and I just now, were both puzzled by the naming
> > > > > > one after the other.
> > > > > 
> > > > > The commit message of [3] said the reason clearly:
> > > > > 
> > > > >     When we tweak flags involving this value - specially when we use "-",
> > > > >     we have to act on both.
> > > > > 
> > > > > So you are trying to change it to "when people want to disable kvmclock,
> > > > > they need to use '-kvmclock,-kvmclock2' instead of '-kvmclock'"
> > > > > 
> > > > > IMHO, I prefer existing code and I don't see much value of differentiating
> > > > > them. If the current code puzzles you, then we can add comment to explain.
> > > > 
> > > > It's enough to just enable kvmclock2 for Guest; kvmclock (old) is
> > > > redundant in the presence of kvmclock2.
> > > > 
> > > > So operating both feature bits at the same time is not a reasonable
> > > > choice, we should only keep kvmclock2 for Guest. It's possible because
> > > > the oldest linux (v4.5) which QEMU i386 supports has kvmclock2.
> > > 
> > > who said the oldest Linux QEMU supports is from 4.5? what about 2.x kernel?
> > 
> > For Host (docs/system/target-i386.rst).
> > 
> > > Besides, not only the Linux guest, whatever guest OS is, it will be broken
> > > if the guest is using kvmclock and QEMU starts to drop support of kvmclock.
> > 
> > I'm not aware of any minimum version requirements for Guest supported
> > by KVM, but there are no commitment.
> 
> the common commitment is at least keeping backwards compatibility.
> 
> > > So, again, hard NAK to drop the support of kvmclock. It breaks existing
> > > guests that use kvmclock. You cannot force people to upgrade their existing
> > > VMs to use kvmclock2 instead of kvmclock.
> > 
> > I agree, legacy kvmclock can be left out, if the old kernel does not
> > support kvmclock2 and strongly requires kvmclock, it can be enabled
> > using 9.1 and earlier machines or legacy-kvmclock, as long as Host still
> > supports it.
> > 
> > What's the gap in handling it this way? especially considering that
> > kvmclock2 was introduced in v2.6.35, and earlier kernels are no longer
> > maintained. The availability of the PV feature requires compatibility
> > for both Host and Guest.
> > 
> > Anyway, the above discussion here is about future plans, and this series
> > does not prevent any Guest from ignoring kvmclock2 in favor of kvmclock.
> > 
> > What this series is doing, i.e. separating the current two kvmclock and
> > ensuring CPUID compatibility via legacy-kvmclock, could balance the
> > compatibility requirements of the ancient (unmaintained kernel) with
> > the need for future feature changes.
> 
> You introduce a user-visible change that people need to use
> "-kvmclock,-kvmclock2" to totally disable kvmclock.
> 
> The only difference between kvmclock and kvmclock2 is the MSR index. And
> from users' perspective, they don't care this difference. The existing usage
> is simple. When I want kvmclock, use "+kvmclock". When I don't want it, use
> "-kvmclock".
> 
> You are complicating things and I don't see a strong reason that we have to
> do it.
>

Okay, only when old kvmclock deprecation occurs can the values (of
renaming) be recognized, then I'll hold the renamed patches for now and
only keep some of the other cleanups.

Thanks for your review,

-Zhao


