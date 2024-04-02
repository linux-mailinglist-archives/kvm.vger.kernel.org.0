Return-Path: <kvm+bounces-13388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 796A0895AD3
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 19:39:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06E071F222EB
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 17:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53C9915AAA9;
	Tue,  2 Apr 2024 17:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cwB2i7Ue"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969A115A4AD
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 17:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712079536; cv=none; b=cOJl33HRrqOUFsTf8IWE6teBEMx3tKKZZdK+a6PNehkqHkTfAT4+hnHMy+7bIZmL0txmwTrC1qN77bM0L94ZFMOvDcfgiQvX+mhMTUq6PQAwCOSApSbMRSnvjg3vdW6dGyBEh6F/ZyI/Ajr63/50aEu6oNcRY3Wr4MsCyYHTGXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712079536; c=relaxed/simple;
	bh=LqX3r9GksoEpc+7Ng+4MLLxjUZmC19R39O+V0rsX580=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=En97q5qVrllvrZIHZeeeISjsqxg1SHMD5fg0nLpSutkAHp49JvrjbOC8wU8uwS9z5ggiIu37o5cfDTKY2IqqmZSFqwL+/StGD2fXYRu1Z0pk4U2+LbdohhiwygBc3QshIL7msC3lI+vNYi0irXPK2MpUB9KvORWPIwaA6KuDlJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cwB2i7Ue; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-34378a6994cso391040f8f.1
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 10:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712079533; x=1712684333; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tqLsic/9tND6Pn/uxBhTD9J9JZInJHfRGv9OavLb+Kc=;
        b=cwB2i7Uetq9KpupJpR8qKKsEl1se7gP4/taVXa+n/nbSY/jkWSwYX+1k4K9NxiSxb/
         hmynfuObfFG9SWBZYAZ2rPlAKyr2F2WCPIkcoyl1zHvk2jao8tEQ0maVuRvhDcJhXj7q
         GSMrov1hiBGVFykOIR83n+H4VV39vWd8h4Nng3Dn4OQ15NzC8XNz5if6X1IJdqoZiHPQ
         doj1T2bWBuCpkxcejU1cC/vfoiwWJeTJYnYkuTRzTVHzJKVsIm6rGTnCNUjh7yH8eJe2
         TWFPPJPuW+ujJpIqkdQmgYVEl1wIQ3aqt3eA+RBjcxC5oTQhDnmJKcOCJ/VgRt2Z3bFw
         3CNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712079533; x=1712684333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tqLsic/9tND6Pn/uxBhTD9J9JZInJHfRGv9OavLb+Kc=;
        b=U5r5CtGOav/M7NcOeqXRlTMdkfv6WsY3cvezOaC0S5muYpa5jJxf8FzeuX90jk5GPW
         d+06RSxaBE2F02lfDsNW9EtYR00UQQcfESeCSZg11Ju13EWg3eJmoOkjzfkFgoI/Cp1a
         AbgXesilzYQt77dd71w3iyQZdp78WtiQANGIlVN73B+rdFXsvWwZrAq/cjl6b0XOsSiD
         sgPovkKaVNKj8ZJkne+1TyKABRd332CxQMrJ8PRDkgPFIiwBLA4Lc2auHmr6ABXvMehX
         Wevl3zBJ/H+QqmqotEyffPNvoiltot8CD67nGv6aI/Aa28hAfYw9lVQk4GVoUZQE6/xd
         sEaA==
X-Forwarded-Encrypted: i=1; AJvYcCUkL+eiFXdshqHrFTqNu0VDrW1IzXAWwBf5V19Co6dnhMYe0x4vB+GXCbnF7kApb1cDaLIysHVvDehiMiHenNL236LI
X-Gm-Message-State: AOJu0Yy/f110IIGW1rxR/5GHPj543ncIybiNjMoYuM/6p23mFFq17WtE
	xmLHAIxMltOuckr9zEbeh3J+OJ7x0lr4ue7o6mrvmN8iQ4d0VunlLQC6BV/j8IxXF8I+zAH2BDx
	k52HqsAyBL08Muh5CwhiPbO3Y2P0MH+REz30f
X-Google-Smtp-Source: AGHT+IFFyLIP3mR1zj4IaklXwtmu1mxobLIzc/R6TIuT+vDflQw1wN326QIep6Kb8BVCU6ATRG+ZawrfQqCuQdO0Aqc=
X-Received: by 2002:adf:fe52:0:b0:343:8236:3c2c with SMTP id
 m18-20020adffe52000000b0034382363c2cmr483190wrs.69.1712079532870; Tue, 02 Apr
 2024 10:38:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240320005024.3216282-1-seanjc@google.com> <4d04b010-98f3-4eae-b320-a7dd6104b0bf@redhat.com>
