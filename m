Return-Path: <kvm+bounces-54989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69183B2C6BD
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 16:17:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 743447B6647
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 14:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE0932571D8;
	Tue, 19 Aug 2025 14:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DS63xpEm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9412424DD0E
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 14:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755613040; cv=none; b=bLtf9Vb2mLi49Cu/oYo81ozTpo5WYSo0YoEXCZJ9+QxjMssWhAvRcsmXD/yyCZcaAXCKKinNLRohPbTdAwjwqi1HQZH2XAgD7u241ugtBHNCSYDsAiM7Z8964KasLoZ7H5IgC71HLfj1Mv+7KiC+rXzb5lejdNVBBfvTYzfgrzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755613040; c=relaxed/simple;
	bh=KZo6lFE+1XnNnQGXrhcQMuv8VUWLOdbzBDwzfflqaVs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UheeFiEx6qFA0E+lAQE4RRzqZwWkaxj1H8pgnyIgF/MAxAyn25AP+s4WwCnBbAoZzyUc2vuVgkwAXqZwczFfVFYZHF2X55LTIvrN6TGeVyK1vleb4LOei/r3Js+vwJymTkbzN8tZeCviBslONHeULjlNpnP8mS1WdJlfMtgkEiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DS63xpEm; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326789e09so10498291a91.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 07:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755613038; x=1756217838; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tk8qLdHc0U05Dxo1Ab/dvD77IqT0ZtETlVr+X1bxo7E=;
        b=DS63xpEmkBNKG8te3iQiBgidtvSeirR7Yf3PVaiC1vn5isI5KeNqBabxWCeG4h0cdJ
         xYEzHQ1xJmNQAUflVl1WfxnCMS0YT3gS+SX5HapsSdhkXOpQWWTJpFKRP4Gs5D286Jd6
         kqp8U14sToZ4oUeCHZpY70hbKvAs4MUtooh/KfWLStWmfvSK11+a0vtiWTOQkyYdy8vd
         C/Iz/fK1znVGojIoLLWiRNHH8AnYR5m2iG0G+7GUhFoqnkAMljNoaloT0sZUoskSQQ4E
         UEJ5d15aKtpsM1pynJoVGKYx5ZXTzsaEaGDQ8KR030y4PjGmMH2oOZQoxlkL4j1fctwd
         hGLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755613038; x=1756217838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tk8qLdHc0U05Dxo1Ab/dvD77IqT0ZtETlVr+X1bxo7E=;
        b=dMiyk3wMottYrU5KFGZ7PJtoFofcCgoles6zAmIve4u7n69H40s5KlFMgGHGMNNKDP
         rWRno/L2NK33/vbZxK4sEkDUhnuMgLR9DsJ/TdIHNQwbRJ1zHmjnJWjXgtgwU3JxfS9d
         wOffNN0bOu+EeEf7s4CuAQ7RpNwhIpVlOznUvGAHub6wS2eH96KWBoSDpiAW9wqsQX11
         qOGRoMNs6EEHze0NZvVJ2H+oZIOMF9ClJSSbkcTyw+yzX08eTpsagfqmDqQ5MMvm2Qzd
         nb8b9ymK7Oj+Q1NNboTr85+SSMAnGH4ilQ8TZh35MrRq5G6j2DQwMMlnG5j17WJD3CxG
         XKWg==
X-Forwarded-Encrypted: i=1; AJvYcCXaff8Auq8Q8z8AGe+PIWg2VIXtjHCkyZyjmZqAgyejlOIdzJoHaoEM+uCaQF2c5OKQULU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZGp/CjmnrgmNxwnphThHGkoFvLK1Ycw3c7lx34HHfJ08jyW0h
	GllJhBawYTFZ+BHZfuIOuJ2pZCHkVr1chvdD8muT9AoJW2Xsd1jer2NX1gmjDKuTWZma+kaOK7P
	OFJmdkA==
X-Google-Smtp-Source: AGHT+IG+R29IibUM+skEvVsfUw+0/0piaRJ4aJbmBSk01NC1yZeCdDU/KApLU4ScisyIbczr3lj7S9517lU=
X-Received: from pjbpx1.prod.google.com ([2002:a17:90b:2701:b0:31e:d618:a29c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5202:b0:321:c85d:dd93
 with SMTP id 98e67ed59e1d1-3245e562cedmr4184520a91.4.1755613037551; Tue, 19
 Aug 2025 07:17:17 -0700 (PDT)
Date: Tue, 19 Aug 2025 07:17:15 -0700
In-Reply-To: <20250721134718.2499856-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250721134718.2499856-1-colin.i.king@gmail.com>
Message-ID: <aKSHa8QhidY0ZMAi@google.com>
Subject: Re: [PATCH][next] KVM: x86: Remove space before \n newline
From: Sean Christopherson <seanjc@google.com>
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, kernel-janitors@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 21, 2025, Colin Ian King wrote:
> There is a extraneous space before a newline in a pr_debug_ratelimited
> message. Remove it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index aa157fe5b7b3..e5358277d059 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3142,7 +3142,7 @@ static void enter_lmode(struct kvm_vcpu *vcpu)
>  
>  	guest_tr_ar = vmcs_read32(GUEST_TR_AR_BYTES);
>  	if ((guest_tr_ar & VMX_AR_TYPE_MASK) != VMX_AR_TYPE_BUSY_64_TSS) {
> -		pr_debug_ratelimited("%s: tss fixup for long mode. \n",
> +		pr_debug_ratelimited("%s: tss fixup for long mode.\n",
>  				     __func__);

I'm inclined to simply delete the pr_debug.  I can't imagine it's at all useful
for anyone/anything.

>  		vmcs_write32(GUEST_TR_AR_BYTES,
>  			     (guest_tr_ar & ~VMX_AR_TYPE_MASK)
> -- 
> 2.50.0
> 

