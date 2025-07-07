Return-Path: <kvm+bounces-51702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3154AFBC7E
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 22:26:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44A414A66D6
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 20:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7543521CC5B;
	Mon,  7 Jul 2025 20:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p2L5tIjv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B5621C167
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 20:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751919962; cv=none; b=KwVCGPBPNZZRQxYyVf0hmQv3oqtqP4fmqW+l/IDnFU9JLlFpVTu+43uOo3ewRbcNaRqwzGyZ/y4e2Z0VoWJZ6OSfABa5+SnaiLwP74ygQGO4+30r1uo0OT9XxnALK3mup7ygEyx+Uj1RaFSDOYfvCGt+3z2pHhjs57p7OgzEAxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751919962; c=relaxed/simple;
	bh=CUORdPvw1cX4h66ndzLvStG5j7Op+139XvwyrrREJrk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GUGVhCDrknDT5BKzUrf+VXExngsudhjWQrltKQuEeUssqQKv7PJrGcrrX2uiCI2UahMiqocvCFel5NY3HPtYNTC9YSoNCFu1HIFAuasMs1ouWZT/8BaG3hU1Phkg2i3necp9fbP42PmEq3j/HWLv5MDNz8cr7E81f9rnTH047ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p2L5tIjv; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748fd21468cso2850274b3a.1
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 13:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751919960; x=1752524760; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iDHpPitSS0mzs6saY8nYUe4AbTUUpZo+s9Jeux1OhIQ=;
        b=p2L5tIjvqzyikO684wUOuFMy03ShPidY57Ke1k1vhi45gealcxG/mNbVVvZuTurre7
         fkt+49lGawnIQ8LpicG6fKSmy881+qq8WNrXDSmScIZSOG/M/UX2zHOnb6xwohL5a1qN
         E/4j4pUSZ0p+B75nGVtFaBPDO1fBSm1fplvNCfcQGhB8v0FR1UxMHiE3Bes9wWASCx17
         +l7YwSiULCx4cGSymfHE9h3rH6rid20ggxDe6Le1aMhaRObbo5U9TKHgqQ8TpyFHLcRI
         aIuxUFsVOhGj1PfklZzburCGRPLDjIM+jZMJ6dKu2QEkAqtM68uAUHe1g5nQtj+l21Sg
         F6rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751919960; x=1752524760;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iDHpPitSS0mzs6saY8nYUe4AbTUUpZo+s9Jeux1OhIQ=;
        b=Wu3h+gKG752JOfgrAvf+keq2U5uKA9UqKju0AzAkwpwokzJyXIGNXIRc56ED2teskb
         I+mrtkZoumvCofYfNShTITDk2vOHfYGMmdYlPuIQ6ugWMSWuvG8LnEdRKJXvJMs53GNL
         a7h0cx1EsesOoO0GEif8pWWsmdugmmnNA9Mv7ayXPixQ6mhHuaLiYBTF70a6OuSIGZtC
         ul3dDqEmpJwKFwwYNhfveJY8x7NVxIt9Lef/uRkDLZwNxlOpLNRCsPBnLNyyJybKHTO0
         EruNN8+eWkpMmYQyydmxfai33gZq/KM/+qZf3LVHcAE23yLpnKSn3g9Y2+gUVC/+deMp
         vqqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsU9ZLeMefp3xeRM6Y3RnvYOMlmSddgk+N50H5aUBognRh/BxoscbMZYvcxbVsKBXED6A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOCC1tX1AvqDZVe8HO3pOE1gBhrAbEVRtjSajxsT3NeXqJ1T9r
	Mpq0h4xiHSBu5ELOEfV5kpNh38IUazm5M3+sxe28UltlSY7tIXTLNrrYoHnKWoiQU/QDiOf6eeI
	QU87mag==
X-Google-Smtp-Source: AGHT+IFl8zMk4n4kKwZdLDcVRgIXGtT2XaLzjhr0sN/pKm4EFVOSPvZMjw56qXhYU9AsX5p7+6HZjthUz/0=
X-Received: from pgbee1.prod.google.com ([2002:a05:6a02:4581:b0:b1f:fd39:8314])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:12c7:b0:21f:51ea:5c57
 with SMTP id adf61e73a8af0-22b437de321mr627011637.16.1751919960279; Mon, 07
 Jul 2025 13:26:00 -0700 (PDT)
