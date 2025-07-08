Return-Path: <kvm+bounces-51801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFF2EAFD5EB
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 20:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38E5B585195
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 18:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A8E52E5403;
	Tue,  8 Jul 2025 18:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MpxduJu3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465B821B9C6
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 18:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751997808; cv=none; b=aLXUMbrjM74E28JC4l+uMRsPk6O14lFdz/jCRXMpUPsb86j2Hq3ZJV6v++mwlbgkU1VcsBswR3dhgs7GpKP2bdbwQ6R+RApndbq2msNOh2OpcAnpedo2TJ9Lq1lLzxGT1Ad/VZHnkfz6iZCz84v+7U4U6KaqAIwR5wt4//QOjhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751997808; c=relaxed/simple;
	bh=s4RZ8nQJieFScy8n8qpYU1+xTprPbswQodWfgBTVO6c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dX31WcjOvmnSKAty1Kn6kVxFp7jCqKdNF5BAYErrKw5XEZJT674sI6e5pngFQkY9QJeuUVeuAZ0ECFxTHWsCcx8f43QCERg/VPfee5EJVN8FDXDRB9xi4u5ivYgiGU1aguupVv3OXAiAdBSsDYsduSzTzlx7Hiv85sy8HrAPysE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MpxduJu3; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7491814d6f2so5062150b3a.3
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 11:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751997806; x=1752602606; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x10LXm7PeGMN7MOtWLfXfbWmNGz9S10d7VYiV0yVtCU=;
        b=MpxduJu3u+fM/VC2SJDo/bINjCHvo/qYcsNIIghMojw2PvcG85Zt6mm9wXxC8Y4lVe
         goWMsSHQdl5c9Eq+Vj4z5aIgubDgompaJPCS2+biVcsJC+wmIq0Cg8/WiDLaZ3K1Vdao
         2hOlKDcQOHhBTS1DEdcTHbvUgGQFAwCKVVpdsf1nIWCEQ0vEVBOWDYAVI1jagLbnHdd6
         DNXuxYGVRTFGUErbsUcVv+uNdGdCc2wMvZBOsx0d2Ri1pnvaCPdO4wqi928S/KUJu6fb
         ckqOSIXQbgYaS8hgDpCSTG0YJEvLaWIalHjcJzKFqWCRFyiyH0sl2aI6EM9OVYOG625L
         2Nbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751997806; x=1752602606;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x10LXm7PeGMN7MOtWLfXfbWmNGz9S10d7VYiV0yVtCU=;
        b=ENWVFFTen1PZ8QHB4cln9w3m2QhlUzaIx8bVnwKUALqE030zHBEmMw0biv10oPghnm
         8DlOZNzQWFxX0ShJXWAKQhd/JH1PWGmIeMvOWqgxvBUVymQcW7bdiNjPzQibiXiFBmPN
         d6E/flDRfYZ8a4QTLTaIZchM2LZL8K0vEsqUeNOD2C2jGx9ceM3cpRHZIEk9Y6UT2p9f
         L86PstcHFMbJZ8XhRJRtBzLEWZ4XLgrD99DaX9sXHh6h1xKzD3A4pQb67/AaKTqFXaQe
         taE4wg9tSJ2MYUYzXuKtAX9UmHlhous0R81/Zf6EC2FG/yB3vA5GSZDIAwZpiwzChruy
         DZmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCC9BFCcTfuunrB+FNoZ+dZJhaoOrV/eztHv6n3PTm5yrjy2msF6n2MqiccDlHF8nOmfo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFijtp+x/dCr58xiXnoFBaa+ZeXZO1XuwRY8lQ+4VZ9KFu1O/R
	oxi0fPaB/tUEzuSO/xVIUbED3+HTOM2ZxGKKKnPTyNZ3M2FDdLDxcOlwJzYezzQM8rfwxgg3YGw
	WMTObOg==
