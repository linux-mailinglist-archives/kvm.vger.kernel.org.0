Return-Path: <kvm+bounces-49815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD17CADE392
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 08:22:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4AB1189C925
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41C3A1E3769;
	Wed, 18 Jun 2025 06:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WbmbxAFn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB771B0437
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 06:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750227717; cv=none; b=exdxKDC2iimO0OYJ9RJJjKCcmR/rhJkoNVsBMgtfg19GFJbPxTMM+5n13BvZpJtrf1tcxXC91Jp0UfoMS96jkgWRCfgt8S/PCYQ5komVjooowHS+ZzBPw/Y8k41SZtBa/y2vdRpp5zXip/HMM3249jEDXwg8PZlz/00VWsK5qAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750227717; c=relaxed/simple;
	bh=M2oZbg2GUqircKqpExFuqTy9suxAPOctTofRORlY2no=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AARyfzR4Wil3OW4REf8zw8kKNy3f7/y9DpSlhmXeDG0LqnpdJ8EMNEXEMID6FWHAAc+yrRp5p8oQ3npfG4V61bDPva4F92SCJQ3y8cn4xSxdUKAHAj+Vh19WrhQaI8fzck7vsAR+gxzOPOU35MfGdKxu4yvGMJaBcGTh86LwY/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WbmbxAFn; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2357c61cda7so63095ad.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 23:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750227715; x=1750832515; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M2oZbg2GUqircKqpExFuqTy9suxAPOctTofRORlY2no=;
        b=WbmbxAFnUszRB9668QKNZa24uxOAmtSnVnY+ori1fjN12tMrUbTzKB3470WDMZpvxw
         FEIac+31NN1pHXh82SaJA1+QtmWNvfp9OoUlpZu7UXXuUHDIqPewWFb+k0iB6HKJ8sNP
         RapAeoer261Um1DhJE9j2tjT8n6D6xar2d1fuV4p9GHWreIKCrlROZiw+LI25+apQ9Lt
         dHb8AIVk7h9jdAKvMycTpXNXEG9g5gTPBKsPLKumLPJlQqWaVQXHJyufI6vi9EnLRWl9
         AWFZT3RgMcJRNZOEhtW2tB0FQA+uKL7UjeHVNlDaD7p4zn/AKGmtDJXkMh6VSsBiCZuI
         BTLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750227715; x=1750832515;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M2oZbg2GUqircKqpExFuqTy9suxAPOctTofRORlY2no=;
        b=dlBHRFe0IFdP9vh1cJ/O1NI+eM6UPC9dY/dnwaLqdNx4Qko1riVMftQj8k2zZ1oZNv
         N1hd8dya4qJsYspOjeuXtzw2QIEsF5R0lxGlpANY3jW829BFe2wCnR2ktN6Pa+MoC716
         5+HalEYT88aGBDL4vLHqD0KUj3jJTkW0KkkZpU+wb+y9l/7TxBimGvpWX/284GQPHkTd
         WnkX51swEZPCZlaGq1FAYLL6yBRFnxlOk8YuhvHbL1H4azexmGLSdGVfIp+SGYDjL0LQ
         /UQyHnFpeDs0XLH2rlJq+VDHO1JUB3DRyUcfeYX70qxCCGpgrb/YJTBNg8rNpnkNEXmA
         C8zg==
X-Forwarded-Encrypted: i=1; AJvYcCUiS6TUelHnNvafFrkUquFzSYL1z8YpZSsUtLv8x57BxRc6EtvOdcktU3DA6xO7qspWI7A=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx24Y/Kyw28GdJcLAerocOpGAFFq+g/wyHJnlt4V0rqqx0LnDh
	RR++bbOJD2T7/OWlTrO/jxBtq7XgHFQuQ/vtgwnpyb5lJxfTpEot5Qa1ShFdt9IF8alJY0sj74T
	vNkyLGuZUYI7Ulfx1Q7hPoSSXUO9hB3Ni+/XvkXei
X-Gm-Gg: ASbGncv5dZ0C6WV0Ernn/RPehJlqdOAGfj8DZU722/1dfZy3Pl4yI8lyHCqF9NizsBs
	pFsq+LCfB65yllD/lsgQc4yv9tZWwZJ0ZF1q5OV4CLqfZuItC1cbjnY0JNZkDjh3+hmvbFlT3Tf
	wh1i87ABcGf3JuaGWhf5L47X689B8JigvkYCfQ6cltYQ==
