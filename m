Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5B9159010
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgBKNe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:34:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24607 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728169AbgBKNeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:34:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581428057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZVpv74UeZElPwmXt341gqDCIg9n10+IYxreY2XfSR7o=;
        b=E2Yt3CFwlIoFSb1juWZWMrN08qJ0qF7KTGRV90C5t9DEuwaCIRkmEE38gLtA74EFOdXZGh
        OKzIVxFCYDcv67B+6ysQtMpl8YqCyHwMr+BkTD32BVgSFNR8Z6nLKlP3ESYqbUwAgf7k3Q
        QOvY27Ds2H7KXHbDFuNx3OTyXxebZjs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-8eJfNOWMPVKzKfe0Tkgmgg-1; Tue, 11 Feb 2020 08:34:15 -0500
X-MC-Unique: 8eJfNOWMPVKzKfe0Tkgmgg-1
Received: by mail-wr1-f72.google.com with SMTP id t6so6883065wru.3
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 05:34:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZVpv74UeZElPwmXt341gqDCIg9n10+IYxreY2XfSR7o=;
        b=pL9O538maBd+q6QSpJ2uHYYHCjZXfPLccDYKMTCuDjYoP+rxSuV2Y07hszfeVJ6plg
         dxlZuQKvDoQmOC3mVPkWEVKctr4IIUHDqWabyrPS31zGisp+k6C1GfsR3y9BJXnSNtqD
         eL/3/i3fyBdViKfvpB2BUeok3pkSuMCYGrh0MHMN6tG5mj1iIUUex29zQCsnWSeS62rW
         aBByQZFbBNlLk0+w6Z6xAT2btTrfiv3WIukS0DMe40MjwgSAzoI5WtxuKghMx/kNGrVN
         hgPyyUX9Lj98VMNXHZPcMowQYDMAcNw/uxfgeJT0fZwo+LnWfLpxO9IVpro+pF0Fb6jX
         Kiqw==
X-Gm-Message-State: APjAAAVXEVEdjGvhnlQxu2tL8S4j5zalGFBywgMFy0Ywxugp1MJWNb0r
        8V1NQng8JYJELMDxiUlJEhBXw2flityuDOY9s5phBH506Tibkkl8U/HSwLnGaboqqE1kZVyMADq
        QbEufkAGa5RYp
X-Received: by 2002:a05:6000:50:: with SMTP id k16mr8245407wrx.145.1581428054197;
        Tue, 11 Feb 2020 05:34:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqxQg7pOc18gHn8GIarYbHg6cXUxmcv+NXJfVagkH7DlWVbigAr5O/HyU8hGdLlVvhSwg7I/lA==
X-Received: by 2002:a05:6000:50:: with SMTP id k16mr8245385wrx.145.1581428053838;
        Tue, 11 Feb 2020 05:34:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:bd91:9700:295f:3b1e? ([2001:b07:6468:f312:bd91:9700:295f:3b1e])
        by smtp.gmail.com with ESMTPSA id b10sm5167510wrw.61.2020.02.11.05.34.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 05:34:13 -0800 (PST)
Subject: Re: [PATCH v2 3/6] kvm: x86: Emulate split-lock access as a write
To:     Thomas Gleixner <tglx@linutronix.de>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Laight <David.Laight@aculab.com>
References: <20200203151608.28053-1-xiaoyao.li@intel.com>
 <20200203151608.28053-4-xiaoyao.li@intel.com>
 <95d29a81-62d5-f5b6-0eb6-9d002c0bba23@redhat.com>
 <878sl945tj.fsf@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d690c2e3-e9ef-a504-ede3-d0059ec1e0f6@redhat.com>
Date:   Tue, 11 Feb 2020 14:34:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <878sl945tj.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/02/20 14:22, Thomas Gleixner wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
>> On 03/02/20 16:16, Xiaoyao Li wrote:
>>> A sane guest should never tigger emulation on a split-lock access, but
>>> it cannot prevent malicous guest from doing this. So just emulating the
>>> access as a write if it's a split-lock access to avoid malicous guest
>>> polluting the kernel log.
>>
>> Saying that anything doing a split lock access is malicious makes little
>> sense.
> 
> Correct, but we also have to accept, that split lock access can be used
> in a malicious way, aka. DoS.

Indeed, a more accurate emulation such as temporarily disabling
split-lock detection in the emulator would allow the guest to use split
lock access as a vehicle for DoS, but that's not what the commit message
says.  If it were only about polluting the kernel log, there's
printk_ratelimited for that.  (In fact, if we went for incorrect
emulation as in this patch, a rate-limited pr_warn would be a good idea).

It is much more convincing to say that since this is pretty much a
theoretical case, we can assume that it is only done with the purpose of
DoS-ing the host or something like that, and therefore we kill the guest.

>> Split lock detection is essentially a debugging feature, there's a
>> reason why the MSR is called "TEST_CTL".  So you don't want to make the
> 
> The fact that it ended up in MSR_TEST_CTL does not say anything. That's
> where they it ended up to be as it was hastily cobbled together for
> whatever reason.

Or perhaps it was there all the time in test silicon or something like
that...  That would be a very plausible reason for all the quirks behind it.

Paolo

