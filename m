Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D12786A33
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 10:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240491AbjHXIe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 04:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240641AbjHXIe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 04:34:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F031724
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 01:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692866094; x=1724402094;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+YaBz0JbTkdfg50z18lO5jNRK2nQ1KYA+FqnKCx2caU=;
  b=DKEMcOZ0G5AEVS6jxFCapAVTTWaYGoufuEp3Swr6YiHieI4T+TO/JbdW
   KHkPKM/WQSVaPQ1f4WazpcuW1UA5pYqe1iMJwEy+l8G9jGDMi350zCxWz
   SMkXXGNRzwSNFfTQKjVxnR4LCndtGhhs++iOmkIVkfR7oZR2LVsYuReLO
   78+2STXKmBFeGJf6WG1k/EfP5k+eXJHI91paltOTCniOBuL6lF6C+HVhr
   /ijSxWg6gDqhHTsoKVyCjEu3I9VfFicQLUPAvfwNZnm+KYMmpbrYrAzMz
   UX+xVHFEt8WXdhTVtoyGHIySPy/wLx00iybQBdle81oHUi1TaMRVC88B0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="359365469"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="359365469"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 01:34:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="802465560"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="802465560"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.16.81]) ([10.93.16.81])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 01:34:48 -0700
Message-ID: <5db417d4-473c-06c4-d760-70516065aea5@intel.com>
Date:   Thu, 24 Aug 2023 16:34:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 43/58] i386/tdx: setup a timer for the qio channel
Content-Language: en-US
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-44-xiaoyao.li@intel.com>
 <7629706c-0b7e-a8d5-ed52-21c6eeecd184@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <7629706c-0b7e-a8d5-ed52-21c6eeecd184@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/24/2023 3:21 PM, Chenyi Qiang wrote:
> 
> 
> On 8/18/2023 5:50 PM, Xiaoyao Li wrote:
>> From: Chenyi Qiang <chenyi.qiang@intel.com>
>>
>> To avoid no response from QGS server, setup a timer for the transaction. If
>> timeout, make it an error and interrupt guest. Define the threshold of time
>> to 30s at present, maybe change to other value if not appropriate.
>>
>> Extract the common cleanup code to make it more clear.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   target/i386/kvm/tdx.c | 151 ++++++++++++++++++++++++------------------
>>   1 file changed, 85 insertions(+), 66 deletions(-)
>>
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 3cb2163a0335..fa658ce1f2e4 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -1002,6 +1002,7 @@ struct tdx_get_quote_task {
>>       struct tdx_get_quote_header hdr;
>>       int event_notify_interrupt;
>>       QIOChannelSocket *ioc;
>> +    QEMUTimer timer;
>>   };
>>   
>>   struct x86_msi {
>> @@ -1084,13 +1085,48 @@ static void tdx_td_notify(struct tdx_get_quote_task *t)
>>       }
>>   }
>>   
>> +static void tdx_getquote_task_cleanup(struct tdx_get_quote_task *t, bool outlen_overflow)
>> +{
>> +    MachineState *ms;
>> +    TdxGuest *tdx;
>> +
>> +    if (t->hdr.error_code != cpu_to_le64(TDX_VP_GET_QUOTE_SUCCESS) && !outlen_overflow) {
>> +        t->hdr.out_len = cpu_to_le32(0);
>> +    }
>> +
>> +    /* Publish the response contents before marking this request completed. */
>> +    smp_wmb();
>> +    if (address_space_write(
>> +            &address_space_memory, t->gpa,
>> +            MEMTXATTRS_UNSPECIFIED, &t->hdr, sizeof(t->hdr)) != MEMTX_OK) {
>> +        error_report("TDX: failed to update GetQuote header.");
>> +    }
>> +    tdx_td_notify(t);
>> +
>> +    if (t->ioc->fd > 0) {
>> +        qemu_set_fd_handler(t->ioc->fd, NULL, NULL, NULL);
>> +    }
>> +    qio_channel_close(QIO_CHANNEL(t->ioc), NULL);
>> +    object_unref(OBJECT(t->ioc));
>> +    timer_del(&t->timer);
> 
> Xiaoyao, I guess you missed a bug fix patch here as t->timer could be
> uninitialized and then timer_del() will cause segv.

Thanks for the reminding.
I'll update this patch to include the fix.

Thanks,
-Xiaoyao

>> +    g_free(t->out_data);
>> +    g_free(t);
>> +
>> +    /* Maintain the number of in-flight requests. */
>> +    ms = MACHINE(qdev_get_machine());
>> +    tdx = TDX_GUEST(ms->cgs);
>> +    qemu_mutex_lock(&tdx->lock);
>> +    tdx->quote_generation_num--;
>> +    qemu_mutex_unlock(&tdx->lock);
>> +}
>> +
> 

