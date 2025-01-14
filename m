Return-Path: <kvm+bounces-35373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B05E8A10728
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 13:56:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DECE31886B36
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 12:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0731E22DC33;
	Tue, 14 Jan 2025 12:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LRb+YxwQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD50236A6E
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 12:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736859364; cv=none; b=A2cc3tFK0XdooP4eeOkocudrhCVZ3fIWrMY49gf41ieVpjjTmQADX5e4yw9HqLZh5vhy7pRMteGjKxd1nEZ+OPD+N+FMB1hlKGGlnqLVOP7R0KTaLvgY7FI8rGjUZV8Lx0bVoouKJUnsJjhRGyDcoKwCgbm81TNTkNJH9GOIPE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736859364; c=relaxed/simple;
	bh=qJC8d9uqmeCHYmIZX8ZDBCvOsr4anJF7pnDu7IUs47Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GPLW43sUBSS98tnGWio1Ea4btHekJOLyESiuvSI8uAeI/D3FyALivqgYNoeLnZiJ0IhxJCV1L2JRU9OnbjnDLF4q/aTiGxHAGPPOruH0w3515CGrQWvz63hXmuoSQTyd7H+Rq82rCL+XC6KxbvLJ0QQyYAxk6v3AZPkHdM9g0cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LRb+YxwQ; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736859362; x=1768395362;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qJC8d9uqmeCHYmIZX8ZDBCvOsr4anJF7pnDu7IUs47Q=;
  b=LRb+YxwQhkq8RM6IYqv/iyrYF7M3glR/FDAYz27Exx5HNX+SVbROUK1F
   EUDkemORrDWyZWZ8/Wgb5IvL2D0l66izyVzN6x9bgUpQaq3hAMNnSnKj5
   YGWO0OWqofBFnpq9hl8seTuDZZ6Y32IzgjpiVFFvF7MC3KXTX0Kek0kzv
   CXdCwY1F8Qw5c4Ip5kqMfW8Ee7/9OjtCGuXISQF2sp3pH2yyp9Iv4pWJ0
   LucD9rcwdDJ8wjRXabiT93QdbbskhOwVNpR26aUo0+4mfhf9wR0epagTQ
   lEH53khOOyRvV1wtkApMbRgg2QXB6IJQUrcjVIr0pXZoHMhiEmuzJfhcS
   A==;
X-CSE-ConnectionGUID: 57lZ7MiwS1C+qvjsNSO7iQ==
X-CSE-MsgGUID: J+2AXsykRNe1g/8N8xw8qg==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="37314569"
X-IronPort-AV: E=Sophos;i="6.12,314,1728975600"; 
   d="scan'208";a="37314569"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 04:56:02 -0800
X-CSE-ConnectionGUID: 2OBKfawTTOa2A5hnk/mwfQ==
X-CSE-MsgGUID: hARCAZLvRZKc8lIYka8fig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,314,1728975600"; 
   d="scan'208";a="105313915"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 04:55:56 -0800
Message-ID: <1cbe556d-ac8a-4a95-bf1c-8f87a4bd04ca@intel.com>
Date: Tue, 14 Jan 2025 20:55:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 36/60] i386/tdx: Force exposing CPUID 0x1f
To: Ira Weiny <ira.weiny@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-37-xiaoyao.li@intel.com>
 <Z1thEdonGTThi7MX@iweiny-mobl>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Z1thEdonGTThi7MX@iweiny-mobl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/2024 6:17 AM, Ira Weiny wrote:
> On Tue, Nov 05, 2024 at 01:23:44AM -0500, Xiaoyao Li wrote:
>> TDX uses CPUID 0x1f to configure TD guest's CPU topology. So set
>> enable_cpuid_0x1f for TDs.
> 
> If you squashed this into patch 35 I think it might make more sense overall
> after some commit message clean ups.

I see it as patch 35 introduces the interface, and this patch uses it. 
I'm neutral. Squash is simple, I would leave it to Paolo to make the 
final decision.

> Ira
> 
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   target/i386/kvm/tdx.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 289722a129ce..19ce90df4143 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -388,7 +388,11 @@ static int tdx_kvm_type(X86ConfidentialGuest *cg)
>>   
>>   static void tdx_cpu_instance_init(X86ConfidentialGuest *cg, CPUState *cpu)
>>   {
>> +    X86CPU *x86cpu = X86_CPU(cpu);
>> +
>>       object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
>> +
>> +    x86cpu->enable_cpuid_0x1f = true;
>>   }
>>   
>>   static void tdx_cpu_realizefn(X86ConfidentialGuest *cg, CPUState *cs,
>> -- 
>> 2.34.1
>>


