Return-Path: <kvm+bounces-7631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2777A844DCE
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 01:26:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A2EB1C24533
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 00:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A99877FE;
	Thu,  1 Feb 2024 00:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bs2mZMwe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434BE1FDB
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 00:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706747207; cv=none; b=JgQOQ7PRg2IIdTw3isKmA+QoLwQM5KU3ugW3iLHtnDXvbNbi/SLd/whSVk0LPzOTw56+ZIrX+ZYbSS5XNvQWVGnzd9sZ/PnhSlQAoel1g9oDQyRMIRCkFAKuB+GNUTxh0cgvP9cpdNeYtjTdRNd3zx4YJMcBzh1rCr308Jgp7KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706747207; c=relaxed/simple;
	bh=6tJHrUkrQP7NwvtLhO/da5PPrg5uJy9hVBGQTtTpIig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NgWJyOEIOzncTlkE8jY8vs4cZlX9UTWlFSEaybNRZ0G5hh44CvxITfqu20/vYOUoPq55Tw9B+dKcpf+TXymfx6SRm/kVF10Hh8VnuQVk8qLUCsDFQPEszwUpHNFJQQnPOyjCZ8I47dEI4f9Do8gIUjfG0/9hijYs8qGy5XzpXBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bs2mZMwe; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-42a88ad0813so106641cf.0
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 16:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706747205; x=1707352005; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MfVbRf3BHUSn3cK7ZTAjeFEicT/rpADsX5UluXSAJko=;
        b=bs2mZMweE6PBbSexA3DCBTBBrm5dgKLNq6kdXdw5CAIPQZsoLvA+sDpbxzCeiCPKUn
         9ZUasKnXeponk+or0/3tjwbJjFyh/uBxsDeJI585dJjp9tgq6siAOKZ8bogI7Cg2Fs9f
         pHIMQB1kxDvFZs4VilEM+fZiqu3txLbM09HVlVBAyjHnD1LCWOa01vlZuJWvJstypyZ4
         a+jzHrffMsFjXmB3coDInexeokHAK1SYu+UBl9XsJvVAWIHfYJaAVrYiJyaBTLNVIrHS
         v7R7qCfYXd/JMB7CPHEiTRh/TFUlEaBVr9G/IuJ0wq+X3qq3BkeChBoERlYXRGxjcBIH
         IuRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706747205; x=1707352005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MfVbRf3BHUSn3cK7ZTAjeFEicT/rpADsX5UluXSAJko=;
        b=LrQfVWQgr83JkktDsiEcPaRWOQYoLDv3jngtqh8QIoO3CEkDOqAPxZ4XKSs/oI8YTv
         GHB5U9EJd0m1a2EZGOek4SfH1xArHm0XBMZIB/cgWTcioYYfmWc8f6fCAY9f6qceQvBn
         6QMx9YNxocqEbgtsAPDLtkrAZnb8pIi3johmR/fY6/V2WO6Q7bfda6l6atMWBrT/pUb3
         royXJocEv5YEEBDXHmc710ZiiR9sCqps0OYHbcwKY1S1FEf0bUMbMF8B3lZrE6Wt0M34
         c9MV0TyZ+LCIM+4raT0qswkXTHYKrMyR0fMKcW1YRWjGjF4pM6deQd0oBvTc6pvmiLD6
         3xnA==
X-Gm-Message-State: AOJu0YxrKytRiXdJUZGQb/gJKr/QAHqldpmoNrhN6FFnkWC2cYy8aEVE
	r7HBr6nhg6dbXIzTiz0HpCI/jfJWWvMx3vEASpVKtgKPF04UdzuafGP9WtBwzwZ8tLLrPKy4QbZ
	N7eTeUelLmMdtnndvbYXMgI8/m/o+TvWN7p+P
X-Google-Smtp-Source: AGHT+IFkozDy72/y2wNyA2yA/lTNSD0/eZVvz82Xg5xHONs8hs/Df4umXylnquFRHZr6PnmZkZkDhPz2CdJa2WRWaj8=
X-Received: by 2002:a05:622a:3ce:b0:42a:9c21:2655 with SMTP id
 k14-20020a05622a03ce00b0042a9c212655mr86925qtx.13.1706747204771; Wed, 31 Jan
 2024 16:26:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-7-amoorthy@google.com>
 <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com> <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
In-Reply-To: <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 31 Jan 2024 16:26:08 -0800
Message-ID: <CADrL8HXSzm_C9UwUb8-H_c6-TRgpkKLE+qeXfyN-X_rHGj2vuw@mail.gmail.com>
Subject: Re: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
To: Anish Moorthy <amoorthy@google.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2024 at 2:00=E2=80=AFPM Anish Moorthy <amoorthy@google.com>=
 wrote:
>
> On Tue, Jan 30, 2024 at 4:26=E2=80=AFPM James Houghton <jthoughton@google=
.com> wrote:
> > > @@ -3070,6 +3074,15 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kv=
m_memory_slot *slot, gfn_t gfn,
> > >                 writable =3D NULL;
> > >         }
> > >
> > > +       if (!atomic && can_exit_on_missing
> > > +           && kvm_is_slot_exit_on_missing(slot)) {
> > > +               atomic =3D true;
> > > +               if (async) {
> > > +                       *async =3D false;
> > > +                       async =3D NULL;
> > > +               }
> > > +       }
> > > +
> >
> > Perhaps we should have a comment for this? Maybe something like: "If
> > we want to exit-on-missing, we want to bail out if fast GUP fails, and
> > we do not want to go into slow GUP. Setting atomic=3Dtrue does exactly
> > this."
>
> I was going to push back on the use of "we" but I see that it's all
> over kvm_main.c :).
>
> I agree that a comment would be good, but isn't the "fast GUP only iff
> atomic=3Dtrue" statement a tautology? That's an actual question, my
> memory's fuzzy.
>
> What about
>
> > When the slot is exit-on-missing (and when we should respect that)
> > set atomic=3Dtrue to prevent GUP from faulting in the userspace
> > mappings.
>
> instead?

This is much better than what I wrote, thanks! We merely want GUP not
to fault the page in; we don't actually care about fast GUP vs. slow
GUP.

On that note, I think we need to drop the patch that causes
read-faults in RO memslots to go through fast GUP. KVM didn't do that
for a good reason[1].

That would break KVM_EXIT_ON_MISSING for RO memslots, so I think that
the right way to implement KVM_EXIT_ON_MISSING is to have
hva_to_pfn_slow pass FOLL_NOFAULT, at least for the RO memslot case.
We still get the win we're looking for: don't grab the userfaultfd
locks.

[1]: Commit 17839856fd5 ("gup: document and work around "COW can break
either way" issue")

