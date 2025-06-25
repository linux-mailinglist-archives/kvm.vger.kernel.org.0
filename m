Return-Path: <kvm+bounces-50687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B3A4AE8552
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:57:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FD6A3BFDB6
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 13:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9461265284;
	Wed, 25 Jun 2025 13:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="it+WIuud"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD37263889
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 13:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750859800; cv=none; b=jwTNTHwoHIEcFrWLQHMYPNjuBXI6kUMbrmvZTvR2e3WMaOHOzF160HwPbmlYqClkPbltDX7Z1ZrLsxI8ao8DSmYkE+IfGPINW83miIQR8bGtZHDmxzqZZ41Xq95ZxZVADO+H8bXa43NdY4Uy4+0whXOLmcRm1x1bXr8zmBut+c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750859800; c=relaxed/simple;
	bh=+gUAhtmwSc+Dx/LA8sXseXAxP2H95zpoHM9G3f1eS1o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f+b5LF0gcAdt2iwRXqLoa6yY+iH0E4tt51PvESozg98Blu8LZ0d+i/UaCL/udDteym/Q6CzMbu43HkFR/gQxMGskT2xNkxSv318rU2JhrkArPJLfipHXrc3FhGAuyXLgdPxkW0qyczccHNOX4+i+b2XrYZj7nDsAGSDUneCCsSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=it+WIuud; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2fb347b3e6so1844080a12.1
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 06:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750859795; x=1751464595; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uYRYqT/bXAL8k2LO9qK1rydTyzlSzlDY+mdu4otHhRA=;
        b=it+WIuudSA6omDLq6utjYwjmI4vvZsilUkbLH0PLf6eArtGaLsKPGSv+OLvi/GTwLp
         uznFV0UY0pMOuLuIjKvZcllsu6j6UWT4ixqeo0i6L2hp96bXplCEUbCEShF+/uZTeWmX
         253KjJQCxm5Rd+1NYr3r47nbTvtR2dsDAU798NMCn236jkfKJY20tUXaPPeazdRWamTA
         pmPCODaX881Yu2JUYBs1xS1kSLDgztfYKLyON95D3ilWYGzhdDYnVbNel7iOO5KNcduz
         K/9ofhGGdHa2LuqegO6KNkPSR0htLLtg+OdDlftzWM3VFEfGId7itejvnu8DqreCtUTr
         hlbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750859795; x=1751464595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uYRYqT/bXAL8k2LO9qK1rydTyzlSzlDY+mdu4otHhRA=;
        b=eTPEwvX74BS6CGOJnQ5juuqXKC7j6SGjeUdB0dI/SvSR3qYBYF5dYev8PcQGIm3miN
         uRXsxWdp4+uJaQnJP0BEOTLCjzPWprB9CeZ7w863N0cr9ETxHC1SFDeahcxcsxTQtLaA
         DAdI4R/Ef5nqpfYDMNhoTdh4XK1X1YJWOxoVe7STp5lo4VgaHXKcEzYToRI7VVKOYn3s
         NpRNHwJiqd6lDoL4qplrIg+19ix6SeNNCQBOQU6n5qJw20cAsD0oyFS+mXdeyLDRvlTV
         qhwvvY2pOk8tedIIDtZ+mfAtY6Pkw5pyUicetNNkrC4VXpVrsLvtUPnjWc+YedWXrEU4
         3bdg==
X-Forwarded-Encrypted: i=1; AJvYcCXyXA36rB/pqhrEECHanRcCY1JQBw3OXbsIG7dL7+0/2RvgNTqAP3Rzduk1yqtq20VNWpk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfVsbN4eWWj3rsju1u/oe1KQw5RvHSrSxhIj5J/Psa1DL3OVlI
	spumGlh5JvcScmDqr/j7cVHScuLwVKnf9eGvtWBZNxq5BcILYjojQwRYtzIfQ90dhwSJeip9ZRU
	WVfA1pQ==
X-Google-Smtp-Source: AGHT+IEpjJNtqFiEYRWcClwvn4omIwDUPMHmUWiHGbZoFEdpFnjJvDByLlczHO/ibArdo0tkOI3NS0mkejY=
X-Received: from plmm20.prod.google.com ([2002:a17:902:c454:b0:234:c2e4:1e08])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce8a:b0:235:caa8:1a72
 with SMTP id d9443c01a7336-23824031f58mr54507795ad.30.1750859794872; Wed, 25
 Jun 2025 06:56:34 -0700 (PDT)
Date: Wed, 25 Jun 2025 06:56:33 -0700
In-Reply-To: <20250610175424.209796-8-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com> <20250610175424.209796-8-Neeraj.Upadhyay@amd.com>
Message-ID: <aFwAESoVcldwpaCR@google.com>
Subject: Re: [RFC PATCH v7 07/37] KVM: lapic: Rename lapic get/set_reg() helpers
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	francescolavra.fl@gmail.com, tiala@microsoft.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 10, 2025, Neeraj Upadhyay wrote:
> In preparation for moving kvm-internal __kvm_lapic_set_reg(),
> __kvm_lapic_get_reg() to apic.h for use in Secure AVIC apic driver,
> rename them to signify that they are part of apic api.
> 
> While at it, fix line wrap in kvm_apic_get_state().

Nit, please don't bill this as a "fix".  There is absolutely nothing wrong with
the existing code.  I have no objection to the new code, I just don't want to
give KVM developers the impression that wrapping at ~80 chars when they feel it
makes the code more readable is somehow bad/wrong.

I'd just drop this line.  The function name is being shortened; adjusting the
wrapping to account for that is completely natural and doesn't need to be called
out.

> @@ -3099,8 +3099,7 @@ int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>  	 * Get calculated timer current count for remaining timer period (if
>  	 * any) and store it in the returned register set.
>  	 */
> -	__kvm_lapic_set_reg(s->regs, APIC_TMCCT,
> -			    __apic_read(vcpu->arch.apic, APIC_TMCCT));
> +	apic_set_reg(s->regs, APIC_TMCCT, __apic_read(vcpu->arch.apic, APIC_TMCCT));
>  
>  	return kvm_apic_state_fixup(vcpu, s, false);
>  }

