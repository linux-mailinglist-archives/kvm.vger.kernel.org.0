Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3264B4C353E
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 20:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbiBXTA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 14:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiBXTAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 14:00:25 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28D618E42B
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 10:59:54 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id i21so2634819pfd.13
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 10:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fyRJwkdEk9dWrbptJefFZUVWbdfjncd85LnmXOcMJA4=;
        b=koCoOElIvFf2pF9r8KqL81JR7/aEwX4ouLYXauh77CI48GZtPvSVyyuZL/+2Fw1KMN
         yyhmYZR4KDha4XVqiwktrwJei4UPzgz6ynyBeZ6fE9G32zTS+kU7tyTKj9Vxqw/CIu1Z
         1UXYlXoyMXgZKHKjzJ4A2Q/RtQjhWNQQDpNwKUG1K8XaKU5Y6KW2Au2Ks5RGYdeLyYZs
         nCh0dU0rjhU8dDylVjfzAOjI3GDY4fGTepSXIYHTAC+kS54ZBSP/1ttxd9FZF6D0S4Df
         h33hEX8nC0jK7vkIan4rNUfYEhdvghFN2o0+kP5Ha5JC2iKhrotsgLwLsWJ70M3gscOE
         Lh6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fyRJwkdEk9dWrbptJefFZUVWbdfjncd85LnmXOcMJA4=;
        b=XBtCwFIoW7enx/BQP+SmA3hNS14+JJyvK0lZNMz3rtistOKHNnDkCzc65ULJkfaRzu
         w54mWsky9tnMAGQzoWdSDs03upj7QAfv6A7LphlCD233YXpcQ6AH7+FYuGYFZOCFoPpv
         JRD6lctWJa0w7PI1lcdliCz6jnV1RVTq7EXenxEDtbTXxrgFK8bWEiyaxlrrou79BZ1L
         IEi35QT5GGLeV3vmka1GHNQBoyHsqmNWjJns1Bj9LN3FvcWzqjTYqWfOYINVGBnQuDvL
         ri68TOj2VxjWnBlIXM5YPpUneTO/Z9tZ16igId95FxXWXy1wI+5WK5mi08AQmcM5blJK
         r3oA==
X-Gm-Message-State: AOAM530osy7upFE/AOU9IoMIi7rgdswuRrqnkFaRPO61Q8m2o9kLauNu
        q3Da2udvg7xYa8MiqwqrxpOpmg==
X-Google-Smtp-Source: ABdhPJwFBRKABFChm9nzdPOgbE3WXtr9EPr5XquiOKPJHsMmFjakNuJVob6G0QqvAmGUsUzPa+myAQ==
X-Received: by 2002:a05:6a00:140f:b0:4e0:6995:9c48 with SMTP id l15-20020a056a00140f00b004e069959c48mr3962998pfu.59.1645729194251;
        Thu, 24 Feb 2022 10:59:54 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id 25-20020a631859000000b00373df766e76sm255444pgy.16.2022.02.24.10.59.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Feb 2022 10:59:53 -0800 (PST)
Message-ID: <8d3a11be-a7eb-5ad0-2ef6-abc9276ced2f@linaro.org>
Date:   Thu, 24 Feb 2022 10:59:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: x86: Forcibly leave nested virt when SMM state is
 toggled
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+8112db3ab20e70d50c31@syzkaller.appspotmail.com
References: <20220125220358.2091737-1-seanjc@google.com>
 <db8a9edd-533e-3502-aed1-e084d6b55e48@linaro.org>
 <Yg/QKgxotNyZbYAI@google.com>
 <3561688b-b52c-8858-3da2-afda7c3e681f@linaro.org>
 <6cef7c8a-10d3-9fc6-f68d-220fdfc079c1@redhat.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <6cef7c8a-10d3-9fc6-f68d-220fdfc079c1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/22 10:14, Paolo Bonzini wrote:
> On 2/18/22 18:22, Tadeusz Struk wrote:
>> On 2/18/22 08:58, Sean Christopherson wrote:
>>> This SMM-specific patch fixes something different, the bug that you are still
>>> hitting is the FNAME(cmpxchg_gpte) mess.  The uaccess CMPXCHG series[*] that
>>> properly fixes that issue hasn't been merged yet.
>>>
>>>    ==================================================================
>>>    BUG: KASAN: use-after-free in ept_cmpxchg_gpte.constprop.0+0x3c3/0x590
>>>    Write of size 8 at addr ffff888010000000 by task repro/5633
>>>
>>> [*]https://lore.kernel.org/all/20220202004945.2540433-1-seanjc@google.com
>>>
>>
>> Ok, that's good. I will keep an eye on it and give it a try then.
> 
> I'll poke PeterZ for a review next week.
> 

Paulo, do you know if PeterZ had a chance to look at the uaccess patches yet?

-- 
Thanks,
Tadeusz
