Return-Path: <kvm+bounces-41975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC9FFA705C2
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 16:58:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2BBE3A791C
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 15:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48E4A253B5C;
	Tue, 25 Mar 2025 15:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cZY657Eg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6D525C6F9
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 15:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742918265; cv=none; b=eYWmC6wPmp67H5G3GGuMtNsw0QyecHEUyndoCWLOPko/BuCjbZ16uvTvG3fNmCCORzF5wRScL3bagwisoF5SVHaPPxK+gJTazAOMLbNSZYAFaoCFDs+yHQ7ARnuN3dx9oHg5sqTowiPry0FaujcNgLjUAIOuTRzyX/+TK5OSCcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742918265; c=relaxed/simple;
	bh=8F1NJ56bxjIwyjTv2treAxz+REJKUAEBG3yf9qS2wGk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kSNli5yW43kxql4tysAay30sDYZCrgxVCLyl63AXGAO3fJkxtBpNxBBLmeZpxl0OOTP9+HBj5GTm80dTfJom+qkEK34t4FvByERgbsLiiX9qAPS3Q8zLHZwHMv0QMPdYbGiiGwRX8taqxTPuYZQLjLXgnAUq6rnJGr8ccUwA/Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cZY657Eg; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4769e30af66so448421cf.1
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 08:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742918262; x=1743523062; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=74Qwj89IF8GjpANpjZfZDaQ2z8tGZK11oNXVHKtMIeA=;
        b=cZY657Egqdo7/xDKMufB7SwTnQ41eUAqYeA9ZJISHU1Mry+vJ/xK/0OIG8PpI3R68J
         fK7B1Y5BkXSGJcRdmXf2H7V97xdkwaejAE0VPms3SwQt8ZKFBxGzvz7YiEzN7chc6FMU
         3gM81pYUkHK+16tiGuKlH7evYR0YNCCACenftJZ50+g3qwQGJtTRlxHIQdRjftuDh1uH
         LuhwYMbJgX+wE54bVq+qK0FvoG0iri+9Rr70ej6Bd/ebkiHsZ7sWplR4cnvD0BOLVNTi
         HvHxpmZwCU8AJ2Vv+ANjbpmsuWCwaHH7s6BwJ6wofi/GK6o7N7820yA8dQGVXaiZo/Rk
         MnmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742918262; x=1743523062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=74Qwj89IF8GjpANpjZfZDaQ2z8tGZK11oNXVHKtMIeA=;
        b=FIF+HD/53iBN8NrsScNrH4VXtBG/3L5Y4rqqlOWbXsl+OBEBhp7vIulCmOT0B6MMTv
         0gENeWyhe4nKrdEvYXVjJS9eqmUMQwrcwYvA+QcU86cpuE2s+ODzh4r4brG3Cu9WBNGO
         TwIZq0AC6Gavfa1Tu00+fVAnTu8Hp6/hDkwA1tSlTjmqfapDxjeLDsBrZjpJNZBPBFCD
         Nz44w4QouND1lHDd2pXdH0wX2F8m1WWtfvC1PZvAmgfYmL4zdsTOjJssSEgg1lMtWiJg
         UNyeYY7c405ZUDrBPNUzEtV1ic++8AvZJEXecq6oPesBEicutO2jFaMj1ZF3+MK7L9ml
         DRXQ==
X-Gm-Message-State: AOJu0YzyPG+Qs5hBKaHlm/52WzE5e7kGGJOxYeRc7NzCvHPllJrzf441
	jF9/u7jk1+ID92fxh5Aaaa/VtWPIz6ZaDWWTtuwizPJ3vgUda1x114Tiii/gFBJB/jDl0QQv6jr
	uht/l30zUw8GZOZGiGX3gkYnlDSRXTzM3y4z/
X-Gm-Gg: ASbGncv2lzbGP3kZ0wfAIvoERBjTEpPFc8BpqI1rFbsedxDMoIEzigFFtc1PF7brek1
	FKKjc2ly6lE/HCVDENRxOwwxjH0tQ1sAsTkOnpbNF9WBtSiv+1dQJc1DxB4ltMzkufOD5sL4vjE
	C2Lx2KYhIb+FzRvgaijO/EYtlt6g==
