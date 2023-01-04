Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F3865D384
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 13:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbjADM6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 07:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234014AbjADM6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 07:58:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2F01E3E5
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 04:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672837023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=98JNIQy8FeRzxONlKyvSI5Ze/+IGOFmKeu3MLQNRHHs=;
        b=M/Z3ODjZAWGhIRAd+KDB7kgMo72Gcj2eLa8CndIdGf6dy6kGuLoY+9HjL/HbFp2/CZCYM8
        JnCVCOMBPbG3SzxNLiOUfLOCHjfr6JvFUmhMslFxCx7h1WWAZjRvKRfB19e32Hrh8mmB23
        ZrxbZdXf5gn0EY4tXOiWukJk1+l0gsg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-646-2FF6sDY-PYKaaXIQH-uToQ-1; Wed, 04 Jan 2023 07:57:01 -0500
X-MC-Unique: 2FF6sDY-PYKaaXIQH-uToQ-1
Received: by mail-wr1-f69.google.com with SMTP id w20-20020adf8bd4000000b00272d0029f18so3710611wra.7
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 04:57:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=98JNIQy8FeRzxONlKyvSI5Ze/+IGOFmKeu3MLQNRHHs=;
        b=lCzSIjmk8s+2Xeayy8T37JcNIERzKqs5950lYuyMUwlXbMhQpasJ7Z0g5x0tVSAxHo
         l4IIxd2vnYgxiVL6C39tSGvSjfdM2wMeh7634ibPjTdz3J7oBJh91p+fSWBAkOPesmwe
         HaPVtrPGtxt3CeHFToT2R8LINkpHkZ+KJ5+IUG2Hi+mpeozq/4RQD2Ts/J3e2QNLvpEH
         3DPvm6mCDEtoQb1C2jVm3UB5b9oPs3MSDK+5cV+zFwpqr72pmlQPBACt1XEaE7cHx5PJ
         xVdPijxNtriuA5BMkZGsq5Yo02Pp8xP+gtc2U0GDl+gn4FjK/qX8S66CTM7uBzzzU4Yg
         mktw==
X-Gm-Message-State: AFqh2kqnMvWA+JRTeMu2TfdJpAINHulEcBiiEXkdAp224uOi99hbrYZZ
        0vWpxh6qQvEVtwI0CBj2RQbrlQoIGyrkQ4jp2VAw7cNcbQayca3j8n5KX+GZt7rNZO9pdn+oIgx
        E70kcyIRnC9TS
X-Received: by 2002:adf:e38e:0:b0:251:d76:94d6 with SMTP id e14-20020adfe38e000000b002510d7694d6mr27613865wrm.8.1672837020893;
        Wed, 04 Jan 2023 04:57:00 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsTL72pbSJ0LqO0mZBqA1ZA5XXdELBG+wXp27yRc6oWkoAnGHBgpT+NGeci3xFu6QaJLcbk+g==
X-Received: by 2002:adf:e38e:0:b0:251:d76:94d6 with SMTP id e14-20020adfe38e000000b002510d7694d6mr27613861wrm.8.1672837020716;
        Wed, 04 Jan 2023 04:57:00 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-176-239.web.vodafone.de. [109.43.176.239])
        by smtp.gmail.com with ESMTPSA id a6-20020adfed06000000b0028e8693bb75sm18725288wro.63.2023.01.04.04.56.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 04:57:00 -0800 (PST)
Message-ID: <6560bcba-b967-55b5-41ff-e20360a7102e@redhat.com>
Date:   Wed, 4 Jan 2023 13:56:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: fix make standalone
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com
References: <20221220175508.57180-1-imbrenda@linux.ibm.com>
 <167161061144.28055.8565976183630294954@t14-nrb.local>
 <167161409237.28055.17477704571322735500@t14-nrb.local>
 <20221226184112.ezyw2imr2ezffutr@orel> <20230104120720.0d3490bd@p-imbrenda>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230104120720.0d3490bd@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/01/2023 12.07, Claudio Imbrenda wrote:
> On Mon, 26 Dec 2022 19:41:12 +0100
> Andrew Jones <andrew.jones@linux.dev> wrote:
> 
>> On Wed, Dec 21, 2022 at 10:14:52AM +0100, Nico Boehr wrote:
>>> Quoting Nico Boehr (2022-12-21 09:16:51)
>>>> Quoting Claudio Imbrenda (2022-12-20 18:55:08)
>>>>> A recent patch broke make standalone. The function find_word is not
>>>>> available when running make standalone, replace it with a simple grep.
>>>>>
>>>>> Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>>>>> Fixes: 743cacf7 ("s390x: don't run migration tests under PV")
>>>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>>>
>>>> I am confused why find_word would not be available in standalone, since run() in runtime.bash uses it quite a few times.
>>>>
>>>> Not that I mind the grep, but I fear more might be broken in standalone?
>>
>> standalone tests don't currently include scripts/$ARCH/func.bash, which
>> may be an issue for s390x. That could be fixed, though.
>>
>>>>
>>>> Anyways, to get this fixed ASAP:
>>>>
>>>> Acked-by: Nico Boehr <nrb@linux.ibm.com>
>>>
>>> OK, I get it now, find_word is not available during _build time_.
>>
>> That could be changed, but it'd need to be moved to somewhere that
>> mkstandalone.sh wants to source, which could be common.bash, but
>> then we'd need to include common.bash in the standalone tests. So,
>> a new file for find_word() would be cleaner, but that sounds like
>> overkill.
> 
> the hack I posted here was meant to be "clean enough" and
> arch-only (since we are the only ones with this issue). To be
> honest, I don't really care __how__ we fix the problem, only that we do
> fix it :)
> 
> what do you think would be the cleanest solution?

I think your patch is good enough for fixing the issue, so I went ahead and 
pushed it. If someone wants to figure out a nice way to make find_word 
available to the standalone builds, too, feel free to send a patch on top of 
this.

  Thanks,
   Thomas

