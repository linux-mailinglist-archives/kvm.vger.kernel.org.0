Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2270687360
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 03:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjBBCjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 21:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBBCjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 21:39:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226DA2B0A1
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 18:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675305507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ApOKYKEp9+NcVo7PhBHJxbKc52pVbDUPLTRV3lF5F48=;
        b=JqrQOuqKQzpxSXF57qYG2rIATh/nqBSnIbNIPwGSjhEGJs3sRLE6ovjHlCcDUvsps6fc18
        9MuVLHL0SHEi8jtPqjLGEyb/86PFSiTbR6owC5X4X7s5ygwuyfbVmUmTIhOBX5kOPGxG5c
        IQOBJqIY+9Kd9c3JHJadpjcWzafjJUE=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-284-EjK0JqZIML2W1TRDNNjP1g-1; Wed, 01 Feb 2023 21:38:26 -0500
X-MC-Unique: EjK0JqZIML2W1TRDNNjP1g-1
Received: by mail-pl1-f197.google.com with SMTP id y9-20020a1709027c8900b00195e237dc8bso250513pll.13
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 18:38:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ApOKYKEp9+NcVo7PhBHJxbKc52pVbDUPLTRV3lF5F48=;
        b=sSxMiMCFgm8zMzdcIhAcEGm65gwd87nwRAu6GOAZglihA1/VAT4xJb/zifZk+ip2wx
         0h2VBCJy3i3owYBNy8jao9XbqPAfqdOAbYYS1OOqjtd1LnMD08bZBaRmuGzNQ2YMoNJW
         cl133Vk7kzW8cHNpx9ZqQkCp5X9WAT78C50jiPs8Z3gjFQ7mK8Rs6fdQN1q35W9oaIt9
         +j4MS/ZDqp5Pj1kXSfMEuc/z/obTtHydnxi6hmMO1NWSE9GE8lzsN1yLqdhOW9Anhfxw
         rn4bwwT0nllaFcBESrZDP+26O6Z5r5EQkg4rZNVbkwTey1EO3GYyGZ5kLTwAR31YBGrT
         inrQ==
X-Gm-Message-State: AO0yUKX+lI9YLL3Sj1hWJ4FfYfHHsYyWbvQDkwiF6bd9vr96yZ+4uV5I
        2pb7HIL6lvEDRMxhYwdbNXTRzQ29tSpea4ys1qnNUG7H8n4sD08PN/ihJhki17xN+CWex1ikQYW
        54PmfXx7NPL6Y
X-Received: by 2002:a05:6a20:441b:b0:bc:f665:8656 with SMTP id ce27-20020a056a20441b00b000bcf6658656mr6380915pzb.6.1675305505062;
        Wed, 01 Feb 2023 18:38:25 -0800 (PST)
X-Google-Smtp-Source: AK7set89TVvVFfBlJQq1qKyH8W6aNmxyTnPHU7y3H1p8qyqbybkNHnnffdQH22CU3lhv6SUi66K9qw==
X-Received: by 2002:a05:6a20:441b:b0:bc:f665:8656 with SMTP id ce27-20020a056a20441b00b000bcf6658656mr6380897pzb.6.1675305504740;
        Wed, 01 Feb 2023 18:38:24 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id m1-20020a633f01000000b004dfacb4804bsm8818599pga.21.2023.02.01.18.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 18:38:24 -0800 (PST)
Message-ID: <4b847318-280f-8b9b-bafa-2ada86a54cfa@redhat.com>
Date:   Thu, 2 Feb 2023 10:38:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] selftests: KVM: Replace optarg with arg in
 guest_modes_cmdline
Content-Language: en-US
To:     Vipin Sharma <vipinsh@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20230201054522.162611-1-shahuang@redhat.com>
 <CAHVum0eH_XrrPiviYYWEu=FouhEXeWq1mcx0=BoiF8NaoyVj_g@mail.gmail.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <CAHVum0eH_XrrPiviYYWEu=FouhEXeWq1mcx0=BoiF8NaoyVj_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/2/23 00:00, Vipin Sharma wrote:
> On Tue, Jan 31, 2023 at 9:46 PM <shahuang@redhat.com> wrote:
>> From: Shaoqin Huang <shahuang@redhat.com>
>>
>> The parameter arg in guest_modes_cmdline not being used now, and the
>> optarg should be replaced with arg in guest_modes_cmdline.
>>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>> ---
>>   tools/testing/selftests/kvm/lib/guest_modes.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
>> index 99a575bbbc52..1f2dca4520ab 100644
>> --- a/tools/testing/selftests/kvm/lib/guest_modes.c
>> +++ b/tools/testing/selftests/kvm/lib/guest_modes.c
>> @@ -127,7 +127,7 @@ void guest_modes_cmdline(const char *arg)
>>                  mode_selected = true;
>>          }
>>
>> -       mode = strtoul(optarg, NULL, 10);
>> +       mode = strtoul(arg, NULL, 10);
> While you are at it, can you also change strtoul to atoi_non_negative()?
>
> An underflow negative number will print an error message with a wrong
> positive guest mode ID not passed by the user.

Of course I can do that. Thanks for you Suggestion.

Thanks,

Shaoqin

>>          TEST_ASSERT(mode < NUM_VM_MODES, "Guest mode ID %d too big", mode);
>>          guest_modes[mode].enabled = true;
>>   }
>> --
>> 2.39.0
>>

