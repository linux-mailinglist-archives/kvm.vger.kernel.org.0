Return-Path: <kvm+bounces-48972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5460AD4CAB
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 09:31:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8A023A862B
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 07:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 576DE230BE2;
	Wed, 11 Jun 2025 07:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KIDQtvpO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED762F85B;
	Wed, 11 Jun 2025 07:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749627068; cv=none; b=sQ2vMOUCMeQdB6FMSySSAfmFOvfQCdp6ydVKirmbq6+A91vRtvLT1V8xJ4PfyPmNIZDQi/8pnq4E2OfP1xkPxWGTHJrAn/KN6Dv2Hv6QovRcq4HirF4QO2HBYfMEf8Jw4XjzoLxSBON3AtVBRu0qCPRnjIUjrXIRRp9FyLi/gwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749627068; c=relaxed/simple;
	bh=5MdI/iDwHBTHKaErNZaK89tcWsio8Sj+Ml2VksuOC/Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KSI2lzmXP3bXH3Mri1HM9vXnPDO/alcItFJgqnWYJp6x6PZNjCfxnaetEmxg2wQ2663EP08pQahFWXvuafL5tP1zZgDBFPJD5bowsEwwJeo9lT72tAHX5ysfX4V3N6ldBgzr52ZmWKi7lhzWMnUhUzotBMDbm6xzT7t//oJAeKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KIDQtvpO; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749627068; x=1781163068;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5MdI/iDwHBTHKaErNZaK89tcWsio8Sj+Ml2VksuOC/Y=;
  b=KIDQtvpOM/A2ll9rm3K2oDa1wOaE4Av/DQwr9NrtxiIfSK6CKhQi9TCN
   sk50Q/7whoi0hZXoOdP192k55tHd6o1CUHxUgvU7oAxtUYXvmJtfrLdgy
   DOxjcJmVcv2gWDEbqEx+SACvPqFbUNlKgyqf+KPVbIs+u0vGG/YCu1wv/
   Oix61//M6trob4B4zZaHZ7qHZUf86/+qv5FFlhDuXcyllSY9QiV3JbK3/
   QtG//5iNCyKhsDaEdgerlTYt5cYK2UNB349a+fMr5FXGAkuOrDr5hP147
   IuKCieNppx7TB6HChOuFRfU/7O/mUeoZ7pu8x6+QV/okWmxSCnpVr41Z/
   g==;
X-CSE-ConnectionGUID: UCAG/zQ6R5WAsK55VbHOBg==
X-CSE-MsgGUID: SYs+YsEWQ7iDZr+PiIPqWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="62795719"
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="62795719"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 00:31:07 -0700
X-CSE-ConnectionGUID: zaXYcOu6Qx2AzVSQkQxnnw==
X-CSE-MsgGUID: yQ768NV8RkmPFy0qVcXpLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="152231710"
Received: from unknown (HELO [10.238.0.239]) ([10.238.0.239])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 00:31:03 -0700
Message-ID: <323c9840-24b7-43d8-b08f-659287693555@linux.intel.com>
Date: Wed, 11 Jun 2025 15:31:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/32] KVM: SVM: Implement and adopt VMX style MSR
 intercepts APIs
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
 Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>,
 Manali Shukla <Manali.Shukla@amd.com>
References: <20250610225737.156318-1-seanjc@google.com>
 <20250610225737.156318-15-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250610225737.156318-15-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/11/2025 6:57 AM, Sean Christopherson wrote:
> Add and use SVM MSR interception APIs (in most paths) to match VMX's
> APIs and nomenclature.  Specifically, add SVM variants of:
>
>          vmx_disable_intercept_for_msr(vcpu, msr, type)
>          vmx_enable_intercept_for_msr(vcpu, msr, type)
>          vmx_set_intercept_for_msr(vcpu, msr, type, intercept)
>
> to eventually replace SVM's single helper:
>
>          set_msr_interception(vcpu, msrpm, msr, allow_read, allow_write)
>
> which is awkward to use (in all cases, KVM either applies the same logic
> for both reads and writes, or intercepts one of read or write), and is
> unintuitive due to using '0' to indicate interception should be *set*.
>
> Keep the guts of the old API for the moment to avoid churning the MSR
> filter code, as that mess will be overhauled in the near future.  Leave
> behind a temporary comment to call out that the shadow bitmaps have
> inverted polarity relative to the bitmaps consumed by hardware.
>
> No functional change intended.
>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

[...]

