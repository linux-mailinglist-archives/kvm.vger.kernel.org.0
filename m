Return-Path: <kvm+bounces-9524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 672FB86146B
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 15:46:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 854331C20CDA
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 14:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF1B8C06;
	Fri, 23 Feb 2024 14:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="17/mIRTk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EE86119
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 14:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708699519; cv=none; b=B+kP9YWdbNUkNljAF3B/hDp62j7IOk5hgEQpe52KJcP1TzK2biDWo3pWAtoxIss5Iun1/kk19VFWf3F5lqZx4I37oG99fbOJKtBCX5iwBUGCDHSKqXcsYn8K2DS9zL9WwDpiyuaMpG4amXWmpVnM0KiIiePuzPZW7PoTUrtVLKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708699519; c=relaxed/simple;
	bh=eO90BSQ9sClZwCZjYPT6YEKAkQek8EMTFy09R75oy7Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MJTx23GJljFUSXO82bgIBDxlkfynw1mR5RYm6mhxTLKolDQSwkZpZTC2sInIFZxqxm7JpsDWRwymy96vvh+ndsMxVCu9pMa4XRlM+dRsFGVJV0RkoOG8uQFWKAJu/A9yEhpqmFqNYX3OsHdSBft+9FuRMzN5RqI9BZUHez8kT38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=17/mIRTk; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26845cdso1131346276.3
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 06:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708699516; x=1709304316; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4sx2PhzYT6bX0Zx62enZmD7C7A3SWfoCmRN0DeqiXBk=;
        b=17/mIRTkihanA55DSq3nng5zKRaWkZoKf8B2NWgqodCb1uKbNy9zTuTickgQLYNVco
         6kUYNQKiOSWFCFPmGnXqDwSPSCVoDVusTl9MzAxXNfBKCYeKfUchMRwqF5F8fw7phJpl
         EJvkDmuWPVFMifzZRcmNZR+6ES7+LrQXxDM7JgvOXjCwDtjQ5jVEOSwXTGOvdfmug4WM
         5MDG6sSB23nzq3Ov4Ivs7Es4WBWrej7BN5nT2xpOTZGouNEQWsnGnz2m26etFjpcYCAy
         wz9iuKRL+s4t6qMBOP6pJeqtNfe/TDldhRYaNtcnFhMWWPUyRCM9NWh6xycuJ8rAgTq6
         VMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708699516; x=1709304316;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4sx2PhzYT6bX0Zx62enZmD7C7A3SWfoCmRN0DeqiXBk=;
        b=bSDSABfOsPFV7JTdTLlWS6yb5HKFfci6BJXnblYNItxwr4C2gEQ60vAEUWi9Kk6uRT
         M219xXdTSwQdpGdoSL+I0Kv78gLw1BPccU90U2feSjm07+3fo626/1dwLEeF4HYEOR6J
         FppaCcPlHcmPJwo0dkliTr6ahWsc0FZisH0OqKXgvV7lsImkiWbETNTk2RrrCID6fsTk
         g5pwR/KIoDkD6FslkxoZ5ZO/ksz7Vbi1TQzFzBdzNsGYS5RtFFYuvSf02o6SCm0d0G6H
         DIOIsVWWGdTtDECfvobDFGSL+Ja6MmpIgAM45t1Z8YHDKvCXpeFYw/uEkH/WvIVpQQoh
         JuGg==
X-Forwarded-Encrypted: i=1; AJvYcCWCNFQNML+gV8Qp9GpbSjTz7UbBf4mgpoh8pHe+lLKUsNo6femhtSm2bC0P+Y39KR8vb4SZ4f5SQJ82sVSs4/VS+eDj
X-Gm-Message-State: AOJu0YzjTYcTiIpsgZnBxXTI/WcZlqtH9wceq6SthUq1q0a8YckTP2J7
	xcU71IaaUccSIcEnaGH3B/9dNht/5P7t4pPD5jRoC2qqGxD11EEwH2ebp1nFUtH5yhZeBzTO/XL
	L5g==
X-Google-Smtp-Source: AGHT+IHXGvEXS7hSYx/wrQvinEU03fRZgUsQ6u3pq19wu072nmzc0allXRkp54uWZF0VWpcmhhAtqlrCLIk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1145:b0:dbd:b165:441 with SMTP id
 p5-20020a056902114500b00dbdb1650441mr6757ybu.0.1708699516616; Fri, 23 Feb
 2024 06:45:16 -0800 (PST)
