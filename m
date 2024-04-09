Return-Path: <kvm+bounces-14027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28C7B89E2E8
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 21:05:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59A9D1C21F0A
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 19:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C29B156F4F;
	Tue,  9 Apr 2024 19:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kht9PQM6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA23153574
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 19:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712689516; cv=none; b=G8kSFv6vO3jfU01eE32wdvU5lpIuTZEwJW4ZprfIhA6+MMftcCp/65CZrIonfFUmFeBPcD7aI54OHSb1d3h/LMsu8mwBWGEYIN06yqEGa6f+9yXMtQO0Gd3lTX3DfN8fGgambsOwyTYTUSTaXkeZ08SUJFgWJBoixSXobzpO0h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712689516; c=relaxed/simple;
	bh=kALgoWoGcEiQ5xjH0ESDObpl47WYRSkGbLw5cMwwHnk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dwnjE8imISCBEQJmiNny0UnUOOku0lU5YEJiXV5o+kQEnRvwYUsOvMQpH4wJv8qONLS8LoAsowTPvNzxPWOwgMuRVeFlxMSFGQfQ1R8rhNG+/SipBln9hmrrg0L2OfAkedTYI71wJgkDitvmqcECUssedPVHXoYQohFLWePAlBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kht9PQM6; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60cd62fa1f9so91988857b3.0
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 12:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712689513; x=1713294313; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oGaLDhzrs4WjxLTgLX7F3OCAgqs6Vh12MGHKH8gqyQM=;
        b=kht9PQM6Y5bor1jVn8Hd+eSCYTRGy/B436EMvqx0P7o9ejv1wcSGqLkJNug5uW7wWH
         57VUQi5URNsybpB+Aa8yvsiAH1SrzKGELRPvs3Cot/yWLRfAMLJ0Km9im57Q1Eqf3N8C
         zT9eeW7+s+WeDEC/N1XgSE4Ua9GAL6ajBMzeD6myUfbCYxVbfZxF3naiuiyKhBCPSGGm
         WSjt9aoKoCRTCn9rTVjfEIZ5mOyv/HMq0lW0hnksuDOfjiX9aBFb8NNKhs8BRtQFMCOW
         x+kA2+aLRc7JXyTuzmr60KIy+84ZsvQHZTWL8ttidxLeqOVMOGFAkr3TMfaRA6iudGFW
         F8+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712689513; x=1713294313;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oGaLDhzrs4WjxLTgLX7F3OCAgqs6Vh12MGHKH8gqyQM=;
        b=Fw2gVGGhG9VmfcpE10kUgD+E8vQx44J6Q4Lo97SQgL7PNQlGF8wGHvoyawvFlVNDrS
         O/cOr9gzowQoRZ75oOWIpHsZO1cU+EiX08CPYxMYnp37lpY1qO8YDI/T459wiJK7fDDZ
         pgjWQj8w5XiskLGKZwi4rkzFDiTI7zZ3GPgQl7cmSXc6yPk4JZpaQrDCH25SnJpxWv68
         wxeEzjqnY2sycpzuym+86I5qxrdQ6KFEL+rZs/cnLVdbqgTlNpQfJStyGzycAgHZpbgX
         69z6xLhKSvyHenGS3v6z0omqkKGEMB8i3jRjF0XhxCfRnMVUw3e2yg3NTqDx7wkn1z15
         zAKg==
X-Gm-Message-State: AOJu0YyGoMIeMW1ZStsjqx6V1mW1BlHg807aZ4JnP5gqK6eeJH13Bo2L
	Ph+46SElFbpSvV0/eSudEer5+KjP/2hrDtZA1gAU5vboCvRSHC3EKmLZkR1Lrq/NbNaYuStQeq2
	k8g==
X-Google-Smtp-Source: AGHT+IH1ppIpWPQNcb+YnQEft9Ovjv4vk+t7D3f8awDLgx3PVSvlLvRu99syKm553RerAktbovj1Upro3UA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:110:b0:615:dce:e3e with SMTP id
 bd16-20020a05690c011000b006150dce0e3emr130669ywb.9.1712689513687; Tue, 09 Apr
 2024 12:05:13 -0700 (PDT)
Date: Tue, 9 Apr 2024 12:05:12 -0700
In-Reply-To: <20240319031111.495006-1-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240319031111.495006-1-tao1.su@linux.intel.com>
Message-ID: <ZhWRaMtsMXfHTFTH@google.com>
Subject: Re: [PATCH] KVM: x86: Fix the condition of #PF interception caused by MKTME
From: Sean Christopherson <seanjc@google.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com, 
	xiaoyao.li@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2024, Tao Su wrote:
> Intel MKTME repurposes several high bits of physical address as 'keyID',
> so boot_cpu_data.x86_phys_bits doesn't hold physical address bits reporte=
d
> by CPUID anymore.
>=20
> If guest.MAXPHYADDR < host.MAXPHYADDR, the bit field of =E2=80=98keyID=E2=
=80=99 belongs
> to reserved bits in guest=E2=80=99s view, so intercepting #PF to fix erro=
r code
> is necessary, just replace boot_cpu_data.x86_phys_bits with
> kvm_get_shadow_phys_bits() to fix.
>=20
> Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 65786dbe7d60..79b1757df74a 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -15,6 +15,7 @@
>  #include "vmx_ops.h"
>  #include "../cpuid.h"
>  #include "run_flags.h"
> +#include "../mmu.h"
> =20
>  #define MSR_TYPE_R	1
>  #define MSR_TYPE_W	2
> @@ -719,7 +720,8 @@ static inline bool vmx_need_pf_intercept(struct kvm_v=
cpu *vcpu)
>  	if (!enable_ept)
>  		return true;
> =20
> -	return allow_smaller_maxphyaddr && cpuid_maxphyaddr(vcpu) < boot_cpu_da=
ta.x86_phys_bits;
> +	return allow_smaller_maxphyaddr &&
> +		cpuid_maxphyaddr(vcpu) < kvm_get_shadow_phys_bits();

For posterity, because I had a brief moment where I thought we done messed =
up:

No change is needed in the reporting of MAXPHYADDR in KVM_GET_SUPPORTED_CPU=
ID,
as reporting boot_cpu_data.x86_phys_bits as MAXPHYADDR when TDP is disabled=
 is ok
because KVM always intercepts #PF when TDP is disabled, and KVM already rep=
orts
the full/raw MAXPHYADDR when TDP is enabled.

