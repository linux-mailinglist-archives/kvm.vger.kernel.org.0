Return-Path: <kvm+bounces-61455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B459C1E58E
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 05:30:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0344B400CB4
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 04:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66AC02FABE0;
	Thu, 30 Oct 2025 04:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eZBsmjJZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DCF2F60A3
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 04:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761798604; cv=none; b=PZ/NvYDP/UhmAFWPJC8qN4iCkv1NkQbhuq2vnGBBP5gYnc+qwxVIdO7w5iJ0MDk7YpIeEPXsHbKIUOx+OMS/6dfsEycddnoYmIGsEO1r7lLDSGyoG9lyvOSepAw+7/CNgErE5rbOnfrRfQr87Xk6VKM0S/b49tE9Y+A+wvsBzxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761798604; c=relaxed/simple;
	bh=u7PuITfx4IeFAa8s+tPsssN46kIRp4aS74VUU7N6W48=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dSrQ9itYPNHtLE1tzuXVj29+InxUUg4rVCrJY3EKRiHD0i6stZO0Admj8giS1gije09JOSsghAzXdj3uE7P9zbvJK9gmilzzOgHl9hMf2Gk0oKHqwvkt7l0lY5C/vsqlbuY3s+Rme5oLDMm2Wv7QL35KdblVb01i3tc3zPKkWrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eZBsmjJZ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761798603; x=1793334603;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u7PuITfx4IeFAa8s+tPsssN46kIRp4aS74VUU7N6W48=;
  b=eZBsmjJZOWU390hyYzJYgnNkvdw+FczLyYxHNKCXPBg2J4ifxTxj9u04
   jdOaxn3WlLrivn2ihpAL5164a3ctUigtnNi4yr8sb07OJTxmVA01orzc9
   LV9nQFq+DCYlFAzQFM/ogx1rWILt58KqlvqOpUIxBOjZT5o1d3wvKACzN
   lYI9QiL/xXu4aFBZbxDJseen8++9R5/WiblTTD8nQxClKgdbQU+A+0Oq2
   OexFgpcWvRKmik36fQ7mC4KbYL0KUj0IHhcM7Ubb4zm/a/AYWX4J4cz8I
   OgGXVslolWuY+THRzNhlv9dbj+K2vChCAQ7fJpHm4YlZMv6mg4q3yPlxj
   w==;
X-CSE-ConnectionGUID: cRabA/G3RKWjrCgU1Ppm0A==
X-CSE-MsgGUID: uUxKx2csTAuSB6whtdPanQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63834263"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63834263"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 21:30:01 -0700
X-CSE-ConnectionGUID: iS6zRn3IRu2hIWFWiaXczw==
X-CSE-MsgGUID: 0JqmzqhuRoihmN4bC/MmsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="191018131"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 21:29:57 -0700
Message-ID: <4806bc74-e4c2-4aa1-b003-e72895a11f11@intel.com>
Date: Thu, 30 Oct 2025 12:29:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/20] i386/cpu: Enable xsave support for CET states
To: Chao Gao <chao.gao@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 John Allen <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, Dapeng Mi <dapeng1.mi@intel.com>,
 Zide Chen <zide.chen@intel.com>, Chenyi Qiang <chenyi.qiang@intel.com>,
 Farrah Chen <farrah.chen@intel.com>, Yang Weijiang <weijiang.yang@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-12-zhao1.liu@intel.com> <aQGe66NsIm7AglKb@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aQGe66NsIm7AglKb@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/2025 12:58 PM, Chao Gao wrote:
> On Fri, Oct 24, 2025 at 02:56:23PM +0800, Zhao Liu wrote:
>> From: Yang Weijiang <weijiang.yang@intel.com>
>>
>> Add CET_U/S bits in xstate area and report support in xstate
>> feature mask.
>> MSR_XSS[bit 11] corresponds to CET user mode states.
>> MSR_XSS[bit 12] corresponds to CET supervisor mode states.
>>
>> CET Shadow Stack(SHSTK) and Indirect Branch Tracking(IBT) features
>> are enumerated via CPUID.(EAX=07H,ECX=0H):ECX[7] and EDX[20]
>> respectively, two features share the same state bits in XSS, so
>> if either of the features is enabled, set CET_U and CET_S bits
>> together.
>>
>> Tested-by: Farrah Chen <farrah.chen@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> Co-developed-by: Chao Gao <chao.gao@intel.com>
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
>> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> 
> It just occurred to me that KVM_GET/SET_XSAVE don't save/restore supervisor
> states. Supervisor states need to be saved/restored via MSR APIs. So, there
> is no need to add supervisor states (including ARCH_LBR states) to
> x86_ext_save_areas[].

x86_ext_save_areas[] is not used only for xsave state, it's also used 
for the setup of xsave features, i.e., CPUID leaf 0xD.

And you did catch the missing part of this series, it lacks the 
save/restore of CET XSAVE state in 
x86_cpu_xsave_all_areas()/x86_cpu_xrstor_all_areas()

