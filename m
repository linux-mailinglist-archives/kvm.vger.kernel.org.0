Return-Path: <kvm+bounces-3290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 34F83802BB5
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 07:48:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9D788B209FD
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 06:48:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93CE68F49;
	Mon,  4 Dec 2023 06:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fdz6nLyP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAF5D3
	for <kvm@vger.kernel.org>; Sun,  3 Dec 2023 22:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701672521; x=1733208521;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=y8yRSaEkPLF2VOkDRnbgCR2r31wGQ3+5KgDkJM6z/dU=;
  b=Fdz6nLyPkGYBdmpfcEbqDB6RERdWNMf/ZqJrvQU4F6K+KHRuCG7khroP
   0RpaobxeU5SoN/MdEGEAiiF2V56yk1jfVSAVAb94Ld5uh3Bn9qjeVoFbK
   vJjwp6FD1juw59QmwNRNfHg+wlyh/67wfEnTHYw0C4sGQySyqeWEiJ/su
   jx7JOUK0LTGnMosIhFeHDCrOLaQo8Th5/OPc1a5gXc6PIrwEyHpejFH8x
   ShUxg8YVpTiI1kJ/6GcdYMOL2md8YFfh2pOYzOQCwZHESzwSztzaTxX1H
   2+co6n7/oZ8DuqgHIgVSCWvsAqBApgwj3jcRgKhwxuNl7TjLLaIEji+Qg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="390852121"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="390852121"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2023 22:48:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="746725855"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="746725855"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2023 22:48:31 -0800
Message-ID: <9c113486-3a47-40f1-bfe4-1639a4c7b489@intel.com>
Date: Mon, 4 Dec 2023 14:48:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/70] kvm: Enable KVM_SET_USER_MEMORY_REGION2 for
 memslot
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
 <20231115071519.2864957-6-xiaoyao.li@intel.com>
 <20231117205028.GB1645850@ls.amr.corp.intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20231117205028.GB1645850@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/2023 4:50 AM, Isaku Yamahata wrote:
> On Wed, Nov 15, 2023 at 02:14:14AM -0500,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> From: Chao Peng <chao.p.peng@linux.intel.com>
>>
>> Switch to KVM_SET_USER_MEMORY_REGION2 when supported by KVM.
>>
>> With KVM_SET_USER_MEMORY_REGION2, QEMU can set up memory region that
>> backend'ed both by hva-based shared memory and guest memfd based private
>> memory.
>>
>> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   accel/kvm/kvm-all.c      | 56 ++++++++++++++++++++++++++++++++++------
>>   accel/kvm/trace-events   |  2 +-
>>   include/sysemu/kvm_int.h |  2 ++
>>   3 files changed, 51 insertions(+), 9 deletions(-)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 9f751d4971f8..69afeb47c9c0 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -293,35 +293,69 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram,
>>   static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, bool new)
>>   {
>>       KVMState *s = kvm_state;
>> -    struct kvm_userspace_memory_region mem;
>> +    struct kvm_userspace_memory_region2 mem;
>> +    static int cap_user_memory2 = -1;
>>       int ret;
>>   
>> +    if (cap_user_memory2 == -1) {
>> +        cap_user_memory2 = kvm_check_extension(s, KVM_CAP_USER_MEMORY2);
>> +    }
>> +
>> +    if (!cap_user_memory2 && slot->guest_memfd >= 0) {
>> +        error_report("%s, KVM doesn't support KVM_CAP_USER_MEMORY2,"
>> +                     " which is required by guest memfd!", __func__);
>> +        exit(1);
>> +    }
>> +
>>       mem.slot = slot->slot | (kml->as_id << 16);
>>       mem.guest_phys_addr = slot->start_addr;
>>       mem.userspace_addr = (unsigned long)slot->ram;
>>       mem.flags = slot->flags;
>> +    mem.guest_memfd = slot->guest_memfd;
>> +    mem.guest_memfd_offset = slot->guest_memfd_offset;
>>   
>>       if (slot->memory_size && !new && (mem.flags ^ slot->old_flags) & KVM_MEM_READONLY) {
>>           /* Set the slot size to 0 before setting the slot to the desired
>>            * value. This is needed based on KVM commit 75d61fbc. */
>>           mem.memory_size = 0;
>> -        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
>> +
>> +        if (cap_user_memory2) {
>> +            ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION2, &mem);
>> +        } else {
>> +            ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
>> +	    }
>>           if (ret < 0) {
>>               goto err;
>>           }
>>       }
>>       mem.memory_size = slot->memory_size;
>> -    ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
>> +    if (cap_user_memory2) {
>> +        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION2, &mem);
>> +    } else {
>> +        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
>> +    }
>>       slot->old_flags = mem.flags;
>>   err:
>>       trace_kvm_set_user_memory(mem.slot >> 16, (uint16_t)mem.slot, mem.flags,
>>                                 mem.guest_phys_addr, mem.memory_size,
>> -                              mem.userspace_addr, ret);
>> +                              mem.userspace_addr, mem.guest_memfd,
>> +                              mem.guest_memfd_offset, ret);
>>       if (ret < 0) {
>> -        error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
>> -                     " start=0x%" PRIx64 ", size=0x%" PRIx64 ": %s",
>> -                     __func__, mem.slot, slot->start_addr,
>> -                     (uint64_t)mem.memory_size, strerror(errno));
>> +        if (cap_user_memory2) {
>> +                error_report("%s: KVM_SET_USER_MEMORY_REGION2 failed, slot=%d,"
>> +                        " start=0x%" PRIx64 ", size=0x%" PRIx64 ","
>> +                        " flags=0x%" PRIx32 ", guest_memfd=%" PRId32 ","
>> +                        " guest_memfd_offset=0x%" PRIx64 ": %s",
>> +                        __func__, mem.slot, slot->start_addr,
>> +                        (uint64_t)mem.memory_size, mem.flags,
>> +                        mem.guest_memfd, (uint64_t)mem.guest_memfd_offset,
>> +                        strerror(errno));
>> +        } else {
>> +                error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
>> +                            " start=0x%" PRIx64 ", size=0x%" PRIx64 ": %s",
>> +                            __func__, mem.slot, slot->start_addr,
>> +                            (uint64_t)mem.memory_size, strerror(errno));
>> +        }
>>       }
>>       return ret;
>>   }
>> @@ -477,6 +511,9 @@ static int kvm_mem_flags(MemoryRegion *mr)
>>       if (readonly && kvm_readonly_mem_allowed) {
>>           flags |= KVM_MEM_READONLY;
>>       }
>> +    if (memory_region_has_guest_memfd(mr)) {
>> +        flags |= KVM_MEM_PRIVATE;
>> +    }
> 
> Nitpick: it was renamed to KVM_MEM_GUEST_MEMFD
> As long as the value is defined to same value, it doesn't matter, though.

thanks for the reminder!

Will update the headers and switch to KVM_MEM_GUEST_MEMFD.

