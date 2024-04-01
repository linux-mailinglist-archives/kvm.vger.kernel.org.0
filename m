Return-Path: <kvm+bounces-13295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5234389463C
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 22:48:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 091F82817E5
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 20:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEACF53380;
	Mon,  1 Apr 2024 20:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LExrYd7Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9980117552
	for <kvm@vger.kernel.org>; Mon,  1 Apr 2024 20:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712004495; cv=none; b=LCC/jCWokOv7AkX747//Ki4ZyuCRL0Qy1AfVtQu7nuXbjYHONGJFSD9Bh8Cpfw3QZcz7bVeyLhzZSTwygEtNK4lbK5020GaMmz1GfRLoGHRuvLrOtRyvqSPi3aI6juUXB19eMQ5fTcSxgQZ2mkxBCHwXxBt8f1ixpQTtlud/zoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712004495; c=relaxed/simple;
	bh=A6LNjl7kdK9AzHxQfi4d8qBHPIt3Xy8smslvZSzSU90=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L//F/kPjvmwxHpy53UR6JICj/ZwoM4hi29bMk4LZvvElU4luR93Pe0PJh0ibo0EvlriNJ2pNNWkZ2Xa/QTP++2kc+et+9N+97O/NHWmLWna3Bgd5j+J0EpcS6KMEqQXRyipB+nDa8cFxiBxIOgE68nDfmrLkSdWuR7OodJVszaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LExrYd7Q; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5c6245bc7caso3072869a12.3
        for <kvm@vger.kernel.org>; Mon, 01 Apr 2024 13:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712004493; x=1712609293; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fv/II9A3epHoaznKrK5u7efYeDiQF4Go6qSmeABJnqw=;
        b=LExrYd7QV2XYAF6aLQJH4cyFhifP/Wa3BjQkH9mf+8LsIQexD+nBcf+bytG4/HcWgf
         pa+rbV7G4jlpds08DbbRTnxJrf9h+M6xUrRwWu6nxa0COTRpcwMTQKMDpPFlQijOuoRI
         1ybZzNpbXXVtpgYIzy3kppZ8bVtKgAH88wvHjpHz1BH/imOaK7ArkJb6uKF8KEG6siuQ
         zZfojJ+347DtUhIrT+TPgfL5iafso2VTN+TZnXGmlm9X4rJOYfSXrzvJPy135FNiaCS/
         82Sp+v9AZdb4kVDkRCwW2uxbn3xmnRypkB2CY3Zt+2MW9tjPFHGTZSW9zv0kB6xd68aD
         yMSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712004493; x=1712609293;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fv/II9A3epHoaznKrK5u7efYeDiQF4Go6qSmeABJnqw=;
        b=KN68r2S4JiNu1hQc4hqlZ0wj+MGZ/TSiRM9Hc2peIjUpZm0dzuK5BP2V9Mq1tO7dHA
         k5p7srdcWboEQs4B5FoOD9IqNQTPl8Mks5APQG/ONRSOPEQZ9O3Aql7XTOYXlOe10uk8
         4cPJobZOoatrfScYQDd8D+v1HZeP8XwebNT0JKFn+KCXE4uwgmTO87kADoTRl+hIxADS
         Ti5ORPyIyC582TOkFxWn5A2DrB4ldpHquwNf/nqvXlSx4jvBvzRwlDKJYB7xOrCIRfqV
         QOOZYt95SAdodcDGbnXMkpNX1UwtsPQrMQ8nDXuWVDordpGznetQ319gOgezx34ClCy0
         ENow==
X-Gm-Message-State: AOJu0YylnMdpDaPWVQPf7EPb3H6blNtdr9sWMpdTjzyeEWYbTdaEQ+be
	OVtS0b7wCm99vZM8/ES7tk4GNjrYD2B3nus0RYJAi1kbwgjH6Fh/iSKRnJSP/f/UDuTQrn70VbB
	fzA==
X-Google-Smtp-Source: AGHT+IH8/txgly2jkhgBUNBvhKavDGq0KjklzR1yfdbtb09ostm6P50syvQAFKzOhIUyq8jMD1vrdIosJTE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:4081:0:b0:5dc:8f91:a343 with SMTP id
 t1-20020a654081000000b005dc8f91a343mr29179pgp.1.1712004492881; Mon, 01 Apr
 2024 13:48:12 -0700 (PDT)
