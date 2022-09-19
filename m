Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F8D5BC391
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 09:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiISHjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 03:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiISHjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 03:39:12 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352A81EAEA;
        Mon, 19 Sep 2022 00:39:09 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id b75so22021489pfb.7;
        Mon, 19 Sep 2022 00:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=6BbzpneSCd/fog8Z/llAh0YBRR0NTGGPNcaoP0oTmv8=;
        b=VOiVHDSbwRDnYIfB5vTjxTI5vzhffyTYBtu46285qGH5XdyYmi9H1r8raFz9isX8H8
         WVL8MMC1JJQMBkSv9JxyQts8iUskqIaXL0ycoZjcWjafWH3ykpva81ljhI2v+Ql0VQ/n
         dJQIhI1ePbYnwermbk/av1N5+6XX0dx/p4Wm0Nq6xQmdMYoLxXdIVSDj2BqU8Q19z1f1
         tsTkHHxGZOQA5nBs8D5OIqHld4XC9SKyIVT2hVCm1HClSl5S4mPUzjDWM5eq64aVnVA1
         cSd3fBAbmlC97PSar1kcmXmu6+UaOIuhue9kIUteI6qssI4wbJ/Diu1uakyvwrktcVzH
         dJ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=6BbzpneSCd/fog8Z/llAh0YBRR0NTGGPNcaoP0oTmv8=;
        b=YbbRDEmPCxiFMPwc8keMd/T15w9rzy3jFJvbTh2LiPvER3FuPoa2uoez1EhhcOzKdt
         2z+dMk1B4mLuf0b3M7rSSlhhCeyA2prTZ4pH+uw5zSolxQl3Kxvdc9HB5fId4slBITO4
         JO+wwAIBfKMpLECaZ6uaRrmaMktDUhoDCLW5p12sitYzKwGGUq59TSY45KhjkAXZDwdp
         UqACG8wVudxAn1/u89hQWFQBreVqxkXDom20y/pwRJzYz5d/P9f775Egw5wbdjph4hdG
         F9pvDUoykKxXbGV7ji+yKdAws0bzMzDWNbf1HqY1JzXEonMGx7xQQzdY+hKnmzba2lAJ
         Mn4g==
X-Gm-Message-State: ACrzQf2JvMstCs34afOwaVDgYU+crCbr9FqBkdPutkTl8FzfEGzZmCzQ
        VED21qA8CBo4/a74iq1A5so=
X-Google-Smtp-Source: AMsMyM6VXcd32oAHHS8h4UvkKOe1Ubw+usoTz+8u0qNTPfO0fik9WsVLsHzt4VGQxx6aVKgWQ797Tg==
X-Received: by 2002:a65:6042:0:b0:439:2032:225 with SMTP id a2-20020a656042000000b0043920320225mr14325350pgp.469.1663573148841;
        Mon, 19 Sep 2022 00:39:08 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b26-20020a62a11a000000b00540a3252191sm19541622pff.28.2022.09.19.00.39.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 00:39:08 -0700 (PDT)
Message-ID: <2a419402-c9ed-02a4-cdf6-00395fffad47@gmail.com>
Date:   Mon, 19 Sep 2022 15:38:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220909104506.738478-1-eesposit@redhat.com>
 <YxtOEgJhe4EcAJsE@google.com>
 <5f0345d2-d4d1-f4fe-86ba-6e22561cb6bd@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <5f0345d2-d4d1-f4fe-86ba-6e22561cb6bd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/9/2022 12:13 am, Emanuele Giuseppe Esposito wrote:
> 
> Am 09/09/2022 um 16:30 schrieb Sean Christopherson:
>> On Fri, Sep 09, 2022, Emanuele Giuseppe Esposito wrote:
>>> KVM is currently capable of receiving a single memslot update through
>>> the KVM_SET_USER_MEMORY_REGION ioctl.
>>> The problem arises when we want to atomically perform multiple updates,
>>> so that readers of memslot active list avoid seeing incomplete states.
>>>
>>> For example, in RHBZhttps://bugzilla.redhat.com/show_bug.cgi?id=1979276

Oh, thanks for stepping up to try to address it.

As it turns out, this issue was discovered "long" before
https://bugzilla.kernel.org/show_bug.cgi?id=213781

As a comment, relevant selftests are necessary and required.
