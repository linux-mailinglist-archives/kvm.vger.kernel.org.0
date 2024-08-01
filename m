Return-Path: <kvm+bounces-22994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA69D945401
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 23:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 120F41C22A8D
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 21:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AED614B091;
	Thu,  1 Aug 2024 21:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cMX4PeNZ"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2A113E04C;
	Thu,  1 Aug 2024 21:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722546619; cv=none; b=cLlT2x6V2wtmvZxEdYbAz7iXj9PvN/NoN6kkFryiVUOCZ8QVyImxiMYcsgzqtu7C39v/yDP+EVM8C7G3WLWOyPHeXH4KjrNc8C+DEGQvJvYO74jZPUZAEfx3D3QGH2OJA9besz2YAPBCcsM6WaQwqQSmcqeLgXxL1Z3Nu36I8Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722546619; c=relaxed/simple;
	bh=jZNe0NumX7nre7PbjemzZRC2003uKq1lzr7goPHi6cU=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=qtHVmAZBV3+xvFc336BDqVGO80JCseqNeCHGvkQ2iqG34qBEJIvEN5XOWds+OMcKRUTSBBNcBDht4zhyxyDqZcKBqLMjGEw2KdO4cPRQJtLqXP4w4VANyG48GnH/Gpk3FyfByNuplSwkbumOW8UsOQ6PiQMu66/r8Eoy6gEeDy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cMX4PeNZ; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=aioUhSnG9CYnIu6VliGOpcyWjhy+xIOl0G4jWEKd5wE=; b=cMX4PeNZWqzTcOYOuEaDqHrsRX
	Gd5uRBiUJy5eX7gr2jIpJngmc9udi7iOQIy1I3Icv1QWvc4xxFQluKKg+hwNZFzUGMWJOE+WpBONb
	qAG8TN0tRG7X6jWRexr/srJkACk1q1lMNhgFTg6AM5eTopZc9MCYZKnk+RnGt1WPC2VGGuXJ2Zo6C
	2vh6WfwKp2d6hfFK/CYPfFi/QFA406h3ZcplWFSZsEJVtJ/xWPv3CS1GBson9X65JukyNofA2Ximw
	8W8/WMDifPN3crdNeTGAiVtUkXM9f1gTjtw32+wA1jk59tPRDVBIrpyHOyhBYxSnyqkHiTJViwury
	wb/8HFHA==;
Received: from [2001:8b0:10b:5:4def:d905:9693:de2e] (helo=[IPv6:::1])
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sZd3n-00000005ZiB-1pSC;
	Thu, 01 Aug 2024 21:10:08 +0000
Date: Thu, 01 Aug 2024 22:10:08 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>, mikelley@microsoft.com,
 kvm <kvm@vger.kernel.org>
CC: bp@alien8.de, dave.hansen@linux.intel.com, decui@microsoft.com,
 haiyangz@microsoft.com, kys@microsoft.com, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, lirongqing@baidu.com, mingo@redhat.com,
 seanjc@google.com, wei.liu@kernel.org, x86@kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_clockevents/drivers/i8253=3A?=
 =?US-ASCII?Q?_Do_not_zero_timer_counter_in_shutdown?=
User-Agent: K-9 Mail for Android
In-Reply-To: <874j842bqq.ffs@tglx>
References: <8eb7ba99a746110597bbac6f1e027aa63384dfce.camel@infradead.org> <4bac07dc91de1c45720f36ed6b797d3f215f131a.camel@infradead.org> <874j842bqq.ffs@tglx>
Message-ID: <DCDC804F-4025-4B9D-8727-2DBA40DD3598@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

On 1 August 2024 22:07:25 BST, Thomas Gleixner <tglx@linutronix=2Ede> wrote=
:
>On Thu, Aug 01 2024 at 16:22, David Woodhouse wrote:
>> On Thu, 2024-08-01 at 10:00 +0100, David Woodhouse wrote:
>>  bool __init pit_timer_init(void)
>>  {
>> -	if (!use_pit())
>> +	if (!use_pit()) {
>> +		if (!hypervisor_is_type(X86_HYPER_NATIVE)) {
>> +			/*
>> +			 * Don't just ignore the PIT=2E Ensure it's stopped,
>> +			 * because VMMs otherwise steal CPU time just to
>> +			 * pointlessly waggle the (masked) IRQ=2E
>> +			 */
>> +			raw_spin_lock(&i8253_lock);
>> +			outb_p(0x30, PIT_MODE);
>> +
>> +			/*
>> +			 * It's not entirely clear from the datasheet, but some
>> +			 * virtual implementations don't stop until the counter
>> +			 * is actually written=2E
>> +			 */
>> +			if (i8253_clear_counter_on_shutdown) {
>> +				outb_p(0, PIT_CH0);
>> +				outb_p(0, PIT_CH0);
>> +			}
>> +			raw_spin_unlock(&i8253_lock);
>> +		}
>>  		return false;
>> +	}
>
>That's just wrong=2E What we want is to have the underlying problem
>fixed in the driver and then make:
> =20
>>  	clockevent_i8253_init(true);
>
>bool clockevent_i8253_init(bool enable, bool oneshot);
>
>so it can invoke the shutdown sequence instead of registering the pile:
>
>   if (!enable) {
>      shutdown();
>      return false;
>   }
>   =2E=2E=2E
>   return true;
>
>and the call site becomes:
>
>    if (!clockevent_i8253_init(use_pit(), true))
>    	return false;
>
>No?

Yes=2E Well, kind of=2E The way I actually did it was by exposing the shut=
down function instead of an "init" function which optionally did the opposi=
te=2E But yes,  I left the hardware-bashing in precisely once place, in the=
 driver=2E


