Return-Path: <kvm+bounces-25883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 63C5596BE70
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 15:26:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1E0F1F2450A
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 453481DA633;
	Wed,  4 Sep 2024 13:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J+Q9v2NS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DFB1DA2E4
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 13:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725456364; cv=none; b=CTyd6fF3F7xls1+45SDUp003xiD4Ki+3QGkOEdAA6sv6XyaBnz9Q9vndlWs3nRmMV3J+/QhDzQbY44RxMrwgISHPajZcwXjnsubXluwiZuirWYea5l+ZtyIJLtLhvLD511xj5UypLO4m7Eo7cgMJYzQ5TCENimdasc5ybV3kaK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725456364; c=relaxed/simple;
	bh=fV02eram5SAlbEuGwmDuQ+se3z089NuDaBoBuGLrODk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sAXC73dVqDWb9actakHoQXY7RwGJgbG9VAZskPrWYkaehy96CFCJzZapBUqlxsIZZN57IQ37374iJUbit3xbWQql90azWZ9/e1gvmKsdGJsvnU2/wwBPnP4c5g9UvecCecqJzzz/f0EgKSFaLbBXKmh1vSbF5S0fDwf65VJ7YlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J+Q9v2NS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725456361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8SNhHCBduhr9H1n14OffkTff0HidGminGrYHFT9HiFw=;
	b=J+Q9v2NSvOtrFByYjzdRNGnof+2oN6hiBXZyHLC3vGk+MHcMKj3rPVNxF5JbgtEt5jOnP/
	DpdSAdT4Ohan8ipAjzDQZ8fudHWoHmxFxJVSV2sM1084QlbAfPh1uHKqY7zbQpv58CLsJC
	hF96VBaCyic2LR6HH/d6R5Lr0ONkS8U=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-mWlLqZjhOnWPRCLRH0Gndg-1; Wed, 04 Sep 2024 09:26:00 -0400
X-MC-Unique: mWlLqZjhOnWPRCLRH0Gndg-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a8691010836so500925466b.2
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 06:26:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725456359; x=1726061159;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8SNhHCBduhr9H1n14OffkTff0HidGminGrYHFT9HiFw=;
        b=gM3iN7vfTE7/Xo5l4eWQG9hmevbFO7kYEnk3fLQvKqljDJJZB8ncCI5GA7eMUTQ5yW
         PhgIvnoI19e5DtE+MNU9Fn+RRz1GO5wlyAS/yWv50anmBsSJ38lmNwLoYPWCwAnUoamF
         DsFc+/QiBnqQBLQo2c/rWbvJ+qk8/YiiAgnqW5u502VyW8jk9CFPkdviARKckMpfPtrZ
         sBEzDeXkVJOvoX/bA4BsdlEZtjwehitleKlp7/wtiwXEcu5fmlIVIbFiq0vw96FriD2q
         oVw3D7dB1ZEuViOraTtkK2DjnzzzH+Y0PwKXvVJwSYHbfh0ACLGN2tmBgEKQfpMwnJRo
         oOIw==
X-Forwarded-Encrypted: i=1; AJvYcCVv5ZmD6ba8NP1B/JNr0S9RwH3M3C47tpMtyDoP/r3CIYeM04RufqxIdrp+alQTBv1Dftw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyro5EiLXpvgZD8WV6efZ6rCjckuZ4IlcdAfj7jNckLS4Oj1B7a
	9ur9+bsA0Bvr36bWS0Gu7WsVSOc57baXIbWjMMicDQEkBKb7ZvXe6Rm0XWjMqILUMLQxCOOHApP
	Xx6NB0XN/rugaqmaWUsi7XmMF2IWC4rfR9B7vf1aimTdYcpdOFw==
X-Received: by 2002:a17:906:fd8b:b0:a86:968b:e9c1 with SMTP id a640c23a62f3a-a89a34e4375mr1246384466b.5.1725456359146;
        Wed, 04 Sep 2024 06:25:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHc9RX7yalPWjcjlOP7ue8yMLn3BH4LZGW+kIo2ts8WjY3/Ym+juQ7azkErO7rt9xEW79nx+w==
X-Received: by 2002:a17:906:fd8b:b0:a86:968b:e9c1 with SMTP id a640c23a62f3a-a89a34e4375mr1246380666b.5.1725456358569;
        Wed, 04 Sep 2024 06:25:58 -0700 (PDT)
