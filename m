Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF0D5EFCC9
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 20:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235442AbiI2SPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 14:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiI2SPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 14:15:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB784AD59
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 11:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664475300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lCJrrcdKYCEK8mx5WN/ohtqBMQWHx3f7oSkfu0XYxHg=;
        b=Pf+5oSC1yjEM/3R3hGAi44iE1w8Jvd9AYmVgJBWknt+D/bm0e5ekrEpNL+UnV1hc16fsd8
        QBaq+m6//thyxkxoVl9FBQBrNOUzeoRY/dM1WxX5ZxOa1HRIj+gGGJthSt5Z+FQILpmSvz
        znKpstNeMQFVNBv6R+mTPcBv9rRFfS8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-674-poWmyBEqMguZRRSX03XKDg-1; Thu, 29 Sep 2022 14:14:58 -0400
X-MC-Unique: poWmyBEqMguZRRSX03XKDg-1
Received: by mail-ed1-f70.google.com with SMTP id f10-20020a0564021e8a00b00451be6582d5so1831795edf.15
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 11:14:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=lCJrrcdKYCEK8mx5WN/ohtqBMQWHx3f7oSkfu0XYxHg=;
        b=NaswiDKMEi6ruG35O7lqmNEL+4PBb/bBy4779rhbxrXPAfeLq0Pem97lM1hihfgRH/
         Hd6Q/YUbT3V4erWt1pn4qodrIrym8UHsubay11+DO5W/82Y+wWFvkCadwCy0q8+Q3XXf
         d1BKECuOwbiHkGcLacsOe/VVgOY0WCDU9NKZgavV3q7/CWr9n0Q2GoBK370AwpN95dAr
         Ni4FyoHkqHXSQteBakbBBv+dCe52cnB7CIXurR0hNKD6aIhBQjb5LDtkz+GGRfdA3JH8
         bfZcZhLAtoNRSIWiOakpcmq1BUHiFS5l6r4898Wmu1CRlESQorkXgSEm3kfBKcd5AiDt
         JCdQ==
X-Gm-Message-State: ACrzQf2++z5GiY6SWX+mZ/YhlKBAKdXdCbRb6hITvV+Tl/egoo9LA/RG
        745p6czRCh39kVbB+2BfVfXfu3yyYlC/EW7JrXM4Kxtt5njoGq7485Whnun8DEc4HlYQJ0fGrCO
        I/RZaSn84QBO8
X-Received: by 2002:a17:907:2c78:b0:779:7327:c897 with SMTP id ib24-20020a1709072c7800b007797327c897mr3539056ejc.657.1664475297792;
        Thu, 29 Sep 2022 11:14:57 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6nRddG4vqVPW/y4Jj6VZeBzKWXXY7gRnYgslGuboJMKJ+b0A32CztA9r7pNhMncFo2WOPYtw==
X-Received: by 2002:a17:907:2c78:b0:779:7327:c897 with SMTP id ib24-20020a1709072c7800b007797327c897mr3539049ejc.657.1664475297560;
        Thu, 29 Sep 2022 11:14:57 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id v6-20020aa7d646000000b0045851005e64sm137987edr.36.2022.09.29.11.14.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 11:14:57 -0700 (PDT)
Message-ID: <3f9c7cf9-4b77-fa21-5ffa-b32b305f8d57@redhat.com>
Date:   Thu, 29 Sep 2022 20:14:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: Guest IA32_SPEC_CTRL on AMD hosts without X86_FEATURE_V_SPEC_CTRL
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     kvm list <kvm@vger.kernel.org>, "Moger, Babu" <Babu.Moger@amd.com>
References: <CALMp9eRkuPPtkv7LadDDMT6DuKhvscJX0Fjyf2h05ijoxkYaoQ@mail.gmail.com>
 <20220903235013.xy275dp7zy2gkocv@treble>
 <CALMp9eR+sRARi8Y2=ZEmChSxXF1LEah3fjg57Mg7ZVM_=+_3Lw@mail.gmail.com>
 <CALMp9eT2mSjW3jpS4fGmCYorQ-9+YxHn61AZGc=azSEmgDziyA@mail.gmail.com>
 <20220908053009.p2fc2u2r327qyd6w@treble>
 <CALMp9eQ9A0qGS5RQjkX0HKdsUq3y5nKHFZQ=AVdfNOxxDPC65Q@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eQ9A0qGS5RQjkX0HKdsUq3y5nKHFZQ=AVdfNOxxDPC65Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/22 19:47, Jim Mattson wrote:
>> It sounds like that behavior may need clarification from AMD.  If that's
>> possible then it might indeed make sense to move the AMD spec_ctrl wrmsr
>> to asm like we did for Intel.
> 
> On the other side of the transition, restoration of the host
> IA32_SPEC_CTRL value is definitely way too late. With respect to the
> user/kernel boundary, AMD says, "If software chooses to toggle STIBP
> (e.g., set STIBP on kernel entry, and clear it on kernel exit),
> software should set STIBP to 1 before executing the return thunk
> training sequence." I assume the same requirements apply to the
> guest/host boundary. The return thunk training sequence is in
> vmenter.S, quite close to the VM-exit. On hosts without V_SPEC_CTRL,
> the host's IA32_SPEC_CTRL value is not restored until much later.

I think it's easier to just do both sides than to wait for 
clarifications.  I'll take a look.

Paolo

