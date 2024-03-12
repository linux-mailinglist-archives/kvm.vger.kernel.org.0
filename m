Return-Path: <kvm+bounces-11681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2A1587996B
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 17:54:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 561BD283DEC
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 16:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B65C137C3A;
	Tue, 12 Mar 2024 16:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eLPif1o8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AA6137C21
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 16:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710262483; cv=none; b=laWczACUs8Z2DTVoMI8M+/3Znt++QsHEnoSo4orWhesnZMVEIVY/5g8oyrOzMDcpl1bn8khT48piLn2DYr/7+eUcan4nmxxCzMM7W6zMNiwMTDbXTfx60H6CdTBxUjsTIvWyJs1ww5AkHiar64B7Ri2NFxIcQ4D8n49C1MdH1BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710262483; c=relaxed/simple;
	bh=hnU+YA4RXIF/GOUheYFoJG/SR6F5vuvGtRER+vjK0XY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FaAOjfkxQE6tozA3sTX4ump/DJfUooJMI9ocJbcfHO6bKGUh/UiquA8pMY9Zvq9oC/GG7fZdBRZJWrDltUtnmjDdQTxB43XufnXFvIIljOzhn7vMYLKz1Wzoq6+e8nfqPUM/0iD9a6GqX/CzQBUGS4kWnNNTvxWJ9NU3pdN7OpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eLPif1o8; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dced704f17cso107911276.1
        for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 09:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710262481; x=1710867281; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w8rE3E0ODiy2LbskMgMROHXlKbp7hEny95QgkRDNzlk=;
        b=eLPif1o89/ieDKokraQalDvDXR5zTiAEIle+2U2mHbJEwUcHui/RqOrlMp4ZBIrhO+
         aw1SZFsgX60qz3cT7zilpuIQeov0jHUCSOP7mYD3XHF7XgGdbeQYWT4Y1fhHQFHSBsyE
         zi4Ds2vnhMIb1u45f6ZZG0p5Gc7/lHwU+IZYMu/90Aut/WX/MiVn62mlxT9j46WcOJgl
         95a6JWk9fE9zyS0JhxdjAMJcK9nMceLqQviTxPoU1nr6sYjOt4WljbnsVrcEvDwRbiFG
         Zhq3TVHqW3vlqoADma64fGnuv08MbK4w5wdzk0+SSztlx5BHLeYkm1aagW806f3EscIo
         EAuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710262481; x=1710867281;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w8rE3E0ODiy2LbskMgMROHXlKbp7hEny95QgkRDNzlk=;
        b=e657g6PZZilfgU0N6/gZVvA53akRhqDnKJyUz6rGCKrMJaLt434zBC5cDUQFOwvW2N
         ftPmU0sunbqP3kncj1GQJ0oPg/UkG8mdTAMn8Lll1F1XMzIrFmZkulcR2OoIOjuOUSMR
         D/izUrS+Hjc8H1ZdlPxyUfV3xfBkHXWSVY2KaBTjDDZ26k0NuxYegGyS4o2pEDnyhKDu
         e6rnVNV31PW/uUqfxp3csm2ukK3vTwEny6gVD+W+dU0c36zUjbrYJQVv6hZKUxHySTyO
         kJ5CmNe8JGD0ejVctLa5z0eElDrfWeaVNyiYXmOzIHP0jylsjt1z75UDzYLg04TfSqj+
         X3jw==
X-Forwarded-Encrypted: i=1; AJvYcCXil4Wv2YbzW52bM68QLRwkxCGw0YUESq35jkiTQo3oxPhol8fZYfAHOfxu8Eg50fS1Nr8EopKiuw91FqAdVpNgSMJt
X-Gm-Message-State: AOJu0Yw7hSEj1HrFEyNid9HY99QgsLWTyoYcgPcu7jIFqOK3TI1fsevn
	E7p90DKLXMUkZ27MSR/t0QeOwkLcN6P0JWX+jA17UlK3/zVf34yL03HQJqPRVZxW/cL3MIPpubQ
	tfg==
X-Google-Smtp-Source: AGHT+IGodaN9dDZ/TTSG1t0ZTtMJX9t1+LcKUjdsqUJRIzS/j6OP4DICS7asJ2d2Az98J8pObywBAmiKL/8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1104:b0:dc2:5456:d9ac with SMTP id
 o4-20020a056902110400b00dc25456d9acmr274ybu.5.1710262480871; Tue, 12 Mar 2024
 09:54:40 -0700 (PDT)
