Return-Path: <kvm+bounces-65224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B1E96C9FF73
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 17:29:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 077D33030D9C
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 16:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FC6D34C155;
	Wed,  3 Dec 2025 16:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XgWnnyBf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7616434C137
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 16:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777712; cv=none; b=iFYOr2vuqKweERK8nEu587o2yMqYf8snyHHjXXCUe8i5P93uMypCz6XW795gNE6Q+VWhBXBQ7A2LlY2CC1CMXTOTAhxOBfYcI5aYSyS/MTdIKSfZzr653JBFkTkWVxrxHsbTFiS9JCgB8iPzuIgqQjQ0uF/Dhd0zqoERj6qvN74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777712; c=relaxed/simple;
	bh=GPDfJzod4BMwB/jmajkSIg41BnVKMpR7k2O70/rBDvg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cqIp/CWmHz62e62BpR+ohE/5BdHxl7bitqearMfjoKuIVATGMH4xI4vFsTlswIW6cYxQbikBhKAz9IKdjrplbDHZu5PUyxHedR2quc1r9VxMIY3T6RmHw3LMciU/LxLsl1dRptMT7PfQz79VqYPwWg/VoYrmY6HmVcylDgm8CK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XgWnnyBf; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6416581521eso7660094a12.2
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 08:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764777709; x=1765382509; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YkQttknYbA9t2pEB6SBl2xoMwHanEg94ZMG4/4IgIUE=;
        b=XgWnnyBfxOTqduAApWV8EPjhyndDDjqX40lhXwkuBMvhlzy8aJSbl0oaHsw0hrz4M3
         z+Y/U3ELnHzqyObEmcBC31JjxAxjG3sD76T3T07S0RoiaEye+idK7fGyY6NhTnyysm3l
         fztHPZc7BeOXK21HkC1Kidnv0WVDpbkLda6c7vdSvhaZc3nKGGG+bV5CBO8+NY5ouiej
         FgkahMIggEar3SQPlZHd5S5m19uebJBWwZqREvZe7TPe/+6uokbRW93TuPW0gRTwELxu
         7RXuIUDgUgwbWR9t9yFgVJy78suAwS0KqBXq7ev3tRlaNmnrcWRvNwhnyyjHtTkbO70T
         V5DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764777709; x=1765382509;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YkQttknYbA9t2pEB6SBl2xoMwHanEg94ZMG4/4IgIUE=;
        b=hQijsYhUmiWpca4ygtmSYAsd3XcyyFpJ40m1hlECgpYoEU3pNE5OaPS2dsMxjlKHht
         sbJcJI5bcqB8lqqd8E54WvcRNtbGoVLeDTrWxQYj52sOPrOANgaS9fuHmEU3x4sLwMyB
         72Y0WoL8ls3uDkxABI0jGBJa7iViAzvApT8thPs8p/BCcu5dwXhL/KOnkyZm/C3PIv4j
         w2LgMX/XGlxF/8kS0C6eT6A1umia7pjlRpi806MR8ZyCGNovzMPxTkcWn/PxULRExIO4
         23KCCNqYPRBAsIDligfvgyLVyDhrvxnDLH3y0Wum2Z/L8s39SbQCI2ElFrU6mQU/yuSu
         Vpcg==
X-Forwarded-Encrypted: i=1; AJvYcCVJNJU3d9wgOUU9KmnFjmM7s5U/8FardwQqyNBJHd4tWNk+6hFGX9LyHG2I1aSuHEN/lGw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIQAoS6lgmkOtLbJNmm3ODo4VtSki8pqfGmGCrmI+6HjLINv37
	pTBULxedh1A38scpy6vWOoN2zSG0hdbZYodzPhqO8//DTHntD5XmFk1Q77qttNzckdbcUgIF6eT
	eDaKGfBRSARVakA==
X-Google-Smtp-Source: AGHT+IFQsvq53QQzhPM21j/ZvLK9YUejDCkT7o8XXdJUdJGjAS4+CmZVCp2SEd/GP6hDVV4VL+KbikLlKQfBuw==
X-Received: from edaa13.prod.google.com ([2002:a05:6402:24cd:b0:641:9a93:f230])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:4301:b0:640:fb1f:e934 with SMTP id 4fb4d7f45d1cf-6479c4b6205mr2160068a12.32.1764777708776;
 Wed, 03 Dec 2025 08:01:48 -0800 (PST)
