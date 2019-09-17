Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C972B4FF5
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 16:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfIQOIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 10:08:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbfIQOIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 10:08:36 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 39AF981F25
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 14:08:36 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id c1so1357520wrb.12
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 07:08:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zo94M/S+0QMhxiiEtdJA09kaXmZqIlmiIBtzBP4Qi5Q=;
        b=fGonB6ubpnxwLMaRqqGS4rqfJiD9B/fQzkfrG5Eh077SULj+xbn/Hq6Ba9/E0jMOFC
         EP3c5HA6NbnlIbdaBlAN8pjSEwyYlDZsrm6psypkQlbbwOr9Ix3n0DFc+CmF6TDBtMFo
         pJBURJY4TKi1gVWqvLzR1w7COrMFJpjpdpJBBWxnjOZI3ybe/0taVCRn6hlCDUfOKgqd
         A+SoZ2gM35zNq9sFN+vSjLtjVLTnbvcjxOVuhIUB/JKiZxr1c6yRojm0F8DhzNRm1rfO
         WKZh3bJyFOxtdW2Ur+5/mfuRGB8ygBS2pqczdXWzooBMkYYLGTgN7PzU1qvHVYmcT+ki
         dQTw==
X-Gm-Message-State: APjAAAXJhXyw9RMgEhWDxMu3CfJK0Z3T7Ag1W7Z9QYUDYCDqiij0HdRz
        TAwVwzPWsnpk//xNq1nVa7h6hDxiIt8klq2I0L+kWzM0khYffkQlpPReuj1jWTTJxQQVcNX45gy
        SqLRYY/FQ2xMc
X-Received: by 2002:a5d:5005:: with SMTP id e5mr3115551wrt.79.1568729314711;
        Tue, 17 Sep 2019 07:08:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzwJyVSxT1tRPcoJlKjfzhaJKAAxzm8KWOT8E3UWBRupFvvr6hlcptMJiwcFHxzxq1OsrSzVw==
X-Received: by 2002:a5d:5005:: with SMTP id e5mr3115522wrt.79.1568729314447;
        Tue, 17 Sep 2019 07:08:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id l18sm2701304wrc.18.2019.09.17.07.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2019 07:08:34 -0700 (PDT)
Subject: Re: [PATCH 2/3] KVM: x86: hyper-v: set NoNonArchitecturalCoreSharing
 CPUID bit when SMT is impossible
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org,
        the arch/x86 maintainers <x86@kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Roman Kagan <rkagan@virtuozzo.com>
References: <20190916162258.6528-1-vkuznets@redhat.com>
 <20190916162258.6528-3-vkuznets@redhat.com>
 <CALMp9eRa0-HO+JWGDoAFO1zOtNjrutfT7d4pLxjsxn-XiAJwwQ@mail.gmail.com>
 <87ef0fb72x.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <fae07d28-e7de-1ed1-c6d4-513884a97c2f@redhat.com>
Date:   Tue, 17 Sep 2019 16:08:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87ef0fb72x.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/09/19 11:33, Vitaly Kuznetsov wrote:
> Jim Mattson <jmattson@google.com> writes:
> 
>> On Mon, Sep 16, 2019 at 9:23 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>>
>>> Hyper-V 2019 doesn't expose MD_CLEAR CPUID bit to guests when it cannot
>>> guarantee that two virtual processors won't end up running on sibling SMT
>>> threads without knowing about it. This is done as an optimization as in
>>> this case there is nothing the guest can do to protect itself against MDS
>>> and issuing additional flush requests is just pointless. On bare metal the
>>> topology is known, however, when Hyper-V is running nested (e.g. on top of
>>> KVM) it needs an additional piece of information: a confirmation that the
>>> exposed topology (wrt vCPU placement on different SMT threads) is
>>> trustworthy.
>>>
>>> NoNonArchitecturalCoreSharing (CPUID 0x40000004 EAX bit 18) is described in
>>> TLFS as follows: "Indicates that a virtual processor will never share a
>>> physical core with another virtual processor, except for virtual processors
>>> that are reported as sibling SMT threads." From KVM we can give such
>>> guarantee in two cases:
>>> - SMT is unsupported or forcefully disabled (just 'disabled' doesn't work
>>>  as it can become re-enabled during the lifetime of the guest).
>>> - vCPUs are properly pinned so the scheduler won't put them on sibling
>>> SMT threads (when they're not reported as such).
>>
>> That's a nice bit of information. Have you considered a mechanism for
>> communicating this information to kvm guests in a way that doesn't
>> require Hyper-V enlightenments?
>>
> 
> (I haven't put much thought in this) but can we re-use MD_CLEAR CPUID
> bit for that? Like if the hypervisor can't guarantee usefulness
> (e.g. when two random vCPUs can be put on sibling SMT threads) of
> flushing, is there any reason to still make the guest think the feature
> is there?

Yes, that's a good idea.

Paolo
