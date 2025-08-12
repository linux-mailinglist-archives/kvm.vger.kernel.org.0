Return-Path: <kvm+bounces-54543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AF532B234EE
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 20:45:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 999AB4E49D6
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 18:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 899852FDC30;
	Tue, 12 Aug 2025 18:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oYcIaB0z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442942C21D4
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 18:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024310; cv=none; b=dmBA1F7NzyKqqiwnQckbNK4wO8HCWbTATpsIWsdsgMMDiTMcCBuDPBVTli0PD2KBjrtRz52Cu+KcvTEAlI9MxpKMfC/UhSBfZFeIGmaP1dX32GTNNpILdek9zmS5s6LxLmcun4IC2hA8A/tG7TxU0oqhCm2lh/bTDIM3PZmURqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024310; c=relaxed/simple;
	bh=k8eJflyHaGW1cyd3IMxkAyfMV4XfphhmHbTGJPhMO2A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fznPo0Lbf+HymCg8HmsrH1nbuy7ZK/E7qYlSz6FxpjgNswnym3Ph+JKe87bqNlAg7tlhfnaerIJgFAOuQitw9cyIN+bendCEN/yGK8ID1WtcHdvpdyFpO22MgjVVUSMSzwsKngf5I0BtlgUm+zApHihfneclhwtBEm41OM0Z9Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oYcIaB0z; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-242d3be5bdfso24075ad.1
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 11:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755024308; x=1755629108; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3aZrrKJF+13GgKsgM/uEfcdmhk0fl5dHjrt4Kw7aLp4=;
        b=oYcIaB0zfrssJA+kaSObnS5BQA26q5OHHplhLioIfNjyzDFQz7/11ysU3oa9I+/BlM
         VF91CWWCoxMd4H5tUuP5kSGhao+8MLHEPr07Nh79pq3FU7WVwyAsjI5R1MpCmeoP6Sst
         w0IMjlLYBoUGqcy1Jd2RKj1gOrpc/LhEKVfZjPpJBUwEaoYKKpZXTVICaBV5Jcy8IRdC
         QE4Mxy1PP6wIGGWc5etoE9I1sAgi9v7qOXnvZpAP/1zBVCOqFR5NstOt8PMnp/tpl47t
         cmsP7LsQmpFEPjMMQpmEaS8eUJIlwCK3wiZbNZjv/TcAx2o0OwrPcz4T0wH8JkMmFerv
         RceQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755024308; x=1755629108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3aZrrKJF+13GgKsgM/uEfcdmhk0fl5dHjrt4Kw7aLp4=;
        b=GqZB//KgT70E+grAI9xnW7fFhZdLiSCFNxf3qihIEmgUAF2oPhCaVQvcfiNven4NTk
         PgOWRJV0rndOkPWtng9aYHHKkaRfzV5mWMblEvr5fKI74mLTQoSxfk5onEt+qaSnyKEA
         F7qLLvbst0G9s0P9S/ef2pvitVxu/DV0csSbubEK1a/UogYqvWx9nNqeXhoG3vM6ylWm
         HmiUXGVS3H7M5z2WCZlh2lP0AQ5a0i0tSSkF70VgGQhcuoqQWCNDe2bPH6QN4773uYNx
         u2W1iUksPG+sic+r5RiV3+yjRs/JicRd3O7+q97Koc7sx0zu9LbegXS25l3Ulh8W9Pwt
         KzIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXR2RRLtSGf4jiC0bp6+IIklf05Aex49vVx5t67XtClf6IUWRwEclpdWrybavSfGFJUuCs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz41Duvf3Z2qZhe7RBAifE3xL9uJh+QAoo6BDEiMOhL0v6RNwF3
	PjNwLcqxi7rwJxypvCcjVTyLkesmJw+6J0JyV5epi0knserWzDA/Qd4vRmwUbBrLRJxV3A8awQZ
	6XSCKpFHjMnkRZhxNynnwhucN9yIGz/dDzMoHSBLb
