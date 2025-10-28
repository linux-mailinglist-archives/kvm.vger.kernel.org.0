Return-Path: <kvm+bounces-61251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B65DBC122BA
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 01:30:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19407562611
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:29:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B191E9B1A;
	Tue, 28 Oct 2025 00:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Qn5cXtj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178371DFE22
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 00:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761611386; cv=none; b=VgW0CYUBrNMx4rYp/1en0vgoKQdFQjXpkxsgBz8kH+JD8T25Q0fEIlzn4aW164x31fW8vIK+B36KomlRrjsLQiPZ8dWJ5NmxjU7VmIT9DTl/keswvMxYi3UXBBCdt4cTPrkrTW+U7lhRQdbFM5U04KovoAtwbUjFOX/FsCA6cls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761611386; c=relaxed/simple;
	bh=qyo5vYPBXQcSiICdjzpbw4YoCeaDaAVfCf6SQjhOYiM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W+RIihrgKV5KASddBVrEkzFMy2alL8WFTJObD9IxCczEON42VBL5tWvMMkLrAL9KHgDs57NJAuubTpDlKiiIxa7QETXDzQyg2lHUveX20ZsPc4KY9gK8bnARtPorKkTAAmi/4C/dFxMc1v0vYx/sohtCIKgMN4XOkemEoA/Ns/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0Qn5cXtj; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3304def7909so4092828a91.3
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 17:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761611384; x=1762216184; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3fZq3tbinLN9iV6tR9wh+L1TcJJLRbds3pWQbE4SVPQ=;
        b=0Qn5cXtjMYcc6CIS2H+1Z74GJ2Jp6I330AeAsK9DA0QGAjHitp8PleqTjjq5SHtwBW
         X3TkCnWUkH+3mcXGED0VDYN52c8K3cbVb9vL64HYRyYfiMA5SX9KoQ9gk4hNvgA2UgCy
         xfw3WSILSBjcye1CfHBueOPfGQ6Bdxc9Tyj0b3IAhJGQPROAM8FvJutS4SnzMxG1jP+G
         mIGxPum8YQaHDI4U59yRipRLjLXdNGd0Ph9T87fnHeM/A57be2LkxC3QPnXB3GjUYp+V
         27rPKJ4fjgRgiYmICJdxFuRjcgTMSflcJMczmosWgakqLLIiNU8LvX+USP6AyS0BlSGm
         xh5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761611384; x=1762216184;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3fZq3tbinLN9iV6tR9wh+L1TcJJLRbds3pWQbE4SVPQ=;
        b=ORvE7xDwo29rUVUj0lBVruCMIjAptMddn6MoO31AnV2nFiLpxDIZ57BGSsiuEao8kx
         A6nLkzcY0GDVBVqS1mDenaKBmXDV3WANzdtnWyLDyPAf5/l+na+K2yEIJ/Xxvt/jXuXh
         MTXrdMpxH/2aSg8ypngcbm5KzdPf1yP3Gruyi7bZT4uu5VAJCssyrSF23Mk8iRKntSO+
         rsNlN95oW3ZxfgLzvAZgG528Sgwy1OXrybHiVdn8wRgtukrPSJEDcoh2T1x7skXnsYC+
         RaEfsu33jpCc89cQbK4Z7++3yjnREfQCvWW548ETEUW0Cq8+f9ak40VIqaxvXW9sNHkO
         2OYg==
X-Forwarded-Encrypted: i=1; AJvYcCWVmgtB8g9tirsfRVDCi3JhBcYuq4z9X8g5y7P7V5L+z+j5KR61eGmjS5mtaFLtFBocXg0=@vger.kernel.org
X-Gm-Message-State: AOJu0YygVymdqTzEJC5TYKy1DY5SdXcSHdAC3xMNDHUsKjpjocX+FtBn
	MeCDBPjsDOr7Rk9jrHcINL/tdL8DgPEUHnXLREKZU1Frw/TK7aV4vDlYhduBVFOZhgyB19Ro3FQ
	zxKJ9ZA==
X-Google-Smtp-Source: AGHT+IEcbPffJX+DPzKHtANj5YoID2qTNS+wCvJIhOFTengBDdmvUTitjaF5SaOhKDAJ4Iu3BAJZiOrVVlg=
X-Received: from pjqc14.prod.google.com ([2002:a17:90a:a60e:b0:33b:51fe:1a77])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d0f:b0:33e:30e8:81cb
 with SMTP id 98e67ed59e1d1-34027a0775bmr1898674a91.13.1761611384405; Mon, 27
 Oct 2025 17:29:44 -0700 (PDT)
Date: Mon, 27 Oct 2025 17:29:42 -0700
In-Reply-To: <59ae9957-88a8-4777-9bd2-196e8b4eb8ac@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-14-seanjc@google.com>
 <5dea4a3d-c7b7-48f0-b2d5-7597e0cd5f00@linux.intel.com> <aPuqYz3ly5a3__mf@google.com>
 <59ae9957-88a8-4777-9bd2-196e8b4eb8ac@linux.intel.com>
Message-ID: <aQAOdiSUktmAJKsw@google.com>
Subject: Re: [PATCH v3 13/25] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025, Binbin Wu wrote:
>=20
>=20
> On 10/25/2025 12:33 AM, Sean Christopherson wrote:
> > On Fri, Oct 24, 2025, Binbin Wu wrote:
> > >=20
> > > On 10/17/2025 8:32 AM, Sean Christopherson wrote:
> > > > Fold tdx_mem_page_record_premap_cnt() into tdx_sept_set_private_spt=
e() as
> > > > providing a one-off helper for effectively three lines of code is a=
t best a
> > > > wash, and splitting the code makes the comment for smp_rmb()  _extr=
emely_
> > > > confusing as the comment talks about reading kvm->arch.pre_fault_al=
lowed
> > > > before kvm_tdx->state, but the immediately visible code does the ex=
act
> > > > opposite.
> > > >=20
> > > > Opportunistically rewrite the comments to more explicitly explain w=
ho is
> > > > checking what, as well as _why_ the ordering matters.
> > > >=20
> > > > No functional change intended.
> > > >=20
> > > > Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> > >=20
> > > One nit below.
> > >=20
> > > [...]
> > > > +	/*
> > > > +	 * If the TD isn't finalized/runnable, then userspace is initiali=
zing
> > > > +	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Increment the numbe=
r of
> > > > +	 * pages that need to be mapped and initialized via TDH.MEM.PAGE.=
ADD.
> > > > +	 * KVM_TDX_FINALIZE_VM checks the counter to ensure all mapped pa=
ges
> > >  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0^
> > >  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Nit: Is pre-mapped better?
> > Yeah, updated (and then it gets deleted a few commits later :-) ).
> Oh, right, nr_premapped will be dropped later.
>=20
> Since the whole nr_premapped will be dropped, do we still need a cleanup =
patch
> like patch 12 which will be dropped finally?

We don't strictly "need" the cleanups, but IMO intermediate cleanups are of=
ten
worth doing even if they get thrown away, soo that the code is in a (hopefu=
lly)
better state when the "big" functional change comes along.  I.e. if code 'X=
' is
easier to understand than code 'Y', then theoretically/hopefully X=3D>Z is =
also
easier to understand than Y=3D>Z.

