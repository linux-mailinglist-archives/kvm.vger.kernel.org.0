Return-Path: <kvm+bounces-32457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AD819D8904
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 16:19:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D98BD1616C0
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 15:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B199B1B3945;
	Mon, 25 Nov 2024 15:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fsIYcbgF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8F21ADFEA
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 15:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732547970; cv=none; b=tRTqzu5cSqgOMJ0UufXnTJlt/XiCUi2SiUcB+N65LlkeutJpLvJqQxaJa5uzWSK85fTWNcUFEAap3PMu1yRri1B4XgHQuDNhCox9F/sYTpo8eNLWuuRj66k7BrOxdq6SulI2P+a4lKxNrso+2aZ9IOkxdKHQ6tPmG3MhHK+L8sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732547970; c=relaxed/simple;
	bh=eS+F4NvX3yguAUTjqUBlqDobDnrwsNaFBrNfdlRhQxY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cgtWjkZZhoNdiYSiVWScwdjzDH2rsKSeXpTB/cItQrIL3vUKmOWUcBs/VcikbOdUNoV5xGm4Ksa3qeyajXORkYE7xvO+ou/0oBj1s6LVAbwQDAyhjXvvAcEjbcoUAOsX5c1jP1V5fPdlOyTw7B8b9m4UIgDQAwrGTiMO60e2tck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fsIYcbgF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea41a5bfe7so4507552a91.2
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 07:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732547969; x=1733152769; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=smY0pu296n7od/oN2lDFD5BnMm9swJNyWDSoa6GGUSY=;
        b=fsIYcbgFOqLsmxBARxIan+lx3YvvaPg7fnVdSyV/Xulqoqj4nY7s14u95H2WXQyF52
         CCRSIu2dvXYwAv4XDWrukfZ6nEaVqO1mbl67S2pVFfz7Sc8xKbS4uKtUcWEwWtWygL8d
         vXxkkfl//j1V86zYZFcZ327scivKdu6rO3p6OVZgMCYAqoKdk5Jtao1WiW/9Aa6ZPLo7
         XBHDkN5rb8b+me2wjCso51UbgiX3CMV12ir0GFXSo6o2rWG9guFH6TAZ3DqhWIWZL70x
         B/RwQHhOn2jK5wmYzO4lsyjItWaS+YIkEcujej12lAbmeracn2rCfAu+XeH5/VtaoDTx
         XqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732547969; x=1733152769;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=smY0pu296n7od/oN2lDFD5BnMm9swJNyWDSoa6GGUSY=;
        b=kMTIl4Ul3SWxOgpCdOCelpTKJTUc+qDjdeh132EfxoaguC7MKTh2/QT5P597Q+Cnfi
         qqvGayR+FgOKroxCIYkbii+zFUq+GPBEIcVWgdpcnmZv5P3P0ttdt9agpBMoRLZoQZtR
         xS3fWuqEiKe7nK+BPOS9Cn1VeQVcNGLMIZesrQa0ssSH0vMhAmWATjP+RSDjKrJdF6au
         S1QSAz56HFDfYk7N1LhlmDHyFSmG8FKMa91Q1cWVuo1ZSL6xKTzYyieOydre1SJnhN2Q
         yTXuNW0AbsBsfyk5SSTMT8Bp06CX4ZuGs3wi+Qy4FT3ksI0LLh9udzpFf84OTsF+DPoZ
         5utA==
X-Forwarded-Encrypted: i=1; AJvYcCUl4HRrKxnNvNPR3tj9JgStbbX0osMXFbwXrwaSk8p39qRi3RVvkAHAx22zA1+1KqZztvY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgzsL0s2S3Y2kVRLfGrvx571HRw0b2f/9aRRqTa4217+qmXjK/
	9nl320eCoFUvTzVfa3bdqub40cUCK0ezTGOHszJQdgnAkiPlZksiUEbXzyR4bDoIsZsL/Ck/0wU
	VBA==
