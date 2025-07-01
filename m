Return-Path: <kvm+bounces-51152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 77D85AEED89
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 07:22:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A055A189F930
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 05:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E46C211499;
	Tue,  1 Jul 2025 05:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e3s5Xq0r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8E41F37C5
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 05:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751347362; cv=none; b=oqPA6RRbY5Ct83bccgaffMdaf+Sg73uswC9sQCD3a5xTT4N9n84rjfLvhfhm4n7Aucs+hPr4ACR1eclwFy6UxtYcwa4dIzVvzsc91NQG5SGJO9f3yzA7FO2jkqr1YZ+WqGmbfycf5N+8cHdF23EovyNevAWFP0wMxFupXUfPTus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751347362; c=relaxed/simple;
	bh=VYqlj+Y3w6GrxsL/42ioSVNT3PVbnq2E31Nz6I6CgQg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o5HazrevTRuqYGVXQ0020Xa/OqrK73h8DYNS84mDjBRklYBYmpjlZnZ4V3ugm2v0o6dXETbGkBFjWp2ir5EOCm+Bv6ACd+1UGer6AOs1qEj0pOYuYBn5qFxZVUwA/uMi/YwFqhZwmw/KSsVAhsMUnSophGng8AeLs/HjsigSLVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e3s5Xq0r; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-235e389599fso134905ad.0
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 22:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751347360; x=1751952160; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ug5SHg66aGnCTuPO5TyvNH1aNiq24HsB7hp/dDRBT7k=;
        b=e3s5Xq0rbvkD+CxKqUc8VB0dID14p47RfNwXUF1BTUYJsMVPmHZGqRRg2DRswmHwVQ
         Tq7wfLik4ZUErGf12agWIH1PWeAFIDEbM9umNBcp87Nk2AzUWHb0EIUir4Rr6aeTdVnq
         3ULjW20N2q692pRNeFxXb7jVZafz98+6utaa464XhUg0gCeYjDHYYcHW2znD3ezoR1A8
         ugwebOJTNq1MsHxIqX+BkOzl3evIXZfO3+cr+xOUliT0LvQhx+ulHmCx7CFNNODslEdT
         oycdqcRcKgcWc4su9HSjdTiBlhcycrICT0WXovHx4gYE7F/4DHyxIKtOhovBj5DJ9/1c
         qLWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751347360; x=1751952160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ug5SHg66aGnCTuPO5TyvNH1aNiq24HsB7hp/dDRBT7k=;
        b=ASOHAsnUubFveS8Dv3wCvlqb/i6Hf1L0pBxA7Pd7JOoEhKU4DKAPCB8aI5S5CmJ6hb
         FX5qH08oLt2x5Z5IuR5SATRvz/xeITijt7vF8ucluhiOnNY57IFogCJGNyuqaZc7ZliL
         XFM3zbW1M6EvRokFCPL/o4Z+DL4jg/vSvgsk8rB3gBOaWwf3TKj7Sty7AFDE0vBaa2wk
         aystWrv8+OtQtyTQeacMUI/PVr8c6LYeLzsgMjWt6OK2gBOkP/vc7mrg1q7AlXNWfv4U
         36axtfo5aHqHOJ5LNmJVqlqXnJ5vhDrba8oe5nktArZdmJZ12R5HjkbnQk37sqOxBDMp
         zcUg==
X-Forwarded-Encrypted: i=1; AJvYcCXaAa+oZvgXdetCaZ3UYUt2DNID6L04RlWfEmVMvVIb6h9JRuUunqcqP4pi9LuvZmtY1D8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfHPP5Fbvlhv34K2rITdyO8KcnoYshROBZl3zBBuCJEK6Dliqj
	hSIYSdGvl4wVhV9g0G38UepcbVIvy6iNWDdmhhJn5rfl6dXkLLsLI0Gf8WEV09B103ZyVWMaGvA
	qpE5UoNe7oB9HBYGc9Zsqsee/+8+cques1D795p68
