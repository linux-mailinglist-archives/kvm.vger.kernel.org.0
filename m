Return-Path: <kvm+bounces-1869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EC14A7EDA6C
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 04:40:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 290F71C20918
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 03:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFB9AC126;
	Thu, 16 Nov 2023 03:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EhW882Pv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6831F1B3
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 19:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700106023; x=1731642023;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2g/nSpUeYAI0OsL4LSEsZIaBASDmEzDwebICySRFOHs=;
  b=EhW882PvX6iSKu0GpxiR4whVmwNQC0AJotn3tJ9oPA55absCUrErWsmf
   lFyHLHG7S8e/G9OZXmj0Q/3WoXFOqQawVUHTpQYUsFVfrPRER3vzGsFVS
   0ZWcHjbW3s27UQFXowPUOj2VK0lkX4kiveZUaWnddSxSuFpSH25phEw7p
   nUrYUotbovRXjtghTEJ0Z7MwjsEjiYmz63nSmbbZphWoBJdnDoUgjc4mb
   X/E4rmUwfnMFc9Ei16Fa/a/3hnYVXK5XeGcXFDwdaaPKbmMj+du3dx+kW
   i30GovHgdj5P524iRop7mLO1gv5oy/EOqmEdHjPnLskx9pFaXBqovkZc+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="477226157"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="477226157"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 19:40:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="938701423"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="938701423"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 19:40:17 -0800
Message-ID: <cfcf0700-8e1d-4b33-acd4-e19dec9d9c12@intel.com>
Date: Thu, 16 Nov 2023 11:40:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/70] kvm: Introduce support for memory_attributes
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
 <20231115071519.2864957-7-xiaoyao.li@intel.com> <ZVSfkgidWqUYHHSO@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZVSfkgidWqUYHHSO@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/15/2023 6:38 PM, Daniel P. Berrangé wrote:
> On Wed, Nov 15, 2023 at 02:14:15AM -0500, Xiaoyao Li wrote:
>> Introduce the helper functions to set the attributes of a range of
>> memory to private or shared.
>>
>> This is necessary to notify KVM the private/shared attribute of each gpa
>> range. KVM needs the information to decide the GPA needs to be mapped at
>> hva-based shared memory or guest_memfd based private memory.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   accel/kvm/kvm-all.c  | 42 ++++++++++++++++++++++++++++++++++++++++++
>>   include/sysemu/kvm.h |  3 +++
>>   2 files changed, 45 insertions(+)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 69afeb47c9c0..76e2404d54d2 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -102,6 +102,7 @@ bool kvm_has_guest_debug;
>>   static int kvm_sstep_flags;
>>   static bool kvm_immediate_exit;
>>   static bool kvm_guest_memfd_supported;
>> +static uint64_t kvm_supported_memory_attributes;
>>   static hwaddr kvm_max_slot_size = ~0;
>>   
>>   static const KVMCapabilityInfo kvm_required_capabilites[] = {
>> @@ -1305,6 +1306,44 @@ void kvm_set_max_memslot_size(hwaddr max_slot_size)
>>       kvm_max_slot_size = max_slot_size;
>>   }
>>   
>> +static int kvm_set_memory_attributes(hwaddr start, hwaddr size, uint64_t attr)
>> +{
>> +    struct kvm_memory_attributes attrs;
>> +    int r;
>> +
>> +    attrs.attributes = attr;
>> +    attrs.address = start;
>> +    attrs.size = size;
>> +    attrs.flags = 0;
>> +
>> +    r = kvm_vm_ioctl(kvm_state, KVM_SET_MEMORY_ATTRIBUTES, &attrs);
>> +    if (r) {
>> +        warn_report("%s: failed to set memory (0x%lx+%#zx) with attr 0x%lx error '%s'",
>> +                     __func__, start, size, attr, strerror(errno));
> 
> This is an error condition rather than an warning condition.
> 
> Also again I think __func__ is generally not required in an error message,
> if the error message text is suitably descriptive - applies to other
> patches in this series too.

Get it.

>> +    }
>> +    return r;
>> +}
>> +
>> +int kvm_set_memory_attributes_private(hwaddr start, hwaddr size)
>> +{
>> +    if (!(kvm_supported_memory_attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
>> +        error_report("KVM doesn't support PRIVATE memory attribute\n");
>> +        return -EINVAL;
>> +    }
>> +
>> +    return kvm_set_memory_attributes(start, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
>> +}
>> +
>> +int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size)
>> +{
>> +    if (!(kvm_supported_memory_attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
>> +        error_report("KVM doesn't support PRIVATE memory attribute\n");
>> +        return -EINVAL;
>> +    }
>> +
>> +    return kvm_set_memory_attributes(start, size, 0);
>> +}
>> +
>>   /* Called with KVMMemoryListener.slots_lock held */
>>   static void kvm_set_phys_mem(KVMMemoryListener *kml,
>>                                MemoryRegionSection *section, bool add)
>> @@ -2440,6 +2479,9 @@ static int kvm_init(MachineState *ms)
>>   
>>       kvm_guest_memfd_supported = kvm_check_extension(s, KVM_CAP_GUEST_MEMFD);
>>   
>> +    ret = kvm_check_extension(s, KVM_CAP_MEMORY_ATTRIBUTES);
>> +    kvm_supported_memory_attributes = ret > 0 ? ret : 0;
>> +
>>       if (object_property_find(OBJECT(current_machine), "kvm-type")) {
>>           g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
>>                                                               "kvm-type",
>> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
>> index fedc28c7d17f..0e88958190a4 100644
>> --- a/include/sysemu/kvm.h
>> +++ b/include/sysemu/kvm.h
>> @@ -540,4 +540,7 @@ bool kvm_dirty_ring_enabled(void);
>>   uint32_t kvm_dirty_ring_size(void);
>>   
>>   int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp);
>> +
>> +int kvm_set_memory_attributes_private(hwaddr start, hwaddr size);
>> +int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size);
>>   #endif
>> -- 
>> 2.34.1
>>
> 
> With regards,
> Daniel


