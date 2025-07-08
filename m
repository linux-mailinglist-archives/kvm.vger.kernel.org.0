Return-Path: <kvm+bounces-51797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 490F5AFD503
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 19:16:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B6DC4A5D3D
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 17:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C3A2E6D14;
	Tue,  8 Jul 2025 17:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jL8ULSCI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BE419EED3
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 17:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994986; cv=none; b=saft6Pwu1NfWz9awH4vBjj6b190m/azewgguJY4v8vGZcgfMPxVu8G2Ve570C8fLNmBF816TqXjU8dMrqt+HPZIemf1INNLXt/iDXfy13AR3Db/Ycwj82T3SH8QEhqDt45ntvxwSG+2YcaiZtGncbBRSryDPqqJEa/5CEclU51g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994986; c=relaxed/simple;
	bh=EfXYtz6eCgxEu7KRQ0if/ac+m6kwM9iQSLD1UYKujqQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=To9G6dQgIjGyyqU98RKM8EXWwNIMrqvM/ohKhd9A5cR1k5sTRtmk+aoxhzOlIe1J4f6YEXkVHO0PSi2dja3JEVCCcnTSujyINHQ8yMmTdUyfftzzIcXuAWAhMHr4+qe80+1sSU244Ua3yLlPHFnkC0QysJdS+elRheIn+QE5c2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jL8ULSCI; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-23dd9ae5aacso9535ad.1
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 10:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751994984; x=1752599784; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w/vdXYRsw5z4df1ZBivhz/DTkNGF2DjR6MZbntX/+a4=;
        b=jL8ULSCIDGMONc5vbg05Hdq/VDVxDARi63OK5EUBZZxfT5Ry1uWCH+qtvdXEMhPwjV
         G1VE82uB69LPHr1qpvVrQcAabri42WC7Y2V4/QpNl7368pd+03nERsKfgbLZHBD6wlwg
         nYuXrjBmYgsf8uLx1iSrPnYPBW5YxkC40n7E8+sjwcH1LwxEL//Z/cSiD98/meeQuwLT
         nGlZo7eyT7UZ6ZPBWToBH93yOCoZSJaFcs1ZUwrxTnJ7XKIEHMQpJ4v+yNGkIJWJd2zI
         3vnMUscChGgl/feVKUyS88UVqoWH2DcqddV7Ox8X38+d1THn2HMJMk71qS0I25IZ5V/o
         gnfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751994984; x=1752599784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w/vdXYRsw5z4df1ZBivhz/DTkNGF2DjR6MZbntX/+a4=;
        b=sZFwUSHXEev8BpNu49kH0BSWi9n/7f8fLkyuv/IrWZ+/9IxbjbROPIwSMTgnXcWDl6
         tKI00lnecL5YFC4//KYaaHqkRXS59+qlQgZuboHNNuF9745TEaU9x36gwiOIifvfPnWl
         VDOgAulZkK5ppFQxmvePvj7iC/2cTPVPwLx+ky0CdzgtJJLYgKO9Ue+ctrva/YCkF7yQ
         NqICzVJJlVOfVLS+sso0FTbxzZhUhihpFrl/tWMjC350qDRsuEW5DMKXjX1eBAXJh888
         UTzic9kM05aCUt0XthZy0yeFP6T9blZ648ubhwUv7YikW/UTSBGKmF47OVuRnT+/kMD6
         3LYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWArm510FaaVClOdOmuFBR2ffYMm1RkvNNfz9e3X5brm4Fg8ntKYmj1GMkrDVjaDz+/7lU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhZ1YKaKo5LLbK+pF8MPj41rnF0UPxJ0p9EjiWC95GYhiQeSZ0
	pQivGK6jstCAc/VMugXdZXXy9iHO2E03K/2Tft8PpStlx/OiEMBrfDFrp4XuUyKwLicu0FHzfbq
	nMv62K6FP9JOteH/cRdG2l6TiCjCcwsO/FlAtHRAj
