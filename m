Return-Path: <kvm+bounces-46253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B47ECAB4336
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:31:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06CBE4A3B23
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FFA629B8D6;
	Mon, 12 May 2025 18:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ug+h8PqF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6DE29B79E
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073707; cv=none; b=OoHwio87Au4SlP259ndfKdUW64mkuWV5JsSmECBG+GOQGGj9CF+hbJp45HHjTjt94hxxgXpex3TQCwgS8cMHte90QudU41Ioux6orZgcoRHwsOwlRTOV2dL1GldhBJ96dGrZZYjuNLddZkOGKLNvx89pOQ0jAxlYh2QkjHOh8YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073707; c=relaxed/simple;
	bh=XRgxPrQuWwX712fF2KflNnXoQ502wCaR5BHoTUuXB04=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KoPOf1M5rhtB7kcqMxWdv/I12UjEjR1FsUMRFMRZoR0AtVvFxjgHbBJzamPLIsJKlh3X9rJ5MfL5VbhQMYcc5ropFMyG+K0zbbOvOw3WPXdBSm30A4UgsVBQLNpItDaTImVe9lZl2qGB3C8T0S2b4odQshNM+2JiVkojKvlObss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ug+h8PqF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a59538b17so4582728a91.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747073706; x=1747678506; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OawiPZy4beozboh+ADi996BCPJ4CwdxLLRfTTirpfYY=;
        b=ug+h8PqFIOYv+/rpwt+0myhrSFKCuhi5YOUYAIGZOSzdmaKzrg8MmIe8cDEXBxcTea
         eOwjhDae5vTE4LFccjbA4e6foVEUaHXr72EhBIqLTanKanPn+AXl8B7osRwjQhuoXBZb
         TK1ELQe8jMw228FsGuZORMmIQaylSTRcCzHzVuw2yXY3Xg2jjgNtBKDF5uxOGkKmAADk
         vnzJB23Prm0q5jLj/j/S+ekp4m1FKLH8U5LOGJ4Sy8uZ+oGvstxLOy2WLiY+ydnpoHIx
         iMJEUzS/OCvR20fdzks7g5zP98BLxJCDWGeCcih11YTKxo+L7MivgH6MFt44QxLD98DI
         3RMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073706; x=1747678506;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OawiPZy4beozboh+ADi996BCPJ4CwdxLLRfTTirpfYY=;
        b=biLCufi6Gw00BjjmfJMycfXd4xJFBWcfhI4wlK+a5Sm0O8svbLcLY8qouKOx7rw+3x
         4mvxF7dZAgT0ViIEzyxiwQRtTZKT7qxNw0/khAcJlmvZIKZnUNyd5Xyteu+KeWh46lUT
         f99Pp1UouIH7ASraR/0LHaPeKBoBfH8AkjBj+iNaXUnD7wmJlEIQ3VAaJdKjDcSPNfcT
         1qENkmSq8M0aMc/vyUEYY4v/2GUnQmI29T4Ha0xVZvZ02S/z1T1QjlisSPDTREIZYAe8
         3PL2Jz5WpSu1OSUsHCGoWrA0cUftDLGlMHDRfn9nUxh5RTclA6QXMH+pH1iUjKWseIxp
         nmmw==
X-Forwarded-Encrypted: i=1; AJvYcCV3FtTZaOWPRsV3I0fk9PokNRTJmG7e6VsJqW3VNjZ9jRJovBx5BGUIhhGE/A+LK0c6M3g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeNx9tjPCdkdG4WeNKoFNlxsPRdTGeTSEr9xOglk+t+pECDq+l
	B0ny/gteYLeNq/GVdEnekxCD3Qr3mbJOQjhCIfeuKz+8I0saF5e/xtButi1hV01dwXJ84GxSKi5
	6Tg==
X-Google-Smtp-Source: AGHT+IGyau0PoBP95Yo7LfzxSiqa/oArBrnyxawTOxipXchYIU5+/lMqeUCH5/FZBJvvi0+YCIuI2+JTqkk=
X-Received: from pjh4.prod.google.com ([2002:a17:90b:3f84:b0:2ea:aa56:49c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1843:b0:301:9f62:a944
 with SMTP id 98e67ed59e1d1-30c3d64f332mr26562923a91.33.1747073705884; Mon, 12
 May 2025 11:15:05 -0700 (PDT)
Date: Mon, 12 May 2025 11:15:04 -0700
In-Reply-To: <20250313203702.575156-6-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313203702.575156-1-jon@nutanix.com> <20250313203702.575156-6-jon@nutanix.com>
Message-ID: <aCI6qMg6OjT-cWzR@google.com>
Subject: Re: [RFC PATCH 05/18] KVM: x86: Add pt_guest_exec_control to kvm_vcpu_arch
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 13, 2025, Jon Kohler wrote:
> Add bool for pt_guest_exec_control to kvm_vcpu_arch, to be used for
> runtime checks for Intel Mode Based Execution Control (MBEC) and
> AMD Guest Mode Execute Control (GMET).
> 
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> 
> ---
>  arch/x86/include/asm/kvm_host.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index fd37dad38670..192233eb557a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -856,6 +856,8 @@ struct kvm_vcpu_arch {
>  	struct kvm_hypervisor_cpuid kvm_cpuid;
>  	bool is_amd_compatible;
>  
> +	bool pt_guest_exec_control;

Again, aside from the fast that putting this in kvm_vcpu_arch is wrong, this not
worth of a separate patch.

