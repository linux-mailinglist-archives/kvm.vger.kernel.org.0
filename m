Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B977079E050
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 08:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238367AbjIMG7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 02:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbjIMG7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 02:59:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493F0173E
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 23:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694588386; x=1726124386;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=C6mQa9xWJ5rj5rAaxGCawIPJlfT6aTwLFeDPxzx9A+k=;
  b=GfvrHMHpuNPx7PCrJZikuDd9VRhSPZcRUN8lY4VEfZ+UPgsc560eodrp
   J4zqRnw4mbtqnQ9vegsuFHMMYcSZAoo0d4t8Z1vZXfUdQ14WUlzG0dHQB
   FbuHYAzyNYM7Gb3sjziONIkwiYDoSl0UYnXAgqP3uInqIUBn8gcw0ypUw
   nVK/xkeIZiJH5fLkGcHPMfYC7UVXTF2kKk4/GxpBYSeGX3RnSnVgpWd3E
   g594cI6Ernj1TjRvoIsn87F/yr6kiYWr05YVQF3SJllAw19WaqMKjIFwL
   tahvOk+EKpNi3TUcsYpo/9FNFWvLe61PmTZKNFGM6YHI1a7XcFQnW3M7i
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="377491110"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="377491110"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 23:59:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="747192882"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="747192882"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.16.87]) ([10.93.16.87])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 23:59:26 -0700
Message-ID: <fc235a15-53be-033a-1281-ff94ecb8c269@intel.com>
Date:   Wed, 13 Sep 2023 14:59:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.0
Subject: Re: [RFC PATCH 15/19] kvm: handle KVM_EXIT_MEMORY_FAULT
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
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
        Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-16-xiaoyao.li@intel.com>
 <20230802222545.GC1807130@ls.amr.corp.intel.com>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230802222545.GC1807130@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/2023 6:25 AM, Isaku Yamahata wrote:
> On Mon, Jul 31, 2023 at 12:21:57PM -0400,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
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
>> +        }
>> +
>> +        addr = memory_region_get_ram_ptr(section.mr) +
>> +               section.offset_within_region;
>> +        rb = qemu_ram_block_from_host(addr, false, &offset);
> 
> Here we have already section. section.mr->ram_block.  We don't have to
> scan the existing RAMBlocks.

But we don't have the @offset, do we?

> Except that, looks good to me.
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>

