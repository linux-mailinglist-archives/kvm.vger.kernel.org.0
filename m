Return-Path: <kvm+bounces-11509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB3AE877B84
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 09:10:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7348E281E3D
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 08:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1998E10A3A;
	Mon, 11 Mar 2024 08:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ieqtl+gb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5225BF516
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 08:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710144619; cv=none; b=N6xfgnJbbLEp8ZGL04QDodDbqWCjYn/SdsSGLPGms7ujMNEmK+w/sOnawll6zsA409YIekqVO3yfyFa1mNc4pkOblf3SLKUnqnsuZlOFiy8U2N0yRc0fDXBxMiLx1wqtHiaELai0jr6FffKYnzWSphOAdcEUfqKwXAQLECkOMl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710144619; c=relaxed/simple;
	bh=T0YVqkROoTZT7ZXF1wX65oUz/qiMr4QFmWDX6GaS7gw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BmZjwar0LI9IRgTclx04hKPa4Qrl6p6RNmfpffgErvLgd81cKZJUpOtSc+Q0drO8olF+sLfWURvAcpr6P7GkNaE8PDylHD0UPGdY4gmUxXZPGVNU4fJEUieepU4jxoeMi/wkKHzWXPVSoojHufQExgydxYygeAkOnpFmz1TAH1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ieqtl+gb; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710144617; x=1741680617;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=T0YVqkROoTZT7ZXF1wX65oUz/qiMr4QFmWDX6GaS7gw=;
  b=Ieqtl+gbPnQZI6E4OWv3P0kz71Lvy1vMlmuTFGQW4a9ycaaHUNHyNiLN
   07kNFWnftKbq/d8u/DZTR01SJgP1SzJMGtDgOE/iVLV3nxbSJ2z4GXY4L
   82U347IvCgpv3Wf0Hi3saygTBvdxabdfj06qpcW3ekgCcRmO1+9uGI//W
   qgsYlvg8ktwNwxyOiqQH1yZi26F/czmXnGkGjsLh70vgzJxAqWhco6aH8
   JRBud25Op0ZbA9yFVZE5WrAFoHXDGiTCZMG+FBmBL9RxeCRDzhLGXOeNw
   FUkzu04u0V59/aQ7aKctoyUTgOPBh5LcB73Ul/UORmv6e7mDUNbAh95ie
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="4957968"
X-IronPort-AV: E=Sophos;i="6.07,116,1708416000"; 
   d="scan'208";a="4957968"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 01:10:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,116,1708416000"; 
   d="scan'208";a="42017291"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa002.jf.intel.com with ESMTP; 11 Mar 2024 01:10:08 -0700
Date: Mon, 11 Mar 2024 16:23:57 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?B?TWF0aGlldS1EYXVk77+9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel P =?utf-8?B?LiBCZXJyYW5n77+9?= <berrange@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH v9 06/21] i386/cpu: Use APIC ID info to encode cache topo
 in CPUID[4]
Message-ID: <Ze6/naoIIXj/DfTv@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <20240227103231.1556302-7-zhao1.liu@linux.intel.com>
 <c88ee253-f212-4aa7-9db9-e90a99a9a1e3@intel.com>
 <Ze23y7UzGxnsyo6O@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ze23y7UzGxnsyo6O@intel.com>

Hi Xiaoyao,

Did the following reason convince you? Could I take your r/b tag with
current code? ;-)

Thanks,
Zhao

On Sun, Mar 10, 2024 at 09:38:19PM +0800, Zhao Liu wrote:
> Date: Sun, 10 Mar 2024 21:38:19 +0800
> From: Zhao Liu <zhao1.liu@linux.intel.com>
> Subject: Re: [PATCH v9 06/21] i386/cpu: Use APIC ID info to encode cache
>  topo in CPUID[4]
> 
> Hi Xiaoyao,
> 
> > >               case 3: /* L3 cache info */
> > > -                die_offset = apicid_die_offset(&topo_info);
> > >                   if (cpu->enable_l3_cache) {
> > > +                    addressable_threads_width = apicid_die_offset(&topo_info);
> > 
> > Please get rid of the local variable @addressable_threads_width.
> > 
> > It is truly confusing.
> 
> There're several reasons for this:
> 
> 1. This commit is trying to use APIC ID topology layout to decode 2
> cache topology fields in CPUID[4], CPUID.04H:EAX[bits 25:14] and
> CPUID.04H:EAX[bits 31:26]. When there's a addressable_cores_width to map
> to CPUID.04H:EAX[bits 31:26], it's more clear to also map
> CPUID.04H:EAX[bits 25:14] to another variable.
> 
> 2. All these 2 variables are temporary in this commit, and they will be
> replaed by 2 helpers in follow-up cleanup of this series.
> 
> 3. Similarly, to make it easier to clean up later with the helper and
> for more people to review, it's neater to explicitly indicate the
> CPUID.04H:EAX[bits 25:14] with a variable here.
> 
> 4. I call this field as addressable_threads_width since it's "Maximum
> number of addressable IDs for logical processors sharing this cache".
> 
> Its own name is long, but given the length, only individual words could
> be selected as names.
> 
> TBH, "addressable" deserves more emphasis than "sharing". The former
> emphasizes the fact that the number of threads chosen here is based on
> the APIC ID layout and does not necessarily correspond to actual threads.
> 
> Therefore, this variable is needed here.
> 
> Thanks,
> Zhao
> 

