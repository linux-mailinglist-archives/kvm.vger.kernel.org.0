Return-Path: <kvm+bounces-25797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F4196AA76
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 23:41:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED29EB25284
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 21:41:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF50F19CC2F;
	Tue,  3 Sep 2024 21:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rOK8OIDy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFBF13DB88
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 21:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725399676; cv=none; b=pzl+ZQ6G/w9tJoLLN0TvLPMAzS/UZHYzNuz1hjv49N65ZN1q1VLvt7eQ+rb7Ynf6X/7wsDccGUWryl5OtjnKeCvIpsiCgJivxCoZ3RPsM9Ks7FaLroFFUBLxibvHlqVwntae4sbtGFC8cr+381d+AEW5/VQkr8Mdn/qFINzeNhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725399676; c=relaxed/simple;
	bh=e1h7zTR9/S25Fd3D7+oznWXEX729eyTG7XRG+ROQ+5Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JRBL4J3huse4J8AgZ3c3R+Vu0fwHtdxEDDChbqFPXUTPBm/Bcf6COa2nCBePi11IdL40UuFO7aKsZUnMqQroYEh5Kfxck/oYaPpKTI/ACD/nfnzK3Hknjw9Q5Z2hfM2RoDt6lQVr/2ehPwAiALJDLvhlIhnHSBTbbxhqsxI+zqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rOK8OIDy; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e1a74ee4c75so4769350276.3
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 14:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725399673; x=1726004473; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KTDnuKwd75FUnpcfChbe8v1J7QDzpMPR82p5HLmU/tQ=;
        b=rOK8OIDy4K9e9pqabDKRE2oB4OasFy7ya6YOYrV3T9T9mQEaMCeBmb+yo92UQfqElS
         gRzdlFIMp+/3FvHJJ3HG8UXWPw9ks3Ap6rah9Wj5iA735CCaTVjbMCN346u9ZroRP9su
         txru6x7bRnL/BaW1EaF6Ohdn7MRu7yCLI0J4P8rG1bdTJI8y1JZv/oxFKMdkMZEysLsm
         2aD+p+FDZhenab5DSN/WIthigK2TlbuyX5MeftffhdhkiBC9+G0+M0aex4AGIpbZKzW0
         6tw2eVG3fzxJJF7CkilDpIjamQd36sxg3MXlMMZHqhBc3jJ0TRzLL+5eUNW0U2sSsvih
         V0Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725399673; x=1726004473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KTDnuKwd75FUnpcfChbe8v1J7QDzpMPR82p5HLmU/tQ=;
        b=iS6cUwSw/SIqgpKfZ+6/OR2F1ZJSVtag55hPD7b00mB1IX5Y1HaN/a2VmpqK/138Xg
         66mN7Dd5YvYn3KZlAzPP+6jVz1ZyvyRUz0USCpjWZKH8QWALPcKx7BsENP7dZ6ztwjrP
         ZQS+f1GxfmzQtrOnscc9IHLCRgSKYd9OfI3P9OBJ3YzlgwChNzZMT2pQX/K6KySAzK1H
         vGUIq08my7zwhkjbzkPaPHf2FyT62J/rkV/q6yhz51JY7dyyVeEE4W1okxBnyNx7J+8Y
         vxqRWk0+G8eCvscr6slSZZ1Qz+1n0Z8RdGEsMgQIlP+zgmstYnlJbRRDR6y4CjnbnzU0
         DFqw==
X-Forwarded-Encrypted: i=1; AJvYcCWgomwPF3yGUWAMuWQ/cM2oEJrdzcMqCHeCVGMLS0Db7xmEyGWdwIuuNDdjyXaeACr9CgI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzttPLscQK+l23ORgyPOZuwcS7rak6qX0O4+5CKpChd4MMlhQAF
	dUqTZj7mm0jOLhACziuOP2GAPsQIDG3LdGE6i/6b6ZwdLQW08hv3T5rQBCzgFujWqn72RsILz4N
	Np7wJpbIA0X+UaSjb8LLvEstwWEXx3BaknzVN
