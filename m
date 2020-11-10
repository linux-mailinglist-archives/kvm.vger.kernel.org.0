Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64ECC2ADB4C
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 17:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731348AbgKJQIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 11:08:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39545 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730182AbgKJQIl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Nov 2020 11:08:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605024519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J2Sf12kgoaoMwSO7zVui+rmBiPrlupwBdcBqb7pEUrA=;
        b=JRg00qQEvb8Eufd8f1sCHVRpOBaK2vJz4SoV0D6QZFTEy37fPuFAvX0Dl9I3Z2GzvtwZcI
        rnoKUXLT18tLyppMQ1yHu554qJ7PKlBRR/4HI5G5erLPGPxKy5DFN8k+jIyCj8wuxotIyR
        E/Nuv4ZaCW5KXUilywJxkQDdJMv6tGg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-lbsjEGKUM2e-pGFf-wqavg-1; Tue, 10 Nov 2020 11:08:38 -0500
X-MC-Unique: lbsjEGKUM2e-pGFf-wqavg-1
Received: by mail-wm1-f72.google.com with SMTP id s3so1458236wmj.6
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 08:08:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J2Sf12kgoaoMwSO7zVui+rmBiPrlupwBdcBqb7pEUrA=;
        b=Jh7qe/z/a6gNpYevobBVxwpYcnJCoydUJYEoHRfQsx5yV9bjM+SIQQXjln0UVIKUqH
         cVQYQ4z2Eqw9AcAqfyTL85Ra76Px9yWm228MLXt9LaTlr5ZeqG//f/mSg6BpKKO7CdvR
         UKPxNRnJ9gEWbkV9PUCe+7KQMAP/t2dGTO+9La89J6naY6QLrLjxgr1LqZHq5Id7HDvB
         80AOyIcMLfuzN0UPL/pt+CfsGguvZHuKbxeBXR5ya6QOyeR5fE2KpXtASIQERTsRRdGb
         bZT3PKCFVLIG9XgBb9d7q9WeWP8WfXaPdmBvdTDeg82hspZyjfX24l+LLh0v9TgxRPHJ
         baaQ==
X-Gm-Message-State: AOAM533drfsZ+l1mv6lqWJFbM122FuGvaRPvN9Wrzf35WexwDd/UwViS
        w7Zr9b9Tk0ujlBDrjXAiL4WWPGfD7H15ookL8S3hP2swRaUhwZYIC6xg94rU2kGqsPIvPBKuTab
        LRqPi3tagXHFTLukTdceQeabBCGyFcfjntVZPsHaEA2F2OYBxw4XiPH2ktGqmGLFT
X-Received: by 2002:a1c:7418:: with SMTP id p24mr459783wmc.36.1605024513784;
        Tue, 10 Nov 2020 08:08:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwX2bp8EAQvFHBwQTJhwBcQNIfAJv7DP1ceAp2mu/MJcNBhBYQdzSeyQiIFxUbOK4ZpE66t/Q==
X-Received: by 2002:a1c:7418:: with SMTP id p24mr459735wmc.36.1605024513477;
        Tue, 10 Nov 2020 08:08:33 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h128sm3524684wme.38.2020.11.10.08.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 08:08:32 -0800 (PST)
Subject: Re: [PATCH] x86/mce: Check for hypervisor before enabling additional
 error logging
To:     Borislav Petkov <bp@alien8.de>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        Jim Mattson <jmattson@google.com>, Qian Cai <cai@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>, x86 <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <160431588828.397.16468104725047768957.tip-bot2@tip-bot2>
 <3f863634cd75824907e8ccf8164548c2ef036f20.camel@redhat.com>
 <bfc274fc27724ea39ecac1e7ac834ed8@intel.com>
 <CALMp9eTFaiYkTnVe8xKzg40E4nZ3rAOii0O06bTy0+oLNjyKhA@mail.gmail.com>
 <a22b5468e1c94906b72c4d8bc83c0f64@intel.com>
 <20201109232402.GA25492@agluck-desk2.amr.corp.intel.com>
 <20201110063151.GB7290@nazgul.tnic>
 <094c2395-b1b3-d908-657c-9bd4144e40ac@redhat.com>
 <20201110095615.GB9450@nazgul.tnic>
 <b8de7f7b-7aa1-d98b-74be-62d7c055542b@redhat.com>
 <20201110155013.GE9857@nazgul.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1b587b45-a5a8-2147-ae53-06d1b284ea11@redhat.com>
Date:   Tue, 10 Nov 2020 17:08:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201110155013.GE9857@nazgul.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/20 16:50, Borislav Petkov wrote:
> I was thinking of
> having a mapping between f/m/s and a list of MSRs which those models
> have - even non-architectural ones - but that's a waste of energy. Why?
> Because using the *msr_safe() variants will give you the same thing

Yes, pretty much.

>> If it makes sense to emulate certain non-architectural MSRs we can add them.
> See above - probably not worth the effort.

When we do, certain Microsoft OSes are usually involved. :)

> I'll take a look at how ugly it would become to make the majority of MSR
> accesses safe.

I think most of them already are, especially the non-architectural ones, 
because I remember going through a similar discussion a few years ago 
and Andy said basically "screw it, let's just use *_safe anywhere" as 
well.  I don't see any need to do anything but add it to your review 
checklist if you have it (and do it now for MSR_ERROR_CONTROL).

Paolo

