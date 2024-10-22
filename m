Return-Path: <kvm+bounces-29426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A369AB495
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 19:01:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B46F1C231D0
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 17:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D341BC065;
	Tue, 22 Oct 2024 17:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ceIZXixH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D8B1E4A4
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 17:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729616471; cv=none; b=OX6DqMBQKgZ+TZk1S45RCFr84+kestfAF0wHH0+5bqnLOBqJCAc9hqp2R5jJ/pWJlohLIPpjLwwfXxq7vagI8zgD4uG2Arbf/h6k1vMkdXYRCA+kT1dVyhZuXSv91YnVat3+uePt+8zFPuOcNlZgYsFCMpiGi+j46JQdhCSBYYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729616471; c=relaxed/simple;
	bh=ifN6cqjsbcmVpO5CYfsnF/3RQKUBqSnhMcykdzi5jb4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JMReaxDPDcviZ7Wr13n3eoD+jlR2eowJXAg+DHtLWmpmQ5Nq6b9lirEG9XZVf4FoY+FGvRKy5EWthr4cggD8k4zzuV7/0llPa8uSLKufU9DShvECwL2L0Zxw1psCLY6Yek3SMOOzhTM71r8XMJ8Lxonxu2skw3MWu38d4BRaOXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ceIZXixH; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e6d31b3bdso6815280b3a.2
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729616469; x=1730221269; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jz6HPAUfPJFv2cSc6XtRrNpTzfpz4jKdakYIVYEvHsQ=;
        b=ceIZXixHrUxi8vI2mg7nuMSmPm9EK4NbX9bdd3yPhNRAE/VY3ZoNnnqv/XKSdUE100
         piaD/JVaUe5vE1Q60+kDOc0q8ljpOcP9silpkjlZeEy7M0Xc/wQr1xd8ywk3Xgh3XtZP
         qT1QhbCYVXdSy2EekVNLsJ0td6pXFXNBvJcXMis+2eIdBvS+E3F0AJxiPENYL1++QdF/
         CZR864Eg0SXPuv62OMkkyV8+9hZWxnoB+fTcwgaA1Ie/mtTaW/tTWaO9h4MjsYOf1mi0
         VJn9v4aXR+B2agDDNu4zgKI2qhz9aARMzeH2HCNuw04/vEYmWI/VR0wLYtrBYzc8NPlL
         4WPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729616469; x=1730221269;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jz6HPAUfPJFv2cSc6XtRrNpTzfpz4jKdakYIVYEvHsQ=;
        b=c5BlaaK3j+W4b8WdRAxMkF7qh0CesyCkHaj2rhbzkd2IKMeWujMWOfOAo7ZU/lWRfV
         agoR1dHh9KbXsVD4OpSp5WqseRogelTx9u45aH7hJP9JJ5/kTZTBTQ8E8lnHehLqQRJ1
         vkw5emk4ZTma501JC0SmEBstKWoyXJAJUtRxO/2v8HXEVVO8xqxyNIz/2sTD4mym+SS/
         /1wXXNHaGu9h+XczvSP3DBt0HQajmqllh5jTuNNzwlKxfyFZwyXG1d37NWK1kQai+iEh
         MFSGLyuoLT3fP81KDYLcExR58Tyuiu6K56UK3ut0jHL3wv8ps2HdJvn6oxZPtCISB29Y
         SZ2g==
X-Forwarded-Encrypted: i=1; AJvYcCXxCMuTDOlIFo1n78s1caWdWZwMoq37RxlJd3yo4ZIF9nHZVE+/WJfN8SG54zlKe/oa6BM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv8QYz9jdj6Pd34PbCGyKK3b7SNLOCj2gQxYD4z5BjaYoA82M6
	qU3wRqSq9W3A/2xupToIyc/RC9p2Jd2xqSFdRZxiPiSEHe0oBr+1ZCh+wdxaXkr/NXE4eue0VSc
	mRg==
X-Google-Smtp-Source: AGHT+IHnyZ3xuVY7Clm+eBIYyW7Mrfkpkys2oJltNzld9dORGFnn5Yu6KuNOVHJzto/+35IL38mQWUk0W7o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a62:b403:0:b0:71e:4ad1:b133 with SMTP id
 d2e1a72fcca58-71ea32daff6mr27874b3a.4.1729616468773; Tue, 22 Oct 2024
 10:01:08 -0700 (PDT)
Date: Tue, 22 Oct 2024 10:01:07 -0700
In-Reply-To: <20241022100812.4955-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241022100812.4955-1-jgross@suse.com>
Message-ID: <ZxfaU9cCS6556AKg@google.com>
Subject: Re: [PATCH] kvm/x86: simplify kvm_mmu_do_page_fault() a little bit
From: Sean Christopherson <seanjc@google.com>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 22, 2024, Juergen Gross wrote:
> Testing whether to call kvm_tdp_page_fault() or
> vcpu->arch.mmu->page_fault() doesn't make sense, as kvm_tdp_page_fault()
> is selected only if vcpu->arch.mmu->page_fault == kvm_tdp_page_fault.

It does when retpolines are enabled and significantly inflate the cost of the
indirect call.  This is a hot path in various scenarios, but KVM can't use
static_call() to avoid the retpoline due to mmu->page_fault being a property of
the current vCPU.  Only kvm_tdp_page_fault() is special cased because all other
mmu->page_fault targets are slow-ish and/or we don't care terribly about their
performance.

> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  arch/x86/kvm/mmu/mmu_internal.h | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index c98827840e07..6eae54aa1160 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -322,10 +322,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
>  	}
>  
> -	if (IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) && fault.is_tdp)
> -		r = kvm_tdp_page_fault(vcpu, &fault);
> -	else
> -		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
> +	r = vcpu->arch.mmu->page_fault(vcpu, &fault);
>  
>  	/*
>  	 * Not sure what's happening, but punt to userspace and hope that
> -- 
> 2.43.0
> 

