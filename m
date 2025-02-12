Return-Path: <kvm+bounces-37940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E7BAA31BA0
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 02:58:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E2367A39F6
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 01:57:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E07146A68;
	Wed, 12 Feb 2025 01:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ARZ3Bj9j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D21D1CA9C
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 01:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739325495; cv=none; b=Qe0c23DijJ2QQ1pCQemixG2Vi9UwvfIEg32WZAbmC0Z0HDrZbhkYO9Ep1c/p8zG8GkgpOy9riI9NQX6CBK7T82ZoTf5ZAf1DloktwUSb4knd5HYYwilNinb4x1ogw0Svk7Frtr/4sHQFhgzkincvzfyiAue/6gv7uZV0H1CTFkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739325495; c=relaxed/simple;
	bh=XIMgkskMxn1nn+KR+UHsoIEJpOMWNgBuJYgmSHFKAZE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oCvOXIr3+vHsv9j4iAivL/p1da0VnOjdUWQ0A5cRzC+q6/E+WQPkZHUaz/2/XBA46bV/OuymWECG5FzcRrlOVlQBg33eR4Cu+Ax6cijIgNDvGlUDfE4b7m4DC7imQ/X49WSAHzKA0oT5myrbrQKGal1mS4Z0MxDORztXEeIy444=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ARZ3Bj9j; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa57c42965so7318799a91.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 17:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739325494; x=1739930294; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JBmexDJauWUVMueSQTYcfoS5XgO5mBN+j+WiBcxqz+0=;
        b=ARZ3Bj9jl8OJMYGMS/FPbwXsuvkeWZCEBkmkkQPAuzEX0G8LLGHWejhHH91mOuIVmp
         iKCdZ5CpvKM/rTywAtOLVVAfSorMPO5fdt5KsGv7jvO5IGnr0DOxQ7ry7AGiKT/rvfEp
         vbe9avvOFcFkew9HcMm63VUF2T1lwehR35KRC/kgEUyOX91hh5Kk8EuEBSd2tkTuksHW
         gDt6R7R8dZYSndtUuU+z8vkgY4hULZMe6aZOvcvSLq92dsjkVF49uyUAq/TYME2vChY7
         f0HUqz/LSEUAOUe1qN1GMe+/pYoGoJKbqRKfkCIYXtmqvMmOWdp7g32DL6sv2+oXPLOR
         Dd3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739325494; x=1739930294;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JBmexDJauWUVMueSQTYcfoS5XgO5mBN+j+WiBcxqz+0=;
        b=TsPBJe8MSKiG4UFzJBfI76W3CgXuPSO6DJDkUKsKuFTzV/U4wjx5N8W9oezTurnfky
         SkJMSZa17jGqNfokdVj010WrfazUCRGwlH5wkFcKv9AyPLCup8qdnaBRgRXBXD06oRV9
         j3BoMGAoujV35W68a4KLkcxip05Q7GrSaNclT7c1jKOVUs9t2VQ9hs+QzJZgAoVIu9jd
         IiVZhEvNb6kO7lW4XwGx0+zB1tsY9z+S5gqo7oT5wLqEPU9LrLoTTPxdX2iSbHOsm0Yu
         MTrRzcRCTI5XOYYZ2jpOUveGb2/Y64JI5LEaHoJFGl9pW0vy43KjvENPXJkV6lfxGBQk
         8j4Q==
X-Forwarded-Encrypted: i=1; AJvYcCW15o6bVCrRRsskL+fv3k7builjwmqXK0BKs8VSy4iSt9Ta94OpfgZOwgCaDTVMyBohDW8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+H+ZInYL3/rbkHAd31DrsfVB+chx4lh4vjDWXj9IqQRq4ZCP8
	/zwmWICCSryIng5t7sz5UI7p7sZh6K+LY5NJUV1w60JYJ/Qyb1u+oZJXJwBMvdMlbiJenXnYeHo
	W+A==
X-Google-Smtp-Source: AGHT+IG8gNhDei/WwBHZVkG78nqd1F8fT+XYoWcLtzAPMmJRfa8+UGmH6QlGzlgYGpwOFsPEKl6pyd8osao=
X-Received: from pji8.prod.google.com ([2002:a17:90b:3fc8:b0:2fa:1fac:269c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2712:b0:2ee:741c:e9f4
 with SMTP id 98e67ed59e1d1-2fbf5be0da2mr2064880a91.11.1739325493702; Tue, 11
 Feb 2025 17:58:13 -0800 (PST)
Date: Tue, 11 Feb 2025 17:58:12 -0800
In-Reply-To: <20250203223205.36121-3-prsampat@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250203223205.36121-1-prsampat@amd.com> <20250203223205.36121-3-prsampat@amd.com>
Message-ID: <Z6wANGkZb7_HK8ay@google.com>
Subject: Re: [PATCH v6 2/9] KVM: SEV: Disable SEV on platform init failure
From: Sean Christopherson <seanjc@google.com>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com, thomas.lendacky@amd.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, shuah@kernel.org, 
	pgonda@google.com, ashish.kalra@amd.com, nikunj@amd.com, pankaj.gupta@amd.com, 
	michael.roth@amd.com, sraithal@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 03, 2025, Pratik R. Sampat wrote:
> If the platform initialization sev_platform_init() fails, SEV cannot be
> set up and a secure VM cannot be spawned. Therefore, in this case,
> ensure that KVM does not set up, nor advertise support for SEV, SEV-ES,
> and SEV-SNP.
> 
> Suggested-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Srikanth Aithal <sraithal@amd.com>
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> ---
> v5..v6:
> 
> * Rename is_sev_platform_init to sev_fw_initialized (Nikunj)
> * Collected tags from Srikanth.
> ---
>  arch/x86/kvm/svm/sev.c       |  2 +-
>  drivers/crypto/ccp/sev-dev.c | 10 ++++++++++
>  include/linux/psp-sev.h      |  3 +++
>  3 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b709c2f0945c..42d1309f8a54 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2957,7 +2957,7 @@ void __init sev_hardware_setup(void)
>  	bool sev_es_supported = false;
>  	bool sev_supported = false;
>  
> -	if (!sev_enabled || !npt_enabled || !nrips)
> +	if (!sev_fw_initialized() || !sev_enabled || !npt_enabled || !nrips)
>  		goto out;

Me thinks this wasn't tested with KVM_AMD built-in[1].  I'm pretty sure Ashish's
fix[2] solves all of this?

[1] https://lore.kernel.org/all/d6d08c6b-9602-4f3d-92c2-8db6d50a1b92@amd.com
[2] https://lore.kernel.org/all/f78ddb64087df27e7bcb1ae0ab53f55aa0804fab.1739226950.git.ashish.kalra@amd.com

