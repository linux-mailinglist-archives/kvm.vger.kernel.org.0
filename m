Return-Path: <kvm+bounces-32888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3A109E1382
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 07:48:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4E07282983
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 06:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8D32189F56;
	Tue,  3 Dec 2024 06:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ON/teFOr";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ON/teFOr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CB18837;
	Tue,  3 Dec 2024 06:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733208483; cv=none; b=tsSpViOsiDavod29D5sQOZ6suhPJk8W18Ngco62h0QpS0XtJsVTCFhtwsYbxGtsKVGab16OiyjwbBgEx4gUktz16iZSW3qZHJLIc9Xt8wWEebJVASVmJED+8hvODfgrRkbFFZnTWDatU8Fcw7KqqHJEwSDuZIEOO8Xou1HDFsZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733208483; c=relaxed/simple;
	bh=skXBrguFnEEJ9cK1Wgw6mdBV+KU7BMDS9WBaBnwTQ3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dIiaG5E8nbGspiao0XCs8y5tVe+iIuq264pByivkAYt3EmPGfiE51coHOlgDpc3q9wgHwBNdnPEa4+apmvSjWWblmnZPU529vakuLckR1PafkeBdQOzHTPLJM032Nz0PEw7Zw4sJTZsZKuAymGGyeVHDoD1Ve5RA0FhUwW8L9as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ON/teFOr; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ON/teFOr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C9C0A2116D;
	Tue,  3 Dec 2024 06:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733208475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KmTgfQaLPbT4i+fON6Y5ezxxdO6L+T5ytkzLsgHmxZg=;
	b=ON/teFOrcct37tAnFgOR2NrHAzcYeTxxCe+Wn8mh605pWh3cYXyGwQEBkWPTRFw7+/i7NV
	qwzuhbiRwNVQTD4toB3ap+JgGGMd2lLu28dXvzkFxz++s2mQnTKsVu3K1n5Q/fYktaQ9vp
	A64vaMyCcjx0mZv1ZUdJGrpLd9e1rRI=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733208475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KmTgfQaLPbT4i+fON6Y5ezxxdO6L+T5ytkzLsgHmxZg=;
	b=ON/teFOrcct37tAnFgOR2NrHAzcYeTxxCe+Wn8mh605pWh3cYXyGwQEBkWPTRFw7+/i7NV
	qwzuhbiRwNVQTD4toB3ap+JgGGMd2lLu28dXvzkFxz++s2mQnTKsVu3K1n5Q/fYktaQ9vp
	A64vaMyCcjx0mZv1ZUdJGrpLd9e1rRI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1459F139C2;
	Tue,  3 Dec 2024 06:47:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IfMAApupTmdmIAAAD6G6ig
	(envelope-from <jgross@suse.com>); Tue, 03 Dec 2024 06:47:55 +0000
Message-ID: <24b80006-dcea-4a76-b5c8-e147d9191ed2@suse.com>
Date: Tue, 3 Dec 2024 07:47:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] x86, lib, xenpv: Add WBNOINVD helper functions
To: Xin Li <xin@zytor.com>, Kevin Loughlin <kevinloughlin@google.com>,
 Andrew Cooper <andrew.cooper3@citrix.com>
Cc: linux-kernel@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 kvm@vger.kernel.org, thomas.lendacky@amd.com, pgonda@google.com,
 sidtelang@google.com, mizhang@google.com, virtualization@lists.linux.dev,
 xen-devel@lists.xenproject.org, bcm-kernel-feedback-list@broadcom.com
References: <20241203005921.1119116-1-kevinloughlin@google.com>
 <20241203005921.1119116-2-kevinloughlin@google.com>
 <a9560e97-478d-4e03-b936-cf6f663279a4@citrix.com>
 <CAGdbjmLRA5g+Rgiq-fRbWaNqXK51+naNBi0b3goKxsN-79wpaw@mail.gmail.com>
 <bc4a4095-d8bd-4d97-a623-be35ef81aad0@zytor.com>
