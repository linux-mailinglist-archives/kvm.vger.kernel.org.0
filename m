Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAAB6369029
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 12:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241897AbhDWKPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 06:15:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55778 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230057AbhDWKPn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 06:15:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619172907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zU8xSHS0eLUV311ziEBewDcU/XJ05AOBQVWlp6b2OZI=;
        b=B2iXejhR/m9VD55ZdKEOEVBcWYhNkBvJdiAy8JbOROsM/YZYO8vVsBpleDbyalm8/tzJ0u
        GnXkn4C9KfxVAdikCn1PBzjzfeNQL1ig0bXxJerxFKX/K31uL5vi0RHYy9PAilJK3/Abdf
        KoSFk2ybkYRefx6Q/VYk1QysA+A8IrI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-ABUniwLINpOFz8X5M6JzRQ-1; Fri, 23 Apr 2021 06:15:05 -0400
X-MC-Unique: ABUniwLINpOFz8X5M6JzRQ-1
Received: by mail-ed1-f71.google.com with SMTP id n18-20020a0564020612b02903853320059eso9312817edv.0
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 03:15:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zU8xSHS0eLUV311ziEBewDcU/XJ05AOBQVWlp6b2OZI=;
        b=gTK6h/tfPwrbzPPduqe5yAntJRRSwu39G0Kq3YzYI6R8BXUWN0E/oY0hfV43qlY06d
         s4bcAUMv9lPwWjTWAV9fdt3bXRgqiw1ZgHdh5MIQynMBhx47HpK6xWVC0aTrLDfTC9lk
         TqoQ7Z7OS/j2hodaoHBXEXyS8CGrp1QExIUdye2QuuL37lkCEZkSIXIYzXCueZYuJmI7
         4QF/Q8kDscuBzSpcBBl8TqGdZ0ygWvmX3emR2d6s2wHkCs8J/eyoP0gG4qAflWdvc8KI
         +s8WtFxEcIN/fpdFZRCgqzPgUrr2hqwibmshe4qvS5cx5VyNvFRHiwtaSdmrUdGNvJDn
         42kQ==
X-Gm-Message-State: AOAM5320U3pHqgVfJTN5usVc2Ql369hi2iUL/qNyGTtIhbqbIT3NnIcL
        BDNlfvDKQOXQNVPS/s45E5/8lyxQTJxBcD3wI4S/5cqG3AMSQkHtDeqHpY3cwiPTNgSsnZg90Ko
        waii3rLO0XxRs
X-Received: by 2002:a17:906:1c83:: with SMTP id g3mr3431438ejh.93.1619172904416;
        Fri, 23 Apr 2021 03:15:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz32hxW6BwlqELQ71xlnrs8HZakqBtXQL7FatSt+SW5KA+zaUvrU624umIv9PYL0XNS2iW2rA==
X-Received: by 2002:a17:906:1c83:: with SMTP id g3mr3431406ejh.93.1619172904194;
        Fri, 23 Apr 2021 03:15:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p13sm3685996ejr.87.2021.04.23.03.15.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 03:15:03 -0700 (PDT)
To:     Alexander Graf <graf@amazon.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc:     Evgeny Iakovlev <eyakovl@amazon.de>, Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210423090333.21910-1-sidcha@amazon.de>
 <224d266e-aea3-3b4b-ec25-7bb120c4d98a@amazon.com>
 <213887af-78b8-03ad-b3f9-c2194cb27b13@redhat.com>
 <ded8db53-0e58-654a-fff2-de536bcbc961@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: hyper-v: Add new exit reason HYPERV_OVERLAY
Message-ID: <45888d26-89d2-dba6-41cb-de2d58cd5345@redhat.com>
Date:   Fri, 23 Apr 2021 12:15:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <ded8db53-0e58-654a-fff2-de536bcbc961@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/21 11:58, Alexander Graf wrote:
>> In theory userspace doesn't know how KVM wishes to implement the
>> hypercall page, especially if Xen hypercalls are enabled as well.
> 
> I'm not sure I agree with that sentiment :). User space is the one that 
> sets the xen compat mode. All we need to do is declare the ORing as part 
> of the KVM ABI. Which we effectively are doing already, because it's 
> part of the ABI to the guest, no?

Good point.  But it may change in the future based on KVM_ENABLE_CAP or 
whatever, and duplicating code between userspace and kernel is ugly.  We 
already have too many unwritten conventions around CPUID, MSRs, get/set 
state ioctls, etc.

That said, this definitely tilts the balance against adding an ioctl to 
write the hypercall page contents.  Userspace can either use the 
KVM_SET_MSR or assemble it on its own, and one of the two should be okay.

Paolo

>>
>> But userspace has two plausible ways to get the page contents:
>>
>> 1) add a ioctl to write the hypercall page contents to an arbitrary
>> userspace address
>>
>> 2) after userspace updates the memslots to add the overlay page at the
>> right place, use KVM_SET_MSR from userspace (which won't be filtered
>> because it's host initiated)
>>
>> The second has the advantage of not needing any new code at all, but
>> it's a bit more ugly.
> 
> The more of all of that hyper-v code we can have live in user space, the 
> happier I am :).