X-Google-Smtp-Source: AGHT+IEq+la7fPI+jIUHIuVIxCQYY3gRR0EF+qaAb/jS0UgdTzRMeA/McH6lpLLI1QRVjuVO9S5Kgb3LHQb8oJYs9N4=
X-Received: by 2002:a05:6902:2406:b0:e1a:b361:4d9b with SMTP id
 3f1490d57ef6-e1ab36153f7mr8782208276.24.1725399673389; Tue, 03 Sep 2024
 14:41:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-20-seanjc@google.com>
 <CADrL8HUvmbtmfcLzqLOVhj-v7=0oEA+0DPrGnngtWoA50=eDPg@mail.gmail.com> <Ztd_N7KfcRBs94YM@google.com>
In-Reply-To: <Ztd_N7KfcRBs94YM@google.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 3 Sep 2024 14:40:36 -0700
Message-ID: <CADrL8HVpPOBkM4tD0xBpxWzYMiAoE5Gcg8Cg0=Xi5mvgeqR0gA@mail.gmail.com>
Subject: Re: [PATCH 19/22] KVM: x86/mmu: Add infrastructure to allow walking
 rmaps outside of mmu_lock
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 3, 2024 at 2:27=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Tue, Sep 03, 2024, James Houghton wrote:
> > On Fri, Aug 9, 2024 at 12:44=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > +/*
> > > + * rmaps and PTE lists are mostly protected by mmu_lock (the shadow =
MMU always
> > > + * operates with mmu_lock held for write), but rmaps can be walked w=
ithout
> > > + * holding mmu_lock so long as the caller can tolerate SPTEs in the =
rmap chain
> > > + * being zapped/dropped _while the rmap is locked_.
> > > + *
> > > + * Other than the KVM_RMAP_LOCKED flag, modifications to rmap entrie=
s must be
> > > + * done while holding mmu_lock for write.  This allows a task walkin=
g rmaps
> > > + * without holding mmu_lock to concurrently walk the same entries as=
 a task
> > > + * that is holding mmu_lock but _not_ the rmap lock.  Neither task w=
ill modify
> > > + * the rmaps, thus the walks are stable.
> > > + *
> > > + * As alluded to above, SPTEs in rmaps are _not_ protected by KVM_RM=
AP_LOCKED,
> > > + * only the rmap chains themselves are protected.  E.g. holding an r=
map's lock
> > > + * ensures all "struct pte_list_desc" fields are stable.
> > > + */
> > > +#define KVM_RMAP_LOCKED        BIT(1)
> > > +
> > > +static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
> > > +{
> > > +       unsigned long old_val, new_val;
> > > +
> > > +       old_val =3D READ_ONCE(rmap_head->val);
> > > +       if (!old_val)
> > > +               return 0;
> >
> > I'm having trouble understanding how this bit works. What exactly is
> > stopping the rmap from being populated while we have it "locked"?
>
> Nothing prevents the 0=3D>1 transition, but that's a-ok because walking r=
maps for
> aging only cares about existing mappings.  The key to correctness is that=
 this
> helper returns '0' when there are no rmaps, i.e. the caller is guaranteed=
 to do
> nothing and thus will never see any rmaps that come along in the future.
>
> > aren't holding the MMU lock at all in the lockless case, and given
> > this bit, it is impossible (I think?) for the MMU-write-lock-holding,
> > rmap-modifying side to tell that this rmap is locked.
> >
> > Concretely, my immediate concern is that we will still unconditionally
> > write 0 back at unlock time even if the value has changed.
>
> The "readonly" unlocker (not added in this patch) is a nop if the rmap wa=
s empty,
> i.e. wasn't actually locked.

Ah, that's what I was missing. Thanks! This all makes sense now.

>
> +static void kvm_rmap_unlock_readonly(struct kvm_rmap_head *rmap_head,
> +                                    unsigned long old_val)
> +{
> +       if (!old_val)
> +               return;
> +
> +       KVM_MMU_WARN_ON(old_val !=3D (rmap_head->val & ~KVM_RMAP_LOCKED))=
;
> +       WRITE_ONCE(rmap_head->val, old_val);
> +}
>
> The TODO in kvm_rmap_lock() pretty much sums things up: it's safe to call=
 the
> "normal", non-readonly versions if and only if mmu_lock is held for write=
.
>
> +static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
> +{
> +       /*
> +        * TODO: Plumb in @kvm and add a lockdep assertion that mmu_lock =
is
> +        *       held for write.
> +        */
> +       return __kvm_rmap_lock(rmap_head);
> +}

