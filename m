Return-Path: <kvm+bounces-51542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77CB6AF8788
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:02:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D602482DA5
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 06:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F256214209;
	Fri,  4 Jul 2025 06:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WZ3eqzun"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366B11FAC59
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 06:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751608947; cv=none; b=Rts2o6EKt1+rcsOJ35lkHV5O4heTntQfc6Gri/s5Hus8oo0BBYrMU1inIOCYOwKyk0mNwi3+qMhDh+wz4DoIkyCXzrMQ+KosgSJ94CHncRFxsSEQGhUnEgflRuX8FgkOaLFotupJMXW1yx/fZ0C5Z6PNYPqdeixoWLkd+gFj+ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751608947; c=relaxed/simple;
	bh=HSF0YPztBs3o2kgo1im0JCr/WFUyW0ehjeq+hU2vTpc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lG5D6MVH1unheNfJ/3TNCEiFuShDvXAVIlIoiPe/Q+Sp87ofveAdb66QxJmZrEm+tjwI1taCuaneWE4KmuqQ0nzV2LUWrQJxAYnDmeOAuOAH/is1PZcRsEHRRo1nGJfx7/ht2U8zOM0lcnPVofcSAqaEE0gU5beAt08EUJFsjQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WZ3eqzun; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751608946; x=1783144946;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HSF0YPztBs3o2kgo1im0JCr/WFUyW0ehjeq+hU2vTpc=;
  b=WZ3eqzunfMRgl1gdrnzfmHmubCElRcXTU9PkHRKwHKZNDh5tDvgTmhAO
   xewsk3WymhhNUkHuACJnnmJ3UfurKmlO6wbNB6ZxT5pU7+TfT8M3Z2UJQ
   AgCVvw0lSYpvus7ZdWo5Ds3snnzJQ+pb797PJC4BKxq8le8Ry3VgwDhgk
   9g/PBc0f1wMv2M8Ph+5nZpZsG44xULj6Q0iDB1VwHvZe7R/LsgRLPJCO4
   fp5lIF8VYwmsOKzZEEXadaL0agoo40ulQQFnHYUH1rRhe0ZjKwAS6fxd+
   RgsUtcfg0FfY8z56EiZyxDY3gJ0b/argZ26TLKH22xYBgO181i7BCUJbv
   g==;
X-CSE-ConnectionGUID: Fwo2rMhfQjifDw57JXVxxA==
X-CSE-MsgGUID: NSdc0U+XRxya+e4GiqJz6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="53865542"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="53865542"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 23:02:25 -0700
X-CSE-ConnectionGUID: LwVKagpVTueUiPH8KgCxZA==
X-CSE-MsgGUID: 3TsSFvmaTIKzOwSQddv8cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154930608"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 23:02:23 -0700
Message-ID: <06dc9c3c-ccd5-43e8-82eb-3198c7f358a6@intel.com>
Date: Fri, 4 Jul 2025 14:02:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 21/39] accel/kvm: Remove kvm_cpu_synchronize_state()
 stub
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org
References: <20250703173248.44995-1-philmd@linaro.org>
 <20250703173248.44995-22-philmd@linaro.org>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250703173248.44995-22-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/4/2025 1:32 AM, Philippe Mathieu-Daudé wrote:
> Since commit 57038a92bb0 ("cpus: extract out kvm-specific code
> to accel/kvm") the kvm_cpu_synchronize_state() stub is not
> necessary.
> 
> Fixes: e0715f6abce ("kvm: remove kvm specific functions from global includes")
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

BTW, as what you do for HVF in this series that moving vcpu methods from 
hvf-all.c to hvf-accel-ops.c, do you plan to move 
kvm_cpu_synchronize_state() from kvm-all.c to kvm-accel-ops.c ?

> ---
>   accel/stubs/kvm-stub.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
> index b9b4427c919..68cd33ba973 100644
> --- a/accel/stubs/kvm-stub.c
> +++ b/accel/stubs/kvm-stub.c
> @@ -29,10 +29,6 @@ void kvm_flush_coalesced_mmio_buffer(void)
>   {
>   }
>   
> -void kvm_cpu_synchronize_state(CPUState *cpu)
> -{
> -}
> -
>   bool kvm_has_sync_mmu(void)
>   {
>       return false;


