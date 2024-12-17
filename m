Return-Path: <kvm+bounces-33978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 322D79F5094
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 17:13:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6038218889BD
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 16:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEB851F76DA;
	Tue, 17 Dec 2024 16:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kJWiDmEv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7C717753
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 16:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734451342; cv=none; b=n7Y2s0RQH9VP7XPfiTzUM+97tZPCe1IlF/3h2zcZ8STEamT8/RtWGn7R4BrYSek4guQLYeYaCItmkmqQcUyYs/7R6kqupqZdOGAHicYQHegu2kzp1cVtkz2er0C2AzFgeOCbqNFhsvSsVZNJuvmCnb6LeVPhpbyfjrVLGS14NxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734451342; c=relaxed/simple;
	bh=snrT2Ns6e36l2ymjYWcaUa+kTGd+p3goxe68uIQLrSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PXHoXZ5Xc/W9Or3KyrQ6Dxi60VwikWAF2m0wThfFCG9ki9+4+unTt3gvj2EMTE4zHfxpEvATX3/Gs1QWazLk27H9OKNEy19n30xlWRWNjGtMVbyGa8zAwW8HYh9YfvSpuwYWX0TA1CL0sgE24YPxz293QSPlCB6mXhveMgB9LO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kJWiDmEv; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734451340; x=1765987340;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=snrT2Ns6e36l2ymjYWcaUa+kTGd+p3goxe68uIQLrSY=;
  b=kJWiDmEv+7weZ0xrokI7uGpZkSfrpxRQa3SmPfJFEcO7ZJ67a9jiTO5Y
   ulEmEyTdB8cD/8X0QQFbRcmOShWs+BSkXR5LfiTVSr6z4JkL4ZVcE5Jdr
   DLFwbMcYIBgtfoZ4wkvyGR3F1h0YWwvUsxJSaDPhGUFU7zXIIyDjszyb6
   DoNQcZd2jyML2PlEYNbYo3iHDtDaR4K2Ux2tBfbSZJHDfBT5l/dcfSYge
   phfYLfJ2gAv+TiLkMcaQrIQDDqCeQxiv3XzSUDrtCm2ootGszZl90IzQj
   n3kCMuonpUfc8oNIBDPd3z+nYN4LSFVt2z4uoAvA2TXocl9XOSQa7iZET
   A==;
X-CSE-ConnectionGUID: ApSz/ZOUSWeyJTD3wrbW2w==
X-CSE-MsgGUID: YMV6eS1YR1a0tqXftVNF5w==
X-IronPort-AV: E=McAfee;i="6700,10204,11288"; a="34174200"
X-IronPort-AV: E=Sophos;i="6.12,242,1728975600"; 
   d="scan'208";a="34174200"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2024 08:02:19 -0800
X-CSE-ConnectionGUID: FpTVphQ0QCe50Aevqj3iLw==
X-CSE-MsgGUID: YSqaj35bR1275uo0MM1xOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="98018723"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa007.jf.intel.com with ESMTP; 17 Dec 2024 08:02:14 -0800
Date: Wed, 18 Dec 2024 00:20:53 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Alireza Sanaee <alireza.sanaee@huawei.com>
Cc: Daniel P =?utf-8?B?LiBCZXJyYW5n77+9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?B?TWF0aGlldS1EYXVk77+9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?utf-8?B?QmVubu+/vWU=?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v2 0/7] Introduce SMP Cache Topology
Message-ID: <Z2Gk5Ta43HJ9ChAT@intel.com>
References: <20240908125920.1160236-1-zhao1.liu@intel.com>
 <20241217142342.00007d96@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217142342.00007d96@huawei.com>

> Hi Zhao,
> 
> I wonder if this patch-set requires rebase for the new cycle?
>

Hi Alireza,

Yes, as some general patches are merged.

(Pls refer the v5: https://lore.kernel.org/qemu-devel/20241101083331.340178-1-zhao1.liu@intel.com/)

I'll send a new version this week, to include the remaining patches
(i386 path and your has_caches flag):

i386/cpu: Support thread and module level cache topology
i386/cpu: Update cache topology with machine's configuration
i386/pc: Support cache topology in -machine for PC machine
i386/cpu: add has_caches flag to check smp_cache configuration

Regards,
Zhao


