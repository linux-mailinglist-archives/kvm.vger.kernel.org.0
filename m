Return-Path: <kvm+bounces-32475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4220F9D8EBA
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 23:52:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1902286B56
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 22:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D5BB1BBBD4;
	Mon, 25 Nov 2024 22:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PvPW+LUn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457831B85C2
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 22:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732575117; cv=none; b=NOE0u3c9mEnfCsnkr/RBU18o+9/KwSICnJGzILETWhZSrkoQ4QhpWgurSA7xh8UBz8almcwdCsJFb/yA6vApyqsrPU06v7g2rVOrbkaZLuH8Rm7uxr0HNvC9XeDoubHTVc3+8UtT4QgS4/1mJrJDfSKDJ6Ct38hbBxaM/8/VZBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732575117; c=relaxed/simple;
	bh=+344/y+fqLzIptJF3tZsdyu4JrVxxXoe1f/Gvryhw/U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JMMo9EHTzTnivZZG/fuAIAE/aikmhfd0Y+nRSGxKTMaU5sLJTp71Kx5Ox1dk/l8YSBPDr0SlJIHCc+kqezIbctG/ewyTsSIvVfC55HCkf0h56YVst9+fQR+k0pPWGGF1eiUcwGy0GATDZHTK1NVz0sq9JdA8SVXDOH5bU2UFAQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PvPW+LUn; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea3c9178f6so4892176a91.1
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 14:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732575113; x=1733179913; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j+K9zzd9fyT3ev3udb3SozcJ58KmXrRPHl4/ugcSkmM=;
        b=PvPW+LUnk6VOz2oX0gpAd7vksTMjDS0JIscdFUI/ABBMDE7gBvhGWbQjaAfvxDCJjT
         AphrwIEENfdqVo7QDOytS688oUz1AcAzePSSGs3FNVKe0CsLozVbYVpk1bzHLEk18vUB
         hsl558bjFqqKOS2mkGjiYwDJmmHrG+1XrPuz5syu2kb30ECGJyNftWfW5hfGwq/S3adD
         4ZwvA7Vu8+cI4Ndy9015aADGltZf8yZs4d6Asc3Zd3SFaZkQvSHC7Bppmk0JPB2TjvMq
         xe7nTgHLwF7p1fyAQUQClQrbhfh1QceoFTy5lHs/cxE4cBcoJSzHtQ/EIYNJb85sMZ/D
         aUtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732575113; x=1733179913;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=j+K9zzd9fyT3ev3udb3SozcJ58KmXrRPHl4/ugcSkmM=;
        b=nl0IQJaUfGPBJfZW4EvQKWF3kaynuemmW0Wv3+5XQ4lQtzP4xsax3lTqOgOxg107OS
         FyZC8x2zv/bZUJYm1Hl3bxuBHzDhtf9Z/Azo+x9I1oCsqMk2yc0BKPub4w8nhDW58WWT
         TEDY77o5Lc3o6y69E0GgeokyEDmZdoSE9AeIS/PLSSSLYQdkhIHxYY496kSvnqNLQcHt
         mA4QdrIASz1A499RjVdFBqLP3/WpJ7o0nyn2gaf1zVFh4bcTrRnH7etljlR9h/wnLBgG
         lU/80cIpZAOOWSpoND7SqkkaZxW+8N7mvZurjgXrpIWC2wx8wRtEbSYWOnTXPFz93h5/
         78tQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDPiSOcXFPGSkm4DkPtE1dcsKNjRpgHlBS1KuUTjs3H4wmfgM1VnLeiUhVxTAWdvznQKg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6QIVUmw28w2sf6SqNQTcFLE7FUveGuv7ptN3I0aNxhuAIBURO
	00EOKuhB7IizhHOw1lg5UT5xV/nDDXWYxjdubXVtNNUNCL1I72GATKfG8Z9rAr/5f3BziUmtxjh
	xeA==
