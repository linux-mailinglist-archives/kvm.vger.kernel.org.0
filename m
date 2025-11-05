Return-Path: <kvm+bounces-62048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C00DAC35217
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 11:39:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 694594E67CC
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 10:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44E302E62A8;
	Wed,  5 Nov 2025 10:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ynv1pybh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7108A3019B5
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 10:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762339173; cv=none; b=dJ5UcDn62qboBHsdQB88AT0QPWL31bwLpqfclB7N2rwnXESw4prH6JoycJ0kpYhnMMhKS5DaumvO9qRArXb2YUag7vHElc1ZCpZ6kCAXn47jDf/pcmEUPM2jRNt4Cf4u1bDXn9rMqhFhPNPL9t8v3+Z3fz+tWRE9VXHPcglkZvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762339173; c=relaxed/simple;
	bh=5085uEIbKIBFCqGBmaKcUQr+3PnBlKPDZ5wQ2+/cins=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eLef5loZxvJkrOouiviAuVQRPK9J9lMFQh9UVK3EPW0zNm4zHxGUaU+2e4ZwPmC9hCFpMPU9EHd6d6pwr8pRDv/eVJoJDaU6AOF/04ecFB/LxSKeaFnw0zie+My3nODJkhh8Wuqry7aGrNPfXrBa6/ARgG+JRVsD05MhBoaajLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ynv1pybh; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762339172; x=1793875172;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5085uEIbKIBFCqGBmaKcUQr+3PnBlKPDZ5wQ2+/cins=;
  b=Ynv1pybhA8D3jn5RUK+ojC/6fIdmcpy8nDkepiTumBcTGZ2PfsnxKFuP
   QOUl1I5GKwhRq3iW8LEf9fEy6i0TtW1caioJIKt59aHJdD5cjzHPypJvh
   A0KpbtxZvosfginY7ZQywLXKxHS1WaS2gfXCv4mQSItvCjrArh1QSKvPX
   RtkXb3PGlP+QBGWzlVr3AzzDIE8SSTbvNADddjJtrzAWqGZ3QXOQdbgF6
   Iv2s+r7BeOIKQx0jzruMMDGnAPVPHSOAvw0r559lrcgrYvfBDXukVt72Y
   NrYj4vZ2LMADkgjKF+3G2QYnif+aNGD7xriD2bgPWLajqVgwlnoMCpCmb
   A==;
X-CSE-ConnectionGUID: EXC16uR9SiOw1ueLhT+BGw==
X-CSE-MsgGUID: 9et6TF+AR8aZMH1UVg2qeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="64598455"
X-IronPort-AV: E=Sophos;i="6.19,281,1754982000"; 
   d="scan'208";a="64598455"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 02:39:20 -0800
X-CSE-ConnectionGUID: U8PLu0kuQFanWNF3e2W3Dg==
X-CSE-MsgGUID: vR34c48pSOeMKHBOXdJ3Ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,281,1754982000"; 
   d="scan'208";a="187580928"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.49]) ([10.124.240.49])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 02:39:15 -0800
Message-ID: <d3c34223-ab23-488b-8502-c4b5b85047d3@intel.com>
Date: Wed, 5 Nov 2025 18:39:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/20] i386/cpu: Add missing migratable xsave features
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-11-zhao1.liu@intel.com>
 <0dc79cc8-f932-4025-aff3-b1d5b56cb654@intel.com> <aP9HPKwHPcOlBTwm@intel.com>
 <aP9VF7FkfGeY6B+Q@intel.com> <308bcfcd-6c43-4530-8ba7-8a2d8a7b0c8f@intel.com>
 <aQOKw/2lxg/EjyDY@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aQOKw/2lxg/EjyDY@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/2025 11:56 PM, Zhao Liu wrote:
>> can you elaborate what will be broken without the patch?
> 
> Obviously, the migratable_flags has been broken.
> 
>> As I commented earlier, though the .migrable_flags determines the return
>> value of x86_cpu_get_supported_feature_word() for
>> features[FEAT_XSAVE_XCR0_LO] in x86_cpu_expand_features(), eventually the
>> x86_cpu_enable_xsave_components() overwrites features[FEAT_XSAVE_XCR0_LO].
>> So even we set the migratable_flags to 0 for FEAT_XSAVE_XCR0_LO, it doesn't
>> have any issue.
> 
> No. this seemingly 'correct' result what you see is just due to
> different bugs influencing each other: the flags are wrong, the code
> path is wrong, and the impact produced by the flags is also wrong.
> 
>> So I think we can remove migratable_flags totally.
> 
> migratable_flags is used for feature leaves that are non-migratable by
> default, while unmigratable_flags is used for feature leaves that are
> migratable by default. Simply removing it doesn't need much effort, but
> additional clarification is needed - about whether and how it affects
> the migratable/unmigratable feature setting. Therefore, it's better to
> do such refactor in the separate thread rather than combining it with
> CET for now.

I meant we don't need to bother touching .migratable_flags field as this 
patch because it doesn't make any difference to the functionality. Just 
drop it from the series and feel free to clean it up with a separate series.

> Regards,
> Zhao
> 
> 