X-Gm-Gg: ASbGnctxozvEBkRQ43pkc6lOreTPcKlW3Jg5aeohHq3z2peGfHNlHKh/m3ErsU0Mzc6
	xja1x9brmlT+1vXOIdDUe45VNbEl0Pm+gKSvB+bcAoVtIQqk7GIKnDjHUt8jHs0A/uvFB1LOGz9
	8hRo8dT5ucNhBKJ1rPp+nu1WUoVT+DdA1Y3aJ4yyfmlpX784f/aZk6hDZjxf93E5RS1xlL8X0tJ
	4dv
X-Google-Smtp-Source: AGHT+IGQ1LJkpXjCB3M6JsBjwHbg7F16Ktug72Dgl4yuUaJr657M2qrWBr6Ub2+QfnlBJIK3KOceKatIxx+yhG4pXjI=
X-Received: by 2002:a17:902:ecc1:b0:215:7152:36e4 with SMTP id
 d9443c01a7336-23c601d19bcmr1027895ad.27.1751347359848; Mon, 30 Jun 2025
 22:22:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com> <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com> <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com> <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com>
In-Reply-To: <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 30 Jun 2025 22:22:26 -0700
X-Gm-Features: Ac12FXyA-w-dfqDos41dPoFYviJkwnTyUL8ABtay1z3xRmiT2sgcPlBoMON2FnU
Message-ID: <CAGtprH-csoPxG0hCexCUg_n4hQpsss83inRUMPRqJSFdBN0yTQ@mail.gmail.com>
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

On Mon, Jun 30, 2025 at 10:04=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wr=
ote:
>
> On Tue, Jul 01, 2025 at 05:45:54AM +0800, Edgecombe, Rick P wrote:
> > On Mon, 2025-06-30 at 12:25 -0700, Ackerley Tng wrote:
> > > > So for this we can do something similar. Have the arch/x86 side of =
TDX grow
> > > > a
> > > > new tdx_buggy_shutdown(). Have it do an all-cpu IPI to kick CPUs ou=
t of
> > > > SEAMMODE, wbivnd, and set a "no more seamcalls" bool. Then any SEAM=
CALLs
> > > > after
> > > > that will return a TDX_BUGGY_SHUTDOWN error, or similar. All TDs in=
 the
> > > > system
> > > > die. Zap/cleanup paths return success in the buggy shutdown case.
> > > >
> > >
> > > Do you mean that on unmap/split failure:
> >
> > Maybe Yan can clarify here. I thought the HWpoison scenario was about T=
DX module
> My thinking is to set HWPoison to private pages whenever KVM_BUG_ON() was=
 hit in
> TDX. i.e., when the page is still mapped in S-EPT but the TD is bugged on=
 and
> about to tear down.
>
> So, it could be due to KVM or TDX module bugs, which retries can't help.
>
> > bugs. Not TDX busy errors, demote failures, etc. If there are "normal" =
failures,
> > like the ones that can be fixed with retries, then I think HWPoison is =
not a
> > good option though.
> >
> > >  there is a way to make 100%
> > > sure all memory becomes re-usable by the rest of the host, using
> > > tdx_buggy_shutdown(), wbinvd, etc?
>
> Not sure about this approach. When TDX module is buggy and the page is st=
ill
> accessible to guest as private pages, even with no-more SEAMCALLs flag, i=
s it
> safe enough for guest_memfd/hugetlb to re-assign the page to allow simult=
aneous
> access in shared memory with potential private access from TD or TDX modu=
le?

If no more seamcalls are allowed and all cpus are made to exit SEAM
mode then how can there be potential private access from TD or TDX
module?

>
> > I think so. If we think the error conditions are rare enough that the c=
ost of
> > killing all TDs is acceptable, then we should do a proper POC and give =
it some
> > scrutiny.
> >
> > >
> > > If yes, then I'm onboard with this, and if we are 100% sure all memor=
y
> > > becomes re-usable by the host after all the extensive cleanup, then w=
e
> > > don't need to HWpoison anything.
> >
> > For eventual upstream acceptance, we need to stop and think every time =
TDX
> > requires special handling in generic code. This is why I wanted to clar=
ify if
> > you guys think the scenario could be in any way considered a generic on=
e.
> > (IOMMU, etc).