X-Gm-Gg: ASbGncteZic7z8MOX6cAX2/auBm1SAcLV87gWL7iTze+UgulDw9+EukU9QVj/MOdasS
	1cbBLsNDPcwy7w4nBD+KDpV4aVxc2dgZ0Np6k/T9nnWyt2UGtfdV/DcO3lOnLaQVcLI8elHVRQc
	o6bjDMdHYaiQcYHUTH7XvS1X1PB8jCVS2D3X/veweQhI3KuA2/TIjQVI6V/uhoYFWMKrXSNQQkG
	Q==
X-Google-Smtp-Source: AGHT+IGkv22D/tXO6gyejl8aGvoee4XRPTMlaDRFSvv3esIwSJ6T6kZ4z2wkxktBHm+oP1e/SApNkNTiB8aBohhkips=
X-Received: by 2002:a17:902:dacd:b0:236:7079:fb10 with SMTP id
 d9443c01a7336-23dda158b72mr87435ad.3.1751994982637; Tue, 08 Jul 2025 10:16:22
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aFPGlAGEPzxlxM5g@yzhao56-desk.sh.intel.com> <d15bfdc8-e309-4041-b4c7-e8c3cdf78b26@intel.com>
 <CAGtprH-Kzn2kOGZ4JuNtUT53Hugw64M-_XMmhz_gCiDS6BAFtQ@mail.gmail.com>
 <aGIBGR8tLNYtbeWC@yzhao56-desk.sh.intel.com> <CAGtprH-83EOz8rrUjE+O8m7nUDjt=THyXx=kfft1xQry65mtQg@mail.gmail.com>
 <aGNw4ZJwlClvqezR@yzhao56-desk.sh.intel.com> <CAGtprH-Je5OL-djtsZ9nLbruuOqAJb0RCPAnPipC1CXr2XeTzQ@mail.gmail.com>
 <aGxXWvZCfhNaWISY@google.com> <CAGtprH_57HN4Psxr5MzAZ6k+mLEON2jVzrLH4Tk+Ws29JJuL4Q@mail.gmail.com>
 <006899ccedf93f45082390460620753090c01914.camel@intel.com>
 <aG0pNijVpl0czqXu@google.com> <a0129a912e21c5f3219b382f2f51571ab2709460.camel@intel.com>
 <CAGtprH8ozWpFLa2TSRLci-SgXRfJxcW7BsJSYOxa4Lgud+76qQ@mail.gmail.com> <eeb8f4b8308b5160f913294c4373290a64e736b8.camel@intel.com>
