Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3C76D3EE7
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 10:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbjDCIYr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 04:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjDCIYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 04:24:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCC510E
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 01:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680510236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=owruJlkuUdo9oSu8mUCXgn4jSBArFwlF1Y6p0/FL9yE=;
        b=MLn8UeBAV50VN5EXFEJ3qsnIec/FmvH0OVQ+Dg52x1fIQOCT8AYHB+FmN+jreXpd2dv0Y2
        zwkfXFYx+xkF2ra7ItzM/uqLqN32Ua/lcffmvfpwnQAY5/U9SrnAyOjm/EN78WhADsqJ++
        Xm4I0V+ViH6lmx+AX5Br60QWwfXXazM=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-kSqlreJqOCmofXixRtCT5Q-1; Mon, 03 Apr 2023 04:23:55 -0400
X-MC-Unique: kSqlreJqOCmofXixRtCT5Q-1
Received: by mail-qv1-f71.google.com with SMTP id j15-20020a0cc34f000000b005c824064b10so12757662qvi.17
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 01:23:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680510234;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=owruJlkuUdo9oSu8mUCXgn4jSBArFwlF1Y6p0/FL9yE=;
        b=tbsMOIInNlNZFGJObGj70NOMJHJyZmz3mTph6HP7xsswpGAI4emdF8pKuv9WZ0wmc7
         Z4FkGRtqQclFyYeQQLRyW/OKudOHXFKvbwjG7nHaIOHjIJyeoCItk7JY0wO6pUuGmtfw
         oMf8FCT1fP1mQTTOxXBtTYZ0opVrOyLQp5RvW/PpFYnSQAOnvf0mWqTjPZCLCsO4Xm5R
         tgXzC4uNzlF5bZK9IgabDyCg4cIlrn6rvjyU2Fxl6mt5lDvFIFv891OINtQbOHGpPlMO
         +fCrp2KDUodLOtUHY5ytjKuH7Z7CnANqzn03gBCtK9btPWTdkxdcGxX2DbpVLZgfANI1
         jsmQ==
X-Gm-Message-State: AAQBX9cpSsfwIN5XzF3IXqgwVh368EXGEboPH7PxILkVHzhVeFM4edkI
        JJzRFjtx/4Hp2r5MexavcRaCUwOY6e/CN6pXLqCwGMir4TA8xY1Iqa67Ah+Q9co/UdoLN60qccR
        wUSBrDUifbmms
X-Received: by 2002:a05:622a:149:b0:3db:9289:6949 with SMTP id v9-20020a05622a014900b003db92896949mr30397695qtw.3.1680510234676;
        Mon, 03 Apr 2023 01:23:54 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zh4clKj2NC+2sj/d9oiqy/2xRaWHU6vJbowFHRgV6G/8Iw9FEiyoUt9SuPcJJZiY9sICWN/Q==
X-Received: by 2002:a05:622a:149:b0:3db:9289:6949 with SMTP id v9-20020a05622a014900b003db92896949mr30397680qtw.3.1680510234440;
        Mon, 03 Apr 2023 01:23:54 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-177-12.web.vodafone.de. [109.43.177.12])
        by smtp.gmail.com with ESMTPSA id bi10-20020a05620a318a00b007485ba3d794sm2580504qkb.105.2023.04.03.01.23.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 01:23:54 -0700 (PDT)
Message-ID: <b6363bd9-4f52-b842-01b6-046a348a1576@redhat.com>
Date:   Mon, 3 Apr 2023 10:23:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Cole Robinson <crobinso@redhat.com>
References: <0dcae003-d784-d4e6-93a2-d8cc9a1e3bc1@redhat.com>
 <ZCSNasVg+HBK0vI1@google.com>
 <754c052c-b575-4abc-605a-fff7d09c4a65@redhat.com>
 <ZCXlCHx0ti9LtXKx@google.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: The "memory" test is failing in the kvm-unit-tests CI
In-Reply-To: <ZCXlCHx0ti9LtXKx@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/03/2023 21.37, Sean Christopherson wrote:
> On Thu, Mar 30, 2023, Thomas Huth wrote:
>> On 29/03/2023 21.11, Sean Christopherson wrote:
>>> On Wed, Mar 29, 2023, Thomas Huth wrote:
>>>>
>>>>    Hi,
>>>>
>>>> I noticed that in recent builds, the "memory" test started failing in the
>>>> kvm-unit-test CI. After doing some experiments, I think it might rather be
>>>> related to the environment than to a recent change in the k-u-t sources.
>>>>
>>>> It used to work fine with commit 2480430a here in January:
>>>>
>>>>    https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/jobs/3613156199#L2873
>>>>
>>>> Now I've re-run the CI with the same commit 2480430a here and it is failing now:
>>>>
>>>>    https://gitlab.com/thuth/kvm-unit-tests/-/jobs/4022074711#L2733
>>>
>>> Can you provide the logs from the failing test, and/or the build artifacts?  I
>>> tried, and failed, to find them on Gitlab.
>>
>> Yes, that's still missing in the CI scripts ... I'll try to come up with a
>> patch that provides the logs as artifacts.
>>
>> Meanwhile, here's a run with a manual "cat logs/memory.log":
>>
>> https://gitlab.com/thuth/kvm-unit-tests/-/jobs/4029213352#L2726
>>
>> Seems like these are the failing memory tests:
>>
>> FAIL: clflushopt (ABSENT)
>> FAIL: clwb (ABSENT)
> 
> More than likely what is happening is that the platform supports CLFLUSHOPT and
> CLWB (possibly even via a ucode patch update), but the CPUID bits are not being
> enumerated to the guest.  Neither VMX nor SVM has intercept controls for the
> instructions, so KVM has no way to enforce the the guest's CPUID model.  E.g.
> the failures can be reproduce by manually hiding the features:
> 
>    rkt ./x86/run x86/memory.flat -smp 1 -cpu max,-clflushopt,-clwb
> 
> This isn't a KVM bug because of the virtualization hole.  And really, the test
> itself is bogus when running on KVM precisely because of said hole (similar holes
> exist for all the other instructions in the test).
 >
> The test appears to have been added for QEMU's TCG, which makes sense as there
> shouldn't be any virtualization holes in a pure emulation environment.
> 
> That said, it is interesting that the test is suddenly failing, as it means
> something is buggy.  If you can run commands on the host, check for host support
> via /proc/cpuinfo.  If those come back negative (no support), then it would appear
> that hardware or the host kernel is in a bad/unexpected state.
> 
>    grep -q clflushopt /proc/cpuinfo
>    grep -q clwb /proc/cpuinfo

I dumped the cpuinfo here:

  https://cirrus-ci.com/task/4861043097206784?logs=main#L22

And indeed, clflushopt and clwb do not show up. It's a nested setup, so I 
guess the flags have been disabled on the L0 host already.

I guess there's not much we can do here except disabling the "memory" test 
on cirrus-CI now...

  Thomas



