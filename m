Return-Path: <kvm+bounces-67991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 639E1D1BBDA
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 00:41:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 42A8F300B9B5
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 23:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AE2936BCEC;
	Tue, 13 Jan 2026 23:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DQ1eZEXs"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DC41DC985;
	Tue, 13 Jan 2026 23:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768347649; cv=none; b=MJ+obp5z/+0DmX/oz3hlAmfK+XmeshATsqCdWa/qfIx1ptm8phOhocyga9P3CLoFNAVj3kvvrpytxGzwpfaDVxNeeR7Q1Ad9op4+MQl76m8NGIatvAXJxQMh8ZSlAPozF2Ce6x8qU1h3X2kLWOp1K5+7+csqnvtgZLu/TzqeeAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768347649; c=relaxed/simple;
	bh=uAqI3fIuQ9dQpiz4bvlkShASmIj+EfpnFrWiJka4qko=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=Q4miWbGk3m9R9bXRvwva3EpCp3IgT9Dj8eIkUOwBbZzRGAWJwrSwCSWHZ1tb3upy3GAisUyO7fr0BpUjxZ1DJsKB2AeBKfysITzqIybbZqFTzrFWi8CvqOdGPVW92r/WJuuQCuyxydrsZqRQkYr5qgaK+L4+E+owVPGGJPu2vqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DQ1eZEXs; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=S7gFUpYJQbg37o5/6HDO6Bs9Y0fg/vJUfna1ZIxerBE=; b=DQ1eZEXs9omuHvDp9OtHjkPwcO
	IBEHdR5mN+XKTQEyRajDfOfO5fXSVe1qgp/v7DhLNTG9J3J3OQ2mQkD3iq6QzImjA2PwOAmP8hWhC
	UP5Wl6B5KRWnUT/zxZDArLj3X+TccczSaObGYOtei+1fj+eWP4LSf9HvZmbHGJ8I+NJg8OHw3n6di
	h4Mc1eq1Kd2OVGjnGZ89/23ncz71UCsNGKHJXqAFcXzSB1Cgp10YY5wIEwslC9C9qYL49WXuShj4i
	mDZS3DcX4k1kJXLZ+2wKwb0+LEkyH6+m5wzqm9qFtMn+wW6tIwsmpt00a35rGy5t1jyU8KajBl/G6
	o3YMstfA==;
Received: from [172.31.31.143] (helo=ehlo.thunderbird.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfnzz-00000003nYa-3djB;
	Tue, 13 Jan 2026 23:40:32 +0000
Date: Tue, 13 Jan 2026 23:40:31 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Khushit Shah <khushit.shah@nutanix.com>
CC: "seanjc@google.com" <seanjc@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kai.huang@intel.com" <kai.huang@intel.com>,
 "mingo@redhat.com" <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
 "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, Jon Kohler <jon@nutanix.com>,
 Shaju Abraham <shaju.abraham@nutanix.com>
Subject: Re: [PATCH v5 1/3] KVM: x86: Refactor suppress EOI broadcast logic
User-Agent: K-9 Mail for Android
In-Reply-To: <9CB80182-701E-4D28-A150-B3A0E774CD61@nutanix.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com> <20251229111708.59402-2-khushit.shah@nutanix.com> <e09b6b6f623e98a2b21a1da83ff8071a0a87f021.camel@infradead.org> <9CB80182-701E-4D28-A150-B3A0E774CD61@nutanix.com>
Message-ID: <6DF6855A-3F9F-4C31-89FC-6905B11553AF@infradead.org>
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

On 12 January 2026 04:15:37 GMT, Khushit Shah <khushit=2Eshah@nutanix=2Ecom=
> wrote:
>
>
>> On 2 Jan 2026, at 9:53=E2=80=AFPM, David Woodhouse <dwmw2@infradead=2Eo=
rg> wrote:
>>=20
>> On Mon, 2025-12-29 at 11:17 +0000, Khushit Shah wrote:
>>> Extract the suppress EOI broadcast (Directed EOI) logic into helper
>>> functions and move the check from kvm_ioapic_update_eoi_one() to
>>> kvm_ioapic_update_eoi() (required for a later patch)=2E Prepare
>>> kvm_ioapic_send_eoi() to honor Suppress EOI Broadcast in split IRQCHIP
>>> mode=2E
>>>=20
>>> Introduce two helper functions:
>>> - kvm_lapic_advertise_suppress_eoi_broadcast(): determines whether KVM
>>>   should advertise Suppress EOI Broadcast support to the guest
>>> - kvm_lapic_respect_suppress_eoi_broadcast(): determines whether KVM s=
hould
>>>   honor the guest's request to suppress EOI broadcasts
>>>=20
>>> This refactoring prepares for I/O APIC version 0x20 support and usersp=
ace
>>> control of suppress EOI broadcast behavior=2E
>>>=20
>>> Signed-off-by: Khushit Shah <khushit=2Eshah@nutanix=2Ecom>
>>=20
>> Looks good to me, thanks for pushing this through to completion!
>>=20
>>=20
>> Reviewed-by: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>>=20
>> Nit: Ideally I would would prefer to see an explicit 'no functional
>> change intended' and a reference to commit 0bcc3fb95b97a=2E
>
>
>I took another careful look at the refactor specifically through the
>=E2=80=9Cno functional change=E2=80=9D lens=2E

This is, of course, exactly why I make people type those words explicitly =
:)

>The legacy behavior with the in-kernel IRQCHIP can be summarized as:
>- Suppress EOI Broadcast (SEOIB) is not advertised to the guest=2E
>- If the guest nevertheless enables SEOIB, it is honored (already in un-s
>  upported territory)=2E
>- Even in that case, the legacy code still ends up calling
>  kvm_notify_acked_irq() in kvm_ioapic_update_eoi_one()=2E
>
>With the refactor, kvm_notify_acked_irq() is no longer reached in this
>specific legacy scenario when the guest enables SEOIB despite it not
>being advertised=2E I believe this is acceptable, as the guest is relying
>on an unadvertised feature=2E

That sounds sensible as you describe it=2E

Note that we did advertise this in the past and then silently just stop do=
ing so potentially underneath already running guests, but that (commit=20
0bcc3fb95b97a) was back in 2018 so I guess there won't be many "innocent v=
ictim" guests around any more who genuinely did see the feature advertised=
=2E


>For non-QUIRKED configurations, the behavior is also correct:
>- When SEOIB is ENABLED, kvm_notify_acked_irq() is called on EOIR write,
>  when enabled by guest=2E
>- When SEOIB is DISABLED, kvm_notify_acked_irq() is called on EOI
>  broadcast=2E
>
>I would appreciate others chiming in if they see a reason to preserve
>the legacy ack behavior even in the unsupported case=2E

LGTM=2E Thanks=2E

