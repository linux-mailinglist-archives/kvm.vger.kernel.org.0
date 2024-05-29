Return-Path: <kvm+bounces-18301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 633BE8D3819
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 15:43:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 923371C23E90
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 13:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C008D1C6A1;
	Wed, 29 May 2024 13:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QvNbedGE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE27C17C98
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 13:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716990186; cv=none; b=usCAFVhjfHsjQ1D7MmfGim68hM0dETRdZzU9EgtQVSdm1r6p7uwpKnxZNi0qe3nzvcy+oJpp4giAesq1eMdSecdck21GaR3vXSxEhAu/5nEXa9a9wEsqv0onPf4qZ5d52h9nkra/zPi14AO/f5dYL8LKPzOVXyEo5xZfWG44gZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716990186; c=relaxed/simple;
	bh=SCQ9nkm1ztsqBMCoum5K+Ptt4+PY7yogbkbMLMLLhxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sUdosgAmTuThwX0WSFc46o7V26KEtTBPy9/JWAGuRwwme72VdXw49pJQraQ9H6L5vYbRRFScqwgSZkkTIYnv/amS/d79DQvEuXZhehIfmKYnw5mLBJSBgqddxg15maqeJDo9470gJ+jJFNOVSnBe+T2hoc5o+7GTPzZwy0Gl94s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QvNbedGE; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716990184; x=1748526184;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SCQ9nkm1ztsqBMCoum5K+Ptt4+PY7yogbkbMLMLLhxI=;
  b=QvNbedGE7y+lRQ98FSPc4jBLptsmdikazXQahLysEucXdQ3vhRmKdh+6
   mMQwfO4SKM5M1lWCVbAjPCBD7BxZKSpi29qQpqSBICfizcVkAplvoqYWM
   wcp6QgAC3Mlj9fxEm0wCA4tP5AUov0YGvdda7yKKre2gsH0RzOexxSO2G
   +pp4d2QRTF9rMphUB6HQEKQTJkkPnzXgFp++wZSDYrvf7KoPdpQAVm49I
   6SF96aE5iCozsLwpjErzQkZY/Y2sc1gZsIb5FFXG94fvCiqDsEDNHzQPn
   barQgxB5zYvBTXw2bwxauHuGB6LEmMOVYdsOyKqS7gsM3ZuqeXtLAX6JI
   w==;
X-CSE-ConnectionGUID: eZDLk4TRRu2ffQ2sne0kXA==
X-CSE-MsgGUID: 8t8BEe6lQaWVi5SUmUAzpA==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="23946915"
X-IronPort-AV: E=Sophos;i="6.08,198,1712646000"; 
   d="scan'208";a="23946915"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 06:43:04 -0700
X-CSE-ConnectionGUID: QTEDW32xRxe4A/GVgvYEzw==
X-CSE-MsgGUID: afC3wSa8TiaLzb+l86Vs6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,198,1712646000"; 
   d="scan'208";a="35469404"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 29 May 2024 06:43:03 -0700
Date: Wed, 29 May 2024 21:58:25 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Zhao Liu <zhao1.liu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Tim Wiederhake <twiederh@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH for-9.1 0/7] target/i386/kvm: Cleanup the kvmclock
 feature name
Message-ID: <Zlc0gX0ouWmyUab9@intel.com>
References: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>

Hi Paolo,

Sorry to re-pick this series, is it an acceptable cleanup to separate the
current kvmclock/kvmclock2 if the old kvmclock can't be dropped?

Thanks,
Zhao

On Fri, Mar 29, 2024 at 06:19:47PM +0800, Zhao Liu wrote:
> Date: Fri, 29 Mar 2024 18:19:47 +0800
> From: Zhao Liu <zhao1.liu@linux.intel.com>
> Subject: [PATCH for-9.1 0/7] target/i386/kvm: Cleanup the kvmclock feature
>  name
> X-Mailer: git-send-email 2.34.1
> 
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> Hi list,
> 
> This series is based on Paolo's guest_phys_bits patchset [1].
> 
> Currently, the old and new kvmclocks have the same feature name
> "kvmclock" in FeatureWordInfo[FEAT_KVM].
> 
> When I tried to dig into the history of this unusual naming and fix it,
> I realized that Tim was already trying to rename it, so I picked up his
> renaming patch [2] (with a new commit message and other minor changes).
> 
> 13 years age, the same name was introduced in [3], and its main purpose
> is to make it easy for users to enable/disable 2 kvmclocks. Then, in
> 2012, Don tried to rename the new kvmclock, but the follow-up did not
> address Igor and Eduardo's comments about compatibility.
> 
> Tim [2], not long ago, and I just now, were both puzzled by the naming
> one after the other.
> 
> So, this series is to push for renaming the new kvmclock feature to
> "kvmclock2" and adding compatibility support for older machines (PC 9.0
> and older).
> 
> Finally, let's put an end to decades of doubt about this name.
> 
> 
> Next Step
> =========
> 
> This series just separates the two kvmclocks from the naming, and in
> subsequent patches I plan to stop setting kvmclock(old kcmclock) by
> default as long as KVM supports kvmclock2 (new kvmclock).
> 
> Also, try to deprecate the old kvmclock in KVM side.
> 
> [1]: https://lore.kernel.org/qemu-devel/20240325141422.1380087-1-pbonzini@redhat.com/
> [2]: https://lore.kernel.org/qemu-devel/20230908124534.25027-4-twiederh@redhat.com/
> [3]: https://lore.kernel.org/qemu-devel/1300401727-5235-3-git-send-email-glommer@redhat.com/
> [4]: https://lore.kernel.org/qemu-devel/1348171412-23669-3-git-send-email-Don@CloudSwitch.com/
> 
> Thanks and Best Regards,
> Zhao
> 
> ---
> Tim Wiederhake (1):
>   target/i386: Fix duplicated kvmclock name in FEAT_KVM
> 
> Zhao Liu (6):
>   target/i386/kvm: Add feature bit definitions for KVM CPUID
>   target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK and
>     MSR_KVM_SYSTEM_TIME definitions
>   target/i386/kvm: Only Save/load kvmclock MSRs when kvmclock enabled
>   target/i386/kvm: Save/load MSRs of new kvmclock
>     (KVM_FEATURE_CLOCKSOURCE2)
>   target/i386/kvm: Add legacy_kvmclock cpu property
>   target/i386/kvm: Update comment in kvm_cpu_realizefn()
> 
>  hw/i386/kvm/clock.c       |  5 ++--
>  hw/i386/pc.c              |  1 +
>  target/i386/cpu.c         |  3 +-
>  target/i386/cpu.h         | 32 +++++++++++++++++++++
>  target/i386/kvm/kvm-cpu.c | 25 ++++++++++++++++-
>  target/i386/kvm/kvm.c     | 59 +++++++++++++++++++++++++--------------
>  6 files changed, 99 insertions(+), 26 deletions(-)
> 
> -- 
> 2.34.1
> 

