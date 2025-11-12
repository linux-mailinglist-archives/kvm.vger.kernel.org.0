Return-Path: <kvm+bounces-62900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2382AC539F5
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:17:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A955F343A66
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 17:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D9AA344046;
	Wed, 12 Nov 2025 17:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AcpDTu9q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC78345CDE
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 17:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762967703; cv=none; b=QHXD0PKZH5k9aDDb0wUQ6KPYgCGBQICuhse4kzVAsnwHbROKMgb4eoN0gr46ueperNUJn3JGfK504Fk4xFvoR5zJlxkHIomZez9eg7kUL8dfivOFoA3Ah0VVuNyPV4eCHRuw+DhXM5TMnnpJkdbLISCp75DGGFLeGxVYMTe1m80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762967703; c=relaxed/simple;
	bh=9Vl4M+L7saM4H5FI9WoIntBj62joT4QeAS05d655lsE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Lfkq3/jFrMEkbV8Q0JuAZ5MCpYR0Ye6cfUEMZggpJO/wwvpeXjNtjzUtGJwg83zqb5hOecR7D49B2lMDX+pG1/87S1+RLgCD1WaAxOsc4PCqCzNi4+Xtwj36OtC9tJNatW8kCFFK871fYMApzzn0s/yXdwpUri2N7v8WKK9iPzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AcpDTu9q; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-298389232c4so11926305ad.2
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 09:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762967702; x=1763572502; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=86qJtDww2XHXYjGdCBBHyykKWyscomPO9oojHmUWOnc=;
        b=AcpDTu9qhrXP53ofVy5hCQuwHvK8em1GH36gRt4RnGpaFU/PhaGfuNvV06BRRQTR9k
         YkK10OS9OpUIzZJZh/5IK2qH7sSkDF6ZTKM4hNbvA16DbDRtdH9iFIVIK6nbPdrL6vaC
         oW12QzIncC0olGic2c5BqZce2hK/y6vaZZts+WCXrgnlRHT8jne2MFgiMplcXo87ffmT
         UtNiiyknVHIf7pMUZHzuWC1HMaN5gm8trE/XbS2Zy/CoyOykg1FJAI8v0BWunAd9WI0w
         fYXEok0eKmopp/XGTCwQqyyonef2j9tGiKNqKAaZwPvhN8yWv+n3q6OjQZSEokB6uRBJ
         efJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762967702; x=1763572502;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=86qJtDww2XHXYjGdCBBHyykKWyscomPO9oojHmUWOnc=;
        b=SwpsHzxQDJFmBTMJ1Jrmqi7Ld6satR+/vL2lZ4wtmNF/m4Jhy1A1Yz9aTooEkfOji7
         aHrvtAwus8aUIMekQ4vEhuFk94SNQw9nrRcqVm+bWjVH2vzafw7AzKnUkgSJe89JyLbc
         AhGPUPXURL3aqNhSkcXXNgAmzbrCjblL4vS9i2sXPZcD+Fo7YBk+ySbtaRBenp0O+/V+
         twk5mfuIgzalJBn4bchpyw7zUh8Bct6qrqSxaIZlTjdzoD7I6FII/4M7P0TI4AWqDa8m
         PG7aiXl13i6mFOC8lvXVQZhGgrTM033BUidd6tDUq0iEj8D71SAy+N2QeCCj0uON279x
         7ivg==
X-Forwarded-Encrypted: i=1; AJvYcCWRGbC3u4QzcFnS46B8WPP3gPlje+yckcofxx9pglngAqKGbWyn0Cf6aZlbOYExJgfWb1M=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx+6vFNpjnjho9jCFMmkmYXNNFXaIv6fSDMDdyvq61awcyotHX
	kX149dGN4hXFNSv7CdR59Q3GLxwtblWpm4pzXOccqklnThbv4YKf9/hxuXaWwMr0uvk6MRqZegA
	uJrWpiw==
X-Google-Smtp-Source: AGHT+IGrMR5JgwNv/Me2MYMypHfVwaZ3yclITiMGko+pOjGEm/IXIepqef+u9s5d279WEqGMcQz9Rix8Ljg=
X-Received: from plcr3.prod.google.com ([2002:a17:903:143:b0:273:67d3:6303])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:28c:b0:27e:f018:d2fb
 with SMTP id d9443c01a7336-2984ed2b896mr45483095ad.6.1762967701625; Wed, 12
 Nov 2025 09:15:01 -0800 (PST)
Date: Wed, 12 Nov 2025 09:15:00 -0800
In-Reply-To: <20251112164144.GAaRS4yKgF0gQrLSnR@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com> <20251031003040.3491385-5-seanjc@google.com>
 <20251112164144.GAaRS4yKgF0gQrLSnR@fat_crate.local>
Message-ID: <aRTAlEaq-bI5AMFA@google.com>
Subject: Re: [PATCH v4 4/8] KVM: VMX: Handle MMIO Stale Data in VM-Enter
 assembly via ALTERNATIVES_2
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 12, 2025, Borislav Petkov wrote:
> On Thu, Oct 30, 2025 at 05:30:36PM -0700, Sean Christopherson wrote:
> > @@ -137,6 +138,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >  	/* Load @regs to RAX. */
> >  	mov (%_ASM_SP), %_ASM_AX
> >  
> > +	/* Stash "clear for MMIO" in EFLAGS.ZF (used below). */
> 
> Oh wow. Alternatives interdependence. What can go wrong. :)

Nothing, it's perfect. :-D

> > +	ALTERNATIVE_2 "",								\
> > +		      __stringify(test $VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO, %ebx), 	\
> 
> So this VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO bit gets set here:
> 
>         if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF_MMIO) &&
>             kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
>                 flags |= VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO;
> 
> So how static and/or dynamic is this?

kvm_vcpu_can_access_host_mmio() is very dynamic.  It can be different between
vCPUs in a VM, and can even change on back-to-back runs of the same vCPU.

> 
> IOW, can you stick this into a simple variable which is unconditionally
> updated and you can use it in X86_FEATURE_CLEAR_CPU_BUF_MMIO case and
> otherwise it simply remains unused?

Can you elaborate?  I don't think I follow what you're suggesting.

> 
> Because then you get rid of that yuckiness.
> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

