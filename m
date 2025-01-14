Return-Path: <kvm+bounces-35396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DA17A10BF2
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 17:13:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2990A16330A
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 16:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D28D1C3021;
	Tue, 14 Jan 2025 16:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2dfsSdcb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC831ADC6E
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 16:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736871186; cv=none; b=DU9EgwjGchwmE/zKc8yvBEaKVnV2V5hGIriDmaIiHkzhjUMAsfw45lKu6ezSOsdM6YKEkvLqN0pjzWE8BWyoWxhZ1qm5YgvWCvwNTFO3ChGSOpe7+z2zh5f0KAm7mWRd/5FW+VVKt3Ej49uW+T3ZY6c0k/cf6khsYxORRzhYN6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736871186; c=relaxed/simple;
	bh=XT4t419OMBDfK006Un5uZ77ROcrKXKzvheGm0OL36rc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IJGmmhMAEVb7o9kLWb3X2TfyGskc5KdOOsNt2j/5kl0Z0w+QTN+D/bK0cPFHdn7NlNIij32b0uYdW3rPJ4Ni830xGumL4UVWmyj7CF5FrP/8XlVcJ/4IRPcRFF6jbvm1YGI5WWcNGZqEOdNR8w3HrIViU7Pe1/OTvvqOrKdT31A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2dfsSdcb; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef80d30df1so9951030a91.1
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 08:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736871184; x=1737475984; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IN4BY1vrx5SuH2U8wdanxq79ndn86isZnzQkNUic768=;
        b=2dfsSdcb2wedaOpqC8Mx/XdQ6YA5dFAZ4cvhekB3tsQmbB5aaogPgOUIFZal0r9OZQ
         IaW/ZuGscbKHfkfmZ2Yk5YlgsqghA0KOTCQtPGBR1UfqdU6o9wuXqFShw0yYhc1TyVnD
         ICkk6j/+mLmoLRF/kVxlWfGwYP4Jj/KMgTONHUPetFFzy7QYT3gDngaSXmzeAnmEiMtB
         1HvMMMYiW4npst7d8fl6GymPJrOfuXdvjWseDZpOArBJ0T5Vo4XuT9wwm58U2zdUuqoh
         LKHInBNiGVbBpRqZUeJqkC7bIQ+Qzu65Qd1R48ohsBtjrr8b1wXUGcaq/HOAI42ByQab
         3MBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736871184; x=1737475984;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IN4BY1vrx5SuH2U8wdanxq79ndn86isZnzQkNUic768=;
        b=dgN1BkjEaLCVy73gte/vbbTvheQ1emYeU2Yy+d3EB8DfGGJ2u/TdTtk3tDoasrNVUv
         UgUphD9rW3JFKI7H277uRlQplM/uFOoZtrlmjWRsk0K/4XJBq+8yDFYFdM5AkZTl+N5h
         lXgB7HY9ECqDLAlbXEvQwgvx4kR96T2ujScgvls32GzYKf/Hl7mlSI8Xd3EQahii+xDe
         YsVzhb2OZ4hNk5gJVQVX3Y73rNQdTUKxA10CZWBMWamNIeOXPFfDo3ewzGFRP6Uce73I
         tKGR4xT1UWnPwaDinBbcrG8XH7I6dWK3DkK8GUlMrp7HCAtnUkCYK7iqzEPIiQ4NDX2l
         8Y6g==
X-Forwarded-Encrypted: i=1; AJvYcCUeAvGNXsLv6fSSfYfwjOTJtPz0Rsg6hIJml76c1sIv/vhPkaOFqF0YW+BBokDXDVY3j0s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9py0R100lmcXIj43erKlHjeaQB/HGRUozF8z/zcDX18K+F1kq
	ELsYOjkHpVgo0g3X6SHkbEiQbRvYMJqsrDlxf6I3vPULemSrkD+7RpWdSoIkbstQtBJlNaTEr7x
	4yA==
X-Google-Smtp-Source: AGHT+IGAEkyp2QXBFeT9lZ1xbq10mva6dlyIOf7agiuR/sH5d3IJs8PRMPxifhAIZArJ/WeFmIfc7pJPt4Y=
X-Received: from pjbqi17.prod.google.com ([2002:a17:90b:2751:b0:2ea:5084:5297])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:280e:b0:2ee:b875:6d30
 with SMTP id 98e67ed59e1d1-2f548ebb62cmr38572711a91.9.1736871184506; Tue, 14
 Jan 2025 08:13:04 -0800 (PST)
