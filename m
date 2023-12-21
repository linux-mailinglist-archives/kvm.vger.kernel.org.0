Return-Path: <kvm+bounces-4979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 62ED181AEB3
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 07:18:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1754E2860AE
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 06:18:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64D8EB669;
	Thu, 21 Dec 2023 06:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RB5Da6tH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0094AD5E
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 06:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703139501; x=1734675501;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BsYBvZXpNmDxnhkK3p7HJV3JL+6lmwWO8f24hANixYY=;
  b=RB5Da6tH5gV59ZhWNe1aS4tPNO79pTMDTQTYYKy/+yfxtErpMIsb4CvF
   fSpTnEuen4ulIvTO1tA57ALcmP51oF0NbQfgKG4Gl/+qWihYfT2ICu1iW
   aRABeoi4rU1Zlp69scKoZ0aaEhk/spnZtqmIKbJBu+K2l2r2nXfmYqDjI
   1Kza3E2to0YMltvWJGqi7yefMfe3ArHbd4NlYOLW8t5EkQ5/jH7vwcf7P
   ZCF4Mv1xVBNyP7Zy7UqlGfq4ymrvn7uZ4Z+Hj2lH2iYbgA15glODyFcS7
   iY+c74RcdKQBCHnkwb9RuyfEjoDBwM3RugA0/YMQy1nvK2J3Fds6tyqFl
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="399757489"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="399757489"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2023 22:18:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="810867965"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="810867965"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.12.199]) ([10.93.12.199])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2023 22:18:14 -0800
Message-ID: <f5f21e2d-b462-4402-b728-46ab4124efb8@intel.com>
Date: Thu, 21 Dec 2023 14:18:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/70] physmem: Introduce ram_block_convert_range() for
 page conversion
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
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
 <20231115071519.2864957-10-xiaoyao.li@intel.com>
 <20231117210304.GC1645850@ls.amr.corp.intel.com>
 <8f20d060-38fe-49d7-8fea-fe665c3c6c78@intel.com>
 <0dc03b42-23c3-4e02-868e-289b3fedf6af@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <0dc03b42-23c3-4e02-868e-289b3fedf6af@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/8/2023 7:52 PM, David Hildenbrand wrote:
