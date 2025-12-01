Return-Path: <kvm+bounces-65031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E099C98DC5
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 20:33:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4793F3A1B74
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 19:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8039223C519;
	Mon,  1 Dec 2025 19:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pmqes4ty"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045DD21ABBB
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 19:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764617613; cv=none; b=MjzQWSmD3nsQ6IZtrO0BA2u+iaqOUCJoor9L8LFqcwJo1mPsBd/J9a2sZnfTacvdpxege98JzU4WWSgQqBnzA1bY7h/+KKnr/nkmgB8F4Vlr2j9wKCMjULoRMR2Br7VH+NOW06QXIlDyr4gyPHy0ASyOYepoqMLjqSWXeARGa3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764617613; c=relaxed/simple;
	bh=bBclXWBTEbUxD+U/Fbj1zSTWpgB2yfzFcZ8O+PL09sc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rl40pPmh7MikV7Fe+aPH+Sy/FXuQ04yW2UwtMrfH53FqctUACm5ZftSp0zr9cWF+l2M2YabJShm/WpvHH18F8hayUulbk9/E7aiwyVQ88+UbchSsjvHt1dVmceLBcV9alNpRnOcoe2ND68hUpnD90JVDKZhjgd7PkPsMiQQW0XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pmqes4ty; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-29852dafa7dso815535ad.1
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 11:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764617611; x=1765222411; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aF10akh46ESQJ+c7BaT1JvkVAunKKRxi6jS26KvxL2o=;
        b=Pmqes4tyDUqqDv9jpqhQN3IyrzSUNfmXbXnNkqnM/zwcXHLFbjC5o8LQmJSjTPVvbH
         yVWuPL3lOYGPLAMEZisv7Ulr+J+yYkiIPTOuHEJtlABDFsmVhGpi6W01mYnkEaJFw6FT
         Eo+qGfu/XXE8UwJMHOes3cN1PAg4ZawQXAuKTRXNW+iHU7wc2vgJMSpBQWRHfXAQxE4D
         /0S3sXDnz9n51jkxuYfKxJVyT7qvSh5d9qgmRAUWDO34HQCLAnJg/9WPVx7yo/JKD1vn
         eu33Z7Em3rZ+N2zIREbwAmED3nSkEQSxsFnXHj5aROysLcM+eazhg0Z9ozNVw6DXtwa3
         uz0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764617611; x=1765222411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aF10akh46ESQJ+c7BaT1JvkVAunKKRxi6jS26KvxL2o=;
        b=SV2BhtfjIQJn23sxXtuyImNsZx5jTftn/0V7K/b1vAuEXGPRA8E6OpdwXngyjbp360
         cHAYYNfo2yYaw2X8G4h4mdxS/lo8l5QXEhgtqQonNa1/Obi9bZQIIgamY7eiVeKtGV8R
         WopGckHx3WlEPlBTUNuJFswoRDZIxJud+chY6tdwWTu5RZkLtP/GBEtg0xw9vJHBFm5V
         zdpK6Zz5zI8zYJs01ZtP3PB9P2GpoFgGLRsluf/FAdwVtjshsB4haB02rY8UXXFB0XKJ
         ZN+gpSlOJ1DRUJB7K3845KUiI/Rdm6+fEtiWDuM7ewPlss1ikdl5yo9K/CXXZoXTIDQw
         wcYA==
X-Forwarded-Encrypted: i=1; AJvYcCWb295aZasAA4KMmdJLAOwoM6483ImWStEHww/DtyIboh6LvPoPTQXO3p3600wdyjI2iIQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzo0GxNpypb75rugQ/30LcKHy9xVorO4xXqaJI4cVzKiVcp5EjU
	IofzBCrYLbKY1f6vY2RFkR0GGRdpHzHjQd6skNjikbm/r8YNellsZvNxTnbPQnhcmnfIv1Xj2ov
	ivDkQsVfcDtBGWA4bK91ANdXzs37u6tPEudzQbvtu
X-Gm-Gg: ASbGnctJOd4Gz28LWwbbHvGk6rN8gw0KuJmiv8tKnUkCSvnjrAQLsL8gni92kcFN3Qk
	vgx7+kPiEolER0b2mdBDuH4nbMlSZRv8PJ8H8nNE8djIKEDHK4ngZzRiQVtyIDpBqArOJiCDORJ
	NIM9R3yQd0wDD+8OAxcTxr3BgF1eJKqhp6GOyKUT7bdGf7lX+gM4hl9wGOenU+jT0+3dMoKFws9
	JWVm1ymzUmSg2wQhnbLmHWGG3h0pNVZsWLEZDUzCZwN46OVXRNeKiGnc+LUOk6bdVDw8gYjDl7T
	mb8ydVX6gpx9JnBdCzIfVpvmpw==
