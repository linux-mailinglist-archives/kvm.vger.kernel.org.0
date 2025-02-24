Return-Path: <kvm+bounces-39002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7165A4273D
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:04:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF5E03B8B53
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 15:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1CD0261378;
	Mon, 24 Feb 2025 15:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DE07uZ97"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00C019C54F
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 15:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740412670; cv=none; b=Msp28InjyhVx9a2QC6aTzw0D1F18muNO50l9DRHrot4rDTxsKdA54GN/a+MQPK9nNwe0zOsAHt8AktuBZScAALP32a1DAhu7WqzguXiFbd5GBb5GLfSzDH1/i9qWhSyvUdZ9zqfeyPRo1ng3ak4xxc3eeSmSpv1sjyaXLw4r/Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740412670; c=relaxed/simple;
	bh=2t59lsYG4BqwtnauANqi9S05hHamW9pvVdmQnLPMB5Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MDDEAjprL0iOtZzpP/HIY99uvKAkiFEy/Ce3ZWZDetSiocpQeRVurNJuDqG1s4yhoCSjFYG2eiT79mWkyFh7uM2xBiTA8iqqysaVkb/ryEe1/JNRwMM/uZ6/msDDJfOZsifz5JyS97ClyjvF/Rh8QI3AINPKEGSvpo8A6P9e3YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DE07uZ97; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220e62c4f27so109546585ad.0
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 07:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740412667; x=1741017467; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ql4hG9y/ji9r+lB2NHuF+yH9db63u51S51cV8RgKCFE=;
        b=DE07uZ97SuDwFBiE6d6ieELH7EE7tkAGbtQcdsA5/fgNCHpljX/n7PprNLq9HmdZEV
         9lKewl967RJwkFOtYu2LPTlz2kxEPbKwlokH6qAguYmk7DVk0WlzRHO/E5Vf43YZxQpz
         9obzG/cDXlr1u84xcEVi3REMX9bRQPC5lAnfIbLRcnVw95xgENHKETMKpzETCnxpIREJ
         ccGFHCNPic6xdlbEXrKcVuEbGdmVVss2KkL3aKRQ1hSiNZ9hL1E6ZGe7dCCw7YcIeZ5G
         Uy1H1a7R2T6W5ZyZKOmCHE4RvS1rpWjviENtY4Hc9xC+Hqyt+HtC0jmd1H6dawlOhh4f
         hW8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740412667; x=1741017467;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ql4hG9y/ji9r+lB2NHuF+yH9db63u51S51cV8RgKCFE=;
        b=bIKrZB0ZzKsVrzFTpySbSMNmbrAtSN5ZQfz0TcGp8ZI9W1fdPw/1PnVIsxTtnNJJ3+
         KAvrEG09skO3en32Tb506uftLJbO09fOkc5sRtGNQsjQjTAeBzQVbZjSy40AFs7MnGbH
         FNjj/XRjPjKo0Gza8XNaKOBVV36FqJnTosx8oKIBmKXCmptIvGmrgjqz4mWXg36tTMqw
         mka8ZbpAOZq2eSFxbGK65a0LuZP8c8O1w1SWBtGI9RXsSAl8j2iLezoavaeBQsLd1tf6
         nzQDtgKM9tvtTJZqNDnaHKL3srMstm1mGEVSgVpzuMxBRF5MtgOzuPA7uzTQr/eP7tGa
         4Ziw==
X-Forwarded-Encrypted: i=1; AJvYcCXSRkNTulk2+HyW7vafjZJT2C2ApKADsR+7EJUn6i/4RVta118SjNGF32jcSoYL+KAKBG0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyclLjPs346Znoi9+OhqN4PFL9/dQFbRhSy8scZiMAzhcFyo4WY
	AiXR6HUXv7wnllIjOf/JeWKuN2sEx4LLc+0R63sE1vtfUjEUPesJ6D5vNmvsk7BZU7Y1J95CImO
	Bcw==
