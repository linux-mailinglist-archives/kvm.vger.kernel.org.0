Return-Path: <kvm+bounces-61245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29A4BC1224D
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 01:07:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BED9560C5A
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:07:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1061F25771;
	Tue, 28 Oct 2025 00:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PnU3ehrB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0151A945
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 00:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761610050; cv=none; b=ACi8jwhej50nm67pXi/PmGrfUMoNCE7DYWCds5hhbk/8LGRXPtDPcUCV0KIY6vvTQddvMV++pOgVN72lMKibH3V6hS5nwwUbIj9LsWIBOmK3Mke2V6G6XVFwi6isG93DNHo4XGCNvxzh6EUnFSSGl+6Pk5WRIGfodx0wrkw2YCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761610050; c=relaxed/simple;
	bh=mch/ZI5qLRVAoaLgIQZaPQoMvhlcGy0VDNUbNfpQoNo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GA46YPFJIwOjYO0+ow6UZSRad4uhAuladfBXjfT5BpDEpcfBM07yphnCBgETbRLXrXu9grVTTstYd9U0HIyWzhSqIjUMR46cAGDYQPYs5FEFPJjiRHCTu50ZfwV7Dhk4V02767oUTaYbT1lhSApHvURRzCr+YDY3QZtMRDBPKHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PnU3ehrB; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-27eeafd4882so100965ad.0
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 17:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761610048; x=1762214848; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mUCmWZphGtvkCj1oy/zutgPwDivCyw9UJKHVVAKeUSU=;
        b=PnU3ehrBAYP6zshNxUjevkDIW/+Ba3a6CqI7xwyMyj6Y1+QcyyZamaGEzsJGbd1JTb
         R5NS0/gsfQUTN62uUNQvCfbMb2RiOAMVheOh7/TLim3c3E1jnkwNvyhULsdw0tfE5nB5
         GW+tcbo92vlOLE7ZALop9N+jZ086b2u5pQ2fYlL7HYQTKcGvIqZ5fLjn/rykm5iSBkYy
         Q32xvwamlCOgUtsz2bO28YwrMi2BHGk5KvnBdg/uXsnozx3vbmWunIhRNtt39NzPj3lI
         DzfZ7eYU2Joc2k8m1q7PVHjU5C7BaSQdK51SZMpXwKoC9VEMunHj2uXPq+glg2WTMqf+
         n9fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761610048; x=1762214848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mUCmWZphGtvkCj1oy/zutgPwDivCyw9UJKHVVAKeUSU=;
        b=VUWz/Vk00hvYXMvpVHr3rTP5uJCKCumUmtXMZqxIr8dxpBBeSzToBl3dYKd4x1s5bY
         +JDb7verEc35C4qFnTcy36ChwhhLsVQqqJJKviL3eDwc5locVGg76gq8sr8b2/h7xY8r
         +6hqTmxYPtuDEwjZSbKu8yU/VtiNdsVMDnrnNW3bDB1ZDbyQz4qmlBm2n4D5B4RWw6r4
         s77fEhYT7C9EJpJIIFg+duelm+RI1B2zUv8CquRDafgXD+tYaG1pj2Ril3g9sywLUQhY
         Jobg4z/ZAClveGhfda2L9/9ZbBrpAhxa5Oxg7L1TjNF1555uUv7Dcrefj1gmMxHWJwNR
         nj4A==
X-Forwarded-Encrypted: i=1; AJvYcCU6kcK5aVCMuEz0JwUUkkdvDm2fKUERmw1Eass2Z2mA2WKQk7Pfe5SNTiKoHfuBMbF+w28=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8Nn2qbjm8ORP+q02l1mFlGjtrf43//7qRK8jmT1y/8hbsLvas
	YBNmjdjgDx9GRJoYDn6K3PZrASG0vJFmmGMK/PcziDJ4imkqofoZg1a5lgixBmzoNapmUTVE2Vy
	sIwUF6ZpLQ0AmfHC9F36P+WRsl1eTFpSucvKxNhDo
