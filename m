Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88FD54B1FF4
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 09:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347943AbiBKINz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 03:13:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiBKINx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 03:13:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F1DBB9A
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 00:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644567231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OUVR/zoupdoX6+ubOzd6knBoEGVnkn4cOQdoBMCfCbw=;
        b=UKSxmPRqGMN2HQsjtYFNB8/C7uWKe7rx/wkh11bGUWQIVI7lXVvdWdUScnncF6oy180yRd
        ubB9H1mjMgVRGCh8fCerEKUrjPl8YNinVRWGEKpumslgGavW8iXPq3laMla3QWaIscZAQ2
        jnPvDb77Sapd3fyD89kED/NU+E+YXVY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-adzUQOleOnqwD6zaBaxTQg-1; Fri, 11 Feb 2022 03:13:50 -0500
X-MC-Unique: adzUQOleOnqwD6zaBaxTQg-1
Received: by mail-wm1-f72.google.com with SMTP id m3-20020a7bcb83000000b0034f75d92f27so2217488wmi.2
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 00:13:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OUVR/zoupdoX6+ubOzd6knBoEGVnkn4cOQdoBMCfCbw=;
        b=YKwnoc7gRIbl4cxvumL1NvdDk4jjXiOJY7TN3l/Uayz8LPLZ8WTTs/dHOIRel/MzXE
         Ua3uN7Wy/wNKhKA+jJvkaulKsR607A+5uIc1LBNHC+8T5Pv8Qc09HfQmy1N5GNnsOfC8
         0HbeGwt7eOuVAMsPq+DsbLfA/B+m/e77B15Nyn6FhWogR2RqOeSmL3AjN5bhQK01tBKV
         gK31toY0eBygPLySIbc/+CmaJlHGyvOhgQ1Irj+/TPX5PnnQ+LhonIkEz8jGYVx2kZjl
         pU7vR3Op22E/kF1rLvSYoWAKrCjTNyWMuavxT4UQkr7qO2pPVj80LGxudJCOFVjI7SQ2
         JI3w==
X-Gm-Message-State: AOAM532X/8gMWr62maLFHKRE6Rn085uP83s0krx0NSCYjd46RHg/Krei
        OTUBMI5n29JoAfRYzw6LeWL4zx49kZ7bdzFtUvU4AH3Ovi/X8m9tP0YFItQBi8YrUBjGksD1rSM
        ZLUFy7qkJbY2o
X-Received: by 2002:a05:600c:4295:: with SMTP id v21mr1158171wmc.19.1644567229079;
        Fri, 11 Feb 2022 00:13:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzFDwMOqNhdLMmzCS9As9GMXonsgOfpQhipriYO985eA+t9E1y7/H8f0Oa+d3sbWGyRVAQfEA==
X-Received: by 2002:a05:600c:4295:: with SMTP id v21mr1158150wmc.19.1644567228874;
        Fri, 11 Feb 2022 00:13:48 -0800 (PST)
Received: from [192.168.8.104] (tmo-098-218.customers.d1-online.com. [80.187.98.218])
        by smtp.gmail.com with ESMTPSA id l28sm19947430wrz.90.2022.02.11.00.13.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 00:13:48 -0800 (PST)
Message-ID: <f326daff-8384-4666-fc5e-6b7b509f6fe8@redhat.com>
Date:   Fri, 11 Feb 2022 09:13:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
Content-Language: en-US
To:     Zixuan Wang <zxwang42@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com> <YgVPPCTJG7UFRkhQ@monolith.localdoman>
 <CAEDJ5ZSR=rw_ALjBcLgeVz9H6TS67eWvZW2SvGTJV468WjgyKw@mail.gmail.com>
 <YgVpJDIfUVzVvFdx@google.com>
 <CAEDJ5ZRkuCbmPzZXz0x2XUXqjKoi+O+Uq_SNkNW_We2mSv4aRg@mail.gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <CAEDJ5ZRkuCbmPzZXz0x2XUXqjKoi+O+Uq_SNkNW_We2mSv4aRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/02/2022 20.48, Zixuan Wang wrote:
> On Thu, Feb 10, 2022 at 11:36 AM Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Thu, Feb 10, 2022, Zixuan Wang wrote:
>>> On Thu, Feb 10, 2022 at 11:05 AM Alexandru Elisei
>>> <alexandru.elisei@arm.com> wrote:
>>>>
>>>> Hi,
>>>>
>>>> On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
>>>>> On Thu, Feb 10, 2022, Alexandru Elisei wrote:
>>>>>> I renamed --target-efi to --efi-payload in the last patch because I felt it
>>>>>> looked rather confusing to do ./configure --target=qemu --target-efi when
>>>>>> configuring the tests. If the rename is not acceptable, I can think of a
>>>>>> few other options:
>>>>>
>>>>> I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
>>>>> seems like it would be sufficient.
>>>>>
>>>>>> 1. Rename --target to --vmm. That was actually the original name for the
>>>>>> option, but I changed it because I thought --target was more generic and
>>>>>> that --target=efi would be the way going forward to compile kvm-unit-tests
>>>>>> to run as an EFI payload. I realize now that separating the VMM from
>>>>>> compiling kvm-unit-tests to run as an EFI payload is better, as there can
>>>>>> be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
>>>>>> a test runner, so I think the impact on users should be minimal.
>>>>>
>>>>> Again irrespective of --target-efi, I think --target for the VMM is a potentially
>>>>> confusing name.  Target Triplet[*] and --target have specific meaning for the
>>>>> compiler, usurping that for something similar but slightly different is odd.
>>>>
>>>> Wouldn't that mean that --target-efi is equally confusing? Do you have
>>>> suggestions for other names?
>>>
>>> How about --config-efi for configure, and CONFIG_EFI for source code?
>>> I thought about this name when I was developing the initial patch, and
>>> Varad also proposed similar names in his initial patch series [1]:
>>> --efi and CONFIG_EFI.
>>
>> I don't mind CONFIG_EFI for the source, that provides a nice hint that it's a
>> configure option and is familiar for kernel developers.  But for the actually
>> option, why require more typing?  I really don't see any benefit of --config-efi
>> over --efi.
> 
> I agree, --efi looks better than --target-efi or --config-efi.

<bikeshedding>
Or maybe --enable-efi ... since configure scripts normally take 
"--enable-..." or "--disable-..." parameters for stuff like this?
</bikeshedding>

  Thomas

