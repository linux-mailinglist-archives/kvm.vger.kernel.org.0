Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFFF7D51FD
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343521AbjJXNjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343591AbjJXNi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:38:56 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8747E324C
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:37:36 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-40842752c6eso35854135e9.1
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698154655; x=1698759455; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j9rxO3yi9gLObbLJi9rghTRfPCV/QR8/fM1S9i4WEuI=;
        b=Kc9u7ZH1m5kXyXZGdDkt9q2+qld7S/mL4Sw60A7MgG560SvtaNzz6F/UavSSQTIIFL
         7f3KnXr51dCXkw8Aq67j5QmVE7jNmJYfT3ByRn7SnV+GwI5gynk/kLy79rhWM8nzM6Js
         33B8nolNll1PMW6J9VYauYoMQuDmX9l6gXtRGfd+2WrWkJLl8Yik2e03GitpMqItCtHL
         zLpe2lI0Z3/o/keBa3fhmT2UoBsfAg9HjMi1rvVSq+zgSOZBkKHoGoCpvDdIbA4oVq27
         811iyreisFZqS4n5Rik9ue8t31xQ0EqalCzMkjZzJbHVk4o6cgud0LGN2D9baSPobFvW
         bhGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698154655; x=1698759455;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j9rxO3yi9gLObbLJi9rghTRfPCV/QR8/fM1S9i4WEuI=;
        b=HoNwq3eSKdQT3vMjKjGOKFAPgE3Wfli7tT9pPybuqsR0bsAPa7PUPQ5ynOIP13f1JK
         Lr3/0eHSDH/5/+8umTdcnLBu1cfCPSwsgNh7AwIf78qhX7d8bplMSxxps6QOEPyAiOl3
         1FiR7m0KF3FxshuloNUaPpc4OcOoBeJhjMJZt7gT7Hncr2/vqJCr/j2d5qEBZMaVPuxN
         Ujl8gFVtmMLBA93scqwWjw9p6iLe9stDV2fGCH+XyjRdlH5Ajn7mB1aMN4kuKIhC3Gid
         K/+qdIN2sHxHfyGnq5pzCJ9Bnef5dozZsCFhBMmRWwCnyxV88/1u3wvs5366bG9XpiWk
         /iZQ==
X-Gm-Message-State: AOJu0YyNDCko222ExltoLhsRz6fBFX3wYxMpAT7JyKDID2hyzN7FHQ6a
        SwWKl03dd6KWYER+LUQzxMk=
X-Google-Smtp-Source: AGHT+IFCwR5Zipko4S5zjbV/abnJStyPGZ1/DwAYuPk2b3wwXjk/TEZ1ExZWj50RRXVedONgMthJkw==
X-Received: by 2002:a05:600c:4588:b0:409:7d0:d20b with SMTP id r8-20020a05600c458800b0040907d0d20bmr3231221wmo.24.1698154654600;
        Tue, 24 Oct 2023 06:37:34 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id 1-20020a05600c028100b004077219aed5sm16673519wmk.6.2023.10.24.06.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 06:37:34 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <ea38b980-14dd-4442-96d4-699ee39a0d27@xen.org>
Date:   Tue, 24 Oct 2023 14:37:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 06/12] hw/xen: add get_frontend_path() method to
 XenDeviceClass
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
References: <20231016151909.22133-1-dwmw2@infradead.org>
 <20231016151909.22133-7-dwmw2@infradead.org>
 <5ef43a7c-e535-496d-8a14-bccbadab3bc0@xen.org>
 <d43b900a6c7987c6832ceeede9b4c5ab65d5bacd.camel@infradead.org>
 <55bb6967-9499-45ef-b4c8-00fbfaccef0d@xen.org>
 <4d059cb96a92004fe25fdb140a6c0b12e91b4d7e.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <4d059cb96a92004fe25fdb140a6c0b12e91b4d7e.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2023 14:29, David Woodhouse wrote:
> On Tue, 2023-10-24 at 13:59 +0100, Paul Durrant wrote:
>> On 24/10/2023 13:56, David Woodhouse wrote:
>>> On Tue, 2023-10-24 at 13:42 +0100, Paul Durrant wrote:
>>>>
>>>>> --- a/hw/xen/xen-bus.c
>>>>> +++ b/hw/xen/xen-bus.c
>>>>> @@ -711,8 +711,16 @@ static void xen_device_frontend_create(XenDevice *xendev, Error **errp)
>>>>>      {
>>>>>          ERRP_GUARD();
>>>>>          XenBus *xenbus = XEN_BUS(qdev_get_parent_bus(DEVICE(xendev)));
>>>>> +    XenDeviceClass *xendev_class = XEN_DEVICE_GET_CLASS(xendev);
>>>>>      
>>>>> -    xendev->frontend_path = xen_device_get_frontend_path(xendev);
>>>>> +    if (xendev_class->get_frontend_path) {
>>>>> +        xendev->frontend_path = xendev_class->get_frontend_path(xendev, errp);
>>>>> +        if (!xendev->frontend_path) {
>>>>> +            return;
>>>>
>>>> I think you need to update errp here to note that you are failing to
>>>> create the frontend.
>>>
>>> If xendev_class->get_frontend_path returned NULL it will have filled in errp.
>>>
>>
>> Ok, but a prepend to say that a lack of path there means we skip
>> frontend creation seems reasonable?
> 
> No, it *is* returning an error. Perhaps I can make it
> 

I understand it is returning an error. I thought the point of the 
cascading error handling was to prepend text at each (meaningful) layer 
such that the eventual message conveyed what failed and also what the 
consequences of that failure were.

   Paul

>      if (!xendev->frontend_path) {
>          /*
>           * If the ->get_frontend_path() method returned NULL, it will
>           * already have set *errp accordingly. Return the error.
>           */
>          return /* false */;
>      }
> 
> 
>>> As a general rule (I'll be doing a bombing run on xen-bus once I get my
>>> patch queue down into single digits) we should never check 'if (*errp)'
>>> to check if a function had an error. It should *also* return a success
>>> or failure indication, and we should cope with errp being NULL.
>>>
>>
>> I'm pretty sure someone told me the exact opposite a few years back.
> 
> Then they were wrong :)

