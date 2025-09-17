Return-Path: <kvm+bounces-57955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 866C1B822D4
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 00:40:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA08D7B8ABA
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 22:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4808130FC3C;
	Wed, 17 Sep 2025 22:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xScshUvX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F255330EF67
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 22:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758148822; cv=none; b=Ji6ouMG/8un/H2MHdsHh5+FOvC+B2E58D1s2snfxq30RGsQpFvA0GhynYlNjOZ4UKUoQBQHVpSsYvBVJsP9Ztv53abZQQ06yxWq/X8Y2E3qwJtpipBtra8O1DrBBoOjfWYk5KIlggri0lb3fy57Lcb2ADaUt3uwiNEsQNOjoqsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758148822; c=relaxed/simple;
	bh=WSfFooN5Bw7kAHcBSRwXJG4k3j5I4pDgZn1B6oXDRa0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MKAj5hMcleF89/jfPwkGcG03ATP0Q6b0yN6Mn7LUhgWKrT2hQT4sCvbsICvmEgfR/7cSO70VicA9sLpSz9t365UxkYENZcG+y6TmAbapXwQoYL1gNLVrA2IYzB4+rboEoWAcc08clN/UT5N6LPu6wfbcdcq7694/+sT5ovV6U2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xScshUvX; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77283b2b5f7so494932b3a.0
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 15:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758148820; x=1758753620; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m2gITbjAhZLVDTe91+pv60FMHVz/PyRihO/dG6TrQ1g=;
        b=xScshUvXozX1uxER7qZsO8p7Ucy0JMRPftF2Qc4iW+jUzt2v+z7shzzTO01oxCZEkq
         051hR+Gj4XdNfQu3CBsi2wZ/EH6w9tdtqjod+Kc1XRG0O89bnsuI7loyoUxiUnZGJjMe
         RCcV2iaR48KpLhO0wVK0FVGOFqVC0u6SHuSflHNj9mda6XvYExKSVhsTN67EiEq1Idi5
         0xmZ5a+QInviQ7LhmASPABrbGQyWowkK6Dj7GE/ISc3Z7Thrvt6udxsJEK7A9GUwwmqc
         SYYllHDx/tEr61hZr1eAqBMi0W5M25jIPqfsNYUNmR3C0R2D5r1NtYnjirXfnjWeOKcx
         cHyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758148820; x=1758753620;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m2gITbjAhZLVDTe91+pv60FMHVz/PyRihO/dG6TrQ1g=;
        b=pI/bv5oGLOcgvgs/OzF7yS7dbI+4eENj4I8WgBkSrK0Qejb45bI/5LdTSXcRH4oWrQ
         ycZ7TJUwkkao8MPkFlw8d/bCwXLzmlC5ZwJDu2PAXgXwY3VpiLRNxwzX8laXmiAhR+kg
         rUrv95Q0CdxULiiwDNe13FoUvZc8m0JaUMsE1BK9D6J2MihoGeg1SNIR8D4CCwC2tny2
         PMcYVt4Lv9waMLBdO3KkgOvu0k0UqQt3rgQt8MLVolOcOhWt5BMm+qtMFKHKCf/LkOA2
         jeko4stvrU0pwnVLdqEE6wmWFS/3dODGpSeyLFIFroL6T75+Osl0DhxIjEWFrgMEsGFF
         LSCA==
X-Forwarded-Encrypted: i=1; AJvYcCWCkPUNv3Jvct3aG80VjJqoJG6lWfMV6VfUb38ZK+NSHSCp2KHejSF7Df7YOBUfF4psGh0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxlh/7QXuMACG6MB5Uvul9UaAMMVb9Hni4vpFC9z9A93pFf2wZ/
	4B/eFOMNGRQD6UN26pr2juwIQ0tMb7nWzyLO+VLoE7pFQy1Ip6ZqiTgyCNWDO9/W4X/FGokWowQ
	cDlf+Mg==
X-Google-Smtp-Source: AGHT+IFI0s+9qm/ZBuqtuCHVVai9MRluhJYduJgd1o773c0GWF5zKPkcHTokW+JlTa7DRlVZN5DukGxMcIA=
X-Received: from pjzz6.prod.google.com ([2002:a17:90b:58e6:b0:327:e172:e96])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e082:b0:262:8bce:33bd
 with SMTP id adf61e73a8af0-27aa12ef6ffmr5224302637.28.1758148820303; Wed, 17
 Sep 2025 15:40:20 -0700 (PDT)
Date: Wed, 17 Sep 2025 15:40:18 -0700
In-Reply-To: <f533d3a4-183e-4b3d-9b3a-95defb1876e0@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909182828.1542362-1-xin@zytor.com> <aMLakCwFW1YEWFG4@google.com>
 <0387b08a-a8b0-4632-abfc-6b8189ded6b4@linux.intel.com> <aMmkZlWl4TiS2qm8@google.com>
 <f533d3a4-183e-4b3d-9b3a-95defb1876e0@zytor.com>
Message-ID: <aMs40gVA4DAHex6A@google.com>
Subject: Re: [RFC PATCH v1 0/5] x86/boot, KVM: Move VMXON/VMXOFF handling from
 KVM to CPU lifecycle
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-pm@vger.kernel.org, pbonzini@redhat.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	pavel@kernel.org, brgerst@gmail.com, david.kaplan@amd.com, 
	peterz@infradead.org, andrew.cooper3@citrix.com, kprateek.nayak@amd.com, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, dan.j.williams@intel.com, 
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025, Xin Li wrote:
> On 9/16/2025 10:54 AM, Sean Christopherson wrote:
> > On Thu, Sep 11, 2025, Arjan van de Ven wrote:
> > > Hi,
> > > > I also want to keep the code as a module, both to avoid doing VMXON=
 unconditionally,
> > >=20
> > > can you expand on what the problem is with having VMXON unconditional=
ly enabled?
> >=20
> > Unlike say EFER.SVME, VMXON fundamentally changes CPU behavior.  E.g. b=
locks INIT,
> > activates VMCS caches (which aren't cleared by VMXOFF on pre-SPR CPUs, =
and AFAIK
> > Intel hasn't even publicly committed to that behavior for SPR+), restri=
cts allowed
> > CR0 and CR4 values, raises questions about ucode patch updates, trigger=
s unique
> > flows in SMI/RSM, prevents Intel PT from tracing on certain CPUs, and p=
robably a
> > few other things I'm forgetting.
>=20
> Regarding Intel PT, if VMXON/VMXOFF are moved to CPU startup/shutdown, as
> Intel PT is initialized during arch_initcall() stage, entering and leavin=
g
> VMX operation no longer happen while Intel PT is _active_, thus
> intel_pt_handle_vmx() no longer needs to "handles" VMX state transitions.

The issue isn't handling transitions, it's that some CPUs don't support Int=
el PT
post-VMXON:

  If bit 14 is read as 1, Intel=C2=AE Processor Trace (Intel PT) can be use=
d in VMX
  operation. If the processor supports Intel PT but does not allow it to be=
 used
  in VMX operation, execution of VMXON clears IA32_RTIT_CTL.TraceEn (see
  =E2=80=9CVMXON=E2=80=94Enter VMX Operation=E2=80=9D in Chapter 32); any a=
ttempt to write IA32_RTIT_CTL
  while in VMX operation (including VMX root operation) causes a general-pr=
otection
  exception.

And again, unconditionally doing VMXON is a minor objection in all of this.

