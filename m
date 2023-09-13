Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9337979E051
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 09:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238389AbjIMHAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 03:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbjIMHAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 03:00:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F961738
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 00:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694588410; x=1726124410;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6ZOTolQaVZtDkdndjG007mer0l08MC5v1of/bXfVgh0=;
  b=kUmjna+/ZYxvuEIx9hcb7VBlgVnK2xWuUVn2qhy/Z9SRmvoQHWzsa2Ml
   0Vor+O08X90BhTLZFgou0jqtD9BrD9JDuYp3fRw9n3g+8WbGoAw479YsY
   1CnzjJGs8Lw+H5LE/mbKrTYzLzAUqdfnYq09ALexcymMCd9sAy0GNykUT
   HKCwsCvCL5ZiCheAOl+raUjHfnO8Iqabs/BbpOocYwwaSMZK34tvN04tQ
   9eCzLo4l2dGRwUwbhicFHis0Feh6IpAAtwb03+uFV3vV9unuoEe5Oo12v
   seGjIdTGvG+wX6BBtn87u3mMZobjvXzyI1ttgf2pyA/0VKj/nRZN+jFHS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="377491296"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="377491296"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 00:00:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="747193142"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="747193142"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.16.87]) ([10.93.16.87])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 00:00:04 -0700
Message-ID: <a19427f8-3432-0918-0e0e-e972de5aa9df@intel.com>
Date:   Wed, 13 Sep 2023 15:00:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.0
Subject: Re: [RFC PATCH 15/19] kvm: handle KVM_EXIT_MEMORY_FAULT
Content-Language: en-US
To:     Xu Yilun <yilun.xu@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-16-xiaoyao.li@intel.com>
 <ZNOqhy1NlGzDA6/F@yilunxu-OptiPlex-7050>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZNOqhy1NlGzDA6/F@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/9/2023 11:02 PM, Xu Yilun wrote:
> On 2023-07-31 at 12:21:57 -0400, Xiaoyao Li wrote:
>> From: Chao Peng <chao.p.peng@linux.intel.com>
>>
>> Currently only KVM_MEMORY_EXIT_FLAG_PRIVATE in flags is valid when
>> KVM_EXIT_MEMORY_FAULT happens. It indicates userspace needs to do
>> the memory conversion on the RAMBlock to turn the memory into desired
>> attribute, i.e., private/shared.
>>
>> Note, KVM_EXIT_MEMORY_FAULT makes sense only when the RAMBlock has
>> gmem memory backend.
>>
>> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   accel/kvm/kvm-all.c | 52 +++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 52 insertions(+)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index f9b5050b8885..72d50b923bf2 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -3040,6 +3040,48 @@ static void kvm_eat_signals(CPUState *cpu)
>>       } while (sigismember(&chkset, SIG_IPI));
>>   }
>>   
>> +static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>> +{
>> +    MemoryRegionSection section;
>> +    void *addr;
>> +    RAMBlock *rb;
>> +    ram_addr_t offset;
>> +    int ret = -1;
>> +
>> +    section = memory_region_find(get_system_memory(), start, size);
>> +    if (!section.mr) {
>> +        return ret;
>> +    }
>> +
>> +    if (memory_region_can_be_private(section.mr)) {
>> +        if (to_private) {
>> +            ret = kvm_set_memory_attributes_private(start, size);
>> +        } else {
>> +            ret = kvm_set_memory_attributes_shared(start, size);
>> +        }
>> +
>> +        if (ret) {
>> +            return ret;
> 
> Should we unref the memory region before return?

Thanks for catching this!

> Thanks,
> Yilun
> 
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
>> +        warn_report("Convert non guest-memfd backed memory region (0x%"HWADDR_PRIx" ,+ 0x%"HWADDR_PRIx") to %s",
>> +                    start, size, to_private ? "private" : "shared");
>> +    }
>> +
>> +    memory_region_unref(section.mr);
>> +    return ret;
>> +}

