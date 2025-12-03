Return-Path: <kvm+bounces-65229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CB57FCA0595
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 18:20:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BEC51300644E
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 17:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB4A2314A9F;
	Wed,  3 Dec 2025 17:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="euvZDA3g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D74F30B51F
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 17:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781593; cv=none; b=BkZkH5Kq4JMypqwiNLZmZ6N8va+ceR1SMV3mR9F9vyhI/4OkrAD2bd19Jj4gBTshFgQ1iUpZAD6SXsgJrFQuMiKOHw7M+ciq3kEdW3JAJY+asCOUJlpX7w8cgYK0QHbtVFwZHCB8IWcJVlZxwQ/FOw81oRDJAAwYn60ckKKk7Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781593; c=relaxed/simple;
	bh=zclxRqTX87lo6NObPUZVkOA86FA3wZclw9ZSgjUJblQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=quLKX9grD/ua1EeKjOPLOolB1xJa1IwzFaI1GZzEsgrSGueGUoRTQWGulxgu9/shHvnaSUOcNHKqQzVSNcP5BX6QviZRSiyBYGtv3nDfOQyUP9sLPP4wwOwMAqdeV7SftKbX7j17+Nn4fbhcsU/svKVWme0W3t44nO0Rc5Guc/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=euvZDA3g; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b735400de44so581043566b.0
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 09:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764781589; x=1765386389; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zclxRqTX87lo6NObPUZVkOA86FA3wZclw9ZSgjUJblQ=;
        b=euvZDA3gsh2vDB6cHQK9Z58fYc1UBAu4y7x4gVk4NChicPo792y/+sDC281DTpRTZp
         HoL3xMZgMY/oH4JScWoeVAiU7oL/gyRL7G9A4DZsRPzW52a+JViA6slU8iynIrZ1wCjg
         G9OGBYtpvaGcE3WsvteE4T1cnfZZGOz0ZqXM1TXQdoDGgRrdKNP/BVduuOfyXYCfqlWW
         qKP6jU1dI9w4YTJZUdcCk2QSB18MXEZy9MY+EFSDNKuz1aTLHApWXkflsrNbNkgIuw5S
         517O0U5qJx7asZghQMhPc7S0kSmT7XVmfuI3eWIPb49R++17lCUo9WHEuiVz5oLPI3h6
         4sZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764781589; x=1765386389;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zclxRqTX87lo6NObPUZVkOA86FA3wZclw9ZSgjUJblQ=;
        b=u0X4dLvzdIGMh7Stqdyqf/cpVGGCnpib/bmGhcouC5OL5BAlrEcLi7fbzm8ipf8nKY
         rFU34tKmH0ht5pIV3jpd5UKRFQ8t8xDBgckxMRidnQqAIckfxeTG7f0xCi0asFumzMb0
         /2zgtRqw/wpNfOPwNMLKBow2qifKsi8V49Kw9HXwdgUioF4Bs1XPX8C4D2vXpUiYgg/t
         vPWXfOb7uuVPYx+rovtFFeN5QTG1AVMQO/NabartldRjTXlDvMKLLJ5r6NY84AV3Idcp
         L4psx5BYWodU/MNKAE2+psKc3zqvm3kZIs9Ux5lrqNt1D/AiAugj+3P+6o+kPjGxgTO1
         ww4w==
X-Forwarded-Encrypted: i=1; AJvYcCV0hlJ5eNRlzh3POfPPj9UZ5OrjHkuPnpFZ7nlQx8FxaJtS6FoV7S0xFwQ6IvdfuDlHbZk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyufueWk6vNQaZPvfzuf1L2VCKsBYhvjpmVwKvsAf8bwTHB5qCM
	HS2iOBbmSYyvZY3m27zojRMsD6/sRfYEbwdNLEkodcV3DDB0zjnyaEg7Oq6aoUZlETbZJDStSja
	GjM45qXCIDaOKCA==
X-Google-Smtp-Source: AGHT+IHKl+ne4cXalSTX1K0FA6u1LEjh1lNftHtIoQk113eCBpyJMXtzjghC720I66Wtq6HftdFEeSNvQybHkg==
X-Received: from ejcrl22.prod.google.com ([2002:a17:907:6c16:b0:b73:8e73:a920])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:6d1c:b0:b6d:2c70:4542 with SMTP id a640c23a62f3a-b79dc51d95amr270641666b.30.1764781589331;
 Wed, 03 Dec 2025 09:06:29 -0800 (PST)
Date: Wed, 03 Dec 2025 17:06:28 +0000
In-Reply-To: <a07a6edf549cfed840c9ead3db61978c951b15e4.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251203144159.6131-1-itazur@amazon.com> <DEOPHISOX8MK.2YEMZ8XKLQGMC@google.com>
 <a07a6edf549cfed840c9ead3db61978c951b15e4.camel@infradead.org>
X-Mailer: aerc 0.21.0
Message-ID: <DEOQV1GRUTUX.1KJUWG1JTF1JJ@google.com>
Subject: Re: [RFC PATCH 0/2] KVM: pfncache: Support guest_memfd without direct map
From: Brendan Jackman <jackmanb@google.com>
To: David Woodhouse <dwmw2@infradead.org>, Brendan Jackman <jackmanb@google.com>, 
	Takahiro Itazuri <itazur@amazon.com>, <kvm@vger.kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Fuad Tabba <tabba@google.com>, David Hildenbrand <david@kernel.org>, 
	Paul Durrant <pdurrant@amazon.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Patrick Roy <patrick.roy@campus.lmu.de>, Takahiro Itazuri <zulinx86@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed Dec 3, 2025 at 4:35 PM UTC, David Woodhouse wrote:
