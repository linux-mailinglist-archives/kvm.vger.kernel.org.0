Return-Path: <kvm+bounces-30725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E796B9BCBC2
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 12:26:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 39F9EB2402C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 740561D5174;
	Tue,  5 Nov 2024 11:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FaeTpw35"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03691D417C
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 11:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730805926; cv=none; b=GmLL4hT5ucxpPK8f2S5fsTmeqaOr+8j24whV+HKXVTix7oPz/26o96qqmUvHoilwjeshu1C8pZMRwmzjcpFfCZfZpagc18ad594K18/YdPmTFlordbGxJ2Wc/He7pCEla7KblmDoAc88jtEL5/U8J9dcjfKsdf4n8dirht0ioo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730805926; c=relaxed/simple;
	bh=s1wswE6/InO1G4xUqdts8qxxRWQM31X334rkUkdhdgU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mx+t8yQAIV6tr5ZMFc3eDyAxz1rxzQBOGqqwDd3nlPhVhNmGW5mBLUUwizc+IXDTuJoD3TDuGk8mxPrjhEYUmlzPpjNAcdjyjHhhhZXlf3du4ix3bfldcwr2Vve1YFLjb6arfe2VmuYsS3WlJ6VJFpvUSbbUvhq4IUoLOjcfmx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FaeTpw35; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730805924; x=1762341924;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=s1wswE6/InO1G4xUqdts8qxxRWQM31X334rkUkdhdgU=;
  b=FaeTpw35jNKRbgw9OEUr81Xt9TelK4RC/mBcvlLMGelmroY+y3R31/Mt
   UTWmQlxM+USuVfQfl5PH8KdGQ+bTJIHZvRX/ZY/bNURbafIr/8T4QHn6F
   n+RlnQvuYvEhf2hOwStJGF/1LIqo9EvML2XgKiVU6g4qyv6UelHkxUoYe
   eC9ZiABSQ2eYRLeZSMxcb/9cF3obpO3CIm5xq5Nbh2G2NOdZ+EcEYTBwX
   YgIvdhLlj8PnzeJQqoRr8XfbXhWyxTgtvOQ5hiDOOxLCxBM9+GVQD0tNc
   u+xCKy7YDFaEJmvr7CTsWqT3KillM06jFMN8utETzVKv5LWeVkpjxt1v8
   w==;
X-CSE-ConnectionGUID: nQoNxDtrQ/q6MZOiqgdNwg==
X-CSE-MsgGUID: WtuUsuiDSL6muZ7mhzqZyQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30503043"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30503043"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 03:25:23 -0800
X-CSE-ConnectionGUID: DKTS63VqThuubrGE6o9gdg==
X-CSE-MsgGUID: vLe/cltnQ9e0hJSfCrxoqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="84092452"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 03:25:20 -0800
Message-ID: <e5d02d7f-a989-4484-b0c1-3d7ac804ec73@intel.com>
Date: Tue, 5 Nov 2024 19:25:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 45/60] i386/tdx: Don't get/put guest state for TDX VMs
To: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-46-xiaoyao.li@intel.com>
 <8cd78103-5f49-4cbd-814d-a03a82a59231@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <8cd78103-5f49-4cbd-814d-a03a82a59231@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/5/2024 5:55 PM, Paolo Bonzini wrote:
> On 11/5/24 07:23, Xiaoyao Li wrote:
>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>
>> Don't get/put state of TDX VMs since accessing/mutating guest state of
>> production TDs is not supported.
>>
>> Note, it will be allowed for a debug TD. Corresponding support will be
>> introduced when debug TD support is implemented in the future.
>>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> 
> This should be unnecessary now that QEMU has 
> kvm_mark_guest_state_protected().

Reverting this patch, we get:

tdx: tdx: error: failed to set MSR 0x174 to 0x0
tdx: ../../../go/src/tdx/tdx-qemu/target/i386/kvm/kvm.c:3859: 
kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
error: failed to set MSR 0x174 to 0x0
tdx: ../../../go/src/tdx/tdx-qemu/target/i386/kvm/kvm.c:3859: 
kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.

> Paolo
> 
>> ---
>>   target/i386/kvm/kvm.c | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index c39e879a77e9..e47aa32233e6 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -5254,6 +5254,11 @@ int kvm_arch_put_registers(CPUState *cpu, int 
>> level, Error **errp)
>>       assert(cpu_is_stopped(cpu) || qemu_cpu_is_self(cpu));
>> +    /* TODO: Allow accessing guest state for debug TDs. */
>> +    if (is_tdx_vm()) {
>> +        return 0;
>> +    }
>> +
>>       /*
>>        * Put MSR_IA32_FEATURE_CONTROL first, this ensures the VM gets 
>> out of VMX
>>        * root operation upon vCPU reset. kvm_put_msr_feature_control() 
>> should also
>> @@ -5368,6 +5373,12 @@ int kvm_arch_get_registers(CPUState *cs, Error 
>> **errp)
>>           error_setg_errno(errp, -ret, "Failed to get MP state");
>>           goto out;
>>       }
>> +
>> +    /* TODO: Allow accessing guest state for debug TDs. */
>> +    if (is_tdx_vm()) {
>> +        return 0;
>> +    }
>> +
>>       ret = kvm_getput_regs(cpu, 0);
>>       if (ret < 0) {
>>           error_setg_errno(errp, -ret, "Failed to get general purpose 
>> registers");
> 


