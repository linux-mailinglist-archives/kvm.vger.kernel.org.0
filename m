Return-Path: <kvm+bounces-47196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AA3CABE7E7
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 01:11:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD621188AB33
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 23:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A172C25EFB5;
	Tue, 20 May 2025 23:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sxvHxGf9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4590B2571A0
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 23:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747782694; cv=none; b=ojU2K1Se8Np0DQaW7LCOSr9WvC0nNFOaEsSK2fEjC82HvOfmJOhua+Tpd8ryd5MJ/o9Fb/IG8AkMzikjyvbN99bfmsg5u92uTseafIjFklDFV+0cwTzhYm3jzlO6zCYvkBRpTvNa188+GdmNa5J/UuZb1g0qWxiJf65hLPBKq9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747782694; c=relaxed/simple;
	bh=yx358BgpArNy/Q/0sUeC3qJnGUiZZ6Wb/XlUO2517zs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oV3jicvQ5di4z5n0I0DHsscXr/RSttznqYfcU14UXGZXnqKjICtgoWXDaLAOr1UJ9XqYzU+EsNU1GlYYNHMg8KXfNOIo3+Hm9SAol/Rl7gv/41zvPUGBNWk7FGeLt/DeqD2VCxYmZbt88pR4vmqjeKVMluN0OdKBufMC1Z8fycg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sxvHxGf9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e78145dc4so6571927a91.2
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 16:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747782691; x=1748387491; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mulczgVyojG9WOnzwZeuMO5RYScv6qpswrU16wfgZMw=;
        b=sxvHxGf9KVgBH56GbFQ3kNPtc69mmqstk443SBobjw1OhkWYF65G3SyDqCxt6y0tVh
         zd2JVeDDyD75N22kPD1nRAYMij6Xu0CIp1GQ3V9DCAI4fsUJdimZHz61GjhM45ne3KXf
         M+ba5H9abghVDc5xirGEuWrKo1+QdAczQs4WZCsEj56vSbYUW8utEE/X8lTkIrnPl0VX
         g/6mYkAUmcd0OXWIhH6Sl3D0YhH5bjAadc2HUUKuxkzuzG41nagRdygJWu0vhWi7DYzX
         2W4QJFxeOcGOvdnb5UNdJJs2UWtoEbMPSswOMxj5tVcmhAnXUymFghSVe1Btf2HCvPFA
         JFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747782691; x=1748387491;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mulczgVyojG9WOnzwZeuMO5RYScv6qpswrU16wfgZMw=;
        b=wTYPpLCnUh+381cIC9Fz58rqomxAIL/dDIof6nXVGP5SdOQ4RXhtp5U1pO8DL8bVQg
         P7HzqGUTLIbe9p+5QhihEqhThaAd1JK09XaIzPGjlKNoM4wTC7RujnWY7BaeYTog18ER
         g8fY/eNBLkYvs0pfpP0N4msNxPp54YDifohezEeeYrHdyuHAsQB1EuxMEmMVZHrKJLPS
         U8TVhHGg28EG9eyndQu1JYv+rLU69rvNgERXxLLoTswd9Z7QIoKxZs8CI9kf9Ixvb4HV
         hvO8Ed3+1atPSKK46A39YunFFmFgINpsItFoN/5lAinmGYjiiZwVBSNbmZ3IHQJFdFvv
         6J6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXEocPIHBB505rvoMf2aZ/AY56GK/r1UPHE8Qsrp38o1qFLBXvyEBZflEpVXlgpSpg3J4s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrTo6ZkefimdpMKf1QM9sno9+jDDShD8SXa3f8eBD6Fa+JkzYs
	Cb6WRB8RRwAcIByKXsSjI0pi0F4id0kehMIafyfrZsVmyAcDmb65lJfYM57EMNW6zS4Eim6JPwk
	N1xkrdQ==
