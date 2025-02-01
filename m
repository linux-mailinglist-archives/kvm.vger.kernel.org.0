Return-Path: <kvm+bounces-37071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 336C3A24984
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 15:25:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C18201885CCC
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 14:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FADE1BEF7A;
	Sat,  1 Feb 2025 14:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4jX8igxL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F03B3F9D5
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 14:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738419949; cv=none; b=OTW5rNPd1E/HhkXNFbug9lUAUQ+xMydSlVuv+65N5l+EDIRyO9tECBKEowsPOp+qvldGBhP7Ex8r0d1DKZ4b39DkbcJYW75PdKIr/6eKd3PsIjaCWC9Aqb8rodqjbjqHqFFM90izYY3NAuFcFbXFlDQltwwYvhMAHwlRhkAFZWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738419949; c=relaxed/simple;
	bh=b/ilQBMD/ctDxdLGch35HEyD5tj1iFoV6HojCaZANsg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rGKQX+hMsSqKbkJchd+hTM6cD5DuM5c04iC9rPxWW5I5sa1+cyv4W/nauAvbRlsTjUSmwxoRqNLd6nB8ftY43msSQddaF720+EXLnWNMDMl6kpRJbt0LB0zSFI3mxWkilrkFUzKCS+60azbKwJoXiAY2BH6xnUaS5NBG67mVY38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4jX8igxL; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aaeef97ff02so489086566b.1
        for <kvm@vger.kernel.org>; Sat, 01 Feb 2025 06:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738419946; x=1739024746; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZ0vZqIXBEKqFKncFREQpwOePkAbHQPGhvJcFWtumXA=;
        b=4jX8igxLLOudGDF8Wq5KPLJKLoNPb/xNqzb3540hd4aB0S7vdAGcCmD9yNFC8Te7sZ
         tKiVUpcoo0mX110ZqkyHQJfpRieniV6TvH7YOQK0xkgggg7GGSbV31buVE3RSEcfhhux
         Abf0rF128n/gbDFwhcx6ikYIgu1kHcmhGylDEEjEdklRGNB4PjfZ+y5MwkgElv3NLLjF
         OVrUnQLCGVKR0wcMwTa1izQGqiYxfW9ZYLKc1ocCuLjsaUf+ElRZWFgZuTK+nS2lamkl
         HL+05hiV+6S97Act1LMoME/YBJZz9f9D+yQusH+uc59vkYjJ7GHtKRoX2hn2VRmp8B8r
         t6mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738419946; x=1739024746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eZ0vZqIXBEKqFKncFREQpwOePkAbHQPGhvJcFWtumXA=;
        b=kwGYox2Zts8Re4e2pX+JO2pvoiZjEqT8FLKBjGnMkkWOCTQ3sm40VrlhA9TB1I9iWs
         NQE+7CUhcI0ABAxWfLauIvX0l9C2SDnMA0Qsoo9XHTK3oVRwQ2YIFUkYGCo2r1FUK2hl
         iez3y58Vy2QJbBR6Lpr2Xtn34jR/diACsdxQ1CNkvscDVqVRNbbToI9lVSlycAK/jPwP
         5Hz8WXOUiiX3tHUzgZ9iQ6blkiofq7k1UMIcHCKFirUbmmeRUSevrqcjgYKGH8rBgo5Y
         ycr8cuzgRAoqcAFXIcDp4x0cPDcQW5E8Ttn+SrC7GXKQUeHGJ9Sf/niybr2LylE9KyJA
         QMDw==
X-Forwarded-Encrypted: i=1; AJvYcCUWIonkfHIdsQ/k5D1D8rGvElfTTOVtluE/GjiLUaMVR4pEfaGJTLPAf+eKbThV6GkBNoA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMbOYcp8jgc4Zan+lmTQ5/upNWXKNV1XMY4LANDvClRJ3koriV
	gJx5odX8AIbPs7rKCJJ+G3w31AlZp8shch+NmusnKsFyJrT16S71qrYoUvkkFDQ+HhXuQghpeCh
	kxZysthNZbha2KxIh2TWIbvsgiovhTJru+g/F
