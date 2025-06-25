Return-Path: <kvm+bounces-50752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8B11AE902F
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 23:27:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB6631C2498B
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 21:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D14BA216E1B;
	Wed, 25 Jun 2025 21:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0dIQQcEk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F62120C476
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 21:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750886845; cv=none; b=tXLUj1XfpQKB29WErFR0wtYwR6Mw1+RMalgLmxivkO826ytAmzUhwZjisyztApFQi1jUtV1HPNXaF18UKF7cXPvE3X1c0IeH3x2wBWLYBC3aH80uytX1fxdI84CNLbteT8WVXSLneya7Bm1vV0mILhmYcQ5HRuW2pKNHIdr6r1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750886845; c=relaxed/simple;
	bh=5/AIDMzcp9aAn9GVVD2wKIiPIrXAOBeyMNI9k6+uBv8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GMWWV6LLF7/cVS2Hkt7gVwBPQShZnrUd3H0617ahH5+dnjkfrexREBBUVCTUyNuEYqxXaQotym5H3ZL+FLTkAG5iiMXFR3wXLoUUn1Ls+9frRvfARgx076lNRxqPzrfDv8kuYAepWT13yF6mKcsLOXzcHvF3Tw4CsfBu5WKO0DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0dIQQcEk; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31f4a9f67cso316545a12.1
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 14:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750886843; x=1751491643; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KDkUH/8hPd96nHKcCj5ct66aFf82AL3mnAQ30uxk9O8=;
        b=0dIQQcEkGzL0OK3+cvDkHl9CLorXFtyko7Y8nVVUS/Jt5isX5qz7F0UEHT5LWZfglY
         Y4Ck02d4WAMJ7kYxxX22yKj+IvnUOD9JsWqrYLZPfMX3G56Agj0nmNebwWah1+ch3kmU
         SnACsnf5VC3eaghI/9QbNGszQiyQKq/OS/8s851Ik922GUrDODtIuE+Dxbq4R7oB2VYS
         9hvS6pRL9JnapON8va4ueR4EGQMbW/j+LrryuaYng+cQaMZFv4sD2W4euCfcbNu+PKuN
         gU7+fyZEm8LR9tTYqJPNkUVTrO8ITh2kqj5L72JcBIW2J68bkcJnGjdVm59apz456OY8
         jKhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750886843; x=1751491643;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KDkUH/8hPd96nHKcCj5ct66aFf82AL3mnAQ30uxk9O8=;
        b=b76bMbiQBkVnTK5Bq6k9N4TkblZBtFRkbZPppjvViB5ExpupOBSjjnzOXbGvSiKy5T
         PKIN3AEZTZbQjPslYYdEq0ThNGw5kIL1bxokcjgZVsYLVtpQS5SzQQuOxE/8Qnm2/r9B
         fOngztEc35btCA/MlpZ8Zrp0OaoxIBRv1G48I430coVzwWb7etfyLffkCp3JyPoyqY6Q
         xb1qPL/7v2yB+JbTEwBmOfMdxVka1KTmVKgrXoA/ajwX3cSdKRY12Vo+CGQ/VLACJ9YR
         MsGmO8vsFoTLcMueKKEyoXoB7MZJobrJ3YI2TeuYl1KViadpLpeWSjgQ4ogAIY3bqWXp
         bnVw==
X-Forwarded-Encrypted: i=1; AJvYcCVqN5c9xo0UJLRn8Vat8jZI250fT+YxsM8l8agSBvOLyfLtjv/PRYn4RC88IUREXVBuu5E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTPZVKIgPYx6CmjcF9waqo1XtKv7W40eyDhpTIzGjHQfdPXh3N
	5DP83lCg0VFbrqoO5Mx0zDviBIiqUND+2lb6xDj2F73OH42cLdOjH3Dsb4iSrtMYRs72nHNLeP3
	mVCpqZg==
X-Google-Smtp-Source: AGHT+IHnNSiQClR98Tu2DIjJN0yUuPOY+tZ7wsPVNu+SogPTpvB/xoqOJtGyrrKUyaCs7hclUXM8so0Z7ms=
X-Received: from pjboi14.prod.google.com ([2002:a17:90b:3a0e:b0:2ff:6132:8710])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1aab:b0:235:eefe:68ec
 with SMTP id d9443c01a7336-23823fe1d8dmr78782915ad.19.1750886843038; Wed, 25
 Jun 2025 14:27:23 -0700 (PDT)
Date: Wed, 25 Jun 2025 14:27:21 -0700
In-Reply-To: <d897ab70d48be4508a8a9086de1ff3953041e063.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-2-kirill.shutemov@linux.intel.com>
 <5cfb2e09-7ecb-4144-9122-c11152b18b5e@intel.com> <d897ab70d48be4508a8a9086de1ff3953041e063.camel@intel.com>
Message-ID: <aFxpuRLYA2L6Qfsi@google.com>
Subject: Re: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Dave Hansen <dave.hansen@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, Chao Gao <chao.gao@intel.com>, 
	"bp@alien8.de" <bp@alien8.de>, Kai Huang <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2025, Rick P Edgecombe wrote:
> On Wed, 2025-06-25 at 10:58 -0700, Dave Hansen wrote:
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -202,12 +202,6 @@ static DEFINE_MUTEX(tdx_lock);
> > > =C2=A0=20
> > > =C2=A0 static atomic_t nr_configured_hkid;
> > > =C2=A0=20
> > > -static bool tdx_operand_busy(u64 err)
> > > -{
> > > -	return (err & TDX_SEAMCALL_STATUS_MASK) =3D=3D TDX_OPERAND_BUSY;
> > > -}
> > > -
> > > -
> >=20
> > Isaku, this one was yours (along with the whitespace damage). What do
> > you think of this patch?
>=20
> I think this actually got added by Paolo, suggested by Binbin. I like the=
se
> added helpers a lot. KVM code is often open coded for bitwise stuff, but =
since
> Paolo added tdx_operand_busy(), I like the idea of following the pattern =
more
> broadly. I'm on the fence about tdx_status() though.

Can we turn them into macros that make it super obvious they are checking i=
f the
error code *is* xyz?  E.g.

#define IS_TDX_ERR_OPERAND_BUSY
#define IS_TDX_ERR_OPERAND_INVALID
#define IS_TDX_ERR_NO_ENTROPY
#define IS_TDX_ERR_SW_ERROR

As is, it's not at all clear that things like tdx_success() are simply chec=
ks,
as opposed to commands.

