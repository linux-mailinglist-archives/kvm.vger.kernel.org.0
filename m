Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5BEF6A0313
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 08:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbjBWHCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 02:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbjBWHB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 02:01:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081C44A1CC
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 23:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677135675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2KrlIqEWrw++5ljF2WMGVjG8JmafNmFlDeR3rNw0a8s=;
        b=USsoxj/MaOBPWtfWMymTsppH+4mI5h9B3TGcGFr4ryhVtBNu/fon6B+mRGNB7DVM4a4QhN
        hyOzRXxRp9/kUgUzsBj2BfjXQbSLxZGnxkQWPqR7+yOeRlnSCDZ6bSKpWLPhGGWckFZWO2
        BjQjFUYO86Pe2AQw1yKCDUIZJRJ9BIo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-640-rchqYGdYNeqBzrAGqaIHCg-1; Thu, 23 Feb 2023 02:01:13 -0500
X-MC-Unique: rchqYGdYNeqBzrAGqaIHCg-1
Received: by mail-wm1-f70.google.com with SMTP id c7-20020a7bc847000000b003e00be23a70so4688496wml.2
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 23:01:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2KrlIqEWrw++5ljF2WMGVjG8JmafNmFlDeR3rNw0a8s=;
        b=i0zWv9nhzkNZ0QPefr5HOENSI3goZgTEje8LzULarc8wzCyPLq56Hu/WfQHqcNGzNw
         VPsi0QLrbMie7pR7Sd4kslKydAmu188gQu/Pw8RtNqpYT9SPxLfWgUnmIVKjtDPFvxGX
         rTt5QcDvraAOcy0MIArSBWO72e/IlmnaXEpMWKwselydTEzJZ0wdju7vFyr0UpRL2wya
         RmYVc3fo3Xa6Aq9hkCu53FAXlL+NFsMxztSV6aF90mURP8znU4bekPO2Uvj9dFWNnnja
         Mgv7CLh9WGbCmLMphnbnIVg7o2ulu8NOHJx61iEyatc1HKRxIUYZSiT7lp+fTAaK6tt8
         xuug==
X-Gm-Message-State: AO0yUKX9vGK2j0JmIEAjVH3evSL8W93Me+JHzFzOuXoNUlfPsjE+NotH
        9oMmr3WIOqFj9GS7yIrnbr89pkW9eHTH4Krhz5eMB83lgeU3vBsg/vV+0DGffMPbBTAslooROKG
        /sQPQWnHn/xja
X-Received: by 2002:a05:600c:984:b0:3e2:14cb:77db with SMTP id w4-20020a05600c098400b003e214cb77dbmr7654579wmp.20.1677135672344;
        Wed, 22 Feb 2023 23:01:12 -0800 (PST)
X-Google-Smtp-Source: AK7set8cG2RUX+u8d+Fjc1cwm/r87odmofT5RiRfY/SC/KhqjY01+XAc7+MBLtAsDhq7ynjO1a4dLg==
X-Received: by 2002:a05:600c:984:b0:3e2:14cb:77db with SMTP id w4-20020a05600c098400b003e214cb77dbmr7654525wmp.20.1677135671592;
        Wed, 22 Feb 2023 23:01:11 -0800 (PST)
Received: from [192.168.8.104] (tmo-100-40.customers.d1-online.com. [80.187.100.40])
        by smtp.gmail.com with ESMTPSA id p13-20020a1c544d000000b003e208cec49bsm4001759wmi.3.2023.02.22.23.01.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 23:01:10 -0800 (PST)
Message-ID: <05144c6d-922c-e70d-e625-c60952b60f3c@redhat.com>
Date:   Thu, 23 Feb 2023 08:01:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] KVM: x86: disable on 32-bit unless CONFIG_BROKEN
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Daniel P. Berrange" <berrange@redhat.com>
References: <20220926165112.603078-1-pbonzini@redhat.com>
 <YzMt24/14n1BVdnI@google.com>
 <ed74c9a9d6a0d2fd2ad8bd98214ad36e97c243a0.camel@redhat.com>
 <15291c3f-d55c-a206-9261-253a1a33dce1@redhat.com>
 <YzRycXDnWgMDgbD7@google.com>
 <ad97d0671774a873175c71c6435763a33569f669.camel@redhat.com>
 <YzSKhUEg3L1eMKOR@google.com>
 <08dab49f-9ca4-4978-4482-1815cf168e74@redhat.com>
 <b8fa9561295bb6af2b7fcaa8125c6a3b89b305c7.camel@redhat.com>
 <06d04f32-8403-4d7f-76a1-11a7fac3078e@redhat.com>
 <Y/aWx4EiDzKW6RHe@google.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <Y/aWx4EiDzKW6RHe@google.com>
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

On 22/02/2023 23.27, Sean Christopherson wrote:
> On Fri, Feb 17, 2023, Thomas Huth wrote:
>> On 29/09/2022 15.52, Maxim Levitsky wrote:
>>> On Thu, 2022-09-29 at 15:26 +0200, Paolo Bonzini wrote:
>>>> On 9/28/22 19:55, Sean Christopherson wrote:
>>>>>> As far as my opinion goes I do volunteer to test this code more often,
>>>>>> and I do not want to see the 32 bit KVM support be removed*yet*.
>>>>>
>>>>> Yeah, I 100% agree that it shouldn't be removed until we have equivalent test
>>>>> coverage.  But I do think it should an "off-by-default" sort of thing.  Maybe
>>>>> BROKEN is the wrong dependency though?  E.g. would EXPERT be a better option?
>>>>
>>>> Yeah, maybe EXPERT is better but I'm not sure of the equivalent test
>>>> coverage.  32-bit VMX/SVM kvm-unit-tests are surely a good idea, but
>>>> what's wrong with booting an older guest?
>>>
>>>>  From my point of view, using the same kernel source for host and the guest
>>> is easier because you know that both kernels behave the same.
>>>
>>> About EXPERT, IMHO these days most distros already dropped 32 bit suport thus anyway
>>> one needs to compile a recent 32 bit kernel manually - thus IMHO whoever
>>> these days compiles a 32 bit kernel, knows what they are doing.
>>>
>>> I personally would wait few more releases when there is a pressing reason to remove
>>> this support.
>>
>> FWIW, from the QEMU perspective, it would be very helpful to remove 32-bit
>> KVM support from the kernel. The QEMU project currently struggles badly with
>> keeping everything tested in the CI in a reasonable amount of time. The
>> 32-bit KVM kernel support is the only reason to keep the qemu-system-i386
>> binary around - everything else can be covered with the qemu-system-x86_64
>> binary that is a superset of the -i386 variant (except for the KVM part as
>> far as I know).
>> Sure, we could also drop qemu-system-i386 from the CI without dropping the
>> 32-bit KVM code in the kernel, but I guess things will rather bitrot there
>> even faster in that case, so I'd appreciate if the kernel could drop the
>> 32-bit in the near future, too.
> 
> Ya, I would happily drop support for 32-bit kernels today, the only sticking point
> is the lack of 32-bit shadow paging test coverage, which unfortunately is a rather
> large point.  :-(

 From your point of view, would it be OK if QEMU dropped qemu-system-i386? 
I.e. would it be fine to use older versions of QEMU only for that test 
coverage (or do you even use a different userspace for testing that)?

  Thomas

