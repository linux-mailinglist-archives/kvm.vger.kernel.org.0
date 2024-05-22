Return-Path: <kvm+bounces-17932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CE5F8CBBB7
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 09:07:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18B9B282661
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 07:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32CC87C0B7;
	Wed, 22 May 2024 07:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UVGceNdS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E634B7BAF4;
	Wed, 22 May 2024 07:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716361655; cv=none; b=XDX9DpyIKezUWWrZ+Xv9DC1Uc6eIae0cEIyQ9DqpPBC5BtnD48AZAo96O1J0DyraShKhC5L6psjgRX90KlMFh4QjUGpDUawu81yVH6rTf33izez6fsYphLW/C63S2Ip+XRlYJOtr+q5EvWp21DJBODG5l0/+8rU/uko5N0qQKR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716361655; c=relaxed/simple;
	bh=Kk/uCIT4I7SCt+XNe4kfIBKvOWlAOSPlgBUKydzRcNU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Rch0ZAK2kzQjogFrH/9XzmFeykslAf3Z1tlFD1AV05QAeOkxQ6lCJOhDkzbim6HsOKk7rxdlxH8ddHxYvW55Qx4mYAAvc8Rb/ZuJMEMhkYm/D3AK7nLAnf7Kn6j+oBVT7mkvq/Tzxg6VfewKvFyC0JYdElUFQ7td7rqh9xMqaZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UVGceNdS; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716361654; x=1747897654;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=Kk/uCIT4I7SCt+XNe4kfIBKvOWlAOSPlgBUKydzRcNU=;
  b=UVGceNdSKRhjqJBSUqCQHjOfKU3Nby91osH4GINfg79ILoFV5t6I0hK4
   kX1dK9XuvlSYtckErOxIdOVbCHzom0Lq/DlNo3udT0ZmRb3zV3OFIruQM
   XT6rJ9lAFEyHkYe6kFCsKRpGWP3q6OpHT37gAJuFNfvz87EGRfROTDw65
   dFySfPTdBIzbbRWO7PQm1RLHepYo6usSCpu0nTThD6d7F1qjO/LPWaWWL
   qtDRQMQNQ1YkFgBc0YXJ4oJmQF7gkybEA+uIRxlz2ldIoqouF5gOYV0eH
   rQuOJx3s1wVuawZicaYzXFilxDsWDjjnBO1Ch5bjntMIWIConbt/MwgUr
   Q==;
X-CSE-ConnectionGUID: jfvXVFH2STW0yY1oo5cq2w==
X-CSE-MsgGUID: vevhyDKWQ5ShzfkVhsFonA==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="16383390"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="16383390"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 00:07:33 -0700
X-CSE-ConnectionGUID: JDN9p/hYQg+DrohsP06G7Q==
X-CSE-MsgGUID: SWkxSu1sTcOnRMUA2Px0+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="37666988"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 00:07:31 -0700
Message-ID: <2d384258-b5eb-432b-9ea4-03b1a51dd386@intel.com>
Date: Wed, 22 May 2024 15:07:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 04/10] KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to
 asm/vmx.h
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, Shan Kang <shan.kang@intel.com>,
 Xin Li <xin3.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20240520175925.1217334-1-seanjc@google.com>
 <20240520175925.1217334-5-seanjc@google.com>
 <46dae102-b6b0-4626-a33e-c20b08e97a14@intel.com>
Content-Language: en-US
In-Reply-To: <46dae102-b6b0-4626-a33e-c20b08e97a14@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/22/2024 2:48 PM, Xiaoyao Li wrote:
>> +#define VMX_BASIC_DUAL_MONITOR_TREATMENT    BIT_ULL(49)
> 
> why add it?

It gets used in Patch 6.

So either mention it in change log, or move it to patch 6.

