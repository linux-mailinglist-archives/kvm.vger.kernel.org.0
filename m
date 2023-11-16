Return-Path: <kvm+bounces-1871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54F1D7EDB1C
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 06:17:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77CDF1C209D4
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 05:17:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82B98CA4A;
	Thu, 16 Nov 2023 05:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OWsf0U76"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D3F18D
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 21:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700111815; x=1731647815;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/INa79jB8VKoRWQG9/d/TbWATffq3Wxzhda7N1BwDPc=;
  b=OWsf0U76SZOsvI7+ROQRLhFbf4opWOJKcdVl3DXWi9EiNKhwXnyttAyk
   IWXEoPuFw+o8tBQtQ13JW9Pg/U1UBdMm0BjtErJZUL3MS3b6yRz67Mdvl
   49YOi2slBuVDuTqRgOmsmqOjqaB7t8QJXofkJIY9CfVABapLj2oPcrCMM
   XLX2x8Odv9Spgwe2ahCvu7LDvEA2/VVi4zwn4Mw+SwVvbFkq/sNw2J825
   9snsj3N/3CrgFY5qkYqrUzKQRGJStCGGJ9VVvp3GetLYSInyuZjqTyjn6
   zi6xfAE7oTb1GueYvLTbQKJdnWJRoJ/ivJChXDi+TZBu46XeSrZ3vMoOD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="370374264"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="370374264"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 21:16:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="13002025"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 21:16:50 -0800
Message-ID: <727a54e6-9ab5-4329-b5fe-3d3abb72b3da@intel.com>
Date: Thu, 16 Nov 2023 13:16:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/70] kvm: handle KVM_EXIT_MEMORY_FAULT
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
 <20231115071519.2864957-11-xiaoyao.li@intel.com>
 <ZVSgkM1H7O0BLbEf@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZVSgkM1H7O0BLbEf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/15/2023 6:42 PM, Daniel P. Berrangé wrote:
> On Wed, Nov 15, 2023 at 02:14:19AM -0500, Xiaoyao Li wrote:
>> From: Chao Peng <chao.p.peng@linux.intel.com>
>>
>> Currently only KVM_MEMORY_EXIT_FLAG_PRIVATE in flags is valid when
>> KVM_EXIT_MEMORY_FAULT happens. It indicates userspace needs to do
>> the memory conversion on the RAMBlock to turn the memory into desired
>> attribute, i.e., private/shared.
>>
>> Note, KVM_EXIT_MEMORY_FAULT makes sense only when the RAMBlock has
>> guest_memfd memory backend.
>>
>> Note, KVM_EXIT_MEMORY_FAULT returns with -EFAULT, so special handling is
>> added.
>>
>> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   accel/kvm/kvm-all.c | 76 +++++++++++++++++++++++++++++++++++++++------
>>   1 file changed, 66 insertions(+), 10 deletions(-)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 76e2404d54d2..58abbcb6926e 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -2902,6 +2902,50 @@ static void kvm_eat_signals(CPUState *cpu)
>>       } while (sigismember(&chkset, SIG_IPI));
>>   }
>>   
>> +static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>> +{
>> +    MemoryRegionSection section;
>> +    ram_addr_t offset;
>> +    RAMBlock *rb;
>> +    void *addr;
>> +    int ret = -1;
>> +
>> +    section = memory_region_find(get_system_memory(), start, size);
>> +    if (!section.mr) {
>> +        return ret;
>> +    }
>> +
>> +    if (memory_region_has_guest_memfd(section.mr)) {
>> +        if (to_private) {
>> +            ret = kvm_set_memory_attributes_private(start, size);
>> +        } else {
>> +            ret = kvm_set_memory_attributes_shared(start, size);
>> +        }
>> +
>> +        if (ret) {
>> +            memory_region_unref(section.mr);
>> +            return ret;
>> +        }
>> +
>> +        addr = memory_region_get_ram_ptr(section.mr) +
>> +               section.offset_within_region;
>> +        rb = qemu_ram_block_from_host(addr, false, &offset);
>> +        /*
>> +         * With KVM_SET_MEMORY_ATTRIBUTES by kvm_set_memory_attributes(),
>> +         * operation on underlying file descriptor is only for releasing
>> +         * unnecessary pages.
>> +         */
>> +        ram_block_convert_range(rb, offset, size, to_private);
>> +    } else {
>> +        warn_report("Convert non guest_memfd backed memory region "
>> +                    "(0x%"HWADDR_PRIx" ,+ 0x%"HWADDR_PRIx") to %s",
>> +                    start, size, to_private ? "private" : "shared");
> 
> Again, if you're returning '-1' to indicate error, then
> using warn_report is wrong, it should be error_report.
> 
> warn_report is for when you return success, indicating
> the problem was non-fatal.

Learned.

Thanks!

>> +    }
>> +
>> +    memory_region_unref(section.mr);
>> +    return ret;
>> +}
>> +
>>   int kvm_cpu_exec(CPUState *cpu)
>>   {
>>       struct kvm_run *run = cpu->kvm_run;
>> @@ -2969,18 +3013,20 @@ int kvm_cpu_exec(CPUState *cpu)
>>                   ret = EXCP_INTERRUPT;
>>                   break;
>>               }
>> -            fprintf(stderr, "error: kvm run failed %s\n",
>> -                    strerror(-run_ret));
>> +            if (!(run_ret == -EFAULT && run->exit_reason == KVM_EXIT_MEMORY_FAULT)) {
>> +                fprintf(stderr, "error: kvm run failed %s\n",
>> +                        strerror(-run_ret));
>>   #ifdef TARGET_PPC
>> -            if (run_ret == -EBUSY) {
>> -                fprintf(stderr,
>> -                        "This is probably because your SMT is enabled.\n"
>> -                        "VCPU can only run on primary threads with all "
>> -                        "secondary threads offline.\n");
>> -            }
>> +                if (run_ret == -EBUSY) {
>> +                    fprintf(stderr,
>> +                            "This is probably because your SMT is enabled.\n"
>> +                            "VCPU can only run on primary threads with all "
>> +                            "secondary threads offline.\n");
>> +                }
>>   #endif
>> -            ret = -1;
>> -            break;
>> +                ret = -1;
>> +                break;
>> +            }
>>           }
>>   
>>           trace_kvm_run_exit(cpu->cpu_index, run->exit_reason);
>> @@ -3067,6 +3113,16 @@ int kvm_cpu_exec(CPUState *cpu)
>>                   break;
>>               }
>>               break;
>> +        case KVM_EXIT_MEMORY_FAULT:
>> +            if (run->memory_fault.flags & ~KVM_MEMORY_EXIT_FLAG_PRIVATE) {
>> +                error_report("KVM_EXIT_MEMORY_FAULT: Unknown flag 0x%" PRIx64,
>> +                             (uint64_t)run->memory_fault.flags);
>> +                ret = -1;
>> +                break;
>> +            }
>> +            ret = kvm_convert_memory(run->memory_fault.gpa, run->memory_fault.size,
>> +                                     run->memory_fault.flags & KVM_MEMORY_EXIT_FLAG_PRIVATE);
>> +            break;
>>           default:
>>               DPRINTF("kvm_arch_handle_exit\n");
>>               ret = kvm_arch_handle_exit(cpu, run);
>> -- 
>> 2.34.1
>>
> 
> With regards,
> Daniel