In-Reply-To: <eeb8f4b8308b5160f913294c4373290a64e736b8.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 8 Jul 2025 10:16:08 -0700
X-Gm-Features: Ac12FXwUqBw2naxHJ41VuiRvkgNlNHoN7o2IpurfkihYeV5Xw345ab2C4M7MZQQ
Message-ID: <CAGtprH8cg1HwuYG0mrkTbpnZfHoKJDd63CAQGEScCDA-9Qbsqw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/51] 1G page support for guest_memfd
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "pvorel@suse.cz" <pvorel@suse.cz>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "Miao, Jun" <jun.miao@intel.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pdurrant@amazon.co.uk" <pdurrant@amazon.co.uk>, 
	"steven.price@arm.com" <steven.price@arm.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"x86@kernel.org" <x86@kernel.org>, "amoorthy@google.com" <amoorthy@google.com>, 
	"tabba@google.com" <tabba@google.com>, "quic_svaddagi@quicinc.com" <quic_svaddagi@quicinc.com>, 
	"jack@suse.cz" <jack@suse.cz>, "vkuznets@redhat.com" <vkuznets@redhat.com>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "keirf@google.com" <keirf@google.com>, 
	"mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>, 
	"anthony.yznaga@oracle.com" <anthony.yznaga@oracle.com>, "Wang, Wei W" <wei.w.wang@intel.com>, 
	"rppt@kernel.org" <rppt@kernel.org>, 
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, 
	"quic_mnalajal@quicinc.com" <quic_mnalajal@quicinc.com>, "aik@amd.com" <aik@amd.com>, 
	"usama.arif@bytedance.com" <usama.arif@bytedance.com>, "fvdl@google.com" <fvdl@google.com>, 
	"quic_cvanscha@quicinc.com" <quic_cvanscha@quicinc.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "anup@brainfault.org" <anup@brainfault.org>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mic@digikod.net" <mic@digikod.net>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "Du, Fan" <fan.du@intel.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "muchun.song@linux.dev" <muchun.song@linux.dev>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, 
	"rientjes@google.com" <rientjes@google.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, 
	"Aktas, Erdem" <erdemaktas@google.com>, "david@redhat.com" <david@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"willy@infradead.org" <willy@infradead.org>, "hughd@google.com" <hughd@google.com>, 
	"Xu, Haibo1" <haibo1.xu@intel.com>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"maz@kernel.org" <maz@kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "will@kernel.org" <will@kernel.org>, 
	"steven.sistare@oracle.com" <steven.sistare@oracle.com>, "jarkko@kernel.org" <jarkko@kernel.org>, 
	"quic_pheragu@quicinc.com" <quic_pheragu@quicinc.com>, "nsaenz@amazon.es" <nsaenz@amazon.es>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "Huang, Kai" <kai.huang@intel.com>, 
	"shuah@kernel.org" <shuah@kernel.org>, "bfoster@redhat.com" <bfoster@redhat.com>, 
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "Peng, Chao P" <chao.p.peng@intel.com>, 
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, "Graf, Alexander" <graf@amazon.com>, 
	"nikunj@amd.com" <nikunj@amd.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"jgowans@amazon.com" <jgowans@amazon.com>, "Xu, Yilun" <yilun.xu@intel.com>, 
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"quic_tsoni@quicinc.com" <quic_tsoni@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "Weiny, Ira" <ira.weiny@intel.com>, 
	"richard.weiyang@gmail.com" <richard.weiyang@gmail.com>, 
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>, "qperret@google.com" <qperret@google.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, "james.morse@arm.com" <james.morse@arm.com>, 
	"brauner@kernel.org" <brauner@kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "pgonda@google.com" <pgonda@google.com>, 
	"quic_pderrin@quicinc.com" <quic_pderrin@quicinc.com>, "hch@infradead.org" <hch@infradead.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "seanjc@google.com" <seanjc@google.com>, 
	"roypat@amazon.co.uk" <roypat@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 8, 2025 at 8:31=E2=80=AFAM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Tue, 2025-07-08 at 08:07 -0700, Vishal Annapurve wrote:
> > On Tue, Jul 8, 2025 at 7:52=E2=80=AFAM Edgecombe, Rick P
> > <rick.p.edgecombe@intel.com> wrote:
> > >
> > > On Tue, 2025-07-08 at 07:20 -0700, Sean Christopherson wrote:
> > > > > For TDX if we don't zero on conversion from private->shared we wi=
ll be
> > > > > dependent
> > > > > on behavior of the CPU when reading memory with keyid 0, which wa=
s
> > > > > previously
> > > > > encrypted and has some protection bits set. I don't *think* the b=
ehavior is
> > > > > architectural. So it might be prudent to either make it so, or ze=
ro it in
> > > > > the
> > > > > kernel in order to not make non-architectual behavior into usersp=
ace ABI.
> > > >
> > > > Ya, by "vendor specific", I was also lumping in cases where the ker=
nel would
> > > > need to zero memory in order to not end up with effectively undefin=
ed
> > > > behavior.
> > >
> > > Yea, more of an answer to Vishal's question about if CC VMs need zero=
ing. And
> > > the answer is sort of yes, even though TDX doesn't require it. But we=
 actually
