Return-Path: <kvm+bounces-57257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F03DBB52375
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 23:26:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1BBC7AED8F
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 21:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22EE3310768;
	Wed, 10 Sep 2025 21:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i3S6fLUu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17078258EC3
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 21:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757539474; cv=none; b=QO4N9O5tbUDAq3FRFL+h9yt4kIoTmZpoefuaf7IaELadbBVei45NnKZI+0WSJKhJ3A+0QktQdahyGtQ629bTDfa38YGnc51gei8QJqdPn4VySfPZAMDGtfGlpHcI75Nr4+68NlCjylAMm0TUGq4j8BNlklUaORsciDgWlFDn99c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757539474; c=relaxed/simple;
	bh=9IQRtSHr1628ofW6kQUbKbDpJQ94kMCTSCn5PHWbJt4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GL1+gtwqy9NKKVQJpXmO62I4Nf4wSiTiBpd1Dh/Ci0GUvtRgImkO5eUfwfZ0aK08R069H+B/xTUnTCWM+5Kl4ZlM++dwBkg403vK6Rntuj4MuSn0y6YHfLkvGKt3n0P4FRqctPsFguKGM/UF5SBNxHqB4ncXPg7j0M4XALt/Rbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i3S6fLUu; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24b0e137484so105475ad.0
        for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 14:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757539471; x=1758144271; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7K25irIRP6gkMb+usONBcKAqyqrONPXTNhVmIFHvEbQ=;
        b=i3S6fLUuNx1KvSnpCJigdRmsDqCke664+0KYvxaAfKghNKGpYouhXHkGlrfs3K2F5q
         XnGT1vPsRFpnE0KhEGGk6lrEdyYcFHBcubvDTt1tmNi8WimfEIP1wyv4JfymW0WyXJYP
         4MGL6p/c5RF4SQEuKU8dQ8ToQarXyLdBkMdseasGOHgGzkzEpInLpn49u/DtOGOjTQMR
         nrg+vOdyhTOTyWXvJP5Xi5utkw6/ZfCi0CHrjlBkjf6cJ9tHakiDv+oq7hKvQ6CLk5dI
         6zcyt2EI2uCR2shtYmpe+bO82178LG8QpqwItmi0ZFAvqpdEljbB/lcyHZuvq8qQ7e33
         ujeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757539471; x=1758144271;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7K25irIRP6gkMb+usONBcKAqyqrONPXTNhVmIFHvEbQ=;
        b=jLZNrBLOk1w4ZQKXgwLJmWXlClTY3scI/VVI/YWduuM9yV41n65ETrfGQDVeJ7aG/e
         c6hsXv6MiuIa+5oOFw9mRCCBPBIFGyrt/rOWdxTr3/hdbJ51+o+KHevHrDDw43sEavA8
         RWmeaCfsCgMfs2v1EHpcffGW0nktn8FGWeNXrnMshGMmwcXGjewX8G9X7/Vhudliwt6a
         JGCozyzaA+p4En+cWCMI1TVmFeUNFdYsX7V081pncL5jxxTOtUkQrQzIudJXniUtbHhY
         YlsPUd4qq0k/LW7pQK+p+S1H7PUl4x2utNONegcg+SwSzRd0lS6YD/Id5dS6OzqYMlvr
         2vQQ==
X-Gm-Message-State: AOJu0Yx3EHfGpfK7Gxom9Z2fnv+OH4HAPnOiNDHyFH5frW8tTHRtU1/k
	Dl6zTbCaPd1jqSUtu1QICM3AZ9OyfCOa9Y5EiRdQI//50BFlcHpvMDeiGXPsmOB727JSV06df21
	ncIqhWw==
X-Google-Smtp-Source: AGHT+IELnivaoN7uLl4I6Rm5FrgSDDRAim2bOXj5yg5qLtdGI08FzJyUExDTu6fZz4/zzccXrCwowFnFk+4=
X-Received: from pjbsw12.prod.google.com ([2002:a17:90b:2c8c:b0:327:7070:5b73])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:240b:b0:250:a6ae:f4aa
 with SMTP id d9443c01a7336-2516f24000cmr219432165ad.25.1757539471255; Wed, 10
 Sep 2025 14:24:31 -0700 (PDT)
Date: Wed, 10 Sep 2025 14:24:29 -0700
In-Reply-To: <20250908201750.98824-5-john.allen@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250908201750.98824-1-john.allen@amd.com> <20250908201750.98824-5-john.allen@amd.com>
Message-ID: <aMHsjTjog6SqPRpD@google.com>
Subject: Re: [PATCH v4 4/5] KVM: SVM: Add MSR_IA32_XSS to the GHCB for
 hypervisor kernel