X-Gm-Gg: ASbGnctsnHaDLl/ErWKhJBZk/0iom8R6/gS4GHLnW1HXcg/+CDBNQ8vryPg7JcMKzWS
	PwizJbet4AG6PnAFsBIYAxFdYSiXQWXrOvbycvmf0iOoEAkyhizgeP1/LqjvpNYpTCQ9LWMAkYM
	K9UJofA2vsyC9fjAos2G0u+fX67noItQ1b2hBj+VH8FUDiZHKqiYd1kRclzJRdvtKejR1jiosoB
	OhTbFF5L+FCK2gkThE81VDrkRRQW7A9aPyyUv69
X-Google-Smtp-Source: AGHT+IHVug2DiOO6Cvt5RmH+7vn9igq9WsESN/7t7V6c6ibS0iTghQrPWcgQ6kZA+3YKuzfUdLeF0Upsie8W0FD4eRM=
X-Received: by 2002:a17:903:2281:b0:23d:eb0f:f49 with SMTP id
 d9443c01a7336-2430d22e961mr364945ad.14.1755024308013; Tue, 12 Aug 2025
 11:45:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
 <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
 <aJqgosNUjrCfH_WN@google.com> <CAGtprH9TX4s6jQTq0YbiohXs9jyHGOFvQTZD9ph8nELhxb3tgA@mail.gmail.com>
 <itbtox4nck665paycb5kpu3k54bfzxavtvgrxwj26xlhqfarsu@tjlm2ddtuzp3>
 <57755acf553c79d0b337736eb4d6295e61be722f.camel@intel.com> <aJtolM_59M5xVxcY@google.com>
In-Reply-To: <aJtolM_59M5xVxcY@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 12 Aug 2025 11:44:56 -0700
X-Gm-Features: Ac12FXy4GUu5ZIRJXl7eGstfP5q8QDTUxveWfrkMVz1y6ccW3owwq_zd_PQQxe0
Message-ID: <CAGtprH_0YWHF5HWzs3Yx+Z7Na2OsCxqG7mJPLREVfoNv9qE6mg@mail.gmail.com>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	Chao Gao <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	Kai Huang <kai.huang@intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2025 at 9:15=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Aug 12, 2025, Rick P Edgecombe wrote:
> > On Tue, 2025-08-12 at 09:04 +0100, kas@kernel.org wrote:
> > > > > E.g. for things like TDCS pages and to some extent non-leaf S-EPT
> > > > > pages, on-demand PAMT management seems reasonable.  But for PAMTs=
 that
> > > > > are used to track guest-assigned memory, which is the vaaast majo=
rity
> > > > > of PAMT memory, why not hook guest_memfd?
> > > >
> > > > This seems fine for 4K page backing. But when TDX VMs have huge pag=
e
> > > > backing, the vast majority of private memory memory wouldn't need P=
AMT
> > > > allocation for 4K granularity.
> > > >
> > > > IIUC guest_memfd allocation happening at 2M granularity doesn't
> > > > necessarily translate to 2M mapping in guest EPT entries. If the DP=
AMT
> > > > support is to be properly utilized for huge page backings, there is=
 a
> > > > value in not attaching PAMT allocation with guest_memfd allocation.
>
> I don't disagree, but the host needs to plan for the worst, especially si=
nce the
> guest can effectively dictate the max page size of S-EPT mappings.  AFAIK=
, there
> are no plans to support memory overcommit for TDX guests, so unless a dep=
loyment
> wants to roll the dice and hope TDX guests will use hugepages for N% of t=
heir
> memory, the host will want to reserve 0.4% of guest memory for PAMTs to e=
nsure
> it doesn't unintentionally DoS the guest with an OOM condition.

Reasonable guest VMs (e.g. Linux) will generally map things mostly at
hugepage granularity, I don't think there is a reason here to be more
conservative and just increase the cost for the well behaved guests.
That being said, The scenario of an unreasonable guest could be
covered in future by modifying how PAMT allocation is
accounted/charged.

Guests are generally free to use the lazy pvalidate/accept features so
the host can't guarantee the needed PAMT memory to be always there
anyways.

