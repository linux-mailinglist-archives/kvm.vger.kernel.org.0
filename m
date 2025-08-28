Return-Path: <kvm+bounces-55985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11414B38F98
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 02:07:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DE6D7C3451
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 00:07:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 273111CA81;
	Thu, 28 Aug 2025 00:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pEOrfLvE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2E12F32
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 00:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756339635; cv=none; b=lyixj8mfxTa87DjTh5/TGt/4oc7IhC6WcRB+RcvRzQuqzHp1TKNz005KBZFny6uWF+mr1QlSW7SYaDgr9UXFYTKcM4Z9ZgOKmMv04QFV3QxohfXxKjuAvg+p9qzYlp2kEqLEKbNomFeFXpmTQRcQX3CFFnGOfGR1FkOwe8pAZaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756339635; c=relaxed/simple;
	bh=EKG1cKzLKUKkjt9t7eG2R6R8dZd2IX10aS64SIZ7J1s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PU2RNfviLHlGMNQp9QVd+Wyvmv458u4ZZqYTTViXL73sqmyqhVpk6b3WfNElRCvgGUFsX68TIOeN9QLfuP8iMU0b4AcObDS6CpBxoCGQccY+YLulbU8UGaM4WI0HIyjl0HWMAQQ+tyh7K73hlcMrPF83CDE49OzC8+CaynOl0Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pEOrfLvE; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-771e43782aaso329244b3a.1
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 17:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756339633; x=1756944433; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t579SF/wnMrFK0E/9c31FaYDCwaoHad3snclUWLCz6M=;
        b=pEOrfLvEG+tA9aBtoX3JCX4cTyDzZ4jRCFcoCv0UmE6J50Me+QuqdqsL3rvq6H87Fd
         at/ct0mVLB+xuM9LkQQJUy5Kg4FDBqsjfU9rIzv/oSmTRt7oa9/u5k7XlYMG+kbZCtFE
         4nu7AP8zB4/GgEwH0gZzVBni+NgiU6crkVvF/f25+QOVfgAb7hFL0CQiHFd9AJouzhL5
         zG0XhSd5A2GtGhWva52o7vnwN+Pvxl5bz8WpW0utAnGue9zB1oz8obDlI/VeVBkpVkxN
         YGtywCWOMC22SO56GVboqe17O7gtlBafbRA8g7K9qKZHGlgjVJ6kblItR1MSBw7KIDw5
         r9fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756339633; x=1756944433;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=t579SF/wnMrFK0E/9c31FaYDCwaoHad3snclUWLCz6M=;
        b=XqoxdVu2N9BRyH6GSsBpBs9qlfPgmHgIxGrAYVo6QpOeXcfp+VYZqR46QliAAgX3lG
         y4wnXAFMLNWTvT5W0Nu6sSiDhfKNj3zgGek0Mv+cWziXkIyI37ljxeNZcc65XRaokUbv
         Qd7LF5dH+ixiEofFudCMyYK5IsrFx/pbY8ZheZN1TGtySg1pDoMNsVEWr5ImrkpmxZdM
         17m5kOQxGg4CNjPOxlruWGIyIsG3zh6ntMNariscgPD8rk1Z6ufQzUl4+iHhK2ndlY/c
         MpkOQEs7Q6pfIKb2T05JTji9OBaKBKpUQiAYRRgjDw/CSUQ7yoOvRs8FuN2M4p5wmEe3
         1lPA==
X-Forwarded-Encrypted: i=1; AJvYcCXu1dGn6VckfZ6xSLkYRalk8u+5nNT8P8Px6l2pqg+NWeoEgWhfyMcVE+FD8UBoKQyQxkU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAmxc9fRLGOSdu8h8FHevygAQWBZoxQEOoR6NTlmO2Hcfwm4vO
	MgSzxmUq9c6tdA7gjgZfKsciVcz2Pj4ZHUNrahhteYoq0YWnjAw1ijjypa+OOpef416B4CimsVm
	ao8Vpuw==
X-Google-Smtp-Source: AGHT+IETLC27C6TI91VObBy0J9hrR5myKvHDcaHo0xSKLRonIs5n9tEC5WogkS6LO7SOJpU1fDydbpJ3DGk=
X-Received: from pgdo2.prod.google.com ([2002:a63:9202:0:b0:b4c:40fc:9518])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7286:b0:243:ae10:2433
 with SMTP id adf61e73a8af0-243ae1026c0mr944532637.40.1756339633137; Wed, 27
 Aug 2025 17:07:13 -0700 (PDT)