Date: Fri, 23 Feb 2024 06:45:14 -0800
In-Reply-To: <20240223104009.632194-3-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223104009.632194-1-pbonzini@redhat.com> <20240223104009.632194-3-pbonzini@redhat.com>
Message-ID: <Zdivel5TiNLG8poV@google.com>
Subject: Re: [PATCH v2 02/11] KVM: introduce new vendor op for KVM_GET_DEVICE_ATTR
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	aik@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

KVM: x86:

On Fri, Feb 23, 2024, Paolo Bonzini wrote:
> Allow vendor modules to provide their own attributes on /dev/kvm.
> To avoid proliferation of vendor ops, implement KVM_HAS_DEVICE_ATTR
> and KVM_GET_DEVICE_ATTR in terms of the same function.  You're not
> supposed to use KVM_GET_DEVICE_ATTR to do complicated computations,
> especially on /dev/kvm.
>=20
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-Id: <20240209183743.22030-3-pbonzini@redhat.com>

Another double-stamp that needs to be dropped.

> Reviewed-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/x86.c                 | 52 +++++++++++++++++++-----------
>  3 files changed, 36 insertions(+), 18 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kv=
m-x86-ops.h
> index 378ed944b849..ac8b7614e79d 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -122,6 +122,7 @@ KVM_X86_OP(enter_smm)
>  KVM_X86_OP(leave_smm)
>  KVM_X86_OP(enable_smi_window)
>  #endif
> +KVM_X86_OP_OPTIONAL(dev_get_attr)
>  KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
>  KVM_X86_OP_OPTIONAL(mem_enc_register_region)
>  KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)

...

> -static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
> +static int __kvm_x86_dev_get_attr(struct kvm_device_attr *attr, u64 *val=
)
>  {
> -	u64 __user *uaddr =3D kvm_get_attr_addr(attr);
> +	int r;
> =20
>  	if (attr->group)
>  		return -ENXIO;
> =20
> +	switch (attr->attr) {
> +	case KVM_X86_XCOMP_GUEST_SUPP:
> +		r =3D 0;
> +		*val =3D kvm_caps.supported_xcr0;
> +		break;
> +	default:
> +		r =3D -ENXIO;
> +		if (kvm_x86_ops.dev_get_attr)
> +			r =3D kvm_x86_ops.dev_get_attr(attr->attr, val);

If you're going to add an entry in kvm-x86-ops.h, might as well use static_=
call().,

> +		break;
> +	}
> +
> +	return r;
> +}
> +
> +static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
> +{
> +	u64 __user *uaddr;
> +	int r;
> +	u64 val;
> +
> +	r =3D __kvm_x86_dev_get_attr(attr, &val);
> +	if (r < 0)
> +		return r;
> +
> +	uaddr =3D kvm_get_attr_addr(attr);
>  	if (IS_ERR(uaddr))
>  		return PTR_ERR(uaddr);

Way off topic, do we actually need the sanity check that userspace didn't p=
rovide
garbage in bits 63:32 when running on a 32-bit kernel?  Aside from the fact=
 that
no one uses 32-bit KVM, if userspace provides a pointer that happens to res=
olve
to an address in the task's address space, so be it, userspace gets to keep=
 its
pieces.  There's no danger to the kernel because KVM correctly uses the che=
cked
versions of {get,put}_user().

The paranoid check came in with the TSC attribute

  static inline void __user *kvm_get_attr_addr(struct kvm_device_attr *attr=
)
  {
	void __user *uaddr =3D (void __user*)(unsigned long)attr->addr;

	if ((u64)(unsigned long)uaddr !=3D attr->addr)
		return ERR_PTR_USR(-EFAULT);
	return uaddr;
  }

I was responsible for the paranoia, though Oliver gets blamed because the f=
ixup
got squashed[1].  And the only reason I posted the paranoid code was becaus=
e the
very original code did:

  arch/x86/kvm/x86.c: In function =E2=80=98kvm_arch_tsc_get_attr=E2=80=99:
  arch/x86/kvm/x86.c:4947:22: error: cast to pointer from integer of differ=
ent size
   4947 |  u64 __user *uaddr =3D (u64 __user *)attr->addr;
        |                      ^
  arch/x86/kvm/x86.c: In function =E2=80=98kvm_arch_tsc_set_attr=E2=80=99:
  arch/x86/kvm/x86.c:4967:22: error: cast to pointer from integer of differ=
ent size
   4967 |  u64 __user *uaddr =3D (u64 __user *)attr->addr;we ended up=20

And as I recently found out[2], u64_to_user_ptr() exists for this exact rea=
son.

I vote to convert to u64_to_user_ptr() as a prep patch, which would make th=
is all
quite a bit more readable.

[1] https://lore.kernel.org/all/20211007231647.3553604-1-seanjc@google.com
[2] https://lore.kernel.org/all/20240222100412.560961-1-arnd@kernel.org

