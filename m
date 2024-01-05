Return-Path: <kvm+bounces-5700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E1CB824CA4
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 02:48:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 624FF2866E1
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 01:48:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 089E21FC4;
	Fri,  5 Jan 2024 01:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fwIgTIfo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD471FAD
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 01:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-555f95cc2e4so1363225a12.3
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 17:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704419284; x=1705024084; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lpGhd5xP2GOFQkyXd8DRiEp0/yoaDhLygKIg+CA9JJ8=;
        b=fwIgTIfo+vNb1m46wu72M9BPMQB8fs9dQB1qSmP3G9mF904ogTMHLYNS5oSg+fGssH
         MDdBigd/brEy3RwSkhWmFSKUHixmhJL8TOaEiu2wQKNUDTpZBqtYl5ccQ33fSXYFEkml
         p4i8dGTdL/ow6GofUAziPMiwxm1om0NMPa9aj9S+3J1Hshr+DswUg2cy2n8u3F932SZz
         UXCJ95xGHgNwsol+ebWLrheYoKCa9BRLqFm85G/fbd3MIfPKBekMIVpknF0ohjgvWtFk
         tbN1n3NhyKSE8QWOpIImMWPhcKFQg2GB1fYFTJ5ZzL3LfGvKPNQ7Uwm7/lRwPk3tnWXI
         UHYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704419284; x=1705024084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lpGhd5xP2GOFQkyXd8DRiEp0/yoaDhLygKIg+CA9JJ8=;
        b=bOtmlZjWM6PyWTS6YlL+6KsBeiNAFR1ao7HLAFLAwNAdpRjoup+AmE4w41eec2qGQg
         6xqhBC0QHUS35YkKo0bSbDGjOj5a/4rmvkYZ+fdNrnSEEgrGWw7MNdpxGoMUR26dq1QD
         QX7E7NJBLGnXWX1ZSkAjQKAA1XxF8bqpen7uPjc312CCilTQJujqD4PlyGWFjSreWt+E
         ovYRMeHntYBdZFFlmg58tx8F995v6wpaSYRGz93lYiwk7Z7n7ZfVSDnQ3o+AANW6a6UC
         PogGxPWVVSuJyhWQYN//CmCGxNM2zXz2F1Mj2zkMCKlAtK4+KpyUj4a7JEDISAa+k0d5
         +SVw==
X-Gm-Message-State: AOJu0YzdJZanADONd3tVd8wqkWpD2LU8dM00z8iQCjaBvnaWBnsCGhIi
	Dn9L/x//0aGSztPJ2m4iHxnk4jzpELN4+rkLNIQ=
X-Google-Smtp-Source: AGHT+IHO+jlFZC49au0wxufSxJTmoDEZTLiybwuL2sKnI67w9rr67BauGwzCbJawMXOhql2QSlqfLetCX1YnF46mge8=
X-Received: by 2002:a50:c092:0:b0:557:1e56:c2cb with SMTP id
 k18-20020a50c092000000b005571e56c2cbmr196552edf.69.1704419283601; Thu, 04 Jan
 2024 17:48:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240103123959.46994-1-liangchen.linux@gmail.com>
 <ZZV8gz7wSCZCX0GZ@google.com> <CAKhg4tJA2TQ_1Zwv2N-PD7dsv_b5OW3Y5uRpnrR2ZOy-63Dsng@mail.gmail.com>
 <CALzav=fKKvKzm6fYUyP4=_uPcFeA3wqBZqGonkz6Rd1+6yuVaw@mail.gmail.com>
In-Reply-To: <CALzav=fKKvKzm6fYUyP4=_uPcFeA3wqBZqGonkz6Rd1+6yuVaw@mail.gmail.com>
From: Liang Chen <liangchen.linux@gmail.com>
Date: Fri, 5 Jan 2024 09:47:51 +0800
Message-ID: <CAKhg4tKDvw9XaG5pDSUKRxSBKWFKAjFndsomdCusd3Z6phcHhw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: count number of zapped pages for tdp_mmu
To: David Matlack <dmatlack@google.com>
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 5, 2024 at 2:29=E2=80=AFAM David Matlack <dmatlack@google.com> =
wrote:
>
> On Wed, Jan 3, 2024 at 8:14=E2=80=AFPM Liang Chen <liangchen.linux@gmail.=
com> wrote:
> >
> > On Wed, Jan 3, 2024 at 11:25=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > +David
> > >
> > > On Wed, Jan 03, 2024, Liang Chen wrote:
> > > > Count the number of zapped pages of tdp_mmu for vm stat.
> > >
> > > Why?  I don't necessarily disagree with the change, but it's also not=
 obvious
> > > that this information is all that useful for the TDP MMU, e.g. the pf=
_fixed/taken
> > > stats largely capture the same information.
> > >
> >
> > We are attempting to make zapping specific to a particular memory
> > slot, something like below.
> >
> > void kvm_tdp_zap_pages_in_memslot(struct kvm *kvm, struct kvm_memory_sl=
ot *slot)
> > {
> >         struct kvm_mmu_page *root;
> >         bool shared =3D false;
> >         struct tdp_iter iter;
> >
> >         gfn_t end =3D slot->base_gfn + slot->npages;
> >         gfn_t start =3D slot->base_gfn;
> >
> >         write_lock(&kvm->mmu_lock);
> >         rcu_read_lock();
> >
> >         for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
> >
> >                 for_each_tdp_pte_min_level(iter, root,
> > root->role.level, start, end) {
> >                         if (tdp_mmu_iter_cond_resched(kvm, &iter, false=
, false))
> >                                 continue;
> >
> >                         if (!is_shadow_present_pte(iter.old_spte))
> >                                 continue;
> >
> >                         tdp_mmu_set_spte(kvm, &iter, 0);
> >                 }
> >         }
> >
> >         kvm_flush_remote_tlbs(kvm);
> >
> >         rcu_read_unlock();
> >         write_unlock(&kvm->mmu_lock);
> > }
> >
> > I noticed that it was previously done to the legacy MMU, but
> > encountered some subtle issues with VFIO. I'm not sure if the issue is
> > still there with TDP_MMU. So we are trying to do more tests and
> > analyses before submitting a patch. This provides me a convenient way
> > to observe the number of pages being zapped.
>
> Note you could also use the existing tracepoint to observe the number
> of pages being zapped in a given test run. e.g.
>
>   perf stat -e kvmmmu:kvm_mmu_prepare_zap_page -- <cmd>

Sure. Thank you!