> On Wed, 2025-12-03 at 16:01 +0000, Brendan Jackman wrote:
>> On Wed Dec 3, 2025 at 2:41 PM UTC, Takahiro Itazuri wrote:
>> > [ based on kvm/next with [1] ]
>> >=20
>> > Recent work on guest_memfd [1] is introducing support for removing gue=
st
>> > memory from the kernel direct map (Note that this work has not yet bee=
n
>> > merged, which is why this patch series is labelled RFC). The feature i=
s
>> > useful for non-CoCo VMs to prevent the host kernel from accidentally o=
r
>> > speculatively accessing guest memory as a general safety improvement.
>> > Pages for guest_memfd created with GUEST_MEMFD_FLAG_NO_DIRECT_MAP have
>> > their direct-map PTEs explicitly disabled, and thus cannot rely on the
>> > direct map.
>> >=20
>> > This breaks the features that use gfn_to_pfn_cache, including kvm-cloc=
k.
>> > gfn_to_pfn_cache caches the pfn and kernel host virtual address (khva)
>> > for a given gfn so that KVM can repeatedly access the corresponding
>> > guest page.=C2=A0 The cached khva may later be dereferenced from atomi=
c
>> > contexts in some cases.=C2=A0 Such contexts cannot tolerate sleep or p=
age
>> > faults, and therefore cannot use the userspace mapping (uhva), as thos=
e
>> > mappings may fault at any time.=C2=A0 As a result, gfn_to_pfn_cache re=
quires
>> > a stable, fault-free kernel virtual address for the backing pages,
>> > independent of the userspace mapping.
>> >=20
>> > This small patch series enables gfn_to_pfn_cache to work correctly whe=
n
>> > a memslot is backed by guest_memfd with GUEST_MEMFD_FLAG_NO_DIRECT_MAP=
.
>> > The first patch teaches gfn_to_pfn_cache to obtain pfn for guest_memfd=
-
>> > backed memslots via kvm_gmem_get_pfn() instead of GUP (hva_to_pfn()).
>> > The second patch makes gfn_to_pfn_cache use vmap()/vunmap() to create =
a
>> > fault-free kernel address for such pages.=C2=A0 We believe that establ=
ishing
>> > such mapping for paravirtual guest/host communication is acceptable as
>> > such pages do not contain sensitive data.
>> >=20
>> > Another considered idea was to use memremap() instead of vmap(), since
>> > gpc_map() already falls back to memremap() if pfn_valid() is false.
>> > However, vmap() was chosen for the following reason.=C2=A0 memremap() =
with
>> > MEMREMAP_WB first attempts to use the direct map via try_ram_remap(),
>> > and then falls back to arch_memremap_wb(), which explicitly refuses to
>> > map system RAM.=C2=A0 It would be possible to relax this restriction, =
but the
>> > side effects are unclear because memremap() is widely used throughout
>> > the kernel.=C2=A0 Changing memremap() to support system RAM without th=
e
>> > direct map solely for gfn_to_pfn_cache feels disproportionate.=C2=A0 I=
f
>> > additional users appear that need to map system RAM without the direct
>> > map, revisiting and generalizing memremap() might make sense.=C2=A0 Fo=
r now,
>> > vmap()/vunmap() provides a contained and predictable solution.
>> >=20
>> > A possible approach in the future is to use the "ephmap" (or proclocal=
)
>> > proposed in [2], but it is not yet clear when that work will be merged=
.
>>=20
>> (Nobody knows how to pronounce "ephmap" aloud and when you do know how
>> to say it, it sounds like you are sayhing "fmap" which is very
>> confusing. So next time I post it I plan to call it "mermap" instead:
>> EPHemeral -> epheMERal).
>>=20
>> Apologies for my ignorance of the context here, I may be missing
>> insights that are obvious, but with that caveat...
>>=20
>> The point of the mermap (formerly "ephmap") is to be able to efficiently
>> map on demand then immediately unmap without the cost of a TLB
>> shootdown. Is there any reason we'd need to do that here? If we can get
>> away with a stable vmapping then that seems superior to the mermap
>> anyway.
>>=20
>> Putting it in an mm-local region would be nice (you say there shouldn't
>> be sensitive data in there, but I guess there's still some potential for
>> risk? Bounding that to the VMM process seems like a good idea to me)
>> but that seems nonblocking, could easily be added later. Also note it
>> doesn't depend on mermap, we could just have an mm-local region of the
>> vmalloc area. Mermap requires mm-local but not the other-way around.
>
> Right. It's really the mm-local part which we might want to support in
> the gfn_to_pfn_cache, not ephmap/mermap per se.
>
> As things stand, we're taking guest pages which were taken out of the
> global directmap for a *reason*... and mapping them right back in
> globally. Making the new mapping of those pages mm-local where possible
> is going to be very desirable.

Makes sense. I didn't properly explore if there are any challenges with
making vmalloc aware of it, but assuming there are no issues there I
don't think setting up an mm-local region is very challinging [1]. I
have the impression the main reason there isn't already an mm-local
region is just that the right usecase hasn't come along yet? So maybe
that could just be included in this series (assuming the mermap doesn't
get merged first).

Aside from vmalloc integration the topic I just ignored when prototyping
[0] it was that it obviously has some per-arch element. So I guess for
users of it we do need to look at whether we are OK to gate the
depending feature on arch support.

[0] https://github.com/torvalds/linux/commit/4290b4ffb35bc73ce0ac9ae590f3e9=
d4d27b6397
[1] https://xcancel.com/pinboard/status/761656824202276864

