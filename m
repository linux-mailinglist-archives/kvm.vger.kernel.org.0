Return-Path: <kvm+bounces-49712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF801ADCFA6
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:27:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03E7B3BE6FD
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 14:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B452EE5ED;
	Tue, 17 Jun 2025 14:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4cZrNyoF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D7D2E974D
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 14:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750169588; cv=none; b=vGWB6ctorYH/0DM07oAFLtabW56t2WCiuZbWetphxQAGhSfUjjEteLA8SrO3Jy5mmirUkbYIBeQuA3JaQY99eAEg/nafST4ELixFtgZVjg8iKjqYzm689NxZKgH9PEvYZ3ACaHc4lAo6vAdnKdmR0NsMeO8jS5+ZZouZsbDUAzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750169588; c=relaxed/simple;
	bh=iJFhAXlGhFKK7yOPAVqYWm3BfhXV1LaGI4OcwABbD/g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lWNI2By+c+d895z3GMzDxJ8T9cQ5GW89ZdLDbfwDxIKelS8DKLJRbWOK21/Awjd2kOVMnGtaS350ZxknQO/wfYlBdhbAAzgYy1eixO9QUKbgn3yRrFvEoQahVqKpfxa5C6sRsVMURHivOt9KTgheoS5DaUL6HN6aeJZs2Ymnq/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4cZrNyoF; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2fdba7f818so5953246a12.2
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 07:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750169586; x=1750774386; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OX3ux6zQ+VEvAEBxzgvhUtbA0mLIAHUIclsODIjZeM8=;
        b=4cZrNyoFJrcgenkOk6D8wZq3eyzhkvcGXKZe1f6kt/3iDrY6TAIN6fBPSXuRqG5kd4
         6Ue/RNCfqlRNy7J4IxWfF+NGZINvlXOwEicLHL2mjjoH951SBPdV2NzuAX3vW1eyp1wC
         B1+rFZHK2aJWoXb34Kwr3mo2aDxrEK3Xz6jIdPX2WQvhsLBJao6Lo26jAPMX66gPec5T
         zo6iAVD2o8i8EuDiSJ6kh/kCY3tMmeOUG0aiDrhm/IDBenpQPOQVT6uayk7GN+3sStEr
         68rswZ5GbHC1CByd0k/c6uB9n9yukPQDHAY9N+sLgsuWJn0mcRhn/sXCkwWcvR2/Nyto
         6j2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750169586; x=1750774386;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OX3ux6zQ+VEvAEBxzgvhUtbA0mLIAHUIclsODIjZeM8=;
        b=ofLzPdq4cIpQ+xE2SnPJqFl/GwXecfUpcqVYr/MwvHD+scLsbX+ckR0fpMCsGyx9GI
         FwykYSQ6OFyZpkoHmg3b+eVVD8n7iNLWxmGcDwgXiKNWMfzU5cIKoNOt+1RF+ASjOZZy
         rh39k4HIQuPyImpcj0NCpufwgi77x1hEfwtW3GBBPqIaphNsigVTlEdeFzX4kft5vCbg
         9yyyoaghIjoOLs7hcfYE1PpyTPrt3cJVmwaAQqPjTM1fkhWm+q0YOCNwjOCJbr0ZE4oF
         QlglCTf99JTv6xcbR+ojYA7BX5c0kEOnm69iCHgC1Osv2l1cjl4U8K/IBuSMDVNN5XQ/
         PFkA==
X-Forwarded-Encrypted: i=1; AJvYcCVpXcOgNPQI0L/qrSYBmIwcUWybRViRxHmuD13k/aavY/67K+ndo8WNl3MU7z1n3Y+KAx8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwR1axXmIIorPYMe2wlnJ5YC2y4DCBiQGdEWSOYkKuP4ijFCkvN
	apmRj2TojfLmpoee5UfyQMv+d0FCKtdY8ldDyDf8N+qV8yNme90yFHAqqpqDAWj0OAMUCQEKhXW
	poJ29iw==
X-Google-Smtp-Source: AGHT+IEh9icMUepp4I5ggIdPQbPGEKAuVdOhfGme7kn3ozONic/swJyFNawEJ+MkTpo/UKNsX0OJfzVNnzg=
X-Received: from pgbfy9.prod.google.com ([2002:a05:6a02:2a89:b0:b2c:374b:9e48])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2d06:b0:1f5:7eee:bb10
 with SMTP id adf61e73a8af0-21fbd54a618mr21353159637.8.1750169586115; Tue, 17
 Jun 2025 07:13:06 -0700 (PDT)
Date: Tue, 17 Jun 2025 07:13:04 -0700
In-Reply-To: <7704c861ba54c246dc8e5f26113c6f84306a099e.camel@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313203702.575156-1-jon@nutanix.com> <20250313203702.575156-7-jon@nutanix.com>
 <aCI8pGJbn3l99kq8@google.com> <49556BAF-9244-4FE5-9BA9-846F2959ABD1@nutanix.com>
 <aCNI72KuMLfWb9F2@google.com> <6dd4eee79fec75a47493251b87c74595826f97bc.camel@amd.com>
 <aCSSptnxW7EBEzSQ@google.com> <7704c861ba54c246dc8e5f26113c6f84306a099e.camel@amd.com>
