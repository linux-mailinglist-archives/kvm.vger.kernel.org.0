Return-Path: <kvm+bounces-1868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 878D07EDA49
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 04:34:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CFC72810DC
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 03:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42084947A;
	Thu, 16 Nov 2023 03:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gjbeiqdZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A9A8F
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 19:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700105661; x=1731641661;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iF9QdIiqtjI0Hn6Ox+hqHjmWadpGoLAqk5iPWE7y5xg=;
  b=gjbeiqdZ21es09Ut59HmRb2cI+q5NYTL0NoDAxZSlcESTBVvp2hDSaf7
   J6SJ99xwk+ql+YKMaajOdmZzirg3T969MvUIYk8wQtGWRDRE2bxkx++kF
   926M8CXZwEhdQkZIX1c0Z2oYP8fwP4E0ez6Hx2eKe0kxFDLZHCRvLNRG1
   slQun2pUkFcwbw/ROzyTymUPtl+9qLgfyClH1QKNrIrfP9kPKfTLgyjp5
   /qmxH6YtNSpefYrwSMKIJE6Nu6lYdND4YJaD3vCoRvm1ujd80DiHjWcdk
   TaomhQve04pcZ801dMruDt8PZx+xlI4OM3+d8cXOnyreIndyIn5unCsiR
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="4083348"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="4083348"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 19:34:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="835609046"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="835609046"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 19:34:15 -0800
Message-ID: <d8b2cdcd-ca00-419b-a5e3-f81ab633abad@intel.com>
Date: Thu, 16 Nov 2023 11:34:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/70] RAMBlock: Add support of KVM private guest memfd
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
 <20231115071519.2864957-3-xiaoyao.li@intel.com> <ZVSbe4lryQyMVnMT@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZVSbe4lryQyMVnMT@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/15/2023 6:20 PM, Daniel P. Berrangé wrote:
