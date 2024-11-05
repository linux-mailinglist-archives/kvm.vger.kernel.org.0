Return-Path: <kvm+bounces-30728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F400B9BCC2D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 12:52:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2A22283730
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADEF61D47C6;
	Tue,  5 Nov 2024 11:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OZa+C+lb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF911D3593
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 11:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730807525; cv=none; b=EbQemq+eLnpA6LNA6w24PkYlHKl65oi88qpYUihggAdiRfspXSK98klj2LYDWdf4/JAJev171DBFC/kGK7f67cUBQCrsObiNzuNDRAMtJLJDxCSoCYLELB2dYicNRr6+J1tt6/YEK9XNH9Bf5qmphcBJ2DrarqG1UanVuUpQnN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730807525; c=relaxed/simple;
	bh=m0AxebZpLKwG+X7WVmxENM8YETuuhBkUO8Y2bjFZTF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gaOicciwz8X0Gh1F2BysG0P9bWMufnf80roDdaEmZ2QN8jsgq9QCJPogVCGzmQI2svChW8zDcYSkfg1Bq/b6jxNZTIyeJ1AQvOFqNvLVswghaFvFRveEeNdKc7K8e1nq8qL1roVvjh3MHev6pBHQPXf+YKvHSrWvsHEZ5OPPfEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OZa+C+lb; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730807524; x=1762343524;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=m0AxebZpLKwG+X7WVmxENM8YETuuhBkUO8Y2bjFZTF0=;
  b=OZa+C+lbTozZjYm+DYKHfC7z3bTY6POUe7TcZvrqCEXwJMNJLIagChIV
   QCB6QR99TUvJKM4yJ5/jI0s0q9DOnwRxrR73Qmxa3UIVp2sO+P0m59Quv
   9HsPmvF/KSDxaJi8jdAhxsd4dzk5QS9S3vUuXRwTKtw55Hpk0P/flLNsk
   VBHyD7iO5c3hbAYwXVydcsMbC9FDgvyv4hfQ9yNXYRFd7sTrclu1UdwT1
   rFtWu9G4pMNOIUS0zDCgycZUUe0lBa5aUKqDH9J+1Ib/KXkj6d/4SS1KM
   XCjefiiksZ3X6N6hut5zJmXET/sccK5Bq3sfmr++Viw4kOxgwds5m4CxU
   Q==;
X-CSE-ConnectionGUID: XZ3PFE8PSPuAlaUAW9hvsg==
X-CSE-MsgGUID: sbzBLKkvTcqPm4n3o9nmoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41096681"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41096681"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 03:52:03 -0800
X-CSE-ConnectionGUID: kzJOCxgrQS25AqBT3aoJpg==
X-CSE-MsgGUID: avDtaManRsGA1HiflDMgAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="88767643"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 03:51:59 -0800
Message-ID: <f0283ac7-31bb-4d59-b45d-046f3e582d55@intel.com>
Date: Tue, 5 Nov 2024 19:51:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/60] i386/tdx: Initialize TDX before creating TD
 vcpus
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-10-xiaoyao.li@intel.com>
 <Zyn0oBKvOC9rvcqk@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Zyn0oBKvOC9rvcqk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/5/2024 6:34 PM, Daniel P. Berrangé wrote:
