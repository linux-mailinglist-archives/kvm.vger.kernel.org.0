Return-Path: <kvm+bounces-50521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7BE3AE6C97
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 18:39:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52C9B5A6F9F
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 16:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96791286430;
	Tue, 24 Jun 2025 16:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YCj1ZcTN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574392E612F
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 16:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750783110; cv=none; b=aULR00g9poJL7VU4jnhDniNHroBv5oELPhvp0O5o8FF90+J4v5F7dIYJfrH0nz9VkLRK5l9ZDiJ6ragwDvCKmesjkDDm1+owNsJYN5/oNTSQpIiRP7tmmcOQIRhUUdAUotRMXbyE8pyWOFtNlw94EBe6igDhkJxK5Svguuaachc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750783110; c=relaxed/simple;
	bh=EebWpedUzCM+qbl6K91Fj9ZaTMQ5QamWCYeabLfGllY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nndl7ThIiqkeRK4wB90iP4tweivC6ea4vBFDIlXqtEr9gVbuoWb8riqfW4XVLTeONdGfC6mqJxdJsS43GAYSJmqBZ3CLEHnDpHnieKhADoTWr6veFxyHIcbiR/aHhKNZFWde3bUewASljoH/AYP2l+bYtdjVwcyedXWyvA+gH2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YCj1ZcTN; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31220ecc586so633225a91.2
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 09:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750783109; x=1751387909; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B7NW/675HsH3/K7ui/6HuJARKanzqs1doi/k1ds4JNc=;
        b=YCj1ZcTNzr5tpbVoOAGRbiGtm/tolzAW+ZiHAuzArgaeGcCALEkZ2TZNVyg2eE0TVk
         70sAFJd8wy5uqPIsAPXhP3pyX4qLtflOcAnTMxULVjNlxVCu3uHgNVVkCuCY3mpI/kzQ
         rMMC/w4TGM4oWvCBhkrGZ3VLbvD4jUj3n6+v80bBF+8rqRSckf+9ugzG+qxTRcDGJUub
         2SCihjahxJ8pAlCHcFX4EcYJbGqrcRrdu1z3ckrngYp18vXnToBZuKy6sjjIf5A2xDWj
         kYvoFml9xz4QP+aiIUeO5zgaSj8YHmHiAFJ1CVF/qHjZCgdeMiMnTloGeDqc0pGv4zlv
         iyNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750783109; x=1751387909;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=B7NW/675HsH3/K7ui/6HuJARKanzqs1doi/k1ds4JNc=;
        b=XfWAWFhtti9nil+jhfZX9U0gNQoGJBvNlNFDHaRvG/cpzrsAuAGm2umzm3PPiDigR4
         1lMEt2MuwDNn9fgwCyDDzqPymRSPYRLY1XxWW9+ozHfRTBS7ISu8ucLsKq762BU9qLVi
         pnQd6AlROd48D730beq0jzxD+kej7gm1AfcmKzJy6X1ONoe9UgDWbCfNCrvWAIgb89fU
         pN2yirNOUl0q9cVZmOr1kQBGDKVCrc3evyYT4DDDqTq7RzMR1REyIVcnQQ0be65fDEe5
         qAnQ+qIHjAcPK1i+2Ztki4XP5W9pdeyuZfIOjf43lK0qeNIbP5KaBuYg/UecRFwOPGIc
         IhUg==
X-Forwarded-Encrypted: i=1; AJvYcCWtz0CzDD6xO0WdBxE83O6waqllGB/0qbtN758bS40t5miKmQmc8STMaMGnxNLS5BVa3y0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxOVikMiMDL08Y7Jiq/F/xMoCDEy84q2Q79YBKQSTJIfrhM1Rc
	Ey7MdkVHZJ32WAuItu+1rpNxrKJ6TobjaElcbMnET682v/MwV5qC0+9ynupBCP1GktqlDuAzvXF
	6ga6U6Q==
X-Google-Smtp-Source: AGHT+IFSYTC92+/PTsuDg1Pvm55pwf9x/qmTZ1t5qnv2amAxjN+sFAPaHCtEKUyRAUZ6yqmBHQHbsbxABWc=
X-Received: from pjqq16.prod.google.com ([2002:a17:90b:5850:b0:313:245:8921])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:bd86:b0:312:e1ec:de44
 with SMTP id 98e67ed59e1d1-3159d8d9c32mr19459176a91.27.1750783108751; Tue, 24
 Jun 2025 09:38:28 -0700 (PDT)
Date: Tue, 24 Jun 2025 09:38:27 -0700
In-Reply-To: <20250328171205.2029296-16-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250328171205.2029296-1-xin@zytor.com> <20250328171205.2029296-16-xin@zytor.com>
Message-ID: <aFrUg4BB-MXuYi3L@google.com>
Subject: Re: [PATCH v4 15/19] KVM: x86: Allow FRED/LKGS to be advertised to guests
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, andrew.cooper3@citrix.com, luto@kernel.org, 
	peterz@infradead.org, chao.gao@intel.com, xin3.li@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

The shortlog (and changelog intro) are wrong.  KVM isn't allowing FRED/LKGS=
 to
be advertised to the guest.  Userspace can advertise whatever it wants.  Th=
e guest
will break badly without KVM support, but that doesn't stop userspace from
advertising a bogus vCPU model.

  KVM: x86: Advertise support for FRED/LKGS to userspace

On Fri, Mar 28, 2025, Xin Li (Intel) wrote:
> From: Xin Li <xin3.li@intel.com>
>=20
> Allow FRED/LKGS to be advertised to guests after changes required to

Please explain what LKGS is early in the changelog.  I assumed it was a fea=
ture
of sorts; turns out it's a new instruction.

Actually, why wait this long to enumerate support for LKGS?  I.e. why not h=
ave a
patch at the head of the series to enumerate support for LKGS?  IIUC, LKGS =
doesn't
depend on FRED.

> enable FRED in a KVM guest are in place.
>=20
> LKGS is introduced with FRED to completely eliminate the need to swapgs
> explicilty, because
>=20
> 1) FRED transitions ensure that an operating system can always operate
>    with its own GS base address.
>=20
> 2) LKGS behaves like the MOV to GS instruction except that it loads
>    the base address into the IA32_KERNEL_GS_BASE MSR instead of the
>    GS segment=E2=80=99s descriptor cache, which is exactly what Linux ker=
nel
>    does to load a user level GS base.  Thus there is no need to SWAPGS
>    away from the kernel GS base and an execution of SWAPGS causes #UD
>    if FRED transitions are enabled.
>=20
> A FRED CPU must enumerate LKGS.  When LKGS is not available, FRED must
> not be enabled.
>=20
> Signed-off-by: Xin Li <xin3.li@intel.com>
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 5e4d4934c0d3..8f290273aee1 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -992,6 +992,8 @@ void kvm_set_cpu_caps(void)
>  		F(FZRM),
>  		F(FSRS),
>  		F(FSRC),
> +		F(FRED),
> +		F(LKGS),

These need to be X86_64_F, no?

>  		F(AMX_FP16),
>  		F(AVX_IFMA),
>  		F(LAM),
> --=20
> 2.48.1
>=20

