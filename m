Return-Path: <kvm+bounces-35371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56F90A106E5
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 13:40:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36FC63A73A8
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 12:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E3FA236A8E;
	Tue, 14 Jan 2025 12:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f2+Jdl1A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D24236A7D
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 12:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736858387; cv=none; b=i1jW7vz8/xasdPSJdiTg6wtUtXMqPc0HCFr6bYx7ZLGJv/ZpNTUKx/ICINj8ptuMASKaAw2F2edVTnVpexnOnM6s/gtfRI8VFjRyzbl5VSYnzy6PUTHvLga3P0RFQhisa3A97oEROVMGy3cTc9hD0G/ZdNPoA2uAM40U+TtrCEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736858387; c=relaxed/simple;
	bh=Ymy6fi60DeIIv6w0XhdotWZiGY1VFM3N3b5/Gxgr4ts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IXe8LxldyDQN7e4L0mOUswAI6PgqVSVwfyFZA1cv17f6CPYqg9xBKztJd4+NvvS4/h8qzG/yqQrqcrlGS6YTtA9eWqT5lFvGgtz0XyhKr+fzewJ6B2mi1gsaMw+cCMxxHaqrGz0pIdmViTYZjyHGASqiMDdHcdExfP3NfzEYNgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f2+Jdl1A; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736858387; x=1768394387;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ymy6fi60DeIIv6w0XhdotWZiGY1VFM3N3b5/Gxgr4ts=;
  b=f2+Jdl1AlsxcUQW7ZRjDDZuja1QEmM3ynYGPx8it0Jco5YkEPPkmVNAm
   d3graudJkTKjd3LclnuslSc005xfGk6Qna+CoimniuBVzH2p+daMb3BSX
   YlpGaUZxolEJsEKPAseJf3fPr/o6hX5/JNTOLV+XfsPvbCidZN2NoQlFx
   AZQW6HAqYbllrgxWK7ADZK/ZkW0TepFx77S8azUTmDi9LHHWJp43Ns8fZ
   FmEhztFeyApfnBKmxEyullYo15ky2fzdf722QAdR1ClI255/tyf3as0LV
   xLheN6UjVwWgp+1q8kdgJdXIe54suGGlbOSqzAhaR7fEPJKiGdbByLiHU
   Q==;
X-CSE-ConnectionGUID: n2lCndQhT5umCUGaNPJIjQ==
X-CSE-MsgGUID: j+5m7M7DRxWEFPk+yNE40g==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="47640483"
X-IronPort-AV: E=Sophos;i="6.12,314,1728975600"; 
   d="scan'208";a="47640483"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 04:39:46 -0800
X-CSE-ConnectionGUID: 8RJqrxEAS0ClqBKgQtivpA==
X-CSE-MsgGUID: HVskA2wXR2WOzdEVmKNImg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,314,1728975600"; 
   d="scan'208";a="104876000"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 04:39:40 -0800
Message-ID: <1b03e7a4-c398-4646-9182-e3757f65980e@intel.com>
Date: Tue, 14 Jan 2025 20:39:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/60] i386/tdx: Initialize TDX before creating TD
 vcpus
To: Tony Lindgren <tony.lindgren@linux.intel.com>,
 Ira Weiny <ira.weiny@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "riku.voipio@iki.fi" <riku.voipio@iki.fi>,
 "imammedo@redhat.com" <imammedo@redhat.com>, "Liu, Zhao1"
 <zhao1.liu@intel.com>,
 "marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
 "anisinha@redhat.com" <anisinha@redhat.com>, "mst@redhat.com"
 <mst@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "mtosatti@redhat.com" <mtosatti@redhat.com>,
 "eblake@redhat.com" <eblake@redhat.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "wangyanan55@huawei.com" <wangyanan55@huawei.com>,
 "berrange@redhat.com" <berrange@redhat.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-10-xiaoyao.li@intel.com>
 <1235bac6ffe7be6662839adb2630c1a97d1cc4c5.camel@intel.com>
 <c0ef6c19-756e-43f3-8342-66b032238265@intel.com>
 <Zyr7FA10pmLhZBxL@tlindgre-MOBL1> <Z1scMzIdT2cI4F5T@iweiny-mobl>
 <Z2F3mBlIqbf9h4QM@tlindgre-MOBL1>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Z2F3mBlIqbf9h4QM@tlindgre-MOBL1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/17/2024 9:10 PM, Tony Lindgren wrote:
> On Thu, Dec 12, 2024 at 11:24:03AM -0600, Ira Weiny wrote:
>> On Wed, Nov 06, 2024 at 07:13:56AM +0200, Tony Lindgren wrote:
>>> On Wed, Nov 06, 2024 at 10:01:04AM +0800, Xiaoyao Li wrote:
>>>> On 11/6/2024 4:51 AM, Edgecombe, Rick P wrote:
>>>>> +Tony
>>>>>
>>>>> On Tue, 2024-11-05 at 01:23 -0500, Xiaoyao Li wrote:
>>>>>> +int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>>>>>> +{
>>>>>> +    X86CPU *x86cpu = X86_CPU(cpu);
>>>>>> +    CPUX86State *env = &x86cpu->env;
>>>>>> +    g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
>>>>>> +    int r = 0;
>>>>>> +
>>>>>> +    QEMU_LOCK_GUARD(&tdx_guest->lock);
>>>>>> +    if (tdx_guest->initialized) {
>>>>>> +        return r;
>>>>>> +    }
>>>>>> +
>>>>>> +    init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
>>>>>> +                        sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
>>>>>> +
>>>>>> +    r = setup_td_xfam(x86cpu, errp);
>>>>>> +    if (r) {
>>>>>> +        return r;
>>>>>> +    }
>>>>>> +
>>>>>> +    init_vm->cpuid.nent = kvm_x86_build_cpuid(env, init_vm->cpuid.entries, 0);
>>>>>> +    tdx_filter_cpuid(&init_vm->cpuid);
>>>>>> +
>>>>>> +    init_vm->attributes = tdx_guest->attributes;
>>>>>> +    init_vm->xfam = tdx_guest->xfam;
>>>>>> +
>>>>>> +    do {
>>>>>> +        r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, init_vm);
>>>>>> +    } while (r == -EAGAIN);
>>>>>
>>>>> KVM_TDX_INIT_VM can also return EBUSY. This should check for it, or KVM should
>>>>> standardize on one for both conditions. In KVM, both cases handle
>>>>> TDX_RND_NO_ENTROPY, but one tries to save some of the initialization for the
>>>>> next attempt. I don't know why userspace would need to differentiate between the
>>>>> two cases though, which makes me think we should just change the KVM side.
>>>>
>>>> I remember I tested retrying on the two cases and no surprise showed.
>>>>
>>>> I agree to change KVM side to return -EAGAIN for the two cases.
>>>
>>> OK yeah let's patch KVM for it.
>>
>> Will the patch to KVM converge such that it is ok for qemu to loop forever?
> 
> Hmm I don't think we should loop forever anywhere, the retries needed should
> be only a few. Or what do you have in mind?

"A few" seems not accurate. It depends on how heavy the RDRAND/RDSEED 
traffic from others are. IIRC, it gets > 10 0000 -EAGAIN before success 
when all the LPs in the system are doing RDRAND/RDSEED.

Maybe a timeout? E.g., QEMU exits when it cannot move forward for a 
certain period.

However, I'm not sure what value is reasonable for the timeout.


> Regards,
> 
> Tony


