Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D42647403
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 17:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiLHQQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 11:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiLHQQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 11:16:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274BEAD30D
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 08:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670516125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O5JSj6tpBiw9sXeHTofqWR8FzlPYJBbVdgJf9+K81HA=;
        b=SLj3xAVgJTMFhhpBhb50In2bMBuEcWpeGKOAfEBI829IYl6aMCQadlAdz40N7iF4bIiVlz
        7jvr91PS1dO2OXWY9U9iiJ2mkKFenziSENh8FW1QGcZAW48jFJHdFEk1aV855ZFetMthQy
        2GMtbCOagWkNw4Qg6o60REHO3pIT0SE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-222-uVNr8hBkMJehg7cgkbKFsA-1; Thu, 08 Dec 2022 11:15:22 -0500
X-MC-Unique: uVNr8hBkMJehg7cgkbKFsA-1
Received: by mail-wm1-f69.google.com with SMTP id r67-20020a1c4446000000b003d09b0fbf54so2600335wma.3
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 08:15:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O5JSj6tpBiw9sXeHTofqWR8FzlPYJBbVdgJf9+K81HA=;
        b=acNUUXLoeqBF2aAuwhDfmDlnFw8IvMTj60cN+pD5INeBN0xHAGWDMYNeCMBZOueafb
         0mJ4tAqE76mmd2DCkRwQghR7LE3uQN1hYwXU+UM8YPScA0AEGG+Whx2FwF0rMQX6FYEt
         IjnWjaxebD+prttFNeZjPlouatRI3eEBYxlIwCqLzia3aMOss8YpXjNyapYk1ijDNLyC
         BWfqLjRnL/BpBuAE7z/4w881A38Ue2MF4fAD8CTYuZ0FUZw6J6fiZE1vo3O/j6HKcWvY
         itY0XVCyaSxs3UIhQRnxkSITciBRhL6seCfjz3kZCG4P5MUZvjIlW04hiH/gLK0aj5c/
         zFyA==
X-Gm-Message-State: ANoB5pmdvf3tkalhfXSlX0H9IE+zzDmlbfv6UrhxmBtTYshM/DMO72Uc
        awk3QspPcj0Rt9Wr4UMmbwNSbslgHzoYgrDdOteU14czrKO4pllXZtgcojA4SPzxUt6avM6bb5i
        ZO76J0CaNP3Ap
X-Received: by 2002:a1c:4c06:0:b0:3cf:88c3:d008 with SMTP id z6-20020a1c4c06000000b003cf88c3d008mr2326490wmf.28.1670516121059;
        Thu, 08 Dec 2022 08:15:21 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5yYLMTTDSRrDK1DcXudstkrPr9nLHKLQBvdzMIjk/U3hsH27sRZgwoVy+ZKGHTYS5p01Q2Kw==
X-Received: by 2002:a1c:4c06:0:b0:3cf:88c3:d008 with SMTP id z6-20020a1c4c06000000b003cf88c3d008mr2326480wmf.28.1670516120857;
        Thu, 08 Dec 2022 08:15:20 -0800 (PST)
Received: from [192.168.8.102] (tmo-113-115.customers.d1-online.com. [80.187.113.115])
        by smtp.gmail.com with ESMTPSA id p6-20020a1c5446000000b003c6cd82596esm5390208wmi.43.2022.12.08.08.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 08:15:20 -0800 (PST)
Message-ID: <a798542a-ef24-9f18-6ee3-c85ad6151bc2@redhat.com>
Date:   Thu, 8 Dec 2022 17:15:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH] s390x: sie: Test whether the epoch
 extension field is working as expected
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>
References: <20221207133118.70746-1-thuth@redhat.com>
 <20221207155909.6a3271f7@p-imbrenda>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20221207155909.6a3271f7@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/2022 15.59, Claudio Imbrenda wrote:
> On Wed,  7 Dec 2022 14:31:18 +0100
> Thomas Huth <thuth@redhat.com> wrote:
> 
>> We recently discovered a bug with the time management in nested scenarios
>> which got fixed by kernel commit "KVM: s390: vsie: Fix the initialization
>> of the epoch extension (epdx) field". This adds a simple test for this
>> bug so that it is easier to decide whether the host kernel of a machine
> 
> s/decide/determine/
> 
>> has already been fixed or not.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   s390x/sie.c | 28 ++++++++++++++++++++++++++++
>>   1 file changed, 28 insertions(+)
>>
>> diff --git a/s390x/sie.c b/s390x/sie.c
>> index 87575b29..7ec4b030 100644
>> --- a/s390x/sie.c
>> +++ b/s390x/sie.c
>> @@ -58,6 +58,33 @@ static void test_diags(void)
>>   	}
>>   }
>>   
>> +static void test_epoch_ext(void)
>> +{
>> +	u32 instr[] = {
>> +		0xb2780000,	/* STCKE 0 */
>> +		0x83020044	/* DIAG 0x44 to intercept */
> 
> I'm conflicted about this. one one hand, it should be 0x83000044, but
> on the other hand it does not matter at all, and the other testcase
> also has the spurious 2 in the middle (to check things we are not
> checking here)

D'oh, I simply copy-n-pasted that value from the other test ... well, it 
shouldn't really matter as long as the instruction just gets intercepted. 
OTOH, it's nicer if we make it at least clean here in this new code. I'll 
send a v2 without this "2" in between.

  Thomas

