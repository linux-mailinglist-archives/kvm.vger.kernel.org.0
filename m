Return-Path: <kvm+bounces-51163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 490F1AEEF93
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 09:13:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D7DB1BC5503
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 07:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F50125DB1D;
	Tue,  1 Jul 2025 07:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z7JP4cjm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551771E515
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 07:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751354021; cv=none; b=iJz7a+aJU8vV0+rmELmKR2n19Jfu2SvOltaZqlKlnjQut562fH6YsSxvf151uQqeCxiccxp+q2YRbN5mUVvBXCN3y/D1hE05bQq3sbPHd586cOSw21ON9d8wZr5CPR//HCRorSy/YwAFGfB3OvmyOkazzD7hOpE/CJAo+L2O2Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751354021; c=relaxed/simple;
	bh=fvdNtZFG98bTz38ZaID/Nl35em193wk9jbzh9oNekbQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AKIm5gUXhImWUzXX72A7dG1yQTh7HmT1OdtT6JozLoKF9r2n+X1vAOFL33+HxgbTAmOLwLWWBh9RCNBQ0CK3jmc+5LJAbwy8dA8Vt2nbVgKkxz5n2WKBb/KDqAtlUCKGGnSszIFm+pl3VrBIVqyCOdTZ1SjFrLKyqhZYV+ny9EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z7JP4cjm; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-235e389599fso152505ad.0
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 00:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751354020; x=1751958820; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RxL3VNZ4Zrs6oBZrgQg54Wx4zFWI9GcyhIpiUNXFiPo=;
        b=z7JP4cjmWsD8b7r4FQNUwRWn4gdtGa9oXDyDBY0VviUpE8aZXcfIkxpsxPHd0D1I0Q
         Vr0cG4sgK7NM+kXJTaEpEmgvUTUBtIqZQly+x+Cebr+IlaA8sUaBuQoaaCKKVIXRufec
         zv+54aIXP08WdRCqNtqvcv2nBVfkH6TTNXsrcLjVoHofOcmo4WPnHLxHfM5+jrmT68Cs
         cQiP5XBfMR/n8KEhbnCU4zMLe+F75Fuw8G9opDqqDfYQWyu7e3ehSqRBjhn/lRmfVTsR
         VgQmyv1HTxCEz9Ej00Y6sS5dK9Qgby5d2VCpdFXdfEHhYQJ8P6kMMNCdl7g+eE+AzmqW
         8/jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751354020; x=1751958820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RxL3VNZ4Zrs6oBZrgQg54Wx4zFWI9GcyhIpiUNXFiPo=;
        b=r1xIhTAzbiEEfnkzRweEV4z4aG7SfVQdc3IKFW+BMhtzb56U49asKwEopJ1fCo1cvL
         DEENfZ5MOAuQz6NgmSlNdqXSY3TAQFv57Ao7FKsOX7h5bgXWmUdVAb4oQMW6147l5bgD
         96tsloJy20Loflsk0lKH82LGDA8C/ovCKoR27/pMWeX3qzXYiY0Wu949aYOBi6i1EvzL
         gJ7qnsAONuDL2aVFnB4/cCnNWeu9rKr7pv1mbE8lVLwjpYMPLTc0PXZf6cjwvyd/XnkF
         hv+rsjwo1NK4D2P/BdNktgX+xHM1r9yJ/Bomzhj+Jj3PprVVCUO574WRGrE78kvfNa31
         gIXA==
X-Forwarded-Encrypted: i=1; AJvYcCWhqR/+6gp8F0QXsIc6ju5o3emz0OgNAE4gUiLXLPeZDfNdoSE3Kbe3fjFP31iOAn5zsWI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBkSpuvHm88DJF8woabB9/ijdiNVDzz7oKgtov2oP70pb026Nj
	JGBr5SX89EjR/b54d8Vg9q3TMBuhqi3ASPFps+vZ8wqD1mheVxbDWDvl4KqntDZosEWi8v3T4eu
	ITRJU+JAAJA4azbrCwCTanSbpcEgHexpssoXHwaAh
