Return-Path: <kvm+bounces-12307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BC6C8812A7
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 14:49:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2631E1F23909
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 13:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D004242059;
	Wed, 20 Mar 2024 13:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gURRC+ma"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9273740BF9
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 13:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710942567; cv=none; b=BU31CX5DkUzF9PLjOSGMIrM2onxzIE+d7SL/7qMcJvv1zy8rjncoPobLKHv7c9NEOPG9qAYFOPRM42OIgm74/t9HJcPx1bkCd5E1k5S9cbChuPhRr0ao4OmcnFo1xhRg83eJF5M8TBiQADiw5pnYOu6cqpxrr6aAGCb6QhuGp48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710942567; c=relaxed/simple;
	bh=2PyOioHoVuIYBj44Mj1+uT2DsWCfdpZ3lXhTE0B8L9A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VjXmvyJieQ53OzKamcCnccFOZXNaPMi8npj1N2Z/ys4KYXTf2ZcIGjqzLkA88JIM/37GF2sFgns3CzWyj8J6vmqVtXRFaFQoLGq0PJR0Fv84drb5rf2X2Jt1DzyHgaW0VoOWXGGy4a4lEBoTsW8BNzwVumIhA0tzyRXVLvSeHDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gURRC+ma; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710942565; x=1742478565;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2PyOioHoVuIYBj44Mj1+uT2DsWCfdpZ3lXhTE0B8L9A=;
  b=gURRC+maWbp+Sh5HnB8cxPRSIvc1VgHJfcjHENkYd2+QCG/hnOp1cH5q
   cc0PIzIAUABT69JZM7ZgwAjNS7mF81T2z/RqnhXGLwvI/J+3J0+EQRL7a
   p7PBpUvJxKYXN06yE7/nOfraqVOYDSOuUGWorvSBptkGkk1EtWJsJ8frQ
   JeL9nkOdPBeCw0tOp6gp57Ah9ZoV71GvIf1KdgqFjpYDm+3ayvnJ1JBTh
   zfM9fg48N38Qtifyzc7HAwwIGoYKAQV+n8JPaYKOVahI0ihTRZvvP5McU
   6XdXiJMP26fXjdfsXzgsmlk50za4yz9Zz2lw72zif0AgwQ1ISE5yv3OEJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="9680709"
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="9680709"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 06:49:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="45137674"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 06:49:18 -0700
Message-ID: <8a7f5bf5-9a4e-4e03-9e43-bbab53efefe9@intel.com>
Date: Wed, 20 Mar 2024 21:49:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/65] kvm: handle KVM_EXIT_MEMORY_FAULT
Content-Language: en-US
To: "Wang, Lei" <lei4.wang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org,
 Michael Roth <michael.roth@amd.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-9-xiaoyao.li@intel.com>
 <3d2655c7-74ad-49d9-a527-7648f8e565da@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <3d2655c7-74ad-49d9-a527-7648f8e565da@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/19/2024 10:14 AM, Wang, Lei wrote:
> On 2/29/2024 14:36, Xiaoyao Li wrote:
>> From: Chao Peng <chao.p.peng@linux.intel.com>
>>
>> When geeting KVM_EXIT_MEMORY_FAULT exit, it indicates userspace needs to
>> do the memory conversion on the RAMBlock to turn the memory into desired
>> attribute, i.e., private/shared.
>>
>> Currently only KVM_MEMORY_EXIT_FLAG_PRIVATE in flags is valid when
>> KVM_EXIT_MEMORY_FAULT happens.
>>
>> Note, KVM_EXIT_MEMORY_FAULT makes sense only when the RAMBlock has
>> guest_memfd memory backend.
>>
>> Note, KVM_EXIT_MEMORY_FAULT returns with -EFAULT, so special handling is
>> added.
>>
>> When page is converted from shared to private, the original shared
>> memory can be discarded via ram_block_discard_range(). Note, shared
>> memory can be discarded only when it's not back'ed by hugetlb because
>> hugetlb is supposed to be pre-allocated and no need for discarding.
>>
>> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
>> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> ---
>> Changes in v4:
>> - open-coded ram_block_discard logic;
>> - change warn_report() to error_report(); (Daniel)
>> ---
>>   accel/kvm/kvm-all.c | 94 ++++++++++++++++++++++++++++++++++++++++-----
>>   1 file changed, 84 insertions(+), 10 deletions(-)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 70d482a2c936..87e4275932a7 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -2903,6 +2903,68 @@ static void kvm_eat_signals(CPUState *cpu)
>>       } while (sigismember(&chkset, SIG_IPI));
>>   }
>>   
>> +static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>> +{
>> +    MemoryRegionSection section;
>> +    ram_addr_t offset;
>> +    MemoryRegion *mr;
>> +    RAMBlock *rb;
>> +    void *addr;
>> +    int ret = -1;
>> +
>> +    if (!QEMU_PTR_IS_ALIGNED(start, qemu_host_page_size) ||
>> +        !QEMU_PTR_IS_ALIGNED(size, qemu_host_page_size)) {
>> +        return -1;
>> +    }
>> +
>> +    if (!size) {
>> +        return -1;
>> +    }
>> +
>> +    section = memory_region_find(get_system_memory(), start, size);
>> +    mr = section.mr;
>> +    if (!mr) {
>> +        return -1;
>> +    }
>> +
>> +    if (memory_region_has_guest_memfd(mr)) {
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
>> +        addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
>> +        rb = qemu_ram_block_from_host(addr, false, &offset);
>> +
>> +        if (to_private) {
>> +            if (rb->page_size != qemu_host_page_size) {
>> +                /*
>> +                * shared memory is back'ed by  hugetlb, which is supposed to be
>> +                * pre-allocated and doesn't need to be discarded
>> +                */
> 
> Nit: comment indentation is broken here.
> 
>> +                return 0;
>> +            } else {
>> +                ret = ram_block_discard_range(rb, offset, size);
>> +            }
>> +        } else {
>> +            ret = ram_block_discard_guest_memfd_range(rb, offset, size);
>> +        }
>> +    } else {
>> +        error_report("Convert non guest_memfd backed memory region "
>> +                    "(0x%"HWADDR_PRIx" ,+ 0x%"HWADDR_PRIx") to %s",
> 
> Same as above.
> 

Fixed.

thanks!