X-Google-Smtp-Source: AGHT+IGDn5rzsTqyT8Eu5D17HvR4yd+YGvsgthjfrw3EM/0fR9oVBtUfrK9/cVdHEmQS3AeJOEBBn8Ywepg=
X-Received: from pjbhl7.prod.google.com ([2002:a17:90b:1347:b0:2ea:7d73:294e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c4b:b0:2ea:59e3:2d2e
 with SMTP id 98e67ed59e1d1-2eb0e2330c2mr18331895a91.10.1732575113537; Mon, 25
 Nov 2024 14:51:53 -0800 (PST)
Date: Mon, 25 Nov 2024 14:51:52 -0800
In-Reply-To: <735d3a560046e4a7a9f223dc5688dcf1730280c5.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <86d71f0c-6859-477a-88a2-416e46847f2f@linux.intel.com> <Z0SVf8bqGej_-7Sj@google.com>
 <735d3a560046e4a7a9f223dc5688dcf1730280c5.camel@intel.com>
Message-ID: <Z0T_iPdmtpjrc14q@google.com>
Subject: Re: [PATCH 0/7] KVM: TDX: TD vcpu enter/exit
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Reinette Chatre <reinette.chatre@intel.com>, 
	Weijiang Yang <weijiang.yang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, Chao Gao <chao.gao@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2024, Kai Huang wrote:
> On Mon, 2024-11-25 at 07:19 -0800, Sean Christopherson wrote:
> > On Mon, Nov 25, 2024, Binbin Wu wrote:
> > > On 11/22/2024 4:14 AM, Adrian Hunter wrote:
> > > [...]
> > > >    - tdx_vcpu_enter_exit() calls guest_state_enter_irqoff()
> > > >      and guest_state_exit_irqoff() which comments say should be
> > > >      called from non-instrumentable code but noinst was removed
> > > >      at Sean's suggestion:
> > > >    	https://lore.kernel.org/all/Zg8tJspL9uBmMZFO@google.com/
> > > >      noinstr is also needed to retain NMI-blocking by avoiding
> > > >      instrumented code that leads to an IRET which unblocks NMIs.
> > > >      A later patch set will deal with NMI VM-exits.
> > > >=20
> > > In https://lore.kernel.org/all/Zg8tJspL9uBmMZFO@google.com, Sean ment=
ioned:
> > > "The reason the VM-Enter flows for VMX and SVM need to be noinstr is =
they do things
> > > like load the guest's CR2, and handle NMI VM-Exits with NMIs blocks.=
=C2=A0 None of
> > > that applies to TDX.=C2=A0 Either that, or there are some massive bug=
s lurking due to
> > > missing code."
> > >=20
> > > I don't understand why handle NMI VM-Exits with NMIs blocks doesn't a=
pply to
> > > TDX.=C2=A0 IIUIC, similar to VMX, TDX also needs to handle the NMI VM=
-exit in the
> > > noinstr section to avoid the unblock of NMIs due to instrumentation-i=
nduced
> > > fault.
> >=20
> > With TDX, SEAMCALL is mechnically a VM-Exit.  KVM is the "guest" runnin=
g in VMX
> > root mode, and the TDX-Module is the "host", running in SEAM root mode.
> >=20
> > And for TDH.VP.ENTER, if a hardware NMI arrives with the TDX guest is a=
ctive,
> > the initial NMI VM-Exit, which consumes the NMI and blocks further NMIs=
, goes
> > from SEAM non-root to SEAM root.  The SEAMRET from SEAM root to VMX roo=
t (KVM)
> > is effectively a VM-Enter, and does NOT block NMIs in VMX root (at leas=
t, AFAIK).
> >=20
> > So trying to handle the NMI "exit" in a noinstr section is pointless be=
cause NMIs
> > are never blocked.
>=20
> I thought NMI remains being blocked after SEAMRET?

No, because NMIs weren't blocked at SEAMCALL.

> The TDX CPU architecture extension spec says:
>=20
> "
> On transition to SEAM VMX root operation, the processor can inhibit NMI a=
nd SMI.
> While inhibited, if these events occur, then they are tailored to stay pe=
nding
> and be delivered when the inhibit state is removed. NMI and external inte=
rrupts
> can be uninhibited in SEAM VMX-root operation. In SEAM VMX-root operation=
,
> MSR_INTR_PENDING can be read to help determine status of any pending even=
ts.
>=20
> On transition to SEAM VMX non-root operation using a VM entry, NMI and IN=
TR
> inhibit states are, by design, updated based on the configuration of the =
TD VMCS
> used to perform the VM entry.
>=20
> ...
>=20
> On transition to legacy VMX root operation using SEAMRET, the NMI and SMI
> inhibit state can be restored to the inhibit state at the time of the pre=
vious
> SEAMCALL and any pending NMI/SMI would be delivered if not inhibited.
> "
>=20
> Here NMI is inhibited in SEAM VMX root, but is never inhibited in VMX roo=
t. =C2=A0

Yep.

> And the last paragraph does say "any pending NMI would be delivered if no=
t
> inhibited". =C2=A0

That's referring to the scenario where an NMI becomes pending while the CPU=
 is in
SEAM, i.e. has NMIs blocked.

> But I thought this applies to the case when "NMI happens in SEAM VMX root=
", but
> not "NMI happens in SEAM VMX non-root"?  I thought the NMI is already
> "delivered" when CPU is in "SEAM VMX non-root", but I guess I was wrong h=
ere..

When an NMI happens in non-root, the NMI is acknowledged by the CPU prior t=
o
performing VM-Exit.  In regular VMX, NMIs are blocked after such VM-Exits. =
 With
TDX, that blocking happens for SEAM root, but the SEAMRET back to VMX root =
will
load interruptibility from the SEAMCALL VMCS, and I don't see any code in t=
he
TDX-Module that propagates that blocking to SEAMCALL VMCS.

Hmm, actually, this means that TDX has a causality inversion, which may bec=
ome
visible with FRED's NMI source reporting.  E.g. NMI X arrives in SEAM non-r=
oot
and triggers a VM-Exit.  NMI X+1 becomes pending while SEAM root is active.
TDX-Module SEAMRETs to VMX root, NMIs are unblocked, and so NMI X+1 is deli=
vered
and handled before NMI X.

So the TDX-Module needs something like this:

diff --git a/src/td_transitions/td_exit.c b/src/td_transitions/td_exit.c
index eecfb2e..b5c17c3 100644
--- a/src/td_transitions/td_exit.c
+++ b/src/td_transitions/td_exit.c
@@ -527,6 +527,11 @@ void td_vmexit_to_vmm(uint8_t vcpu_state, uint8_t last=
_td_exit, uint64_t scrub_m
         load_xmms_by_mask(tdvps_ptr, xmm_select);
     }
=20
+    if (<is NMI VM-Exit =3D> SEAMRET)
+    {
+        set_guest_inter_blocking_by_nmi();
+    }
+
     // 7.   Run the common SEAMRET routine.
     tdx_vmm_post_dispatching();


and then KVM should indeed handle NMI exits prior to leaving the noinstr se=
ction.
=20
> > TDX is also different because KVM isn't responsible for context switchi=
ng guest
> > state.  Specifically, CR2 is managed by the TDX Module, and so there is=
 no window
> > where KVM runs with guest CR2, and thus there is no risk of clobbering =
guest CR2
> > with a host value, e.g. due to take a #PF due instrumentation triggerin=
g something.
> >=20
> > All that said, I did forget that code that runs between guest_state_ent=
er_irqoff()
> > and guest_state_exit_irqoff() can't be instrumeneted.  And at least as =
of patch 2
> > in this series, the simplest way to make that happen is to tag tdx_vcpu=
_enter_exit()
> > as noinstr.  Just please make sure nothing else is added in the noinstr=
 section
> > unless it absolutely needs to be there.
>=20
> If NMI is not a concern, is below also an option?

No, because instrumentation needs to be prohibited for the entire time betw=
een
guest_state_enter_irqoff() and guest_state_exit_irqoff().

> 	guest_state_enter_irqoff();
>=20
> 	instructmentation_begin();
> 	tdh_vp_enter();
> 	instructmentation_end();
>=20
> 	guest_state_exit_irqoff();
>=20

