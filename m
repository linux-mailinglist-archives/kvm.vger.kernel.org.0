Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5592D59B3
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 12:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgLJLuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 06:50:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39940 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728808AbgLJLuI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 06:50:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607600921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S1cqRGAPZ7tEyP9tZX4DdUYMRy3eYwTTW4lAfMAIl0U=;
        b=eKOm5TpIWBf7WgUoYXclkTwWy7hacnIA2bazirFCQLZpjW5wsFKTjB2FMqF3344/ibj8MK
        +5OkZoDN0WTjouoq7/xfUNIoSXhiybE0LIUtWGy3A1Ugin0+zZs1ecUOpjHSkcX4s9F4j8
        /mJmvun3HSlcVWpOLJSoXNsM9GuYAXA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-XxwsLfXeOiSiImei-sBaXg-1; Thu, 10 Dec 2020 06:48:40 -0500
X-MC-Unique: XxwsLfXeOiSiImei-sBaXg-1
Received: by mail-ed1-f72.google.com with SMTP id a9so2339707edy.8
        for <kvm@vger.kernel.org>; Thu, 10 Dec 2020 03:48:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S1cqRGAPZ7tEyP9tZX4DdUYMRy3eYwTTW4lAfMAIl0U=;
        b=CB8Fj974pIkJCGATa+wWfiSIeaJiE1te0eRR40SFjJQf/JYjTwelq86XowmiXpdISJ
         DOhfwBYc3p+Q6adz+c2nYPTAsJMsV3aVfv+CwMUlK6xZ0H+cJhqYHmp9e2Y93typEzkG
         Vwxb37NIqR4xJf3s1p7yUYXbfCqWSTgQwJTQSARXoTubTFlFBPGL7U8U+jke1OkAMwOA
         SE/yUbXeQaWdTTA9/qXeYYdAxV/d4tfkU9F+fu8ZR6ny1SnNcnqxVS5ZCMq9hcyBooVA
         +zvaGakcoZs5g0JGz9QHTcJ+uEP+Y8sekWM/5aSiE7F7mNqGdUcTttcdU7MSzzL/TNw9
         k78g==
X-Gm-Message-State: AOAM533bDU8LDF7qv3rl2ypYRWRbH10xVVjAynd6Y0C+NK0CRiFbZeVn
        V/EM0S/R/ZgAgfzPLz2RwgfocZ/xROKsl2v1FJE/jAqpF/IIPOIzzbOzCFVNGPuMz34ntPvObD8
        38ofLzmZwbyz2
X-Received: by 2002:a17:906:1e0c:: with SMTP id g12mr6163973ejj.115.1607600918813;
        Thu, 10 Dec 2020 03:48:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyB1pH5eIBmIOmgLLK8HLkGQLR9KY10/es9c1MjQzaruXTof/K9wc6bX6AIrPVAFDaTCBimbA==
X-Received: by 2002:a17:906:1e0c:: with SMTP id g12mr6163955ejj.115.1607600918641;
        Thu, 10 Dec 2020 03:48:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id q26sm4127282ejt.73.2020.12.10.03.48.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 03:48:37 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
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
        Oliver Upton <oupton@google.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
References: <20201203171118.372391-1-mlevitsk@redhat.com>
 <20201203171118.372391-2-mlevitsk@redhat.com>
 <20201207232920.GD27492@fuller.cnet>
 <05aaabedd4aac7d3bce81d338988108885a19d29.camel@redhat.com>
 <87sg8g2sn4.fsf@nanos.tec.linutronix.de>
 <6f64558a029574444da417754786f711c2fec407.camel@redhat.com>
 <87blf42dvv.fsf@nanos.tec.linutronix.de>
Subject: Re: [PATCH v2 1/3] KVM: x86: implement KVM_{GET|SET}_TSC_STATE
Message-ID: <70f9a5b3-d912-2a46-3718-a9c7591cd1f4@redhat.com>
Date:   Thu, 10 Dec 2020 12:48:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87blf42dvv.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/12/20 22:20, Thomas Gleixner wrote:
> 
> So now life migration comes a long time after timekeeping had set the
> limits and just because it's virt it expects that everything works and it
> just can ignore these limits.
> 
> TBH. That's not any different than SMM or hard/firmware taking the
> machine out for lunch. It's exactly the same: It's broken.

I agree.  If *live* migration stops the VM for 200 seconds, it's broken.

Sure, there's the case of snapshotting the VM over the weekend.  My 
favorite solution would be to just put it in S3 before doing that.  *Do 
what bare metal does* and you can't go that wrong.

In general it's userspace policy whether to keep the TSC value the same 
across live migration.  There's pros and cons to both approaches, so KVM 
should provide the functionality to keep the TSC running (which the 
guest will see as a very long, but not extreme SMI), and this is what 
this series does.  Maxim will change it to operate per-VM.  Thanks 
Thomas, Oliver and everyone else for the input.

Paolo

