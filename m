Return-Path: <kvm+bounces-36404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D1974A1A80F
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 17:46:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D709188C9D4
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 16:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71E2C13EFF3;
	Thu, 23 Jan 2025 16:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M1x410xB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E471B70817
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 16:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737650767; cv=none; b=QXMcmHOt2D4whbOi7I05H+nH1yUjM9zS78ZlvMYGX0VAMc6tYkr4FRQmB8pmCe/Yk2J+soMz4XhIDpKF2QX0eIY+A4chXx4ia6X4eL8IdvSodlzFNnduOLs7fGyozQ14OEyJT/wSZ7dQHt6CMClXNvHh3jVO4FutQ8pBWlylISw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737650767; c=relaxed/simple;
	bh=vVySh/TZLF+wwReAUP5Aq1bccSywQEunCA8CYjonaeM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hoFlBkgtxJ67hjoDTSUeJi9vsFjdQTk70U9+XCeHRoSOL/MGU/I4wjVGN+EhlO7ZVyzqeXWTzd/KCTVdwFTm0Xj0AOwfsQ621bQQq8xjOEEgNnnpLuZy30uZyTtzWOVKd+SuGqEBGHGu9HwgpqWCcG/IqP/JhpL/GFd5NrT0gIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M1x410xB; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737650766; x=1769186766;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vVySh/TZLF+wwReAUP5Aq1bccSywQEunCA8CYjonaeM=;
  b=M1x410xB9BCe/DZQepuEacmicc7Uc14QI58RQ1KEOoYB5+jcenD4n40g
   ams4cEbHEwoGuhdAQTJUNiA2fTzel4CAVf85ZVGlft44eXhFU9cdByjtH
   l1/2khUjohw3oSFTu6sLholW6e3Ve05RXyQM8gLyq6lOEK7UqaPA6F/14
   IZeR0ep8M6fGH7dX5WPQ2BHBk4HvtcCEt8blKtp6AeoV4bzmC7kn2huvW
   LrIu6YdP8oc82H0A9jSF2uKQNF8mwOcq5NH8rQI86wE5gzYczFPCSRm5i
   LRVJwaLjWjWn8UYgnaAHg3VBBNeTrN+rxsMS9dUqKbZ65HRBp8dUH7OfM
   w==;
X-CSE-ConnectionGUID: Bma2XaPXQ2GBknGgT+1ajQ==
X-CSE-MsgGUID: 8qzk+aPpT2yWt4Vx8v98nQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11324"; a="37858837"
X-IronPort-AV: E=Sophos;i="6.13,228,1732608000"; 
   d="scan'208";a="37858837"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2025 08:46:00 -0800
X-CSE-ConnectionGUID: nBRhB7V2SR2ZKsPwWWRXIw==
X-CSE-MsgGUID: /WGZTQrXTXOSzzv+4SXBTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="107350612"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2025 08:45:54 -0800
Message-ID: <00ecb103-2f0b-479d-bae8-cb3f7bace3be@intel.com>
Date: Fri, 24 Jan 2025 00:45:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 40/60] hw/i386: add eoi_intercept_unsupported member to
 X86MachineState
To: Igor Mammedov <imammedo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Ani Sinha <anisinha@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Yanan Wang <wangyanan55@huawei.com>,
 Cornelia Huck <cohuck@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, rick.p.edgecombe@intel.com, kvm@vger.kernel.org,
 qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-41-xiaoyao.li@intel.com>
 <20250123134148.036d52b0@imammedo.users.ipa.redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250123134148.036d52b0@imammedo.users.ipa.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/2025 8:41 PM, Igor Mammedov wrote:
> On Tue,  5 Nov 2024 01:23:48 -0500
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> Add a new bool member, eoi_intercept_unsupported, to X86MachineState
>> with default value false. Set true for TDX VM.
> 
> I'd rename it to enable_eoi_intercept, by default set to true for evrything
> and make TDX override this to false.
>>
>> Inability to intercept eoi causes impossibility to emulate level
>> triggered interrupt to be re-injected when level is still kept active.
>> which affects interrupt controller emulation.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
>> ---
>>   hw/i386/x86.c         | 1 +
>>   include/hw/i386/x86.h | 1 +
>>   target/i386/kvm/tdx.c | 2 ++
>>   3 files changed, 4 insertions(+)
>>
>> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
>> index 01fc5e656272..82faeed24ff9 100644
>> --- a/hw/i386/x86.c
>> +++ b/hw/i386/x86.c
>> @@ -370,6 +370,7 @@ static void x86_machine_initfn(Object *obj)
>>       x86ms->oem_table_id = g_strndup(ACPI_BUILD_APPNAME8, 8);
>>       x86ms->bus_lock_ratelimit = 0;
>>       x86ms->above_4g_mem_start = 4 * GiB;
>> +    x86ms->eoi_intercept_unsupported = false;
>>   }
>>   
>>   static void x86_machine_class_init(ObjectClass *oc, void *data)
>> diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
>> index d43cb3908e65..fd9a30391755 100644
>> --- a/include/hw/i386/x86.h
>> +++ b/include/hw/i386/x86.h
>> @@ -73,6 +73,7 @@ struct X86MachineState {
>>       uint64_t above_4g_mem_start;
>>   
>>       /* CPU and apic information: */
>> +    bool eoi_intercept_unsupported;
>>       unsigned pci_irq_mask;
>>       unsigned apic_id_limit;
>>       uint16_t boot_cpus;
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 9ab4e911f78a..9dcb77e011bd 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -388,6 +388,8 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>>           return -EOPNOTSUPP;
>>       }
>>   
>> +    x86ms->eoi_intercept_unsupported = true;
> 
> I don't particulary like accel go to its parent (machine) object and override things there
> and that being buried deep inside.

I would suggest don't see TDX as accel but see it as a special type of 
x86 machine.

> How do you start TDX guest?
> Is there a machine property or something like it to enable TDX?

via the "confidential-guest-support" property.
This series introduces tdx-guest object and we start a TDX guest by:

$qemu-system-x86_64 -object tdx-guest,id=tdx0 \
     -machine ...,confidential-guest-support=tdx0

>> +
>>       /*
>>        * Set kvm_readonly_mem_allowed to false, because TDX only supports readonly
>>        * memory for shared memory but not for private memory. Besides, whether a
> 


