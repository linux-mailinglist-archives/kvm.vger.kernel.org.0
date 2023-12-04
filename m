Return-Path: <kvm+bounces-3297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4253802D1F
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 09:28:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D3F31C20A01
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 08:28:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 236FCE55F;
	Mon,  4 Dec 2023 08:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LuVeBDeN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E2FCB
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 00:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701678522; x=1733214522;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZKx6aOAxCYxX3nIGvol2ORfDeTABYuzt1dyIIWAXVOE=;
  b=LuVeBDeNZ62gP9qZxov3sbWTyjnTldNIT0Mju4YewR/mE7DTtGrbaRfV
   LoBbzTQWfl+dG+6IsI8S9S2MY/C+sC0HesFcThEMUZwZ5QaJo9C49VO9e
   J5xxXuekTWxs/angPXnfmkf+REw5aAANy/Nx85sqgGAWrMzkyjnWOiNg2
   trHuqfi8LPnyX2ndd9c0sHU/esDbQFtTQqOAj7mvRXM9kCrVA0Z55MdCu
   lGo2mh8Y//G4rmRdO1KAl37Sjtecir/EKYjMJSmjGjYX4CYS61QLY5cYb
   /ss9LtLTkVuQsd18hgwxtBphxpnoYlxHq35VCPBiRQkicBC6+phcZwee6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="743947"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="743947"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 00:28:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="1017759073"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="1017759073"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 00:28:35 -0800
Message-ID: <489b0ea2-f698-4bce-9b80-1ff516407934@intel.com>
Date: Mon, 4 Dec 2023 16:28:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 26/70] i386/tdx: Initialize TDX before creating TD
 vcpus
Content-Language: en-US
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand
 <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
 Sean Christopherson <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-27-xiaoyao.li@intel.com>
 <ZVSk_-m-AAK7dYZ1@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZVSk_-m-AAK7dYZ1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/15/2023 7:01 PM, Daniel P. Berrangé wrote:
> On Wed, Nov 15, 2023 at 02:14:35AM -0500, Xiaoyao Li wrote:
>> Invoke KVM_TDX_INIT in kvm_arch_pre_create_vcpu() that KVM_TDX_INIT
>> configures global TD configurations, e.g. the canonical CPUID config,
>> and must be executed prior to creating vCPUs.
>>
>> Use kvm_x86_arch_cpuid() to setup the CPUID settings for TDX VM.
>>
>> Note, this doesn't address the fact that QEMU may change the CPUID
>> configuration when creating vCPUs, i.e. punts on refactoring QEMU to
>> provide a stable CPUID config prior to kvm_arch_init().
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
>> ---
>> Changes in v3:
>> - Pass @errp in tdx_pre_create_vcpu() and pass error info to it. (Daniel)
>> ---
>>   accel/kvm/kvm-all.c        |  9 +++++++-
>>   target/i386/kvm/kvm.c      |  9 ++++++++
>>   target/i386/kvm/tdx-stub.c |  5 +++++
>>   target/i386/kvm/tdx.c      | 45 ++++++++++++++++++++++++++++++++++++++
>>   target/i386/kvm/tdx.h      |  4 ++++
>>   5 files changed, 71 insertions(+), 1 deletion(-)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 6b5f4d62f961..a92fff471b58 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -441,8 +441,15 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
>>   
>>       trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
>>   
>> +    /*
>> +     * tdx_pre_create_vcpu() may call cpu_x86_cpuid(). It in turn may call
>> +     * kvm_vm_ioctl(). Set cpu->kvm_state in advance to avoid NULL pointer
>> +     * dereference.
>> +     */
>> +    cpu->kvm_state = s;
>>       ret = kvm_arch_pre_create_vcpu(cpu, errp);
>>       if (ret < 0) {
>> +        cpu->kvm_state = NULL;
>>           goto err;
>>       }
>>   
>> @@ -450,11 +457,11 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
>>       if (ret < 0) {
>>           error_setg_errno(errp, -ret, "kvm_init_vcpu: kvm_get_vcpu failed (%lu)",
>>                            kvm_arch_vcpu_id(cpu));
>> +        cpu->kvm_state = NULL;
>>           goto err;
>>       }
>>   
>>       cpu->kvm_fd = ret;
>> -    cpu->kvm_state = s;
>>       cpu->vcpu_dirty = true;
>>       cpu->dirty_pages = 0;
>>       cpu->throttle_us_per_full = 0;
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index dafe4d262977..fc840653ceb6 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -2268,6 +2268,15 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>       return r;
>>   }
>>   
>> +int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>> +{
>> +    if (is_tdx_vm()) {
>> +        return tdx_pre_create_vcpu(cpu, errp);
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   int kvm_arch_destroy_vcpu(CPUState *cs)
>>   {
>>       X86CPU *cpu = X86_CPU(cs);
>> diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
>> index 1d866d5496bf..3877d432a397 100644
>> --- a/target/i386/kvm/tdx-stub.c
>> +++ b/target/i386/kvm/tdx-stub.c
>> @@ -6,3 +6,8 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
>>   {
>>       return -EINVAL;
>>   }
>> +
>> +int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>> +{
>> +    return -EINVAL;
>> +}
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 1f5d8117d1a9..122a37c93de3 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -467,6 +467,49 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
>>       return 0;
>>   }
>>   
>> +int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>> +{
>> +    MachineState *ms = MACHINE(qdev_get_machine());
>> +    X86CPU *x86cpu = X86_CPU(cpu);
>> +    CPUX86State *env = &x86cpu->env;
>> +    struct kvm_tdx_init_vm *init_vm;
> 
> Mark this as auto-free to avoid the g_free() requirement
> 
>    g_autofree  struct kvm_tdx_init_vm *init_vm = NULL;
> 
>> +    int r = 0;
>> +
>> +    qemu_mutex_lock(&tdx_guest->lock);
> 
>     QEMU_LOCK_GUARD(&tdx_guest->lock);
> 
> to eliminate the mutex_unlock requirement, thus eliminating all
> 'goto' jumps and label targets, in favour of a plain 'return -1'
> everywhere.
> 

Learned!

thanks!


