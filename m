Return-Path: <kvm+bounces-19597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BD16907932
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 19:01:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E199EB2212D
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 17:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8CA714A091;
	Thu, 13 Jun 2024 17:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ADEac/KR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DD81474D8
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 17:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718298092; cv=none; b=rmmNkK1WUbw300XdEtNahx0IQJqbTPCLexNYEKh2sh7pTYwWDG4wGqsKbJ0zppPYvfmkqvAC+R5trIxSnx6VwYBW+ApEbxJzAR3YscpYXASsLeXAINzLPe05xfyM9rjWEQovHczM5byJkqCzUW3DMBoYUnn3sEopijqa0ZJSnyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718298092; c=relaxed/simple;
	bh=0lQAT2+KMVRgoQfAgOXbFpy27kuZJljG825RDkACMEY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JdSSz94xzx+qFuxl/WckHuOXqwiE6wIHm65JbrejXpiunIjaOWJchryUprdtf7tMD3jGLJBo2R3bqKifz+dptjK/LN626S2yMuDqOL0LUE2+uDzEQ8BMkhPL2ryNSyZE+hVwpSjOYEpiUEXymvMQsmw7ZkQS/UQ0t/TBJWjuUko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ADEac/KR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c2e7719d30so1048334a91.0
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 10:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718298091; x=1718902891; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XStJnbLK4V1qhVKaIcxt2hEnuPMBNwhPJrtY0iEHhTg=;
        b=ADEac/KRHgff2C9IepoV7zzOz6xmZ8nc89FX03seKfRMKn907bPjGbTmCTH9eAsUu2
         aBGU72SZ8aBrK8fAjnZL1yQxV4DQ830AOUTlZRaDJDNe6QaUUohoWAyMiPBxpGwzcNT8
         lIVc/2gFQboPK6Fv5op1Ouq+1uw+vOAccO6L6Wp48++zRL39p0fzMnZog52djMe9vw3k
         o9SdfCOPto6z3LSTOayJdRBtHChp43dLyS2FIgMfgIkd94jBhZndNTpZsJSErAucg5sR
         h6kpBLkiKNqxtPCpQxzxcXgC3WKvMjRvqpF4AOuP7m1Un0bKZv8KBkswQKfqvQOGfgLm
         yoDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718298091; x=1718902891;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XStJnbLK4V1qhVKaIcxt2hEnuPMBNwhPJrtY0iEHhTg=;
        b=YQVyICA8r03ciBP9oPh82tuS1a4NSydZuwo1P4gE6wAQYRIWUYr1InleIczOnLl/HO
         DWKVziD8JC2J9LWvsmOp6pAFg3hoERT+ZPFGb6UYhWiqfRJLKyhQ5y7Kde/BVvLjQxbq
         yyiyl1QQpq2DE0r0oMRImTVjkohwU3RYDfCHct1CsoJcTTMxXbCqQmH+l/CYs3z92rFs
         wi4BBPk7hiKxpAdliTgoFspxtcIkytO783FObgrOH+NTL0y4dMoAk5wyxezjkZHajIN6
         YZLgQeXjt88OGwMC51bbTdYwfsg0vD9gDGnW7KBiFycAXPM+61yjCq0RBy+LBfPztn48
         HMPg==
X-Forwarded-Encrypted: i=1; AJvYcCWdNhMNER+rsQXrFrfLU0+0TRJIAfEQwwZ+DkrjXgCBancXiAQRS9bB6+wjzsc40FqBq7/J12xJHp5eI+sm4IYaghjS
X-Gm-Message-State: AOJu0YxGPa8euar7Z2l90H0mi2VhLMr/mVRi8gfu205pCshaQ+P7gohi
	Stj+COxCAoJDA/Kaw2N8kug9nLJoYJuEGhB/KnpxNfZZwJincpggPzMXABNJQCRuLhWHzEmJFyr
	Ifg==
X-Google-Smtp-Source: AGHT+IGY0fQD4689v6rLCIHgS6868CkRehhGNu4lanKhlcUUceleGb6rw06vnZTUAaafVZSYbUgXh/S7jdE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c7d0:b0:2c3:c8b:f634 with SMTP id
 98e67ed59e1d1-2c4da9c8aefmr1011a91.0.1718298090662; Thu, 13 Jun 2024 10:01:30
 -0700 (PDT)
Date: Thu, 13 Jun 2024 10:01:29 -0700
In-Reply-To: <20240207172646.3981-14-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240207172646.3981-1-xin3.li@intel.com> <20240207172646.3981-14-xin3.li@intel.com>
Message-ID: <Zmsl6WtT40-u4Pkn@google.com>
Subject: Re: [PATCH v2 13/25] KVM: VMX: Handle VMX nested exception for FRED
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin3.li@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	shuah@kernel.org, vkuznets@redhat.com, peterz@infradead.org, 
	ravi.v.shankar@intel.com, xin@zytor.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 07, 2024, Xin Li wrote:
> @@ -725,8 +733,28 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
>  		vcpu->arch.exception.injected = false;
>  		vcpu->arch.exception.pending = false;
>  
> +		/*
> +		 * A #DF is NOT a nested event per its definition, however per
> +		 * FRED spec 5.0 Appendix B, its delivery determines the new
> +		 * stack level as is done for events occurring when CPL = 0.
> +		 */

Similar to my comments about CR2, this is mostly noise.  Unless I'm missing a
patch, KVM is not responsible for emulating the stack level stuff, and so there
is zero reason to mention it, because it's not relevant to the KVM code.  Simply
say that #DF is defined to not be a nested exception.

		/* #DF is NOT a nested event, per its definition. */


> +		vcpu->arch.exception.nested = false;
> +
>  		kvm_queue_exception_e(vcpu, DF_VECTOR, 0);
>  	} else {
> +		/*
> +		 * FRED spec 5.0 Appendix B: delivery of a nested exception
> +		 * determines the new stack level as is done for events
> +		 * occurring when CPL = 0.
> +		 *
> +		 * IOW, FRED event delivery of an event encountered in ring 3
> +		 * normally uses stack level 0 unconditionally.  However, if
> +		 * the event is an exception nested on any earlier event,
> +		 * delivery of the nested exception will consult the FRED MSR
> +		 * IA32_FRED_STKLVLS to determine which stack level to use.
> +		 */

And drop this entirely.  The above does not help the reader understand _why_ KVM
sets nested=true for FRED.  E.g. there's no CPL check here.

IMO, this code is entirely self-explanatory; KVM is quite obviously handling a
back-to-back exceptions, and it doesn't take a big mental leap to grok that FRED
tracks that information by describing the second exception as "nested".

> +		vcpu->arch.exception.nested = kvm_is_fred_enabled(vcpu);
> +
>  		/* replace previous exception with a new one in a hope
>  		   that instruction re-execution will regenerate lost
>  		   exception */

