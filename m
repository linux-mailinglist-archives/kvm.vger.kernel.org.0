Return-Path: <kvm+bounces-37154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 75271A26412
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 20:53:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 129847A2FA8
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 19:52:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B97209684;
	Mon,  3 Feb 2025 19:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2fCqn5Wm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494581DB377
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 19:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738612376; cv=none; b=nwIjfmy1m2KiHjc+B6FeRBPK1mjIhK9rLBgfcNcJb+bVxKVxkQb5Nk65IHWYlhFCqbn6wsrHdn4OF3uxJJuPFw+nYyu+DG0pHZ4sYR914St3QnCSXCHA6sCaK53O73QVwU52eclWFuiVNZOBF52iYJc6fdV79ryhmyQRrFhfg6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738612376; c=relaxed/simple;
	bh=vqumdPUecpvskYi8VygICeGGt4cQpB2BlEoPCXjm++o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BDznPa2r9zaYZ6tuPkcC4tgu5Nla8JCrovnQ47fSPupbVh2LPHmKo+ITOMKWnfAoHYKBhRpe7MbqIeoOEcmRJzNUb7szG5brHLhOdFa2NTeIG36kR7Hv5bma4Pp7E8PJc3Ynw0HIl4FIqHSHK2eZ8qXK1pqAQBbb0Bkt5C3yZJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2fCqn5Wm; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-216728b170cso102439755ad.2
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 11:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738612374; x=1739217174; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4DCNVElxq2OdBlpMH7Nkzbl/aQqIemXOZXJQi0SM/U=;
        b=2fCqn5WmpfSMTNPk99MabSvdASAUCrZ1YSHoptYwbaStLioHcmAPiAkpXCbtQaTjnS
         wsJXQN5VD20nMBrJCnxMPD8KL/jBP67WZmeFzUg5aHSyj/ndOk14LSB9mIVWdzA7vtL9
         pWKRMNQCxotzDvKGDNxupj3JbQ9xqVus+w1w6wvt4DRmSRvg2wdXFAXpVui5AnyZFvIA
         Os0PpOT8mjQJ5/ri3PJfcQXXl+k7FKSAQriGp+KMY/RGOBwh5UJLnzICi6sxTU5+omNF
         6rWbcae9bq6lDDq2Elt0KQi1+scF8q+/yOSWd1vIH90koUctHZmsqR/EiPjpX6rbWibP
         wiMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738612374; x=1739217174;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4DCNVElxq2OdBlpMH7Nkzbl/aQqIemXOZXJQi0SM/U=;
        b=iVJaY1+v8clLxMSuoKkkvP2aqXx5O2J5e6IccWis1mYrAC4blGZJtILJOGcbsnzDh7
         0N/K4FU8c1bavdA+L+zAZi4NnagnSv5MkDLj8pbcVYVg/5mhXuRmczD3FlFDNGEImaFn
         xvSat4KXUAII3UrXfez1fx1w3XZNlhANNMMhy2LazPqWYQ0LY8HufyMKp2igdvjo1PZE
         GRDeXWfZLUJ9iq+dgIu5z5Q96ZrsYHXx/6xg7Exo8+wnm0xUoeUmd/47vFZTDqaqIxUD
         PlWK6SL6p5bORD1+mcRwwfJ1TubL3i9kq/Osmw2a6ONNRiOq1WW7EdGTcEMF4e2Z1yIj
         m7nQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuAjPkB5AXWD6jn9rdjL2N6eXlmo/qBNVsP0dzdY5avkJu/QJomn1FMlX+tmCPyb/DKRQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDbn2nXmK2XSa08JtsvRwMLy3dMstURndzXntaTU2P80BW89ax
	C1bs8+FJdcvni2iQFt3bL+FsxR1aS6ozhro817q7CXn0NyYigMpejIPXaReWzN0zIMiDsXw2xR5
	yWw==
X-Google-Smtp-Source: AGHT+IGdTeFcZ8i5SvZ2bB5g1492lleQh9maGoQBlpXj01DaF5LbzkfV8PQhJ2gBHFVfNpv3sg2ev2woN1U=
X-Received: from pfsq1.prod.google.com ([2002:a05:6a00:2a1:b0:72d:4132:7360])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2287:b0:72d:a208:d366
 with SMTP id d2e1a72fcca58-72fd0c8bae3mr33309743b3a.20.1738612374524; Mon, 03
 Feb 2025 11:52:54 -0800 (PST)