X-Gm-Gg: ASbGnctMscUnd/4WrMd8/CaB6AqN0LnwqP3QDFU+vQPX8Y5FWGhS7mOgJdTjaFagMoh
	wkcXVPbtUfK4lVfP7fPNBXJpSI6WLq6KsE+UoC93qP3qFycPf/YmSTHfEkhTLaSxxtbcGEwZ/NP
	+NH2eWz8dxmYGAahV+DUaaoJM4mmmBMy1TwmO7QytBY85cRya6PXzUB8TiY5nW0X9ej9VAYAyRz
	d3gOiWVaHUDbpPZvnE9iS+JQ1L/yac7Cs3LEfqLMsfqEnalpg1A9txD2owPuCFy34IlWLV7KBiN
	vQ21WOEA9Z5RYqBOsw==
X-Google-Smtp-Source: AGHT+IG1q9g21l8rIvkT2cpB43lyzci5HXE6aW1WkiXoYueYDIDNmiWxZPEvNuYZas1IC0sktW0/2rOmQ3UGOrkSU9U=
X-Received: by 2002:a17:902:e744:b0:290:dd42:eb5f with SMTP id
 d9443c01a7336-294ccb598e8mr2710275ad.12.1761610047632; Mon, 27 Oct 2025
 17:07:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901160930.1785244-1-pbonzini@redhat.com> <20250901160930.1785244-5-pbonzini@redhat.com>
 <CAGtprH-63eMtsU6TMeYrR8bi=-83sve=ObgdVzSv0htGf-kX+A@mail.gmail.com>
 <811dc6c51bb4dfdc19d434f535f8b75d43fde213.camel@intel.com>
 <ec07b62e266aa95d998c725336e773b8bc78225d.camel@intel.com> <114b9d1593f1168072c145a0041c3bfe62f67a37.camel@intel.com>
In-Reply-To: <114b9d1593f1168072c145a0041c3bfe62f67a37.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 27 Oct 2025 17:07:14 -0700
X-Gm-Features: AWmQ_blc7n8be0yWMkZPZeKdodPbTZIhORkjSheAPIkmIz8FANtGM3ijy60532w
Message-ID: <CAGtprH9uhdwppnQxNUBKmA4DwXn3qwTShBMoDALxox4qmvF6_g@mail.gmail.com>
Subject: Re: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>, 
	"Hansen, Dave" <dave.hansen@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"Chatre, Reinette" <reinette.chatre@intel.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"peterz@infradead.org" <peterz@infradead.org>, "sagis@google.com" <sagis@google.com>, 
	"Chen, Farrah" <farrah.chen@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"bp@alien8.de" <bp@alien8.de>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"Gao, Chao" <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"Williams, Dan J" <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 2:28=E2=80=AFPM Huang, Kai <kai.huang@intel.com> wr=
ote:
>
> On Mon, 2025-10-27 at 16:23 +0000, Edgecombe, Rick P wrote:
> > On Mon, 2025-10-27 at 00:50 +0000, Huang, Kai wrote:
> > > >
> > > > IIUC, kernel doesn't donate any of it's available memory to TDX mod=
ule
> > > > if TDX is not actually enabled (i.e. if "kvm.intel.tdx=3Dy" kernel
> > > > command line parameter is missing).
> > >
> > > Right (for now KVM is the only in-kernel TDX user).
> > >
> > > >
> > > > Why is it unsafe to allow kexec/kdump if "kvm.intel.tdx=3Dy" is not
> > > > supplied to the kernel?
> > >
> > > It can be relaxed.  Please see the above quoted text from the changel=
og:
> > >
> > >  > It's feasible to further relax this limitation, i.e., only fail ke=
xec
> > >  > when TDX is actually enabled by the kernel.  But this is still a h=
alf
> > >  > measure compared to resetting TDX private memory so just do the si=
mplest
> > >  > thing for now.
> >
> > I think KVM could be re-inserted with different module params? As in, t=
he two
> > in-tree users could be two separate insertions of the KVM module. That =
seems
> > like something that could easily come up in the real world, if a user r=
e-inserts
> > for the purpose of enabling TDX. I think the above quote was talking ab=
out
> > another way of checking if it's enabled.
>
> Yes exactly.  We need to look at module status for that.

So, the right thing to do is to declare the host platform as affected
by PW_MCE_BUG only if TDX module is initialized, does that sound
correct?