Date: Wed, 03 Dec 2025 16:01:47 +0000
In-Reply-To: <20251203144159.6131-1-itazur@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251203144159.6131-1-itazur@amazon.com>
X-Mailer: aerc 0.21.0
Message-ID: <DEOPHISOX8MK.2YEMZ8XKLQGMC@google.com>
Subject: Re: [RFC PATCH 0/2] KVM: pfncache: Support guest_memfd without direct map
From: Brendan Jackman <jackmanb@google.com>
To: Takahiro Itazuri <itazur@amazon.com>, <kvm@vger.kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Fuad Tabba <tabba@google.com>, Brendan Jackman <jackmanb@google.com>, 
	David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
	Paul Durrant <pdurrant@amazon.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Patrick Roy <patrick.roy@campus.lmu.de>, Takahiro Itazuri <zulinx86@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed Dec 3, 2025 at 2:41 PM UTC, Takahiro Itazuri wrote:
> [ based on kvm/next with [1] ]
>
> Recent work on guest_memfd [1] is introducing support for removing guest
> memory from the kernel direct map (Note that this work has not yet been
> merged, which is why this patch series is labelled RFC). The feature is
> useful for non-CoCo VMs to prevent the host kernel from accidentally or
> speculatively accessing guest memory as a general safety improvement.
> Pages for guest_memfd created with GUEST_MEMFD_FLAG_NO_DIRECT_MAP have
> their direct-map PTEs explicitly disabled, and thus cannot rely on the
> direct map.
>
> This breaks the features that use gfn_to_pfn_cache, including kvm-clock.
> gfn_to_pfn_cache caches the pfn and kernel host virtual address (khva)
> for a given gfn so that KVM can repeatedly access the corresponding
> guest page.  The cached khva may later be dereferenced from atomic
> contexts in some cases.  Such contexts cannot tolerate sleep or page
> faults, and therefore cannot use the userspace mapping (uhva), as those
> mappings may fault at any time.  As a result, gfn_to_pfn_cache requires
> a stable, fault-free kernel virtual address for the backing pages,
> independent of the userspace mapping.
>
> This small patch series enables gfn_to_pfn_cache to work correctly when
> a memslot is backed by guest_memfd with GUEST_MEMFD_FLAG_NO_DIRECT_MAP.
> The first patch teaches gfn_to_pfn_cache to obtain pfn for guest_memfd-
> backed memslots via kvm_gmem_get_pfn() instead of GUP (hva_to_pfn()).
> The second patch makes gfn_to_pfn_cache use vmap()/vunmap() to create a
> fault-free kernel address for such pages.  We believe that establishing
> such mapping for paravirtual guest/host communication is acceptable as
> such pages do not contain sensitive data.
>
> Another considered idea was to use memremap() instead of vmap(), since
> gpc_map() already falls back to memremap() if pfn_valid() is false.
> However, vmap() was chosen for the following reason.  memremap() with
> MEMREMAP_WB first attempts to use the direct map via try_ram_remap(),
> and then falls back to arch_memremap_wb(), which explicitly refuses to
> map system RAM.  It would be possible to relax this restriction, but the
> side effects are unclear because memremap() is widely used throughout
> the kernel.  Changing memremap() to support system RAM without the
> direct map solely for gfn_to_pfn_cache feels disproportionate.  If
> additional users appear that need to map system RAM without the direct
> map, revisiting and generalizing memremap() might make sense.  For now,
> vmap()/vunmap() provides a contained and predictable solution.
>
> A possible approach in the future is to use the "ephmap" (or proclocal)
> proposed in [2], but it is not yet clear when that work will be merged.

(Nobody knows how to pronounce "ephmap" aloud and when you do know how
to say it, it sounds like you are sayhing "fmap" which is very
confusing. So next time I post it I plan to call it "mermap" instead:
EPHemeral -> epheMERal).

Apologies for my ignorance of the context here, I may be missing
insights that are obvious, but with that caveat...

The point of the mermap (formerly "ephmap") is to be able to efficiently
map on demand then immediately unmap without the cost of a TLB
shootdown. Is there any reason we'd need to do that here? If we can get
away with a stable vmapping then that seems superior to the mermap
anyway.

Putting it in an mm-local region would be nice (you say there shouldn't
be sensitive data in there, but I guess there's still some potential for
risk? Bounding that to the VMM process seems like a good idea to me)
but that seems nonblocking, could easily be added later. Also note it
doesn't depend on mermap, we could just have an mm-local region of the
vmalloc area. Mermap requires mm-local but not the other-way around.