> On Tue, Nov 05, 2024 at 01:23:17AM -0500, Xiaoyao Li wrote:
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
>> Acked-by: Markus Armbruster <armbru@redhat.com>
>> ---
>> Changes in v6:
>> - setup xfam explicitly to fit with new uapi;
>> - use tdx_caps->cpuid to filter the input of cpuids because now KVM only
>>    allows the leafs that reported via KVM_TDX_GET_CAPABILITIES;
>>
>> Changes in v4:
>> - mark init_vm with g_autofree() and use QEMU_LOCK_GUARD() to eliminate
>>    the goto labels; (Daniel)
>> Changes in v3:
>> - Pass @errp in tdx_pre_create_vcpu() and pass error info to it. (Daniel)
>> ---
>>   accel/kvm/kvm-all.c         |  8 ++++
>>   target/i386/kvm/kvm.c       | 15 +++++--
>>   target/i386/kvm/kvm_i386.h  |  3 ++
>>   target/i386/kvm/meson.build |  2 +-
>>   target/i386/kvm/tdx-stub.c  |  8 ++++
>>   target/i386/kvm/tdx.c       | 87 +++++++++++++++++++++++++++++++++++++
>>   target/i386/kvm/tdx.h       |  6 +++
>>   7 files changed, 125 insertions(+), 4 deletions(-)
>>   create mode 100644 target/i386/kvm/tdx-stub.c
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 1732fa1adecd..4a1c9950894c 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -536,8 +536,15 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
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
>> @@ -546,6 +553,7 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
>>           error_setg_errno(errp, -ret,
>>                            "kvm_init_vcpu: kvm_create_vcpu failed (%lu)",
>>                            kvm_arch_vcpu_id(cpu));
>> +        cpu->kvm_state = NULL;
>>           goto err;
>>       }
>>   
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index afbf67a7fdaa..db676c1336ab 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -38,6 +38,7 @@
>>   #include "kvm_i386.h"
>>   #include "../confidential-guest.h"
>>   #include "sev.h"
>> +#include "tdx.h"
>>   #include "xen-emu.h"
>>   #include "hyperv.h"
>>   #include "hyperv-proto.h"
>> @@ -1824,9 +1825,8 @@ static void kvm_init_nested_state(CPUX86State *env)
>>       }
>>   }
>>   
>> -static uint32_t kvm_x86_build_cpuid(CPUX86State *env,
>> -                                    struct kvm_cpuid_entry2 *entries,
>> -                                    uint32_t cpuid_i)
>> +uint32_t kvm_x86_build_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
>> +                             uint32_t cpuid_i)
>>   {
>>       uint32_t limit, i, j;
>>       uint32_t unused;
>> @@ -2358,6 +2358,15 @@ int kvm_arch_init_vcpu(CPUState *cs)
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
>> diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
>> index efb0883bd968..b1baf9e7f910 100644
>> --- a/target/i386/kvm/kvm_i386.h
>> +++ b/target/i386/kvm/kvm_i386.h
>> @@ -24,6 +24,9 @@
>>   #define kvm_ioapic_in_kernel() \
>>       (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
>>   
>> +uint32_t kvm_x86_build_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
>> +                             uint32_t cpuid_i);
>> +
>>   #else
>>   
>>   #define kvm_pit_in_kernel()      0
>> diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
>> index 466bccb9cb17..3f44cdedb758 100644
>> --- a/target/i386/kvm/meson.build
>> +++ b/target/i386/kvm/meson.build
>> @@ -8,7 +8,7 @@ i386_kvm_ss.add(files(
>>   
>>   i386_kvm_ss.add(when: 'CONFIG_XEN_EMU', if_true: files('xen-emu.c'))
>>   
>> -i386_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c'))
>> +i386_kvm_ss.add(when: 'CONFIG_TDX', if_true: files('tdx.c'), if_false: files('tdx-stub.c'))
>>   
>>   i386_system_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
>>   
>> diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
>> new file mode 100644
>> index 000000000000..b614b46d3f4a
>> --- /dev/null
>> +++ b/target/i386/kvm/tdx-stub.c
>> @@ -0,0 +1,8 @@
>> +#include "qemu/osdep.h"
>> +
>> +#include "tdx.h"
>> +
>> +int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>> +{
>> +    return -EINVAL;
>> +}
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index ff3ef9bd8657..1b7894e43c6f 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -137,6 +137,91 @@ static int tdx_kvm_type(X86ConfidentialGuest *cg)
>>       return KVM_X86_TDX_VM;
>>   }
>>   
>> +static int setup_td_xfam(X86CPU *x86cpu, Error **errp)
>> +{
>> +    CPUX86State *env = &x86cpu->env;
>> +    uint64_t xfam;
>> +
>> +    xfam = env->features[FEAT_XSAVE_XCR0_LO] |
>> +           env->features[FEAT_XSAVE_XCR0_HI] |
>> +           env->features[FEAT_XSAVE_XSS_LO] |
>> +           env->features[FEAT_XSAVE_XSS_HI];
>> +
>> +    if (xfam & ~tdx_caps->supported_xfam) {
>> +        error_setg(errp, "Invalid XFAM 0x%lx for TDX VM (supported: 0x%llx))",
>> +                   xfam, tdx_caps->supported_xfam);
>> +        return -1;
>> +    }
>> +
>> +    tdx_guest->xfam = xfam;
>> +    return 0;
>> +}
>> +
>> +static void tdx_filter_cpuid(struct kvm_cpuid2 *cpuids)
>> +{
>> +    int i, dest_cnt = 0;
>> +    struct kvm_cpuid_entry2 *src, *dest, *conf;
>> +
>> +    for (i = 0; i < cpuids->nent; i++) {
>> +        src = cpuids->entries + i;
>> +        conf = cpuid_find_entry(&tdx_caps->cpuid, src->function, src->index);
>> +        if (!conf) {
>> +            continue;
>> +        }
>> +        dest = cpuids->entries + dest_cnt;
>> +
>> +        dest->function = src->function;
>> +        dest->index = src->index;
>> +        dest->flags = src->flags;
>> +        dest->eax = src->eax & conf->eax;
>> +        dest->ebx = src->ebx & conf->ebx;
>> +        dest->ecx = src->ecx & conf->ecx;
>> +        dest->edx = src->edx & conf->edx;
>> +
>> +        dest_cnt++;
>> +    }
>> +    cpuids->nent = dest_cnt++;
>> +}
>> +
>> +int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>> +{
>> +    X86CPU *x86cpu = X86_CPU(cpu);
>> +    CPUX86State *env = &x86cpu->env;
>> +    g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
>> +    int r = 0;
>> +
>> +    QEMU_LOCK_GUARD(&tdx_guest->lock);
>> +    if (tdx_guest->initialized) {
>> +        return r;
>> +    }
>> +
>> +    init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
>> +                        sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
>> +
>> +    r = setup_td_xfam(x86cpu, errp);
>> +    if (r) {
>> +        return r;
>> +    }
>> +
>> +    init_vm->cpuid.nent = kvm_x86_build_cpuid(env, init_vm->cpuid.entries, 0);
>> +    tdx_filter_cpuid(&init_vm->cpuid);
>> +
>> +    init_vm->attributes = tdx_guest->attributes;
>> +    init_vm->xfam = tdx_guest->xfam;
>> +
>> +    do {
>> +        r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, init_vm);
>> +    } while (r == -EAGAIN);
> 
> Other calls to tdx_vm_ioctl don't loop on EAGAIN. Is the need to
> do this retry specific to only KVM_TDX_INIT_VM, or should we push
> the EAGAIN retry logic inside tdx_vm_ioctl_helper so all callers
> benefit ?

So far, only KVM_TDX_INIT_VM can get -EAGAIN due to KVM side 
TDH_MNG_CREATE gets TDX_RND_NO_ENTROPY because Random number generation 
(e.g., RDRAND or RDSEED) failed and in this case it should retry.

I think adding a commment to explain why it can get -EAGAIN and needs to 
retry should suffice?

>> +    if (r < 0) {
>> +        error_setg_errno(errp, -r, "KVM_TDX_INIT_VM failed");
>> +        return r;
>> +    }
>> +
>> +    tdx_guest->initialized = true;
>> +
>> +    return 0;
>> +}
> 
> With regards,
> Daniel


