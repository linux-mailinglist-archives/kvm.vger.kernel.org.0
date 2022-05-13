Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EE8525914
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 02:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359806AbiEMArJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 20:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359812AbiEMArD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 20:47:03 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0D066680
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 17:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652402813; x=1683938813;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5c2e/TArcdBeEGS+Y2rMq8nx3fXkMZ3M8isdb3HBWSg=;
  b=JN2RKz9rCORproE/aPcs4LDiE3BrLkdeBXwOnA+6BOiuTiIXvNIUkv+7
   Ek+HP8lZWyB6vu7xJDha31Tpn40GhT7hqVXdI9itnKW3Y4yPTasBJgamP
   rs7viWj4JOKPBJ/v0NQZRftozPUNF9Mp4r2/gYEkWHEqAPZhqYwG0wsiT
   uBRX0MxxQ9KtCYSq2nymFAnTBW8SlTT01r39TplzKj1Tfq7lnlo7he9FS
   JGRTy4qaX2uMsddByS0USGpXmIY33XXGVJbgk58GdfUl2tYOJPYmp9HlQ
   m3VFJzOlWrGrhTfnR90RLGjF/YnmQZRwWazDP9MHvcES/DZ5qsXVG0Dx3
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="252223269"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="252223269"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 17:46:53 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="594955799"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.175.214]) ([10.249.175.214])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 17:46:47 -0700
Message-ID: <5c5d9722-6880-4b8e-3293-ff4a8c295b53@intel.com>
Date:   Fri, 13 May 2022 08:46:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [RFC PATCH v4 24/36] i386/tdx: Add TDVF memory via
 KVM_TDX_INIT_MEM_REGION
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-25-xiaoyao.li@intel.com>
 <20220512183423.GI2789321@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220512183423.GI2789321@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/13/2022 2:34 AM, Isaku Yamahata wrote:
> On Thu, May 12, 2022 at 11:17:51AM +0800,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> TDVF firmware (CODE and VARS) needs to be added/copied to TD's private
>> memory via KVM_TDX_INIT_MEM_REGION, as well as TD HOB and TEMP memory.
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   target/i386/kvm/tdx.c | 24 ++++++++++++++++++++++++
>>   1 file changed, 24 insertions(+)
>>
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 3e18ace90bf7..567ee12e88f0 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -240,6 +240,7 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
>>   {
>>       TdxFirmware *tdvf = &tdx_guest->tdvf;
>>       TdxFirmwareEntry *entry;
>> +    int r;
>>   
>>       tdx_init_ram_entries();
>>   
>> @@ -265,6 +266,29 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
>>             sizeof(TdxRamEntry), &tdx_ram_entry_compare);
>>   
>>       tdvf_hob_create(tdx_guest, tdx_get_hob_entry(tdx_guest));
>> +
>> +    for_each_tdx_fw_entry(tdvf, entry) {
>> +        struct kvm_tdx_init_mem_region mem_region = {
>> +            .source_addr = (__u64)entry->mem_ptr,
>> +            .gpa = entry->address,
>> +            .nr_pages = entry->size / 4096,
>> +        };
>> +
>> +        __u32 metadata = entry->attributes & TDVF_SECTION_ATTRIBUTES_MR_EXTEND ?
>> +                         KVM_TDX_MEASURE_MEMORY_REGION : 0;
> 
> Please use flags instead of metadata.

Sure. Will change it.

> 
>> +        r = tdx_vm_ioctl(KVM_TDX_INIT_MEM_REGION, metadata, &mem_region);
>> +        if (r < 0) {
>> +             error_report("KVM_TDX_INIT_MEM_REGION failed %s", strerror(-r));
>> +             exit(1);
>> +        }
>> +
>> +        if (entry->type == TDVF_SECTION_TYPE_TD_HOB ||
>> +            entry->type == TDVF_SECTION_TYPE_TEMP_MEM) {
>> +            qemu_ram_munmap(-1, entry->mem_ptr, entry->size);
>> +            entry->mem_ptr = NULL;
>> +        }
>> +    }
>>   }
>>   
>>   static Notifier tdx_machine_done_notify = {
>> -- 
>> 2.27.0
>>
>>
> 

