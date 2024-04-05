Return-Path: <kvm+bounces-13696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BEE88999A1
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:38:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7552B22800
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F8741607BE;
	Fri,  5 Apr 2024 09:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GdQbSXJE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE89F16078D
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 09:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712309885; cv=none; b=qcpJw0ir2xt/Q5xa4vHYH8d3kccQFxFNSiA4prIySwxkqh02ZdKh6xEijp2gZR/FUo0rCZnmYNSfLIA+Ew9nlGjPzVgtgZt8UwrIlNJ5tscsIG1pOa1sk/bHn2yQpes5PpzItLkoFmeQVvwG6xBy2CIJOW/Th0QuZcZG5pGQR9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712309885; c=relaxed/simple;
	bh=GkRFkjj3yHtzdRR99kfcHdzefMolzFxP8TwNQvvTfbw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jZxo26z99OuQ2RU5RWOmvNZ0WZ+QkihJiJyU/yO7GJkLSq8z8RYCS/RoHNqMFakP0mCIPivytJPMMi2XcoFT+hwoJFmXq5GBLyMEAMc1qg27KSnUn7V+4RMOBffgsFCSXHGVzfVHzU6rnLIg5BdIuQeLsH/3RLFeohuksd6xRW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GdQbSXJE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712309882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V3uuBiJkAylOmO9OjZj3QvZBOcaQFjZAsmRqZXYAPrA=;
	b=GdQbSXJEUkFe/RN2LZSLBi5Xl5jojThuJonrK8CbKlTOqOiJE6lknDrtISntebLXigO1JF
	G+HsJ1sTPXbWP881OmWiPZv6drNQgL15/qCdgm5yrIwkRXIKnRedfK205jntbcTyhYlfw1
	iDoMd5vz2jFVoCEWZ8Wn+4XOe9Kb0RI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-oRzpRCUWOu6TnIXXKDxZcQ-1; Fri, 05 Apr 2024 05:38:01 -0400
X-MC-Unique: oRzpRCUWOu6TnIXXKDxZcQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-343c86edeb7so820867f8f.1
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 02:38:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712309880; x=1712914680;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V3uuBiJkAylOmO9OjZj3QvZBOcaQFjZAsmRqZXYAPrA=;
        b=FuaxvnyPFUeflKBYoK09ukvo/B2iP/eSCM6Rt78vkbsGipSqNMslBz/cNTyS1HFAKu
         iY1I7sC5C4rNJJiJoh6XNIvh6IabUcEcuLtWWHZ1exJj/Ga6AgqubUyx55TurtTs5DLB
         hoWcFPypj37jp+Gi6OX22O2poSr67sZFnGLaPd9fXM4MhIriM4PsmoMYeo/gDw/BVpNe
         fHSSVdmJup+aTGgOtpAFOq/scm6NIksH28OvAp7qauV6Qoh16Hnd5aDOUM0zr+fDwBFJ
         719BkcjcQl/PYcIBGuoymt3mAffAirokTwLAa8VMkaMdpHqDRxd8rSJKtMkMCCCtNanK
         l/Gg==
X-Forwarded-Encrypted: i=1; AJvYcCUTLGT7c1zNwZ1j3yxjghyTV4da16G+7rhznev5wwb+QsfHQBBDM7/38x7ZdXQdLQHVsVsEbbSkpcIrFsY/ndIkrs/I
X-Gm-Message-State: AOJu0YzlD17ik6JmX8iqqtY67WOxZgJfkxpmp9FHYiIKv/jRvid8iz+4
	E+pv3V1o4prA7uQqllfL4O09IC3amOtJXv4yMhNLwcI/X+N/1RVGNqCBsp7OLsQyrlWP+RzvFJ8
	Z3d4O2QOadsu25/c5bLi7g6YvIRHABDWHIvlLkIVSJDoWMalljNoIFkwStAC6WAdQ7lebsyzCYl
	J8hy7Qj+I47N6BL1o00AsCsHou
X-Received: by 2002:a5d:474c:0:b0:33e:6d6c:8503 with SMTP id o12-20020a5d474c000000b0033e6d6c8503mr739455wrs.16.1712309880126;
        Fri, 05 Apr 2024 02:38:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHrW2E4L8dtYMZfT2FVzU8jH+3wWVUZgUPVuxswxS6TVAJ98ONwuEP32ytUfAH2YUgdwoJe+pjiuXTobnp23Ys=
