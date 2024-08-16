Return-Path: <kvm+bounces-24399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F806954D33
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 16:56:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 050B81F2174C
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 14:56:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C94B1C379F;
	Fri, 16 Aug 2024 14:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aGPoVdYD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5658E1BE248
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 14:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723819912; cv=none; b=K3uyUoE94Y4sINVEEM1g1pF/Pvr6PzmW0s5ThDHRV9lt+xlFcDQFSMVLOxdzWl/pCj0iOC5rq7qsUJmrXIe0r795m9fhaNR13ifXkuub/EExdyq/+bEqDUZduDmbvabjiyiBQhd8W8EsXUBlE1tKV04TplxrflS+2ZvQ86w/IN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723819912; c=relaxed/simple;
	bh=qPDW7sE2j4o5sp7nP3YWhR7UIwdSPbOKX7D46QQfrqc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PiGB6LmJuYrc9G5agJ8Cinhxv3aLTqQcGpkadyhQcp49+20KuhqYP+jv1h9Jnu3ObRZQHFnecps9g9EeNi4xqGsyQJLK1sGNtvdpIh8Ts0WNa6ZIx0yxLvBlMB4OOcfDctrwFC6AHmEpHfh4gPRTFwlF3iC99jmZKWBRGRk0Pig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aGPoVdYD; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a12bb066aaso1722142a12.3
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 07:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723819910; x=1724424710; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gkflmIGUwJMdTfwuwvczKikPVqtIhcNk6V4p4N9b1Og=;
        b=aGPoVdYDh1vSucNjT6TyeM23Ze2jXK40JXNuOB6tq0QJ9FUpxAgz5vOVpP0ngoQITb
         l/LajPG+ULUGLALbdnEnwN7Msgmay+hdcIVKpniqxcaqdGh6CTkc7kP15iJrGXee3oGP
         H43kc7CMcNQNIbmnpp9jgmZ1Ri7Px1qyPlCiRGGSoNxdEC5eURnelOEYtS9A0BZm1rvK
         22cPqGn9dz4BfrtPyGhhM6rPv460mFtDelR/gadoEyvVrVYUYrNBn45K0pVsNz+xO+yX
         N7aPGODuCb0XL/UtPYUt8OLiSyK38ogOYWSVUKkEHLpA+ay6JTtSDFdkdoP8MSQ7XjMx
         bvdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723819910; x=1724424710;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gkflmIGUwJMdTfwuwvczKikPVqtIhcNk6V4p4N9b1Og=;
        b=Tsv0CY9KZIed2SQ1DcCPKTJYpMTopjl0uskp/20leGgA3fRvYN/Lxeqt2MwHhHQMQf
         5g7HowNLYjCDNQC5inAHe8MCk4mAUPR4GuX6cDqjvCSE4IinTn29prnjA0pPhda8UkKZ
         KKgdvRLfajOWfgm4ZICSqaj64fU29u+m0rxz+oNq4zHVlT9abyiFhvdxusP4YVgqVRXc
         jSlDC9YuGLyoI7V0zVZuQgzV6PSfPVUeHqEOKuHjgJuU5Hng5LKn/0DXbNz2bXpo6oPi
         77G+dq3hmS5lZcS9DG1GGatXHs8i3/Qr1HTm62giQRVRXB39gswbjQDsvN733BZtpM2G
         QoGQ==
X-Gm-Message-State: AOJu0YyqQblLYz9l24CaFluCa94DUflO+CclqL4gHhelnf8GvDVN7FEd
	gUA/r8VSnrpofK3NeKvRQa8bFuowc66jgfqj0ADFbdHffqPJZgMjZZdWA8lUcPNlnVY+71MVu/U
	eiA==
X-Google-Smtp-Source: AGHT+IFfizCAVzHwwugzYHFjV9bnh8WV5OcQJ/H0NMKmzAhDDlQwQrzGcBqjLslvcV4d7/WAB7ISUxSmUOo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7352:0:b0:7c9:58ed:713b with SMTP id
 41be03b00d2f7-7c975b842edmr5870a12.0.1723819910410; Fri, 16 Aug 2024 07:51:50
 -0700 (PDT)
Date: Fri, 16 Aug 2024 07:51:48 -0700
In-Reply-To: <20240603064002.266116-1-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240603064002.266116-1-tao1.su@linux.intel.com>
Message-ID: <Zr9nhCqerpmXjvGc@google.com>
Subject: Re: [PATCH v2] KVM: x86: Advertise AVX10.1 CPUID to userspace
From: Sean Christopherson <seanjc@google.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com, 
	xiaoyao.li@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 03, 2024, Tao Su wrote:
> Advertise AVX10.1 related CPUIDs, i.e. report AVX10 support bit via
> CPUID.(EAX=3D07H, ECX=3D01H):EDX[bit 19] and new CPUID leaf 0x24H so that
> guest OS and applications can query the AVX10.1 CPUIDs directly. Intel
> AVX10 represents the first major new vector ISA since the introduction of
> Intel AVX512, which will establish a common, converged vector instruction
> set across all Intel architectures[1].
>=20
> AVX10.1 is an early version of AVX10, that enumerates the Intel AVX512
> instruction set at 128, 256, and 512 bits which is enabled on
> Granite Rapids. I.e., AVX10.1 is only a new CPUID enumeration with no
> VMX capability, Embedded rounding and Suppress All Exceptions (SAE),
> which will be introduced in AVX10.2.
>
> Advertising AVX10.1 is safe because kernel doesn't enable AVX10.1 which i=
s

I thought there is nothing to enable for AVX10.1?  I.e. it's purely a new w=
ay to
enumerate support, thus there will never be anything for the kernel to enab=
le.