Date: Mon, 7 Jul 2025 13:25:59 -0700
In-Reply-To: <aF8FwqaBpfvQ7dYW@char.us.oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626125720.3132623-1-alexandre.chartre@oracle.com>
 <aF1S2EIJWN47zLDG@google.com> <67bd4e2f-24a8-49d8-80af-feaca6926e45@intel.com>
 <61df5e77-dfc4-4189-a86d-f1b2cabcac88@oracle.com> <aF8FwqaBpfvQ7dYW@char.us.oracle.com>
Message-ID: <aGwtV8f253c6IOwC@google.com>
Subject: Re: [PATCH] kvm/x86: ARCH_CAPABILITIES should not be advertised on AMD
From: Sean Christopherson <seanjc@google.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Alexandre Chartre <alexandre.chartre@oracle.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com, 
	x86@kernel.org, boris.ostrovsky@oracle.com, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 27, 2025, Konrad Rzeszutek Wilk wrote:
> On Fri, Jun 27, 2025 at 08:23:52AM +0200, Alexandre Chartre wrote:
> >=20
> > On 6/27/25 07:41, Xiaoyao Li wrote:
> > > On 6/26/2025 10:02 PM, Sean Christopherson wrote:
> > > > +Jim
> > > >=20
> > > > For the scope, "KVM: x86:"
> > > >=20
> > > > On Thu, Jun 26, 2025, Alexandre Chartre wrote:
> > > > > KVM emulates the ARCH_CAPABILITIES on x86 for both vmx and svm.
> > > > > However the IA32_ARCH_CAPABILITIES MSR is an Intel-specific MSR
> > > > > so it makes no sense to emulate it on AMD.
> > > > >=20
> > > > > The AMD documentation specifies that this MSR is not defined on
> > > > > the AMD architecture. So emulating this MSR on AMD can even cause
> > > > > issues (like Windows BSOD) as the guest OS might not expect this
> > > > > MSR to exist on such architecture.
> > > > >=20
> > > > > Signed-off-by: Alexandre Chartre<alexandre.chartre@oracle.com>
> > > > > ---
> > > > >=20
> > > > > A similar patch was submitted some years ago but it looks like it=
 felt
> > > > > through the cracks:
> > > > > https://lore.kernel.org/kvm/20190307093143.77182-1- xiaoyao.li@li=
nux.intel.com/
> > > > It didn't fall through the cracks, we deliberately elected to emula=
te the MSR in
> > > > common code so that KVM's advertised CPUID support would match KVM'=
s emulation.
> > > >=20
> > > > =C2=A0=C2=A0 On Thu, 2019-03-07 at 19:15 +0100, Paolo Bonzini wrote=
:
> > > > =C2=A0=C2=A0 > On 07/03/19 18:37, Sean Christopherson wrote:
> > > > =C2=A0=C2=A0 > > On Thu, Mar 07, 2019 at 05:31:43PM +0800, Xiaoyao =
Li wrote:
> > > > =C2=A0=C2=A0 > > > At present, we report F(ARCH_CAPABILITIES) for x=
86 arch(both vmx and svm)
> > > > =C2=A0=C2=A0 > > > unconditionally, but we only emulate this MSR in=
 vmx. It will cause #GP
> > > > =C2=A0=C2=A0 > > > while guest kernel rdmsr(MSR_IA32_ARCH_CAPABILIT=
IES) in an AMD host.
> > > > =C2=A0=C2=A0 > > >
> > > > =C2=A0=C2=A0 > > > Since MSR IA32_ARCH_CAPABILITIES is an intel-spe=
cific MSR, it makes no
> > > > =C2=A0=C2=A0 > > > sense to emulate it in svm. Thus this patch choo=
ses to only emulate it
> > > > =C2=A0=C2=A0 > > > for vmx, and moves the related handling to vmx r=
elated files.
> > > > =C2=A0=C2=A0 > >
> > > > =C2=A0=C2=A0 > > What about emulating the MSR on an AMD host for te=
sting purpsoes?=C2=A0 It
> > > > =C2=A0=C2=A0 > > might be a useful way for someone without Intel ha=
rdware to test spectre
> > > > =C2=A0=C2=A0 > > related flows.
> > > > =C2=A0=C2=A0 > >
> > > > =C2=A0=C2=A0 > > In other words, an alternative to restricting emul=
ation of the MSR to
> > > > =C2=A0=C2=A0 > > Intel CPUS would be to move MSR_IA32_ARCH_CAPABILI=
TIES handling into
> > > > =C2=A0=C2=A0 > > kvm_{get,set}_msr_common().=C2=A0 Guest access to =
MSR_IA32_ARCH_CAPABILITIES
> > > > =C2=A0=C2=A0 > > is gated by X86_FEATURE_ARCH_CAPABILITIES in the g=
uest's CPUID, e.g.
> > > > =C2=A0=C2=A0 > > RDMSR will naturally #GP fault if userspace passes=
 through the host's