X-Google-Smtp-Source: AGHT+IFe4SBpWGzwWywsUZpN2vnR08oPkVmXJnGtvFDNSO2RDy7ZqC2nSucMyoDDGRjNc9DXvg6wKac3oiE=
X-Received: from pfbna28.prod.google.com ([2002:a05:6a00:3e1c:b0:748:f98a:d97b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:549d:b0:1f5:717b:46dc
 with SMTP id adf61e73a8af0-22c7f545df3mr622282637.27.1751997806375; Tue, 08
 Jul 2025 11:03:26 -0700 (PDT)
Date: Tue, 8 Jul 2025 11:03:24 -0700
In-Reply-To: <b1348c229c67e2bad24e273ec9a7fc29771e18c5.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAGtprH-Je5OL-djtsZ9nLbruuOqAJb0RCPAnPipC1CXr2XeTzQ@mail.gmail.com>
 <aGxXWvZCfhNaWISY@google.com> <CAGtprH_57HN4Psxr5MzAZ6k+mLEON2jVzrLH4Tk+Ws29JJuL4Q@mail.gmail.com>
 <006899ccedf93f45082390460620753090c01914.camel@intel.com>
 <aG0pNijVpl0czqXu@google.com> <a0129a912e21c5f3219b382f2f51571ab2709460.camel@intel.com>
 <CAGtprH8ozWpFLa2TSRLci-SgXRfJxcW7BsJSYOxa4Lgud+76qQ@mail.gmail.com>
 <eeb8f4b8308b5160f913294c4373290a64e736b8.camel@intel.com>
 <CAGtprH8cg1HwuYG0mrkTbpnZfHoKJDd63CAQGEScCDA-9Qbsqw@mail.gmail.com> <b1348c229c67e2bad24e273ec9a7fc29771e18c5.camel@intel.com>
Message-ID: <aG1dbD2Xnpi_Cqf_@google.com>
Subject: Re: [RFC PATCH v2 00/51] 1G page support for guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Vishal Annapurve <vannapurve@google.com>, "pvorel@suse.cz" <pvorel@suse.cz>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	Jun Miao <jun.miao@intel.com>, "nsaenz@amazon.es" <nsaenz@amazon.es>, 
	Kirill Shutemov <kirill.shutemov@intel.com>, "pdurrant@amazon.co.uk" <pdurrant@amazon.co.uk>, 
	"peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>, 
	"tabba@google.com" <tabba@google.com>, "amoorthy@google.com" <amoorthy@google.com>, 
	"quic_svaddagi@quicinc.com" <quic_svaddagi@quicinc.com>, "jack@suse.cz" <jack@suse.cz>, 
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, 
	"keirf@google.com" <keirf@google.com>, 
	"mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>, 
	"anthony.yznaga@oracle.com" <anthony.yznaga@oracle.com>, Wei W Wang <wei.w.wang@intel.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>, "willy@infradead.org" <willy@infradead.org>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, Dave Hansen <dave.hansen@intel.com>, 
	"aik@amd.com" <aik@amd.com>, "usama.arif@bytedance.com" <usama.arif@bytedance.com>, 
	"quic_mnalajal@quicinc.com" <quic_mnalajal@quicinc.com>, "fvdl@google.com" <fvdl@google.com>, 
	"rppt@kernel.org" <rppt@kernel.org>, "quic_cvanscha@quicinc.com" <quic_cvanscha@quicinc.com>, 
	"maz@kernel.org" <maz@kernel.org>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"anup@brainfault.org" <anup@brainfault.org>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mic@digikod.net" <mic@digikod.net>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Fan Du <fan.du@intel.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "steven.price@arm.com" <steven.price@arm.com>, 
	"muchun.song@linux.dev" <muchun.song@linux.dev>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Zhiquan1 Li <zhiquan1.li@intel.com>, 
	"rientjes@google.com" <rientjes@google.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, 
	Erdem Aktas <erdemaktas@google.com>, "david@redhat.com" <david@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"hughd@google.com" <hughd@google.com>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, Haibo1 Xu <haibo1.xu@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"steven.sistare@oracle.com" <steven.sistare@oracle.com>, 
	"quic_pheragu@quicinc.com" <quic_pheragu@quicinc.com>, "jarkko@kernel.org" <jarkko@kernel.org>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, Kai Huang <kai.huang@intel.com>, 
	"shuah@kernel.org" <shuah@kernel.org>, "bfoster@redhat.com" <bfoster@redhat.com>, 
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, Chao P Peng <chao.p.peng@intel.com>, 
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, Alexander Graf <graf@amazon.com>, 
	"nikunj@amd.com" <nikunj@amd.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"jgowans@amazon.com" <jgowans@amazon.com>, Yilun Xu <yilun.xu@intel.com>, 
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"quic_tsoni@quicinc.com" <quic_tsoni@quicinc.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, Ira Weiny <ira.weiny@intel.com>, 
	"richard.weiyang@gmail.com" <richard.weiyang@gmail.com>, 
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>, "qperret@google.com" <qperret@google.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, "james.morse@arm.com" <james.morse@arm.com>, 
	"brauner@kernel.org" <brauner@kernel.org>, "roypat@amazon.co.uk" <roypat@amazon.co.uk>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "pgonda@google.com" <pgonda@google.com>, 
	"quic_pderrin@quicinc.com" <quic_pderrin@quicinc.com>, "hch@infradead.org" <hch@infradead.org>, 
	"will@kernel.org" <will@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2025, Rick P Edgecombe wrote:
> On Tue, 2025-07-08 at 10:16 -0700, Vishal Annapurve wrote:
> > > Right, I read that. I still don't see why pKVM needs to do normal
> > > private/shared
> > > conversion for data provisioning. Vs a dedicated operation/flag to ma=
ke it a
> > > special case.
> >=20
> > It's dictated by pKVM usecases, memory contents need to be preserved
> > for every conversion not just for initial payload population.
>=20
> We are weighing pros/cons between:
>  - Unifying this uABI across all gmemfd VM types
>  - Userspace for one VM type passing a flag for it's special non-shared u=
se case
>=20
> I don't see how passing a flag or not is dictated by pKVM use case.

Yep.  Baking the behavior of a single usecase into the kernel's ABI is rare=
ly a
good idea.  Just because pKVM's current usecases always wants contents to b=
e
preserved doesn't mean that pKVM will never change.

As a general rule, KVM should push policy to userspace whenever possible.

> P.S. This doesn't really impact TDX I think. Except that TDX development =
needs
> to work in the code without bumping anything. So just wishing to work in =
code
> with less conditionals.
>=20
> >=20
> > >=20
> > > I'm trying to suggest there could be a benefit to making all gmem VM =
types
> > > behave the same. If conversions are always content preserving for pKV=
M, why
> > > can't userspace=C2=A0 always use the operation that says preserve con=
tent? Vs
> > > changing the behavior of the common operations?
> >=20
> > I don't see a benefit of userspace passing a flag that's kind of
> > default for the VM type (assuming pKVM will use a special VM type).
>=20
> The benefit is that we don't need to have special VM default behavior for
> gmemfd. Think about if some day (very hypothetical and made up) we want t=
o add a
> mode for TDX that adds new private data to a running guest (with special =
accept
> on the guest side or something). Then we might want to add a flag to over=
ride
> the default destructive behavior. Then maybe pKVM wants to add a "don't
> preserve" operation and it adds a second flag to not destroy. Now gmemfd =
has
> lots of VM specific flags. The point of this example is to show how unifi=
ed uABI
> can he helpful.

Yep again. Pivoting on the VM type would be completely inflexible.  If pKVM=
 gains
a usecase that wants to zero memory on conversions, we're hosed.  If SNP or=
 TDX
gains the ability to preserve data on conversions, we're hosed.

The VM type may restrict what is possible, but (a) that should be abstracte=
d,
e.g. by defining the allowed flags during guest_memfd creation, and (b) the
capabilities of the guest_memfd instance need to be communicated to userspa=
ce.
=20
> > Common operations in guest_memfd will need to either check for the
> > userspace passed flag or the VM type, so no major change in
> > guest_memfd implementation for either mechanism.
>=20
> While we discuss ABI, we should allow ourselves to think ahead. So, is a =
gmemfd
> fd tied to a VM?

Yes.

> I think there is interest in de-coupling it?

No?  Even if we get to a point where multiple distinct VMs can bind to a si=
ngle
guest_memfd, e.g. for inter-VM shared memory, there will still need to be a=
 sole
owner of the memory.  AFAICT, fully decoupling guest_memfd from a VM would =
add
non-trivial complexity for zero practical benefit.

> Is the VM type sticky?
>=20
> It seems the more they are separate, the better it will be to not have VM=
-aware
> behavior living in gmem.

Ya.  A guest_memfd instance may have capabilities/features that are restric=
ted
and/or defined based on the properties of the owning VM, but we should do o=
ur
best to make guest_memfd itself blissly unaware of the VM type.

