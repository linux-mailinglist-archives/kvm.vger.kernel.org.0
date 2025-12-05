Return-Path: <kvm+bounces-65372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 50328CA8AE8
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 18:52:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5D173300B6B9
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 17:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E38833BBDF;
	Fri,  5 Dec 2025 17:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vJifQDCu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DFD33B979
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 17:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764957110; cv=none; b=QzEqrm7xAPxz4fcDDClnd1hTO9MpK3CGRtVpTQdnTE+qUJszN2/D77256c7rkAOR7KH98cBbVJOu+lhmQbUMQri7VS88fgXe4hx1PARXnIKJCCJm8DWJIU2dNvtQ0C1MSmksK8UGhr1ES7qSiLkZINdT02CxEWGBESD+thVcxpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764957110; c=relaxed/simple;
	bh=YAy8kOMbenr6ygHzmzjhwYAcLGZZ38JaotGnblaZKV4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bfl8HnYvr/NbGrH6L5aE7WQTQf48CFRcbIrlTSlq9m9LYoVi0nzQpy6Pg7RMhDfraHJct6dr7iJDIkIWCpWrJ4Fo+DATQHUI+X8yLZEnGeVRhVaUCvYzWCfCObiTNKEc0R7nNAjml38OEBWij/tOmyFyFKi5+Gk1T6sBhO8cqH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vJifQDCu; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2980ef53fc5so49766545ad.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 09:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764957108; x=1765561908; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QG9C+Jdux0eTNqncV3vT7mVdAyEVYQXo70O8uiTBoHk=;
        b=vJifQDCufnl77AGr46jpNv1UpkTov+0e12ikGZRWWRKiTR8jvmf7LGmnkfOocjZy1I
         wxASbNpAsRqoC8uQ0NaOo/RgK8SXMIa4YB/x3hXIq1EmWpot2IVUSbtM/0mljcKKp8+u
         5XYCGTq3lq/OHAATTd+vZOsOSw98QLwVjlzF3uYjgWuRFd8DsbUUPhJS4c2cpYuL2VnM
         ktP7uuF/JSxlxQ8b/hmZ3hKHDS/wNxB74ecgKPxCLGSozRek64T1AQE3UBj/sHNghJO+
         NUBTj9EIFIdCrqQrZyv7AMd7k4kUvXQl8ao+ABSd3YctBUotnZsN0z92aFmZghCtilfa
         Lm1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764957108; x=1765561908;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QG9C+Jdux0eTNqncV3vT7mVdAyEVYQXo70O8uiTBoHk=;
        b=Pb7ILVrggwn3/PCRekuYNjBhTEDIXVe0RVuJi2tuJnDn0eFjK4ioEQnOPjy3n1SO97
         MR8Ev7cO32D5xlF8IAjqmONGlwMJc6mn5mV36R49vFbJg1OyglIp7xNhiOUU9gydRREN
         XRIlEnpejnJ/ZBTcyAvi1s4ehcGC+rAc6qZM5+DddMbIFcA1z8zlb76hoxElrKhTqFSu
         /KyQeJkaCuuRnyyifx2Cb5IYoZ66Rfia4EylHGTvCsWrgOa3yaPQauC9B/3oYapFYSuN
         anmMHY7pr89u2VdrgphHt+KceLDcaxJ/pzPNwg/h3dRsxkDyMe+vYJeW2C5fpA5xkc6v
         l/ow==
X-Gm-Message-State: AOJu0YxqrqEHWzDw+ckwUO3bjSQgE4hItYNlSsII/CkUZkn8+lnd1ybn
	wCzIxO3wBNNR59iNoTzKy3M6zG1DxtSW5muQQxTukedCyYwbBFAZBfGdkHLFTHZ85XrDCKQTGHx
	b8GJvxQ==
X-Google-Smtp-Source: AGHT+IEfLgqZGT+fTGmjJDCIF0+ZZtUCC/Mw4x5E3IAuhBY4I8q1MOvgtzzmUAai8K8vFr/I+9rwDED9vus=
X-Received: from plbkz16.prod.google.com ([2002:a17:902:f9d0:b0:29d:5afa:2c6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:19e4:b0:295:8c80:fb94
 with SMTP id d9443c01a7336-29d683e1cacmr120523235ad.59.1764957107809; Fri, 05
 Dec 2025 09:51:47 -0800 (PST)
Date: Fri, 5 Dec 2025 09:51:46 -0800
In-Reply-To: <6d375ab3edb54645ac16e0446dc7516105ed4b04.1757416809.git.houwenlong.hwl@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1757416809.git.houwenlong.hwl@antgroup.com> <6d375ab3edb54645ac16e0446dc7516105ed4b04.1757416809.git.houwenlong.hwl@antgroup.com>
Message-ID: <aTMbsunKNyxOFiKm@google.com>
Subject: Re: [PATCH 2/7] KVM: x86: Check guest debug in DR access instruction emulation
From: Sean Christopherson <seanjc@google.com>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: kvm@vger.kernel.org, Lai Jiangshan <jiangshan.ljs@antgroup.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 10, 2025, Hou Wenlong wrote:
> @@ -8606,19 +8628,38 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
>  	}
>  }
>  
> -static void inject_emulated_exception(struct kvm_vcpu *vcpu)
> +static int kvm_inject_emulated_db(struct kvm_vcpu *vcpu, unsigned long dr6)
> +{
> +	struct kvm_run *kvm_run = vcpu->run;
> +
> +	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
> +		kvm_run->debug.arch.dr6 = dr6 | DR6_ACTIVE_LOW;
> +		kvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);
> +		kvm_run->debug.arch.exception = DB_VECTOR;
> +		kvm_run->exit_reason = KVM_EXIT_DEBUG;
> +		return 0;
> +	}
> +
> +	kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
> +	return 1;
> +}
> +
> +static int inject_emulated_exception(struct kvm_vcpu *vcpu)
>  {
> +	int r = 1;
>  	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>  
>  	if (ctxt->exception.vector == PF_VECTOR)
>  		kvm_inject_emulated_page_fault(vcpu, &ctxt->exception);
>  	else if (ctxt->exception.vector == DB_VECTOR)
> -		kvm_queue_exception_p(vcpu, DB_VECTOR, ctxt->exception.dr6);
> +		r = kvm_inject_emulated_db(vcpu, ctxt->exception.dr6);
>  	else if (ctxt->exception.error_code_valid)
>  		kvm_queue_exception_e(vcpu, ctxt->exception.vector,
>  				      ctxt->exception.error_code);
>  	else
>  		kvm_queue_exception(vcpu, ctxt->exception.vector);
> +
> +	return r;

Hmm, I think I'd rather make the DB_VECTOR case an early termination, and keep
the rest largely as-is.  And while you're modifying this code, maybe add a patch
to capture "struct x86_exception" locally instead of the context?  E.g. to end
up with:

static int inject_emulated_exception(struct kvm_vcpu *vcpu)
{
	struct x86_exception *ex = &vcpu->arch.emulate_ctxt->exception;

	if (ex->vector == DB_VECTOR)
		return kvm_inject_emulated_db(vcpu, ex->dr6);

	if (ex->vector == PF_VECTOR)
		kvm_inject_emulated_page_fault(vcpu, ex);
	else if (ex->error_code_valid)
		kvm_queue_exception_e(vcpu, ex->vector, ex->error_code);
	else
		kvm_queue_exception(vcpu, ex->vector);
	return 1;
}

