Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83FF56A81F1
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 13:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjCBMNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 07:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjCBMNb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 07:13:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CF03E60A
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 04:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677759162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HtFtaTLhkJtMXijEa58s2Y5EfyyTLMzyM1VpQwrQ+Qo=;
        b=DC59X3BhB3eGa/JUAUMXk7tzW4+geMPJG7mSMq8ivgQq2Jy5JcMyc6KCGt/OsVHGF+ba1N
        62crR64D9YWN7JDJB8j/wOdgKkAsu0xR3WGQOwTaOoGFvgNjdxCHMRuXBvFUqgzwYSab29
        mRTbTW50P/4PtfH5JbJzROCPc2EvMhw=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-595-aohY3X9MMp-2XHL_bk5oFw-1; Thu, 02 Mar 2023 07:12:40 -0500
X-MC-Unique: aohY3X9MMp-2XHL_bk5oFw-1
Received: by mail-pl1-f198.google.com with SMTP id z2-20020a170903018200b0019cfc0a566eso7671882plg.15
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 04:12:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HtFtaTLhkJtMXijEa58s2Y5EfyyTLMzyM1VpQwrQ+Qo=;
        b=FaRSShpY7bVa2gjDZjWp8FkR2HQZyLMSoIsIP8+w+ghrK5zco5X6XF5lok0GD1WTh7
         UFsIRZX/WPYvbhvvv7YLJp62gleUb8+qT418IdIot08B57XBBsLTTfjnLhN78AOw4Egm
         aoFx5idypV61DSMP8axxmSXkT6rTuFa+4xs3Q2Vicypocj5vRsmoxDTnB44ipf6fyIvv
         8onXWZ+DtNaIF9i+t65qESfkicp6otaFpdyN2y1yvv3uYm0nxiN86a4pk+3K3Sj+5DZc
         7te6Q4fn49rZ9GajgiYnNiJaLRveqpZYKBhu7bhfNUeB/Qf1p0cXlm0+JiZLRBTosU2M
         fQ6Q==
X-Gm-Message-State: AO0yUKUuOK5dwYZS1AoR99ewZbLhtaz0tpF9CIcsyJ8Wx45pMXgi0PDh
        v8EoHOW8kMpwxPVn1ZZWQqNDlTfhOTAN5+iS48SixHDqyiXUU0dyFF+GdNx0vVGi7bFLkvHmAd9
        6e5YnDhAUA6AWjM85kK68
X-Received: by 2002:a17:902:e74b:b0:19a:7217:32af with SMTP id p11-20020a170902e74b00b0019a721732afmr10871195plf.5.1677759159783;
        Thu, 02 Mar 2023 04:12:39 -0800 (PST)
X-Google-Smtp-Source: AK7set+lXh2ywAgxrTS03JOo9a92Dl/Rl74r2ipF/QnKaPY4SUvG5hHopddPLoVn4ctTSEg6aXiXHQ==
X-Received: by 2002:a17:902:e74b:b0:19a:7217:32af with SMTP id p11-20020a170902e74b00b0019a721732afmr10871190plf.5.1677759159516;
        Thu, 02 Mar 2023 04:12:39 -0800 (PST)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y9-20020a1709027c8900b00186a2274382sm10156720pll.76.2023.03.02.04.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 04:12:39 -0800 (PST)
Message-ID: <ae1f6ef0-2566-ad82-17b3-5637141be40e@redhat.com>
Date:   Thu, 2 Mar 2023 20:12:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests] arm: Replace the obsolete qemu script
Content-Language: en-US
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, "open list:ARM" <kvm@vger.kernel.org>
References: <20230301071737.43760-1-shahuang@redhat.com>
 <20230301125004.d5giadtz4yaqdjam@orel>
 <5b019bd3-cc57-017a-e0f6-bf9ebc97ad11@redhat.com>
 <20230302115229.cphrnp5qaxmdg6wz@orel>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230302115229.cphrnp5qaxmdg6wz@orel>
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



On 3/2/23 19:52, Andrew Jones wrote:
> On Thu, Mar 02, 2023 at 06:09:36PM +0800, Shaoqin Huang wrote:
>> Hi drew,
>>
>> On 3/1/23 20:50, Andrew Jones wrote:
>>> On Wed, Mar 01, 2023 at 02:17:37AM -0500, Shaoqin Huang wrote:
>>>> The qemu script used to detect the testdev is obsoleted, replace it
>>>> with the modern way to detect if testdev exists.
>>>
>>> Hi Shaoqin,
>>>
>>> Can you please point out the oldest QEMU version for which the modern
>>> way works?
>>>
>>>>
>>>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>>>> ---
>>>>    arm/run | 3 +--
>>>>    1 file changed, 1 insertion(+), 2 deletions(-)
>>>>
>>>> diff --git a/arm/run b/arm/run
>>>> index 1284891..9800cfb 100755
>>>> --- a/arm/run
>>>> +++ b/arm/run
>>>> @@ -59,8 +59,7 @@ if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
>>>>    	exit 2
>>>>    fi
>>>> -if $qemu $M -chardev testdev,id=id -initrd . 2>&1 \
>>>> -		| grep backend > /dev/null; then
>>>> +if ! $qemu $M -chardev '?' 2>&1 | grep testdev > /dev/null; then
>>>                                 ^ This shouldn't be necessary. afaict,
>>> 			        only stdio is used
>>>
>>> We can change the 'grep testdev >/dev/null' to 'grep -q testdev'
>>>
>>
>> This just remind me if we could also change
>>
>> if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
>>
>> to
>>
>> if ! $qemu $M -device '?' | grep -q virtconsole; then
>>
>> And all other place like that.
> 
> Yup.
> 
> Also, unrelated, but can you change your patch prefix to
> 
>    kvm-unit-tests PATCH
> 
> as suggested in the README? My filters are looking for 'PATCH'.
> 

Hi drew,

My bad. Has update it.

Thanks,
Shaoqin

> Thanks,
> drew
> 
>>
>> Thanks,
>>
>>>>    	echo "$qemu doesn't support chr-testdev. Exiting."
>>>>    	exit 2
>>>>    fi
>>>> -- 
>>>> 2.39.1
>>>>
>>>
>>> Thanks,
>>> drew
>>>
>>
>> -- 
>> Shaoqin
>>
> 

-- 
Shaoqin

