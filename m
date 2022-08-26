Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC5A5A28DC
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 15:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343637AbiHZNxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 09:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243071AbiHZNxT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 09:53:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A053DCFE4
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 06:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661521996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kLq1XXsmS6w4iNG3UsahysBIpHCw6tAbQbv9UDMh8EI=;
        b=Nb+R2IrhEB8kCFYm9BV+gqUlOO55kwcQ8aGrZzrPcdE+rm1UKPo0qQDm+GI+vnu1cm4N7j
        72jWZaLzFfjvbXztdxbtCACY/t8DXs9SqN01Gmeso5W8OOpKPiR9szcr7ZyxvL0fRDcbqt
        OVx2zUJv4YM0AnU79JmrPLzqbrPMyTs=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-439-UGBBH4HrNxiNoeyH4rfFPw-1; Fri, 26 Aug 2022 09:53:14 -0400
X-MC-Unique: UGBBH4HrNxiNoeyH4rfFPw-1
Received: by mail-qv1-f72.google.com with SMTP id d10-20020a0cf6ca000000b00496744bc8e6so1007904qvo.2
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 06:53:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=kLq1XXsmS6w4iNG3UsahysBIpHCw6tAbQbv9UDMh8EI=;
        b=lyrQb7olUo2HeIVfwSAoK2VXuTL6pMv1yhjB4cst7D485lxWN8J78LlDhNEriTF5ux
         6UwTs5MZgcHCsqKEGySJ4WKxYmudQLypfSXmC3GPY2EVSeMO1CpGKAKp7gEd3dpSSeiN
         84kG3FtQ5G9/SSg/6L+0nvKqO1txQSEqKzu3fupU1CVErTuPjhLvUW5K6OAIBjuH9xuB
         fWhgVtrrZdNzy4qmP/YPTdTgtwy49uZmYr6FxQUB1JHB2ntdexoG3wTX41oAmJrwrxlb
         CiVJcp6Vft9MNkBAOA37dszVdRBm9qVRqD9sQ1XHIt4citXQiqeqd1/0gnLNJh86tU4p
         jbNQ==
X-Gm-Message-State: ACgBeo0M6uPfbaVQzRcP0KPiqn2RS5bJgWAK0K2a0qIfdsntOO9iFcGz
        pqk2kr/gxTvAdYBefeBJLaXTreZ+P1lEi8WSocmLLSaMYRpKWE0GGlAs9GLY+BgKXm9/ael+t8s
        8mTkZpEmtm+Be
X-Received: by 2002:a0c:9c87:0:b0:479:606d:670e with SMTP id i7-20020a0c9c87000000b00479606d670emr8149125qvf.127.1661521994326;
        Fri, 26 Aug 2022 06:53:14 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5mIHJ5DY9bd9E9EydQNVN1qd9+4yK82F8LkucHhh+OG6m5uIoTWomyMHurDR+btja+mpR1/Q==
X-Received: by 2002:a0c:9c87:0:b0:479:606d:670e with SMTP id i7-20020a0c9c87000000b00479606d670emr8149111qvf.127.1661521994148;
        Fri, 26 Aug 2022 06:53:14 -0700 (PDT)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id v21-20020a05620a0f1500b006bbdcb3fff7sm1836496qkl.69.2022.08.26.06.53.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 06:53:13 -0700 (PDT)
Message-ID: <e5935ba7-dd60-b914-3b1d-fff4f8c01da3@redhat.com>
Date:   Fri, 26 Aug 2022 15:53:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 1/2] softmmu/memory: add missing begin/commit callback
 calls
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-2-eesposit@redhat.com> <Yv6UVMMX/hHFkGoM@xz-m1.local>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <Yv6UVMMX/hHFkGoM@xz-m1.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 18/08/2022 um 21:34 schrieb Peter Xu:
> On Tue, Aug 16, 2022 at 06:12:49AM -0400, Emanuele Giuseppe Esposito wrote:
>> kvm listeners now need ->commit callback in order to actually send
>> the ioctl to the hypervisor. Therefore, add missing callers around
>> address_space_set_flatview(), which in turn calls
>> address_space_update_topology_pass() which calls ->region_* and
>> ->log_* callbacks.
>>
>> Using MEMORY_LISTENER_CALL_GLOBAL is a little bit an overkill,
>> but it is harmless, considering that other listeners that are not
>> invoked in address_space_update_topology_pass() won't do anything,
>> since they won't have anything to commit.
>>
>> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
>> ---
>>  softmmu/memory.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/softmmu/memory.c b/softmmu/memory.c
>> index 7ba2048836..1afd3f9703 100644
>> --- a/softmmu/memory.c
>> +++ b/softmmu/memory.c
>> @@ -1076,7 +1076,9 @@ static void address_space_update_topology(AddressSpace *as)
>>      if (!g_hash_table_lookup(flat_views, physmr)) {
>>          generate_memory_topology(physmr);
>>      }
>> +    MEMORY_LISTENER_CALL_GLOBAL(begin, Forward);
>>      address_space_set_flatview(as);
>> +    MEMORY_LISTENER_CALL_GLOBAL(commit, Forward);
> 
> Should the pair be with MEMORY_LISTENER_CALL() rather than the global
> version?  Since it's only updating one address space.

Ideally yes, we want to call the memory listener only for this address
space. Practically I don't know how to do it, as MEMORY_LISTENER_CALL 1)
takes additional parameters like memory region section, and 2) calls
_listener->_callback(_listener, _section, ##_args)
whereas begin and commit need (_listener, ##args) only, which is what
MEMORY_LISTENER_CALL_GLOBAL does.

> 
> Besides the perf implication (walking per-as list should be faster than
> walking global memory listener list?), I think it feels broken too since
> we'll call begin() then commit() (with no region_add()/region_del()/..) for
> all the listeners that are not registered against this AS.  IIUC it will
> empty all regions with those listeners?

What do you mean "will empty all regions with those listeners"?
But yes theoretically vhost-vdpa and physmem have commit callbacks that
are independent from whether region_add or other callbacks have been called.
For kvm and probably vhost it would be no problem, since there won't be
any list to iterate on.

I'll implement a new macro to handle this.

Emanuele
> 
> Thanks,
> 