Message-ID: <aFF38Pq71JdLBlqO@google.com>
Subject: Re: [RFC PATCH 06/18] KVM: VMX: Wire up Intel MBEC enable/disable logic
From: Sean Christopherson <seanjc@google.com>
To: Amit Shah <Amit.Shah@amd.com>
Cc: "x86@kernel.org" <x86@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"jon@nutanix.com" <jon@nutanix.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2025, Amit Shah wrote:
> On Wed, 2025-05-14 at 05:55 -0700, Sean Christopherson wrote:
> > On Wed, May 14, 2025, Amit Shah wrote:
> > > (btw KVM MMU API question -- from the #NPF, I have the GPA of the L2
> > > guest.=C2=A0 How to go from that guest GPA to look up the NX bit for =
that
> > > page?=C2=A0 I skimmed and there doesn't seem to be an existing API fo=
r it - so
> > > is walking the tables the only solution?)
> >=20
> > As above, KVM doesn't manually look up individual bits while handling
> > faults.  The walk of the guest page tables (L1's NPT/EPT for this scena=
rio)
> > performed by FNAME(walk_addr_generic) will gather the effective permiss=
ions
> > in walker->pte_access, and check for a permission_fault() after the wal=
k is
> > completed.
>=20
> Hm, despite the discussions in the PUCK calls since this email, I have
> this doubt, which may be fairly basic.  To determine whether the exit
> was due to GMET, we have to check the effective U/S and NX bit for the
> address that faulted.  That means we have to walk the L2's page tables
> to get those bits from the L2's PTEs, and then from the error code in
> exitinfo1, confirm why the #NPF happened.  (And even with Paolo's neat
> SMEP hack, the exit reason due to GMET can only be confirmed by looking
> at the guest's U/S and NX bits.)
>=20
> And from what I see, currently page table walks only happen on L1's
> page tables, and not on L2's page tables, is that right?

Nit, they aren't _L2's_ page tables, in that (barring crazy paravirt behavi=
or)
L2 does not control the page tables.  In most conversations, that distincti=
on
wouldn't matter, but when talking about which pages KVM walks when running =
an L2
while L1 is using NPT (or EPT), it's worth being very precise, because KVM =
may
also need to walk L2's non-nested page tables, i.e. the page table that map=
 L2
GVAs to L2 GPA.

The least awful terminology we've come up with when referring to nested TDP=
 is
to follow KVM's VMCS/VMCB terminology when doing nested virtualization:

  npt12: The NPT page tables controlled by L1 to manage L2 GPAs.  These are
         never referenced by hardware.
  npt02: KVM controlled page tables that shadow npt12, and are consumed by =
hardware.

> I'm sure I'm missing something here, though..

Heh, yep.  Part of that's my fault for using ambiguous terminology.  When I=
 said
"L1's NPT/EPT" above, what I really meant was npt12.  I.e. this code

  static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault=
 *fault)
  {
	struct guest_walker walker;
	int r;

	WARN_ON_ONCE(fault->is_tdp);

	/*
	 * Look up the guest pte for the faulting address.
	 * If PFEC.RSVD is set, this is a shadow page fault.
	 * The bit needs to be cleared before walking guest page tables.
	 */
	r =3D FNAME(walk_addr)(&walker, vcpu, fault->addr,
			     fault->error_code & ~PFERR_RSVD_MASK);

	/*
	 * The page is not mapped by the guest.  Let the guest handle it.
	 */
	if (!r) {
		if (!fault->prefetch)
			kvm_inject_emulated_page_fault(vcpu, &walker.fault);  <=3D=3D=3D=3D=3D G=
MET #NPF

		return RET_PF_RETRY;
	}

which leads to the aformentioned FNAME(walk_addr_generic) and walker->pte_a=
ccess
behavior, is walking npt12.  Because the #NPF will have occurred while runn=
ing
L2, and by virtue of it being an #NPF (as opposed to a "legacy" #PF), KVM k=
nows
the fault is in the context of npt02.

Before doing anything with respect to npt12, KVM needs to do walk_addr() on=
 _npt12_
to determine whether the access is allowed by np12.  E.g. the simplest scen=
ario
to grok is if L2 accesses a (L2) GPA that isn't mapped by npt12, in case KV=
M needs
to inject a #NPF into L1.

Same thing here.  On a PRESENT+FETCH+USER fault, if the effective protectio=
ns
in npt12 have U/S=3D1 and GMET is enabled, then KVM needs to inject a #NPF =
into
L1. =20

Side topic, someone should check with the AMD architects as to whether or n=
ot
GMET depends on EFER.NXE=3D1.  The APM says that all NPT mappings are execu=
table
if EFER.NXE=3D0 in the host (where the "host" is L1 when dealing with neste=
d NPT).
To me, that implies GMET is effectively ignored if EFER.NXE=3D0.

  Similarly, if the EFER.NXE bit is cleared for the host, all nested page t=
able
  mappings are executable at the underlying nested level.

