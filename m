Return-Path: <kvm+bounces-39101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3217BA43A88
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 11:02:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB3683B4690
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 10:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D661F266590;
	Tue, 25 Feb 2025 09:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hdoLZ2IX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F08261364
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 09:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740477367; cv=none; b=CcoB4sMt6SjVk1x/ObYTJWN/YAQr/BhN0mOoAFvH5gpcxPBoGzm7DEdeE0FE9Hwio8YRXAtnbxaXhlyBAKaFjSqa7WHFCKXt0aoZcEhTXKHYnDkJ41uv8yjK/TNN5ZwwGZCKPjCiX4h77/hmXGNMXN2T+7+9+/Bb1fVPooYGTV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740477367; c=relaxed/simple;
	bh=jDDPZgTYh2ucTSEU02Q+0XVKfJmHM7vvajnT3JsASxY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WWBX7x/6+eQsxKeQ5tywYvMukCWfDzCdSkMMdIjsnbX9PeARMcMOA6+RTUZrQmCXLSy5MdlScUsl01QJwlN79WxvhYqriv26A+LUKl3NO/r8mbUCCwNSwNUmK/wjEj+ZEIe9Eoh+5H0yhfMpBd+zN46YjDdA1NKQuHBRTynW3MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hdoLZ2IX; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740477363; x=1772013363;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jDDPZgTYh2ucTSEU02Q+0XVKfJmHM7vvajnT3JsASxY=;
  b=hdoLZ2IXQV8EFZPOeafFxWY3v1CCa903quL4Wy21oRsRKQnnkb0+C2cs
   Zh11CsYat/9TwowWbta5t7I8ZB4n2DqLMnmhUmsxIDx1hW5VjMbusDXiM
   Pc/ftbA5n5MUtNRkC00SFBZoaxWVlj783g/1u7Qo40JeHSYEXY5TKQIb0
   jNHnbA0+ojFbXWSoefJrA6qZl4ZRE1LOCU4GmcQPjohgjcU+CKQ6tJ3NT
   iTmpEyvUwn+bcqv+QI4tZtUUuR3h3LtF8Se0yP9DiPxZEpwGITBqp6/sO
   SyEHCnQu00QIwNGGzCSQfFx599Q1J4BPoHAjjwLy1/5xT5PClu9voPJLL
   w==;
X-CSE-ConnectionGUID: tLuU/69BSc2mTeGLpCC2ZA==
X-CSE-MsgGUID: pN36zO2USL6RKE/UwcPLXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11355"; a="66644670"
X-IronPort-AV: E=Sophos;i="6.13,313,1732608000"; 
   d="scan'208";a="66644670"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 01:56:02 -0800
X-CSE-ConnectionGUID: Jel9C8EYQySLBbMWybqPdA==
X-CSE-MsgGUID: m/EPt7kvRJSqgnGXSuIsWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,313,1732608000"; 
   d="scan'208";a="121283339"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 01:55:56 -0800
Message-ID: <77e3769b-7f79-42d0-8eaa-18e916800fa0@intel.com>
Date: Tue, 25 Feb 2025 17:55:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/52] i386/tdx: Initialize TDX before creating TD
 vcpus
To: Francesco Lavra <francescolavra.fl@gmail.com>,
 Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
 <20250124132048.3229049-9-xiaoyao.li@intel.com>
 <6571727841685f4276aa7c814776ff1fdd162a0a.camel@gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <6571727841685f4276aa7c814776ff1fdd162a0a.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/19/2025 6:14 PM, Francesco Lavra wrote:
> On Fri, 2025-01-24 at 08:20 -0500, Xiaoyao Li wrote:
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 45867dbe0839..e35a9fbd687e 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -540,8 +540,15 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
>>   
>>       trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
>>   
>> +    /*
>> +     * tdx_pre_create_vcpu() may call cpu_x86_cpuid(). It in turn
>> may call
>> +     * kvm_vm_ioctl(). Set cpu->kvm_state in advance to avoid NULL
>> pointer
>> +     * dereference.
>> +     */
>> +    cpu->kvm_state = s;
> 
> This assignment should be removed from kvm_create_vcpu(), as now it's
> redundant there.

I'll just drop the change in this patch since there is no dependency in 
cpu_x86_cpuid() in current upstream QEMU.

>>       ret = kvm_arch_pre_create_vcpu(cpu, errp);
>>       if (ret < 0) {
>> +        cpu->kvm_state = NULL;
> 
> No need to reset cpu->kvm_state to NULL, there already are other error
> conditions under which cpu->kvm_state remains initialized.
> 
>>           goto err;
>>       }
>>   
>> @@ -550,6 +557,7 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
>>           error_setg_errno(errp, -ret,
>>                            "kvm_init_vcpu: kvm_create_vcpu failed
>> (%lu)",
>>                            kvm_arch_vcpu_id(cpu));
>> +        cpu->kvm_state = NULL;
> 
> Same here.


