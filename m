Return-Path: <kvm+bounces-14262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D60008A173C
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 16:31:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF986B2BE74
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 14:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFB8814EC49;
	Thu, 11 Apr 2024 14:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RaKXz5PV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990A614C583
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 14:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712845367; cv=none; b=e05R6uLwJOrWBfktc3ZA7r0EbECZNGA8Cqo8I3vi82bO//LovTotuCX8nONzX8F3VrL7Ubnt6oUpNiW7SxOZ+gSiH2ZRf9q3aHe3e4PocLQmcPUk1LNDw1PCmb3IzaDP2/89hCIvR2bB5HsJAD6wY2sx977OwkSW0FMJ0UbdLBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712845367; c=relaxed/simple;
	bh=5ws/A/06xIoL6+cVU7hMy6Emh6zWldKl+mIyryAkvSE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RsdwbpNkCbgscrgFLF0TZYfWvVFibKUS7ZIm5DSXUykE415X7zXCeHdzLeRD0X6WSLvPQRTYQRs84wwTQ/PK+Pnl1C5xfTV3rUE2AGZG/6qCVHdYVYSn8uXmQXlaTph1MnJ0rX+Ei2OfqifoHWjBRTAArTtyOaDCVNGwcq1/p7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RaKXz5PV; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61836c921a4so50542897b3.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 07:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712845365; x=1713450165; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9GtzFk1KROuOyCTzMxxWmq/Qzlg7l7c+rvMLuBjBAYQ=;
        b=RaKXz5PV9xVBhOIDiZiDdzGTjHHF/gFPElEcFmWzbcOHEcDBio9yl5EP4qHW6U2aqu
         +/g++rF3ifKPkDRLmOFm4QhnINlvndl9+lY5cvxCJ81CZgk6sv63SNNharfm1VwUglWB
         NJ3Xw4mzm5IXPOGLgpx4aoZTyo1sTA3MTD4tpJO1+lI0be5V8SlEBtIzWWf6elBRXnQl
         aTpqWoe2sF6B8pFz5bHCeWtNMrUMF8OidsZU51rkAEGkKmDGvSGFTEMXOYPmDLC+G1DY
         mbeoG2LqIxpTp3RMKy9BDykquC/cqXABUjMs1Wtyw4Wkb3t/evufXIhrABLCxhgZ0F/Z
         Z3fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712845365; x=1713450165;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9GtzFk1KROuOyCTzMxxWmq/Qzlg7l7c+rvMLuBjBAYQ=;
        b=gvW3mz2TQ2j+PIYbAcpk25U7c3bdpTpSX2UDpbAHj4zaRhYpNfPo4wCV2NV8LZxbuD
         p2HPQkxZP2NouJPttpjHncFx8VS/zrXzkzXoB9pRq9MY0DlEHtT+q0Xr2QSTCoOUYHWu
         Rkqw5AzSeyC/6rMAef4zbaoY6QvVBrnaUoShV2XpzP59Zt9WTk4jSgfKNtWYZuOmGuDh
         ABK7vjORimFYUjTnygn0I6jHcUehiB+zJgjVZiZRrTk+mlDfEDSxt2ZPm5zwqocO+iAF
         yS0GE5kDd7ocAVu1ctE/t6J8nHmDq3YPAzXS2s42/Hsm+qFCOZJ0mtsQpflDzGUfIb55
         6IPw==
X-Forwarded-Encrypted: i=1; AJvYcCXhFwpVAYoqctkXPYD8tKuT3LnGtlQ/k1GrF22uxhRaYVAPwq8oRF3/Q4T/m7SoprQRyO1GGCsBJ3UZhmTfeSjS8X62
X-Gm-Message-State: AOJu0YxiKOgEWIdJrYFAtyqrudSTlwl6soRFZIHNJpq7fqKoh9/E6SsX
	Sa1ZqgNsI6si0N5dJ88u/lrZVkKyCFoSFXFe+tZnkdNVGjTBzHrX3JjcZZvUWyhIOhFI+XOJGIY
	Kpw==
X-Google-Smtp-Source: AGHT+IFFHEHDmY+PfptNwpczLpS5fCk2BFurIG4JKclwhXEwzGr9Uvo0u9/2jjW6EximfNlJxE4MUFsl28E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d8d3:0:b0:615:134c:7ef3 with SMTP id
 a202-20020a0dd8d3000000b00615134c7ef3mr1511695ywe.9.1712845365687; Thu, 11
 Apr 2024 07:22:45 -0700 (PDT)