X-Google-Smtp-Source: AGHT+IFP/zhwci3vTqB9EDyMd0PIB3pGB3CtyKHh0svTCtOgB/uKqoCrsL9Qur1sceYt3JqL6MrYHvIDY5EEWYqMNpM=
X-Received: by 2002:a05:7022:f902:10b0:119:e55a:808c with SMTP id
 a92af1059eb24-11dc9c5d1f3mr327753c88.9.1764617610739; Mon, 01 Dec 2025
 11:33:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-2-michael.roth@amd.com> <aR7blxIx6tKD2xiQ@yzhao56-desk.sh.intel.com>
 <20251121124314.36zlpzhwm5zglih2@amd.com> <aSUe1UfD3hXg2iMZ@yzhao56-desk.sh.intel.com>
 <CAGtprH-ZhHO4C5gTqWgMNpf5MKvL0yz6QG2h01sz=0o=ZwOF0g@mail.gmail.com> <aS0ClozgeICZN/XX@yzhao56-desk.sh.intel.com>
In-Reply-To: <aS0ClozgeICZN/XX@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 1 Dec 2025 11:33:18 -0800
X-Gm-Features: AWmQ_bmRwRx__VVgKyn6dcD5fugj47Z9H8pbE9hwrVIaEriDYO1NkTox6hQ0kSQ
Message-ID: <CAGtprH8kVtyMiZeF+40hSpkY=O_HD0K+1Gy10rPdi8-mNLr8Yg@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, ackerleytng@google.com, 
	aik@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 30, 2025 at 6:53=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> On Sun, Nov 30, 2025 at 05:35:41PM -0800, Vishal Annapurve wrote:
> > On Mon, Nov 24, 2025 at 7:15=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com>=
 wrote:
> > > > > > @@ -889,7 +872,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn=
_t start_gfn, void __user *src, long
> > > > > >           p =3D src ? src + i * PAGE_SIZE : NULL;
> > > > > >           ret =3D post_populate(kvm, gfn, pfn, p, max_order, op=
aque);
> > > > > >           if (!ret)
> > > > > > -                 kvm_gmem_mark_prepared(folio);
> > > > > > +                 folio_mark_uptodate(folio);
> > > > > As also asked in [1], why is the entire folio marked as uptodate =
here? Why does
> > > > > kvm_gmem_get_pfn() clear all pages of a huge folio when the folio=
 isn't marked
> > > > > uptodate?
> > > >
> > > > Quoting your example from[1] for more context:
> > > >
> > > > > I also have a question about this patch:
> > > > >
> > > > > Suppose there's a 2MB huge folio A, where
> > > > > A1 and A2 are 4KB pages belonging to folio A.
> > > > >
> > > > > (1) kvm_gmem_populate() invokes __kvm_gmem_get_pfn() and gets fol=
io A.
> > > > >     It adds page A1 and invokes folio_mark_uptodate() on folio A.
> > > >
> > > > In SNP hugepage patchset you responded to, it would only mark A1 as
> > > You mean code in
> > > https://github.com/amdese/linux/commits/snp-inplace-conversion-rfc1 ?
> > >
> > > > prepared/cleared. There was 4K-granularity tracking added to handle=
 this.
> > > I don't find the code that marks only A1 as "prepared/cleared".
> > > Instead, I just found folio_mark_uptodate() is invoked by kvm_gmem_po=
pulate()
> > > to mark the entire folio A as uptodate.
> > >
> > > However, according to your statement below that "uptodate flag only t=
racks
> > > whether a folio has been cleared", I don't follow why and where the e=
ntire folio
> > > A would be cleared if kvm_gmem_populate() only adds page A1.
> >
> > I think kvm_gmem_populate() is currently only used by SNP and TDX
> > logic, I don't see an issue with marking the complete folio as
> > uptodate even if its partially updated by kvm_gmem_populate() paths as
> > the private memory will eventually get initialized anyways.
> Still using the above example,
> If only page A1 is passed to sev_gmem_post_populate(), will SNP initializ=
e the
> entire folio A?
> - if yes, could you kindly point me to the code that does this? .
> - if sev_gmem_post_populate() only initializes page A1, after marking the
>   complete folio A as uptodate in kvm_gmem_populate(), later faulting in =
page A2
>   in kvm_gmem_get_pfn() will not clear page A2 by invoking clear_highpage=
(),
>   since the entire folio A is uptodate. I don't understand why this is OK=
.
>   Or what's the purpose of invoking clear_highpage() on other folios?

I think sev_gmem_post_populate() only initializes the ranges marked
for snp_launch_update(). Since the current code lacks a hugepage
provider, the kvm_gmem_populate() doesn't need to explicitly clear
anything for 4K backings during kvm_gmem_populate().

I see your point. Once a hugepage provider lands, kvm_gmem_populate()
can first invoke clear_highpage() or an equivalent API on a complete
huge folio before calling the architecture-specific post-populate hook
to keep the implementation consistent.

Subsequently, we need to figure out a way to avoid this clearing for
SNP/TDX/CCA private faults.

>
> Thanks
> Yan

