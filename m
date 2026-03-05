Return-Path: <kvm+bounces-72774-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +AV/GWzfqGmjyAAAu9opvQ
	(envelope-from <kvm+bounces-72774-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 02:42:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D8B1209F66
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 02:42:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 68EE330004E1
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 01:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DBDE24336D;
	Thu,  5 Mar 2026 01:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iesnoR8t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9060313AA2D
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 01:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772674910; cv=none; b=ZDTSgWUyRtYzAAhqufPnHjcmmVAPnLIqabXMdwkeqg5dg1Sw8b7XkM5dJeKFfs1AmMkRfKa7ypMFAgwUu5807TobWKGjI8UHqrAHHqv92Ou7inodqIDb6AapXPqNh6PDFKElh5sQa24oCelK7FDEgDCvP3i228a0d1XvHaCKJ7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772674910; c=relaxed/simple;
	bh=7/+ihf6MeglMl37gZaW7faMNSP8BEfnn8RGSD6t4tkc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=niaJalnEMzAgvhzADUz+/eY7PBn9etdrvD1k9oondgYahf8nbBT2vzH1LSRa4M/FsZMBbNG6/RgTduhQh7EoT76qHiSCV8cojX50lWgbM5YiKIaeWDL3edsV0BHmuWSlmVxxgdh+OtMeDYhYATKlfQ/WzoII7YX5pCnZrapAQqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iesnoR8t; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae5031c6c5so183253635ad.3
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 17:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772674909; x=1773279709; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LHpAeCIu8R4XKk/BCF5t8aL8jR2BZgLlIWU/hH7XCgA=;
        b=iesnoR8thbEYi1K8eRYIDFr+l7Bi5yBntZQUI63AOSC6KMDVtWabO4M2PMO6vucU8H
         vKFPKCjjY4Y1B0ogX5e4rJqO9dpmJl/YkG3YFEbm9gHxvEh8xxoKjZenUogsYx4E1a1q
         a5r+vr4GuEGzv2KOPTyR7FlhXXqK252MRyrPlawhsGqDFVlX8MQIgkCAhUcGdr25wwyp
         HWho2BKM9f/LHolvptTIwCvBQqJC9tMBpMFRYcU1+KvkLWOvrkOX6pQY5+YW8DCJcEpd
         clHN2rUzAJYO1wDEGUClHNg4cabd/wGGapQqt52mn2HmH4oa5gZVMqZ9LglFEfIz84KX
         D4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772674909; x=1773279709;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LHpAeCIu8R4XKk/BCF5t8aL8jR2BZgLlIWU/hH7XCgA=;
        b=gqL6jma7cMH2XbAT7lbJEb/OWJQdBNIwyf+I/AWm7/Fbx0xvmqtBaqrmNxSJD0JNiX
         J8DoTcpp5vZlPS1ekm/GA8WYqTviBE6utmn8+X+ixayzli0217Ic77m/TyQr6aKoGQ3J
         4o+ARQlfItAFVFgxe3bMWXNh8HwkgkwVev2y/MlAEnPQLfBl89x5mDDb0zfg4K8+lL/X
         iwzRECu5SPyWfdnyRecpQX0ncjYIpqkPLJrNrIKASOlYcfBuZ23mttcFaLEuOlA+A+q7
         ULyr15+6vYUPGoevofvBkl/eewIHJ4FSwwY//OzBHtvF5EvhT0qoMyxTFCMo8vc9Gw9J
         OY/A==
X-Forwarded-Encrypted: i=1; AJvYcCU59ptEbOX/ATwtUudzwTYvZVrvzoSiR7hUdObdCPDkrm0XIWEMjKq4qW3o6zVVeHnd17g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/0nh7huyxZ4SaUEsDVVZqj3XiKnR+CbI3phyqpYot9Srk26m9
	QayOxSMs49WCfUJRAJTCkYOmX6DJYVRN+BMrmx40NGR7v4157JdxYqn/lR8055jXxAgFv9ti9gk
	jgipjsg==
X-Received: from plhc2.prod.google.com ([2002:a17:903:2342:b0:2ae:4d0d:bcb3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f541:b0:2aa:d65f:47a2
 with SMTP id d9443c01a7336-2ae6ab06068mr42866935ad.41.1772674908795; Wed, 04
 Mar 2026 17:41:48 -0800 (PST)
Date: Wed, 4 Mar 2026 17:41:47 -0800
In-Reply-To: <20260112235408.168200-4-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112235408.168200-1-chang.seok.bae@intel.com> <20260112235408.168200-4-chang.seok.bae@intel.com>
Message-ID: <aajfW5k7H78FDHJC@google.com>
Subject: Re: [PATCH v2 03/16] KVM: x86: Implement accessors for extended GPRs
From: Sean Christopherson <seanjc@google.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	chao.gao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0D8B1209F66
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72774-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Jan 12, 2026, Chang S. Bae wrote:
> Add helpers to directly read and write EGPRs (R16=E2=80=93R31).
>=20
> Unlike legacy GPRs, EGPRs are not cached in vcpu->arch.regs[]. Their
> contents remain live in hardware. If preempted, the EGPR state is
> preserved in the guest XSAVE buffer.
>=20
> The Advanced Performance Extensions (APX) feature introduces EGPRs as an
> XSAVE-managed state component. The new helpers access the registers
> directly between kvm_fpu_get() and kvm_fpu_put().
>=20
> Callers should ensure that EGPRs are enabled before using these helpers.
>=20
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
> ---
> V1 -> V2: Move _kvm_read_egpr()/_kvm_write_egpr() to x86.c (Paolo)
> ---
>  arch/x86/kvm/x86.c | 70 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 69 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9857b4d319ed..edac2ec11e2f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1256,13 +1256,81 @@ static inline u64 kvm_guest_supported_xfd(struct =
kvm_vcpu *vcpu)
>  #endif
> =20
>  #ifdef CONFIG_KVM_APX
> +/*
> + * Accessors for extended general-purpose registers. binutils >=3D 2.43 =
can
> + * recognize those register symbols.
> + */
> +
> +static void _kvm_read_egpr(int reg, unsigned long *data)

Double underscores please (ignore the bad prior art).  And please don't use=
 an
out-param with a void return.  That's "necessary" for e.g. _kvm_write_avx_r=
eg()
because the value is large, but this is just 64-bits.

> +{
> +	/* mov %r16..%r31, %rax */
> +	switch (reg) {
> +	case __VCPU_XREG_R16: asm(".byte 0xd5, 0x48, 0x89, 0xc0" : "=3Da"(*data=
)); break;
> +	case __VCPU_XREG_R17: asm(".byte 0xd5, 0x48, 0x89, 0xc8" : "=3Da"(*data=
)); break;
> +	case __VCPU_XREG_R18: asm(".byte 0xd5, 0x48, 0x89, 0xd0" : "=3Da"(*data=
)); break;
> +	case __VCPU_XREG_R19: asm(".byte 0xd5, 0x48, 0x89, 0xd8" : "=3Da"(*data=
)); break;
> +	case __VCPU_XREG_R20: asm(".byte 0xd5, 0x48, 0x89, 0xe0" : "=3Da"(*data=
)); break;
> +	case __VCPU_XREG_R21: asm(".byte 0xd5, 0x48, 0x89, 0xe8" : "=3Da"(*data=
)); break;
> +	case __VCPU_XREG_R22: asm(".byte 0xd5, 0x48, 0x89, 0xf0" : "=3Da"(*data=
)); break;
> +	case __VCPU_XREG_R23: asm(".byte 0xd5, 0x48, 0x89, 0xf8" : "=3Da"(*data=
)); break;
> +	case __VCPU_XREG_R24: asm(".byte 0xd5, 0x4c, 0x89, 0xc0" : "=3Da"(*data=
)); break;
> +	case __VCPU_XREG_R25: asm(".byte 0xd5, 0x4c, 0x89, 0xc8" : "=3Da"(*data=
)); break;
> +	case __VCPU_XREG_R26: asm(".byte 0xd5, 0x4c, 0x89, 0xd0" : "=3Da"(*data=
)); break;
> +	case __VCPU_XREG_R27: asm(".byte 0xd5, 0x4c, 0x89, 0xd8" : "=3Da"(*data=
)); break;
> +	case __VCPU_XREG_R28: asm(".byte 0xd5, 0x4c, 0x89, 0xe0" : "=3Da"(*data=
)); break;
> +	case __VCPU_XREG_R29: asm(".byte 0xd5, 0x4c, 0x89, 0xe8" : "=3Da"(*data=
)); break;
> +	case __VCPU_XREG_R30: asm(".byte 0xd5, 0x4c, 0x89, 0xf0" : "=3Da"(*data=
)); break;
> +	case __VCPU_XREG_R31: asm(".byte 0xd5, 0x4c, 0x89, 0xf8" : "=3Da"(*data=
)); break;

Oof, is this really the most effecient way to encode this?  I guess so sinc=
e that's
what all the SIMD instruction do, but ugh.=20

> +	default: BUG();
> +	}
> +}
> +
> +static void _kvm_write_egpr(int reg, unsigned long *data)

And then take a value, not a pointer.

> +{
> +	/* mov %rax, %r16...%r31*/
> +	switch (reg) {
> +	case __VCPU_XREG_R16: asm(".byte 0xd5, 0x18, 0x89, 0xc0" : : "a"(*data)=
); break;
> +	case __VCPU_XREG_R17: asm(".byte 0xd5, 0x18, 0x89, 0xc1" : : "a"(*data)=
); break;
> +	case __VCPU_XREG_R18: asm(".byte 0xd5, 0x18, 0x89, 0xc2" : : "a"(*data)=
); break;
> +	case __VCPU_XREG_R19: asm(".byte 0xd5, 0x18, 0x89, 0xc3" : : "a"(*data)=
); break;
> +	case __VCPU_XREG_R20: asm(".byte 0xd5, 0x18, 0x89, 0xc4" : : "a"(*data)=
); break;
> +	case __VCPU_XREG_R21: asm(".byte 0xd5, 0x18, 0x89, 0xc5" : : "a"(*data)=
); break;
> +	case __VCPU_XREG_R22: asm(".byte 0xd5, 0x18, 0x89, 0xc6" : : "a"(*data)=
); break;
> +	case __VCPU_XREG_R23: asm(".byte 0xd5, 0x18, 0x89, 0xc7" : : "a"(*data)=
); break;
> +	case __VCPU_XREG_R24: asm(".byte 0xd5, 0x19, 0x89, 0xc0" : : "a"(*data)=
); break;
> +	case __VCPU_XREG_R25: asm(".byte 0xd5, 0x19, 0x89, 0xc1" : : "a"(*data)=
); break;
> +	case __VCPU_XREG_R26: asm(".byte 0xd5, 0x19, 0x89, 0xc2" : : "a"(*data)=
); break;
> +	case __VCPU_XREG_R27: asm(".byte 0xd5, 0x19, 0x89, 0xc3" : : "a"(*data)=
); break;
> +	case __VCPU_XREG_R28: asm(".byte 0xd5, 0x19, 0x89, 0xc4" : : "a"(*data)=
); break;
> +	case __VCPU_XREG_R29: asm(".byte 0xd5, 0x19, 0x89, 0xc5" : : "a"(*data)=
); break;
> +	case __VCPU_XREG_R30: asm(".byte 0xd5, 0x19, 0x89, 0xc6" : : "a"(*data)=
); break;
> +	case __VCPU_XREG_R31: asm(".byte 0xd5, 0x19, 0x89, 0xc7" : : "a"(*data)=
); break;
> +	default: BUG();
> +	}
> +}

