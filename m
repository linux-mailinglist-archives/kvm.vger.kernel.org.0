Return-Path: <kvm+bounces-15905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 044F88B2029
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 13:27:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 926E11F22BC6
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 11:27:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEAD212AACA;
	Thu, 25 Apr 2024 11:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mRKJ93uq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011041DDCE;
	Thu, 25 Apr 2024 11:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714044446; cv=none; b=IKxpBP2L4JGfNXdxt9FGDUmKuyZ+rNykog+Qcdgtdk0miS/Jf2kthpZQv2ipsZnVx4LAm6qT7lDzWOwCOx+qR06Ttj7N1d/zjwqrSdEdeWTkmMtMaNi2Wmzn3koKzZY2Kvwa3wUnQ5Ma41Pzq64kfZLnploqmO5G0y2vwuKiC1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714044446; c=relaxed/simple;
	bh=/xag3OkcGEyfkLOWbreP2qxcC/ujNSwQZVNR+WIcJbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nWyj+P8h54o5JWwx2XYN4Z/FQCrwpUlYr+z78WJbh1XifDvlBwkWIWlu4m1p2OZuGCNPXX4BqTzYh2W6oSa8TdkxJrx+uzkAddPnuwM0jSx9Qpu9+7dqGyAUGuZu+6at1oAOTaAqwYgF2MlFJlXDtkX6pcDXw4l3QvkZDfpYuok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mRKJ93uq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872C5C113CC;
	Thu, 25 Apr 2024 11:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714044445;
	bh=/xag3OkcGEyfkLOWbreP2qxcC/ujNSwQZVNR+WIcJbw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mRKJ93uqcY3f24wDK0kXzBjcPBV39G7QObjuc4CmkQfRv5R+mMpJ1b6/J6H5u2HIm
	 t3h5+32yZNa9AnoOJhEsPXOxE743fBO/ZLvaD3SlDtF8Xs+uMfOxHE4vQafUCmrTeS
	 RauCHvdPX8zvNEuF1uoAtnZsVbEL6F3JQU4ITMpZeHMVpsbaStweISAUZ6NSPwqYK1
	 Bznvw3m7I67nKaMSLncnqLg+qkh3IpEMtvfeKnmZfr3+eXQJE4Y4h22qAAkj/prqE7
	 l7Z0jthgvYfF/3lWJ+ZN1Mj9l+O5eeFJL9TnW2NlZSe49x5nzyjc40EKQCg+px2KUW
	 1T6j/jrkd3wfw==
Date: Thu, 25 Apr 2024 16:47:58 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Gautam Menghani <gautam@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	aneesh.kumar@kernel.org, npiggin@gmail.com, Vaibhav Jain <vaibhav@linux.ibm.com>, 
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v5 RESEND] arch/powerpc/kvm: Add support for reading VPA
 counters for pseries guests
Message-ID: <ne4jzv6dyremumuulw6c5zcwgncz5igsesfmlazg4jxmkaz3te@jpqv3qfo7jlb>
References: <20240402070656.28441-1-gautam@linux.ibm.com>
 <aauzmvtbpgxbr4aa3s4k33cdi7fljs5q4ifn5x2swncz7dtvam@gclohylavkpl>
 <ualscagnpj54rvn33ncaznp7ibvvqulhrmq46qsg73wokgswxy@naopf7leuk66>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ualscagnpj54rvn33ncaznp7ibvvqulhrmq46qsg73wokgswxy@naopf7leuk66>

On Wed, Apr 24, 2024 at 11:08:38AM +0530, Gautam Menghani wrote:
> On Mon, Apr 22, 2024 at 09:15:02PM +0530, Naveen N Rao wrote:
> > On Tue, Apr 02, 2024 at 12:36:54PM +0530, Gautam Menghani wrote:
> > >  static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 
> > >  time_limit,
> > >  				     unsigned long lpcr, u64 *tb)
> > >  {
> > > @@ -4130,6 +4161,11 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
> > >  	kvmppc_gse_put_u64(io->vcpu_run_input, KVMPPC_GSID_LPCR, lpcr);
> > >  
> > >  	accumulate_time(vcpu, &vcpu->arch.in_guest);
> > > +
> > > +	/* Enable the guest host context switch time tracking */
> > > +	if (unlikely(trace_kvmppc_vcpu_exit_cs_time_enabled()))
> > > +		kvmhv_set_l2_accumul(1);
> > > +
> > >  	rc = plpar_guest_run_vcpu(0, vcpu->kvm->arch.lpid, vcpu->vcpu_id,
> > >  				  &trap, &i);
> > >  
> > > @@ -4156,6 +4192,10 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcpu *vcpu, u64 time_limit,
> > >  
> > >  	timer_rearm_host_dec(*tb);
> > >  
> > > +	/* Record context switch and guest_run_time data */
> > > +	if (kvmhv_get_l2_accumul())
> > > +		do_trace_nested_cs_time(vcpu);
> > > +
> > >  	return trap;
> > >  }
> > 
> > I'm assuming the counters in VPA are cumulative, since you are zero'ing 
> > them out on exit. If so, I think a better way to implement this is to 
> > use TRACE_EVENT_FN() and provide tracepoint registration and 
> > unregistration functions. You can then enable the counters once during 
> > registration and avoid repeated writes to the VPA area. With that, you 
> > also won't need to do anything before vcpu entry. If you maintain 
> > previous values, you can calculate the delta and emit the trace on vcpu 
> > exit. The values in VPA area can then serve as the cumulative values.
> > 
> 
> This approach will have a problem. The context switch times are reported
> in the L1 LPAR's CPU's VPA area. Consider the following scenario:
> 
> 1. L1 has 2 cpus, and L2 has 1 cpu
> 2. L2 runs on L1's cpu0 for a few seconds, and the counter values go to
> 1 million
> 3. We are maintaining a copy of values of VPA in separate variables, so
> those variables also have 1 million.
> 4. Now if L2's vcpu is migrated to another L1 cpu, that L1 cpu's VPA
> counters will start from 0, so if we try to get delta value, we will end
> up doing 0 - 1 million, which would be wrong.

I'm assuming you mean migrating the task. If we maintain the previous 
readings in paca, it should work I think.

> 
> The aggregation logic in this patch works as we zero out the VPA after
> every switch, and maintain aggregation in a vcpu->arch

Are the cumulative values of the VPA counters of no significance? We 
lose those with this approach. Not sure if we care.


- Naveen


