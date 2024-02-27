Return-Path: <kvm+bounces-10104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21ED0869D8F
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 18:28:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE55828517F
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 17:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9EEB1487E0;
	Tue, 27 Feb 2024 17:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V7VTU9/I"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85B34CB20
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 17:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709054588; cv=none; b=qLG3gDAVpx9+sK/4vj0AWaavG5toG7zx7ySc6BjjSiqv5ScKs/p9zWbvbcuMBt74dGZO6h33tSUIaTwnndajS4scwqhKLZ8qGJgl+j6sW1hfxtRo3mbZLDINrqnWCpvwclR3p4Gv+s3zcsKjjIfuvtoXL/FD43c2x2zDgoV5nJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709054588; c=relaxed/simple;
	bh=Ud9fhO9bJGgT5AynGewQz2oOUrGnb1uFY2uxhhU/5yE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=abr+mQere5/tFNaJSXGRGAcNHpA/gan2KepdnjAizPRxaH66tgu/o1gC7tMAUkOeswn/6Rrh/P5u8036nCE4DjBxrVDQ7Uiwj296rhGXd+RKILOSJaQYbrJKSGHA1/dAXwnsW2M+1rZJiVwUJO2T/crujXw8hnaFxs0WrXq7SWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V7VTU9/I; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=Sg0fet3DPYfoRRMcHARV07iXFmO9tJmq+73MaEQ6pQs=; b=V7VTU9/IgKhveYDrTJfIZmovSF
	iWPaVdKtjmcvPSHlRRLccstHV3A/pNBOk1hN7IVm7sIOJ3vc79mMuc1NzVrHc8yCcNmJ8OhuihoA0
	xq/2SjwkR5BS4VpjjfCAu6sTCIJP8C5wH/ScSKXBlK7rUWDX2kd0KkvUEKnjEIApBOBAfEi0roRZo
	iImbuwLdhCikgOtfixDTBjYApZkK+Vv5+GLBcRgW2OfulGFAB6Ueukk4YpiubEBII8LLRoBAo1rtO
	tysu148efNrhDYLWFp79QEq8nJajTrARVGbNaJSNx6AVy489VuJoWZ/PHP9k5XIVJ/o8pa0VaGW28
	cQZqDpQw==;
Received: from [2a00:23ee:2310:b61:2cd1:6cc6:6a39:1f9c] (helo=[IPv6:::1])
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rf1AU-00000001r3t-2s3P;
	Tue, 27 Feb 2024 17:23:03 +0000
Date: Tue, 27 Feb 2024 17:22:59 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
CC: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Michal Luczaj <mhal@rbox.co>, Paul Durrant <pdurrant@amazon.com>,
 David Woodhouse <dwmw@amazon.co.uk>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_7/8=5D_KVM=3A_x86/xen=3A_avoid_blocking?= =?US-ASCII?Q?_in_hardirq_context_in_kvm=5Fxen=5Fset=5Fevtchn=5Ffast=28=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <871q8xakql.ffs@tglx>
References: <20240227115648.3104-1-dwmw2@infradead.org> <20240227115648.3104-8-dwmw2@infradead.org> <20240227094326.04fd2b09@gandalf.local.home> <8C04AFD0-FC16-4572-AD23-FC7EEF663F11@infradead.org> <871q8xakql.ffs@tglx>
Message-ID: <3A220705-5BEB-4247-96D0-9054E1164CCE@infradead.org>
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

On 27 February 2024 17:18:58 GMT, Thomas Gleixner <tglx@linutronix=2Ede> wr=
ote:
>On Tue, Feb 27 2024 at 17:00, David Woodhouse wrote:
>> On 27 February 2024 14:43:26 GMT, Steven Rostedt <rostedt@goodmis=2Eorg=
> wrote:
>>>On Tue, 27 Feb 2024 11:49:21 +0000
>>>David Woodhouse <dwmw2@infradead=2Eorg> wrote:
>>>
>>>> diff --git a/arch/x86/kvm/xen=2Ec b/arch/x86/kvm/xen=2Ec
>>>> index c16b6d394d55=2E=2Ed8b5326ecebc 100644
>>>> --- a/arch/x86/kvm/xen=2Ec
>>>> +++ b/arch/x86/kvm/xen=2Ec
>>>> @@ -1736,9 +1736,23 @@ static int set_shinfo_evtchn_pending(struct kv=
m_vcpu *vcpu, u32 port)
>>>>  	unsigned long flags;
>>>>  	int rc =3D -EWOULDBLOCK;
>>>> =20
>>>> -	read_lock_irqsave(&gpc->lock, flags);
>>>> +	local_irq_save(flags);
>>>> +	if (!read_trylock(&gpc->lock)) {
>>>
>>>Note, directly disabling interrupts in PREEMPT_RT is just as bad as doi=
ng
>>>so in non RT and the taking a mutex=2E
>>
>> Well, it *isn't* a mutex in non-RT=2E It's basically a spinlock=2E And
>> even though RT turns it into a mutex this is only a trylock with a
>> fall back to a slow path in process context, so it ends up being a
>> very short period of irqdisable/lock =E2=80=93 just to validate the tar=
get
>> address of the cache, and write there=2E (Or fall back to that slow
>> path, if the cache needs revalidating)=2E
>>
>> So I think this is probably OK, but=2E=2E=2E
>>
>>>Worse yet, in PREEMPT_RT read_unlock_irqrestore() isn't going to re-ena=
ble
>>>interrupts=2E
>>
>> =2E=2E=2E that's kind of odd=2E I think there's code elsewhere which as=
sumes
>> it will, and pairs it with an explicit local_irq_save() like the
>> above, in a different atomic context (updating runstate time info when
>> being descheduled)=2E
>
>While it is legit, it simply cannot work for RT=2E We fixed the few place=
s
>which had it open coded (mostly for no good reason)=2E
>
>> So *that* needs changing for RT?
>
>No=2E It's not required anywhere and we really don't change that just to
>accomodate the xen shim=2E

It's open-coded in the runstate update in the Xen shim, as I said=2E That'=
s what needs changing, which is separate from the problem at hand in this p=
atch=2E

>I'll look at the problem at hand tomorrow=2E

Ta=2E


