Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DDD41B4A2
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 19:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241948AbhI1RBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 13:01:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36442 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241937AbhI1RBq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 13:01:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632848406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XHmQkL+t1hn9bNMzRjhxH5e06VgDwe5vVOI99NJ41VU=;
        b=dXyld5l7a+FSclBMEaGSFvUhZ4eDR+CIXin6Srdj9Gk0AokSL/ugzC1WVliWAL4KxkwDFx
        6g3u+Ar16q/f3+lGwsyfootjA4/HJEzjUcs8bjGEAm838B31LlOtaTDugU6ehxe1/YepOu
        THUAjd8iHGXkYOtfEK0YbZW5r21iAnY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-b23zjFLVNleP397qXUpnbQ-1; Tue, 28 Sep 2021 13:00:04 -0400
X-MC-Unique: b23zjFLVNleP397qXUpnbQ-1
Received: by mail-ed1-f69.google.com with SMTP id w8-20020a50f108000000b003da70d30658so8755987edl.6
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 10:00:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XHmQkL+t1hn9bNMzRjhxH5e06VgDwe5vVOI99NJ41VU=;
        b=ag1J2ZOxqxfG7fk8sB2BBnStYInRig3+iCS5J3Zf2+q1OqDMHBaSWB1r+7vBHabJ2u
         bvCGGorGsJ3Goqu1tqOthjB2ZVyX/dwj9sLrofXogJxL/uSP8eMOGHBTazcHcRiZSCoR
         dcnAa7JdLePkmsYXlMMlM2Cnl1Av7Z2rbEzRt5/iK61Dp22eJ+qKYBq3HxMH5xx5z5Zh
         twkVKEbAJgN2O/p6GXhQRaQrhLDo5ywPWBgarcrt2XagW6qjctew//HXkRegXmhBCSe+
         u88W//2NLtmI5KJseKMb4cV1lx+VWAmntziRH+SfF9fPQSo7VPc++eGwodSd2EL260gS
         5YMA==
X-Gm-Message-State: AOAM532FrLG3pB8JbVV9nvMLEezyqtd/7QQpZtrGZfqCeaTmiHA5406Q
        +8lezTyXrHOAtCGjIIV2hVCVSXlkifM/0yHhIomTXrfe50i+C1t+MGccsPVbCVJAO+XHFZa5on0
        nAT1H9d1P/jL9
X-Received: by 2002:a17:907:7ba8:: with SMTP id ne40mr3981962ejc.517.1632848403454;
        Tue, 28 Sep 2021 10:00:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6tKIsCCUt9TxrFDO6yShTBPwBWa6pspy4jimhCeN64wkjbPt6rRgfyr3JVQdYrTFGFFBEQA==
X-Received: by 2002:a17:907:7ba8:: with SMTP id ne40mr3981943ejc.517.1632848403295;
        Tue, 28 Sep 2021 10:00:03 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 6sm10922163ejx.82.2021.09.28.10.00.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 10:00:02 -0700 (PDT)
Message-ID: <b17c4613-5e29-8170-c42b-125dc66b1dc1@redhat.com>
Date:   Tue, 28 Sep 2021 19:00:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 0/2] KVM: x86: skip gfn_track allocation when possible
Content-Language: en-US
To:     David Stevens <stevensd@chromium.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
References: <20210922045859.2011227-1-stevensd@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210922045859.2011227-1-stevensd@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/21 06:58, David Stevens wrote:
> From: David Stevens<stevensd@chromium.org>
> 
> Skip allocating gfn_track arrays when tracking of guest write access to
> pages is not required. For VMs where the allocation can be avoided, this
> saves 2 bytes per 4KB of guest memory.
> 
> Write tracking is used to manage shadow page tables in three cases -
> when tdp is not supported, when nested virtualization is used, and for
> GVT-g. If tdp_enable is set and the kernel is compiled without GVT-g,
> then the gfn_track arrays can be allocated lazily when the shadow MMU is
> initialized.
> 
> v1 -> v2:
>   - lazily allocate gfn_track when shadow MMU is initialized, instead
>     of looking at cpuid

Queued, thanks.

paolo

