Return-Path: <kvm+bounces-16086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF0538B4279
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 01:05:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FA2E1F22593
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 23:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E48273AC1F;
	Fri, 26 Apr 2024 23:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OL+Hx3Jm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB8839FC5
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 23:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714172751; cv=none; b=JxqyYaviKqdHvDMGk1aBUNeoamWYowUbDtSgUMslZBKWEe9Cx70e7UF9YHe1tJfjIdFbYXvJIPOOmV/rqpJKkxoDp4Lg+qZ3NxLy0VEnJ2GiSgJf6AhQaIP7KnIU8QFLpAEaRF6BsigPDI8zZ3J4a1VBm1uy6IYSNhkXMFTGpw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714172751; c=relaxed/simple;
	bh=XMOJK8JNiyETiFujG5JElHagjyI+SL9Uc8ODF4UE0QQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YfDmf4XDXNYAc3OdlA9KzrW/V3SvzXZcrOGkyfUeHqD5x9rfcUeaSe2/MzgYC4lqDyVbtNVP7ktBRpxaYlMLByZndV5kamwfRVKlvIK8PW3Q7sJGvea9E2CFF8ohimtc4RFeZk88+Ixy8QNtsW+O9BeOQunhfD9Wa7QWjgj2FY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OL+Hx3Jm; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714172750; x=1745708750;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XMOJK8JNiyETiFujG5JElHagjyI+SL9Uc8ODF4UE0QQ=;
  b=OL+Hx3Jm4+nSjVZU7EXNvnnzWoeGXbrJnaMwF2lqKfSu3oisT0Bg/acD
   q6YLtEAWxjCptQSfJq+XvU2EiIqQft/NUxSL2by4GV1jZmK5REnQ5RvaE
   rN1agMCQC0dAJAAaTRewI68nqZ3JNd7FpGtkkjEiWlNtxzcNX9RFkFEe5
   zi4fWCFRMhAR/vKMOXrE+49h86zoaYKprJHyrKGWtUT7H6x8op0zzKzyc
   Qa6EfX3v2RfAhtJcO/c3o4v95BFaf+5U4AjDAruUXU16ebRHnlAVwZLgx
   +qj9Xn08nizvu+gheEYOdEH+gM88g3/dyhvCSJvql0BGVbq152b6u7ZyJ
   Q==;
X-CSE-ConnectionGUID: GCgkw0QrSweuFRJa2JEDBg==
X-CSE-MsgGUID: AkqmEIuMS1+qB0JcIwJ+FQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11056"; a="9850169"
X-IronPort-AV: E=Sophos;i="6.07,234,1708416000"; 
   d="scan'208";a="9850169"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 16:05:49 -0700
X-CSE-ConnectionGUID: hCmGHMO6Sk+2GC46ZqVfJA==
X-CSE-MsgGUID: 4gceDbsYRiaQ7n2YcGFRxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,234,1708416000"; 
   d="scan'208";a="25531317"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 16:05:46 -0700
Message-ID: <c75723d7-353e-4208-96bc-865a227f1bac@intel.com>
Date: Sat, 27 Apr 2024 07:05:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] target/i386/confidential-guest: Fix comment of
 x86_confidential_guest_kvm_type()
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240426100716.2111688-1-zhao1.liu@intel.com>
 <20240426100716.2111688-8-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240426100716.2111688-8-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/26/2024 6:07 PM, Zhao Liu wrote:
> Update the comment to match the X86ConfidentialGuestClass
> implementation.
> 
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>

I think it should be "Reported-by"

> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>   target/i386/confidential-guest.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/i386/confidential-guest.h b/target/i386/confidential-guest.h
> index 532e172a60b6..06d54a120227 100644
> --- a/target/i386/confidential-guest.h
> +++ b/target/i386/confidential-guest.h
> @@ -44,7 +44,7 @@ struct X86ConfidentialGuestClass {
>   /**
>    * x86_confidential_guest_kvm_type:
>    *
> - * Calls #X86ConfidentialGuestClass.unplug callback of @plug_handler.
> + * Calls #X86ConfidentialGuestClass.kvm_type() callback.
>    */
>   static inline int x86_confidential_guest_kvm_type(X86ConfidentialGuest *cg)
>   {


