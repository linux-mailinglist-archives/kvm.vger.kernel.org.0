Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476392D6476
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 19:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392743AbgLJSGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 13:06:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25303 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392780AbgLJSGr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 13:06:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607623520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=38b2aHumfg+RHL6XskHzjsc/L/nI/0Gd6ZGQlxYxxHM=;
        b=V7NppQiWfqS8kMpDFn49lxQP5UAPgjN+3T3gwY3SVY76V1feDldbDeHN6sCuTlcsTZlYh9
        nyNf9wh7yRgLS4LFFTo4O/kil8DWzlcvA5xAfv+PPtW/iC1DP3Ljz/k7o1urnJzYLqtWPT
        4rh61wWorwxhvjekps2JnLCKY2xa/uw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-yrEavJNBNZ2lKaPZz2TkwQ-1; Thu, 10 Dec 2020 13:05:18 -0500
X-MC-Unique: yrEavJNBNZ2lKaPZz2TkwQ-1
Received: by mail-ej1-f69.google.com with SMTP id u10so1898359ejy.18
        for <kvm@vger.kernel.org>; Thu, 10 Dec 2020 10:05:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=38b2aHumfg+RHL6XskHzjsc/L/nI/0Gd6ZGQlxYxxHM=;
        b=X5Gkqe1xlad0+SdlH0878ZjCm/jG6T0wFF5SNQ8ywKk1pye4NimbUbW+JT6jBKvIBz
         6K05MnYyH40CEF/jTxLOAJ6BFquzW2BwbvqwugMeITpHxRecaHSoHOgJNUQUqOQdx6LA
         UmFYdz04gvLG/el+SytSZdqmuKfbDEQfjfUJZnfb2uKCOW+Gy2baQo7qTk/5ZhWf4/kw
         PCNW8HmT0NcDioAzMnm5SXhyPSS1udFiaJnTjEb7/AautK0T84ju4L+/xXmdbamv1W/j
         7iwPa8w0m1+rQQyE4kVWtXFLKwAUxIie+lHif0Pk3aFHRpT7OI/F6YH7WUNJIDhrJP8i
         0LIw==
X-Gm-Message-State: AOAM532Nspy2L7nnIT/m0KrADRLYtMyJ1J5THEmHP6IlOf68daAeAOCq
        OJ4jRKpQC5GqOiTuG/cTQ5fSt+F+QFD9GDiSzHbK0GCybfckLcX0ZfncdOJaZ3+TwD593zjbiMi
        728WDEjUcBHKu
X-Received: by 2002:a50:e786:: with SMTP id b6mr7758318edn.242.1607623517513;
        Thu, 10 Dec 2020 10:05:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwgKk6eJFtLPuqCFcvy/3QeR5ZDZaVS3/9ky/rcrJfcfptZUk4xCwIvHkm7fi1iYvstgVtIog==
X-Received: by 2002:a50:e786:: with SMTP id b6mr7758300edn.242.1607623517335;
        Thu, 10 Dec 2020 10:05:17 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id k21sm5830209edq.26.2020.12.10.10.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 10:05:16 -0800 (PST)
Subject: Re: [PATCH v2 1/3] KVM: x86: implement KVM_{GET|SET}_TSC_STATE
To:     Oliver Upton <oupton@google.com>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
References: <9389c1198da174bcc9483d6ebf535405aa8bdb45.camel@redhat.com>
 <E4F263BE-6CAA-4152-8818-187D34D8D0FD@amacapital.net>
 <CAOQ_QshW0UvwSS3TUCK5PxkLQhHTqDNXNeMxwVDyf+DXc23fXQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <eb0cbfaa-251a-810b-3c12-4ee63d082bc8@redhat.com>
Date:   Thu, 10 Dec 2020 19:05:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAOQ_QshW0UvwSS3TUCK5PxkLQhHTqDNXNeMxwVDyf+DXc23fXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/20 18:59, Oliver Upton wrote:
> However, I don't believe we can assume the guest's TSCs to be synchronized,
> even if sane guests will never touch them. In this case, I think a per-vCPU
> ioctl is still warranted, allowing userspace to get at the guest CPU adjust
> component of Thomas' equation below (paraphrased):
> 
>          TSC guest CPU = host tsc base + guest base offset + guest CPU adjust

Right now that would be:

- KVM_GET_TSC_STATE (vm) returns host tsc base + guest base offset (plus 
the associated time)

- KVM_GET_MSR *without* KVM_X86_QUIRK_TSC_HOST_ACCESS for guest CPU adjust

and the corresponding SET ioctls.  What am *I* missing?

> Alternatively, a write from userspace to the guest's IA32_TSC_ADJUST with
> KVM_X86_QUIRK_TSC_HOST_ACCESS could have the same effect, but that seems to be
> problematic for a couple reasons. First, depending on the guest's CPUID the
> TSC_ADJUST MSR may not even be available, meaning that the guest could've used
> IA32_TSC to adjust the TSC (eww).

Indeed, the host should always be able to read/write IA32_TSC and 
IA32_TSC_ADJUST.

Thanks,

Paolo

> Second, userspace replaying writes to IA32_TSC
> (in the case IA32_TSC_ADJUST doesn't exist for the guest) seems_very_
> unlikely to work given all the magic handling that KVM does for
> writes to it.
> 
> Is this roughly where we are or have I entirely missed the mark?:-)

