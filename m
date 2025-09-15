Return-Path: <kvm+bounces-57641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D131B587B3
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:42:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B4E41B258C2
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 22:43:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AA372D5C86;
	Mon, 15 Sep 2025 22:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M0eGpImO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0565F2D5C68
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 22:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757976156; cv=none; b=IXR0MbZijPNL3yoJoeYwuNqqOOxeB5u0u5I4hEb9yr0Wvq5nbzQliBsbJfm8EwUB02bRqSwXrqyTS00yVWS8rAzPVTrQMtd+b7QBIYi5+cM7nzoZNSmADMhufIMRlkN10ETX8V0w/cAlRfYfPOnpt0s42ENELt+8cmGgxx/K+go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757976156; c=relaxed/simple;
	bh=13zLzpfHJ3rbqJnw/B4wpMpeY4yBoRUl0yj1LjoS/B0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bP/cNYBY0udLeRVIvtVQZE9MTZvH/uW0829BbdRGqsA7iYWCk82ug2VPdwSMxd1fIpEM+eNRCaKUzi31hcbPO3M0Va8antyL0ExblxRkRBAyzq3AkzD2nOAm+GmB9wn1Hqcn+GDGXJ6YcN3oCXsWRQbY088yXA5SdCmZcY9faEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M0eGpImO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32e43b0f038so1246711a91.0
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 15:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757976154; x=1758580954; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=om69MBA/Gpwbf/SzDc2SN7iWNn0HD2BqY+WWEl3HQx8=;
        b=M0eGpImOSBlZMY54Is7vHbpQbYHHf/CRx1499+diupbAn0ZyC+93faabao8fSjGmCj
         zVyU2gCDOgieShBL+xkCx0d9d1PMNI2s6AJt0gIzdktQfe8QAvuftmR6rZ1kS065Zg5W
         9NCDEuwYlKMa/Kp7ZDE2mmJBPZp/LGN8fcb9kRZL+ulhD+DGfHOzZmxYOyrIaU5tF56P
         E526Co+8lAa3dzyd3g3fSzOAUoHZw/XAlvMcoYwk5rnJ3IJiJI9QLXA2UBN6dkyluNua
         q5Cb5zdiAfLdVTQoO5Meg2/VV17XdYwAle6HmpFACeoqws8fa2CHsE4FqiPgtd0A8O0v
         jcBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757976154; x=1758580954;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=om69MBA/Gpwbf/SzDc2SN7iWNn0HD2BqY+WWEl3HQx8=;
        b=PVJOtesRWzhsRJHa7j5H78HE+mWtwO+Mhj6OQrFDt53ocfRmtNW159pQmCx3U/EjPo
         EdNzQzcdOU4Qhg3k3brlubM0B/T/xdK0oTJ0cufQNqsc2dVMN2ZqMWL9Ds18lrgPPptV
         kQBZpGZy54cdfBcLBvihSImsP6trTkELd0ALFWDtGZRadJu4qFSynaZjGb7V5t7oY/fF
         l4haVEfS0odArb1LluxqcrkGj37LX9NydQ7Qn8byaOGVXFIjv6NTzbN6bV31ctY3yhfd
         3Ag8hEuEvDRCfzVfEhFu+NPQmfhvrJI5O1Hzl2xU/yu7KyPGHjPAcB0B/QYYEWpFYg3y
         Cx4g==
X-Forwarded-Encrypted: i=1; AJvYcCV/EWg2EYgxokV2oB3X1jaUxjvfX4qFJLkMCO6ge1PTtc/6JbOzjEAsKTgYMctkLqXANdE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf5HlJxpZDNqQYO5ZIYdATSsNYCm7+KFnkzuK/UKEIthhmr0Ff
	mtXA7zSVJOfG3OuMUpXSCA7pXYfpO/7ZkbD4f2GnE/Db4Ap5hwQwVCzdhz+x/tvVfuf4Neg7z7Y
	043RgGw==
X-Google-Smtp-Source: AGHT+IF5wofdTIyZQbyg9SrGwozLbkP1P+1cPya+7f1zmdEnisMkX1D0cjM5ZmR5k3MFPWwPLrB1/c+GAQA=
X-Received: from pjv8.prod.google.com ([2002:a17:90b:5648:b0:32d:e096:fcd5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c06:b0:32b:6132:5f94
 with SMTP id 98e67ed59e1d1-32de4f85710mr16653646a91.21.1757976154253; Mon, 15
 Sep 2025 15:42:34 -0700 (PDT)
Date: Mon, 15 Sep 2025 15:42:32 -0700
In-Reply-To: <5ebb7b1c278b6f20ee4f7afa0228298f9e504fbd.1756993734.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1756993734.git.naveen@kernel.org> <5ebb7b1c278b6f20ee4f7afa0228298f9e504fbd.1756993734.git.naveen@kernel.org>
Message-ID: <aMiWWM6hb-Cm3QK3@google.com>
Subject: Re: [RFC PATCH v2 2/5] KVM: SVM: Simplify the message printed with 'force_avic'
From: Sean Christopherson <seanjc@google.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joao Martins <joao.m.martins@oracle.com>, 
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 04, 2025, Naveen N Rao (AMD) wrote:
> On systems that do not advertise support for AVIC, it can be
> force-enabled through 'force_avic' module parameter. In that case, a
> warning is displayed but the customary "AVIC enabled" message isn't.
> Fix that by printing "AVIC enabled" unconditionally. The warning for
> 'force_avic' is also needlessly long. Simplify the same.
> 
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> ---
>  arch/x86/kvm/svm/avic.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 346cd23a43a9..3faed85fcacd 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -1110,16 +1110,8 @@ bool avic_hardware_setup(void)
>  		return false;
>  	}
>  
> -	if (boot_cpu_has(X86_FEATURE_AVIC)) {
> -		pr_info("AVIC enabled\n");
> -	} else if (force_avic) {
> -		/*
> -		 * Some older systems does not advertise AVIC support.
> -		 * See Revision Guide for specific AMD processor for more detail.
> -		 */
> -		pr_warn("AVIC is not supported in CPUID but force enabled");
> -		pr_warn("Your system might crash and burn");
> -	}
> +	pr_info("AVIC enabled%s\n", cpu_feature_enabled(X86_FEATURE_AVIC) ? "" :
> +				    " (forced, your system may crash and burn)");

Except this bundles the scary forced message into pr_info, which isn't desirable
since KVM really should "yell" about AVIC being force enabled.  I 100% agree that
not printing "AVIC enabled" is mean, but I think we should do the super simple
thing and just always print exactly that.

>  
>  	/* AVIC is a prerequisite for x2AVIC. */
>  	x2avic_enabled = boot_cpu_has(X86_FEATURE_X2AVIC);
> -- 
> 2.50.1
> 

