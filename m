Return-Path: <kvm+bounces-55326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B9F4B2FED3
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 17:44:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66510560621
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 918C233472B;
	Thu, 21 Aug 2025 15:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nY2rt5KH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4AF3218B0
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 15:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755790043; cv=none; b=YXIEcvs8v2nbjG3ZerVMRvnkj54JU7SeF4Ok5J6H/a1uggAoRE1SSYRcCv5MFCxcPST1708jT9QbcK0PE8QMe58A5sw5oJNHLFK70eamOe0Q+sQhpJleUzFoHSAHoT+kJd4K/oOy1FK9CIRwrqro3yBLtMdjNptCf+kf0UrQBxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755790043; c=relaxed/simple;
	bh=RuVd6VhLx/ESvjcEdKEJ0sQssvWWc/dXK+bjffFMlDU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DqexPZ0uEM0b446Q+69bVZLVeAoD6Xbwv7l5fRpyIy0OVR0MvHN76ZnpXUCm1FSdt/1SEnmemzj8T+ETaVeLUEhCjok+vsHHXDov6wH+647ZzYSYEq2EQsNxjx8Y9Mj4nodIsAEsNyPRlbmnEAkTLByF7bXJHw4R/GqGp470MDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nY2rt5KH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326e2506aso1170849a91.3
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 08:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755790040; x=1756394840; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J0nOEic8CcwY+6hpqmum6A9VNU65AINFJfOA9KBUaPg=;
        b=nY2rt5KHHZ9Yy4NlUbKvDYneBU+HGEc0nCkNzpr7/PgG07v61rggWtSBy0BiFA/PyH
         B69LrsO4qc0npVOq0+FsJ/fDodVZitvoradAjktb84Exbp0V3vTAHtKuR9naLYSMwj8I
         Y6yGEU1cY7vU3qEQEuBtZMwy5+PWJ3SvkrTrTvs3lwCxMSe9OOOsxzNtweOhj+D1OmVR
         uze0DBliPIuvxoUlQtW86l2BVAuoxCryvYk/i0O5b+3LtFh8AKV8J8wgZx9ewlMWAmLG
         zXTFlrKIUrEcfnuIHju9QEKyKwgnD1/T8yMfAdtPHgAFaz3oDfAsr2/a3ggpGV1qcxTN
         ohbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755790040; x=1756394840;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J0nOEic8CcwY+6hpqmum6A9VNU65AINFJfOA9KBUaPg=;
        b=ZbcbYh3iDk24ta848kFerZAXy8pWkmm7VwA+rHHS6eo42NudBsMlkFLv8C5wCyBUG2
         rOgeugtX7HUCXX/uLYpBBtT1cesLDgKMdRMobc5K1SP47e8UpdkmiW0NTyKOjGobQCVx
         iPmjrqV3Bk0ZsxGBlHEztN1BUOVEmQH4Kwj+mL+2GgQ7+5Jrp1oRnm9e9ziiISnDGvga
         hd7OHZ+EIq/BVm1GLADpKbevHGq9kC/96/tXhD18UQ8nOKofVMEmsGaaN4wepQ4GHMHV
         4smV+/pscTaS7nYAPWj4tU8MRZuWY7HneOCkrwv/Qwedty2ZJ0ODBkdGXyWGsqE5NmwS
         PZuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIsmN5Okyg+2Q5eAjgm+ivpZVHJUjm5TIaWTWFRZtR0JMPrF65+MZVB/vzlpjarY7HPgE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMM/9PFO0VUDLdL0RcxBvfg/uPN95aUISRnbA1xIo4uguckwBV
	JPsC0qBQOMkPE5cUANS+AsCqa4tmWjnXFVFXkON5sOopWZL7bUCrNB1UQ7OhRETe9TjSw9IzDwe
	+O2cqAA==