> On 08.12.23 08:59, Xiaoyao Li wrote:
>> On 11/18/2023 5:03 AM, Isaku Yamahata wrote:
>>> On Wed, Nov 15, 2023 at 02:14:18AM -0500,
>>> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>>
>>>> It's used for discarding opposite memory after memory conversion, for
>>>> confidential guest.
>>>>
>>>> When page is converted from shared to private, the original shared
>>>> memory can be discarded via ram_block_discard_range();
>>>>
>>>> When page is converted from private to shared, the original private
>>>> memory is back'ed by guest_memfd. Introduce
>>>> ram_block_discard_guest_memfd_range() for discarding memory in
>>>> guest_memfd.
>>>>
>>>> Originally-from: Isaku Yamahata <isaku.yamahata@intel.com>
>>>> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> ---
>>>>    include/exec/cpu-common.h |  2 ++
>>>>    system/physmem.c          | 50 
>>>> +++++++++++++++++++++++++++++++++++++++
>>>>    2 files changed, 52 insertions(+)
>>>>
>>>> diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
>>>> index 41115d891940..de728a18eef2 100644
>>>> --- a/include/exec/cpu-common.h
>>>> +++ b/include/exec/cpu-common.h
>>>> @@ -175,6 +175,8 @@ typedef int (RAMBlockIterFunc)(RAMBlock *rb, 
>>>> void *opaque);
>>>>    int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque);
>>>>    int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t 
>>>> length);
>>>> +int ram_block_convert_range(RAMBlock *rb, uint64_t start, size_t 
>>>> length,
>>>> +                            bool shared_to_private);
>>>>    #endif
>>>> diff --git a/system/physmem.c b/system/physmem.c
>>>> index ddfecddefcd6..cd6008fa09ad 100644
>>>> --- a/system/physmem.c
>>>> +++ b/system/physmem.c
>>>> @@ -3641,6 +3641,29 @@ err:
>>>>        return ret;
>>>>    }
>>>> +static int ram_block_discard_guest_memfd_range(RAMBlock *rb, 
>>>> uint64_t start,
>>>> +                                               size_t length)
>>>> +{
>>>> +    int ret = -1;
>>>> +
>>>> +#ifdef CONFIG_FALLOCATE_PUNCH_HOLE
>>>> +    ret = fallocate(rb->guest_memfd, FALLOC_FL_PUNCH_HOLE | 
>>>> FALLOC_FL_KEEP_SIZE,
>>>> +                    start, length);
>>>> +
>>>> +    if (ret) {
>>>> +        ret = -errno;
>>>> +        error_report("%s: Failed to fallocate %s:%" PRIx64 " +%zx 
>>>> (%d)",
>>>> +                     __func__, rb->idstr, start, length, ret);
>>>> +    }
>>>> +#else
>>>> +    ret = -ENOSYS;
>>>> +    error_report("%s: fallocate not available %s:%" PRIx64 " +%zx 
>>>> (%d)",
>>>> +                 __func__, rb->idstr, start, length, ret);
>>>> +#endif
>>>> +
>>>> +    return ret;
>>>> +}
>>>> +
>>>>    bool ramblock_is_pmem(RAMBlock *rb)
>>>>    {
>>>>        return rb->flags & RAM_PMEM;
>>>> @@ -3828,3 +3851,30 @@ bool ram_block_discard_is_required(void)
>>>>        return qatomic_read(&ram_block_discard_required_cnt) ||
>>>>               
>>>> qatomic_read(&ram_block_coordinated_discard_required_cnt);
>>>>    }
>>>> +
>>>> +int ram_block_convert_range(RAMBlock *rb, uint64_t start, size_t 
>>>> length,
>>>> +                            bool shared_to_private)
>>>> +{
>>>> +    if (!rb || rb->guest_memfd < 0) {
>>>> +        return -1;
>>>> +    }
>>>> +
>>>> +    if (!QEMU_PTR_IS_ALIGNED(start, qemu_host_page_size) ||
>>>> +        !QEMU_PTR_IS_ALIGNED(length, qemu_host_page_size)) {
>>>> +        return -1;
>>>> +    }
>>>> +
>>>> +    if (!length) {
>>>> +        return -1;
>>>> +    }
>>>> +
>>>> +    if (start + length > rb->max_length) {
>>>> +        return -1;
>>>> +    }
>>>> +
>>>> +    if (shared_to_private) {
>>>> +        return ram_block_discard_range(rb, start, length);
>>>> +    } else {
>>>> +        return ram_block_discard_guest_memfd_range(rb, start, length);
>>>> +    }
>>>> +}
>>>
>>> Originally this function issued KVM_SET_MEMORY_ATTRIBUTES, the 
>>> function name
>>> mad sense. But now it doesn't, and it issues only punch hole. We 
>>> should rename
>>> it to represent what it actually does. discard_range?
>>
>> ram_block_discard_range() already exists for non-guest-memfd memory 
>> discard.
>>
>> I cannot come up with a proper name. e.g.,
>> ram_block_discard_opposite_range() while *opposite* seems unclear.
>>
>> Do you have any better idea?
> 
> Having some indication that this is about "guest_memfd" back and forth 
> switching/conversion will make sense. But I'm also not able to come up 
> with a better name.
> 
> Maybe have two functions:
> 
> ram_block_activate_guest_memfd_range
> ram_block_deactivate_guest_memfd_range
> 

finally, I decide to drop this function and expose 
ram_block_discard_guest_memfd_range() instead. So caller can call the 
ram_block_discard_*() on its own.