X-Google-Smtp-Source: AGHT+IGK3ol8JP93u/VaNeY9EDNrNJpQd59v5T6XZJjNKDTOkjHCqtBfGffmbF0fyH/4vlRnqrmwub7qfl3mnN7UET0=
X-Received: by 2002:a17:903:22d1:b0:215:7152:36e4 with SMTP id
 d9443c01a7336-2366f00e2damr10103495ad.27.1750227714423; Tue, 17 Jun 2025
 23:21:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com> <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com> <CAGtprH_SKJ4hbQ4aSxxybcsD=eSQraP7a4AkQ3SKuMm2=Oyp+A@mail.gmail.com>
 <aFEQy4g4Y2Rod5GV@yzhao56-desk.sh.intel.com> <CAGtprH_ypohFy9TOJ8Emm_roT4XbQUtLKZNFcM6Fr+fhTFkE0Q@mail.gmail.com>
 <8f686932b23ccdf34888db3dc5a8874666f1f89f.camel@intel.com>
 <aFIMbt7ZwrJmPs4y@yzhao56-desk.sh.intel.com> <CAGtprH9Wj7YW-_sfGQfwKHRXL-7fFStXiHn2O32ptXAFbFB8Tw@mail.gmail.com>
 <aFJY/b0QijjzC10a@yzhao56-desk.sh.intel.com>
In-Reply-To: <aFJY/b0QijjzC10a@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 17 Jun 2025 23:21:41 -0700
X-Gm-Features: AX0GCFtRUP-5cnFBemiZhlLVBMxziNxOYphJQzh7iBKSZHxolwfAovcV1sgbry8
Message-ID: <CAGtprH9WLRNcXWr1tK6MmatoSun9fdSg5QUj1q=gETPmRX_rsQ@mail.gmail.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"tabba@google.com" <tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Du, Fan" <fan.du@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "jroedel@suse.de" <jroedel@suse.de>, 
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2025 at 11:15=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wr=
ote:
>
> On Tue, Jun 17, 2025 at 09:33:02PM -0700, Vishal Annapurve wrote:
> > On Tue, Jun 17, 2025 at 5:49=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com>=
 wrote:
> > >
> > > On Wed, Jun 18, 2025 at 08:34:24AM +0800, Edgecombe, Rick P wrote:
> > > > On Tue, 2025-06-17 at 01:09 -0700, Vishal Annapurve wrote:
> > > > > Sorry I quoted Ackerley's response wrongly. Here is the correct r=
eference [1].
> > > >
> > > > I'm confused...
> > > >
> > > > >
> > > > > Speculative/transient refcounts came up a few times In the contex=
t of
> > > > > guest_memfd discussions, some examples include: pagetable walkers=
,
> > > > > page migration, speculative pagecache lookups, GUP-fast etc. Davi=
d H
> > > > > can provide more context here as needed.
> > > > >
> > > > > Effectively some core-mm features that are present today or might=
 land
> > > > > in the future can cause folio refcounts to be grabbed for short
> > > > > durations without actual access to underlying physical memory. Th=
ese
> > > > > scenarios are unlikely to happen for private memory but can't be
> > > > > discounted completely.
> > > >
> > > > This means the refcount could be increased for other reasons, and s=
o guestmemfd
> > > > shouldn't rely on refcounts for it's purposes? So, it is not a prob=
lem for other
> > > > components handling the page elevate the refcount?
> > > Besides that, in [3], when kvm_gmem_convert_should_proceed() determin=
es whether
> > > to convert to private, why is it allowed to just invoke
> > > kvm_gmem_has_safe_refcount() without taking speculative/transient ref=
counts into
> > > account? Isn't it more easier for shared pages to have speculative/tr=
ansient
> > > refcounts?
> >
> > These speculative refcounts are taken into account, in case of unsafe
> > refcounts, conversion operation immediately exits to userspace with
> > EAGAIN and userspace is supposed to retry conversion.
> Hmm, so why can't private-to-shared conversion also exit to userspace wit=
h
> EAGAIN?

How would userspace/guest_memfd differentiate between
speculative/transient refcounts and extra refcounts due to TDX unmap
failures?

>
> In the POC
> https://lore.kernel.org/lkml/aE%2Fq9VKkmaCcuwpU@yzhao56-desk.sh.intel.com=
,
> kvm_gmem_convert_should_proceed() just returns EFAULT (can be modified to
> EAGAIN) to userspace instead.
>
> >
> > Yes, it's more easier for shared pages to have speculative/transient re=
fcounts.
> >
> > >
> > > [3] https://lore.kernel.org/lkml/d3832fd95a03aad562705872cbda5b3d248c=
a321.1747264138.git.ackerleytng@google.com/
> > >
> > > > >
> > > > > Another reason to avoid relying on refcounts is to not block usag=
e of
> > > > > raw physical memory unmanaged by kernel (without page structs) to=
 back
> > > > > guest private memory as we had discussed previously. This will he=
lp
> > > > > simplify merge/split operations during conversions and help useca=
ses
> > > > > like guest memory persistence [2] and non-confidential VMs.
> > > >
> > > > If this becomes a thing for private memory (which it isn't yet), th=
en couldn't
> > > > we just change things at that point?
> > > >
> > > > Is the only issue with TDX taking refcounts that it won't work with=
 future code
> > > > changes?
> > > >
> > > > >
> > > > > [1] https://lore.kernel.org/lkml/diqz7c2lr6wg.fsf@ackerleytng-cto=
p.c.googlers.com/
> > > > > [2] https://lore.kernel.org/lkml/20240805093245.889357-1-jgowans@=
amazon.com/
> > > >

