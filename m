Return-Path: <kvm+bounces-30961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0431B9BF072
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:35:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 239D11C21B44
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 14:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 453722022E5;
	Wed,  6 Nov 2024 14:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sIBBCyfr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C871E7C1A
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 14:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730903699; cv=none; b=QwJSxW08AgaPmsXulh9/JzrFiwRb6VAFryRueIp8h5Ha/qKMxR4VO+G5qINH2a09AOl/bt4KVvcJhCD1wVONi4W8xhnAftY3w1F+QjnVsPeQSwHvncEjU4fdvO/p8yn8kYHSA/8lYg1G9xgbst/yUnPWcjL9I/ZM984K1aZI9jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730903699; c=relaxed/simple;
	bh=pup6Bx2H6bbZiQK7VkJk+5M1i4APEfd+U0AYUwlyulw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SOh0RIgbz5yTcqQGNcDaMQ0TKBN+VfHmjSRLmFCFVXVuvqmUQBZGc33+Q5KJflIStcRY4pDDe1InmSe5liEQQY5z2mS8y2dz9Z4b+aMSWnGTL6gUDN1tNbP+aeTGGfgvUwX1eDuwlmbQIOlotA6SQv0npVq6oQQDuPtNy3iUrlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sIBBCyfr; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea33aad097so10889537b3.0
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 06:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730903697; x=1731508497; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bdNfAfJ6uGcIqvjU9RF/tIhJYkjaGkmkvEaPHVyDj9c=;
        b=sIBBCyfrbPpwK57DS58zU/XruZESGoDjrQk0W/9las4ndCpx7xz/3ekGjJE/krbn2K
         pR3DsP8Qy/nLrCA1p6nBykt0LK49X/nhG1SbPro4+1ms2G+9cWuruV/J9PVfYEUWd4rc
         qysryyKFxV12solcI5Yy2s11XrRSMEPPaYKAsc+iR0lRxx2pQAKHht6Qv6JUYa8l2kRo
         lUxR3QF0KEcS3P1iiZCGbD47lE36JGKCX1mtd1uV8bN5BZtBDGNK+NDMjCJW3J85WC3k
         vVEI5zfha+WqudcdzuhS0SI0CZ+IfZyuQyqzCfzHgY4EZilHhQqJsS5rt0YSkJMmpNhx
         j0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730903697; x=1731508497;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bdNfAfJ6uGcIqvjU9RF/tIhJYkjaGkmkvEaPHVyDj9c=;
        b=l2XvYcR6hsNmMZkN/kaqjbV/YDIu+4Qn5Tsp5NRZjK/pcwaJhY1hZkrI0TwNZN0pTP
         HEZWcj1WO3dcyFHO9bdwgcrWyr4V9ioqV3g+pHtfBMd9TFB53C//36QlAW7PqPQ0dv5K
         V+hSHQ2aLdbFzXUaYAKG8g70oEeH2KHFSGngA118Z+miXNT9rlO7+Do92IzKpvWdZAun
         KY4h49zdMYNLxtjeb0sMKM4wYGVQDQIHdUiy2e3qQnd4sYql80RBXl7RBeRqYVylS7lL
         a+r2IeZSKbjmr2yKf5xivz7kSWU+N0w4ijWn6u7HILTcVCyX+SGscxtIQDSxMpkbNxB9
         94Jg==
X-Forwarded-Encrypted: i=1; AJvYcCVQyBbS1srjfr9kQI6SuEkebGqXNxbZa5+xWOxm8dtWBzXbQwT4JHHW01QWuvTsy4Sl51A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfZyCzXI+OikR6Cyn4XcwibuSTF7tsHxpQgiVfJMxIC48SVtfh
	eaHstuWmKDp7TjfgpdCSerT+QFWowsl0eU4NnNdKiFi0MiVPhkPKYoJ4J1UI8bEI7krmmpu9+Y0
	A2A==
X-Google-Smtp-Source: AGHT+IGLhqOze19LuZ5LfgYsjD+OI29UKlxovPVi1+TpctQx01BSgPbC/lpV7t9qzY5XocCyloyf4mmjJBI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:ce0e:0:b0:e24:c330:f4cc with SMTP id
 3f1490d57ef6-e335abea802mr11076276.6.1730903696980; Wed, 06 Nov 2024 06:34:56
 -0800 (PST)
Date: Wed, 6 Nov 2024 06:34:55 -0800
In-Reply-To: <20241105010558.1266699-2-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105010558.1266699-1-dionnaglaze@google.com> <20241105010558.1266699-2-dionnaglaze@google.com>
Message-ID: <Zyt-jxNsyMTH4f3q@google.com>
Subject: Re: [PATCH v4 1/6] kvm: svm: Fix gctx page leak on invalid inputs
From: Sean Christopherson <seanjc@google.com>
To: Dionna Glaze <dionnaglaze@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Michael Roth <michael.roth@amd.com>, 
	Brijesh Singh <brijesh.singh@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Luis Chamberlain <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>, 
	Danilo Krummrich <dakr@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Tianfei zhang <tianfei.zhang@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

KVM: SVM:

In the future, please post bug fixes separately from new features series, especially
when the fix has very little to do with the rest of the series (AFAICT, this has
no relation whatsoever beyond SNP).

On Tue, Nov 05, 2024, Dionna Glaze wrote:
> Ensure that snp gctx page allocation is adequately deallocated on
> failure during snp_launch_start.
> 
> Fixes: 136d8bc931c8 ("KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command")

This needs

Cc: stable@vger.kernel.org

especially if it doesn't get into 6.12.

> CC: Sean Christopherson <seanjc@google.com>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: Dave Hansen <dave.hansen@linux.intel.com>
> CC: Ashish Kalra <ashish.kalra@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: John Allen <john.allen@amd.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Michael Roth <michael.roth@amd.com>
> CC: Luis Chamberlain <mcgrof@kernel.org>
> CC: Russ Weight <russ.weight@linux.dev>
> CC: Danilo Krummrich <dakr@redhat.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: "Rafael J. Wysocki" <rafael@kernel.org>
> CC: Tianfei zhang <tianfei.zhang@intel.com>
> CC: Alexey Kardashevskiy <aik@amd.com>
> 
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>

Acked-by: Sean Christopherson <seanjc@google.com>

Paolo, do you want to grab this one for 6.12 too?

> ---
>  arch/x86/kvm/svm/sev.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 714c517dd4b72..f6e96ec0a5caa 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2212,10 +2212,6 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (sev->snp_context)
>  		return -EINVAL;
>  
> -	sev->snp_context = snp_context_create(kvm, argp);
> -	if (!sev->snp_context)
> -		return -ENOTTY;
> -
>  	if (params.flags)
>  		return -EINVAL;
>  
> @@ -2230,6 +2226,10 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET)
>  		return -EINVAL;
>  
> +	sev->snp_context = snp_context_create(kvm, argp);
> +	if (!sev->snp_context)
> +		return -ENOTTY;

Related to this fix, the return values from snp_context_create() are garbage.  It
should return ERR_PTR(), not NULL.  -ENOTTY on an OOM scenatio is blatantly wrong,
as -ENOTTY on any SEV_CMD_SNP_GCTX_CREATE failure is too.

> +
>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>  	start.policy = params.policy;
>  	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
> -- 
> 2.47.0.199.ga7371fff76-goog
> 

