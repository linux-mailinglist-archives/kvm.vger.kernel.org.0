Return-Path: <kvm+bounces-30726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26BFE9BCBFE
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 12:39:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53E711C23FB4
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A14A91D4351;
	Tue,  5 Nov 2024 11:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="faoRNzmW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0961CB9E6
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 11:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730806743; cv=none; b=akcLWCHDaHoo5rYoRoRXRNFuIoa32iuyrzoKy4ym+lNpKjbUVC6CKSOXFkdjmmgJcNE8e+x6Srf770Z1NVgVBB5Bs/0pz6Zn7MWB0qlwR+6+Ln1b8gFIuSyqUItc4KjacXA0b3cyys5ZF2FTuq9VZysdqOgJYl/kC67IIzQv36k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730806743; c=relaxed/simple;
	bh=2p0qqrZXhnJnX7t+XGnwdl5Wk1Q0mCbjfRdTlG/C5Ds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SNikfy/SUUuTqwdHXOma2XGadJ6tUDmHar1XOjQ3LL68k2lW5tA+W2ADjH3Pal6xZP2mzHPMxtR7vQsPDE1F76Z9tlmGFk4rslVXkCMfVWpM/JKYSWY4SVcvPaSd9jajZCuo9ftZL0+3s7CN3G5oEcMYOk2EBTtRRqqE84Og4ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=faoRNzmW; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730806742; x=1762342742;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2p0qqrZXhnJnX7t+XGnwdl5Wk1Q0mCbjfRdTlG/C5Ds=;
  b=faoRNzmW4pFfFFf0xNc1L0AMQaGt2IN2tbvRZ5WAokVDVfu+nd6OsGV1
   yqQabHnad+EsLUlPIRqv6OmX/L25mjDJ8D3c1oNHwQ7gKx3LKIPXZo1Tl
   eRS4kK2e0QU0YH/ILpNpgY1B6SxyBx7Fk6QKTSy0E5lM1+WYPBHnhxeeg
   hAtaGFMFIydyt+Qw8E6gp01jfjq0QWnKmALT3i0OKK8ujWnhdo7TDA07+
   XEte1E6QMNEfnnno8Jd4P9ZszJAvwxwXynAjydlyho2DaDi1Q/W5Rx9HE
   rKEsVT1aiSR5ouS0U/PiA74djc5LJgxhZA3idOAi2U7vK/NC7R45lFqFy
   Q==;
X-CSE-ConnectionGUID: HI5sZ0QvStiIg3CW9Ax/fQ==
X-CSE-MsgGUID: w/RCX/hYQCWhoJhQkTmOMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="34331936"
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="34331936"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 03:39:02 -0800
X-CSE-ConnectionGUID: RbFMi+25QlyixGO3X3+4yA==
X-CSE-MsgGUID: LvrbLg2sRYOMCDLqbdN59w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="83879565"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 03:38:57 -0800
Message-ID: <2bedfcda-c2e7-4e5b-87a7-9352dfe28286@intel.com>
Date: Tue, 5 Nov 2024 19:38:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 34/60] i386/tdx: implement tdx_cpu_realizefn()
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
 <20241105062408.3533704-35-xiaoyao.li@intel.com>
 <82b74218-f790-4300-ab3b-9c41de1f96b8@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <82b74218-f790-4300-ab3b-9c41de1f96b8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/5/2024 6:06 PM, Paolo Bonzini wrote:
> On 11/5/24 07:23, Xiaoyao Li wrote:
>> +static void tdx_cpu_realizefn(X86ConfidentialGuest *cg, CPUState *cs,
>> +                              Error **errp)
>> +{
>> +    X86CPU *cpu = X86_CPU(cs);
>> +    uint32_t host_phys_bits = host_cpu_phys_bits();
>> +
>> +    if (!cpu->phys_bits) {
>> +        cpu->phys_bits = host_phys_bits;
>> +    } else if (cpu->phys_bits != host_phys_bits) {
>> +        error_setg(errp, "TDX only supports host physical bits (%u)",
>> +                   host_phys_bits);
>> +    }
>> +}
> 
> This should be already handled by host_cpu_realizefn(), which is reached 
> via cpu_exec_realizefn().
> 
> Why is it needed earlier, but not as early as instance_init?  If 
> absolutely needed I would do the assignment in patch 33, but I don't 
> understand why it's necessary.

It's not called earlier but right after cpu_exec_realizefn().

Patch 33 adds x86_confidenetial_guest_cpu_realizefn() right after 
ecpu_exec_realizefn(). This patch implements the callback and gets 
called in x86_confidenetial_guest_cpu_realizefn() so it's called after
cpu_exec_realizefn().

The reason why host_cpu_realizefn() cannot satisfy is that for normal 
VMs, the check in cpu_exec_realizefn() is just a warning and QEMU does 
allow the user to configure the physical address bit other than host's 
value, and the configured value will be seen inside guest. i.e., "-cpu 
phys-bits=xx" where xx != host_value works for normal VMs.

But for TDX, KVM doesn't allow it and the value seen in TD guest is 
always the host value.  i.e., "-cpu phys-bits=xx" where xx != host_value 
doesn't work for TDX.

> Either way, the check should be in tdx_check_features.

Good idea. I will try to implement it in tdx_check_features()

> Paolo
> 
>>   static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
>>   {
>>       if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
>> @@ -733,4 +749,5 @@ static void tdx_guest_class_init(ObjectClass *oc, 
>> void *data)
>>       klass->kvm_init = tdx_kvm_init;
>>       x86_klass->kvm_type = tdx_kvm_type;
>>       x86_klass->cpu_instance_init = tdx_cpu_instance_init;
>> +    x86_klass->cpu_realizefn = tdx_cpu_realizefn;
>>   }
> 