X-Gm-Gg: ASbGncsaGG5DJM0bw+RQBs6NJ/lMyWNpV+wONMsun0yH8iJP6VUCEL8gyMAxW9e5djg
	q7k02+HsJaKeyRhygWvQAru8EkKMoflCJNb0VcXySWom7d/rStDTK47BS+duS9BrsMyxliicGOk
	Jy0XqqCOVINcAeJ/veBuOy1KNJ0tVa6XqXVpHAYmr8tvf2eNxNCtvHX1vrllSTuTLdl4ovEVXmk
	dPd
X-Google-Smtp-Source: AGHT+IECig08eHKTTvf45dHSJaJUQDbe4/XeGRIpH9pZV9TKF+yYFATBI2QtHbYGZhiRR5ayYC8ekg+hNsS90nakNG8=
X-Received: by 2002:a17:902:d506:b0:234:9f02:e937 with SMTP id
 d9443c01a7336-23c601b0ca0mr1180985ad.25.1751354019225; Tue, 01 Jul 2025
 00:13:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com> <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com> <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com> <CAGtprH-csoPxG0hCexCUg_n4hQpsss83inRUMPRqJSFdBN0yTQ@mail.gmail.com>
 <aGN6GIFxh57ElHPA@yzhao56-desk.sh.intel.com>
In-Reply-To: <aGN6GIFxh57ElHPA@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 1 Jul 2025 00:13:26 -0700
X-Gm-Features: Ac12FXz5n0nRXiv5tX1uPxgTYg1ZNQypYDgTfnT8A352KSP8Co9WwSmcusOKr6w
Message-ID: <CAGtprH_GoFMCMWYgOBtmu_ZBbBJeUXXanjYhYg9ZwDPeDXOYXg@mail.gmail.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "Du, Fan" <fan.du@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2025 at 11:06=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wr=
ote:
>
> On Mon, Jun 30, 2025 at 10:22:26PM -0700, Vishal Annapurve wrote:
> > On Mon, Jun 30, 2025 at 10:04=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com=
> wrote:
> > >
> > > On Tue, Jul 01, 2025 at 05:45:54AM +0800, Edgecombe, Rick P wrote:
> > > > On Mon, 2025-06-30 at 12:25 -0700, Ackerley Tng wrote:
> > > > > > So for this we can do something similar. Have the arch/x86 side=
 of TDX grow
> > > > > > a
> > > > > > new tdx_buggy_shutdown(). Have it do an all-cpu IPI to kick CPU=
s out of
> > > > > > SEAMMODE, wbivnd, and set a "no more seamcalls" bool. Then any =
SEAMCALLs
> > > > > > after
> > > > > > that will return a TDX_BUGGY_SHUTDOWN error, or similar. All TD=
s in the
> > > > > > system
> > > > > > die. Zap/cleanup paths return success in the buggy shutdown cas=
e.
> > > > > >
> > > > >
> > > > > Do you mean that on unmap/split failure:
> > > >
> > > > Maybe Yan can clarify here. I thought the HWpoison scenario was abo=
ut TDX module
> > > My thinking is to set HWPoison to private pages whenever KVM_BUG_ON()=
 was hit in
> > > TDX. i.e., when the page is still mapped in S-EPT but the TD is bugge=
d on and
> > > about to tear down.
> > >
> > > So, it could be due to KVM or TDX module bugs, which retries can't he=
lp.
> > >
> > > > bugs. Not TDX busy errors, demote failures, etc. If there are "norm=
al" failures,
> > > > like the ones that can be fixed with retries, then I think HWPoison=
 is not a
> > > > good option though.
> > > >
> > > > >  there is a way to make 100%
> > > > > sure all memory becomes re-usable by the rest of the host, using
> > > > > tdx_buggy_shutdown(), wbinvd, etc?
> > >
> > > Not sure about this approach. When TDX module is buggy and the page i=
s still
> > > accessible to guest as private pages, even with no-more SEAMCALLs fla=
g, is it
> > > safe enough for guest_memfd/hugetlb to re-assign the page to allow si=
multaneous
> > > access in shared memory with potential private access from TD or TDX =
module?
> >
> > If no more seamcalls are allowed and all cpus are made to exit SEAM
> > mode then how can there be potential private access from TD or TDX
> > module?
> Not sure. As Kirill said "TDX module has creative ways to corrupt it"
> https://lore.kernel.org/all/zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7i=
uk2rt@qaaolzwsy6ki/.

I would assume that would be true only if TDX module logic is allowed
to execute. Otherwise it would be useful to understand these
"creative" ways better.

