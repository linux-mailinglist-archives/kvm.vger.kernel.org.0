Return-Path: <kvm+bounces-15928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D458B2405
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B16831F241F5
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 14:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A42F914AD24;
	Thu, 25 Apr 2024 14:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1LNBycAv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D12E149C41
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 14:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714055069; cv=none; b=CRHxAvjsrckNPwZnh0PdoDrD0C+SPHmWxSJq6a5u0myDyaRlTQ42l83Erc8NyQXAijCiO0ANXPv3rEaQkqv1pslUNcAhuQ/rAvqcrZf78EGLMDsG6fge1dxOlv/ca6YF+o+X9zRN6ylJlbwSdSqNfzb+VGfrWwaK1Yz7UdOElGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714055069; c=relaxed/simple;
	bh=CXgze8H10KX/v4JRImSh9WP/ZVuNODByVEtOpwVyOCQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dPyk894H20Eya0SpeXKS/kl8jMAae8Rtmltpfi+DD1X103E4cKprXsoJH1CaNvzdwlcq3ROh5QvvOXX6PvfLJ0nox2uCgsFetLLMFHTajUDEslnod8DLBZKpZWpc4hdCWfuw4ElGd+QRRWUoozuFfJnmFVYUduFq554FodSdADg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1LNBycAv; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61b2abd30f9so18724417b3.0
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 07:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714055067; x=1714659867; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dndj0KNcjnBFh89QNBUHH2At0L0MDscnvYBB7fmSsDw=;
        b=1LNBycAvR5+r9mimJzZeZ/62iN+z8IvWG2Z6wSvUeS3rbRZxR6O1IMa38WQrRy7KtO
         znSzFjqgp4ht3IsLrzCxQfdNkTuDS0htWoTTtz/lKL6FE5KI/H/3iDzXdGsLbY6X1+aA
         8slluLBcsFhiZLolAXwCIfFTmusTagJQ0pEvFq95E0+PVYoMpV1pWkcTXdkLrLQtTna8
         UzjNlhdqBHAB0Tau38AOHLIR09pGWk8uGHiLrPTgv6lq6jtgCkawr6rOfaOdmEYjJCvu
         I7gOubCKt9DWLVa6S5hMQrA/XywnKcK/m0G3Qte+vWKy6kcqELUP8YiNMk7ecWxlPyC4
         p8Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714055067; x=1714659867;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dndj0KNcjnBFh89QNBUHH2At0L0MDscnvYBB7fmSsDw=;
        b=SKaUVwVCkzPr4qB00Em5e4jYWCpbxNLWl4uQOgoFiinQG8rxkEAEcOvV/upJQs1ErH
         dSgpryrwxuCaqp4cfI7qYLHfDveojbA7FOYo4Oz9W6NMqGSgbokgLpyvT3Bf25h4AB6q
         ssnk/KVoUv+bY5AhBMX8GVC2mbt/gT5B6efXi2B5qIVYiuRrXp3sL7WoJARTsvcSN0Wz
         1D/mf8Q/IpwWVVanDPQLq+QWtaCItfW4ils5iJYnjQm1LpqZnFIKlWe4ee/Yoc+2NUeJ
         KItauTN7NZvkbWSRLMaGS4dGXT/RC4udLe/xVdvFcJsnMKs93xKwUXu5UsKYjrM9xbuJ
         f0Zw==
X-Forwarded-Encrypted: i=1; AJvYcCUKv3/grWIRY593HifLcpoIMfLsv8Jm5p4ioD3Y2PONvtk3zmBk9BVllHjm+otDgn0/JwWJ0fSwUSySCMOmILZxuEin
X-Gm-Message-State: AOJu0YxeGI0wzwCDacYaN5OsMm2lJ15JO+4H59/7QaC5aetiRlRgsyHO
	PNTCPu3xiPmAneA6Er7387DibdKAHYtn0Ymm8iiYy4G6i/68dUfGRm053X8FjmIQqEKxpWYgOkA
	+Kg==
X-Google-Smtp-Source: AGHT+IEa63siDXWXx6D/2Ix0xJGiuiKCdPStxwqX6NuXKyTXCR7Qssn7Vd2JljTKE2qH/arBLlro51i9qUw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1890:b0:dc2:2ace:860 with SMTP id
 cj16-20020a056902189000b00dc22ace0860mr541502ybb.2.1714055067513; Thu, 25 Apr
 2024 07:24:27 -0700 (PDT)
Date: Thu, 25 Apr 2024 07:24:25 -0700
In-Reply-To: <DS0PR11MB6373E404A16BD8CC55128FDFDC172@DS0PR11MB6373.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423221521.2923759-1-seanjc@google.com> <DS0PR11MB6373E404A16BD8CC55128FDFDC172@DS0PR11MB6373.namprd11.prod.outlook.com>
Message-ID: <ZipnmfPs0dP3fRUE@google.com>
Subject: Re: [PATCH 0/4] KVM: x86: Collect host state snapshots into a struct
From: Sean Christopherson <seanjc@google.com>
To: Wei W Wang <wei.w.wang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 25, 2024, Wei W Wang wrote:
> On Wednesday, April 24, 2024 6:15 AM, Sean Christopherson wrote:
> > Add a global "kvm_host" structure to hold various host values, e.g. for EFER,
> > XCR0, raw MAXPHYADDR etc., instead of having a bunch of one-off variables
> > that inevitably need to be exported, or in the case of shadow_phys_bits, are
> > buried in a random location and are awkward to use, leading to duplicate
> > code.
> 
> Looks good. How about applying similar improvements to the module
> parameters as well? I've changed the "enable_pmu" parameter as an example below:

Hmm, I don't hate the idea, but I don't think it would work as well in practice.

For kvm_host, all of the fields it contains were being namespace with "host_<asset>",

And the globals that became kvm_caps all had some variant of kvm_ or kvm_has_ as
a prefix.

For module params and other knobs, the thing being controlled is usually unique
to KVM, and often fairly self-descriptive, so we haven't had to namespace them
muc.  And we have params across kvm.ko, kvm-amd.ko, and kvm-intel.ko, which
sometimes weird splits in responsibilities, e.g. enable_apicv is defined by common
x86, but the module params themsleves are defined by SVM and VMX, and for SVM it's
an alias of avic.

> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 77352a4abd87..a221ba7b546f 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1013,7 +1013,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>                 union cpuid10_eax eax;
>                 union cpuid10_edx edx;
> 
> -               if (!enable_pmu || !static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
> +               if (!kvm_caps.enable_pmu || !static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {

If we did try to collect module params in a struct, it should be a unique struct,
because they aren't pure capabilities or host values.

>                         entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>                         break;
>                 }