Date: Tue, 14 Jan 2025 08:12:57 -0800
In-Reply-To: <brebuxyjirsfc257fpq4qxlowveolrabzetg2i3cj3ee6yzci3@j7zlc676gf7n>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109225533.1841097-1-kevinloughlin@google.com>
 <20250109225533.1841097-3-kevinloughlin@google.com> <szkkdk35keb6ibdy2d2p2q6qiykeo2aoj2iqpzx3h6k2wzs2ob@iuidkwpeoxua>
 <CAGdbjm+i52GNLRXVduzqe2h-bmNeJ_ES97p7LhJPJw+8FMuc-A@mail.gmail.com> <brebuxyjirsfc257fpq4qxlowveolrabzetg2i3cj3ee6yzci3@j7zlc676gf7n>
Message-ID: <Z4aNCa3N3yPZBM2e@google.com>
Subject: Re: [PATCH v2 2/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
From: Sean Christopherson <seanjc@google.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Kevin Loughlin <kevinloughlin@google.com>, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	pbonzini@redhat.com, kai.huang@intel.com, ubizjak@gmail.com, 
	dave.jiang@intel.com, jgross@suse.com, kvm@vger.kernel.org, 
	thomas.lendacky@amd.com, pgonda@google.com, sidtelang@google.com, 
	mizhang@google.com, rientjes@google.com, szy0127@sjtu.edu.cn
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2025, Kirill A. Shutemov wrote:
> On Mon, Jan 13, 2025 at 10:47:57AM -0800, Kevin Loughlin wrote:
> > On Fri, Jan 10, 2025 at 12:23=E2=80=AFAM Kirill A. Shutemov
> > <kirill.shutemov@linux.intel.com> wrote:
> > >
> > > On Thu, Jan 09, 2025 at 10:55:33PM +0000, Kevin Loughlin wrote:
> > > > @@ -710,6 +711,14 @@ static void sev_clflush_pages(struct page *pag=
es[], unsigned long npages)
> > > >       }
> > > >  }
> > > >
> > > > +static void sev_wb_on_all_cpus(void)

In anticipation of landing the targeted flushing optimizations[*] in the ne=
ar-ish
future, I would prefer to avoid the "on_all_cpus" aspect of the name.

Maybe sev_writeback_caches(), to kinda sorta pair with sev_clflush_pages()?
Definitely open to other names.

[*] https://lore.kernel.org/all/20240411140445.1038319-1-szy0127@sjtu.edu.c=
n

> > > > +{
> > > > +     if (boot_cpu_has(X86_FEATURE_WBNOINVD))
> > > > +             wbnoinvd_on_all_cpus();
> > > > +     else
> > > > +             wbinvd_on_all_cpus();
> > >
> > > I think the X86_FEATURE_WBNOINVD check should be inside wbnoinvd().
> > > wbnoinvd() should fallback to WBINVD if the instruction is not suppor=
ted
> > > rather than trigger #UD.
> >=20
> > I debated this as well and am open to doing it that way. One argument
> > against silently falling back to WBINVD within wbnoinvd() (in general,
> > not referring to this specific case) is that frequent WBINVD can cause
> > soft lockups, whereas WBNOINVD is much less likely to do so. As such,
> > there are potentially use cases where falling back to WBINVD would be
> > undesirable (and would potentially be non-obvious behavior to the
> > programmer calling wbnoinvd()), hence why I left the decision outside
> > wbnoinvd().

Practically speaking, I highly doubt there will ever be a scenario where no=
t
falling back to WBINVD is a viable option.  The alternatives I see are:

  1. Crash
  2. Data Corruption
  3. CLFLUSH{OPT}

(1) and (2) are laughably bad, and (3) would add significant complexity in =
most
situations (to enumerate all addresses), and would be outright impossible i=
n some.

And if someone opts for WBNOINVD, they darn well better have done their hom=
ework,
because there should be precious few reasons to need to flush all caches, a=
nd as
evidenced by lack of usage in the kernel, even fewer reasons to write back =
dirty
data while preserving entries.  I don't think it's at all unreasonable to p=
ut the
onus on future developers to look at the implementation of wbnoinvd() and
understand the implications.

> > That said, open to either way, especially since that "potential" use
> > case doesn't apply here; just lemme know if you still have a strong
> > preference for doing the check within wbnoinvd().
>=20
> An alternative would be to fail wbnoinvd() with an error code and
> possibly a WARN(). Crash on #UD is not helpful.

