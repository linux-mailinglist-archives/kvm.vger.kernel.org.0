Return-Path: <kvm+bounces-19001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59E1F8FE245
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 11:15:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7B3D287B31
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 09:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8890C14EC6E;
	Thu,  6 Jun 2024 09:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Iz6s67b8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D72414E2FF
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 09:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717665008; cv=none; b=CCq6DNFHDFnldCtYVJPDYZToOVIWg4jNk2bSOX49k51G7caMOcUEZTCZt0KOk5J6LbOZ8WyGwozIeX3UDdUFxhKb/PAFQnAFtRnNnKxajSGDgQgH29igDFWmXybAdUt/rjpTq8099NayjxfpCOuMcbLZIjEqsjeKWbQbw6B/Wk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717665008; c=relaxed/simple;
	bh=eGjSDJFtFiOdUgyuzxIYjRn+S7wXr14xrMosiBvN5vM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kyNcpadcdX1QNW3hIYWpsdScyn2nNu5dlQ4BGDGk5Gp2dxtWLKNCurRUa9rWWH2Eqg18M31ADUgqBN1Ll+jxUWpkC+4CFtKXcL1bUlpqD7aWDjYAbJkV5XXIG7Yh7QzbQHbvGmuW1WCFzSwA1LWniQPknY+6wVF6EDVloxRFBzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Iz6s67b8; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717665007; x=1749201007;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eGjSDJFtFiOdUgyuzxIYjRn+S7wXr14xrMosiBvN5vM=;
  b=Iz6s67b8I5GMeiJaYIGkOCWgOr5znSG9341r/uWLXr3gjEXqf6ZhVpQM
   dLKmaXO/H98aPp1NretTL8VD2FaWqydnYrqT050EVXbal6ojNtbt6X9Cv
   J6zUCzV/MLq0LHEZ1Zcyoy7FZGgmVUmtn9ailr/H8hN02uvfL4Zf90qla
   KENkOi5glmAvJS7AST964rox98+IB919GoEMf6hZijyI4tCBJXmltbEXJ
   xg08GiSK+pGMMIMV6oD0YqWWM0nmrlqqLg8E7xifIrDzngnMDXosi3oZo
   dD249B4pKnurdIJ1Re2S/bj008fD2+OaRELzQDvaaWIM+m9tjO3AMtOtK
   Q==;
X-CSE-ConnectionGUID: 98VkySViRV+NkobGx/xHIQ==
X-CSE-MsgGUID: LcEwjXovRRCoSYzAZNMzAg==
X-IronPort-AV: E=McAfee;i="6600,9927,11094"; a="24890293"
X-IronPort-AV: E=Sophos;i="6.08,218,1712646000"; 
   d="scan'208";a="24890293"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 02:10:06 -0700
X-CSE-ConnectionGUID: U1p9oq3aSt2+r+EWMjdTWQ==
X-CSE-MsgGUID: G5wjL19rTEWp1zdCCs+q6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,218,1712646000"; 
   d="scan'208";a="42839079"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa003.jf.intel.com with ESMTP; 06 Jun 2024 02:10:05 -0700
Date: Thu, 6 Jun 2024 17:25:31 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/6] target/i386: Misc cleanup on KVM PV defs and
 outdated comments
Message-ID: <ZmGAi4j+IxZgNShC@intel.com>
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

Hi Paolo,

Just a ping for this cleanup series.

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

