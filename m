Return-Path: <kvm+bounces-73034-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mG3aOGDFqmnVWwEAu9opvQ
	(envelope-from <kvm+bounces-73034-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 13:15:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FB45220598
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 13:15:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AB48E3158E93
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 12:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B7E738E5C5;
	Fri,  6 Mar 2026 12:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=raymakers.nl header.i=@raymakers.nl header.b="RecBsxzY"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.soverin.net (outbound.soverin.net [185.233.34.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468BA38E138
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 12:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.233.34.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772798926; cv=none; b=guMYYNKCwCctO+YkvrT3CH2+hYyVJduqFOoAX2x9Uqys+Tw4PbtanCkkgA6kXvjYfX7wzPgSXd43GCa+rxZ15ZEIQo2qUoqYix6UA00ZRfYXkAobRVUjEhY+mIquPvBsvpzpjcCeJgKsboCAzUYjxuPVXzmDPYANTWa8LaMmqLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772798926; c=relaxed/simple;
	bh=aMce7kvvmzykMlONCuoesfRf/hzhFINeo54FDqjnUEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KjapU9xJsawVJzAjafn3fWKzfL5r/lXdFlhmPtSzofdgAzpk7nRHntRUCwjuFlE+Q0vQXwOUK0r3aA1EClx+0UZSyoFOaqqAS5qUVD+9MLpYD/pPjpv4Hgm+xzEsRPQeWuoSsFk5y/uA4kzO3BQJ5uccSU/hrrpBl3fvhmaJapU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=raymakers.nl; spf=pass smtp.mailfrom=raymakers.nl; dkim=pass (2048-bit key) header.d=raymakers.nl header.i=@raymakers.nl header.b=RecBsxzY; arc=none smtp.client-ip=185.233.34.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=raymakers.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raymakers.nl
Received: from smtp.soverin.net (unknown [10.10.4.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by outbound.soverin.net (Postfix) with ESMTPS id 4fS4lz0CHNz1G2;
	Fri,  6 Mar 2026 12:02:39 +0000 (UTC)
Received: from smtp.soverin.net (smtp.soverin.net [10.10.4.100]) by soverin.net (Postfix) with ESMTPSA id 4fS4ly4TqZzF2;
	Fri,  6 Mar 2026 12:02:38 +0000 (UTC)
Authentication-Results: smtp.soverin.net;
	dkim=pass (2048-bit key; unprotected) header.d=raymakers.nl header.i=@raymakers.nl header.a=rsa-sha256 header.s=soverin1 header.b=RecBsxzY;
	dkim-atps=neutral
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raymakers.nl;
	s=soverin1; t=1772798558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0ioHcj60W3BKPFWPY/0z6B6Dj1wRBGLySgyLFdgGeLg=;
	b=RecBsxzYUT27vosnAZR2fyqD2vMj9kjMXiDoQ1V+XZ4G5Bj1b/g3jatF2F0uDnq7uds9z1
	LIaq0dfj6QhRUzljnVFZORVnZsIpaxwv6Gv45f7Puq5n0voKioGZwTmpkikk24O3jEJLcy
	Re5T03kRFXIxWPkhojsLfdOsreIjKGZNLalGVjiBQdZgn+lmsJF+ldAT4omJFv52AzgIcS
	YCHZtHaFlH95XuANrGTkYBQ7hNnwHyH3Jnd8g5rnULjcYZws5WAQsowFG3lS8r4gi+VYPU
	hGShNdEzcVPqxDMFJoSjaSrRo5I0cHGT++qnBmGBIRtHvPYi1MG2h8Uzrt2D4g==
X-CM-Envelope: MS4xfC61agICMW43iApHWrAEzRpDIKyvKtnbDV7YIStCEmNWkOQK90z9wzLPag+T4fgRwxcSFGaEwZGKUJkSF+Q4NjK+RnzUR+paWh+bNvazwqYXUBYgzO1D GaQF4FY73tF+plyjQEI3MRIntS6Y7xmde787zp8b64m+2WTY/0j+VvBE3jxBgwMVCpepMi2/hhV9LzbF/5Bf2Q2ChPoYl8N3fvmNEOCa12+WqPQta9x//GTL 8MZxt9sY9Ew9Jrnuk4PZQv2cyWQ/0vp+8XRg5ygk1YqxAj7syr01evESX4T33YcfSmwH3z0oTwkSntlUultneESBY/O8xddWdp4NNTPBoky6s6sWyzGkVayi 8ljNAU0a653I7/Mum3HtkePzSwrMK4m3f8qjYveGwYvKd2oDmTX/YwAlWoFNqvpFkle5gkQVJt7sh9bI72orgFV+xdfOjNpK9OzXn4Zj/n/FxDHxEAn5l+R/ NCDiUtfXZiFcTRQ6527t8jK3tmcqeYzU3NO11g==
X-Soverin-Id: 019cc307-3f30-7bde-a98a-d5a4d2da7a12
Message-ID: <33837d76-eaa5-4495-be4d-80b366034bcf@raymakers.nl>
Date: Fri, 6 Mar 2026 13:02:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3] KVM: x86: use array_index_nospec with indices that
 come from guest
To: David Woodhouse <dwmw2@infradead.org>,
 Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
 Anel Orazgaliyeva <anelkz@amazon.de>, stable <stable@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20250804064405.4802-1-thijs@raymakers.nl>
 <ac94394405bf7e878c8ff0acf87db922dc4af48c.camel@infradead.org>
 <CALMp9eTSb3YrLRxnSbYQmAsK1SKA3Job6z2VjUWcKpPOGbWvRw@mail.gmail.com>
 <aaoDtzpY-2y-c-66@google.com>
 <FFDA9F60-F0AD-4A92-8203-40DE82A921A7@infradead.org>
 <aaozvNtzczwlyz_3@google.com>
 <cc9d4b2f588babeba21318ce40ec5814d1c19084.camel@infradead.org>
Content-Language: en-US
From: Thijs Raymakers <thijs@raymakers.nl>
In-Reply-To: <cc9d4b2f588babeba21318ce40ec5814d1c19084.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spampanel-Class: ham
X-Rspamd-Queue-Id: 6FB45220598
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[raymakers.nl,reject];
	R_DKIM_ALLOW(-0.20)[raymakers.nl:s=soverin1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[raymakers.nl:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73034-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thijs@raymakers.nl,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,infradead.org:email,raymakers.nl:dkim,raymakers.nl:mid]
X-Rspamd-Action: no action


On 3/6/26 9:05 AM, David Woodhouse wrote:
> On Thu, 2026-03-05 at 17:54 -0800, Sean Christopherson wrote:
>> On Thu, Mar 05, 2026, David Woodhouse wrote:
>>> On 5 March 2026 23:29:11 CET, Sean Christopherson <seanjc@google.com> wrote:
>>>> On Thu, Mar 05, 2026, Jim Mattson wrote:
>>>>> On Thu, Mar 5, 2026 at 12:31 PM David Woodhouse <dwmw2@infradead.org> wrote:
>>>>>> On Mon, 2025-08-04 at 08:44 +0200, Thijs Raymakers wrote:
>>>>>>> min and dest_id are guest-controlled indices. Using array_index_nospec()
>>>>>>> after the bounds checks clamps these values to mitigate speculative execution
>>>>>>> side-channels.
>>>>>>>
>>>>>> (commit c87bd4dd43a6)
>>>>>>
>>>>>> Is this sufficient in the __pv_send_ipi() case?
>>>>>>
>>>>>>> --- a/arch/x86/kvm/lapic.c
>>>>>>> +++ b/arch/x86/kvm/lapic.c
>>>>>>> @@ -852,6 +852,8 @@ static int __pv_send_ipi(unsigned long *ipi_bitmap, struct kvm_apic_map *map,
>>>>>>>        if (min > map->max_apic_id)
>>>>>>>                return 0;
>>>>>>>
>>>>>>> +     min = array_index_nospec(min, map->max_apic_id + 1);
>>>>>>> +
>>>>>>>        for_each_set_bit(i, ipi_bitmap,
>>>>>>>                min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))) {
>>>>>>>                if (map->phys_map[min + i]) {
>>>>>>                          vcpu = map->phys_map[min + i]->vcpu;
>>>>>>                          count += kvm_apic_set_irq(vcpu, irq, NULL);
>>>>>>                  }
>>>>>>          }
>>>>>>
>>>>>> Do we need to protect [min + i] in the loop, rather than just [min]?
>>>>>>
>>>>>> The end condition for the for_each_set_bit() loop does mean that it
>>>>>> won't actually execute past max_apic_id but is that sufficient to
>>>>>> protect against *speculative* execution?
>>>>>>
>>>>>> I have a variant of this which uses array_index_nospec(min+i, ...)
>>>>>> *inside* the loop.
>>>>> Heh. Me too!
>>>> LOL, OMG, get off your high horses you two and someone send a damn patch!
>>> Heh, happy to, but it was actually a genuine question. Our pre-embargo
>>> patches did it in the loop but the most likely explanation seemed to be that
>>> upstream changed it as a valid optimization (because somehow the loop wasn't
>>> vulnerable?), and that we *can* drop the old patches in favour of the
>>> upstream one.
>>>
>>> If no such reason exists for why the patch got changed, I'm happy to post the
>>> delta.
>> AFAIK, there was no such justification.  I'm pretty sure the only upstream version
>> I've ever seen is what ended up in-tree.
>>
>> Speculation stuff definitely isn't my area of expertise.  Honestly, you, Jim, and
>> a few others are who I'd go bug for answers for this sort of thing, so unless
>> someone chimes in with a strong argument for the current code, I say we go with
>> the more conservative approach.
> Posted as
> https://lore.kernel.org/kvm/9d50fc3ca9e8e58f551d015f95d51a3c29ce6ccc.camel@infradead.org

I looked back to my notes, and this seems to be an oversight on my end. 
The goal of the original
patch was to remove a speculative cache load with an arbitrary value of 
'min', because it allowed
a guest to load any host memory into its cache. I thought it reduced the 
maximum speculative buffer
out-of-bounds load from all of host memory to no out-of-bounds load, but 
it reduced it to a maximum
of BITS_PER_LONG elements of map->phys_map instead.

For the perspective of my original proof-of-concept, I do not see how an 
attacker could abuse this
small window. In theory, depending on the data that sits directly after 
the phys_map array, it could
theory be used to leak a pointer from the host (and probably not much 
else). Last time I checked, there
was no data directly after the phys_map array, but that could change due 
to any number of reasons
that are unrelated to this particular piece of code.

I am in favor of the more conservative approach and using 
array_index_nospec *inside* of the loop.
The original patch does prevent my original proof-of-concept, which is 
probably why I missed this. I
do not think that the current speculative out-of-bounds load is 
exploitable in practice, but it is better
to take a more conservative approach in this case.


