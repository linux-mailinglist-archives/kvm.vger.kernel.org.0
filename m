Return-Path: <kvm+bounces-29081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FCFF9A2529
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 16:35:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7B331C235BF
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 14:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1E071DE8BA;
	Thu, 17 Oct 2024 14:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uld+QFDL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404381DE2DA
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 14:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729175699; cv=none; b=rgOo3As3WopQEXNwfb9J4n2pdPut0/5hxhNagTlJYO0o4mgTRL/yhPE8wJbFJWZ5aBxqQw04DrCKRlcOjVXdNi6Rmp/ZOHfGHwUCW2OvxtxcJvYhN60kbFI8O2/3B76MW/KK4N9yBKOyg0z//PmiSjBuD17tkcQ/El3wEmeJ0Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729175699; c=relaxed/simple;
	bh=CVMfqVFPC1FfKWUvGbQ6UhJ7jsGmHq8fERdx02Rk3c8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOKwIOXbtKSqTv9h9AsZdBRM4rldfKjWr9y0/w3bXQHJIvRc8bvHFeFt4Ogf7OnWYvvah87u6ISM3/MA7BP2X//uJrI86nxCXF7bJvDnXYnSIIpb/RL2EeGI1VudZz8KTN54xS9i2jlh6179L7lDT+e66vM57vAqKcavhePAFoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uld+QFDL; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729175698; x=1760711698;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CVMfqVFPC1FfKWUvGbQ6UhJ7jsGmHq8fERdx02Rk3c8=;
  b=Uld+QFDLGQ3vbbz8GcuXWJ4Hd8Df9c0xiE47i0RoQ9zWBhoOs404CBiD
   jbZoq/+YIotrthquu6kOw4EKSLUOGAiI85a0RoaFpZc8/3R8U5LjCA1Zq
   yUHUGhDnh5bWLBEOeEUMJKPo3aThskRfj+HInHP4/vIy17zbwm7lpDTVD
   LhH/jU6SU7jkVWzkSQy4lds0+rtOn7PuYp31Th3NRxmMGsZlXkWjXbXle
   G1lLXbajQnYHThgqb6dSCGfk2qYFuMGA0C3KPI7wUfSAmoNprAq/XOPE7
   o5AbuQ9qUF2uaKDh1FpjMqDxy8OiYGPXqR3/dS5xq1Hggqfj1oVGafy6v
   Q==;
X-CSE-ConnectionGUID: tQg1lUi8RDOItIQ4HpY6kg==
X-CSE-MsgGUID: dbzOTbHkQz6jOQscisCapA==
X-IronPort-AV: E=McAfee;i="6700,10204,11228"; a="28546002"
X-IronPort-AV: E=Sophos;i="6.11,211,1725346800"; 
   d="scan'208";a="28546002"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 07:34:57 -0700
X-CSE-ConnectionGUID: iFCeQvUHQD6EsOtiz6LP5g==
X-CSE-MsgGUID: RrpgABK9Q/aTX6hvU38pWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,211,1725346800"; 
   d="scan'208";a="83116369"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa005.fm.intel.com with ESMTP; 17 Oct 2024 07:34:51 -0700
Date: Thu, 17 Oct 2024 22:51:07 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Markus Armbruster <armbru@redhat.com>
Cc: Daniel P =?utf-8?B?LiBCZXJyYW5n77+9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?B?TWF0aGlldS1EYXVk77+9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S.Tsirkin " <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?utf-8?B?QmVubu+/vWU=?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v3 1/7] hw/core: Make CPU topology enumeration
 arch-agnostic
Message-ID: <ZxEkW84fcf4pCK0w@intel.com>
References: <20241012104429.1048908-1-zhao1.liu@intel.com>
 <20241012104429.1048908-2-zhao1.liu@intel.com>
 <20241017095227.00006d85@Huawei.com>
 <20241017142013.00006c41@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017142013.00006c41@Huawei.com>

(Ping Markus)

> > > +
> > > +##
> > > +# @CpuTopologyLevel:
> > > +#
> > > +# An enumeration of CPU topology levels.
> > > +#
> > > +# @invalid: Invalid topology level.  
> > 
> > Really trivial but why a capital I on Invalid here but not the
> > t of thread below?

Oops, thank you! It should be "invalid".

If Markus doesn't veto this version :), I'll standardize the case issues
in this file later. Some cases are uppercase, while others are lowercase.

> > > +#
> > > +# @thread: thread level, which would also be called SMT level or
> > > +#     logical processor level.  The @threads option in
> > > +#     SMPConfiguration is used to configure the topology of this
> > > +#     level.  
> > 
> 

