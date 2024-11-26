Return-Path: <kvm+bounces-32545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E7B3A9D9EF1
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 22:42:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09C4AB25186
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 21:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A31E1DFDA1;
	Tue, 26 Nov 2024 21:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y7wiKFOA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1598D1DDA24
	for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 21:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732657319; cv=none; b=hw+Evr6gmk4RFOXtZRPOm9z5rARQa12BF/YUN5sk7hXtHzobTXmSEHrdhMrq29vM33Sei4Ov6/csv5Xb1EQ2oNfbPIdLxQxtKOhbfMY+Vqz8zEtsbwUWt60Lf+mo7cPTFtt6K+ZQrFDoY8HXfiUvyePxxeev+LLHJfbM5eOBCZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732657319; c=relaxed/simple;
	bh=9tOBKynM5NyF0v/UtMAEN0JLJrkLzpFaaDYbCRmxycA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LafDgsH2BWfMh25BO5id+Mg5Nha/Eg7UefEMlsp1rXpHEQ4xTpq21Nsyg++SLMWS+1EoDFVvSGE/mUwgcRZAdoPqPeeYvVKJd/GwL2/RJ/d3F7nzj/a1YIVo7HFuFs6XzkMvy0HXNBSmj6Lu743Pbcb7DC+gzJPm59MmisQoaV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y7wiKFOA; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea21082c99so6263329a91.3
        for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 13:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732657317; x=1733262117; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZC0eOZiWtQZomc+AExmm1yUnCB63goeI5SJU+DDCrHA=;
        b=y7wiKFOAYC3sQeg1RYe4W+hypoY3+BGNO+MSSxOyg3aiMTXPIKolk0WU1/30rLkeK4
         3sfuLQbVHhmrpDHHlpRP//hGZwVi3cD7WhT+ezWmJ0pIMzEKLA1vS91j7yjpS/dXgnEc
         p6Iso0WcYiaNIqWnSL17EMim5hN8sZeZkASVxBcwGqYNlYTVgze7kU+naveD4K2ir8Kb
         zG65z9AQ5ym09GdzUneF5FIXZO8n+FFPppaQbI4owXlPxVG5W3AEDrXXnNb4ubVPXXey
         ctQlek7Q03qSwxpJ2BFmWwCE650rSfeg1tDzAEgtOx+3sAma4O2pJh+s0JF3+wwkIcGF
         RDHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732657317; x=1733262117;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZC0eOZiWtQZomc+AExmm1yUnCB63goeI5SJU+DDCrHA=;
        b=fmSiYP/xhb5uTYnQv9mU7/uSW9CALE5bNS+czlXvsJe9935eHwT8rbcVJwz9m7IySa
         Vc079zECc6f8JwMbA47nbBEtnA7LcfteqyrtoVdQLp0EE6s1R3CPIHvO928GDh4lwkMl
         x+s4LfVzbMal0g44qECJ5bfGHd9YJwxdvGf8W0NbC2rMiGB4D5EbT7ncnplFwotllURO
         DtC+5ThJ27KbMjfVLESLVJ/SOV6libSmKwdAyJOrgp4xWVD0YjZv/xZn7peHL9hSzkSu
         RR9n7PRg756vc2r6uG+sH4VL9y57/SlXO+yGKgKsXOAha0Xp3XMiljBtrX7FZ4NIRNLx
         12zw==
X-Forwarded-Encrypted: i=1; AJvYcCUSG9nXA3jeqyQkSTgDfUDBPRJ174qfVJabD31DfZXjpoXwkEWRRIvT1ulHlSAwpMeyzMI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvmIL9HZ3OVBZ6X3FbPJTxGDefNl3J9VCftmC7WzG1YltP3BZP
	KBV+hEIhkaVE2VYxdjA/XeH61ScEoMz7lVkGF3l8ude2mpM6oTVkrp72+Wc84q5u4gDgBdsCFac
	7Zg==
