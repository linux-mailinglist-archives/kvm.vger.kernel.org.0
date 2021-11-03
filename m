Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C644441A4
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 13:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhKCMhx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 08:37:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54578 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231903AbhKCMhx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 08:37:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635942916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=icJ6gd+79rtqILLZuH41AKUvEAmXaJaaYs7riANmljc=;
        b=GnbEbnjnNXnoZx4gxMns/5d+POqqvzcNclCle223R7M6DSQSPq5DyJAQ68LpEFdnZFc6W6
        MRSpCoo+2KNpn3hZWlBhx2PJBAhYYzQM8ngN35CYV4t/YV0tqdKa4FLlUzWxf37o2lvhfU
        mYVyzVvg/km8VaXcUS+tlAKfMUgIX0Y=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-0YQAl3rzPoOEgbisyR_7VA-1; Wed, 03 Nov 2021 08:35:15 -0400
X-MC-Unique: 0YQAl3rzPoOEgbisyR_7VA-1
Received: by mail-ed1-f71.google.com with SMTP id i9-20020a508709000000b003dd4b55a3caso2302455edb.19
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 05:35:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=icJ6gd+79rtqILLZuH41AKUvEAmXaJaaYs7riANmljc=;
        b=TeW4o3ePqjDYhT7RjG4b1Mfa/jqJsonaNTHAQPQflvy/4liy4GpAI9hGC847b2c8/H
         ijs0m1uN3j/KXh9jE9KmfYYKVAU2/Dcvi/Gornmw20u4FafC8hm4YAiU0ZvWxdTNGKIr
         7r/hRvTPi2cMbcdodM7MFHqx2ETuOAjhKmeMwxl/rdhyWjSmmy4eQDTkHry4/F/Re4Ol
         gaN6A7i5MyY/RRuCo6JiZV0Rp9OXo5moMzLgs6ZRgIVQGI1HKq/jikif0lsZBRmSl5mw
         t/9LlNqSLGuyVuXd9ev7C27bTjQ6B1dkNKg57tZHisUavXUG0Th5nAYHQmRAijt5B9hH
         0yCg==
X-Gm-Message-State: AOAM531fbg1Y21qJrk/weiu3vsc8lZMZSArhUyuP3MklsNnOUhvzBxek
        NUFSNJzYQME6I0iMYvzRKuJTthdr2PPXkUzF4C852U8iVdW4DBgqMAqLmSzacL5ZWYe0UxbBNCG
        NkIHks+QKJeYu
X-Received: by 2002:aa7:d613:: with SMTP id c19mr30237381edr.109.1635942914185;
        Wed, 03 Nov 2021 05:35:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEY/6vPMQ1QwIjV5dnziCoxUiuOa+gs9+FSryyA+5b/PrbWibJheKXAw6VCIgNqAqrxxJo6w==
X-Received: by 2002:aa7:d613:: with SMTP id c19mr30237345edr.109.1635942913933;
        Wed, 03 Nov 2021 05:35:13 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u14sm1274607edj.74.2021.11.03.05.35.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 05:35:12 -0700 (PDT)
Message-ID: <e05809f3-46fa-8fdf-642d-66821465456e@redhat.com>
Date:   Wed, 3 Nov 2021 13:35:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2] KVM: x86: Fix recording of guest steal time /
 preempted status
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
References: <5d4002373c3ae614cb87b72ba5b7cdc161a0cd46.camel@infradead.org>
 <4369bbef7f0c2b239da419c917f9a9f2ca6a76f1.camel@infradead.org>
 <624bc910-1bec-e6dd-b09a-f86dc6cdbef0@redhat.com>
 <0372987a52b5f43963721b517664830e7e6f1818.camel@infradead.org>
 <1f326c33-3acf-911a-d1ef-c72f0a570761@redhat.com>
 <E4C6E3D6-E789-4F0A-99F7-554A0F852873@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <E4C6E3D6-E789-4F0A-99F7-554A0F852873@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/21 10:47, David Woodhouse wrote:
> Sorry, it took me a while to realise that by "above comment" you mean
> the original commit comment (which you want me to reword) instead of
> just what I'd said in my previous email. How about this version? If
> it's OK like this then I can resubmit later today when I get back to
> a proper keyboard.

No need to resubmit, thanks!  I'll review the code later and decide 
whether to include this in 5.16 or go for the "good" solution in 5.16 
and submit this one for 5.15 only.

Paolo