Content-Language: en-US
From: Juergen Gross <jgross@suse.com>
In-Reply-To: <bc4a4095-d8bd-4d97-a623-be35ef81aad0@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid]
X-Spam-Flag: NO
X-Spam-Level: 

On 03.12.24 05:09, Xin Li wrote:
> On 12/2/2024 5:44 PM, Kevin Loughlin wrote:
>> On Mon, Dec 2, 2024 at 5:28 PM Andrew Cooper <andrew.cooper3@citrix.com> wrote:
>>>
>>> On 03/12/2024 12:59 am, Kevin Loughlin wrote:
>>>> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
>>>> index d4eb9e1d61b8..c040af2d8eff 100644
>>>> --- a/arch/x86/include/asm/paravirt.h
>>>> +++ b/arch/x86/include/asm/paravirt.h
>>>> @@ -187,6 +187,13 @@ static __always_inline void wbinvd(void)
>>>>        PVOP_ALT_VCALL0(cpu.wbinvd, "wbinvd", ALT_NOT_XEN);
>>>>   }
>>>>
>>>> +extern noinstr void pv_native_wbnoinvd(void);
>>>> +
>>>> +static __always_inline void wbnoinvd(void)
>>>> +{
>>>> +     PVOP_ALT_VCALL0(cpu.wbnoinvd, "wbnoinvd", ALT_NOT_XEN);
>>>> +}
>>>
>>> Given this, ...
>>>
>>>> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
>>>> index fec381533555..a66b708d8a1e 100644
>>>> --- a/arch/x86/kernel/paravirt.c
>>>> +++ b/arch/x86/kernel/paravirt.c
>>>> @@ -149,6 +154,7 @@ struct paravirt_patch_template pv_ops = {
>>>>        .cpu.write_cr0          = native_write_cr0,
>>>>        .cpu.write_cr4          = native_write_cr4,
>>>>        .cpu.wbinvd             = pv_native_wbinvd,
>>>> +     .cpu.wbnoinvd           = pv_native_wbnoinvd,
>>>>        .cpu.read_msr           = native_read_msr,
>>>>        .cpu.write_msr          = native_write_msr,
>>>>        .cpu.read_msr_safe      = native_read_msr_safe,
>>>
>>> this, and ...
>>>
>>>> diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
>>>> index d6818c6cafda..a5c76a6f8976 100644
>>>> --- a/arch/x86/xen/enlighten_pv.c
>>>> +++ b/arch/x86/xen/enlighten_pv.c
>>>> @@ -1162,6 +1162,7 @@ static const typeof(pv_ops) xen_cpu_ops __initconst = {
>>>>                .write_cr4 = xen_write_cr4,
>>>>
>>>>                .wbinvd = pv_native_wbinvd,
>>>> +             .wbnoinvd = pv_native_wbnoinvd,
>>>>
>>>>                .read_msr = xen_read_msr,
>>>>                .write_msr = xen_write_msr,
>>>
>>> this, what is the point having a paravirt hook which is wired to
>>> native_wbnoinvd() in all cases?
>>>
>>> That just seems like overhead for overhead sake.
>>
>> I'm mirroring what's done for WBINVD here, which was changed to a
>> paravirt hook in 10a099405fdf ("cpuidle, xenpv: Make more PARAVIRT_XXL
>> noinstr clean") in order to avoid calls out to instrumented code as
>> described in the commit message in more detail. I believe a hook is
>> similarly required for WBNOINVD, but please let me know if you
>> disagree. Thanks!
> 
> Then the question is why we need to add WBINVD/WBNOINVD to the paravirt
> hooks.
> 

We don't.

The wbinvd hook is a leftover from lguest times.

I'll send a patch to remove it.


Juergen

P.S.: As the paravirt maintainer I would have preferred to be Cc-ed in the
       initial patch mail.