X-Gm-Gg: ASbGncsWItzh+uIfegjpXIgtIi2UVNQvIF6h9rHE6SD++iR8bpHKKSNLNTRDFz2TCbu
	6AR6Y5g9zCd/Bcm+n3guUyCfSiGgA2Y57bD6QXW6WRUVu9vDIN9Kuhb7K0qbBH5tRgf4PSak=
X-Google-Smtp-Source: AGHT+IFNU50KGJzZgl7w7V83IWbYIOCrmGxy1Ru5bXtuLQdKA+rEmK/FcWEISxLcAC0MiPZn9JdBhR9NVHupPkR+kk0=
X-Received: by 2002:a17:907:2cc5:b0:aae:85b4:a07 with SMTP id
 a640c23a62f3a-ab6cfcb35b1mr1635306066b.8.1738419945558; Sat, 01 Feb 2025
 06:25:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250201005048.657470-1-seanjc@google.com>
In-Reply-To: <20250201005048.657470-1-seanjc@google.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Sat, 1 Feb 2025 06:25:34 -0800
X-Gm-Features: AWEUYZmHzRH4TAEFvkpdJYgx_73GLI504WWZIIxFen1KKjX6D7kitSz8ByVCMlo
Message-ID: <CAAH4kHY-Gt_6=cGL1VNsgow+XX_3wr_GxRE9hWbHomu+CaAgpw@mail.gmail.com>
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>, 
	Kirill Shutemov <kirill.shutemov@linux.intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Binbin Wu <binbin.wu@intel.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"Xiang, Qinglan" <qinglan.xiang@intel.com>, "Xu, Min M" <min.m.xu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2025 at 4:50=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Attempt to hack around the SNP/TDX guest MTRR disaster by hijacking
> x86_platform.is_untracked_pat_range() to force the legacy PCI hole, i.e.
> memory from TOLUD =3D> 4GiB, as unconditionally writeback.
>
> TDX in particular has created an impossible situation with MTRRs.  Becaus=
e
> TDX disallows toggling CR0.CD, TDX enabling decided the easiest solution
> was to ignore MTRRs entirely (because omitting CR0.CD write is obviously
> too simple).
>
> Unfortunately, under KVM at least, the kernel subtly relies on MTRRs to
> make ACPI play nice with device drivers.  ACPI tries to map ranges it fin=
ds
> as WB, which in turn prevents device drivers from mapping device memory a=
s
> WC/UC-.
>
> For the record, I hate this hack.  But it's the safest approach I can com=
e
> up with.  E.g. forcing ioremap() to always use WB scares me because it's
> possible, however unlikely, that the kernel could try to map non-emulated
> memory (that is presented as MMIO to the guest) as WC/UC-, and silently
> forcing those mappings to WB could do weird things.
>
> My initial thought was to effectively revert the offending commit and
> skip the cache disabling/enabling, i.e. the problematic CR0.CD toggling,
> but unfortunately OVMF/EDKII has also added code to skip MTRR setup. :-(
>

EDK2 has a bug tracker. Maybe this is still fixable on Intel's end.
Adding Qinglan, Isaku, and Min to comment.

> Sean Christopherson (2):
>   x86/mtrr: Return success vs. "failure" from guest_force_mtrr_state()
>   x86/kvm: Override low memory above TOLUD to WB when MTRRs are forced
>     WB
>
>  arch/x86/include/asm/mtrr.h        |  5 +++--
>  arch/x86/kernel/cpu/mtrr/generic.c | 11 +++++++----
>  arch/x86/kernel/kvm.c              | 31 ++++++++++++++++++++++++++++--
>  3 files changed, 39 insertions(+), 8 deletions(-)
>
>
> base-commit: fd8c09ad0d87783b9b6a27900d66293be45b7bad
> --
> 2.48.1.362.g079036d154-goog
>


--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

