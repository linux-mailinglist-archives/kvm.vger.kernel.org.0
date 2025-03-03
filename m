Return-Path: <kvm+bounces-39844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DBF8A4B631
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 03:42:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE2C5167316
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 02:42:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA2E0189913;
	Mon,  3 Mar 2025 02:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pq3xQW+n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B06D8632C
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 02:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740969739; cv=none; b=lrDSrwUFRvXf7yd50kpHUAJQEAtJb+aERJeOoLM96Jdy4Pg7hsR+tzmEtvWb8XZzZy4JDGzyNIaqL3O/TVp7OnomdHPxteBmzTwYeGf3fU/KKrAI/M/5OlsVRLYBmVxwEN9st03zo6LeYQarTszeG6SrtnjL7LRJS0yVAky2V/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740969739; c=relaxed/simple;
	bh=UTJE0AWcwtm1kfCtTh7Pdyk6SzSTbYJlwG8ImNoDFkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ug2VR2f+giFOOv5d3qyhUkdM69/g+S8Z//bWd8LSOwt0Ev6a9osO9ZRsAuVef69Rz9FssyCHo6jV5fQjmFss4JVzNBFYbVveQjEjiCkL4qYT1HIJRoXuCjmsIWvagA3ZqI9KZIwvtzN2mwK677q4yBiCZoTt7CoiOtZAZETUFes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pq3xQW+n; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740969737; x=1772505737;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UTJE0AWcwtm1kfCtTh7Pdyk6SzSTbYJlwG8ImNoDFkg=;
  b=Pq3xQW+nqfcdsL6RVJIjBgU8lKNLkESo0nikpBP7b4dSopwddDMTRY2L
   n4zPbGeeU4h63v6wuuRzwK9jOP0kx4mFr4CqbUSYpEru7XKVU/9WWrGhj
   WrKUJrSh/xRa5KqhGVSzS9CzCdBjSlAvdMl6l+dLRGMnpBD705pPsE2GH
   3gVEBEQlzAmEwWU79MRWVbCPoXSvPq+v+bB54XEHpyYuZmgIMU551gJ6Z
   iHRgdjElYCrgHwfrb0KVM7LUMOoOhvnugbhjsqToewlfCyI4QjdT6AsRj
   ZBTZ3JPZFoNZ1FTQCBKtEMIumzU72cwANTkRZpDeAjOhSCAgw+NaxH1x2
   Q==;
X-CSE-ConnectionGUID: 307tapghSRO2nT5j7hT3rA==
X-CSE-MsgGUID: hMipb9j0T0innGiEdeAWaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="41533050"
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="41533050"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 18:42:16 -0800
X-CSE-ConnectionGUID: uvej7JceQYS6RgznScZbuA==
X-CSE-MsgGUID: WluVq+NDQ0qfbVt13pid6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="117896335"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 18:42:12 -0800
Message-ID: <85c7d37d-1e8f-49f6-8c96-36ff316a6615@intel.com>
Date: Mon, 3 Mar 2025 10:42:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 38/52] i386/apic: Skip kvm_apic_put() for TDX
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
 <20250124132048.3229049-39-xiaoyao.li@intel.com>
 <40b8bf9854d4a83b55ae8e83f093462b5852a35f.camel@gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <40b8bf9854d4a83b55ae8e83f093462b5852a35f.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/28/2025 12:57 AM, Francesco Lavra wrote:
> On Fri, 2025-01-24 at 08:20 -0500, Xiaoyao Li wrote:
>> KVM neithers allow writing to MSR_IA32_APICBASE for TDs, nor allow
>> for
>> KVM_SET_LAPIC[*].
>>
>> Note, KVM_GET_LAPIC is also disallowed for TDX. It is called in the
>> path
>>
>>    do_kvm_cpu_synchronize_state()
>>    -> kvm_arch_get_registers()
>>       -> kvm_get_apic()
>>
>> and it's already disllowed for confidential guest through
>> guest_state_protected.
>>
>> [*] https://lore.kernel.org/all/Z3w4Ku4Jq0CrtXne@google.com/
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   hw/i386/kvm/apic.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/hw/i386/kvm/apic.c b/hw/i386/kvm/apic.c
>> index 757510600098..a1850524a67f 100644
>> --- a/hw/i386/kvm/apic.c
>> +++ b/hw/i386/kvm/apic.c
>> @@ -17,6 +17,7 @@
>>   #include "system/hw_accel.h"
>>   #include "system/kvm.h"
>>   #include "kvm/kvm_i386.h"
>> +#include "kvm/tdx.h"
>>   
>>   static inline void kvm_apic_set_reg(struct kvm_lapic_state *kapic,
>>                                       int reg_id, uint32_t val)
>> @@ -141,6 +142,10 @@ static void kvm_apic_put(CPUState *cs,
>> run_on_cpu_data data)
>>       struct kvm_lapic_state kapic;
>>       int ret;
>>   
>> +    if(is_tdx_vm()) {
> 
> Missing space between if and (.
> scripts/checkpatch.pl would have caught this.

Me to be blamed that don't use checkpatch.pl everytime before post.

