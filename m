Return-Path: <kvm+bounces-6458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EB1E832392
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 04:13:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 334371C21C2D
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 03:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D045A1FA6;
	Fri, 19 Jan 2024 03:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="cNFsReMZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A78617C9
	for <kvm@vger.kernel.org>; Fri, 19 Jan 2024 03:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705633990; cv=none; b=Kt/E3vzuS8D/ydA7JsEa405f+iWDK/6pj2PR/0Syk2WH13ToI0o0UyYUW7++CSg7PkP7AQhLU+SUhcKq8SiI9eMosKKx7IKVzUQPC0UyxTp8C3vf7o1R0srDgtzILJk2eN1Cct5AmGl7L1LY6Mgq3Ytghg7rO7CBNzHXTQp44bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705633990; c=relaxed/simple;
	bh=+f2ZoedK7FP1DbND5juUvhTafSPGIv0emWsVqtcPME4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O3HFh+9fgRmKzqCnrfvaD9DDX9fl9+ATROMKx4PXXjhtyxNMyS/esj3bWS4OUgLV7bnHZbgRJEvuVgSSgajGx6gGY18ugJc6ZyrClpbxA9N84dT57AZatSoFZ4JAXtXvKwBBifhaNAd+fXuaiz/TYFq6zBHOJnp9+WvgMjXMKH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=cNFsReMZ; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-50edf4f478eso370039e87.3
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 19:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1705633986; x=1706238786; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YfU1RR3yVXE2aFjE6KuwO1NTsoIa0IOOIUzkc/YADig=;
        b=cNFsReMZRK0Oc4hfqvzplg3X83svfp0wBCIib+Vdz3umPUWpuj0yD1o2kKGYM0+T2E
         m/zZjfYBrbPTm1J7V8vBpdDf0C169yUdWgWx6zi3U7VHazKbDL2aoQo98YB23hgf84xH
         CqlCkE0b3KwvkRzw92qsMP3vWQYKfzJ0WK6hi1rCheVMcCet1ROlAbC9kiz2S5jiZ8DF
         ziDD8MlYdcN0JfOoFablYt7v2NNTB0wXKRVJKbrxzcVlBIx2n47/uzGtCsYzWToF0T05
         YCL5/9Pt8eXzQQVMBTywhk4waq7dAGPsUAXVZ6bOMOPj93AH4AdGCFBKn9yAW98fGQP7
         OWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705633986; x=1706238786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YfU1RR3yVXE2aFjE6KuwO1NTsoIa0IOOIUzkc/YADig=;
        b=MpG13dQHpR8H8yDUYt+pvYGSsm5bSpiLnni9s1N+BV1Eaq28343Wc1bc71R74K5dis
         NAa3x2cGT1sTv2gh8zc6xW339l+2PFJjmqS+ojWNPigSbGYNDYDtOUV2r/cD9URkdre9
         pS03/Gt5ooQ4JKFhP6iilX6pwXlXnBVP/xwaLekwC+mbechOe9TTwIif71a4i8QZykvb
         B5bsPIFVxY7zE9LCEGw49e1LgmLhtmoF8s2v31NAD74omRkitnHs2nkl3k8ywOJJ5Ieb
         pQ+d2BOWpTTx8OLM0kVZxsAxIUcc1vd6aK2EW4sRESRNBlRm4en8CAHN1hS74brRWQfb
         x3OQ==
X-Gm-Message-State: AOJu0YyJPNBJKBoBz2+J23yWG5bq5LzjGHSjVQ+QBE/6CudNuZDp3HPl
	g1bvQAPzJXc8QLI6H2AhKsZfWX7ignQEN8GEpBFR9KMM2sg2IUBBHTYLNKdo7/wSw/LzkadiT7E
	bNdCQKXsXtfXhG0FVRnxNUJxaB5Rrz2PU6LdUJA==
X-Google-Smtp-Source: AGHT+IE+iUkkY6fxTl1+JfpkYAQ0slyXdEkKVq40J5n5SU1ZLhag+ZXwroh2Z1WoXt0AjKQUbiW1WyNyUstIlFIKEPY=
X-Received: by 2002:ac2:41c9:0:b0:50e:314c:76da with SMTP id
 d9-20020ac241c9000000b0050e314c76damr265337lfi.82.1705633986292; Thu, 18 Jan
 2024 19:13:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240104123727.76987-2-ajones@ventanamicro.com>
 <CAAhSdy0SxZWdCHQVW0Bki+bHpg4qrHWV0aFzJq8V2xYtwsMWhw@mail.gmail.com> <ZalilFSHBa_XHolD@google.com>
In-Reply-To: <ZalilFSHBa_XHolD@google.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Fri, 19 Jan 2024 08:42:53 +0530
Message-ID: <CAK9=C2X4R+3F5Lh-f33dPVMkyGt+koXorfwMOmB-JnqSs79eQw@mail.gmail.com>
Subject: Re: [PATCH -fixes v2] RISC-V: KVM: Require HAVE_KVM
To: Sean Christopherson <seanjc@google.com>
Cc: Anup Patel <anup@brainfault.org>, Andrew Jones <ajones@ventanamicro.com>, 
	linux-riscv@lists.infradead.org, linux-next@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, atishp@atishpatra.org, rdunlap@infradead.org, 
	sfr@canb.auug.org.au, alex@ghiti.fr, mpe@ellerman.id.au, npiggin@gmail.com, 
	linuxppc-dev@lists.ozlabs.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 18, 2024 at 11:10=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Jan 18, 2024, Anup Patel wrote:
> > On Thu, Jan 4, 2024 at 6:07=E2=80=AFPM Andrew Jones <ajones@ventanamicr=
o.com> wrote:
> > >
> > > KVM requires EVENTFD, which is selected by HAVE_KVM. Other KVM
> > > supporting architectures select HAVE_KVM and then their KVM
> > > Kconfigs ensure its there with a depends on HAVE_KVM. Make RISCV
> > > consistent with that approach which fixes configs which have KVM
> > > but not EVENTFD, as was discovered with a randconfig test.
> > >
> > > Fixes: 99cdc6c18c2d ("RISC-V: Add initial skeletal KVM support")
> > > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > > Closes: https://lore.kernel.org/all/44907c6b-c5bd-4e4a-a921-e4d382553=
9d8@infradead.org/
> > > Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> >
> > Queued this patch for Linux-6.8
>
> That should be unnecessary.  Commit caadf876bb74 ("KVM: introduce CONFIG_=
KVM_COMMON"),
> which is in Paolo's pull request for 6.8, addresses the EVENTFD issue.  A=
nd the
> rest of Paolo's series[*], which presumably will get queued for 6.9, elim=
inates
> HAVE_KVM entirely.
>
> [*] https://lore.kernel.org/all/20240108124740.114453-6-pbonzini@redhat.c=
om

I was not sure about the timeline of when Paolo's series would be merged
hence thought of taking this patch as a fix.

For now, I will drop this patch from my queue. If required we can have it
as a 6.8-rc fix.

Regards,
Anup