> > > don't want to zero memory when reclaiming memory. So TDX KVM code nee=
ds to know
> > > that the operation is a to-shared conversion and not another type of =
private
> > > zap. Like a callback from gmem, or maybe more simply a kernel interna=
l flag to
> > > set in gmem such that it knows it should zero it.
> >
> > If the answer is that "always zero on private to shared conversions"
> > for all CC VMs, then does the scheme outlined in [1] make sense for
> > handling the private -> shared conversions? For pKVM, there can be a
> > VM type check to avoid the zeroing during conversions and instead just
> > zero on allocations. This allows delaying zeroing until the fault time
> > for CC VMs and can be done in guest_memfd centrally. We will need more
> > inputs from the SEV side for this discussion.
> >
> > [1] https://lore.kernel.org/lkml/CAGtprH-83EOz8rrUjE+O8m7nUDjt=3DTHyXx=
=3Dkfft1xQry65mtQg@mail.gmail.com/
>
> It's nice that we don't double zero (since TDX module will do it too) for
> private allocation/mapping. Seems ok to me.
>
> >
> > >
> > > >
> > > > > Up the thread Vishal says we need to support operations that use =
in-place
> > > > > conversion (overloaded term now I think, btw). Why exactly is pKV=
M using
> > > > > private/shared conversion for this private data provisioning?
> > > >
> > > > Because it's literally converting memory from shared to private?  A=
nd IICU,
> > > > it's
> > > > not a one-time provisioning, e.g. memory can go:
> > > >
> > > >   shared =3D> fill =3D> private =3D> consume =3D> shared =3D> fill =
=3D> private =3D> consume
> > > >
> > > > > Instead of a special provisioning operation like the others? (Xia=
oyao's
> > > > > suggestion)
> > > >
> > > > Are you referring to this suggestion?
> > >
> > > Yea, in general to make it a specific operation preserving operation.
> > >
> > > >
> > > >  : And maybe a new flag for KVM_GMEM_CONVERT_PRIVATE for user space=
 to
> > > >  : explicitly request that the page range is converted to private a=
nd the
> > > >  : content needs to be retained. So that TDX can identify which cas=
e needs
> > > >  : to call in-place TDH.PAGE.ADD.
> > > >
> > > > If so, I agree with that idea, e.g. add a PRESERVE flag or whatever=
.  That way
> > > > userspace has explicit control over what happens to the data during
> > > > conversion,
> > > > and KVM can reject unsupported conversions, e.g. PRESERVE is only a=
llowed for
> > > > shared =3D> private and only for select VM types.
> > >
> > > Ok, we should POC how it works with TDX.
> >
> > I don't think we need a flag to preserve memory as I mentioned in [2]. =
IIUC,
> > 1) Conversions are always content-preserving for pKVM.
> > 2) Shared to private conversions are always content-preserving for all
> > VMs as far as guest_memfd is concerned.
> > 3) Private to shared conversions are not content-preserving for CC VMs
> > as far as guest_memfd is concerned, subject to more discussions.
> >
> > [2] https://lore.kernel.org/lkml/CAGtprH-Kzn2kOGZ4JuNtUT53Hugw64M-_XMmh=
z_gCiDS6BAFtQ@mail.gmail.com/
>
> Right, I read that. I still don't see why pKVM needs to do normal private=
/shared
> conversion for data provisioning. Vs a dedicated operation/flag to make i=
t a
> special case.

It's dictated by pKVM usecases, memory contents need to be preserved
for every conversion not just for initial payload population.

>
> I'm trying to suggest there could be a benefit to making all gmem VM type=
s
> behave the same. If conversions are always content preserving for pKVM, w=
hy
> can't userspace  always use the operation that says preserve content? Vs
> changing the behavior of the common operations?

I don't see a benefit of userspace passing a flag that's kind of
default for the VM type (assuming pKVM will use a special VM type).
Common operations in guest_memfd will need to either check for the
userspace passed flag or the VM type, so no major change in
guest_memfd implementation for either mechanism.

>
> So for all VM types, the user ABI would be:
> private->shared          - Always zero's page
> shared->private          - Always destructive
> shared->private (w/flag) - Always preserves data or return error if not p=
ossible
>
>
> Do you see a problem?
>

