Return-Path: <kvm+bounces-3815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 143CB8081B6
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 08:17:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B70DE282FC2
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 07:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1487D171B9;
	Thu,  7 Dec 2023 07:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GcMoetH7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6551193
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 23:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701933435; x=1733469435;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BgCZPpQ50gmd2BMmvAZSRbHcwf16Fy5t1weLfxDv2Hs=;
  b=GcMoetH7vyia91rDHeOny94ApxTpYCxJKeILFZF1fJvCbdJeHDExByKD
   rUtK5x/LCTLl6UdiOWgCRPWVyE1D3RTw8QUjP2VvWa7oO6mrBMGORKi2z
   VLySmpTQyaLCYZ5IuYygchRf7VoSxPkZsYCNragNmhP3ost1xAQZNGXyr
   G4GCyBO3owIIDc8cmifHVM7jFMsnXZiAe9h/DEUN6f566Awr90tmzj5mW
   ikM5XKPfBfEZHC7NWGlaSR1u5DglkM49di66RftQYEfFQm50rSl+OgXzr
   3D71lCdEjUlDCqHVqNfy2e9QFy34dBfbrHRR8DhZc9Gxu/INUPGz7Ab5O
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="480378938"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="480378938"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 23:17:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="944933517"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="944933517"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 23:17:05 -0800
Message-ID: <e5a3eb28-aa97-4e07-a21c-02c20867f9a7@intel.com>
Date: Thu, 7 Dec 2023 15:16:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/70] i386/tdx: Get tdx_capabilities via
 KVM_TDX_CAPABILITIES
Content-Language: en-US
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand
 <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
 Sean Christopherson <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>,
 isaku.yamahata@intel.com
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-19-xiaoyao.li@intel.com>
 <20231117211843.GA1648821@ls.amr.corp.intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20231117211843.GA1648821@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/2023 5:18 AM, Isaku Yamahata wrote:
