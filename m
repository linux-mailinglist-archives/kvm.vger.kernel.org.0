Return-Path: <kvm+bounces-11446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 002D1877181
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 14:48:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88C9D1F21648
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 13:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3F6C4085D;
	Sat,  9 Mar 2024 13:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PWlKLujB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370D73BBD4
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 13:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709992123; cv=none; b=Y7w5eGZFc5CAwMJUEDhza11kt11AxA/k8jtrSlLAiiGwTfuuYP+MzTZYMtJiCRRc8QyjGCVs1vPxG07gP0orqlilFl+w9yQ4i3+6YW0xWEwPY0yTZYThn/X/mdur+owb4mfs8cg3wwe2zVLWGwaYwt11wJnwm/DLiCw2ovsQm98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709992123; c=relaxed/simple;
	bh=ZsbNRgKa8jRlouM8lJsQdY6Y2ydgaQ/O7g7M2CP5sNc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j+1xspJw2a99d/il1/j5N+x9Bj8m1uDCUThREA9x4ZplqvKTdVqnnGaJq9xOLJYRaper3hbWhoWqvz0CK303fNDCUfY5IHD0MbdQU5GpzNOOHTTBG8frBexEq8G6FcUKdwyLmehQIe0gr8p3S2p9R3prbhHEKi2yeS0N1eG73Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PWlKLujB; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709992122; x=1741528122;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZsbNRgKa8jRlouM8lJsQdY6Y2ydgaQ/O7g7M2CP5sNc=;
  b=PWlKLujBtTiPrsPm0ADUwmJuWmoqReJCoz4fIVrKhytxe592lk4HBfHV
   tGoPcAPezT4EC4HVY6MzR3uJwC1VulwERdUQ+tDZPOlIcZ5ZelwRiRKLb
   GDU9vWYDKmmLSObFoqGzqhfd3pPJf97elXUWI1oatZYE/uFYJDYx3Qee2
   SKFlQRXpPTuMicupZmz2MOSBglOXWSAmIEuCQy3F0+iGntGdiKbYwNSa3
   3V60WPxujD2OVimjxySpH0IbVOGNmsAs7Go0Cs5HEpxrcSRXZDn/L0kDd
   6qPkrrTyFOQygzAKX0cwZinBU6oi1E+pfoNj/l/IZvwVGB+KWp6e5/Ugw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11007"; a="7660227"
X-IronPort-AV: E=Sophos;i="6.07,112,1708416000"; 
   d="scan'208";a="7660227"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2024 05:48:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,112,1708416000"; 
   d="scan'208";a="15335297"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2024 05:48:37 -0800
Message-ID: <89ed09f2-c139-46b1-b76a-8fa3522cc1ed@intel.com>
Date: Sat, 9 Mar 2024 21:48:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 08/21] i386/cpu: Consolidate the use of topo_info in
 cpu_x86_cpuid()
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Babu Moger <babu.moger@amd.com>,
 Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Robert Hoo <robert.hu@linux.intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <20240227103231.1556302-9-zhao1.liu@linux.intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240227103231.1556302-9-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/2024 6:32 PM, Zhao Liu wrote:
> From: Zhao Liu<zhao1.liu@intel.com>
> 
> In cpu_x86_cpuid(), there are many variables in representing the cpu
> topology, e.g., topo_info, cs->nr_cores and cs->nr_threads.
> 
> Since the names of cs->nr_cores/cs->nr_threads does not accurately

Again as in v7, please changes to "cs->nr_cores and cs->nr_threads",

"cs->nr_cores/cs->nr_threads" looks like a single variable of division

> represent its meaning, the use of cs->nr_cores/cs->nr_threads is prone
> to confusion and mistakes.
> 
> And the structure X86CPUTopoInfo names its members clearly, thus the
> variable "topo_info" should be preferred.
> 
> In addition, in cpu_x86_cpuid(), to uniformly use the topology variable,
> replace env->dies with topo_info.dies_per_pkg as well.


