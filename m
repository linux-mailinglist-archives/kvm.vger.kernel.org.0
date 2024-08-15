Return-Path: <kvm+bounces-24310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B4FB95383D
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 18:30:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD47C1F22141
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 16:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C1321B8EA8;
	Thu, 15 Aug 2024 16:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HPeLZTBf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108D41AC8BF
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 16:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723739428; cv=none; b=mKGuo6aCa4eThLZ5lgdXWt1VJ3EsyVtJK4omXuylB+FEfWQwvGo7SYPdRfl2sleJSQMAtWC8PfA7dFqnOwAoXr9Wh2IjwRGTDkmHguk2MUnlIaWoBX5EIDo2xic7ysuk+vbgoh+NxOEQmKbBO+8XR4lQBaJSvVREPRKzQrb2LM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723739428; c=relaxed/simple;
	bh=wbk2LZUDRbV1K6GyGuP81W+lgL2ESCb6Ofdh8qj+So0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MG6plaIkZGgJBGoQTDaeZRZ1cC3nM4T99TKchvgzbwTY5jWQ3au+90cdh2HnWtbWqP2u3jGsVudpR4iTvpvwMM8HPjPfNQJbwFiTBkM775mxdINvmyvvUi9HP3troc6tSRL7VybBKCOMCaZNZNTZqkXMpI+s56c4/3otXf/zDNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HPeLZTBf; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc5b60f416so10069315ad.3
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 09:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723739426; x=1724344226; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8FLTrRaaj4IbDFlX9Gb5bpYCUef69cHd3D95ZRPBkgE=;
        b=HPeLZTBfX6W45guZs0bLdjOSQ2uy8p2Mi2DTS97NN+qyd027MN+J7zQd85gjgUWwQV
         rKd87GjCQEtfj+nzXvi5e9DEt3ivnZY5XxxBIy3ykr65RUcpnqPYOXop+URmjq9OnLkV
         UHQupA3yOwPea72uRr1AxVUcAHGJsmLLly21EKmAd7tx4mmqrnxyr5t0NC2lZdcwHbXU
         loZpOSkexYSzLSSI9zxybBrYVp8YPl0K02jUTmP47CRpkpZDWtrE9rJQAmCJPs61zmTw
         4UCAqN1D6Hk3knV6fHN2SHkoBY3heLSr3P4d+8MvoGH0i5hdK9DOVn9iikuB3QrfyZNg
         BdLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723739426; x=1724344226;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8FLTrRaaj4IbDFlX9Gb5bpYCUef69cHd3D95ZRPBkgE=;
        b=uymBG/+wQ0Paqh/nqCcgAfvS7guWJ/8hTZirkvzt58ImYfCwtkFBSq0PWj0Sq5vFpL
         ut0Vd4dtggl7lAJXvCbI9yxjQhmCK7zP14143NEnqOOxUFBQ1P0YX+O81xX3t3/idPgA
         osEpekba0/r81THsLtn6KrLq+7mJHlWVPuzrRJf3tHcvmzBaOWKqkbT90kbO3joVKmGp
         YS2rHAWvG918+weis6++tEukjYPt8IsKAWVi07q+JR+EGJJOIM0UoMkooO8giYOPE1Ik
         BYJfUk4cu2i4q5rJkLEUNrMKdoTed5jyA0heAkFCdtF1YsNZG5m6t6lUTsZ3SDLSLU9m
         q8pA==
X-Gm-Message-State: AOJu0YwBnkVH60rUYU7bZLIPP9ryFzY778I50wqS75uBnsOOjuEttY0v
	qlpJyCekHlQvJzDOz3mNrb3W76mwnPxNwALPiKKsxRtmtVwTLJwBxTxUKjbso2UeXztba+nVHX4
	aLg==
