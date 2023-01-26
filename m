Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E864967D37D
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 18:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbjAZRso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 12:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbjAZRsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 12:48:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF0822A0E
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 09:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674755273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nr3flWHXbUAsZEmbiKK8RDAuSq8Y/JdJBz6u6YpVkyg=;
        b=G8gNUsX1UZP6au9rd/8BESzgIL6E2NRV5ilMc/7Bf2e6o8ID0eDXymhbiNOnOVFICFfQZX
        YpdOqYUbhhYnciOMTRN/ni+mICNlpVjN7UZYxtvWP0PBFwE33Re+V0+UmlfTmOlbmgAzNv
        MrJqrYx2HyQE21oYZpVgs0hM7ylOrJA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-100-Yth15kjxPgm5pdIZ35YqBw-1; Thu, 26 Jan 2023 12:47:52 -0500
X-MC-Unique: Yth15kjxPgm5pdIZ35YqBw-1
Received: by mail-ej1-f69.google.com with SMTP id nc27-20020a1709071c1b00b0086dae705676so1724001ejc.12
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 09:47:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nr3flWHXbUAsZEmbiKK8RDAuSq8Y/JdJBz6u6YpVkyg=;
        b=aeZiWlCriqG0SqKyiZ8s0S9LrE4E9qeW/C7uaeGs/Ab841fw8LCUbtNsBJSqOiauwL
         OKluM4128GG+PSs4fc52DmBgCPUtT/KqHz8pQpiyRz85mUtOMDzgRtJ2BtTm6bFmzVlc
         FU501Fae7rdV2ii9hDTND7Bj6IiNKc8iBTZzVlrUCcZBzb826AtqeKS1fjw/3vrDIowx
         J3YOX5EJQvmT4rDsx01hwslndNXSSjEg+HttWA6XVYUAm5TjP34GnGuMtiypDscEMDFG
         JmOCo4V46uwF16M50huxOZ/UZn6qnxuU0QfkWIecd9w1DD6TTkBnDVZo4QiR3ajAe81T
         ZVFg==
X-Gm-Message-State: AFqh2kpXgdyEXwc6ylZqgWSQSgAWoGPokqVTKx2Hr5yabjPU2TVSJEDk
        4nOsInCBqk1mq4yZ3LwXSZivSQTDeEfidO3IMtrqKZLcssA2GP0MWUwSjE4OHs9RuzX70+73kcc
        c2VxjJcn91pbo
X-Received: by 2002:a17:907:8c14:b0:84c:e9c4:5751 with SMTP id ta20-20020a1709078c1400b0084ce9c45751mr40100921ejc.74.1674755271031;
        Thu, 26 Jan 2023 09:47:51 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsWPUbMj5DHa+3wZZhr6rEgHS9w6VlREbdPPjsEZW7Qt+zJC0DfHkxXTvhooqeznJf3adRxwQ==
X-Received: by 2002:a17:907:8c14:b0:84c:e9c4:5751 with SMTP id ta20-20020a1709078c1400b0084ce9c45751mr40100911ejc.74.1674755270816;
        Thu, 26 Jan 2023 09:47:50 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id f17-20020a1709064dd100b0087853fbb55dsm892986ejw.40.2023.01.26.09.47.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 09:47:50 -0800 (PST)
Message-ID: <b3820c5c-370b-44f1-7dac-544e504bc61a@redhat.com>
Date:   Thu, 26 Jan 2023 18:47:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2] KVM: x86: Do not return host topology information from
 KVM_GET_SUPPORTED_CPUID
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, stable@vger.kernel.org
References: <20221027092036.2698180-1-pbonzini@redhat.com>
 <CALMp9eQihPhjpoodw6ojgVh_KtvPqQ9qJ3wKWZQyVtArpGkfHA@mail.gmail.com>
 <3a23db58-3ae1-7457-ed09-bc2e3f6e8dc9@redhat.com>
 <CALMp9eQ3wZ4dkq_8ErcUdQAs2F96Gvr-g=7-iBteJeuN5aX00A@mail.gmail.com>
 <8bdf22c8-9ef1-e526-df36-9073a150669d@redhat.com>
 <CALMp9eRKp_4j_Q0j1HYP2itT2+z3pRotQK8LwScMsaGF5FpARA@mail.gmail.com>
 <dec8c012-885a-6ed8-534e-4a5f0a435025@redhat.com>
 <CALMp9eSyVWGS2HQVwwwViE6S_uweiOiFucqa3keuoUjNz9rKqA@mail.gmail.com>
 <f322cce0-f83a-16d9-9738-f47f265b41d8@redhat.com>
 <CALMp9eTpbwQP3QsqpOBsDb0soLpsv9FZA=ivZUmf2GJgBxhfmw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eTpbwQP3QsqpOBsDb0soLpsv9FZA=ivZUmf2GJgBxhfmw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/23 17:06, Jim Mattson wrote:
>>> Sadly, there isn't a single kernel involved. People running our VMM on
>>> their desktops are going to be impacted as soon as this patch hits
>>> that distro. (I don't know if I can say which distro that is.) So, now
>>> we have to get the VMM folks to urgently accommodate this change and
>>> get a new distribution out.
>>
>> Ok, this is what is needed to make a more informed choice.  To be clear,
>> this is _still_ not public (for example it's not ChromeOS), so there is
>> at least some control on what version of the VMM they use?  Would it
>> make sense to buy you a few months by deferring this patch to Linux 6.3-6.5?
> 
> Mainline isn't a problem. I'm more worried about 5.19 LTS.

5.19 is not LTS, is it?  This patch is only in 6.1.7 and 6.1.8 as far as 
stable kernels is concerned, should I ask Greg to revert it there?

Paolo