> on KVM-only leaf now, just the CPUID checking is changed when using AVX51=
2
> related instructions, e.g. if using one AVX512 instruction needs to check
> (AVX512 AND AVX512DQ), it can check ((AVX512 AND AVX512DQ) OR AVX10.1)
> after checking XCR0[7:5].
>=20
> The versions of AVX10 are expected to be inclusive, e.g. version N+1 is
> a superset of version N. Per the spec, the version can never be 0, just
> advertise AVX10.1 if it's supported in hardware.

I think it's also worth calling out that advertising AVX10_{128,256,512} ne=
eds
to land in the same patch (this patch) as AVX10 (and thus AVX10.1), because
otherwise KVM would advertise an impossible CPU model, e.g. with AVX512 but=
 not
AVX10.1/512, which per "Feature Differences Between Intel=C2=AE AVX-512 and=
 Intel=C2=AE AVX10"
should be impossible.

> As more and more AVX related CPUIDs are added (it would have resulted in
> around 40-50 CPUID flags when developing AVX10), the versioning approach
> is introduced. But incrementing version numbers are bad for virtualizatio=
n.
> E.g. if AVX10.2 has a feature that shouldn't be enumerated to guests for
> whatever reason, then KVM can't enumerate any "later" features either,
> because the only way to hide the problematic AVX10.2 feature is to set th=
e
> version to AVX10.1 or lower[2]. But most AVX features are just passed
> through and don=E2=80=99t have virtualization controls, so AVX10 should n=
ot be
> problematic in practice.
>=20
> [1] https://cdrdv2.intel.com/v1/dl/getContent/784267
> [2] https://lore.kernel.org/all/Zkz5Ak0PQlAN8DxK@google.com/
>=20
> Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> ---
> Changelog:
> v1 -> v2:
>  - Directly advertise version 1 because version can never be 0.
>  - Add and advertise feature bits for the supported vector sizes.
>=20
> v1: https://lore.kernel.org/all/20240520022002.1494056-1-tao1.su@linux.in=
tel.com/
> ---
>  arch/x86/include/asm/cpuid.h |  1 +
>  arch/x86/kvm/cpuid.c         | 21 +++++++++++++++++++--
>  arch/x86/kvm/reverse_cpuid.h |  8 ++++++++
>  3 files changed, 28 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/cpuid.h b/arch/x86/include/asm/cpuid.h
> index 6b122a31da06..aa21c105eef1 100644
> --- a/arch/x86/include/asm/cpuid.h
> +++ b/arch/x86/include/asm/cpuid.h
> @@ -179,6 +179,7 @@ static __always_inline bool cpuid_function_is_indexed=
(u32 function)
>  	case 0x1d:
>  	case 0x1e:
>  	case 0x1f:
> +	case 0x24:
>  	case 0x8000001d:
>  		return true;
>  	}
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index f2f2be5d1141..6717a5b7d9cd 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -693,7 +693,7 @@ void kvm_set_cpu_caps(void)
> =20
>  	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
>  		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI) |
> -		F(AMX_COMPLEX)
> +		F(AMX_COMPLEX) | F(AVX10)
>  	);
> =20
>  	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
> @@ -709,6 +709,10 @@ void kvm_set_cpu_caps(void)
>  		SF(SGX1) | SF(SGX2) | SF(SGX_EDECCSSA)
>  	);
> =20
> +	kvm_cpu_cap_init_kvm_defined(CPUID_24_0_EBX,
> +		F(AVX10_128) | F(AVX10_256) | F(AVX10_512)
> +	);
> +
>  	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
>  		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
>  		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
> @@ -937,7 +941,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_ar=
ray *array, u32 function)
>  	switch (function) {
>  	case 0:
>  		/* Limited to the highest leaf implemented in KVM. */
> -		entry->eax =3D min(entry->eax, 0x1fU);
> +		entry->eax =3D min(entry->eax, 0x24U);
>  		break;
>  	case 1:
>  		cpuid_entry_override(entry, CPUID_1_EDX);
> @@ -1162,6 +1166,19 @@ static inline int __do_cpuid_func(struct kvm_cpuid=
_array *array, u32 function)
>  			break;
>  		}
>  		break;
> +	case 0x24: {

No need for the curly braces on the case.  But, my suggestion below will ch=
ange
that ;-)

> +		if (!kvm_cpu_cap_has(X86_FEATURE_AVX10)) {
> +			entry->eax =3D entry->ebx =3D entry->ecx =3D entry->edx =3D 0;
> +			break;
> +		}
> +		entry->eax =3D 0;
> +		cpuid_entry_override(entry, CPUID_24_0_EBX);
> +		/* EBX[7:0] hold the AVX10 version; KVM supports version '1'. */
> +		entry->ebx |=3D 1;

Ah, rather than hardcode this to '1', I think we should do:

		u8 avx10_version;

		if (!kvm_cpu_cap_has(X86_FEATURE_AVX10)) {
			entry->eax =3D entry->ebx =3D entry->ecx =3D entry->edx =3D 0;
			break;
		}

		/*
		 * The AVX10 version is encoded in EBX[7:0].  Note, the version
		 * is guaranteed to be >=3D1 if AVX10 is supported.  Note #2, the
		 * version needs to be captured before overriding EBX features!
		 */
		avx10_version =3D min_t(u8, entry->ebx & 0xff, 1);

		cpuid_entry_override(entry, CPUID_24_0_EBX);
		entry->ebx |=3D avx10_version;

I.e. use the same approach as limiting the max leaf, which does:

		entry->eax =3D min(entry->eax, 0x1fU);

Unless I'm misunderstanding how all of this is expected to play out, we're =
going
to need the min_t() code for AVX10.2 anyways, might as well implement it no=
w.

