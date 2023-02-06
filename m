Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D02568BD86
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 14:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjBFNKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 08:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjBFNKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 08:10:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66988144B6
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 05:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675689004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0F4n6oRN9d0FXsy2UfnG+aJFu5pdD1XrdXOjIiNSqM4=;
        b=hFOl7Fg3ePlgSu9RmPzs5YQxIQbMDuAbd/vVi9OnXWmO7zzZ5RrKOTJ6yCfOTTMiBinu4T
        85aysromAAFrevI2vFYXc6kzvl4gbfVEnsGPurudGQFZwEeEoMii8Y90/0l6iKxMtc+CP0
        p6qu1seziko4KAkV7UPAjmdwb1cU3j0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-452-Tqh6h33gPheVKj_eu7qPCQ-1; Mon, 06 Feb 2023 08:10:03 -0500
X-MC-Unique: Tqh6h33gPheVKj_eu7qPCQ-1
Received: by mail-qv1-f71.google.com with SMTP id l6-20020ad44446000000b00537721bfd2dso5801313qvt.11
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 05:10:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0F4n6oRN9d0FXsy2UfnG+aJFu5pdD1XrdXOjIiNSqM4=;
        b=IN/Yaiu1pz8dAE/3pfwHdoAs9oJpYmV8IXjqOGzp/Q9wl9MgIKErjGonVve//LNMvS
         peg2BfjevzgBjsq0klit3nkBJLgQ4EeMUhCKtebD91gi4zbveKQUUnSoVB4Nx0apK1Vx
         mfhg0RKn9fWouFNOaqJ16uwW1+hqL6MbimX3BJEdTu1/h0gZbWPEyDNhQpjCxjvt65vU
         Jgt5tzGFMvO5degjGcwVlY8kdzr/VQ3uqzxFs2qDhb2nWf9MnCj4TpBDbrbcKh83I9y5
         j7hZvs8tr8M0MUvJJfy0JqIINUrWRfLSeog1Ezo/dwH+T8/iTMIP+YAqUr+HOxyqZbdF
         MXBQ==
X-Gm-Message-State: AO0yUKVryUpbEhHEg+jmlHBl9aE+bk65Yui79+qyWgKVsLjKKpaS0qnJ
        CdTPzHt6ifn2Hvh+WJjt6vYlKk0W8VeoRuHzmjW0bz0mczN3F90KKfNK+5fskuhYPABr5JYiAI4
        6cTnPc0w5S5zQ
X-Received: by 2002:ac8:59cb:0:b0:3b8:4951:57b7 with SMTP id f11-20020ac859cb000000b003b8495157b7mr34547879qtf.20.1675689002719;
        Mon, 06 Feb 2023 05:10:02 -0800 (PST)
X-Google-Smtp-Source: AK7set9zL72cFuFVsx2BUC3H2ZLsTV1hGvBPE85qDtnjVy85ay2pdSlUopi9QLkabRgin6oMR+J9gQ==
X-Received: by 2002:ac8:59cb:0:b0:3b8:4951:57b7 with SMTP id f11-20020ac859cb000000b003b8495157b7mr34547838qtf.20.1675689002426;
        Mon, 06 Feb 2023 05:10:02 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-71.web.vodafone.de. [109.43.177.71])
        by smtp.gmail.com with ESMTPSA id d8-20020a05622a100800b003b643951117sm7377910qte.38.2023.02.06.05.09.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 05:10:01 -0800 (PST)
Message-ID: <e1828071-551a-b5cb-8da5-cea91f075548@redhat.com>
Date:   Mon, 6 Feb 2023 14:09:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v15 09/11] machine: adding s390 topology to query-cpu-fast
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        armbru@redhat.com, Michael Roth <michael.roth@amd.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Cc:     qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-10-pmorel@linux.ibm.com>
 <a7a235d5-4ded-b83d-dcb6-2cf81ad5f283@redhat.com>
 <Y+D3PH0EkUPshIMO@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <Y+D3PH0EkUPshIMO@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/02/2023 13.49, Daniel P. Berrangé wrote:
> On Mon, Feb 06, 2023 at 01:41:44PM +0100, Thomas Huth wrote:
>> On 01/02/2023 14.20, Pierre Morel wrote:
>>> S390x provides two more topology containers above the sockets,
>>> books and drawers.
>>>
>>> Let's add these CPU attributes to the QAPI command query-cpu-fast.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>    qapi/machine.json          | 13 ++++++++++---
>>>    hw/core/machine-qmp-cmds.c |  2 ++
>>>    2 files changed, 12 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/qapi/machine.json b/qapi/machine.json
>>> index 3036117059..e36c39e258 100644
>>> --- a/qapi/machine.json
>>> +++ b/qapi/machine.json
>>> @@ -53,11 +53,18 @@
>>>    #
>>>    # Additional information about a virtual S390 CPU
>>>    #
>>> -# @cpu-state: the virtual CPU's state
>>> +# @cpu-state: the virtual CPU's state (since 2.12)
>>> +# @dedicated: the virtual CPU's dedication (since 8.0)
>>> +# @polarity: the virtual CPU's polarity (since 8.0)
>>>    #
>>>    # Since: 2.12
>>>    ##
>>> -{ 'struct': 'CpuInfoS390', 'data': { 'cpu-state': 'CpuS390State' } }
>>> +{ 'struct': 'CpuInfoS390',
>>> +    'data': { 'cpu-state': 'CpuS390State',
>>> +              'dedicated': 'bool',
>>> +              'polarity': 'int'
>>
>> I think it would also be better to mark the new fields as optional and only
>> return them if the guest has the topology enabled, to avoid confusing
>> clients that were written before this change.
> 
> FWIW, I would say that the general expectation of QMP clients is that
> they must *always* expect new fields to appear in dicts that are
> returned in QMP replies. We add new fields at will on a frequent basis.

Did we change our policy here? I slightly remember I've been told 
differently in the past ... but I can't recall where this was, it's 
certainly been a while.

So a question to the QAPI maintainers: What's the preferred handling for new 
fields nowadays in such situations?

  Thomas

