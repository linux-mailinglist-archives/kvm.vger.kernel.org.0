Return-Path: <kvm+bounces-35882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5590A15982
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 23:21:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB1BD7A1B9A
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 22:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821031DC9B8;
	Fri, 17 Jan 2025 22:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mnl2knhy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0412619CC34
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 22:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737152458; cv=none; b=htkOkBnAXFxQTNoqCvM6oT/qbv/wrihDVxsC5GopbiXoM/kVTCWRtPjmEVpUW1iodbZmJdVfPSzwdmVvrPVqh3q/dvH2Zfqs48hgjz39zAtRa0NitYcBsWbmMnghDLTOuz6xWcuJBLRKnMIiEjUVKNOdg6xGY2n/Hwudh1iv288=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737152458; c=relaxed/simple;
	bh=iKi4CzP3sZAgYx6CYnYED3xGsSAXY4nIYA7oeulCLS0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M/V0Ql1majPEB+y6eMcBrDeGPzm++vjnzHDeFcHO54oRbejd6NbfP9i/tKld05Peea2MU901BihsBrAoPzoDFkInN+lU/RsM9SN4Xg2G8t0E3zN2M6pGGhW6U4v4W9UVfFS0ZPjYKF/PHmskA+TveEGnt4nODCK+RxrD5xBhiXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mnl2knhy; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-518957b0533so680164e0c.1
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 14:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737152456; x=1737757256; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fq24TRyxQJQtSNKNYGhv6ia30kgYKqW6TYXg34I25Is=;
        b=mnl2knhywisLyAUgT7Um54kFRuugw+3A7c7Pf+rhyvr8cBeWrDrGyq3olXkl8cLHF7
         ZKWik9bKG8lhXyHxC2D/7ap5/iQOFbZT74faiGB0CBVhXZEt8jIir3LA7IS4wcu18fxW
         FYIVE7PHiTE0mOIN5KmUvnh9DcwJCpX6HDjwwHKfX9DUcAsIDWvbvdGKMb/Zr2uveoan
         lzHkRTYuO/pbwEnF8/wiv6yHa0dfLHQgpiUDdmp7idwjPmwQ11OjtlajCUhajMT1FyZU
         950OjRsunDX9w4gJpp0gfG7v6cvBuNbEWB/bzuwIQ5F2aUE0hs0JKSXqMSBS+ITOz15z
         HcCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737152456; x=1737757256;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fq24TRyxQJQtSNKNYGhv6ia30kgYKqW6TYXg34I25Is=;
        b=IAfP8ftav/1p+fgEICeTnu2G5XTZKE8/57u5kJwPm41jO9XTW01PgV0aMhM1y7GGaU
         V4t16VNZJBp212RV/zO8IcEPHjD/FJqwdLgJfO3p5/748Ifk1mjb5GohezbJwP25oUNE
         Iv+drMgnlhY+t5p1sWPehuatt75dL3Q+GwdMk6e+tQG0ixqXzlQJqNaWG5jyzQ/G8H+8
         muMB4ta28wWB2znkIIAuA8jUC/xkdWt6lT1imohN68cNoCYMsHTwQcBf88jjbFf0cEx9
         itptBo0gjx3ZruxMevXMiqqrK/VbkpE09Tp+GQsHU8M0nr0xTJf0f0yCB+OP7axHaIP8
         U9fg==
X-Forwarded-Encrypted: i=1; AJvYcCVCbnHgfF05seJDUL32d21VIzGPiVKzlyr44Ei8zT0q+CDLnmjr7I5TFsNVjeGm9Yv3FpI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRRMyLoC8dDEIh1jcDzeGVhsTMvdhxkr5e+0Ihr6UVKdxzsA2Q
	mmvfDnx8WchQGSyCzYR7ktxki2TEaIZAtDn8eezwOnchXH/WBk3iyayj90u7luJzfVRc+JgprGR
	8sd3nu4bVUbt8611PNlst/jyFZfhSfhIDgQ2r
X-Gm-Gg: ASbGncvk4fyzZisf5N6EZy0TzhI/+LgHyxUL6PNmgusK4CXn3eMhVoKXDV6fw/Z2Pfe
	QB+wur42oIgj6Wi8TyQCov6f770I77qp1Efww+2qORxf8PVHg+kSVcVaogKoxluW3qzZUe5Y=