X-Google-Smtp-Source: AGHT+IHeh2gPA4DB1fZIeYy9PDd2izAMrAEkI1SyH2TI74S+jvSN+Ftr3W19JthWsvq2CGGaH+hiMPDVB1rq8Iwc7wM=
X-Received: by 2002:a05:622a:1f8b:b0:476:f1a6:d8e8 with SMTP id
 d75a77b69052e-4772be14c43mr13528291cf.11.1742918257692; Tue, 25 Mar 2025
 08:57:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250318162046.4016367-1-tabba@google.com> <20250318162046.4016367-6-tabba@google.com>
 <CAGtprH-aoUrAPAdTho7yeZL1dqz0yqvr0-v_-U1R9f+dTxOkMA@mail.gmail.com>
In-Reply-To: <CAGtprH-aoUrAPAdTho7yeZL1dqz0yqvr0-v_-U1R9f+dTxOkMA@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 25 Mar 2025 15:57:00 +0000
X-Gm-Features: AQ5f1JrYL6iEPnJvzqrjUrKSPmUCLtNGb2xeLimK0jjw7tytAVKf6Eo11ig_wvI
Message-ID: <CA+EHjTwZaqX9Ab-XhFURn+Kn6OstN3PHNqUi_DxbHrQYBTa2KA@mail.gmail.com>
Subject: Re: [PATCH v6 5/7] KVM: guest_memfd: Restore folio state after final folio_put()
To: Vishal Annapurve <vannapurve@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Vishal,


On Fri, 21 Mar 2025 at 20:09, Vishal Annapurve <vannapurve@google.com> wrot=
e:
>
> On Tue, Mar 18, 2025 at 9:20=E2=80=AFAM Fuad Tabba <tabba@google.com> wro=
te:
> > ...
> > +/*
> > + * Callback function for __folio_put(), i.e., called once all referenc=
es by the
> > + * host to the folio have been dropped. This allows gmem to transition=
 the state
> > + * of the folio to shared with the guest, and allows the hypervisor to=
 continue
> > + * transitioning its state to private, since the host cannot attempt t=
o access
> > + * it anymore.
> > + */
> >  void kvm_gmem_handle_folio_put(struct folio *folio)
> >  {
> > -       WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in pro=
gress.");
> > +       struct address_space *mapping;
> > +       struct xarray *shared_offsets;
> > +       struct inode *inode;
> > +       pgoff_t index;
> > +       void *xval;
> > +
> > +       mapping =3D folio->mapping;
> > +       if (WARN_ON_ONCE(!mapping))
> > +               return;
> > +
> > +       inode =3D mapping->host;
> > +       index =3D folio->index;
> > +       shared_offsets =3D &kvm_gmem_private(inode)->shared_offsets;
> > +       xval =3D xa_mk_value(KVM_GMEM_GUEST_SHARED);
> > +
> > +       filemap_invalidate_lock(inode->i_mapping);
>
> As discussed in the guest_memfd upstream, folio_put can happen from
> atomic context [1], so we need a way to either defer the work outside
> kvm_gmem_handle_folio_put() (which is very likely needed to handle
> hugepages and merge operation) or ensure to execute the logic using
> synchronization primitives that will not sleep.

Thanks for pointing this out. For now, rather than deferring (which
we'll come to when hugepages come into play), I think this would be
possible to resolve by ensuring we have exclusive access* to the folio
instead, and using that to ensure that we can access the
shared_offsets maps.

* By exclusive access I mean either holding the folio lock, or knowing
that no one else has references to the folio (which is the case when
kvm_gmem_handle_folio_put() is called).

I'll try to respin something in time for folks to look at it before
the next sync.

Cheers,
/fuad

> [1] https://elixir.bootlin.com/linux/v6.14-rc6/source/include/linux/mm.h#=
L1483
>
> > +       folio_lock(folio);
> > +       kvm_gmem_restore_pending_folio(folio, inode);
> > +       folio_unlock(folio);
> > +       WARN_ON_ONCE(xa_err(xa_store(shared_offsets, index, xval, GFP_K=
ERNEL)));
> > +       filemap_invalidate_unlock(inode->i_mapping);
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_gmem_handle_folio_put);
> >
> > --
> > 2.49.0.rc1.451.g8f38331e32-goog
> >