Date: Mon, 3 Feb 2025 11:52:53 -0800
In-Reply-To: <fb1d32fb-f213-350f-95a4-766c88a6249c@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201021718.699411-1-seanjc@google.com> <20250201021718.699411-9-seanjc@google.com>
 <fb1d32fb-f213-350f-95a4-766c88a6249c@amd.com>
Message-ID: <Z6EelTYbVIcmGH5Q@google.com>
Subject: Re: [PATCH 08/16] x86/tsc: Pass KNOWN_FREQ and RELIABLE as params to registration
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Alexey Makhalov <alexey.amakhalov@broadcom.com>, Jan Kiszka <jan.kiszka@siemens.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-hyperv@vger.kernel.org, jailhouse-dev@googlegroups.com, 
	kvm@vger.kernel.org, xen-devel@lists.xenproject.org, 
	Nikunj A Dadhania <nikunj@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 03, 2025, Tom Lendacky wrote:
> On 1/31/25 20:17, Sean Christopherson wrote:
> > Add a "tsc_properties" set of flags and use it to annotate whether the
> > TSC operates at a known and/or reliable frequency when registering a
> > paravirtual TSC calibration routine.  Currently, each PV flow manually
> > sets the associated feature flags, but often in haphazard fashion that
> > makes it difficult for unfamiliar readers to see the properties of the
> > TSC when running under a particular hypervisor.
> > 
> > The other, bigger issue with manually setting the feature flags is that
> > it decouples the flags from the calibration routine.  E.g. in theory, PV
> > code could mark the TSC as having a known frequency, but then have its
> > PV calibration discarded in favor of a method that doesn't use that known
> > frequency.  Passing the TSC properties along with the calibration routine
> > will allow adding sanity checks to guard against replacing a "better"
> > calibration routine with a "worse" routine.
> > 
> > As a bonus, the flags also give developers working on new PV code a heads
> > up that they should at least mark the TSC as having a known frequency.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/coco/sev/core.c       |  6 ++----
> >  arch/x86/coco/tdx/tdx.c        |  7 ++-----
> >  arch/x86/include/asm/tsc.h     |  8 +++++++-
> >  arch/x86/kernel/cpu/acrn.c     |  4 ++--
> >  arch/x86/kernel/cpu/mshyperv.c | 10 +++++++---
> >  arch/x86/kernel/cpu/vmware.c   |  7 ++++---
> >  arch/x86/kernel/jailhouse.c    |  4 ++--
> >  arch/x86/kernel/kvmclock.c     |  4 ++--
> >  arch/x86/kernel/tsc.c          |  8 +++++++-
> >  arch/x86/xen/time.c            |  4 ++--
> >  10 files changed, 37 insertions(+), 25 deletions(-)
> > 
> 
> > diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
> > index d6f079a75f05..6e4a2053857c 100644
> > --- a/arch/x86/kernel/cpu/vmware.c
> > +++ b/arch/x86/kernel/cpu/vmware.c
> > @@ -385,10 +385,10 @@ static void __init vmware_paravirt_ops_setup(void)
> >   */
> >  static void __init vmware_set_capabilities(void)
> >  {
> > +	/* TSC is non-stop and reliable even if the frequency isn't known. */
> >  	setup_force_cpu_cap(X86_FEATURE_CONSTANT_TSC);
> >  	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
> 
> Should this line be deleted, too, or does the VMware flow require this
> to be done separate from the tsc_register_calibration_routines() call?

No idea, I just didn't want to break existing setups.  I assume VMware hypervisors
will always advertise the TSC frequency, but nothing in the code guarantees that.

The check on the hypervisor providing the TSC frequency has existed since the
original support was added, and the CONSTANT+RELIABLE logic was added immediately
after.  So even if it the above code _shouldn't_ be needed, I don't want to be
the sucker that finds out :-)

  395628ef4ea12ff0748099f145363b5e33c69acb x86: Skip verification by the watchdog for TSC clocksource.
  eca0cd028bdf0f6aaceb0d023e9c7501079a7dda x86: Add a synthetic TSC_RELIABLE feature bit.
  88b094fb8d4fe43b7025ea8d487059e8813e02cd x86: Hypervisor detection and get tsc_freq from hypervisor