Received: from [192.168.10.3] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a898908ebfasm813233866b.95.2024.09.04.06.25.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2024 06:25:58 -0700 (PDT)
Message-ID: <9b6ef0fa-99f5-4eac-b51a-aa0a3126c443@redhat.com>
Date: Wed, 4 Sep 2024 15:25:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH] KVM: Remove HIGH_RES_TIMERS dependency
To: Suleiman Souhlal <ssouhlal@freebsd.org>,
 Sean Christopherson <seanjc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML
 <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>,
 Joel Fernandes <joel@joelfernandes.org>,
 Vineeth Pillai <vineeth@bitbyteword.org>, Borislav Petkov <bp@alien8.de>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Peter Zijlstra <peterz@infradead.org>, Viresh Kumar
 <viresh.kumar@linaro.org>, Frederic Weisbecker <fweisbec@gmail.com>,
 suleiman@google.com
References: <20240821095127.45d17b19@gandalf.local.home>
 <Zs97wp2-vIRjgk-e@google.com> <ZtgNqv1r7S738osp@freefall.freebsd.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZtgNqv1r7S738osp@freefall.freebsd.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 09:35, Suleiman Souhlal wrote:
> On Wed, Aug 28, 2024 at 12:34:26PM -0700, Sean Christopherson wrote:
>> On Wed, Aug 21, 2024, Steven Rostedt wrote:
>>> From: Steven Rostedt <rostedt@goodmis.org>
>>>
>>> Commit 92b5265d38f6a ("KVM: Depend on HIGH_RES_TIMERS") added a dependency
>>> to high resolution timers with the comment:
>>>
>>>      KVM lapic timer and tsc deadline timer based on hrtimer,
>>>      setting a leftmost node to rb tree and then do hrtimer reprogram.
>>>      If hrtimer not configured as high resolution, hrtimer_enqueue_reprogram
>>>      do nothing and then make kvm lapic timer and tsc deadline timer fail.
>>>
>>> That was back in 2012, where hrtimer_start_range_ns() would do the
>>> reprogramming with hrtimer_enqueue_reprogram(). But as that was a nop with
>>> high resolution timers disabled, this did not work. But a lot has changed
>>> in the last 12 years.
>>>
>>> For example, commit 49a2a07514a3a ("hrtimer: Kick lowres dynticks targets on
>>> timer enqueue") modifies __hrtimer_start_range_ns() to work with low res
>>> timers. There's been lots of other changes that make low res work.
>>>
>>> I added this change to my main server that runs all my VMs (my mail
>>> server, my web server, my ssh server) and disabled HIGH_RES_TIMERS and the
>>> system has been running just fine for over a month.
>>>
>>> ChromeOS has tested this before as well, and it hasn't seen any issues with
>>> running KVM with high res timers disabled.
>>
>> Can you provide some background on why this is desirable, and what the effective
>> tradeoffs are?  Mostly so that future users have some chance of making an
>> informed decision.  Realistically, anyone running with HIGH_RES_TIMERS=n is likely
>> already aware of the tradeoffs, but it'd be nice to capture the info here.
> 
> We have found that disabling HR timers saves power without degrading
> the user experience too much.

This might have some issues on guests that do not support kvmclock, 
because they rely on precise delivery of periodic timers to keep their 
clock running.  This can be the APIC timer (provided by the kernel), the 
RTC (provided by userspace), or the i8254 (choice of kernel/userspace).

These guests are few and far between these days, and in the case of the 
APIC timer + Intel hosts we can use the preemption timer (which is 
TSC-based and has better latency _and_ accuracy).  Furthermore, only x86 
is requiring CONFIG_HIGH_RES_TIMERS, so it's probably just excessive 
care and we can even apply Steven's patch as is.

Alternatively, the "depends on HIGH_RES_TIMERS || EXPERT" could be added 
to virt/kvm.  Or a pr_warn could be added to kvm_init if HIGH_RES_TIMERS 
are not enabled.

But in general, it seems that Linux has a laissez-faire approach to 
disabling CONFIG_HIGH_RES_TIMERS - there must be other code in the 
kernel (maybe sound/?) that is relying on having high-enough HZ or 
hrtimers but that's not documented anywhere.  I don't have an objection 
to doing the same in KVM, honestly, since most systems are running 
CONFIG_HIGH_RES_TIMERS anyway.

Paolo


