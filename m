Return-Path: <kvm+bounces-36669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78489A1DB05
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 18:09:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D8887A3DDE
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 17:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF848189BB1;
	Mon, 27 Jan 2025 17:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KV/fn+Qw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E28188736
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 17:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737997747; cv=none; b=SbWlVjUv20LFsz/+bukby9Guy1+1MszaoFqBbGo/yNO6+F4n0bGT5tsvJbb1I1Jd15JUaZC6OSn3HQsglkzjWpDSDBsFxhgu/LwJuBfhNEGLwXnRsR+bt5HvkEQtymwB4CF9AG1QJTJr2CJfUhn+a1z8y6Q8kpkPU36OjJliwKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737997747; c=relaxed/simple;
	bh=zQrk1uIf3lMPBaWp52ewOBQRuI5DgfVodYnU/7Wes/g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FPYoF9mBOgpTx2fkQvBli3Rga/XvhDvlIxdqgDp9ZOvHcYDIWNSbcoh+iEl8mkCMaR5kSjxwsJkOP3Roe2OWXPwpakWk+CQdjSfGdgUcT+SjUK9HCOfg+OREw7rUV8f7fpsXmlhb4stl62BbgNjKl8ElTc8V6Dn0qA9BFA4ChxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KV/fn+Qw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee8ced572eso9570487a91.0
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 09:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737997745; x=1738602545; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LtnrCMjNLY9dxlwp8PuMqWEP2G86XRjQHfhjyZ08Gl4=;
        b=KV/fn+Qw2kZEe5XxVHuG2ZYLGSCWNkLjUoizq3u5NiISJUhrwJZDqMaCz4TNsSh0eN
         pDB2y/2RHzM70sP/LNJIE/BtrcDSfDZHjUSHDwzK/cG7u5rGaxyHLQm3IuR1y//i4ma7
         gh+kbE1jLPPpok9QXGN2P9ag7uEmJWsEzc1sUp4DH4HFDK2S8qgGM9VvKZUV+YDh0kXQ
         r90Z8+sxAUCSHMNFph4zW3gTYqaif87S2nHqDY/tcV9NLGkKUqQUz1F3eaAMaTl22Ndy
         2lLAPlTyQTGfWHU83jDxMHjLFY/C+vGEdjf4eQBWzQzkHEpTjO9zjL64BEtDz35dF3iz
         pA8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737997745; x=1738602545;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LtnrCMjNLY9dxlwp8PuMqWEP2G86XRjQHfhjyZ08Gl4=;
        b=DRa9+5hdO8NcE2FKmAkh7TATimAF66BkIPwoZYVDwYx3RO3yBCiL+bZfQ5bQaoESpr
         Kj3d83oR/H0XPt1DU0HycsIh+khHsitfBfgpVzZaKn4a0C1K6W/JlZVpDfP7LaP0KB/i
         D8J26iBW7k3CQSmcf0HZ+xpGftWkydvwqog2y3jbzwOJWKSJ4CqcgC8Pu0/BD7LQiSX3
         nUe6D0cZX6f7vwUmLqO+i+SyoXY8J+t9EvBxz73cvZML47OxojYxmMcF92A3zU71mp1X
         iyR6I2F1LVVOTRlfXcNSTswCSVeJKhGVheWp0EdGkzAJFyc5yC6IwJE+QzVA2tj8Vctw
         peHw==
X-Gm-Message-State: AOJu0YwnwYajhQ7t6N0xZ3UMxEFRJGN/YcdLpQxh4cGL+wV6uVJJYUuI
	W9HcNBTjFMKn99JrEtpO8InV+qN3F6cySjFeRyF+P9wivqjCAPlWyylWKnY1ymvjD1UyZjyACaz
	q+w==
