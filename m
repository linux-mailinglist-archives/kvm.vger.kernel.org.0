Return-Path: <kvm+bounces-34260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 91D379F9BE5
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 22:25:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 846C01885AC8
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 21:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8321224B07;
	Fri, 20 Dec 2024 21:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z/IY2db/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AD4157A48
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 21:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734729894; cv=none; b=tDEx5bs0BM97wi6NClD78JFobIYEiFOFPR0+yd+OFltxDF7qJ5dumpFr90gShSM0ltsNRM2nOHeS/UVUsIoLETqAelNW9Bj1a98R8nuCAzekr3xtfHrrji1iXzjnt9tK9gxtorFfTipdE8i1kq//AC27PgDi74Pj8luqhm1i6Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734729894; c=relaxed/simple;
	bh=7eeLqFnzCXbq+xxHnkCScV5mqKqwOaZz6WykcyZRamA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KHzzZagRu6v/vHs1+ObIhG2zepKyS6CcH59V83e5dqcfUHyFynAaZ9MIdkwxS8uqmEmYrFXaVTJ/qiI7SNjHFmYF26uxdBhVJhfSUVlSXOAVhpxE3FoTNhH/JSo+t3c0/fMy1X2we4EKWdmhrU2GLbjGE1nY6Q3tQXNjO9sSpAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z/IY2db/; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7eaa7b24162so2220657a12.1
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 13:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734729893; x=1735334693; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NKDL7WotRRznfzryExW5ZNK1jrrKZQRr226yPL5NSdw=;
        b=Z/IY2db/fyR0RzClTOunJWfp1kW14qqEhz3DyrjZd+WZvVowvI0hZErCM1Pc1VMVMj
         h0pK4DmCzKzRI/pg6vM/Gg8EE5FN3zyPi6SM2Hc++F0UbqwzQ3XsnQ6NsLikXwR5wVl9
         p0JBwtPmi25GzNTG3W7D6RmRoy4RLh70fiCbNKre9j7k/l6AFrFkW8KXERGB/KaimYDu
         7zzJPvREz03RUaMNaLJHu1b82z3mu/CGhrHsNajbAk54xeDCuANmVwkW6EtiR07DWaUG
         Hf4F1AtCjwxg3QLEaEv+xP82mpHVOANDiFT9s78N2UdrNJhAmr8fkh0YGo7pkLNsfPgr
         kRQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734729893; x=1735334693;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NKDL7WotRRznfzryExW5ZNK1jrrKZQRr226yPL5NSdw=;
        b=oErTONrRRC4aMPxx6JA/ViQ31dSyBZ8ugo3m70E84SNQeTBDtJuZn1VywhU1nTBaWv
         VTkXx58v0fBvo+Llr/lOzIwwpaU6IYGG92Ro6/81YWnvSL2KK0b9MaXM1JL6PVDI625v
         Bq28mo57nPRz7R2C0UrHNJIVYk5lmbDOd7TAkf6ikxdpwashF6p/O36bwmQiJzm6a4e0
         IUotLs1qgwUArTOWQ9rIAWEiIJqqRmv9hJSuRwy8xWFTcd0OgHwG7YB6rpA+RuaFiuon
         t1aH7/pcdEVwSTWaTdszZujPH4tz7rdIvidBd/0l7D6EFqg6c+xzAUxkGeTXEEs9D2oz
         sZ3w==
X-Gm-Message-State: AOJu0YzPvQOxlFaBSExkNeDX4tyw2Qe4tjfV7V7ZsSULvH1+qENIbNrs
	x5RauL0/n4j9Cb0FHjy2uwJVynSocgIIGJxZC7RZ+4cD4husCftqksSFYqK/T4TwtCEbHiF8vPz
	lCA==
X-Google-Smtp-Source: AGHT+IFA3IucqYuK8Je92yPsNf5Lvo4xKTxSHfDp42LjOwnarj0UeQAojWvQZZZTM6tVIkpEGfcfJFs81NA=
X-Received: from pfwz9.prod.google.com ([2002:a05:6a00:1d89:b0:72a:9fce:4f44])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a108:b0:1e1:9bc1:6d6d
 with SMTP id adf61e73a8af0-1e5e07ee6e4mr9686830637.31.1734729892856; Fri, 20
 Dec 2024 13:24:52 -0800 (PST)
Date: Fri, 20 Dec 2024 13:24:51 -0800
In-Reply-To: <Z2WZ091z8GmGjSbC@google.com>
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
Message-ID: <Z2Xgo3XwE6XrCMOM@google.com>
Subject: PKEY syscall number for selftest? (was: [PATCH 4/7] KVM: TDX: restore
 host xsave state when exit from the guest TD)
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Switching topics, dropped everyone else except the list.

