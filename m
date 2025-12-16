Return-Path: <kvm+bounces-66094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E46C5CC544C
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 22:53:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B1ADF307A23B
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 21:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D36326D6B;
	Tue, 16 Dec 2025 21:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="TaSruyIL"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95F533AD8D;
	Tue, 16 Dec 2025 21:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765921904; cv=none; b=PLeqVu8MT0xn4likJR60ZIlJBZDCLQkqsd64AR4a/PqGk3w9AvcSWhKbkhfri7XHMjcUQDfQntWMbgc5wVfPBxKgFttmSL+/JG8Wy5YV7QSPLoK7y+a4EUtx3ep9k3GjCEG7sm2/Vl9ausUG6LguU5UEBTXIIDMtO4E6Atvz0Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765921904; c=relaxed/simple;
	bh=98ggaTZvCYQrJE7EKpjojwh2LUANapTP62HYxPrNHsw=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=t5dN2F4Al9a4K54aFq4VrcvdQTxP2PZVafi0f6/8umBSBtvmTvSyzRGIgePIMSIAvCAVCJdC2oFsSLBs2JUGwLlEOZ3MkR1mhJPgQlUlurwR4GTUxvgPEuOE4ItTkWsXup+bwralx7a/YZe6IjDnLLYVabSHoMMwCw49HYyIuWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=TaSruyIL; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5BGLohdD2591914
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 16 Dec 2025 13:50:43 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5BGLohdD2591914
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025112201; t=1765921845;
	bh=IUFjXMGEioy90PCRU6K4eEZsewA4J72rUYR0KWqV+PM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=TaSruyIL5BsuQXNl77ikEHcqTR1fDc/rJVG9GGilNzbXMjAWLMi5zLkeAnIAug1+r
	 Su/ah9a3Wgx0pu3LR0we0eDApaY8L/uZC28BGqjRZAvTkiWEJ87pqbp53NDubEKBmc
	 G2Nlb4Bu15QyNTu7ZtHdHCV5hKeXr86jkQ674prA51A6dCUfANhW1Hsg5QmpearEVm
	 kSTg37FHH2iRaLQ9ZpJ76YZa69FMDMyr7gujzLXDUstSm7PXe85dAgbUVevIepDrwN
	 VkvaQfn0WxKIabhsLzFt4y2wKfCXTwj33MPECOh1RPxcmhVPcWl0HrC+VxhS+9q4G0
	 a/7lubgc33EpQ==
Date: Tue, 16 Dec 2025 13:50:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: David Laight <david.laight.linux@gmail.com>
CC: =?ISO-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, virtualization@lists.linux.dev, kvm@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-block@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ajay Kaher <ajay.kaher@broadcom.com>,
        Alexey Makhalov <alexey.makhalov@broadcom.com>,
        Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>, Denis Efremov <efremov@linux.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/5] x86: Cleanups around slow_down_io()
User-Agent: K-9 Mail for Android
In-Reply-To: <20251216195912.0727cc0d@pumpkin>
References: <20251126162018.5676-1-jgross@suse.com> <aT5vtaefuHwLVsqy@gmail.com> <bff8626d-161e-4470-9cbd-7bbda6852ec3@suse.com> <aUFjRDqbfWMsXvvS@gmail.com> <b969cff5-be11-4fd3-8356-95185ea5de4c@suse.com> <14EF14B1-8889-4037-8E7B-C8446299B1E9@zytor.com> <20251216195912.0727cc0d@pumpkin>
Message-ID: <69AE77E6-4256-4B0B-970E-194B4C70B7AF@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On December 16, 2025 11:59:12 AM PST, David Laight <david=2Elaight=2Elinux@=
gmail=2Ecom> wrote:
>On Tue, 16 Dec 2025 07:32:09 -0800
>"H=2E Peter Anvin" <hpa@zytor=2Ecom> wrote:
>
>> On December 16, 2025 5:55:54 AM PST, "J=C3=BCrgen Gro=C3=9F" <jgross@su=
se=2Ecom> wrote:
>> >On 16=2E12=2E25 14:48, Ingo Molnar wrote: =20
>> >>=20
>> >> * J=C3=BCrgen Gro=C3=9F <jgross@suse=2Ecom> wrote:
>> >>  =20
>> >>>> CPUs anymore=2E Should it cause any regressions, it's easy to bise=
ct to=2E
>> >>>> There's been enough changes around all these facilities that the
>> >>>> original timings are probably way off already, so we've just been
>> >>>> cargo-cult porting these to newer kernels essentially=2E =20
>> >>>=20
>> >>> Fine with me=2E
>> >>>=20
>> >>> Which path to removal of io_delay would you (and others) prefer?
>> >>>=20
>> >>> 1=2E Ripping it out immediately=2E =20
>> >>=20
>> >> I'd just rip it out immediately, and see who complains=2E :-) =20
>> >
>> >I figured this might be a little bit too evil=2E :-)
>> >
>> >I've just sent V2 defaulting to have no delay, so anyone hit by that
>> >can still fix it by applying the "io_delay" boot parameter=2E
>> >
>> >I'll do the ripping out for kernel 6=2E21 (or whatever it will be call=
ed)=2E
>> >
>> >
>> >Juergen =20
>>=20
>> Ok, I'm going to veto ripping it out from the real-mode init code,
>> because I actually know why it is there :) =2E=2E=2E
>
>Pray tell=2E
>One thing I can think of is the delay allows time for a level-sensitive
>IRQ line to de-assert before an ISR exits=2E
>Or, maybe more obscure, to avoid back to back accesses to some register
>breaking the 'inter-cycle recovery time' for the device=2E
>That was a good way to 'break' the Zilog SCC and the 8259 interrupt
>controller (eg on any reference board with a '286 cpu)=2E
>
>	David
>
>> and that code is pre-UEFI legacy these days anyway=2E
>>=20
>> Other places=2E=2E=2E I don't care :)
>>=20
>
>

A20 gate logic on some motherboards, especially=2E

