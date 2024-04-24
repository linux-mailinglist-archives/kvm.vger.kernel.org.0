Return-Path: <kvm+bounces-15779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A20278B0720
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 12:19:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE0E7B21EC2
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 10:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22835159565;
	Wed, 24 Apr 2024 10:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TiLG0YZ7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509A1158D9A
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 10:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713953982; cv=none; b=nAWDGDEj0hTuqiR3R/kXaI9TRUzteahmBCc9qdBq4xFMchdJPl5btdL0Jijzu6Xv9xVO+eKdsC+T1u0rt06YJRUbI/ZZ07FPkuH5ivjPEtDzukYH1hDW51iQ7jw5uWHSlFS2P3Ee5Mmkj4aIG0e7p2wdQx/wyuQQSwWDgXJFBmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713953982; c=relaxed/simple;
	bh=Ro8LJdgZqyCdBFIoBx/EtjaSCPEmCl/nrm9NUdz+RfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GSo8yCEt7srB9FkNrVS0satuD5PV0V7+xdWQuj8KheM4/BnoAHH1nhu5TYrABDHVDBmdrib3pTFU8e+zh5aYAZrrPxb7qI/LSicsCsBiTAdjmXkhTYu/0C8ThjMnLL3rrUV1qiaHGdYm8rieGNHULxpAeh2z2+zc4FwSG/fWjwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TiLG0YZ7; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713953981; x=1745489981;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ro8LJdgZqyCdBFIoBx/EtjaSCPEmCl/nrm9NUdz+RfE=;
  b=TiLG0YZ7dhOkLh4xRMM6wAFb8JOd+x8ptnDDhP6uCIzxUCKPtSCJGs1y
   KjUiK3SDZz9wuocqES2X4ZPWt9ji1t5N5sEEwkT3MJ0YArLJKwDQS0+RT
   IPeNY1PWfVvuBP3IiUIdTu11vldH3dDlsq77B+Kjv+bQ1NPVcTeDVqVqo
   d29nC1mtZSjHfYH4DqL/+OpL81rgpQ8ByWwtdm/klPzFPO7ZZYlcU7Dbc
   j+mrZn2kuAGVIr6iO6oXmllcwfZUpc64Qz0xkWmSALg4zyKT2J9YCNUka
   eIRalrVbq60j0ppI9QvFpN3wL4ICEDC8EVHwlNUw+nB3xi08mt1ZvT3Gm
   g==;
X-CSE-ConnectionGUID: L4JbNS1aToO95dJQl44Gbg==
X-CSE-MsgGUID: mnQFbGwISoqlY+q9HUvqYg==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="27032261"
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="27032261"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 03:19:40 -0700
X-CSE-ConnectionGUID: cNB1Y3tgQZC1OhIlSs1w6A==
X-CSE-MsgGUID: 7qPVLuibTjOUwVDbsuRCJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="29305819"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa003.jf.intel.com with ESMTP; 24 Apr 2024 03:19:37 -0700
Date: Wed, 24 Apr 2024 18:33:43 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
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
Message-ID: <ZijgB1Aocksr+ec9@intel.com>
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

Hi maintainers,

Ping. Do you like this diea?

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

