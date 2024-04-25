Return-Path: <kvm+bounces-15893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EBD258B1B60
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 09:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A80B0283C5D
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 07:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA5B669946;
	Thu, 25 Apr 2024 07:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j/uczAjg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC2A2E631
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 07:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714028604; cv=none; b=MpaL65RUJCI6Pv/LqnydlP9e5OSlzFg9Hqb9sJMGcYYTYbYJDHdNSVwYOytkN+kO3TpvahsbGdk74ZzaijvipYL7w4wXUC8Iile16+3h9yI6rV4QOFjo7HRUYT4Fg5QkfAkGx3GxJesR6NDGuqX5pWv5Dut1mutCyc7My3tK/wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714028604; c=relaxed/simple;
	bh=qO4v/myxkSZo6pTKczEfEvF9d1EDa0KePzRo82nRE0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CzD4Ezk7KTw+pBi67KT06g4VUP2aGSihHGKmyIOys7ZETQ45rEIP1BHzi9VaDKuPiEndX3udYY/gM5niwljuxnLT9cbp2GCC/CEdUV+2aN0tTyfWLyYyudmyajid/w03QkNL1jej/ObAsE2kiUifSPwr/r728pE2Tfwx5xVdTnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j/uczAjg; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714028602; x=1745564602;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qO4v/myxkSZo6pTKczEfEvF9d1EDa0KePzRo82nRE0k=;
  b=j/uczAjgBgxm6ducpMUPmJPSSXUquQPUgGbrLmHUp/lKp2SpY+CPh7l0
   QB9GL+MzirgtmYj7KfxEf3IkC+9GPicVWiuH2YQoIYT+jG3IfeeAQ4bHr
   NBgzv666a0EKMMQ2Hp9Qr5WYr8X4mfuGGwZHkdBfuZIbQ9Eg2nQFnMoON
   cRQgI2KK8J42GiY+XP6PUKdzCHXeaM+0tFl+I1/23TwsLxhBBlKp6onE7
   0unJDmdSuHXxL7Cve4ZQ4vFq6roSSUD9F1uz8UkHpgxfWFf8sVN1jGdao
   +e3e8dg+oylwAOkTPq18axYQQz2sLcw1VATgc4COR/HoVpgNmh8iKZp/I
   g==;
X-CSE-ConnectionGUID: 4tphXiVfRvq4NQdiVqbc8Q==
X-CSE-MsgGUID: Ehy+0rOiRL+F8lRe3cblkg==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="13479825"
X-IronPort-AV: E=Sophos;i="6.07,228,1708416000"; 
   d="scan'208";a="13479825"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 00:03:21 -0700
X-CSE-ConnectionGUID: EGiMHNZBS0ebDAMq4EDJew==
X-CSE-MsgGUID: LhCxX+3GQBKq46HlzN5VnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,228,1708416000"; 
   d="scan'208";a="25590748"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 25 Apr 2024 00:03:19 -0700
Date: Thu, 25 Apr 2024 15:17:26 +0800
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
Message-ID: <ZioDhpYUOEdGbWgE@intel.com>
References: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
 <fb252e78-2e71-4422-9499-9eac69102eec@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb252e78-2e71-4422-9499-9eac69102eec@intel.com>

Hi Xiaoyao,

On Wed, Apr 24, 2024 at 11:57:11PM +0800, Xiaoyao Li wrote:
> Date: Wed, 24 Apr 2024 23:57:11 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH for-9.1 0/7] target/i386/kvm: Cleanup the kvmclock
>  feature name
> 
> On 3/29/2024 6:19 PM, Zhao Liu wrote:
> > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > Hi list,
> > 
> > This series is based on Paolo's guest_phys_bits patchset [1].
> > 
> > Currently, the old and new kvmclocks have the same feature name
> > "kvmclock" in FeatureWordInfo[FEAT_KVM].
> > 
> > When I tried to dig into the history of this unusual naming and fix it,
> > I realized that Tim was already trying to rename it, so I picked up his
> > renaming patch [2] (with a new commit message and other minor changes).
> > 
> > 13 years age, the same name was introduced in [3], and its main purpose
> > is to make it easy for users to enable/disable 2 kvmclocks. Then, in
> > 2012, Don tried to rename the new kvmclock, but the follow-up did not
> > address Igor and Eduardo's comments about compatibility.
> > 
> > Tim [2], not long ago, and I just now, were both puzzled by the naming
> > one after the other.
> 
> The commit message of [3] said the reason clearly:
> 
>   When we tweak flags involving this value - specially when we use "-",
>   we have to act on both.
> 
> So you are trying to change it to "when people want to disable kvmclock,
> they need to use '-kvmclock,-kvmclock2' instead of '-kvmclock'"
>
> IMHO, I prefer existing code and I don't see much value of differentiating
> them. If the current code puzzles you, then we can add comment to explain.

It's enough to just enable kvmclock2 for Guest; kvmclock (old) is
redundant in the presence of kvmclock2.

So operating both feature bits at the same time is not a reasonable
choice, we should only keep kvmclock2 for Guest. It's possible because
the oldest linux (v4.5) which QEMU i386 supports has kvmclock2.

Pls see:
https://elixir.bootlin.com/linux/v4.5/source/arch/x86/include/uapi/asm/kvm_para.h#L22

With this in mind, I'm trying to implement a silky smooth transition to
"only kcmclock2 support".

This series is now separating kvmclock and kvmclock2, and then I plan to
go to the KVM side and deprecate kvmclock2, and then finally remove
kvmclock (old) in QEMU. Separating the two features makes the process
clearer.

Continuing to use the same name equally would have silently caused the
CPUID to change on the Guest side, which would have hurt compatibility
as well.

> > So, this series is to push for renaming the new kvmclock feature to
> > "kvmclock2" and adding compatibility support for older machines (PC 9.0
> > and older).
> > 
> > Finally, let's put an end to decades of doubt about this name.
> > 
> > 
> > Next Step
> > =========
> > 
> > This series just separates the two kvmclocks from the naming, and in
> > subsequent patches I plan to stop setting kvmclock(old kcmclock) by
> > default as long as KVM supports kvmclock2 (new kvmclock).
> 
> No. It will break existing guests that use KVM_FEATURE_CLOCKSOURCE.

Please refer to my elaboration on v4.5 above, where kvmclock2 is
available, it should be used in priority.

> > Also, try to deprecate the old kvmclock in KVM side.
> > 
> > [1]: https://lore.kernel.org/qemu-devel/20240325141422.1380087-1-pbonzini@redhat.com/
> > [2]: https://lore.kernel.org/qemu-devel/20230908124534.25027-4-twiederh@redhat.com/
> > [3]: https://lore.kernel.org/qemu-devel/1300401727-5235-3-git-send-email-glommer@redhat.com/
> > [4]: https://lore.kernel.org/qemu-devel/1348171412-23669-3-git-send-email-Don@CloudSwitch.com/

Thanks,
Zhao