On Fri, Dec 20, 2024, Sean Christopherson wrote:
>  arch/x86/kvm/x86.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4320647bd78a..9d5cece9260b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1186,7 +1186,7 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vc=
pu)
>  	    vcpu->arch.pkru !=3D vcpu->arch.host_pkru &&
>  	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
>  	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE)))
> -		write_pkru(vcpu->arch.pkru);
> +		wrpkru(vcpu->arch.pkru);
>  }
>  EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
> =20
> @@ -1200,7 +1200,7 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcp=
u)
>  	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE))) {
>  		vcpu->arch.pkru =3D rdpkru();
>  		if (vcpu->arch.pkru !=3D vcpu->arch.host_pkru)
> -			write_pkru(vcpu->arch.host_pkru);
> +			wrpkru(vcpu->arch.host_pkru);
>  	}
> =20
>  	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
>=20
> base-commit: 13e98294d7cec978e31138d16824f50556a62d17
> --=20

I tried to test this by running the mm/protection_keys selftest in a VM, bu=
t it
gives what are effectively false passes on x86-64 due to the selftest picki=
ng up
the generic syscall numbers, e.g. 289 for SYS_pkey_alloc, instead of the x8=
6-64
numbers.

I was able to get the test to run by hacking tools/testing/selftests/mm/pke=
y-x86.h
to shove in the right numbers, but I can't imagine that's the intended beha=
vior.

If I omit the #undefs from pkey-x86.h, it shows that the test is grabbing t=
he
definitions from the generic usr/include/asm-generic/unistd.h header.

Am I doing something stupid?

Regardless of whether this is PEBKAC or working as intended, on x86, the te=
st
should ideally assert that "ospke" support in /proc/cpuinfo is consistent w=
ith
the result of sys_pkey_alloc(), e.g. so that an failure to allocate a pkey =
on a
system that work is reported as an error, not a pass.

--
diff --git a/tools/testing/selftests/mm/pkey-x86.h b/tools/testing/selftest=
s/mm/pkey-x86.h
index ac91777c8917..ccc3552e6b77 100644
--- a/tools/testing/selftests/mm/pkey-x86.h
+++ b/tools/testing/selftests/mm/pkey-x86.h
@@ -3,6 +3,10 @@
 #ifndef _PKEYS_X86_H
 #define _PKEYS_X86_H
=20
+#define __NR_pkey_mprotect     329
+#define __NR_pkey_alloc                330
+#define __NR_pkey_free         331
+
 #ifdef __i386__
=20
 #define REG_IP_IDX             REG_EIP
--

Yields:

$ ARCH=3Dx86_64 make protection_keys_64
gcc -Wall -I /home/sean/go/src/kernel.org/linux/tools/testing/selftests/../=
../..  -isystem /home/sean/go/src/kernel.org/linux/tools/testing/selftests/=
../../../usr/include -isystem /home/sean/go/src/kernel.org/linux/tools/test=
ing/selftests/../../../tools/include/uapi -no-pie -D_GNU_SOURCE=3D  -m64 -m=
xsave  protection_keys.c vm_util.c thp_settings.c -lrt -lpthread -lm -lrt -=
ldl -o /home/sean/go/src/kernel.org/linux/tools/testing/selftests/mm/protec=
tion_keys_64
In file included from pkey-helpers.h:102:0,
                 from protection_keys.c:49:
pkey-x86.h:6:0: warning: "__NR_pkey_mprotect" redefined
 #define __NR_pkey_mprotect 329
=20
In file included from protection_keys.c:45:0:
/home/sean/go/src/kernel.org/linux/usr/include/asm-generic/unistd.h:693:0: =
note: this is the location of the previous definition
 #define __NR_pkey_mprotect 288
=20
In file included from pkey-helpers.h:102:0,
                 from protection_keys.c:49:
pkey-x86.h:7:0: warning: "__NR_pkey_alloc" redefined
 #define __NR_pkey_alloc  330
=20
In file included from protection_keys.c:45:0:
/home/sean/go/src/kernel.org/linux/usr/include/asm-generic/unistd.h:695:0: =
note: this is the location of the previous definition
 #define __NR_pkey_alloc 289
=20
In file included from pkey-helpers.h:102:0,
                 from protection_keys.c:49:
pkey-x86.h:8:0: warning: "__NR_pkey_free" redefined
 #define __NR_pkey_free  331
=20
In file included from protection_keys.c:45:0:
/home/sean/go/src/kernel.org/linux/usr/include/asm-generic/unistd.h:697:0: =
note: this is the location of the previous definition
 #define __NR_pkey_free 290
=20