Date: Thu, 11 Apr 2024 07:22:44 -0700
In-Reply-To: <b1d112bf0ff55073c4e33a76377f17d48dc038ac.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZhQ8UCf40UeGyfE_@google.com> <5faaeaa7bc66dbc4ea86a64ef8e8f9b22fd22ef4.camel@intel.com>
 <ZhRxWxRLbnrqwQYw@google.com> <957b26d18ba7db611ed6582366066667267d10b8.camel@intel.com>
 <ZhSb28hHoyJ55-ga@google.com> <8b40f8b1d1fa915116ef1c95a13db0e55d3d91f2.camel@intel.com>
 <ZhVdh4afvTPq5ssx@google.com> <4ae4769a6f343a2f4d3648e4348810df069f24b7.camel@intel.com>
 <ZhVsHVqaff7AKagu@google.com> <b1d112bf0ff55073c4e33a76377f17d48dc038ac.camel@intel.com>
Message-ID: <ZhfyNLKsTBUOI7Vp@google.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "davidskidmore@google.com" <davidskidmore@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"srutherford@google.com" <srutherford@google.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Wei W Wang <wei.w.wang@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024, Rick P Edgecombe wrote:
> On Tue, 2024-04-09 at 09:26 -0700, Sean Christopherson wrote:
> > > Haha, if this is the confusion, I see why you reacted that way to "JS=
ON".
> > > That would be quite the curious choice for a TDX module API.
> > >=20
> > > So it is easy to convert it to a C struct and embed it in KVM. It's j=
ust not
> > > that useful because it will not necessarily be valid for future TDX m=
odules.
> >=20
> > No, I don't want to embed anything in KVM, that's the exact same as har=
dcoding
> > crud into KVM, which is what I want to avoid.=C2=A0 I want to be able t=
o roll out a
> > new TDX module with any kernel changes, and I want userspace to be able=
 to
> > assert
> > that, for a given TDX module, the effective guest CPUID configuration a=
ligns
> > with
> > userspace's desired the vCPU model, i.e. that the value of fixed bits m=
atch up
> > with the guest CPUID that userspace wants to define.
> >=20
> > Maybe that just means converting the JSON file into some binary format =
that
> > the
> > kernel can already parse.=C2=A0 But I want Intel to commit to providing=
 that
> > metadata
> > along with every TDX module.
>=20
> Oof. It turns out in one of the JSON files there is a description of a di=
fferent
> interface (TDX module runtime interface) that provides a way to read CPUI=
D data
> that is configured in a TD, including fixed bits. It works like:
> 1. VMM queries which CPUID bits are directly configurable.
> 2. VMM provides directly configurable CPUID bits, along with XFAM and
> ATTRIBUTES, via TDH.MNG.INIT. (KVM_TDX_INIT_VM)
> 3. Then VMM can use this other interface via TDH.MNG.RD, to query the res=
ulting
> values of specific CPUID leafs.
>=20
> This does not provide a way to query the fixed bits specifically, it tell=
s you
> what ended up getting configuring in a specific TD, which includes the fi=
xed
> bits and anything else. So we need to do KVM_TDX_INIT_VM before KVM_SET_C=
PUID in
> order to have something to check against. But there was discussion of
> KVM_SET_CPUID on CPU0 having the CPUID state to pass to KVM_TDX_INIT_VM. =
So that
> would need to be sorted.
>=20
> If we pass the directly configurable values with KVM_TDX_INIT_VM, like we=
 do
> today, then the data provided by this interface should allow us to check
> consistency between KVM_SET_CPUID and the actual configured TD CPUID beha=
vior.

I think it would be a good (optional?) sanity check, e.g. KVM_BUG_ON() if t=
he
post-KVM_TDX_INIT_VM CPUID set doesn't match KVM's internal data.  But that=
 alone
provides a terrible experience for userspace.

 - The VMM would still need to hardcode knowledge of fixed bits, without a =
way
   to do a sanity check of its own.

 - Lack of a sanity check means the VMM can't fail VM creation early.

 - KVM_SET_CPUID2 doesn't have a way to inform userspace _which_ CPUID bits=
 are
   "bad".

 - Neither userspace nor KVM can programming detect when bits are fixed vs.
   flexible.  E.g. it's not impossible that userspace would want to do X if=
 a
   feature is fixed, but Y if it's flexible.

