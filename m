Return-Path: <kvm+bounces-10352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C6186BFE5
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 05:33:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A73A1F2523D
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 04:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02955383A9;
	Thu, 29 Feb 2024 04:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EUyCAI++"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE31812
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 04:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709181200; cv=none; b=iCoxBy+TuR8Hrt8GdweDdwyAX2t/yGHhy8BUlQD9DxJDEVExDbJuduRAN6qEN/L8QAXKtyCyrOxPbisPdq+SYn1rU19wJ52sru2bED3W/CoMVl2aUMbqsQAV0Y3ywszfYV3u4OAbLZ99EUdkiNLyPA1yGIlW3E8/a6CmUlbyFYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709181200; c=relaxed/simple;
	bh=K4P+3be7WkAmiqJGY461bGaJxoGNESikO7CzVS0rHDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k2esAjL4Zk/Zgye2bZywSEHvYiw5A7/HbZC4hjuMFyjhyzF7yhxpbrV50rRs7LhAJeWyXar7ACyWaDD50ar30UnfCkedEJOJWUPWDBoUhpVl+Q1S5D12ZhXzXmSqKN1PELYuDqjPq+enRroADKj3Crm1oNxpGZlIPH4gXVzWJb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EUyCAI++; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709181198; x=1740717198;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K4P+3be7WkAmiqJGY461bGaJxoGNESikO7CzVS0rHDM=;
  b=EUyCAI++iQCYv72/IbQsxhOPb6EvNKNXBIvq7TvXHmnR1LXYggCjThBY
   eKwZX8c5/QCSb+jW14sryVZoA9bj1PLyVXV30R072OSWlwjZjiFLfIEtQ
   t0jJAcypGe0XhKVQ2e8b+ueEoQiJyGEkNMbrzIj1NinzRFS0MvEPktuAi
   FT8sTxiMDsj4qXoDRXybR7Grq163HGD5ybQAmf0kjdG6noYiUvjOruaYS
   I1T7pAQ/snGBN0O9hxuP02iiVJFMnnvwbyr7uT/Zex9H5/S8sN3X55R1m
   cRB0/PIpMyl3RamR6PDvL0w4s3HyGbwLk2FLP0rEoxlUIz5rqOOc4B7CS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="14338803"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="14338803"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 20:33:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="38526829"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa002.jf.intel.com with ESMTP; 28 Feb 2024 20:33:12 -0800
Date: Thu, 29 Feb 2024 12:46:55 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: JeeHeng Sia <jeeheng.sia@starfivetech.com>
Cc: Daniel P =?utf-8?B?LiBCZXJyYW5n77+9?= <berrange@redhat.com>,
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
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"qemu-riscv@nongnu.org" <qemu-riscv@nongnu.org>,
	"qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [RFC 2/8] hw/core: Move CPU topology enumeration into
 arch-agnostic file
Message-ID: <ZeAMP7OCwWPMhpeD@intel.com>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
 <20240220092504.726064-3-zhao1.liu@linux.intel.com>
 <BJSPR01MB05614B900DA2E93AE9F8E0BE9C58A@BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BJSPR01MB05614B900DA2E93AE9F8E0BE9C58A@BJSPR01MB0561.CHNPR01.prod.partner.outlook.cn>

Hi JeeHeng,

> > +const char *cpu_topo_to_string(CPUTopoLevel topo)
> > +{
> > +    return cpu_topo_descriptors[topo].name;
> > +}
> > +
> > +CPUTopoLevel string_to_cpu_topo(char *str)
>
> Can use const char *str.

Okay, I'll.

> > +{
> > +    for (int i = 0; i < ARRAY_SIZE(cpu_topo_descriptors); i++) {
> > +        CPUTopoInfo *info = &cpu_topo_descriptors[i];
> > +
> > +        if (!strcmp(info->name, str)) {
>
> Suggest to use strncmp instead.

Thanks! I tries "l1i-cache=coree", and it causes Segmentation fault.
Will fix.

> > +            return (CPUTopoLevel)i;
> > +        }
> > +    }
> > +    return CPU_TOPO_LEVEL_MAX;
> > +}

> > @@ -304,7 +304,7 @@ static uint32_t num_threads_by_topo_level(X86CPUTopoInfo *topo_info,
> >                                            enum CPUTopoLevel topo_level)
> >  {
> >      switch (topo_level) {
> > -    case CPU_TOPO_LEVEL_SMT:
> > +    case CPU_TOPO_LEVEL_THREAD:
> >          return 1;
> Just wondering why 'return 1' is used directly for the thread, but not
> for the rest?

This helper returens how many threads in one topology domain/container
at this level.

For thread level, it calculates how many threads are in one thread
domain, so it returns 1 directly.

Thanks,
Zhao


