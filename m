Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE4E447CBF
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 10:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbhKHJ26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 04:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236707AbhKHJ25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 04:28:57 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D537CC061570;
        Mon,  8 Nov 2021 01:26:13 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id o4so1339228pfp.13;
        Mon, 08 Nov 2021 01:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=QE1/LJ1LNaoIh5WC5o6lUyTF2BVqDSPHbnIHEa4a38U=;
        b=hW+PS6QiQtD52Ow2QcH51gY/LAwHZBV0f0bBgo59mjcbBBRZneIZK9FON+hamrjNh9
         R7v5lDORvqzCyUv6mdsoWGPS8M8hVs7RXueOtC9fr/4CNEqbfhmW+vFGD+qGFEu2B/0y
         O7gV00N+wuBIrRQ0Kki2AV//LSx82Uz06fAfwdszAZSzr3KAhXWMfbsocc76OtrR3r/Q
         o6unvErJ2erL9AKfcZmLWs6m3z5wPx5I/cqsiMt3Tbdjhf3OVYZqOISxvawaPVsqSiDN
         r4IpgjPrpJfopZchOkvenJAeO20aifzVndDNlr1UfE6dSwE1R9OnOPwkrtTamMg/F4mT
         5sGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=QE1/LJ1LNaoIh5WC5o6lUyTF2BVqDSPHbnIHEa4a38U=;
        b=zZ7EhjE44oiFq3XrTLCwFLleP6+nmyKU+5JX2YGdXcVKAFvdhweI/8iW/uXTmbSs/0
         42YPPj1Y5JZpEOqgTiX0mZ2J2t55t+WOcXsRKj6gcZiq8mwn+r+XBWSOUAU3GIw8NUhj
         YYj4YXoaG4U2VTqODD1tJAC3nrl2QGaV4T6F4d706SjxqIeq//7ExZ0Mpl0pP/bdDh3a
         cwy25FRxfk9Y37B57Qm4NnS8863IoKAS4XXObNCXvpQ/CZyDquBtKPBrqqvApfp2i5dm
         E5WnYqFzXitTQ/8jiBTIVQIvazyd6etdGx4WsqYruSPG74dzuDIu1lUL3h+hMFv00Snd
         gFzg==
X-Gm-Message-State: AOAM531y8z0z+EQH3ulyFZQIBjvyDNnK0ecodGjK5KjpQkJBCojRHeT6
        gNCojoqX5jIirFTJMixIDrs=
X-Google-Smtp-Source: ABdhPJx7uTPC4ka3w/9lfsh7EkVysoC8V4ZbJBD7RgsYYW+QXcrI/xypVTajANZ7P4zbBo+OTa2/AA==
X-Received: by 2002:a63:82c7:: with SMTP id w190mr41967446pgd.13.1636363573293;
        Mon, 08 Nov 2021 01:26:13 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mg12sm15565714pjb.10.2021.11.08.01.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 01:26:13 -0800 (PST)
Message-ID: <583a2f1b-1ac8-0a30-1b0a-e541ce739448@gmail.com>
Date:   Mon, 8 Nov 2021 17:26:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 1/3] KVM: x86: Copy kvm_pmu_ops by value to eliminate
 layer of indirection
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211103070310.43380-1-likexu@tencent.com>
 <20211103070310.43380-2-likexu@tencent.com> <YYVODdVEc/deNP8p@google.com>
 <YYVPkxVeQO4VFGCZ@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <YYVPkxVeQO4VFGCZ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/11/2021 11:36 pm, Sean Christopherson wrote:
> On Fri, Nov 05, 2021, Sean Christopherson wrote:
>> On Wed, Nov 03, 2021, Like Xu wrote:
>> I would also say land this memcpy() above kvm_ops_static_call_update(), then the
>> enabling patch can do the static call updates in kvm_ops_static_call_update()
>> instead of adding another helper.
> 
> Ugh, kvm_ops_static_call_update() is defined in kvm_host.h.  That's completely
> unnecessary, it should have exactly one caller, kvm_arch_hardware_setup().  As a
> prep match, move kvm_ops_static_call_update() to x86.c, then it can reference the
> pmu ops.

Quite good and thank you.


