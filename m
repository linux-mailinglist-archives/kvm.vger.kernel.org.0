Return-Path: <kvm+bounces-18300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69E848D37FA
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 15:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B7A41C23F68
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 13:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 104A61BDCD;
	Wed, 29 May 2024 13:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O0XfmMLD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8585A17BBA
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 13:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716990008; cv=none; b=sDEBEpk9LRFvvDHGY8uToOT85jWblWNxahN9i13fMLb664K8gZxm52O7ylvRdvpuWaFc0iONYRxyi6lu2LQvr2GPNqDtc2IzVzO0jHb1euCAkVsZooSLZiWa6fpuDoD25E0L3nQHqaHs/Eq9BOfgl+7h5vYBoonporuSSZ+vAl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716990008; c=relaxed/simple;
	bh=MmFNbZeo9MSYiHcRdeKEQagT0HH9mc7n7rtg7wuLdOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JbvsSrhionWjAftH1DmchtU1xy+jm5XdtIOI7KWfgjgwZscJmUq68D6ppa/TfYuy01/FvhFeD9T8vYvy9+fUsHpTfk2xrHVOQ3MHdQLzuTxILfzsO1XDtEWCC68unAzEorLdu/mAK6kEmTxJVBahETQvpC3+DrGOdZrBEzx1Y4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O0XfmMLD; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716990007; x=1748526007;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MmFNbZeo9MSYiHcRdeKEQagT0HH9mc7n7rtg7wuLdOk=;
  b=O0XfmMLDwLWkAexR/+OCCkKges/JfUPkferpVMvumlcpLUT/g+vyw1wL
   jhWpvSDOxkTnF+Ac1p4aa6jXjeekQDPSrf8lnVH25N4X8aizqqWQuMANX
   LZlsd9NKBBCbH8ITn4axC9umEoxaoiv+5ru+77fe/DEzMWWTVrfHSCQg3
   vRKFOT60tcWZcz7fuSEYmxYm75hk3wa+94TEjq9XeaKKj6R9M+r01rANu
   UxsXGQkwB6hlgrkdsDeAQOcYymVQJpqIYFlQT7AEG8FWDRsZNLuiLa4x7
   FLrw0Oo7yCCI+Hm6a9asd8Djso72OuF2pOkgW+RUyFqWb2EmtUWmL4Aw0
   Q==;
X-CSE-ConnectionGUID: 3tibx/LBRoWL0mcVD6wVBQ==
X-CSE-MsgGUID: yst19YqrSpqLu5hLM+UWLA==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="24806056"
X-IronPort-AV: E=Sophos;i="6.08,198,1712646000"; 
   d="scan'208";a="24806056"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 06:39:56 -0700
X-CSE-ConnectionGUID: 4qXYuXRERLO3IAWvdJ03Jw==
X-CSE-MsgGUID: SpxxG4IgR8iRsxILyWXWDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,198,1712646000"; 
   d="scan'208";a="35972577"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 29 May 2024 06:39:53 -0700
Date: Wed, 29 May 2024 21:55:16 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/6] target/i386: Misc cleanup on KVM PV defs and
 outdated comments
Message-ID: <ZlczxBdykhX28M9K@intel.com>
References: <20240506085153.2834841-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506085153.2834841-1-zhao1.liu@intel.com>

Hi mainatainers,

Just a friendly ping.

Thanks,
Zhao

On Mon, May 06, 2024 at 04:51:47PM +0800, Zhao Liu wrote:
> Date: Mon, 6 May 2024 16:51:47 +0800
> From: Zhao Liu <zhao1.liu@intel.com>
> Subject: [PATCH v2 0/6] target/i386: Misc cleanup on KVM PV defs and
>  outdated comments
> X-Mailer: git-send-email 2.34.1
> 
> Hi,
> 
> This is my v2 cleanup series. Compared with v1 [1], only tags (R/b, S/b)
> updates, and a typo fix, no code change.
> 
> This series picks cleanup from my previous kvmclock [2] (as other
> renaming attempts were temporarily put on hold).
> 
> In addition, this series also include the cleanup on a historically
> workaround and recent comment of coco interface [3].
> 
> Avoiding the fragmentation of these misc cleanups, I consolidated them
> all in one series and was able to tackle them in one go!
> 
> [1]: https://lore.kernel.org/qemu-devel/20240426100716.2111688-1-zhao1.liu@intel.com/
> [2]: https://lore.kernel.org/qemu-devel/20240329101954.3954987-1-zhao1.liu@linux.intel.com/
> [3]: https://lore.kernel.org/qemu-devel/2815f0f1-9e20-4985-849c-d74c6cdc94ae@intel.com/
> 
> Thanks and Best Regards,
> Zhao
> ---
> Zhao Liu (6):
>   target/i386/kvm: Add feature bit definitions for KVM CPUID
>   target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK and
>     MSR_KVM_SYSTEM_TIME definitions
>   target/i386/kvm: Only save/load kvmclock MSRs when kvmclock enabled
>   target/i386/kvm: Save/load MSRs of kvmclock2
>     (KVM_FEATURE_CLOCKSOURCE2)
>   target/i386/kvm: Drop workaround for KVM_X86_DISABLE_EXITS_HTL typo
>   target/i386/confidential-guest: Fix comment of
>     x86_confidential_guest_kvm_type()
> 
>  hw/i386/kvm/clock.c              |  5 +--
>  target/i386/confidential-guest.h |  2 +-
>  target/i386/cpu.h                | 25 +++++++++++++
>  target/i386/kvm/kvm.c            | 63 +++++++++++++++++++-------------
>  4 files changed, 66 insertions(+), 29 deletions(-)
> 
> -- 
> 2.34.1
> 

