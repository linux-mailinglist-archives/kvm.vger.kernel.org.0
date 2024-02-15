Return-Path: <kvm+bounces-8821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A625A856E13
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 20:55:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D75491C22A12
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 19:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A3313A89F;
	Thu, 15 Feb 2024 19:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vOopWdvt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD8D13A86E
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 19:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708026934; cv=none; b=l16JauoI/yOoZML99gYFv+QIvJ49Jr3vAmAfJmihcNCk9bCITSM53qJhszFjh3TsJUcfe+K19ANBLu0JKmhr6klDvs4QG5HUrjriZ1fqYpTuCAt7dY8zd7Ny8j0w3wCbIGIgRnxhVsh94KQqLzyqH6u2Tqn+d5tShz0xTEknefE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708026934; c=relaxed/simple;
	bh=kT5YoBgoPZ0lLO55VRtAadBAv4FxNR0YQTQAqq356es=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m4Y6dLUc1qkZgEqFG9bSjveI7yYcO9S0wwwzJ1BxR4O5ssohlvey611OQ4bMyY9JIW9L7joavqWRUQncpl3w/J6yATn5kMT7EcGcFPlvaBTS48MPr6LMa+f18BU2yhxGsZBRqot6iyKXm3RJnMHEiJ6zTBkr6G/tHft3tReIAPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vOopWdvt; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-602dae507caso21718587b3.0
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 11:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708026931; x=1708631731; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S+ytbs/OlyKZvUUYHvg+QSwbP7J8EV4VQfdwZAf3qxo=;
        b=vOopWdvt93Hcbgkx7FHYmHUtYfT5N7GfvPQdRvDaT9D5f1z7lP627a8GUUa2CilUAZ
         Cp3U47D2bO3Ycjo9zZ6/XRnm2nIX5ZmZW+5WyodUPYCJWtOKgveXOhTD8bbs9sqbg9il
         8VV1lEZ2uwo2UcWFIoXbkZXY/fW0qX2XIobf7YxVC9k8EJ1qGRzK7684+VEp1fu92C+v
         ADI3x77jhQIuPtv9+jMSzHhS2oEkM/4PzKNAMXFngwEEgjifK2/Qff2oN+lUWR9P/lob
         ihKu3Rl69gIR44nr6r9J24/28xnXgmnaKwu/7Unco6QHPkXZqT82YKTFB+7w2bTrSamX
         xRAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708026931; x=1708631731;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S+ytbs/OlyKZvUUYHvg+QSwbP7J8EV4VQfdwZAf3qxo=;
        b=JKX4rYgFkr12jo/VOOwfjld/wu4kX5X1nwx72t2FnZIv9z6m2z58amnqaDV3VF2z1Z
         L6LhKxgnqGD2ENyr9nAp5BWZL6wLw5mgTrx4srK7V+4BOKs5VH9Xi1hEQ6UHFbaFPSWL
         +ttyc1TTl/aABaXZrp/o570/u37ggjd6OtS9mXvC/DMd0/Wt2f59hAnTLs93rmYiLEZt
         g4yl5V9SixQUbNm+dlX48+6sC+Px+2zPr1JUFMVSYDajPku3nGdh0gOCqWcXoS40aghg
         wpw2pgd1ScWbn43Fivvl8Plpc5TD7eGsGkL7rU/RAsTv0DWJdS+eIs6O2xtt04HRGSkh
         RgsA==
X-Forwarded-Encrypted: i=1; AJvYcCUd279XMVnVRm5XHkYiN0bV23/3dGbfLNnIJENt7laFuw3BULelZZxJocRkyUP4oUqLMx2wIWQbBNj2kr0BZDf+Tono
X-Gm-Message-State: AOJu0YwJe5K1nDxFlzCg+fh+9sntRw8JsxpvznA5UjXMTj82L5eh8TTE
	MC38wkrtVDlsfbs5+y1U6mJvQb8ezG/ijlzuyZ+QShTGojpdImCxbTa4FhivMtwFxAzWph4Ik0G
	Q8g==
X-Google-Smtp-Source: AGHT+IG04njOW89dgCobRztopxDWGJ70SPl/1yBF3/h9CXtghLVsshGy50Hx8eZcwGq/tfqEm9M4YoyGBb8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1885:b0:dc6:207e:e8b1 with SMTP id
 cj5-20020a056902188500b00dc6207ee8b1mr622114ybb.2.1708026931610; Thu, 15 Feb
 2024 11:55:31 -0800 (PST)
Date: Thu, 15 Feb 2024 11:55:30 -0800
In-Reply-To: <20240215133631.136538-1-max.kellermann@ionos.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215133631.136538-1-max.kellermann@ionos.com>
Message-ID: <Zc5sMmT20kQmjYiq@google.com>
Subject: Re: [PATCH] arch/x86/entry_fred: don't set up KVM IRQs if KVM is disabled
From: Sean Christopherson <seanjc@google.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

+Paolo and Stephen

FYI, there's a build failure in -next due to a collision between kvm/next and
tip/x86/fred.  The above makes everything happy.

On Thu, Feb 15, 2024, Max Kellermann wrote:
> When KVM is disabled, the POSTED_INTR_* macros do not exist, and the
> build fails.
> 
> Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  arch/x86/entry/entry_fred.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
> index ac120cbdaaf2..660b7f7f9a79 100644
> --- a/arch/x86/entry/entry_fred.c
> +++ b/arch/x86/entry/entry_fred.c
> @@ -114,9 +114,11 @@ static idtentry_t sysvec_table[NR_SYSTEM_VECTORS] __ro_after_init = {
>  
>  	SYSVEC(IRQ_WORK_VECTOR,			irq_work),
>  
> +#if IS_ENABLED(CONFIG_KVM)
>  	SYSVEC(POSTED_INTR_VECTOR,		kvm_posted_intr_ipi),
>  	SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	kvm_posted_intr_wakeup_ipi),
>  	SYSVEC(POSTED_INTR_NESTED_VECTOR,	kvm_posted_intr_nested_ipi),
> +#endif
>  };
>  
>  static bool fred_setup_done __initdata;
> -- 
> 2.39.2