Date: Wed, 27 Aug 2025 17:07:11 -0700
In-Reply-To: <aKc61y0_tvGLmieC@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <550a730d-07db-46d7-ac1a-b5b7a09042a6@linux.intel.com>
 <aIeX0GQh1Q_4N597@google.com> <ad616489-1546-4f6a-9242-a719952e19b6@linux.intel.com>
 <CAGtprH9EL0=Cxu7f8tD6rEvnpC7uLAw6jKijHdFUQYvbyJgkzA@mail.gmail.com>
 <20641696-242d-4fb6-a3c1-1a8e7cf83b18@linux.intel.com> <697aa804-b321-4dba-9060-7ac17e0a489f@linux.intel.com>
 <aKYMQP5AEC2RkOvi@google.com> <d84b792e-8d26-49c2-9e7c-04093f554f8a@linux.intel.com>
 <f1ec8527-322d-4bdb-9a38-145fd9f28e4b@linux.intel.com> <aKc61y0_tvGLmieC@google.com>
Message-ID: <aK-dr2W7UoA65jM2@google.com>
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

On Thu, Aug 21, 2025, Sean Christopherson wrote:
> On Thu, Aug 21, 2025, Binbin Wu wrote:
> > On 8/21/2025 11:30 AM, Binbin Wu wrote:
> > > Variable MTRR has requirement for range size and alignment:
> > > For ranges greater than 4 KBytes, each range must be of length 2^n an=
d its base
> > > address must be aligned on a 2^n boundary, where n is a value equal t=
o or
> > > greater than 12. The base-address alignment value cannot be less than=
 its length.
> >=20
> > Wait, Linux kernel converts MTRR register values to MTRR state (base an=
d size) and
> > cache it for later lookups (refer to map_add_var()). I.e., in Linux ker=
nel,
> > only the cached state will be used.
> >=20
> > These MTRR register values are never programmed when using
> > guest_force_mtrr_state() , so even the values doesn't meet the requirem=
ent
> > from hardware perspective, Linux kernel can still get the right base an=
d
> > size.
>=20
> Yeah.  I forget what happens if the ranges don't meet the power-of-2 requ=
irements,
> but the mask+match logic should work jus tfine.
>=20
> > No bothering to force the base and size alignment.
> > But a comment would be helpful.
> > Also, BIT(11) could be replaced by MTRR_PHYSMASK_V.
>=20
> Ha!  I spent a good 5 minutes looking for a #define couldn't find one.  W=
hat a
> bizarre name...
>=20
> > How about:
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 90097df4eafd..a9582ffc3088 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -934,9 +934,15 @@ static void kvm_sev_hc_page_enc_status(unsigned lo=
ng pfn, int npages, bool enc)
> > =C2=A0static void __init kvm_init_platform(void)
> > =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 u64 tolud =3D e820__end_of_low_ram_pfn() <<=
 PAGE_SHIFT;
> > +=C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * The range's base address and size may no=
t meet the alignment
> > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * requirement for variable MTRR. However, =
Linux guest never
> > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * programs MTRRs when forcing guest MTRR s=
tate, no bothering to
> > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * enforce the base and range size alignmen=
t.
> > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct mtrr_var_range pci_hole =3D {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .base_lo =3D to=
lud | X86_MEMTYPE_UC,
> > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.mask_lo =3D (u=
32)(~(SZ_4G - tolud - 1)) | BIT(11),
> > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.mask_lo =3D (u=
32)(~(SZ_4G - tolud - 1)) | MTRR_PHYSMASK_V,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .mask_hi =3D (B=
IT_ULL(boot_cpu_data.x86_phys_bits) - 1) >> 32,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 };
> >=20
> >=20
> > I tested it in my setup, it can fix the issue of TPM driver failure wit=
h the
> > modified ACPI table for TPM in QEMU.
> >=20
> >=20
> > Hi Vishal,
> > Could you test it with google's VMM?
>=20
> Vishal is OOO for a few days.  I pinged our internal bug tracker, I'll fi=
nd
> someone to test.

Got confirmation this fixes the vTPM woes with Google's VMM.  v2 incoming..=
.