X-Google-Smtp-Source: AGHT+IFkxCGkRNpNw+UlQYXfNBv6PhblpOoOHAO6bny9WcoQpJVMrpTux0exDkoFpvccE+QSh69xIrDiPgM=
X-Received: from pfbhx1.prod.google.com ([2002:a05:6a00:8981:b0:732:5b2e:4735])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4f88:b0:730:a40f:e6ce
 with SMTP id d2e1a72fcca58-73426d85439mr18693077b3a.17.1740412666826; Mon, 24
 Feb 2025 07:57:46 -0800 (PST)
Date: Mon, 24 Feb 2025 07:57:45 -0800
In-Reply-To: <20250221071624.1356899-1-suhui@nfschina.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250221071624.1356899-1-suhui@nfschina.com>
Message-ID: <Z7yW-aNXV1sK6eQN@google.com>
Subject: Re: [PATCH] include/linux/log2.h: mark is_power_of_2() with __always_inline
From: Sean Christopherson <seanjc@google.com>
To: Su Hui <suhui@nfschina.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: binbin.wu@linux.intel.com, pbonzini@redhat.com, 
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

+Andrew

On Fri, Feb 21, 2025, Su Hui wrote:
> When build kernel with randconfig, there is an error:
>=20
> In function =E2=80=98kvm_is_cr4_bit_set=E2=80=99,inlined from
> =E2=80=98kvm_update_cpuid_runtime=E2=80=99 at arch/x86/kvm/cpuid.c:310:9:
>=20
> include/linux/compiler_types.h:542:38: error: call to
> =E2=80=98__compiletime_assert_380=E2=80=99 declared with attribute error:
> BUILD_BUG_ON failed: !is_power_of_2(cr4_bit).

Andrew, do you want to grab this?  Looks like you've taken the last few cha=
nges
to log2.h, and KVM isn't the only subsystem that expects is_power_of_2() to=
 yield
a compile-time constant; taking this through the KVM tree feels wrong.

  arch/x86/kvm/kvm_cache_regs.h:	BUILD_BUG_ON(!is_power_of_2(cr0_bit));
  arch/x86/kvm/kvm_cache_regs.h:	BUILD_BUG_ON(!is_power_of_2(cr4_bit));
  arch/x86/kvm/x86.c:	BUILD_BUG_ON(!is_power_of_2(ASYNC_PF_PER_VCPU));
  drivers/net/ipa/gsi.c:	BUILD_BUG_ON(!is_power_of_2(GSI_RING_ELEMENT_SIZE)=
);
  drivers/vfio/pci/virtio/legacy_io.c:	BUILD_BUG_ON(!is_power_of_2(virtvdev=
->bar0_virtual_buf_size));
  kernel/kcov.c:		BUILD_BUG_ON(!is_power_of_2(KCOV_WORDS_PER_CMP));
  mm/sparse.c:	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
  mm/swap_cgroup.c:	BUILD_BUG_ON(!is_power_of_2(ID_PER_SC));

> '!is_power_of_2(X86_CR4_OSXSAVE)' is False, but gcc treats is_power_of_2(=
)
> as non-inline function and a compilation error happens. Fix this by marki=
ng
> is_power_of_2() with __always_inline.
>=20
> Signed-off-by: Su Hui <suhui@nfschina.com>
> ---
>  include/linux/log2.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/linux/log2.h b/include/linux/log2.h
> index 9f30d087a128..1366cb688a6d 100644
> --- a/include/linux/log2.h
> +++ b/include/linux/log2.h
> @@ -41,7 +41,7 @@ int __ilog2_u64(u64 n)
>   * *not* considered a power of two.
>   * Return: true if @n is a power of 2, otherwise false.
>   */
> -static inline __attribute__((const))
> +static __always_inline __attribute__((const))
>  bool is_power_of_2(unsigned long n)
>  {
>  	return (n !=3D 0 && ((n & (n - 1)) =3D=3D 0));
> --=20
> 2.30.2
>=20