X-Google-Smtp-Source: AGHT+IG1w7Qoqnb3NFJ68bXBPMkvpyOpBhnO+vu1FuLqzaK80uGHGi36Tcxih8m0vrDAF3NUUSVQGFVrYK4=
X-Received: from pjbnt2.prod.google.com ([2002:a17:90b:2482:b0:2eb:7b7e:d9d5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b03:b0:2ea:4c4f:bd20
 with SMTP id 98e67ed59e1d1-2ee097e51f7mr1008956a91.32.1732657317439; Tue, 26
 Nov 2024 13:41:57 -0800 (PST)
Date: Tue, 26 Nov 2024 13:41:55 -0800
In-Reply-To: <8db4d414-b8f0-4ea2-a850-0f168967fb94@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <86d71f0c-6859-477a-88a2-416e46847f2f@linux.intel.com> <Z0SVf8bqGej_-7Sj@google.com>
 <735d3a560046e4a7a9f223dc5688dcf1730280c5.camel@intel.com>
 <Z0T_iPdmtpjrc14q@google.com> <57aab3bf-4bae-4956-a3b7-d42e810556e3@linux.intel.com>
 <d27b4e076c3ad2f5d7d71135f112e6a45e067ae7.camel@intel.com> <8db4d414-b8f0-4ea2-a850-0f168967fb94@linux.intel.com>
Message-ID: <Z0ZAo4lZcIj0rEZb@google.com>
Subject: Re: [PATCH 0/7] KVM: TDX: TD vcpu enter/exit
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Kai Huang <kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, Weijiang Yang <weijiang.yang@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, 
	"nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chao Gao <chao.gao@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, Xin3 Li <xin3.li@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2024, Binbin Wu wrote:
> On 11/26/2024 11:52 AM, Huang, Kai wrote:
> > On Tue, 2024-11-26 at 09:44 +0800, Binbin Wu wrote:
> > >=20
> > > On 11/26/2024 6:51 AM, Sean Christopherson wrote:
> > >=20
> > > [...]
> > > > When an NMI happens in non-root, the NMI is acknowledged by the CPU=
 prior to
> > > > performing VM-Exit.  In regular VMX, NMIs are blocked after such VM=
-Exits.  With
> > > > TDX, that blocking happens for SEAM root, but the SEAMRET back to V=
MX root will
> > > > load interruptibility from the SEAMCALL VMCS, and I don't see any c=
ode in the
> > > > TDX-Module that propagates that blocking to SEAMCALL VMCS.
> > > I see, thanks for the explanation!
> > >=20
> > > > Hmm, actually, this means that TDX has a causality inversion, which=
 may become
> > > > visible with FRED's NMI source reporting.  E.g. NMI X arrives in SE=
AM non-root
> > > > and triggers a VM-Exit.  NMI X+1 becomes pending while SEAM root is=
 active.
> > > > TDX-Module SEAMRETs to VMX root, NMIs are unblocked, and so NMI X+1=
 is delivered
> > > > and handled before NMI X.
> > > This example can also cause an issue without FRED.
> > > 1. NMI X arrives in SEAM non-root and triggers a VM-Exit.
> > > 2. NMI X+1 becomes pending while SEAM root is active.
> > > 3. TDX-Module SEAMRETs to VMX root, NMIs are unblocked.
> > > 4. NMI X+1 is delivered and handled before NMI X.
> > >   =C2=A0=C2=A0 (NMI handler could handle all NMI source events, inclu=
ding the source
> > >   =C2=A0=C2=A0=C2=A0 triggered NMI X)
> > > 5. KVM calls exc_nmi() to handle the VM Exit caused by NMI X
> > > In step 5, because the source event caused NMI X has been handled, an=
d NMI X
> > > will not be detected as a second half of back-to-back NMIs, according=
 to
> > > Linux NMI handler, it will be considered as an unknown NMI.
> > I don't think KVM should call exc_nmi() anymore if NMI is unblocked upo=
n
> > SEAMRET.
>=20
> IIUC, KVM has to, because the NMI triggered the VM-Exit can't trigger the
> NMI handler to be invoked automatically even if NMI is unblocked upon SEA=
MRET.

Yep.  The NMI is consumed by the VM-Exit, for all intents and purposes.  KV=
M must
manually invoke the NMI handler.

Which is how the ordering gets messed up: NMI X+1 arrives before KVM has a =
chance
to manually invoke the handler for NMI X.

