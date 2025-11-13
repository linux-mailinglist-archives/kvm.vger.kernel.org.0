Return-Path: <kvm+bounces-63052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DE8E3C5A146
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:19:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 631784E4500
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 21:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D132B3233E8;
	Thu, 13 Nov 2025 21:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NpdzPWLm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0048A261B6D
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 21:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763068556; cv=none; b=bUMW+NkXouzt5ySkayhyITyEaPtZoVQLugz6a5suI/ya0fHj6EIpen1r7ZrtoxizaTDRTqeqy+4uUFEfKZvNl+SVi68GwjX9XVurl6t9NvBoubFqAjAIXtskP9sgcpMxMnUFyBd0L3VE5adn5DoIRrF6VfXsCSzq/RHpLMu/bSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763068556; c=relaxed/simple;
	bh=JlbnF1+Miz9+WltFJiWNGqBdZlSaszjURQds1GG4q94=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h+oWytgkckRLiJ0tnl8OlfHNYcjLSQbQXQwazZNmdhv+DrcNUWuEJSjnZeCTIBSxXmY4nyK1G1lenF31zn4kh8JwJjF7+Ztw6sTGxgAecwa+nufLs0wTBleGP8esWsLjopBkrOrgoi8q5SYwbrYQFEokv6Ehh7bfic8cNCiLoSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NpdzPWLm; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340c0604e3dso1618999a91.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 13:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763068553; x=1763673353; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ff3EWcIQuw+YV2qhyOlP9oPJacgoGW33b/BuZqsgvi4=;
        b=NpdzPWLmzrVUn+FZQIRWpkORkJdoW4pMD8NehAr8VzXqzLpqa1SdqzrUgAz5naZNfb
         w2vAS2mijWauDK4ntZAd1I9hFFpvaJ+qiDhqB5BcTTPcXvhUkZQ7pi8sS9g4mXOGh1Ji
         zFFlGRLVaJHtaE66Jm+2J4tfRotbtyx4C5wMdHqNIsNWWmxHgUGmNx+HD7KL3AsK1/Wu
         ebr5sJRq62miqbgS2hnTcU3+vq3Hkh1W6gc6o5HoYjevouWMWOK2Sz9kl2bajY+wd3qA
         vnFLwVxRlGzH3dKh+3JKn0eV0seTVafgebfUBj3GzluwjkYAkCCJ8suJzAtRwrbXATce
         bzMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763068553; x=1763673353;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ff3EWcIQuw+YV2qhyOlP9oPJacgoGW33b/BuZqsgvi4=;
        b=R7jYAqn9ISiXK4eGr2s1HO1Ue6rSXW3QW7vcIY4CxM/X7GXvEwN+PllrJhxnxp2PmA
         LJLoaK7KtVXJO4O6zr8gsibG8vZ95MUNbDcTKQQ8MYxUI4f3IyJatDc/sYwlAPT5yCfy
         IUmn0ubaAbPl5K8tKFDij9/g+Uw83AV4v6oLVCLM8Q7ZRxtBr3SSYp0NXPbRlykkkE/e
         N4ir6sK0OoxYNDzeO/USNTppKXWupOq8ZSpHPACY+Thjq+UEJyZIio8KWRdkhXYpyAw6
         fVH4LDzXTWYI+AmC41GNBoEjX8RZhZMcsIurue6HrE1KcnI906QP03HHY+8fnD4QUzwN
         G07g==
X-Gm-Message-State: AOJu0YxbSQdA+K3kjaSJ1wilWMSd4J83/bOvrWqCwR33EoCt2P518Fos
	29pvmrNgV/jWQ04Jxmdk89Wfecs3V1sbpagcgOhLd0myHRBd+uKK+hpHIIBaWa1emyy6y4H1gDP
	AtpLXyg==
X-Google-Smtp-Source: AGHT+IHTvDg0Fvfho2plPN2GuX7qIZOwANyRsPh/XlR4u6dO0fQ8jS/rLmriSL1JSLeZyf3zKAVGdzai8vQ=
X-Received: from pjbcm4.prod.google.com ([2002:a17:90a:fa04:b0:341:8490:5949])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b0c:b0:32e:1b1c:f8b8
 with SMTP id 98e67ed59e1d1-343fa63dc90mr700635a91.26.1763068553344; Thu, 13
 Nov 2025 13:15:53 -0800 (PST)
Date: Thu, 13 Nov 2025 13:15:51 -0800
In-Reply-To: <6e9d3d9d-6541-41ed-994c-04415962a7da@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1761593631.git.thomas.lendacky@amd.com> <e3f711366ddc22e3dd215c987fd2e28dc1c07f54.1761593632.git.thomas.lendacky@amd.com>
 <aRYo05KMsaNdj59U@google.com> <6e9d3d9d-6541-41ed-994c-04415962a7da@amd.com>
Message-ID: <aRZKh66hJWCtqgz1@google.com>
Subject: Re: [PATCH v4 2/4] crypto: ccp - Add an API to return the supported
 SEV-SNP policy bits
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-crypto@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 13, 2025, Tom Lendacky wrote:
> On 11/13/25 12:52, Sean Christopherson wrote:
> > On Mon, Oct 27, 2025, Tom Lendacky wrote:
> >> @@ -1014,6 +1031,7 @@ void *snp_alloc_firmware_page(gfp_t mask);
> >>  void snp_free_firmware_page(void *addr);
> >>  void sev_platform_shutdown(void);
> >>  bool sev_is_snp_ciphertext_hiding_supported(void);
> >> +u64 sev_get_snp_policy_bits(void);
> >>  
> >>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
> >>  
> >> @@ -1052,6 +1070,8 @@ static inline void sev_platform_shutdown(void) { }
> >>  
> >>  static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
> >>  
> >> +static inline u64 sev_get_snp_policy_bits(void) { return 0; }
> > 
> > As called out in the RFC[*], this stub is unnecesary.
> > 
> > [*] https://lore.kernel.org/all/aMHP5EO-ucJGdHXz@google.com
> 
> Ah, sorry, missed that one. Do you want a fix up or do you want to handle it?

No fixup necessary, assuming this goes through kvm-x86.