Date: Tue, 12 Mar 2024 09:54:39 -0700
In-Reply-To: <6d0f2392-bc93-445d-9169-65221fb55329@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240227232100.478238-1-pbonzini@redhat.com> <20240227232100.478238-8-pbonzini@redhat.com>
 <6d0f2392-bc93-445d-9169-65221fb55329@intel.com>
Message-ID: <ZfCIz8JIziuvl8Xp@google.com>
Subject: Re: [PATCH 07/21] KVM: VMX: Introduce test mode related to EPT
 violation VE
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	michael.roth@amd.com, isaku.yamahata@intel.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 12, 2024, Kai Huang wrote:
> On 28/02/2024 12:20 pm, Paolo Bonzini wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >=20
> > To support TDX, KVM is enhanced to operate with #VE.  For TDX, KVM uses=
 the
> > suppress #VE bit in EPT entries selectively, in order to be able to tra=
p
> > non-present conditions.  However, #VE isn't used for VMX and it's a bug
> > if it happens.  To be defensive and test that VMX case isn't broken
> > introduce an option ept_violation_ve_test and when it's set, BUG the vm=
.
>=20
> I am wondering from HW's point of view, is it OK for the kernel to
> explicitly send #VE IPI, in which case, IIUC, the guest can legally get t=
he
> #VE w/o being a TDX guest?

Ooh, fun.  Short answer: there's nothing to worry about here.

Legally, no.  Vectors 0-31 are reserved.  However, I do _think_ the guest c=
ould
technically send IPIs on vectors 16-31, as the local APIC doesn't outright =
reject
such vectors.  But such software would be in clear violation of the SDM.

  11.5.2 Valid Interrupt Vectors
 =20
  The Intel 64 and IA-32 architectures define 256 vector numbers, ranging f=
rom
  0 through 255 (see Section 6.2, =E2=80=9CException and Interrupt Vectors=
=E2=80=9D). Local and
  I/O APICs support 240 of these vectors (in the range of 16 to 255) as val=
id
  interrupts.
 =20
  When an interrupt vector in the range of 0 to 15 is sent or received thro=
ugh
  the local APIC, the APIC indicates an illegal vector in its Error Status
  Register (see Section 11.5.3, =E2=80=9CError Handling=E2=80=9D). The Inte=
l 64 and IA-32
  architectures reserve vectors 16 through 31 for predefined interrupts,
  exceptions, and Intel-reserved encodings (see Table 6-1). However, the lo=
cal
  APIC does not treat vectors in this range as illegal.

  When an illegal vector value (0 to 15) is written to an LVT entry and the=
 delivery
  mode is Fixed (bits 8-11 equal 0), the APIC may signal an illegal vector =
error,
  without regard to whether the mask bit is set or whether an interrupt is =
actually
  seen on the input.

where Table 6-1 defines the various exceptions, including #VE, and for vect=
ors
22-31 says "Intel reserved. Do not use."  Vectors 32-255 are explicitly des=
cribed
as "User Defined (Non-reserved) Interrupts" that can be generated via "Exte=
rnal
interrupt or INT n instruction."

However, INTn is far more interesting than IPIs, as INTn can definitely gen=
erate
interrupts for vectors 0-31, and the legality of software generating such i=
nterrupts
is questionable.  E.g. KVM used to "forward" NMI VM-Exits to the kernel by =
doing
INTn with vector 2.

Key word "interrupts"!  IPIs are hardware interrupts, and INTn generates so=
ftware
interrupts, neither of which are subject to exception bitmap interception:

  Exceptions (faults, traps, and aborts) cause VM exits based on the except=
ion
  bitmap (see Section 25.6.3). If an exception occurs, its vector (in the r=
ange
  0=E2=80=9331) is used to select a bit in the exception bitmap. If the bit=
 is 1, a VM
  exit occurs; if the bit is 0, the exception is delivered normally through=
 the
  guest IDT. This use of the exception bitmap applies also to exceptions ge=
nerated
  by the instructions INT1, INT3, INTO, BOUND, UD0, UD1, and UD2.

with a footnote that further says:

  INT1 and INT3 refer to the instructions with opcodes F1 and CC, respectiv=
ely,
  and not to INT n with value 1 or 3 for n.

So while a misbehaving guest could generate a software interrupt on vector =
20,
it would not be a true #VE, i.e. not an exception, and thus would not gener=
ate
an EXCEPTION_NMI VM-Exit.  I.e. the KVM_BUG_ON() can't be triggered by the =
guest
(assuming hardware isn't broken).

