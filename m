Return-Path: <kvm+bounces-24301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E4589537A6
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:52:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D00DC1C24827
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16F6D1B14E9;
	Thu, 15 Aug 2024 15:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zdF2Efvh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E0E1AD3F7
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723737144; cv=none; b=KGKA9kIL5pcVCidtEbEqiBSIAa4pgGi9HO3X5dzyik9p+XSDXPmgRaIyFPf66KjZrHG2iBqcz+fFVJWZ2GyHR4mRZAkc8F+LjcV76HXZZuTRyowrwn8vWGkhS2zsQFS6IyTamTxAoXr2QMDcp5m1T9QXNhTtbHaNXLSC4U/ea7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723737144; c=relaxed/simple;
	bh=snKXFCF6FnyiOrGKJVBPz6luqmn6mmdCtFo8tjxYdls=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pVM1BhN16r7sm/4d3dESvWL4rcidIpXWPyeTCpJUg7B5vkPDH/Ea3PO6CoeNgBwhtJaQQLG03qNOJ/mqY6jKu3OJmoVwWXMuJOMeFdVozY6isUx/nPn2nBw6xn3KKYs1G8PqGrLtgzMgigPiJfn6iCuj4lBzQtDzJzEGWaLQzpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zdF2Efvh; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2d3c008e146so1052920a91.0
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 08:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723737142; x=1724341942; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UsUSd9Woo/iqPvXMwajq5VMWihmQ0h2yWsEHJq+e+9A=;
        b=zdF2Efvhw8kMRsbjOC6prXruy5KR/vKK84JMIFWniz2YoEP5U3m4SDTHKbSyb0t8Jt
         +BMtOy2MF3VpOSPtyeY/Re7DtcnpV0/W7hxt9k5uMnNt9J4NdFzwTto5vcdI+a3FGpAn
         WNkuDd3xFTum9/Vz5+nU4/7v9yMZk4WtOeQdM+T9uHie3vMKKjLtuUk0Zba9dK+8+ET5
         ZFDGsN82/AqQg2+waIZW6xHQ7arn+xIr2YQkpY2E53Nx4Kr/sFDmLrohNDFnVTrVIanl
         mmHbAU9kSdB0Pc/1Q1tZx8zAQWxavg4eK2/oZyUmtGbW/ZNbWj+pTxFLnEnT54KRhvvP
         OlIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723737142; x=1724341942;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UsUSd9Woo/iqPvXMwajq5VMWihmQ0h2yWsEHJq+e+9A=;
        b=CTxJIfPDd3n/sWOI1p5yuCleVDfkY1ir3kwKOIXsYdwz/UDdFOdwzqY8Jzy/fqBqn8
         7AJHJrC3qTeP5jFfIM1qbzRJAZFQI0yuprzglKL7RDOVarCP37X6yy0kNUaugvKpuGrQ
         zt1lFlQ6nCJk8L1AXIq2jQpPJGsK4z13QAd0TF4jXf1R5Z2oglOO+r+YlzYGWilvAmaH
         5dcgz7LSS3wWbzHO6m32TMd33LOfFKvf/sPABvuHg4Y8uL6EA+tukYImZbEQ+h7UFicH
         CKhzD39GEHBAStL+4sjP8nDsd0xBiW46qfyCeav8QnV/k2EVoqpOhu/2cgNMwipusWVH
         4XVA==
X-Gm-Message-State: AOJu0YySyyUbo71vX+utCTsjWZMA75dCKuisjVdP3xrx7LX6Fxk86idy
	2cObifsJor7h6vwGHu/Csjpmi9Kt790nl8im3iXfModuveaGLevdLpdXaMYqI7lkVmzEAsYkPKN
	IIg==
X-Google-Smtp-Source: AGHT+IHMf5W2rCdu8YRq9VXD8sk35Ym0aHc+ICn2snu/UUL0F247jmEidV+J/NhiZtp1ZaUNES3oCsmPNJ4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f3cc:b0:2cd:bbfa:3e5e with SMTP id
 98e67ed59e1d1-2d3e03e9b1emr68a91.7.1723737141799; Thu, 15 Aug 2024 08:52:21
 -0700 (PDT)
Date: Thu, 15 Aug 2024 08:52:20 -0700
In-Reply-To: <20240522001817.619072-13-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522001817.619072-1-dwmw2@infradead.org> <20240522001817.619072-13-dwmw2@infradead.org>
Message-ID: <Zr4kNNUUm4E6R5zC@google.com>
Subject: Re: [RFC PATCH v3 12/21] KVM: x86: Remove implicit rdtsc() from kvm_compute_l1_tsc_offset()
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
> Let the callers pass the host TSC value in as an explicit parameter.
> 
> This leaves some fairly obviously stupid code, which using this function
> to compare the guest TSC at some *other* time, with the newly-minted TSC
> value from rdtsc(). Unless it's being used to measure *elapsed* time,
> that isn't very sensible.
> 
> In this case, "obviously stupid" is an improvement over being non-obviously
> so.
> 
> No functional change intended.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/x86/kvm/x86.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ef3cd6113037..ea59694d712a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2601,11 +2601,12 @@ u64 kvm_scale_tsc(u64 tsc, u64 ratio)
>  	return _tsc;
>  }
>  
> -static u64 kvm_compute_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
> +static u64 kvm_compute_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 host_tsc,
> +				     u64 target_tsc)

Would it make sense to have a __kvm_compute_l1_tsc_offset() version that takes
in the host TSC, and then this?

static u64 kvm_compute_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
{
	return __kvm_compute_l1_tsc_offset(vcpu, rdtsc(), target_tsc);
}


Hmm, or maybe a better option would be:

static u64 kvm_compute_current_l1_tsc_offset(struct kvm_vcpu *vcpu,
					     u64 target_tsc)
{
	return kvm_compute_l1_tsc_offset(vcpu, rdtsc(), target_tsc);
}

Meh, after typing those out, I don't like either one.  Let's keep it how you
wrote it, I think there's quite a bit of added readability by forcing callers to
provide the host TSC.

>  {
>  	u64 tsc;
>  
> -	tsc = kvm_scale_tsc(rdtsc(), vcpu->arch.l1_tsc_scaling_ratio);
> +	tsc = kvm_scale_tsc(host_tsc, vcpu->arch.l1_tsc_scaling_ratio);
>  
>  	return target_tsc - tsc;

Opportunistically drop "tsc" too?  E.g.

	return target_tsc -
	       kvm_scale_tsc(host_tsc, vcpu->arch.l1_tsc_scaling_ratio);

or

	return target_tsc - kvm_scale_tsc(host_tsc, vcpu->arch.l1_tsc_scaling_ratio);

I find either of those much easier to read.

