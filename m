Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E712876B9F6
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 18:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbjHAQwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 12:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbjHAQwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 12:52:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548BD2114
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 09:52:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B75021FD8F;
        Tue,  1 Aug 2023 16:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690908723; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nav+JSW2TNYV1rgTqTHuoBEFYLmex+BMzpCI3MejTQs=;
        b=rlVBQjXjKvwkBJ66iOMLo4RmerdkyWbhrM6yJ4OR31v9Y5GqdqpHGRs3eeThO9laqxDKB/
        lPaYzCqecXvKAUUv9xOwSMxIHx5Nfo6fDEKjetcmhYgYU3qVZbviy5vQFaz0NgohaXDw/y
        q4EL+RzK5s4GWKeg4/KspZJeMtRTxS8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690908723;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nav+JSW2TNYV1rgTqTHuoBEFYLmex+BMzpCI3MejTQs=;
        b=njC0VdBIIogGIdhnPdK6VJi1Is/8iOynnela/pDkmE4L3vlzo2NEVZJNTGCQfYy/Hz0jqi
        /g2y4IDQFPyYSnBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C777E139BD;
        Tue,  1 Aug 2023 16:52:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RqhhLjI4yWT+LgAAMHmgww
        (envelope-from <cfontana@suse.de>); Tue, 01 Aug 2023 16:52:02 +0000
Message-ID: <835a9d0c-4e3a-d2b6-6392-a17f583f0842@suse.de>
Date:   Tue, 1 Aug 2023 18:52:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH 04/19] memory: Introduce
 memory_region_can_be_private()
Content-Language: en-US
From:   Claudio Fontana <cfontana@suse.de>
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-5-xiaoyao.li@intel.com>
 <3a14456d-244c-ce8f-9d1c-8bcdb75de81c@suse.de>
In-Reply-To: <3a14456d-244c-ce8f-9d1c-8bcdb75de81c@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/1/23 18:48, Claudio Fontana wrote:
> On 7/31/23 18:21, Xiaoyao Li wrote:
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>  include/exec/memory.h | 9 +++++++++
>>  softmmu/memory.c      | 5 +++++
>>  2 files changed, 14 insertions(+)
>>
>> diff --git a/include/exec/memory.h b/include/exec/memory.h
>> index 61e31c7b9874..e119d3ce1a1d 100644
>> --- a/include/exec/memory.h
>> +++ b/include/exec/memory.h
>> @@ -1679,6 +1679,15 @@ static inline bool memory_region_is_romd(MemoryRegion *mr)
>>   */
>>  bool memory_region_is_protected(MemoryRegion *mr);
>>  
>> +/**
>> + * memory_region_can_be_private: check whether a memory region can be private
> 
> The name of the function is not particularly informative,
> 
>> + *
>> + * Returns %true if a memory region's ram_block has valid gmem fd assigned.
> 
> but in your comment you describe more accurately what it does, why not make it the function name?
> 
> bool memory_region_has_valid_gmem_fd()


btw can a memory region have an invalid gmem_fd ?

If an invalid gmem_fd is just used to mark whether gmem_fd is present or not,

we could make it just:

bool memory_region_has_gmem_fd()


Thanks,

C

> 
>> + *
>> + * @mr: the memory region being queried
>> + */
>> +bool memory_region_can_be_private(MemoryRegion *mr);
> 
> 
> bool memory_region_has_valid_gmem_fd()
> 
> 
> Thanks,
> 
> C
> 
>> +
>>  /**
>>   * memory_region_get_iommu: check whether a memory region is an iommu
>>   *
>> diff --git a/softmmu/memory.c b/softmmu/memory.c
>> index 4f8f8c0a02e6..336c76ede660 100644
>> --- a/softmmu/memory.c
>> +++ b/softmmu/memory.c
>> @@ -1855,6 +1855,11 @@ bool memory_region_is_protected(MemoryRegion *mr)
>>      return mr->ram && (mr->ram_block->flags & RAM_PROTECTED);
>>  }
>>  
>> +bool memory_region_can_be_private(MemoryRegion *mr)
>> +{
>> +    return mr->ram_block && mr->ram_block->gmem_fd >= 0;
>> +}
>> +
>>  uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
>>  {
>>      uint8_t mask = mr->dirty_log_mask;
> 

