Return-Path: <kvm+bounces-28827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2F2A99DA87
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 02:08:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EB1C1C21421
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 00:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C603C3C;
	Tue, 15 Oct 2024 00:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mY8qu9Al"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E3119A
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 00:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728950876; cv=none; b=r5GP4H5g2C7StocOY/gi5gMEe0Ize6wg7uG9DIsOQ3GGVLYtMh1x+Ma7ll3XRUSXH/Ig5pmzWpF8xkG4giVYSwdAg/t+1AdMH95yRZsa1OP8WNj7Rpi1IlGQT4xF9JRTakB1YQUiNVrbpSIJ6Z+DwAAOKYz4Cj2N0t1w2eWHUR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728950876; c=relaxed/simple;
	bh=tF/wdh6eCNGHJyuFiF0zNCWlQfBb7gnQY3rCskvzGus=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=COgOOjJBLpPthdxMFuxaLrCJ5PnmTjmPcEIr6Z9iBDkrIlJ8WFVJl9t7kc1SIXEPT7tcQ5hfZs+9BYIX3srRdC3d2Dl1uaz4koG2G7gV26yf32YVUOElzTitUzBx+beuyb2cxERC/dkZM75L/MoiNtOV/uNlImoP0m+FAvGc/Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mY8qu9Al; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e290d5f83bcso3889607276.0
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 17:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728950874; x=1729555674; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0k5ziZv+luz4h4U9vFxjQyLKnmTaKDBU/6xsRlEbTbw=;
        b=mY8qu9AloVYPABAXlBL4ADR5EujVh12wuWKzua94khC+WdJCw0GelAgqOfBhNjCBcm
         Kd/SqhrvHaBcMjTneWR/sHvpWusln8GJFoIKPdFGYiEU7bpi3CakCZgZVENasU1eQnq0
         ihCRUv7nJgQ/yqoKyPcNAd87cyC62gJt3KAwtom3hpS/dixOnBPrfsG5twv23OMfCCWn
         JAKOwym5yXvTZCSL9wgGivKO3x3vndCUdKZQcM1JB0u1sMr1q/IFZwwQUcK+E3NY6P6f
         vSiI9GWL0t5wPJXXua83s7vwgTsDT2ELV6vpPvURj3kb6C/AARSOgMz2PQseIQuybF3N
         hqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728950874; x=1729555674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0k5ziZv+luz4h4U9vFxjQyLKnmTaKDBU/6xsRlEbTbw=;
        b=abv1UEQWF52OW6DpHGxNizFZMU6r8FV/me+QhUc4A/5lOHx9RUFgwQ5ADPWRBjytiE
         T0tj4IR+KSiNd0PYw41xVksz288VBiMEHCDm9bzwMvZjF/M/DydrJHX6W/qHJCYyx1/J
         B/oguUV1YhM25Qv4Myq2FWEhLRdhAv+SUbOuNRSDzraYvQW3o9itryaJzAyXD2ZWm4gc
         5IBVg712PxEnb+Pmpzybp85b1BdxNVPk6/M8leb4ZU3hg0m01GsvHMW7YaQNjFLyHxOh
         q7NfNsX44p7i78aasmcXHBKrSVO0a4DRAycI6GclWo6NuNadtTTxzNrXOpO5EIw4mjvo
         eQNw==
X-Forwarded-Encrypted: i=1; AJvYcCXCq5BsWGuAglOJxi4ygFbCsa0G/J4jKsGtDXQPetAb5Us7BPCo3Vu/hs1bDdm8tylNt2w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4Ow4XiOKhhaj56u+ItL6jvgqFyOYxfEOY2aj14wXXmPsk/fvu
	izA/Ij+AtrPnPO3a3tQB7ZptY7c6S4W+H2RKzhEa01QvYlWa+S0sPo/eY0h70oI65LW9SP42IdC
	NWmJjiZVCSJmWRhGi4NfgDhEFS6jSoqdTAUbA
X-Google-Smtp-Source: AGHT+IGPIi5KCS6+nJghaiqqBaIDBteS+Nw+yIW3S78bDe3HfZ8DlWRHR3b0JckOrBruI74JpMNZzOH6luJE20JY9vk=
X-Received: by 2002:a05:6902:c07:b0:e29:29b0:2b2a with SMTP id
 3f1490d57ef6-e2931deb4c6mr7548470276.51.1728950873598; Mon, 14 Oct 2024
 17:07:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240926013506.860253-1-jthoughton@google.com> <Zw2no4OGDVK7m8QR@google.com>
In-Reply-To: <Zw2no4OGDVK7m8QR@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 14 Oct 2024 17:07:17 -0700
Message-ID: <CADrL8HUP1=eXE5QpVrKjgQGpusr_Raejr1sY2LLW1uSigpptOw@mail.gmail.com>
Subject: Re: [PATCH v7 00/18] mm: multi-gen LRU: Walk secondary MMU page
 tables while aging
To: Sean Christopherson <seanjc@google.com>, Yu Zhao <yuzhao@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Stevens <stevensd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2024 at 4:22=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Sep 26, 2024, James Houghton wrote:
> > This patchset makes it possible for MGLRU to consult secondary MMUs
> > while doing aging, not just during eviction. This allows for more
> > accurate reclaim decisions, which is especially important for proactive
> > reclaim.
>
> ...
>
> > James Houghton (14):
> >   KVM: Remove kvm_handle_hva_range helper functions
> >   KVM: Add lockless memslot walk to KVM
> >   KVM: x86/mmu: Factor out spte atomic bit clearing routine
> >   KVM: x86/mmu: Relax locking for kvm_test_age_gfn and kvm_age_gfn
> >   KVM: x86/mmu: Rearrange kvm_{test_,}age_gfn
> >   KVM: x86/mmu: Only check gfn age in shadow MMU if
> >     indirect_shadow_pages > 0
> >   mm: Add missing mmu_notifier_clear_young for !MMU_NOTIFIER
> >   mm: Add has_fast_aging to struct mmu_notifier
> >   mm: Add fast_only bool to test_young and clear_young MMU notifiers
>
> Per offline discussions, there's a non-zero chance that fast_only won't b=
e needed,
> because it may be preferable to incorporate secondary MMUs into MGLRU, ev=
en if
> they don't support "fast" aging.
>
> What's the status on that front?  Even if the status is "TBD", it'd be ve=
ry helpful
> to let others know, so that they don't spend time reviewing code that mig=
ht be
> completely thrown away.

The fast_only MMU notifier changes will probably be removed in v8.

ChromeOS folks found that the way MGLRU *currently* interacts with KVM
is problematic. That is, today, with the MM_WALK MGLRU capability
enabled, normal PTEs have their Accessed bits cleared via a page table
scan and then during an rmap walk upon attempted eviction, whereas,
KVM SPTEs only have their Accessed bits cleared via the rmap walk at
eviction time. So KVM SPTEs have their Accessed bits cleared less
frequently than normal PTEs, and therefore they appear younger than
they should.

It turns out that this causes tab open latency regressions on ChromeOS
where a significant amount of memory is being used by a VM. IIUC, the
fix for this is to have MGLRU age SPTEs as often as it ages normal
PTEs; i.e., it should call the correct MMU notifiers each time it
clears A bits on PTEs. The final patch in this series sort of does
this, but instead of calling the new fast_only notifier, we need to
call the normal test/clear_young() notifiers regardless of how fast
they are.

This also means that the MGLRU changes no longer depend on the KVM
optimizations, as they can motivated independently.

Yu, have I gotten anything wrong here? Do you have any more details to shar=
e?