X-Google-Smtp-Source: AGHT+IFNQG09mWWy/BGQOv+fIE4GvHXkDmdbh2aEYcKBR++gAlyUA+EIThH21LlucaP05eWouHXTHrb/BSNCgzOGLFo=
X-Received: by 2002:a05:6122:2501:b0:515:daa7:ed07 with SMTP id
 71dfb90a1353d-51d4c6586f4mr3729090e0c.0.1737152455575; Fri, 17 Jan 2025
 14:20:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109225533.1841097-1-kevinloughlin@google.com>
 <20250109225533.1841097-3-kevinloughlin@google.com> <szkkdk35keb6ibdy2d2p2q6qiykeo2aoj2iqpzx3h6k2wzs2ob@iuidkwpeoxua>
 <CAGdbjm+i52GNLRXVduzqe2h-bmNeJ_ES97p7LhJPJw+8FMuc-A@mail.gmail.com>
 <brebuxyjirsfc257fpq4qxlowveolrabzetg2i3cj3ee6yzci3@j7zlc676gf7n> <Z4aNCa3N3yPZBM2e@google.com>
In-Reply-To: <Z4aNCa3N3yPZBM2e@google.com>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Fri, 17 Jan 2025 14:20:44 -0800
X-Gm-Features: AbW1kvYpw4Fq0Tbs1LzBDOepVRY6qEgh4zjR_u1r6GxtPtyC3V50Z_rXnbZoznE
Message-ID: <CAGdbjmKB9=pwv0jc3xa8sY+Toc4q=_U=DWKm7+vP3-CsCvbQ3A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
To: Sean Christopherson <seanjc@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	pbonzini@redhat.com, kai.huang@intel.com, ubizjak@gmail.com, 
	dave.jiang@intel.com, jgross@suse.com, kvm@vger.kernel.org, 
	thomas.lendacky@amd.com, pgonda@google.com, sidtelang@google.com, 
	mizhang@google.com, rientjes@google.com, szy0127@sjtu.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2025 at 8:13=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Jan 14, 2025, Kirill A. Shutemov wrote:
> > On Mon, Jan 13, 2025 at 10:47:57AM -0800, Kevin Loughlin wrote:
> > > On Fri, Jan 10, 2025 at 12:23=E2=80=AFAM Kirill A. Shutemov
> > > <kirill.shutemov@linux.intel.com> wrote:
> > > >
> > > > On Thu, Jan 09, 2025 at 10:55:33PM +0000, Kevin Loughlin wrote:
> > > > > @@ -710,6 +711,14 @@ static void sev_clflush_pages(struct page *p=
ages[], unsigned long npages)
> > > > >       }
> > > > >  }
> > > > >
> > > > > +static void sev_wb_on_all_cpus(void)
>
> In anticipation of landing the targeted flushing optimizations[*] in the =
near-ish
> future, I would prefer to avoid the "on_all_cpus" aspect of the name.
>
> Maybe sev_writeback_caches(), to kinda sorta pair with sev_clflush_pages(=
)?
> Definitely open to other names.
>
> [*] https://lore.kernel.org/all/20240411140445.1038319-1-szy0127@sjtu.edu=
.cn

Ack, will do.

> > > > > +{
> > > > > +     if (boot_cpu_has(X86_FEATURE_WBNOINVD))
> > > > > +             wbnoinvd_on_all_cpus();
> > > > > +     else
> > > > > +             wbinvd_on_all_cpus();
> > > >
> > > > I think the X86_FEATURE_WBNOINVD check should be inside wbnoinvd().
> > > > wbnoinvd() should fallback to WBINVD if the instruction is not supp=
orted
> > > > rather than trigger #UD.
> > >
> > > I debated this as well and am open to doing it that way. One argument
> > > against silently falling back to WBINVD within wbnoinvd() (in general=
,
> > > not referring to this specific case) is that frequent WBINVD can caus=
e
> > > soft lockups, whereas WBNOINVD is much less likely to do so. As such,
> > > there are potentially use cases where falling back to WBINVD would be
> > > undesirable (and would potentially be non-obvious behavior to the
> > > programmer calling wbnoinvd()), hence why I left the decision outside
> > > wbnoinvd().
>
> Practically speaking, I highly doubt there will ever be a scenario where =
not
> falling back to WBINVD is a viable option.  The alternatives I see are:
>
>   1. Crash
>   2. Data Corruption
>   3. CLFLUSH{OPT}
>
> (1) and (2) are laughably bad, and (3) would add significant complexity i=
n most
> situations (to enumerate all addresses), and would be outright impossible=
 in some.
>
> And if someone opts for WBNOINVD, they darn well better have done their h=
omework,
> because there should be precious few reasons to need to flush all caches,=
 and as
> evidenced by lack of usage in the kernel, even fewer reasons to write bac=
k dirty
> data while preserving entries.  I don't think it's at all unreasonable to=
 put the
> onus on future developers to look at the implementation of wbnoinvd() and
> understand the implications.

Yeah, you and Kirill have convinced me that falling back to WBINVD is
the way to go. I'll do that in v3 shortly here; thanks!

