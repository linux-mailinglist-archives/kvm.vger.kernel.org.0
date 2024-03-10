Return-Path: <kvm+bounces-11476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E301877709
	for <lists+kvm@lfdr.de>; Sun, 10 Mar 2024 14:24:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F17D281293
	for <lists+kvm@lfdr.de>; Sun, 10 Mar 2024 13:24:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9F02C6A9;
	Sun, 10 Mar 2024 13:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DT3rYHZO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E141FA5
	for <kvm@vger.kernel.org>; Sun, 10 Mar 2024 13:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710077078; cv=none; b=dSbxsceyp4IDa4oDY7K0MdW7WS46rG+lTiEMU2ke3S1AS/WZRIjzwMEAZjI9MvdoZdUzaobnjFlVR7Ajx6WbL35EBIqjZvGiIv8Fd/0OqNpYQFefBoejmoSHJbloOryWQ3bLBzOqGwjeqB8RJEoai6+r2ukzVVjMgOWk0QjV/kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710077078; c=relaxed/simple;
	bh=Gt/euky25A9+T2umyqp+SyRRMY1VLZnpUw+PY3Wm2U8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pc3/fSikM9rI2eF/Gdml17xVr3MwTr43SU89Bu6tPs3BsYV2d5cOrvZiMeuyBtcBZ0jZ3Jb9QcP5l49iMQ/+O0mREfvh0QT/5Zeyz+U0hiMpxNVvT6g/lb9zFmNvPagS+VwgZvlHM5O9lYCg2fEfsS/lCd17QW/xsFtbSm5cd0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DT3rYHZO; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710077077; x=1741613077;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Gt/euky25A9+T2umyqp+SyRRMY1VLZnpUw+PY3Wm2U8=;
  b=DT3rYHZOcbt0ltoJM+vuJcE4w/ChImk8nfImMqwRyaEb2P7O7cShchel
   3tAqKivpYVccdRsjQ1HLtLDAP5+CA/MYvWJdqCLfRlf5g8an+z3+N5+Nw
   2ts/dq6Ab0TAnBYZ1MyxLACuflUm/DBxKs2BqekRXW3lfyp4wm6Gbwbun
   d6yFUAldUdnK0x2vyHM7YuHDcNWRaGdH7pSHhPUNLnudB4dAX+wab9J7Y
   p9eri4TDfihOFRNDCyrNB3PU+S89UMtHbsJ/9FimuK9TUIRtgeDUMDyYx
   S1z/g8TdlEeQOFTdibw4fvD5o1shS76dF7WT/lwGxVZkW8zYz8KF5dEOc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11008"; a="4670775"
X-IronPort-AV: E=Sophos;i="6.07,114,1708416000"; 
   d="scan'208";a="4670775"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 06:24:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,114,1708416000"; 
   d="scan'208";a="41898226"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 10 Mar 2024 06:24:31 -0700
Date: Sun, 10 Mar 2024 21:38:19 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH v9 06/21] i386/cpu: Use APIC ID info to encode cache topo
 in CPUID[4]
Message-ID: <Ze23y7UzGxnsyo6O@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <20240227103231.1556302-7-zhao1.liu@linux.intel.com>
 <c88ee253-f212-4aa7-9db9-e90a99a9a1e3@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c88ee253-f212-4aa7-9db9-e90a99a9a1e3@intel.com>

Hi Xiaoyao,

> >               case 3: /* L3 cache info */
> > -                die_offset = apicid_die_offset(&topo_info);
> >                   if (cpu->enable_l3_cache) {
> > +                    addressable_threads_width = apicid_die_offset(&topo_info);
> 
> Please get rid of the local variable @addressable_threads_width.
> 
> It is truly confusing.

There're several reasons for this:

1. This commit is trying to use APIC ID topology layout to decode 2
cache topology fields in CPUID[4], CPUID.04H:EAX[bits 25:14] and
CPUID.04H:EAX[bits 31:26]. When there's a addressable_cores_width to map
to CPUID.04H:EAX[bits 31:26], it's more clear to also map
CPUID.04H:EAX[bits 25:14] to another variable.

2. All these 2 variables are temporary in this commit, and they will be
replaed by 2 helpers in follow-up cleanup of this series.

3. Similarly, to make it easier to clean up later with the helper and
for more people to review, it's neater to explicitly indicate the
CPUID.04H:EAX[bits 25:14] with a variable here.

4. I call this field as addressable_threads_width since it's "Maximum
number of addressable IDs for logical processors sharing this cache".

Its own name is long, but given the length, only individual words could
be selected as names.

TBH, "addressable" deserves more emphasis than "sharing". The former
emphasizes the fact that the number of threads chosen here is based on
the APIC ID layout and does not necessarily correspond to actual threads.

Therefore, this variable is needed here.

Thanks,
Zhao