X-Google-Smtp-Source: AGHT+IFuFDQHohRURdGRM189Pt9qL9Zaf73obsIvszIqilIxE8UnhMz921eOxrXQXTzRVL84A/vW1JH77EE=
X-Received: from pjuw5.prod.google.com ([2002:a17:90a:d605:b0:2ea:a9d9:c9d1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:17cd:b0:2ea:6f96:64fd
 with SMTP id 98e67ed59e1d1-2eb0e890c17mr14474024a91.34.1732547968816; Mon, 25
 Nov 2024 07:19:28 -0800 (PST)
Date: Mon, 25 Nov 2024 07:19:27 -0800
In-Reply-To: <86d71f0c-6859-477a-88a2-416e46847f2f@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121201448.36170-1-adrian.hunter@intel.com> <86d71f0c-6859-477a-88a2-416e46847f2f@linux.intel.com>
Message-ID: <Z0SVf8bqGej_-7Sj@google.com>
Subject: Re: [PATCH 0/7] KVM: TDX: TD vcpu enter/exit
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com, 
	dave.hansen@linux.intel.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	nik.borisov@suse.com, linux-kernel@vger.kernel.org, x86@kernel.org, 
	yan.y.zhao@intel.com, chao.gao@intel.com, weijiang.yang@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2024, Binbin Wu wrote:
> On 11/22/2024 4:14 AM, Adrian Hunter wrote:
> [...]
> >    - tdx_vcpu_enter_exit() calls guest_state_enter_irqoff()
> >      and guest_state_exit_irqoff() which comments say should be
> >      called from non-instrumentable code but noinst was removed
> >      at Sean's suggestion:
> >    	https://lore.kernel.org/all/Zg8tJspL9uBmMZFO@google.com/
> >      noinstr is also needed to retain NMI-blocking by avoiding
> >      instrumented code that leads to an IRET which unblocks NMIs.
> >      A later patch set will deal with NMI VM-exits.
> >=20
> In https://lore.kernel.org/all/Zg8tJspL9uBmMZFO@google.com, Sean mentione=
d:
> "The reason the VM-Enter flows for VMX and SVM need to be noinstr is they=
 do things
> like load the guest's CR2, and handle NMI VM-Exits with NMIs blocks.=C2=
=A0 None of
> that applies to TDX.=C2=A0 Either that, or there are some massive bugs lu=
rking due to
> missing code."
>=20
> I don't understand why handle NMI VM-Exits with NMIs blocks doesn't apply=
 to
> TDX.=C2=A0 IIUIC, similar to VMX, TDX also needs to handle the NMI VM-exi=
t in the
> noinstr section to avoid the unblock of NMIs due to instrumentation-induc=
ed
> fault.

With TDX, SEAMCALL is mechnically a VM-Exit.  KVM is the "guest" running in=
 VMX
root mode, and the TDX-Module is the "host", running in SEAM root mode.

And for TDH.VP.ENTER, if a hardware NMI arrives with the TDX guest is activ=
e,
the initial NMI VM-Exit, which consumes the NMI and blocks further NMIs, go=
es
from SEAM non-root to SEAM root.  The SEAMRET from SEAM root to VMX root (K=
VM)
is effectively a VM-Enter, and does NOT block NMIs in VMX root (at least, A=
FAIK).

So trying to handle the NMI "exit" in a noinstr section is pointless becaus=
e NMIs
are never blocked.

TDX is also different because KVM isn't responsible for context switching g=
uest
state.  Specifically, CR2 is managed by the TDX Module, and so there is no =
window
where KVM runs with guest CR2, and thus there is no risk of clobbering gues=
t CR2
with a host value, e.g. due to take a #PF due instrumentation triggering so=
mething.

All that said, I did forget that code that runs between guest_state_enter_i=
rqoff()
and guest_state_exit_irqoff() can't be instrumeneted.  And at least as of p=
atch 2
in this series, the simplest way to make that happen is to tag tdx_vcpu_ent=
er_exit()
as noinstr.  Just please make sure nothing else is added in the noinstr sec=
tion
unless it absolutely needs to be there.