In-Reply-To: <4d04b010-98f3-4eae-b320-a7dd6104b0bf@redhat.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 2 Apr 2024 10:38:24 -0700
Message-ID: <CALzav=eLH+V_5Y6ZWsRkmnbEb6fxPa55B7xyWxP3o6qsrs_nHA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: Rework marking folios dirty/accessed
To: David Hildenbrand <david@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Stevens <stevensd@chromium.org>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 20, 2024 at 5:56=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 20.03.24 01:50, Sean Christopherson wrote:
> > Rework KVM to mark folios dirty when creating shadow/secondary PTEs (SP=
TEs),
> > i.e. when creating mappings for KVM guests, instead of when zapping or
> > modifying SPTEs, e.g. when dropping mappings.
> >
> > The motivation is twofold:
> >
> >    1. Marking folios dirty and accessed when zapping can be extremely
> >       expensive and wasteful, e.g. if KVM shattered a 1GiB hugepage int=
o
> >       512*512 4KiB SPTEs for dirty logging, then KVM marks the huge fol=
io
> >       dirty and accessed for all 512*512 SPTEs.
> >
> >    2. x86 diverges from literally every other architecture, which updat=
es
> >       folios when mappings are created.  AFAIK, x86 is unique in that i=
t's
> >       the only KVM arch that prefetches PTEs, so it's not quite an appl=
es-
> >       to-apples comparison, but I don't see any reason for the dirty lo=
gic
> >       in particular to be different.
> >
>
> Already sorry for the lengthy reply.
>
>
> On "ordinary" process page tables on x86, it behaves as follows:
>
> 1) A page might be mapped writable but the PTE might not be dirty. Once
>     written to, HW will set the PTE dirty bit.
>
> 2) A page might be mapped but the PTE might not be young. Once accessed,
>     HW will set the PTE young bit.
>
> 3) When zapping a page (zap_present_folio_ptes), we transfer the dirty
>     PTE bit to the folio (folio_mark_dirty()), and the young PTE bit to
>     the folio (folio_mark_accessed()). The latter is done conditionally
>     only (vma_has_recency()).
>
> BUT, when zapping an anon folio, we don't do that, because there zapping
> implies "gone for good" and not "content must go to a file".
>
> 4) When temporarily unmapping a folio for migration/swapout, we
>     primarily only move the dirty PTE bit to the folio.
>
>
> GUP is different, because the PTEs might change after we pinned the page
> and wrote to it. We don't modify the PTEs and expect the GUP user to do
> the right thing (set dirty/accessed). For example,
> unpin_user_pages_dirty_lock() would mark the page dirty when unpinning,
> where the PTE might long be gone.
>
> So GUP does not really behave like HW access.
>
>
> Secondary page tables are different to ordinary GUP, and KVM ends up
> using GUP to some degree to simulate HW access; regarding NUMA-hinting,
> KVM already revealed to be very different to all other GUP users. [1]
>
> And I recall that at some point I raised that we might want to have a
> dedicate interface for these "mmu-notifier" based page table
> synchonization mechanism.
>
> But KVM ends up setting folio dirty/access flags itself, like other GUP
> users. I do wonder if secondary page tables should be messing with folio
> flags *at all*, and if there would be ways to to it differently using PTE=
s.
>
> We make sure to synchronize the secondary page tables to the process
> page tables using MMU notifiers: when we write-protect/unmap a PTE, we
> write-protect/unmap the SPTE. Yet, we handle accessed/dirty completely
> different.

Accessed bits have the test/clear young MMU-notifiers. But I agree
there aren't any notifiers for dirty tracking.

Are there any cases where the primary MMU transfers the PTE dirty bit
to the folio _other_ than zapping (which already has an MMU-notifier
to KVM). If not then there might not be any reason to add a new
notifier. Instead the contract should just be that secondary MMUs must
also transfer their dirty bits to folios in sync (or before) the
primary MMU zaps its PTE.

>
>
> I once had the following idea, but I am not sure about all implications,
> just wanted to raise it because it matches the topic here:
>
> Secondary page tables kind-of behave like "HW" access. If there is a
> write access, we would expect the original PTE to become dirty, not the
> mapped folio.

Propagating SPTE dirty bits to folios indirectly via the primary MMU
PTEs won't work for guest_memfd where there is no primary MMU PTE. In
order to avoid having two different ways to propagate SPTE dirty bits,
KVM should probably be responsible for updating the folio directly.