X-Google-Smtp-Source: AGHT+IErn+S7Lo3tcvkDcjWls4tKiHbQGQvkGoFOV+v791Vf8loaYFkjMjAYIe9Wb0EbdLX8P8wL1dPep+E=
X-Received: from pjbdb4.prod.google.com ([2002:a17:90a:d644:b0:324:e309:fc3d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d83:b0:31f:2bd7:a4d2
 with SMTP id 98e67ed59e1d1-324ed15c158mr4291122a91.35.1755790040396; Thu, 21
 Aug 2025 08:27:20 -0700 (PDT)
Date: Thu, 21 Aug 2025 08:27:19 -0700
In-Reply-To: <f1ec8527-322d-4bdb-9a38-145fd9f28e4b@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aIDzBOmjzveLjhmk@google.com> <550a730d-07db-46d7-ac1a-b5b7a09042a6@linux.intel.com>
 <aIeX0GQh1Q_4N597@google.com> <ad616489-1546-4f6a-9242-a719952e19b6@linux.intel.com>
 <CAGtprH9EL0=Cxu7f8tD6rEvnpC7uLAw6jKijHdFUQYvbyJgkzA@mail.gmail.com>
 <20641696-242d-4fb6-a3c1-1a8e7cf83b18@linux.intel.com> <697aa804-b321-4dba-9060-7ac17e0a489f@linux.intel.com>
 <aKYMQP5AEC2RkOvi@google.com> <d84b792e-8d26-49c2-9e7c-04093f554f8a@linux.intel.com>
 <f1ec8527-322d-4bdb-9a38-145fd9f28e4b@linux.intel.com>
Message-ID: <aKc61y0_tvGLmieC@google.com>
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Vishal Annapurve <vannapurve@google.com>, Nikolay Borisov <nik.borisov@suse.com>, 
	Jianxiong Gao <jxgao@google.com>, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dionna Glaze <dionnaglaze@google.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, jgross@suse.com, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, pbonzini@redhat.com, 
	Peter Gonda <pgonda@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, jiewen.yao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025, Binbin Wu wrote:
> On 8/21/2025 11:30 AM, Binbin Wu wrote:
> > Variable MTRR has requirement for range size and alignment:
> > For ranges greater than 4 KBytes, each range must be of length 2^n and =
its base
> > address must be aligned on a 2^n boundary, where n is a value equal to =
or
> > greater than 12. The base-address alignment value cannot be less than i=
ts length.
>=20
> Wait, Linux kernel converts MTRR register values to MTRR state (base and =
size) and
> cache it for later lookups (refer to map_add_var()). I.e., in Linux kerne=
l,
> only the cached state will be used.
>=20
> These MTRR register values are never programmed when using
> guest_force_mtrr_state() , so even the values doesn't meet the requiremen=
t
> from hardware perspective, Linux kernel can still get the right base and
> size.

Yeah.  I forget what happens if the ranges don't meet the power-of-2 requir=
ements,
but the mask+match logic should work jus tfine.

> No bothering to force the base and size alignment.
> But a comment would be helpful.
> Also, BIT(11) could be replaced by MTRR_PHYSMASK_V.

Ha!  I spent a good 5 minutes looking for a #define couldn't find one.  Wha=
t a
bizarre name...

> How about:
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 90097df4eafd..a9582ffc3088 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -934,9 +934,15 @@ static void kvm_sev_hc_page_enc_status(unsigned long=
 pfn, int npages, bool enc)
> =C2=A0static void __init kvm_init_platform(void)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 u64 tolud =3D e820__end_of_low_ram_pfn() << P=
AGE_SHIFT;
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * The range's base address and size may not =
meet the alignment
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * requirement for variable MTRR. However, Li=
nux guest never
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * programs MTRRs when forcing guest MTRR sta=
te, no bothering to
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * enforce the base and range size alignment.
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct mtrr_var_range pci_hole =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .base_lo =3D tolu=
d | X86_MEMTYPE_UC,
> -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.mask_lo =3D (u32=
)(~(SZ_4G - tolud - 1)) | BIT(11),
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.mask_lo =3D (u32=
)(~(SZ_4G - tolud - 1)) | MTRR_PHYSMASK_V,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .mask_hi =3D (BIT=
_ULL(boot_cpu_data.x86_phys_bits) - 1) >> 32,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 };
>=20
>=20
> I tested it in my setup, it can fix the issue of TPM driver failure with =
the
> modified ACPI table for TPM in QEMU.
>=20
>=20
> Hi Vishal,
> Could you test it with google's VMM?

Vishal is OOO for a few days.  I pinged our internal bug tracker, I'll find
someone to test.

Thanks much!