> On Wed, Nov 15, 2023 at 02:14:27AM -0500,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> KVM provides TDX capabilities via sub command KVM_TDX_CAPABILITIES of
>> IOCTL(KVM_MEMORY_ENCRYPT_OP). Get the capabilities when initializing
>> TDX context. It will be used to validate user's setting later.
>>
>> Since there is no interface reporting how many cpuid configs contains in
>> KVM_TDX_CAPABILITIES, QEMU chooses to try starting with a known number
>> and abort when it exceeds KVM_MAX_CPUID_ENTRIES.
>>
>> Besides, introduce the interfaces to invoke TDX "ioctls" at different
>> scope (KVM, VM and VCPU) in preparation.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>> Changes in v3:
>> - rename __tdx_ioctl() to tdx_ioctl_internal()
>> - Pass errp in get_tdx_capabilities();
>>
>> changes in v2:
>>    - Make the error message more clear;
>>
>> changes in v1:
>>    - start from nr_cpuid_configs = 6 for the loop;
>>    - stop the loop when nr_cpuid_configs exceeds KVM_MAX_CPUID_ENTRIES;
>> ---
>>   target/i386/kvm/kvm.c      |   2 -
>>   target/i386/kvm/kvm_i386.h |   2 +
>>   target/i386/kvm/tdx.c      | 102 ++++++++++++++++++++++++++++++++++++-
>>   3 files changed, 103 insertions(+), 3 deletions(-)
>>
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index 7abcdebb1452..28e60c5ea4a7 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -1687,8 +1687,6 @@ static int hyperv_init_vcpu(X86CPU *cpu)
>>   
>>   static Error *invtsc_mig_blocker;
>>   
>> -#define KVM_MAX_CPUID_ENTRIES  100
>> -
>>   static void kvm_init_xsave(CPUX86State *env)
>>   {
>>       if (has_xsave2) {
>> diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
>> index 55fb25fa8e2e..c3ef46a97a7b 100644
>> --- a/target/i386/kvm/kvm_i386.h
>> +++ b/target/i386/kvm/kvm_i386.h
>> @@ -13,6 +13,8 @@
>>   
>>   #include "sysemu/kvm.h"
>>   
>> +#define KVM_MAX_CPUID_ENTRIES  100
>> +
>>   #ifdef CONFIG_KVM
>>   
>>   #define kvm_pit_in_kernel() \
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 621a05beeb4e..cb0040187b27 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -12,17 +12,117 @@
>>    */
>>   
>>   #include "qemu/osdep.h"
>> +#include "qemu/error-report.h"
>>   #include "qapi/error.h"
>>   #include "qom/object_interfaces.h"
>> +#include "sysemu/kvm.h"
>>   
>>   #include "hw/i386/x86.h"
>> +#include "kvm_i386.h"
>>   #include "tdx.h"
>>   
>> +static struct kvm_tdx_capabilities *tdx_caps;
>> +
>> +enum tdx_ioctl_level{
>> +    TDX_PLATFORM_IOCTL,
>> +    TDX_VM_IOCTL,
>> +    TDX_VCPU_IOCTL,
>> +};
>> +
>> +static int tdx_ioctl_internal(void *state, enum tdx_ioctl_level level, int cmd_id,
>> +                        __u32 flags, void *data)
>> +{
>> +    struct kvm_tdx_cmd tdx_cmd;
>> +    int r;
>> +
>> +    memset(&tdx_cmd, 0x0, sizeof(tdx_cmd));
>> +
>> +    tdx_cmd.id = cmd_id;
>> +    tdx_cmd.flags = flags;
>> +    tdx_cmd.data = (__u64)(unsigned long)data;
>> +
>> +    switch (level) {
>> +    case TDX_PLATFORM_IOCTL:
>> +        r = kvm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
>> +        break;
>> +    case TDX_VM_IOCTL:
>> +        r = kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
>> +        break;
>> +    case TDX_VCPU_IOCTL:
>> +        r = kvm_vcpu_ioctl(state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
>> +        break;
>> +    default:
>> +        error_report("Invalid tdx_ioctl_level %d", level);
>> +        exit(1);
>> +    }
>> +
>> +    return r;
>> +}
>> +
>> +static inline int tdx_platform_ioctl(int cmd_id, __u32 flags, void *data)
>> +{
>> +    return tdx_ioctl_internal(NULL, TDX_PLATFORM_IOCTL, cmd_id, flags, data);
>> +}
>> +
>> +static inline int tdx_vm_ioctl(int cmd_id, __u32 flags, void *data)
>> +{
>> +    return tdx_ioctl_internal(NULL, TDX_VM_IOCTL, cmd_id, flags, data);
>> +}
>> +
>> +static inline int tdx_vcpu_ioctl(void *vcpu_fd, int cmd_id, __u32 flags,
>> +                                 void *data)
>> +{
>> +    return  tdx_ioctl_internal(vcpu_fd, TDX_VCPU_IOCTL, cmd_id, flags, data);
>> +}
> 
> As all of ioctl variants aren't used yet, we can split out them. 

No. tdx_vm_ioctl() is used right below.

I can remove the tdx_platform_ioctl() because its sole user, 
KVM_TDX_CAPABILITIES, changed to vm scope.

> An independent
> patch to define ioctl functions.
> 
> 
>> +
>> +static int get_tdx_capabilities(Error **errp)
>> +{
>> +    struct kvm_tdx_capabilities *caps;
>> +    /* 1st generation of TDX reports 6 cpuid configs */
>> +    int nr_cpuid_configs = 6;
>> +    size_t size;
>> +    int r;
>> +
>> +    do {
>> +        size = sizeof(struct kvm_tdx_capabilities) +
>> +               nr_cpuid_configs * sizeof(struct kvm_tdx_cpuid_config);
>> +        caps = g_malloc0(size);
>> +        caps->nr_cpuid_configs = nr_cpuid_configs;
>> +
>> +        r = tdx_vm_ioctl(KVM_TDX_CAPABILITIES, 0, caps);
>> +        if (r == -E2BIG) {
>> +            g_free(caps);
>> +            nr_cpuid_configs *= 2;
> 
> g_realloc()?  Maybe a matter of preference.

I would like to keep the current code unless strong objection from 
maintainers.

> Other than this, it looks good to me.


