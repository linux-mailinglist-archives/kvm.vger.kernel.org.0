Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7447E7BA04
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 08:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfGaG6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 02:58:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36731 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfGaG6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 02:58:13 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so68435964wrs.3
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 23:58:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qU9tOJPiFi8TuJFj6AQwXvcoVLt8SoI2Z+8B3y84t18=;
        b=IiUobzJzPgQ6ajimJd0x+QTVeBiiX7bykMCS8U6Mf8py1skuZB0iDxuZJkscm8modq
         qrseTuSi7j6MGAji7SiKyMu5IGl2z1X6m3VrkVR0XQCyWVyu93Vk34LcDq0nkiqZHdwq
         DWunLA86CX0UrVJiVo0OsQ9yiIh72furreNh0HkG1zHqmlU5vMtsjEpfZEbMvD7VDPae
         4M6fwuKknEr79En8+ry7VwSJ6++F5rYRBgUQFfvjXqVBL70IlaHZBMWhk6XU095CAlZR
         fz6ZB8Z0oLXnvdwK65p6W6zwkKahFn0bziFIvYOqvJbcXwRQEeiL7kuVnUVfkL4KAioW
         GDvA==
X-Gm-Message-State: APjAAAU9HoUkZ+6bOD5ic/mDiK9l/tBFGvLjXMC+rTLSesNVg8FlQMHS
        BOE6Jc4ZTPxoyFpWFKdAZj8Bd9WALwc=
X-Google-Smtp-Source: APXvYqzku30fKv86lxvZXAIuXhHFW1nsc4OVmn/VRSfl4N2bSyp3UlDAsp9RpZGVF8OvZNUqcVv2kg==
X-Received: by 2002:a05:6000:1043:: with SMTP id c3mr79068480wrx.236.1564556291018;
        Tue, 30 Jul 2019 23:58:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91e7:65e:d8cd:fdb3? ([2001:b07:6468:f312:91e7:65e:d8cd:fdb3])
        by smtp.gmail.com with ESMTPSA id t140sm1471116wmt.0.2019.07.30.23.58.09
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 23:58:10 -0700 (PDT)
Subject: Re: [RFC PATCH 13/16] RISC-V: KVM: Add timer functionality
To:     Atish Patra <Atish.Patra@wdc.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "palmer@sifive.com" <palmer@sifive.com>,
        Anup Patel <Anup.Patel@wdc.com>
Cc:     "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "anup@brainfault.org" <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20190729115544.17895-1-anup.patel@wdc.com>
 <20190729115544.17895-14-anup.patel@wdc.com>
 <abedb067-b91f-8821-9bce-d27f6c4efdee@redhat.com>
 <7fe9e845c33e49e4c215e12b1ee1b5ed86a95bc1.camel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0be68aeb-06de-71c7-375e-95f82112dae1@redhat.com>
Date:   Wed, 31 Jul 2019 08:58:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <7fe9e845c33e49e4c215e12b1ee1b5ed86a95bc1.camel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/19 03:55, Atish Patra wrote:
> On Tue, 2019-07-30 at 13:26 +0200, Paolo Bonzini wrote:
>> On 29/07/19 13:57, Anup Patel wrote:
>>> +	if (delta_ns > VCPU_TIMER_PROGRAM_THRESHOLD_NS) {
>>> +		hrtimer_start(&t->hrt, ktime_add_ns(ktime_get(),
>>> delta_ns),
>>
>> I think the guest would prefer if you saved the time before enabling
>> interrupts on the host, and use that here instead of ktime_get().
>> Otherwise the timer could be delayed arbitrarily by host interrupts.
>>
>> (Because the RISC-V SBI timer is relative only---which is
>> unfortunate---
> 
> Just to clarify: RISC-V SBI timer call passes absolute time.
> 
> https://elixir.bootlin.com/linux/v5.3-rc2/source/drivers/clocksource/timer-riscv.c#L32
> 
> That's why we compute a delta between absolute time passed via SBI and
> current time. hrtimer is programmed to trigger only after the delta
> time from now.

Nevermind, I got lost in all the conversions.

One important issue is the lack of ability to program a delta between
HS/HU-mode cycles and VS/VU-mode cycles.  Without this, it's impossible
to do virtual machine migration (except with hcounteren
trap-and-emulate, which I think we agree is not acceptable).  I found
the open issue at https://github.com/riscv/riscv-isa-manual/issues/298
and commented on it.

Paolo