Date: Mon, 1 Apr 2024 13:48:11 -0700
In-Reply-To: <20240328195457036IuH06oaGnAPMpxjXRoWIx@zte.com.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240328195457036IuH06oaGnAPMpxjXRoWIx@zte.com.cn>
Message-ID: <ZgsdiwdtZ6xJNI3y@google.com>
Subject: Re: Hosts got stuck with vmx: =?utf-8?Q?un?= =?utf-8?Q?expected_exit_reason_0x3=C2=A0?=
From: Sean Christopherson <seanjc@google.com>
To: jiang.kun2@zte.com.cn
Cc: kvm@vger.kernel.org, wang.yechao255@zte.com.cn, ouyang.maochun@zte.com.cn
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 28, 2024, jiang.kun2@zte.com.cn wrote:
> Dear KVM experts,
> 
> We have two hosts that got stuck, and the last serial port logs had
> kvm prints vmx: unexpected exit reason 0x3.
> 
> last logs of HostA:
> [23031085.916249] kvm [9737]: vcpu6, guest rIP: 0xffffffffb190d1b5 vmx: unexpected exit reason 0x3
> [23031085.916251] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
> 
> last logs of HostB:
> [16755112.797211] kvm [2787303]: vcpu11, guest rIP: 0x70a8f4 vmx: unexpected exit reason 0x3
> [16755112.797213] kvm [2787303]: vcpu16, guest rIP: 0x70a9ae vmx: unexpected exit reason 0x3
> [16755112.797214] kvm [2787303]: vcpu17, guest rIP: 0x70a9ae vmx: unexpected exit reason 0x3
> [16755112.797217] kvm [2787303]: vcpu15, guest rIP: 0x70d707 vmx: unexpected exit reason 0x3
> [16755112.797219] kvm [2787303]: vcpu12, guest rIP: 0x701431 vmx: unexpected exit reason 0x3
> [16755112.797221] kvm [2787303]: vcpu7, guest rIP: 0x70b005 vmx: unexpected exit reason 0x3
> [16755112.797222] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
> [16755112.797224] kvm [2787303]: vcpu4, guest rIP: 0x796fa6 vmx: unexpected exit reason 0x3
> [16755112.797224] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
> [16755112.797229] kvm [3588862]: vcpu3, guest rIP: 0xffffffff816c7a1b vmx: unexpected exit reason 0x3
> [16755112.797230] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
> [16755112.797231] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
> [16755112.797231] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
> [16755112.797232] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
> [16755112.797233] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
> [16755112.797235] kvm [9066]: vcpu5, guest rIP: 0xffffffff8a4a1c0e vmx: unexpected exit reason 0x3
> [16755112.797236] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
> [16755112.797236] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
> [16755112.797262] kvm [2813867]: vcpu0, guest rIP: 0xffffffff816c7a1b vmx: unexpected exit reason 0x3
> [16755112.797263] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
> [18446744004.989880] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> [18446744004.989880] PGD 0 P4D 0
> [18446744004.989880] Oops: 0000 [#1] SMP NOPTI
> [18446744004.989880] CPU: 10 PID: 0 Comm: swapper/10 Kdump: loaded Tainted: G           OE    --------- -t - 4.18.0-193.14.2.el8_2.x86_64 #1
> [18446744004.989880] Hardware name: xxxxx, BIOS xx.xx.xxxx 02/18/2020
> [18446744004.989880] RIP: 0010:__list_add_valid+0x0/0x50
> [18446744004.989880] Code: ff ff 49 c7 07 00 00 00 00 41 c7 47 08 00 00 00 00 48 89 44 24 28 e9 dc fe ff ff 48 89 6c 24 28 e9 d2 fe ff ff e8 20 08 c8 ff <48> 8b 42 08 49 89 d0 48 39 f0 0f 85 8c 00 00 00 48 8b 10 4c 39 c2
> 
> Kernel version is: 4.18.0-193.14.2.el8_2.x86_64
> CPU is Intel(R) Xeon(R) Gold 6230N CPU @ 2.30GHz
> 
> When the hosts were found to be stuck, both had been stuck for several days.
> We tried triggering a panic collection of vmcore using sysrq+c magic key,
> but there was no response. Eventually, we had to do a hard reboot by pressing
> the power button to recover.
> 
> There is no crashdump generated.
> 
> Before the two hosts got stuck, they both printed vmx: unexpected exit
> reason 0x3. Looking at the code, we found exit reason 0x3 is
> EXIT_REASON_INIT_SIGNAL, means that the current CPU received INIT IPI in
> non-root mode. But found INIT IPI is only sent during CPU setup.
> Anyone know why INIT IPI is generated?

Software (including BIOS/UEFI/firmware) uses INIT to rendezvous APs with the BSP
when taking control from some other piece of software.  Most commonly, that happens
during CPU setup, but I wouldn't say it's strictly limited to "setup", e.g. it
can come into play when kexec'ing into a new kernel, say after a crash.

Some hardware (chipsets?) will also send INIT in response to a triple fault
shutdown, though I've no idea if that's still true on modern hardware.  E.g. if
the BSP hits a triple fault, it could get hit with an INIT and jump back to the
reset vector and thus BIOS/UEFI, and potentially try to wake APs with INIT, while
the APs are still actively running KVM guests.

> HostB printed NULL pointer BUG, but the panic process did not proceed further
> and instead got stuck. The time 18446744004.989880 is incorrect, the uptime
> of HostB is 193 days.
> 
> We suspect hostB&apos;s exception are also related to the previous vmx unexpected
> exit. Anyone encountered similar cases before? Are there any solutions
> and suggestions?

Odds are very, very good that the unexpected INIT VM-Exit is a symptom, not the
root cause.  The most likely scenario is that the host encountered a fatal error
and either hit shutdown or tried to panic, and that fatal error eventually led
to BIOS or a kdump kernel trying to rendezvous with APs via INIT-SIPI, which in
turn triggered the unexpected VM-Exits.

But without more information on what the _other_ CPUs were doing, it's practically
impossible to even make a guess as to what went wrong.  And it's even more impossible
since you're running a relatively ancient kernel, which likely has quite a few out
of tree patches (I'm not criticizing running an older kernel, just saying that it
means no one in upstream is likely to have any guesses as to what went wrong).