X-Google-Smtp-Source: AGHT+IEXrxZG+G1Xqw5JASl98ntqnM3sPYFbmM1Uajz1YtmtVorrIvNlzSXcVbijnHi7wc/xQW9amVAMkZo=
X-Received: from pfblh5.prod.google.com ([2002:a05:6a00:7105:b0:72f:9b55:58a1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:6812:b0:72d:b36a:4497
 with SMTP id d2e1a72fcca58-72db36a45eemr51052542b3a.3.1737997744779; Mon, 27
 Jan 2025 09:09:04 -0800 (PST)
Date: Mon, 27 Jan 2025 09:09:03 -0800
In-Reply-To: <Z2Xgo3XwE6XrCMOM@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-5-adrian.hunter@intel.com> <Z0AbZWd/avwcMoyX@intel.com>
 <a42183ab-a25a-423e-9ef3-947abec20561@intel.com> <Z2GiQS_RmYeHU09L@google.com>
 <487a32e6-54cd-43b7-bfa6-945c725a313d@intel.com> <Z2WZ091z8GmGjSbC@google.com>
 <Z2Xgo3XwE6XrCMOM@google.com>
Message-ID: <Z5e9ryXdZxvjzN7-@google.com>
Subject: Re: PKEY syscall number for selftest? (was: [PATCH 4/7] KVM: TDX:
 restore host xsave state when exit from the guest TD)
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Ping, I'm guessing this fell through the holiday cracks.

On Fri, Dec 20, 2024, Sean Christopherson wrote:
> Switching topics, dropped everyone else except the list.
>=20
> On Fri, Dec 20, 2024, Sean Christopherson wrote:
> >  arch/x86/kvm/x86.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 4320647bd78a..9d5cece9260b 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1186,7 +1186,7 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *=
vcpu)
> >  	    vcpu->arch.pkru !=3D vcpu->arch.host_pkru &&
> >  	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
> >  	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE)))
> > -		write_pkru(vcpu->arch.pkru);
> > +		wrpkru(vcpu->arch.pkru);
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
> > =20
> > @@ -1200,7 +1200,7 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *v=
cpu)
> >  	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE))) {
> >  		vcpu->arch.pkru =3D rdpkru();
> >  		if (vcpu->arch.pkru !=3D vcpu->arch.host_pkru)
> > -			write_pkru(vcpu->arch.host_pkru);
> > +			wrpkru(vcpu->arch.host_pkru);
> >  	}
> > =20
> >  	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
> >=20
> > base-commit: 13e98294d7cec978e31138d16824f50556a62d17
> > --=20
>=20
> I tried to test this by running the mm/protection_keys selftest in a VM, =
but it
> gives what are effectively false passes on x86-64 due to the selftest pic=
king up
> the generic syscall numbers, e.g. 289 for SYS_pkey_alloc, instead of the =
x86-64
> numbers.
>=20
> I was able to get the test to run by hacking tools/testing/selftests/mm/p=
key-x86.h
> to shove in the right numbers, but I can't imagine that's the intended be=
havior.
>=20
> If I omit the #undefs from pkey-x86.h, it shows that the test is grabbing=
 the
> definitions from the generic usr/include/asm-generic/unistd.h header.
>=20
> Am I doing something stupid?
>=20
> Regardless of whether this is PEBKAC or working as intended, on x86, the =
test
> should ideally assert that "ospke" support in /proc/cpuinfo is consistent=
 with
> the result of sys_pkey_alloc(), e.g. so that an failure to allocate a pke=
y on a
> system that work is reported as an error, not a pass.
>=20
> --
> diff --git a/tools/testing/selftests/mm/pkey-x86.h b/tools/testing/selfte=
sts/mm/pkey-x86.h
> index ac91777c8917..ccc3552e6b77 100644
> --- a/tools/testing/selftests/mm/pkey-x86.h
> +++ b/tools/testing/selftests/mm/pkey-x86.h
> @@ -3,6 +3,10 @@
>  #ifndef _PKEYS_X86_H
>  #define _PKEYS_X86_H
> =20
> +#define __NR_pkey_mprotect     329
> +#define __NR_pkey_alloc                330
> +#define __NR_pkey_free         331
> +
>  #ifdef __i386__
> =20
>  #define REG_IP_IDX             REG_EIP
> --
>=20
> Yields:
>=20
> $ ARCH=3Dx86_64 make protection_keys_64
> gcc -Wall -I /home/sean/go/src/kernel.org/linux/tools/testing/selftests/.=
./../..  -isystem /home/sean/go/src/kernel.org/linux/tools/testing/selftest=
s/../../../usr/include -isystem /home/sean/go/src/kernel.org/linux/tools/te=
sting/selftests/../../../tools/include/uapi -no-pie -D_GNU_SOURCE=3D  -m64 =
-mxsave  protection_keys.c vm_util.c thp_settings.c -lrt -lpthread -lm -lrt=
 -ldl -o /home/sean/go/src/kernel.org/linux/tools/testing/selftests/mm/prot=
ection_keys_64
> In file included from pkey-helpers.h:102:0,
>                  from protection_keys.c:49:
> pkey-x86.h:6:0: warning: "__NR_pkey_mprotect" redefined
>  #define __NR_pkey_mprotect 329
> =20
> In file included from protection_keys.c:45:0:
> /home/sean/go/src/kernel.org/linux/usr/include/asm-generic/unistd.h:693:0=
: note: this is the location of the previous definition
>  #define __NR_pkey_mprotect 288
> =20
> In file included from pkey-helpers.h:102:0,
>                  from protection_keys.c:49:
> pkey-x86.h:7:0: warning: "__NR_pkey_alloc" redefined
>  #define __NR_pkey_alloc  330
> =20
> In file included from protection_keys.c:45:0:
> /home/sean/go/src/kernel.org/linux/usr/include/asm-generic/unistd.h:695:0=
: note: this is the location of the previous definition
>  #define __NR_pkey_alloc 289
> =20
> In file included from pkey-helpers.h:102:0,
>                  from protection_keys.c:49:
> pkey-x86.h:8:0: warning: "__NR_pkey_free" redefined
>  #define __NR_pkey_free  331
> =20
> In file included from protection_keys.c:45:0:
> /home/sean/go/src/kernel.org/linux/usr/include/asm-generic/unistd.h:697:0=
: note: this is the location of the previous definition
>  #define __NR_pkey_free 290
> =20
>=20

