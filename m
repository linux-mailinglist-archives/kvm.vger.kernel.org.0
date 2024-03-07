Return-Path: <kvm+bounces-11268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76BA0874846
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 07:43:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B0291C22546
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 06:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F39D71CD21;
	Thu,  7 Mar 2024 06:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MzyHFZ6i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9931CD304
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 06:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709793802; cv=none; b=fJd5c85/WY0VRExbG17k2arFZ4xIpGsW44tpd/ChLeHcDCUlMtL4JPHPq8mda5/Nzvh2nEh0mq335rfKBMUo6qDpZmZxcpFvnVU5cym7TseFWGa+20ASVBfMT0Iho7bvYDTaWEB+EtqXuihpzGn3Ij2xd/vt+7iCCVOo1hkb/5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709793802; c=relaxed/simple;
	bh=hFIJYsPW+KvztSq64GkfUwQLRzmppAvlEm+IcbKEk7c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JhKEAT/LupR8X9DzuzDlNaFTJxmq+Jmli9l183/BIjtCfbdzEvQjWZn57STBPCFoy4sKLJ/uAnf2Ym1nErAYmelK71TA1GWK3yPcH8u1wQf4rzjMR57kxRp5INU8NcgxGznDrgPh9zHG8hYuE0bkRJocBXyoekT/HEYjm2UNo5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MzyHFZ6i; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709793800; x=1741329800;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hFIJYsPW+KvztSq64GkfUwQLRzmppAvlEm+IcbKEk7c=;
  b=MzyHFZ6iDyaPEe/iRobABTYLbe7k3z0khGp4uX2r67TDFvPc3vR0uSaT
   3Ti5PCqzuUP1c3WtqfqO3wd/zi7E4lTzv+JQCrvlPl38svhWmhUHDy5ci
   ve1So2fQ8tSGGD/E6W2a8uw9Ih6rNeZNkb9wlATQw4l9ptAWKUbvADUlL
   zVnYQFU/SGKwpDMYFIvI3sfu8UDbeB2rTxTRsgxGwiOptfNPwmp4/qx+u
   AOVZhItWP6rZC5e4WWpRrG9KncgyOuhzv8GXqGMovABLd1eLlWS+bVYKH
   nXU4Glb2N4lLR+u4dK4VpdrUYxGo53jIUxem3Y30jguWRMmAHldHzdYdY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4617234"
X-IronPort-AV: E=Sophos;i="6.06,210,1705392000"; 
   d="scan'208";a="4617234"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 22:43:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,210,1705392000"; 
   d="scan'208";a="9932222"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 22:43:13 -0800
Message-ID: <135add74-18c2-4137-92b3-63ae457c9080@intel.com>
Date: Thu, 7 Mar 2024 14:43:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/65] kvm: handle KVM_EXIT_MEMORY_FAULT
Content-Language: en-US
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand
 <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 Michael Roth <michael.roth@amd.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>,
 isaku.yamahata@intel.com
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-9-xiaoyao.li@intel.com>
 <20240305091049.GA368614@ls.amr.corp.intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240305091049.GA368614@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/2024 5:10 PM, Isaku Yamahata wrote:
> On Thu, Feb 29, 2024 at 01:36:29AM -0500,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
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
>> +                return 0;
> 
> The reference count leaks. Add memory_region_unref() is needed.

thanks for catching it. Will fix it in next version.

> Otherwise looks good to me.
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>