X-Google-Smtp-Source: AGHT+IEV9UpSNiomlwj7ADa+36foJFadkRZk55Var7flLGlvN2nm00oB0ZbZgDAFzXltC6drlNlP+R4Q4rU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:32c1:b0:1f9:b35f:a2b6 with SMTP id
 d9443c01a7336-20203e3c0d5mr6145ad.1.1723739425641; Thu, 15 Aug 2024 09:30:25
 -0700 (PDT)
Date: Thu, 15 Aug 2024 09:30:24 -0700
In-Reply-To: <20240522001817.619072-15-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522001817.619072-1-dwmw2@infradead.org> <20240522001817.619072-15-dwmw2@infradead.org>
Message-ID: <Zr4tIK5I17NcIxRz@google.com>
Subject: Re: [RFC PATCH v3 14/21] KVM: x86: Kill cur_tsc_{nsec,offset,write} fields
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jalliste@amazon.co.uk, sveith@amazon.de, zide.chen@intel.com, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 22, 2024, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> These pointlessly duplicate the last_tsc_{nsec,offset,write} values.
> 
> The only place they were used was where the TSC is stable and a new vCPU
> is being synchronized to the previous setting, in which case the 'last_'
> value is definitely identical.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 ---
>  arch/x86/kvm/x86.c              | 19 ++++++++-----------
>  2 files changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b01c1d000fff..7d06f389a607 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1354,9 +1354,6 @@ struct kvm_arch {
>  	u32 last_tsc_khz;
>  	u64 last_tsc_offset;
>  	u64 last_tsc_scaling_ratio;
> -	u64 cur_tsc_nsec;
> -	u64 cur_tsc_write;
> -	u64 cur_tsc_offset;
>  	u64 cur_tsc_generation;
>  	int nr_vcpus_matched_tsc;
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6ec43f39bdb0..ab5d55071253 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2713,11 +2713,9 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
>  	lockdep_assert_held(&kvm->arch.tsc_write_lock);
>  
>  	/*
> -	 * We also track th most recent recorded KHZ, write and time to
> -	 * allow the matching interval to be extended at each write.
> +	 * Track the last recorded kHz (and associated scaling ratio for
> +	 * calculating the guest TSC), and offset.
>  	 */
> -	kvm->arch.last_tsc_nsec = ns;
> -	kvm->arch.last_tsc_write = tsc;
>  	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
>  	kvm->arch.last_tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
>  	kvm->arch.last_tsc_offset = offset;
> @@ -2736,10 +2734,9 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
>  		 *
>  		 * These values are tracked in kvm->arch.cur_xxx variables.

This comment is now stale, as most of the fields are now .last_xxx, not cur_xxx.

However...

>  		 */
> +		kvm->arch.last_tsc_nsec = ns;


There is a functional change here, and it's either incorrect or misleading (I
think the latter).  If the TSC is unstable, "ns" in kvm_synchronize_tsc() will
come from get_kvmclock_base_ns(), and only the TSC frequency is checked for a
match when synchronizing.

That results in .last_tsc_nsec not being updated, and so subsequent syncs will
compute a larger elapsed time (relative to the current generation's timestamp,
not the "last" timestamp).

Functionally, I think that's ok?  So long as all vCPUs sync against the same
baseline, it should work?  I think.

But if that's the case, then I would prefer to delete last_tsc_{nsec,write,offset},
not the cur_xxx versions.  For nsec and write it shows that they are valid/used
only in the context of the current generation.

And for the offset, updating it _outside_ of the loop makes it more obvious that
the offset can change (by design) within a generation if the TSC is unstable.

Ooh, and if I'm reading the code correctly, last_tsc_khz can be renamed to
cur_tsc_khz and moved in the !matched statement too, as it's guaranteed to be
vcpu->arch.virtual_tsc_khz if matched==true.

Ah, right, and last_tsc_scaling_ratio is just an deriviation of virtual_tsc_khz,
so it too can be cur_xxx and put under !matched.

Am I missing something?  That seems too easy...