From: Sean Christopherson <seanjc@google.com>
To: John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	pbonzini@redhat.com, dave.hansen@intel.com, rick.p.edgecombe@intel.com, 
	mlevitsk@redhat.com, weijiang.yang@intel.com, chao.gao@intel.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2025, John Allen wrote:
> When a guest issues a cpuid instruction for Fn0000000D_x0B_{x00,x01}, KVM=
 will
> be intercepting the CPUID instruction and will need to access the guest
> MSR_IA32_XSS value. For SEV-ES, the XSS value is encrypted and needs to b=
e
> included in the GHCB to be visible to the hypervisor.
>=20
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
> v2:
>   - Omit passing through XSS as this has already been properly
>     implemented in a26b7cd22546 ("KVM: SEV: Do not intercept
>     accesses to MSR_IA32_XSS for SEV-ES guests")
> v3:
>   - Move guest kernel GHCB_ACCESSORS definition to new series.

Except that broke _this_ series.

arch/x86/kvm/svm/sev.c: In function =E2=80=98sev_es_sync_from_ghcb=E2=80=99=
:
arch/x86/kvm/svm/sev.c:3293:39: error: implicit declaration of function =E2=
=80=98ghcb_get_xss=E2=80=99;
                                       did you mean =E2=80=98ghcb_get_rsi=
=E2=80=99? [-Wimplicit-function-declaration]
 3293 |                 vcpu->arch.ia32_xss =3D ghcb_get_xss(ghcb);
      |                                       ^~~~~~~~~~~~
      |                                       ghcb_get_rsi
  AR      drivers/base/built-in.a
  AR      drivers/built-in.a

> v4:
>   - Change logic structure to be more intuitive.
> ---
>  arch/x86/kvm/svm/sev.c | 5 +++++
>  arch/x86/kvm/svm/svm.h | 1 +
>  2 files changed, 6 insertions(+)
>=20
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f4381878a9e5..33c42dd853b3 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3310,6 +3310,11 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm =
*svm)
>  		vcpu->arch.cpuid_dynamic_bits_dirty =3D true;
>  	}
> =20
> +	if (kvm_ghcb_xss_is_valid(svm)) {
> +		vcpu->arch.ia32_xss =3D ghcb_get_xss(ghcb);

Honestly, I think the ghcb_get_xxx() helpers do more harm than good.  For s=
et()
and if_valid(), I'm totally on board with a wrapper.  For get(), unless we =
WARN
on trying to read an invalid field, I just don't see the point.  Ugh, and w=
e
_can't_ WARN, at least not in KVM, because of the whole TOCTOU mess.

Case in point, this and the xcr0 check can elide setting cpuid_dynamic_bits=
_dirty
if XCR0/XSS isn't actually changing, but then this

	if (kvm_ghcb_xcr0_is_valid(svm) && vcpu->arch.xcr0 !=3D ghcb_get_xcr0(ghcb=
)) {
		vcpu->arch.xcr0 =3D ghcb_get_xcr0(ghcb);
		vcpu->arch.cpuid_dynamic_bits_dirty =3D true;
	}

looks wonky unless the reader knows that ghcb_get_xcr0() is just reading a =
struct
field, which obviously isn't terribly difficult to figure out, but the macr=
os
make it more than a bit annoying.

Argh, even worse, that check is technically subject to a TOCTOU bug as well=
.  It
just doesn't matter in practice because the guest can only hose it self, e.=
g. by
swizzling XCR0/XSS.  But it's still flawed.

And for both XCR0/XSS, KVM lets the guest throw garbage into vcpu->arch.xcr=
0 and
now vcpu->arch.xss.  Maybe that's not problematic in practice, but I'd rath=
er not
find out the hard way.

Lastly, open coding the write to cpuid_dynamic_bits_dirty and vcpu->arch.xc=
r0 is
just gross.

So to avoid a rather pointless dependency for CET, which I'm trying my darn=
dest
to land in 6.18, I'm going to put together a separate fixup patch and repla=
ce
this patchh to end up with code that does:

	if (kvm_ghcb_xcr0_is_valid(svm)
		__kvm_set_xcr(vcpu, 0, kvm_ghcb_get_xcr0(ghcb));

	if (kvm_ghcb_xss_is_valid(svm))
		__kvm_emulate_msr_write(vcpu, MSR_IA32_XSS, kvm_ghcb_get_xss(ghcb));