X-Google-Smtp-Source: AGHT+IFHwoUFVduWS8xWH3QqWe+KZ7CkAWQ6KSZ+E9pnLyiAzh7OsLs8F5OHZFLHL9z8aPwvcrYZtP0kiDs=
X-Received: from pjuu15.prod.google.com ([2002:a17:90b:586f:b0:30e:7783:edb6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:350e:b0:310:8d7a:cece
 with SMTP id 98e67ed59e1d1-3108d7acedbmr677737a91.35.1747782691545; Tue, 20
 May 2025 16:11:31 -0700 (PDT)
Date: Tue, 20 May 2025 16:11:29 -0700
In-Reply-To: <dca247173aace1269ce8512ae2d3797289bb1718.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516215422.2550669-1-seanjc@google.com> <20250516215422.2550669-3-seanjc@google.com>
 <219b6bd5-9afe-4d1c-aaab-03e5c580ce5c@redhat.com> <aCtQlanun-Kaq4NY@google.com>
 <dca247173aace1269ce8512ae2d3797289bb1718.camel@intel.com>
Message-ID: <aC0MIUOTQbb9-a7k@google.com>
Subject: Re: [PATCH v3 2/3] KVM: x86: Use kvzalloc() to allocate VM struct
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"vipinsh@google.com" <vipinsh@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2025, Kai Huang wrote:
> On Mon, 2025-05-19 at 08:39 -0700, Sean Christopherson wrote:
> > +static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
> > +					enum pg_level level, kvm_pfn_t pfn)
> >  {
> >  	struct page *page =3D pfn_to_page(pfn);
> >  	int ret;
> > @@ -3507,10 +3507,14 @@ int __init tdx_bringup(void)
> >  	r =3D __tdx_bringup();
> >  	if (r) {
> >  		/*
> > -		 * Disable TDX only but don't fail to load module if
> > -		 * the TDX module could not be loaded.  No need to print
> > -		 * message saying "module is not loaded" because it was
> > -		 * printed when the first SEAMCALL failed.
> > +		 * Disable TDX only but don't fail to load module if the TDX
> > +		 * module could not be loaded.  No need to print message saying
> > +		 * "module is not loaded" because it was printed when the first
> > +		 * SEAMCALL failed.  Don't bother unwinding the S-EPT hooks or
> > +		 * vm_size, as kvm_x86_ops have already been finalized (and are
> > +		 * intentionally not exported).  The S-EPT code is unreachable,
> > +		 * and allocating a few more bytes per VM in a should-be-rare
> > +		 * failure scenario is a non-issue.
> >  		 */
> >  		if (r =3D=3D -ENODEV)
> >  			goto success_disable_tdx;
> > @@ -3524,3 +3528,19 @@ int __init tdx_bringup(void)
> >  	enable_tdx =3D 0;
> >  	return 0;
> >  }
> > +
> > +
> > +void __init tdx_hardware_setup(void)
> > +{
> > +	/*
> > +	 * Note, if the TDX module can't be loaded, KVM TDX support will be
> > +	 * disabled but KVM will continue loading (see tdx_bringup()).
> > +	 */
>=20
> This comment seems a little bit weird to me.  I think what you meant here=
 is the
> @vm_size and those S-EPT ops are not unwound while TDX cannot be brought =
up but
> KVM is still loaded.

This comment is weird?  Or the one in tdx_bringup() is weird?  The sole int=
ent
of _this_ comment is to clarify that KVM could still end up running load wi=
th TDX
disabled.  The comment about not unwinding S-EPT resides in tdx_bringup(), =
because
that's where the actual decision to not reject KVM load and to not undo the=
 setup
lives.

> > +
> > +	vt_x86_ops.link_external_spt =3D tdx_sept_link_private_spt;
> > +	vt_x86_ops.set_external_spte =3D tdx_sept_set_private_spte;
> > +	vt_x86_ops.free_external_spt =3D tdx_sept_free_private_spt;
> > +	vt_x86_ops.remove_external_spte =3D tdx_sept_remove_private_spte;
> > +	vt_x86_ops.protected_apic_has_interrupt =3D tdx_protected_apic_has_in=
terrupt;
> > +}
> > diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> > index 51f98443e8a2..ca39a9391db1 100644
> > --- a/arch/x86/kvm/vmx/tdx.h
> > +++ b/arch/x86/kvm/vmx/tdx.h
> > @@ -8,6 +8,7 @@
> >  #ifdef CONFIG_KVM_INTEL_TDX
> >  #include "common.h"
> > =20
> > +void tdx_hardware_setup(void);
> >  int tdx_bringup(void);
> >  void tdx_cleanup(void);
> > =20
>=20
> There's a build error when CONFIG_KVM_INTEL_TDX is off:
>=20
> vmx/main.c: In function =E2=80=98vt_hardware_setup=E2=80=99:
> vmx/main.c:34:17: error: implicit declaration of function =E2=80=98tdx_ha=
rdware_setup=E2=80=99;
> did you mean =E2=80=98vmx_hardware_setup=E2=80=99? [-Wimplicit-function-d=
eclaration]
>    34 |                 tdx_hardware_setup();
>       |                 ^~~~~~~~~~~~~~~~~~
>       |                 vmx_hardware_setup
>=20
> .. for which you need a stub for tdx_hardware_setup() when CONFIG_KVM_INT=
EL_TDX
> is off.

Not in kvm-x86/next, commit 907092bf7cbd ("KVM: VMX: Clean up and macrofy x=
86_ops")
buried all of vt_hardware_setup() behind CONFIG_KVM_INTEL_TDX=3Dy.

> And one more thing:
>=20
> With the above patch, we still have below code in vt_init():
>=20
>         /*
>          * TDX and VMX have different vCPU structures.  Calculate the
>          * maximum size/align so that kvm_init() can use the larger
>          * values to create the kmem_vcpu_cache.
>          */
>         vcpu_size =3D sizeof(struct vcpu_vmx);
>         vcpu_align =3D __alignof__(struct vcpu_vmx);
>         if (enable_tdx) {
>                 vcpu_size =3D max_t(unsigned, vcpu_size,
>                                 sizeof(struct vcpu_tdx));
>                 vcpu_align =3D max_t(unsigned, vcpu_align,
>                                 __alignof__(struct vcpu_tdx));
>                 kvm_caps.supported_vm_types |=3D BIT(KVM_X86_TDX_VM);
>         }
>=20
> It's kinda ugly too IMHO.
>=20
> Since we already have @vm_size in kvm_x86_ops, how about also adding vcpu=
_size
> and vcpu_align to it?  Then they can be treated in the same way as vm_siz=
e for
> TDX.
>=20
> They are not needed for SVM, but it doesn't hurt that much?

I'd rather not.  vt_init() already needs to be aware of TDX, e.g. to call i=
nto
tdx_bringup() in the first place.  Shoving state into kvm_x86_ops that is o=
nly
ever used in vt_init() (an __init function at that) isn't a net positive.

Putting the fields in kvm_x86_init_ops would be better, but I still don't t=
hink
the complexity and indirection is justified.  Bleeding gory TDX details int=
o the
common code is undesirable, but I don't see the size of vcpu_tdx or the fac=
t that
enable_tdx=3D=3Dtrue means KVM_X86_TDX_VM is supported as being information=
 with
hiding.

kvm_x86_ops.vm_size is a means to an end.  E.g. if kvm_vcpu_cache didn't ex=
ist,
then we'd probably want/need kvm_x86_ops.vcpu_size, but it does exist, so..=
.