> On Wed, Nov 15, 2023 at 02:14:11AM -0500, Xiaoyao Li wrote:
>> Add KVM guest_memfd support to RAMBlock so both normal hva based memory
>> and kvm guest memfd based private memory can be associated in one RAMBlock.
>>
>> Introduce new flag RAM_GUEST_MEMFD. When it's set, it calls KVM ioctl to
>> create private guest_memfd during RAMBlock setup.
>>
>> Note, RAM_GUEST_MEMFD is supposed to be set for memory backends of
>> confidential guests, such as TDX VM. How and when to set it for memory
>> backends will be implemented in the following patches.
>>
>> Introduce memory_region_has_guest_memfd() to query if the MemoryRegion has
>> KVM guest_memfd allocated.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>> Changes in v3:
>> - rename gmem to guest_memfd;
>> - close(guest_memfd) when RAMBlock is released; (Daniel P. Berrangé)
>> - Suqash the patch that introduces memory_region_has_guest_memfd().
>> ---
>>   accel/kvm/kvm-all.c     | 24 ++++++++++++++++++++++++
>>   include/exec/memory.h   | 13 +++++++++++++
>>   include/exec/ramblock.h |  1 +
>>   include/sysemu/kvm.h    |  2 ++
>>   system/memory.c         |  5 +++++
>>   system/physmem.c        | 27 ++++++++++++++++++++++++---
>>   6 files changed, 69 insertions(+), 3 deletions(-)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index c1b40e873531..9f751d4971f8 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -101,6 +101,7 @@ bool kvm_msi_use_devid;
>>   bool kvm_has_guest_debug;
>>   static int kvm_sstep_flags;
>>   static bool kvm_immediate_exit;
>> +static bool kvm_guest_memfd_supported;
>>   static hwaddr kvm_max_slot_size = ~0;
>>   
>>   static const KVMCapabilityInfo kvm_required_capabilites[] = {
>> @@ -2397,6 +2398,8 @@ static int kvm_init(MachineState *ms)
>>       }
>>       s->as = g_new0(struct KVMAs, s->nr_as);
>>   
>> +    kvm_guest_memfd_supported = kvm_check_extension(s, KVM_CAP_GUEST_MEMFD);
>> +
>>       if (object_property_find(OBJECT(current_machine), "kvm-type")) {
>>           g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
>>                                                               "kvm-type",
>> @@ -4078,3 +4081,24 @@ void query_stats_schemas_cb(StatsSchemaList **result, Error **errp)
>>           query_stats_schema_vcpu(first_cpu, &stats_args);
>>       }
>>   }
>> +
>> +int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp)
>> +{
>> +    int fd;
>> +    struct kvm_create_guest_memfd guest_memfd = {
>> +        .size = size,
>> +        .flags = flags,
>> +    };
>> +
>> +    if (!kvm_guest_memfd_supported) {
>> +        error_setg(errp, "KVM doesn't support guest memfd\n");
>> +        return -EOPNOTSUPP;
> 
> Returning an errno value is unusual when we have an 'Error **errp' parameter
> for reporting, and the following codepath merely returns -1, so this is
> inconsistent. Just return -1 here too.

OK.

>> +    }
>> +
>> +    fd = kvm_vm_ioctl(kvm_state, KVM_CREATE_GUEST_MEMFD, &guest_memfd);
>> +    if (fd < 0) {
>> +        error_setg_errno(errp, errno, "%s: error creating kvm guest memfd\n", __func__);
> 
> I'd prefer an explicit 'return -1' here, even though 'fd' is technically going
> to be -1 already.
> 
> Also including __func__ in the error message is not really needed IMHO

OK

>> +    }
>> +
>> +    return fd;
>> +}
>> diff --git a/include/exec/memory.h b/include/exec/memory.h
>> index 831f7c996d9d..f780367ab1bd 100644
>> --- a/include/exec/memory.h
>> +++ b/include/exec/memory.h
>> @@ -243,6 +243,9 @@ typedef struct IOMMUTLBEvent {
>>   /* RAM FD is opened read-only */
>>   #define RAM_READONLY_FD (1 << 11)
>>   
>> +/* RAM can be private that has kvm gmem backend */
>> +#define RAM_GUEST_MEMFD   (1 << 12)
>> +
>>   static inline void iommu_notifier_init(IOMMUNotifier *n, IOMMUNotify fn,
>>                                          IOMMUNotifierFlag flags,
>>                                          hwaddr start, hwaddr end,
>> @@ -1702,6 +1705,16 @@ static inline bool memory_region_is_romd(MemoryRegion *mr)
>>    */
>>   bool memory_region_is_protected(MemoryRegion *mr);
>>   
>> +/**
>> + * memory_region_has_guest_memfd: check whether a memory region has guest_memfd
>> + *     associated
>> + *
>> + * Returns %true if a memory region's ram_block has valid guest_memfd assigned.
>> + *
>> + * @mr: the memory region being queried
>> + */
>> +bool memory_region_has_guest_memfd(MemoryRegion *mr);
>> +
>>   /**
>>    * memory_region_get_iommu: check whether a memory region is an iommu
>>    *
>> diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
>> index 69c6a5390293..0a17ba882729 100644
>> --- a/include/exec/ramblock.h
>> +++ b/include/exec/ramblock.h
>> @@ -41,6 +41,7 @@ struct RAMBlock {
>>       QLIST_HEAD(, RAMBlockNotifier) ramblock_notifiers;
>>       int fd;
>>       uint64_t fd_offset;
>> +    int guest_memfd;
>>       size_t page_size;
>>       /* dirty bitmap used during migration */
>>       unsigned long *bmap;
>> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
>> index d61487816421..fedc28c7d17f 100644
>> --- a/include/sysemu/kvm.h
>> +++ b/include/sysemu/kvm.h
>> @@ -538,4 +538,6 @@ bool kvm_arch_cpu_check_are_resettable(void);
>>   bool kvm_dirty_ring_enabled(void);
>>   
>>   uint32_t kvm_dirty_ring_size(void);
>> +
>> +int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp);
>>   #endif
>> diff --git a/system/memory.c b/system/memory.c
>> index 304fa843ea12..69741d91bbb7 100644
>> --- a/system/memory.c
>> +++ b/system/memory.c
>> @@ -1862,6 +1862,11 @@ bool memory_region_is_protected(MemoryRegion *mr)
>>       return mr->ram && (mr->ram_block->flags & RAM_PROTECTED);
>>   }
>>   
>> +bool memory_region_has_guest_memfd(MemoryRegion *mr)
>> +{
>> +    return mr->ram_block && mr->ram_block->guest_memfd >= 0;
>> +}
>> +
>>   uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
>>   {
>>       uint8_t mask = mr->dirty_log_mask;
>> diff --git a/system/physmem.c b/system/physmem.c
>> index fc2b0fee0188..0af2213cbd9c 100644
>> --- a/system/physmem.c
>> +++ b/system/physmem.c
>> @@ -1841,6 +1841,20 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>>           }
>>       }
>>   
>> +#ifdef CONFIG_KVM
>> +    if (kvm_enabled() && new_block->flags & RAM_GUEST_MEMFD &&
>> +        new_block->guest_memfd < 0) {
>> +        /* TODO: to decide if KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is supported */
>> +        uint64_t flags = 0;
>> +        new_block->guest_memfd = kvm_create_guest_memfd(new_block->max_length,
>> +                                                        flags, errp);
>> +        if (new_block->guest_memfd < 0) {
>> +            qemu_mutex_unlock_ramlist();
>> +            return;
>> +        }
>> +    }
>> +#endif
>> +
>>       new_ram_size = MAX(old_ram_size,
>>                 (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS);
>>       if (new_ram_size > old_ram_size) {
>> @@ -1903,7 +1917,7 @@ RAMBlock *qemu_ram_alloc_from_fd(ram_addr_t size, MemoryRegion *mr,
>>       /* Just support these ram flags by now. */
>>       assert((ram_flags & ~(RAM_SHARED | RAM_PMEM | RAM_NORESERVE |
>>                             RAM_PROTECTED | RAM_NAMED_FILE | RAM_READONLY |
>> -                          RAM_READONLY_FD)) == 0);
>> +                          RAM_READONLY_FD | RAM_GUEST_MEMFD)) == 0);
>>   
>>       if (xen_enabled()) {
>>           error_setg(errp, "-mem-path not supported with Xen");
>> @@ -1938,6 +1952,7 @@ RAMBlock *qemu_ram_alloc_from_fd(ram_addr_t size, MemoryRegion *mr,
>>       new_block->used_length = size;
>>       new_block->max_length = size;
>>       new_block->flags = ram_flags;
>> +    new_block->guest_memfd = -1;
>>       new_block->host = file_ram_alloc(new_block, size, fd, !file_size, offset,
>>                                        errp);
>>       if (!new_block->host) {
>> @@ -2016,7 +2031,7 @@ RAMBlock *qemu_ram_alloc_internal(ram_addr_t size, ram_addr_t max_size,
>>       Error *local_err = NULL;
>>   
>>       assert((ram_flags & ~(RAM_SHARED | RAM_RESIZEABLE | RAM_PREALLOC |
>> -                          RAM_NORESERVE)) == 0);
>> +                          RAM_NORESERVE| RAM_GUEST_MEMFD)) == 0);
>>       assert(!host ^ (ram_flags & RAM_PREALLOC));
>>   
>>       size = HOST_PAGE_ALIGN(size);
>> @@ -2028,6 +2043,7 @@ RAMBlock *qemu_ram_alloc_internal(ram_addr_t size, ram_addr_t max_size,
>>       new_block->max_length = max_size;
>>       assert(max_size >= size);
>>       new_block->fd = -1;
>> +    new_block->guest_memfd = -1;
>>       new_block->page_size = qemu_real_host_page_size();
>>       new_block->host = host;
>>       new_block->flags = ram_flags;
>> @@ -2050,7 +2066,7 @@ RAMBlock *qemu_ram_alloc_from_ptr(ram_addr_t size, void *host,
>>   RAMBlock *qemu_ram_alloc(ram_addr_t size, uint32_t ram_flags,
>>                            MemoryRegion *mr, Error **errp)
>>   {
>> -    assert((ram_flags & ~(RAM_SHARED | RAM_NORESERVE)) == 0);
>> +    assert((ram_flags & ~(RAM_SHARED | RAM_NORESERVE | RAM_GUEST_MEMFD)) == 0);
>>       return qemu_ram_alloc_internal(size, size, NULL, NULL, ram_flags, mr, errp);
>>   }
>>   
>> @@ -2078,6 +2094,11 @@ static void reclaim_ramblock(RAMBlock *block)
>>       } else {
>>           qemu_anon_ram_free(block->host, block->max_length);
>>       }
>> +
>> +    if (block->guest_memfd >= 0) {
>> +        close(block->guest_memfd);
>> +    }
>> +
>>       g_free(block);
>>   }
>>   
>> -- 
>> 2.34.1
>>
> 
> With regards,
> Daniel


