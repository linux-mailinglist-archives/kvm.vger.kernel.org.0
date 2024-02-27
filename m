Return-Path: <kvm+bounces-10069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B32A8868D63
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 11:22:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD87D1C241CF
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1175137C34;
	Tue, 27 Feb 2024 10:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nzuhbAJF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC93137C5E
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 10:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709029321; cv=none; b=I9B4osF//jeaRCXi2F+gGgKoZ1zYzCYvRoupmjiLidVTDr/t4OcccSttlTkBWxtSYZeqk1luhMdEaxXqaOM+j4yldBlciTzD7dnRo/Bn8D6r/DLURwuHZHgeEmXS/rPyNct6D+2qUmhkurKX/64aH/mBcQjCtlX9GAZuRbW3hhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709029321; c=relaxed/simple;
	bh=F6+NTEf+OvKxItgO+SSdOalGV2SCEFkd9K7C26e6mKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OWPZB/ojdn/PQ9mjrEiukITZPj+sCfwi8DEUpha4lhM6alfuxkcuZO6lCMsLOuqB6ctBSvYp6nBDnPWiE0K1fE4sMHT9XIOtIYkpRYFYE+6o11I51T26tQj5QAHpzj348W1N7Md1e29gIblm1UZP3ySLqiNM02ebTmlohOBoS+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nzuhbAJF; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709029320; x=1740565320;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F6+NTEf+OvKxItgO+SSdOalGV2SCEFkd9K7C26e6mKo=;
  b=nzuhbAJFrWm0NRdVfxcRZVZoFCdaR8oBkEOhrElIv1pj2HcOsvc9wVN4
   p0xSTLEz2oiCl7s36M8/JYQWJdw8pbxjDDeCJn7itfEuV7L+COoHLal9c
   liWsF73zQrvPm8RqdGBtj7/h55ZBImBYjiZbtW7eVuiLqXB7GOu0dz+f2
   e5AWsYCe6+uBpTFSqHJj3+UfFtzHTjqKMkOwpU96QE2fMjUlEkw9eYZly
   3SqNMi3EfsDnMrYrORN5uLAcvN7LPghUq3xxou4DTEdNJySpVJ0u1Rs6e
   gWpAgB0yLHa0kH5QnovDRfkkR9d2gTEq50gCOoFm9u2IzTxbjzkXd6BET
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="14071185"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="14071185"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 02:21:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="11587755"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 27 Feb 2024 02:21:53 -0800
Date: Tue, 27 Feb 2024 18:35:36 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
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
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [RFC 4/8] hw/core: Add cache topology options in -smp
Message-ID: <Zd26+BpXQID95lqm@intel.com>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
 <20240220092504.726064-5-zhao1.liu@linux.intel.com>
 <20240226153947.00006fd6@Huawei.com>
 <Zd2pWVH4/eo3HM8j@intel.com>
 <Zd2ndJghXbmMHzBn@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd2ndJghXbmMHzBn@redhat.com>

> > > > +        if (smp_cache_string_to_topology(ms, config->l1d_cache,
> > > > +            &ms->smp_cache.l1d, errp)) {
> > > 
> > > Indent is to wrong opening bracket.
> > > Same for other cases.
> > 
> > Could you please educate me about the correct style here?
> > I'm unsure if it should be indented by 4 spaces.
> 
> It needs to look like this:
> 
>         if (smp_cache_string_to_topology(ms, config->l1d_cache,
>                                          &ms->smp_cache.l1d, errp)) {
> 
> so func parameters are aligned to the function calls' opening bracket,
> not the 'if' statement's opening bracket.
>

Thanks for your explaination!

Regards,
Zhao