> > > > =C2=A0=C2=A0 > > CPUID on a non-Intel system.
> > > > =C2=A0=C2=A0 >
> > > > =C2=A0=C2=A0 > This is also better because it wouldn't change the g=
uest ABI for AMD
> > > > =C2=A0=C2=A0 > processors.=C2=A0 Dropping CPUID flags is generally =
not a good idea.
> > > > =C2=A0=C2=A0 >
> > > > =C2=A0=C2=A0 > Paolo
> > > >=20
> > > > I don't necessarily disagree about emulating ARCH_CAPABILITIES bein=
g pointless,
> > > > but Paolo's point about not changing ABI for existing setups still =
stands.=C2=A0 This
> > > > has been KVM's behavior for 6 years (since commit 0cf9135b773b ("KV=
M: x86: Emulate
> > > > MSR_IA32_ARCH_CAPABILITIES on AMD hosts"); 7 years, if we go back t=
o when KVM
> > > > enumerated support without emulating the MSR (commit 1eaafe91a0df (=
"kvm: x86:
> > > > IA32_ARCH_CAPABILITIES is always supported").
> > > >=20
> > > > And it's not like KVM is forcing userspace to enumerate support for
> > > > ARCH_CAPABILITIES, e.g. QEMU's named AMD configs don't enumerate su=
pport.=C2=A0 So
> > > > while I completely agree KVM's behavior is odd and annoying for use=
rspace to deal
> > > > with, this is probably something that should be addressed in usersp=
ace.
> > > >=20
> > > > > I am resurecting this change because some recent Windows updates =
(like OS Build
> > > > > 26100.4351) crashes on AMD KVM guests (BSOD with Stop code: UNSUP=
PORTED PROCESSOR)
> > > > > just because the ARCH_CAPABILITIES is available.
> > >=20
> > > Isn't it the Windows bugs? I think it is incorrect to assume AMD will=
 never implement ARCH_CAPABILITIES.
> > >=20
> >=20
> > Yes, although on one hand they are just following the current AMD speci=
fication which
> > says that ARCH_CAPABILITIES is not defined on AMD cpus; but on the othe=
r hand they are
> > breaking a 6+ years behavior. So it might be nice if we could prevent s=
uch an issue in
> > the future.
>=20
> Hi Sean,
>=20
> Part of the virtualization stack is to lie accurately and in this case
> KVM is doing it incorrectly.=20

No, KVM isn't doing anything "incorrectly".  The ioctl in question,
KVM_GET_SUPPORTED_CPUID, advertises what *KVM* supports.  The CPUID model t=
hat
is configured for and presented to the guest is fully controlled by userspa=
ce,
i.e. by QEMU.

And relative to what KVM is advertising, KVM's behavior is correct.  Prior =
to
commit 0cf9135b773b, KVM was indeed buggy, because KVM didn't emulate a fea=
ture
that was advertised to userspace.  But that hasn't been the case for 6+ yea=
rs.

Even if KVM were explicitly setting guest CPUID, KVM's behavior _still_ wou=
ldn't
be incorrect, because it wouldn't violate AMD's architecture.  Per AMD's AP=
M,
software cannot assume reserved CPUID bits are '0':

  All bit positions that are not defined as fields are reserved. The value =
of
  bits within reserved ranges cannot be relied upon to be zero. Software mu=
st
  mask off all reserved bits in the return value prior to making any value
  comparisons of represented information.

> Not fixing it b/c of it being for 7 years in and being part of an ABI but
> saying it should be fixed in QEMU sounds like you agree technically, but =
are
> constrained by a policy.

I'm not constrained by policy, I'm weighing the risk vs. reward of changing=
 KVM's
ABI to remedy a problem that affects exactly one configuration in one VMM, =
is
relatively straightforward to address in said VMM, and has already been fix=
ed in
the affected guest kernel (because as above, QEMU's behavior isn't a violat=
ion
of AMD's architecture).

