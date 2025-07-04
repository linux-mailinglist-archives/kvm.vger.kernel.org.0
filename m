Return-Path: <kvm+bounces-51537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B0C63AF864C
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 06:15:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 453171C81C3F
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 04:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 903BC19D8A7;
	Fri,  4 Jul 2025 04:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XVAbjFI0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202388634C
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 04:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751602509; cv=none; b=edLBMYeojgwmNyuSvMzfFEtUv9RwPux2yYD28UWKln1Wog+tblQAo+iVz9FlwRsApICKogS3tjtnTLOkOmey7t0nDUeNAW7oUKvX5ultJFKTT11CHLp7Iy0xzaZNCHg5xI4KL0LhGHnOptwapjkArgvZV75XxFy1YEnKzH4f9oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751602509; c=relaxed/simple;
	bh=j0T+n+kKsiIh9zeZR3+iPsUcnO8aKeIWUB4OkExJkJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gpg2Nugkpz0cCK466KMkgj33LHcNDkTQNpQ5tsQLJFT8pfkkwkmaQq/kqhdEoGZGzAxa/bFwqZwT5Slb7Gw6Q4kffHxqblT3gVpN35j2PNEMLN5wIV+IqTBivIiV6v+MsEXTiOkQJbMZp9FzeIZO7+bQVHMkvqL5oHxCmmLi/UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XVAbjFI0; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751602508; x=1783138508;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=j0T+n+kKsiIh9zeZR3+iPsUcnO8aKeIWUB4OkExJkJ0=;
  b=XVAbjFI0Mr0x+5Nybs8zoDn1gIenPf0F6D/xrHykpUjAS7t4LsTaZzRI
   mhEv8Fi2HOLnIAjrefUtWk+KT5oE+WJFjx+8lYZ7DQgdrMd3s4qB6e8uu
   3osBOwRo8GYiwWT5sPh+oalIFA8bEapEnaHz4g4JGMPo6aB2ocdOvet3r
   5Iu7xwbcWwkuJXW1fJmOgs+Jd9XNBlfDPTsvBKZM0kXJ1xcJUBHNIxoVq
   3bHYAfFR2czxDECZ9rl+hetsxlA7O5DBlcCB72amN9Ab7q80O/6udRNQ/
   vpK/Cbb8EQOgqcb4PK0wK070n16GYj9Gdum82Ee8b1bHZEkvmfRXDM6xp
   Q==;
X-CSE-ConnectionGUID: QxlkvgdfTy6pdeAZ9R8sDg==
X-CSE-MsgGUID: FO/aGhFeQ0OR2f+DBQ2v+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="53065831"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="53065831"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 21:15:07 -0700
X-CSE-ConnectionGUID: SEjW+rTUTtOAdAeKZLnBDA==
X-CSE-MsgGUID: RM4jtmsxSIahEuNb+ZFZjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154191252"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 21:15:05 -0700
Message-ID: <d3b19880-f294-4506-be3d-1543c2cfe0d9@intel.com>
Date: Fri, 4 Jul 2025 12:15:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/39] accel/kvm: Reduce kvm_create_vcpu() declaration
 scope
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org
References: <20250703173248.44995-1-philmd@linaro.org>
 <20250703173248.44995-7-philmd@linaro.org>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250703173248.44995-7-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/4/2025 1:32 AM, Philippe Mathieu-Daudé wrote:
> kvm_create_vcpu() is only used within the same file unit.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   include/system/kvm.h | 8 --------
>   accel/kvm/kvm-all.c  | 8 +++++++-
>   2 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/include/system/kvm.h b/include/system/kvm.h
> index 7cc60d26f24..e943df2c09d 100644
> --- a/include/system/kvm.h
> +++ b/include/system/kvm.h
> @@ -316,14 +316,6 @@ int kvm_create_device(KVMState *s, uint64_t type, bool test);
>    */
>   bool kvm_device_supported(int vmfd, uint64_t type);
>   
> -/**
> - * kvm_create_vcpu - Gets a parked KVM vCPU or creates a KVM vCPU
> - * @cpu: QOM CPUState object for which KVM vCPU has to be fetched/created.
> - *
> - * @returns: 0 when success, errno (<0) when failed.
> - */
> -int kvm_create_vcpu(CPUState *cpu);
> -
>   /**
>    * kvm_park_vcpu - Park QEMU KVM vCPU context
>    * @cpu: QOM CPUState object for which QEMU KVM vCPU context has to be parked.
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index d095d1b98f8..17235f26464 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -453,7 +453,13 @@ static void kvm_reset_parked_vcpus(KVMState *s)
>       }
>   }
>   
> -int kvm_create_vcpu(CPUState *cpu)
> +/**
> + * kvm_create_vcpu - Gets a parked KVM vCPU or creates a KVM vCPU
> + * @cpu: QOM CPUState object for which KVM vCPU has to be fetched/created.
> + *
> + * @returns: 0 when success, errno (<0) when failed.
> + */
> +static int kvm_create_vcpu(CPUState *cpu)
>   {
>       unsigned long vcpu_id = kvm_arch_vcpu_id(cpu);
>       KVMState *s = kvm_state;