X-Received: by 2002:a5d:474c:0:b0:33e:6d6c:8503 with SMTP id
 o12-20020a5d474c000000b0033e6d6c8503mr739443wrs.16.1712309879759; Fri, 05 Apr
 2024 02:37:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240320005024.3216282-1-seanjc@google.com> <4d04b010-98f3-4eae-b320-a7dd6104b0bf@redhat.com>
 <CALzav=eLH+V_5Y6ZWsRkmnbEb6fxPa55B7xyWxP3o6qsrs_nHA@mail.gmail.com>
 <a2fff462-dfe6-4979-a7b2-131c6e0b5017@redhat.com> <ZgygGmaEuddZGKyX@google.com>
 <ca1f320b-dc06-48e0-b4f5-ce860a72f0e2@redhat.com> <Zg3V-M3iospVUEDU@google.com>
 <42dbf562-5eab-4f82-ad77-5ee5b8c79285@redhat.com> <Zg7j2D6WFqcPaXFB@google.com>
 <b3ea925f-bd47-4f54-bede-3f0d7471e3d7@redhat.com> <Zg8jip0QIBbOCgpz@google.com>
 <36e1592a-e590-48a0-9a79-eeac6b41314b@redhat.com>
In-Reply-To: <36e1592a-e590-48a0-9a79-eeac6b41314b@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 5 Apr 2024 11:37:47 +0200
Message-ID: <CABgObfbykeRXv2r2tULe6_SwD7DkWPaMTdc6PkAUb3JmTodf4w@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: Rework marking folios dirty/accessed
To: David Hildenbrand <david@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Stevens <stevensd@chromium.org>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 5, 2024 at 8:53=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:
> >       mmu_notifier_invalidate_range_start(&range);
> >       tlb_start_vma(&tlb, vma);
> >       walk_page_range(vma->vm_mm, range.start, range.end,
> >                       &madvise_free_walk_ops, &tlb);
> >       tlb_end_vma(&tlb, vma);
> >       mmu_notifier_invalidate_range_end(&range);
> >
>
> Indeed, we do setup the MMU notifier invalidation. We do the start/end
> ... I was looking for PTE notifications.
>
> I spotted the set_pte_at(), not a set_pte_at_notify() like we do in
> other code. Maybe that's not required here (digging through
> documentation I'm still left clueless). [...]
> Absolutely unclear to me when we *must* to use it, or if it is. Likely
> its a pure optimization when we're *changing* a PTE.

Yes, .change_pte() is just an optimization. The original point of it
was for KSM, so that KVM could flip the sPTE to a new location without
first zapping it. At the time there was also an .invalidate_page()
callback, and both of them were *not* bracketed by calls to
mmu_notifier_invalidate_range_{start,end}()

Later on, both callbacks were changed to occur within an
invalidate_range_start/end() block.

Commit 6bdb913f0a70 ("mm: wrap calls to set_pte_at_notify with
invalidate_range_start and invalidate_range_end", 2012-10-09) did so
for .change_pte(). The reason to do so was a bit roundabout, namely to
allow sleepable .invalidate_page() hooks (because .change_pte() is not
sleepable and at the time .invalidate_page() was used as a fallback
for .change_pte()).

This however made KVM's usage of the .change_pte() callback completely
moot, because KVM unmaps the sPTEs during .invalidate_range_start()
and therefore .change_pte() has no hope of succeeding.

(Commit 369ea8242c0f ("mm/rmap: update to new mmu_notifier semantic
v2", 2017-08-31) is where the other set of non-bracketed calls to MMU
notifier callbacks was changed; calls to
mmu_notifier_invalidate_page() were replaced by calls to
mmu_notifier_invalidate_range(), bracketed by calls to
mmu_notifier_invalidate_range_{start,end}()).

Since KVM is the only user of .change_pte(), we can remove
.change_pte() and set_pte_at_notify() completely.

Paolo

> __replace_page() uses it with __replace_page() when replacing the mapped
> page. And migrate_vma_insert_page() uses it with MMU_NOTIFY_MIGRATE.
>
> Other code (e.g., khugepaged) doesn't seem to use it as well.
>
> ... so I guess it's fine? Confusing.
>
> --
> Cheers,
>
> David / dhildenb
>


