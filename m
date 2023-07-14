Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A9A753506
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 10:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjGNIb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 04:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjGNIb1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 04:31:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA661BF9
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 01:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689323439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8GK0iKqkNug8OS4hv1T4NQoqkV1nPuziu7JFcaeVqa8=;
        b=VzN/3JYilGKGN1xETFxZlbYpFVysmfTtFhBCMjKPKDGu35fWzfD1Y2W7SAWWQKKyfvLTOC
        esQyO+RdSwL5SnDSbwJqhA91cgqjSuie5aFBPnyvN/FI09ZeP3BmlmsGYilHzqg5DUjeva
        L9x04NPdi33lPtcxh7ia58o7mGK8Pl4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-aI51tZPuNCufA0ebd3X-rg-1; Fri, 14 Jul 2023 04:30:37 -0400
X-MC-Unique: aI51tZPuNCufA0ebd3X-rg-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-635f63d0c1aso12905796d6.3
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 01:30:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689323437; x=1691915437;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8GK0iKqkNug8OS4hv1T4NQoqkV1nPuziu7JFcaeVqa8=;
        b=GXLYJvMHcG64fipF+ZTkTy2UXlEGR7ArBzQ40lcfXzgQn+MGpipNMBM8pUx2KWa4vx
         O+rXuhpNX5deeVlAESapRmqnLq2c2XJeN/TM5qptF9zwkvfjJweUrsLpmsZZXDUUDDmX
         HZmnDm2h3RPtkpPB+HQmgkNMCk8xCYlXtTkrdyASgiybFzzZ7KSV307UFGmYJTCH61/G
         zqUkghtYC+0KEigurKB4dpwXu4mCwgx7+DRG38M6OtMTjI61y9YNFlfLrZ9QP6SQYbGV
         Q3oUX1yySi5jHTfXqakAmhex9TlTwuOwDuP/OfyHtDQSVCvQet1WGsMnN3ZEQ6CnN5mI
         lRpA==
X-Gm-Message-State: ABy/qLarW5meJDXUQ75S8VY6RcgAWbPnuW6N0h57bErldtVfw/+o/sG+
        OQK3yScG92yllkoQ8FHf7N2zQ0E29zB/WrsRPrEPdACMf4usko9n5UCsXCoiAi2PgMm91MwhmXV
        HkMZhfSvT4Y1T
X-Received: by 2002:a0c:cb8d:0:b0:628:6879:ee48 with SMTP id p13-20020a0ccb8d000000b006286879ee48mr3133070qvk.50.1689323437183;
        Fri, 14 Jul 2023 01:30:37 -0700 (PDT)
X-Google-Smtp-Source: APBJJlECU3lq0hSbX4gPcu9d3VYHoCX2YaF9QrFBfUBOB8Glw4nKssr755Ie3N4zshdH5CdiinMDUA==
X-Received: by 2002:a0c:cb8d:0:b0:628:6879:ee48 with SMTP id p13-20020a0ccb8d000000b006286879ee48mr3133055qvk.50.1689323436759;
        Fri, 14 Jul 2023 01:30:36 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-177-249.web.vodafone.de. [109.43.177.249])
        by smtp.gmail.com with ESMTPSA id a20-20020a0ce354000000b005ef442226bbsm3790768qvm.8.2023.07.14.01.30.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jul 2023 01:30:36 -0700 (PDT)
Message-ID: <773a739d-c1a3-af32-424b-7d29878fccf5@redhat.com>
Date:   Fri, 14 Jul 2023 10:30:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [kvm-unit-tests PATCH v5 3/6] s390x: sie: switch to home space
 mode before entering SIE
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     frankja@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20230712114149.1291580-1-nrb@linux.ibm.com>
 <20230712114149.1291580-4-nrb@linux.ibm.com>
 <3dbe3094-b796-6b78-a97f-130a82780421@redhat.com>
 <20230713101707.1d1da214@p-imbrenda>
 <cedb8a69-c801-daee-52ed-b38b84deabd1@redhat.com>
 <168932289824.12187.4321177108836954492@t14-nrb>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <168932289824.12187.4321177108836954492@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/07/2023 10.21, Nico Boehr wrote:
> Quoting Thomas Huth (2023-07-13 10:21:12)
>> On 13/07/2023 10.17, Claudio Imbrenda wrote:
>>> On Thu, 13 Jul 2023 09:28:19 +0200
>>> Thomas Huth <thuth@redhat.com> wrote:
>>>
>>> [...]
>>>
>>>>> +   irq_set_dat_mode(IRQ_DAT_ON, AS_PRIM);
>>>>> +   psw_mask_clear_bits(PSW_MASK_HOME);
>>>>> +
>>>>> +   /* restore the old CR 13 */
>>>>> +   lctlg(13, old_cr13);
>>>>
>>>> Wouldn't it be better to always switch to HOME address mode directly in our
>>>> startup code already (where we enable DAT)? Switching back and forth every
>>>> time we enter SIE looks confusing to me ... or is there a reason why we
>>>> should continue to run in primary address mode by default and only switch to
>>>> home mode here?
>>>
>>> the existing tests are written with the assumption that they are
>>> running in primary mode.
>>>
>>> switching back and forth might be confusing, but avoids having to
>>> fix all the tests
>>
>> Which tests are breaking? And why? And how much effort would it be to fix them?
> 
> Since you're not the first asking this, I took the time and
> moved^Whacked everything to home space mode:
> 
> - all SIE-related tests time out, even when we load CR1 properly before SIE
>    entry. Most likely just an oversight and fixable.
> - the skey test encounters an unexpected PGM int with a weird backtrace
>    where I couldn't easily figure out what goes wrong
> - edat test fails with a similar looking backtrace
> 
> All in all, it is probably fixable, but additional effort.
> 
> I think explicitly switching the address space mode gives us additional
> flexibility, since sie() doesn't need to make assumptions about which address
> space we're running in.

Ok, thanks for checking. Then let's go with this patch here for now, but 
maybe you could add a more detailed comment in the source code that talks 
about the reasons for switching each time instead of only once during startup?

Thanks,
  Thomas

