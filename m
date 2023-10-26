Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF7D7D7EBE
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 10:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344564AbjJZIpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 04:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjJZIpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 04:45:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89883189
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 01:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698309875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vctb3d6Et+H3LGoRGV4K/3OvkDY/qaE7xpt3KtVR3mY=;
        b=WlP0HTzVdgUbLJIFuZd6OdvBmIg7eU5TRP1NYfCKrE/KcazpSzKq/vKOOaqdRvx8RKHskN
        R3/mdKmTNTEgsZRD0anpn/sOMrWErSFSBh5nsxbXWsRufK39PwFbqwB0uMG59ZdP5J+w0/
        hw+Opf8JDgifzzOIxobEyaS9Q4gpOSo=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-486-PduELqH1Nzm_9u8S55Pt7w-1; Thu, 26 Oct 2023 04:44:32 -0400
X-MC-Unique: PduELqH1Nzm_9u8S55Pt7w-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-694d7f694a4so194377b3a.0
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 01:44:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698309871; x=1698914671;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vctb3d6Et+H3LGoRGV4K/3OvkDY/qaE7xpt3KtVR3mY=;
        b=CHRlLGvIRC+F+etbJR1iAVBHCcWaBK8hWOdjIAun8nuBQZhRkkwd6wRi3jgMP/Ianf
         Smd1E4GCtfDtgsG3VxCg/SRt8wGXOyPah9B5VIp8xRRX1HFz6Df7ezfmkMt8dmJryVD7
         XrqLT/ufOCMSrkQonGdneibNjjqcoFTotcwlzwAYEzr4ROkjvB/dbOWwss1L7jRLjVH1
         ZHZiNH8PUIuMMSrl22i7fseRs9DH/oPOQ+aKb/FSR3eauNx3w8YdFiwg9V125vp5XtX7
         ypL1VCkcJneMLN54TBsv+cAHBLqldfvU5B/rIAwvQvdEvjJ19DS0VVWFMYW/MFslGL5B
         iOkg==
X-Gm-Message-State: AOJu0YzMvWStQJCjUDP/DWWdZzQWDe3MDrQVYlTr1xsD9eCpe7VOdQ/n
        ZU5C+MEYF4rqPzBEHGvZeFLVREnao7byrmnvC1/+mDS6MxU4Jo+SgWPa8XVrAFniOZuF1KRqafj
        tIuHcq8RFBMvL
X-Received: by 2002:a05:6a21:7881:b0:16e:26fd:7c02 with SMTP id bf1-20020a056a21788100b0016e26fd7c02mr23417507pzc.2.1698309871023;
        Thu, 26 Oct 2023 01:44:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpTPOkjjDsH1o7wrlbka9DxRCmMZ3jogtH7v+HOsgH5EbbyCxLczHjQvzZDP4zjrNJi8pr0w==
X-Received: by 2002:a05:6a21:7881:b0:16e:26fd:7c02 with SMTP id bf1-20020a056a21788100b0016e26fd7c02mr23417492pzc.2.1698309870703;
        Thu, 26 Oct 2023 01:44:30 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h185-20020a6253c2000000b00692cb1224casm11181702pfb.183.2023.10.26.01.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Oct 2023 01:44:30 -0700 (PDT)
Message-ID: <907d8b7a-2cb0-f5b4-ac54-51aa1f6dd540@redhat.com>
Date:   Thu, 26 Oct 2023 16:44:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests PATCH v1] configure: arm64: Add support for
 dirty-ring in migration
Content-Language: en-US
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Thomas Huth <thuth@redhat.com>, kvmarm@lists.linux.dev,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
References: <20231026034042.812006-1-shahuang@redhat.com>
 <e318cd46-b871-448a-b95a-01647d8afc43@redhat.com>
 <9052ed87-e5cf-4d89-b480-54da4d8216c7@redhat.com>
 <20231026-38a5f6360752b10fdb086adc@orel>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20231026-38a5f6360752b10fdb086adc@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi drew,

On 10/26/23 15:40, Andrew Jones wrote:
> On Thu, Oct 26, 2023 at 01:54:55PM +0800, Shaoqin Huang wrote:
>>
>>
>> On 10/26/23 13:12, Thomas Huth wrote:
>>> On 26/10/2023 05.40, Shaoqin Huang wrote:
>>>> Add a new configure option "--dirty-ring-size" to support dirty-ring
>>>> migration on arm64. By default, the dirty-ring is disabled, we can
>>>> enable it by:
>>>>
>>>>     # ./configure --dirty-ring-size=65536
>>>>
>>>> This will generate one more entry in config.mak, it will look like:
>>>>
>>>>     # cat config.mak
>>>>       :
>>>>     ACCEL=kvm,dirty-ring-size=65536
>>>>
>>>> With this configure option, user can easy enable dirty-ring and specify
>>>> dirty-ring-size to test the dirty-ring in migration.
>>>
>>> Do we really need a separate configure switch for this? If it is just
>>> about setting a value in the ACCEL variable, you can also run the tests
>>> like this:
>>>
>>> ACCEL=kvm,dirty-ring-size=65536 ./run_tests.sh
>>>
>>>    Thomas
>>>
>>
>> Hi Thomas,
>>
>> You're right. We can do it by simply set the ACCEL when execute
>> ./run_tests.sh. I think maybe add a configure can make auto test to set the
>> dirty-ring easier? but I'm not 100% sure it will benefit to them.
>>
> 
> For unit tests that require specific configurations, those configurations
> should be added to the unittests.cfg file. As we don't currently support
> adding accel properties, we should add a new parameter and extend the
> parsing.

So you mean we add the accel properties into the unittests.cfg like:

accel = kvm,dirty-ring-size=65536

Then let the `for_each_unittest` to parse the parameter?
In this way, should we copy the migration config to dirty-ring 
migration? Just like:

[its-migration]
file = gic.flat
smp = $MAX_SMP
extra_params = -machine gic-version=3 -append 'its-migration'
groups = its migration
arch = arm64

[its-migration-dirty-ring]
file = gic.flat
smp = $MAX_SMP
extra_params = -machine gic-version=3 -append 'its-migration'
groups = its migration
arch = arm64
accel = kvm,dirty-ring-size=65536

So it will test both dirty bitmap and dirty ring.

Thanks,
Shaoqin

> 
> Thanks,
> drew
> 

