Return-Path: <kvm+bounces-34375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BE0A9FC37B
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2024 04:30:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 847A1188440B
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2024 03:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E266142065;
	Wed, 25 Dec 2024 03:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NcxWjyXU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D83DF9DD
	for <kvm@vger.kernel.org>; Wed, 25 Dec 2024 03:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735097437; cv=none; b=ToMHH2ANbZuK0A226ddyOzHlJsTtzQYYjM00xhEkmAtuhv6AxCS3JCatQoJQqbIbfRKphjdiA9ky/uGxXshMh9SeRcHz9NQWv/znmMqOOmuxKUFSE2NTzHRmrt5i197KhEeY6+eFErkRcgoVcZIPRluvXQ+xlHLbAfNs9pHN1Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735097437; c=relaxed/simple;
	bh=3iKFT4z2oDkIUweu+RodEq/bkoPWuslvhF1RfRv3KD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OoEHnM/YloBiZS8mW3kW6dbc26vZh7tso5+sa2VqrmR36aRbJWLVHXikVlc42pvMilB/5mfyqMSONDMhEgxDWBPva903fs5cc0A4l4pJHFfx4tKDpouYPHI+1Y7l6fphIwqFn9Xjjd3HZOOsg5hDWsZke6gYXWKLPZedEfJmB34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NcxWjyXU; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735097435; x=1766633435;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3iKFT4z2oDkIUweu+RodEq/bkoPWuslvhF1RfRv3KD4=;
  b=NcxWjyXUs0RF2sEcsNQm6S8q0DXzru9w0MI8th/AyK7TjjLIJZZE6UtT
   FbsltTAZaic6Ifj9F2AKwucloteFWuWnRCk+GFoNR7z6WB8/4XllNqgeP
   aBIlt23DJdKs4oM3vY4oZK1mceIyz4/ig0Q+zMtMIbBhuFcO8LieavtOl
   bWgmMwxXCrMhwdiVSkRWRZ2KqpFLLpLt5YiMjOUGvhUhTorqMTvqSYSvc
   3+tem3433DvV55tNxAeAC8ooIZCy4TtahRsYlEszfoKmTpJ1795CzYvuj
   AK1Sqb8j6QiYxgwibBVopm1S51KuCMgHRbQLedENZRrO7v7LGSNHuvkNH
   A==;
X-CSE-ConnectionGUID: jn2+VfNyS+KfLjY6Nv3PZQ==
X-CSE-MsgGUID: 0BcWMaySRDiJS/LcSw9SCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11296"; a="35721417"
X-IronPort-AV: E=Sophos;i="6.12,262,1728975600"; 
   d="scan'208";a="35721417"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2024 19:30:34 -0800
X-CSE-ConnectionGUID: 1i829XcrTwm/HZyv+8aUBg==
X-CSE-MsgGUID: TujlvUd2Sc+92wxfcfh4vA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="104250933"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa005.fm.intel.com with ESMTP; 24 Dec 2024 19:30:32 -0800
Date: Wed, 25 Dec 2024 11:49:14 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Tao Su <tao1.su@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v5 05/11] target/i386/kvm: Save/load MSRs of kvmclock2
 (KVM_FEATURE_CLOCKSOURCE2)
Message-ID: <Z2uAupHhVT7/HfWw@intel.com>
References: <20241106030728.553238-1-zhao1.liu@intel.com>
 <20241106030728.553238-6-zhao1.liu@intel.com>
 <af13d0c9-1d73-4cdd-8fd0-eff86a5711d3@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af13d0c9-1d73-4cdd-8fd0-eff86a5711d3@redhat.com>

On Tue, Dec 24, 2024 at 04:32:42PM +0100, Paolo Bonzini wrote:
> Date: Tue, 24 Dec 2024 16:32:42 +0100
> From: Paolo Bonzini <pbonzini@redhat.com>
> Subject: Re: [PATCH v5 05/11] target/i386/kvm: Save/load MSRs of kvmclock2
>  (KVM_FEATURE_CLOCKSOURCE2)
> 
> On 11/6/24 04:07, Zhao Liu wrote:
> > MSR_KVM_SYSTEM_TIME_NEW and MSR_KVM_WALL_CLOCK_NEW are bound to
> > kvmclock2 (KVM_FEATURE_CLOCKSOURCE2).
> > 
> > Add the save/load support for these 2 MSRs just like kvmclock MSRs.
> 
> As mentioned in the previous patch, this is not necessary.  If it was
> needed, you'd have to also add VMSTATE fields in machine.c
> 

I see, thanks!

Regards,
Zhao


