Return-Path: <kvm+bounces-55886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88BA5B385C7
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 17:09:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AEDE1778FB
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 15:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8362727E5;
	Wed, 27 Aug 2025 15:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BjkqBsVN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E593A26F2BE
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 15:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307356; cv=none; b=XZUhW8Dp01IReo1NK4TUwX/9odkvIjssWx7Eodf1MiB6YxAzcMEBahVXU8sqwsSewIAoSuHrfwPH5Xq9L3rVmKtcH5LyHIuBa2+h0zvz9T5ddP+OI9b+DLbnQ4pUkCLUwhxkGDSJ8eZIbM2cXyMQnGpu7YV4+EmiqyCJC97+Dec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307356; c=relaxed/simple;
	bh=DpCJEIfwQQGl2PQO5j/mO2MScWyLFDJU13NPV8HrF00=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TSci91UOsIo4T9x7auXEweWWIzwWF7YDcTcqCsOg+40Rmbge82vAMZXX44ryuBMGPOzeJDq8TfymEwfBJ92Kvfyoj37taZCiKvsBL0noIXHsxZSLlXEOp1ez88jKOoR/F/Bi0Qxfc9o+D2ohQxWa40S4Skpj7FsCF5HtaY4DrKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BjkqBsVN; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-246f49067bdso34080435ad.0
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 08:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756307354; x=1756912154; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cGukJNryZsxnvP4t0ed2eFtZxN1ggIA3k+je7ANvR9U=;
        b=BjkqBsVN70DlSzInhmoYOBVf/N6nxteSjO+iNnu5cHi7bwta4wXuUMICxIJy5nLbVi
         W0+N9gVgb2aMjgL/FYyK8zcPyd++cJYmGDkN316LPfkz20BA6eoKvFQaPJXQWlJqICRQ
         zPqWtOqO218cQGNDtdDz1i0M9n+9E5zBe6fOc/qdnTIMcfFKXITCOxz8R+tSAjz5LOWd
         4nZuvvZin3NRPb2GyxEb3KrhLxfhgYz+BfJJif2jW806Q8VEUX/4pcwSTXiUN9pmsloP
         /2yhwt0AojT0ZZYh6m6G/3dhCLpnf13bnjoFV4baKNtw3L1ygtahkB81u2qZFKGRKN1J
         P0wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756307354; x=1756912154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cGukJNryZsxnvP4t0ed2eFtZxN1ggIA3k+je7ANvR9U=;
        b=tgQtVoHHHCxOqmM0ljkiSjq51htH5I2Ed+kZRSxH2jOFQOHV6tUGJxROF2/3BACoYH
         mMu/wJNmCPyhQhNE1zKyRVwgBsM9I3OHi9rEpzr7F7WLv7OwQ5Z8TxZPkzKH79G0ePxr
         RVpc+iDhiunM49O3DcHEy4TusDPOl/EaGww+lw1lNQC4i3aNN8njl/UmQ2ktzMnEeh6w
         /TSNwLYooclXTIVZ1pXAHwUx7IiCqmqTPKl3M5MJ6jR1LM0SUEEEPhHUChNcIk4Fv2S1
         KHKpo22D4WgmczaCrZQRpzOl88yrmm7vAZnBxF30dCxxbLMLnry+KwCDL9NzEqR2R4aL
         6XOg==
X-Forwarded-Encrypted: i=1; AJvYcCV5KXnZCB9HuHsFjUtcaAfyncDtxgyy14VSBvV25LV70zQSMZFx/SDEk3RI6eDhhqsEwJ8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw23wNgpyWXouY1kr32G7QpEgj/wQaCDzSfzpsOjDRtnX3dlIf2
	iCDT/uggqtnftgA2lIe9iezYNDRI1K59ubYNutXZ5p1C/Oe21lVl9qRVEbWBwJ6K26WTCVt/D4a
	ih/4qEw==
X-Google-Smtp-Source: AGHT+IF5KFARexvwm/25NO3qrVpMzrxQ7U+d6fK+0Kta/gTZ9/eFHTNO/iB4Ran3E9PIhtNjR3PKhzpId3I=
X-Received: from pjur11.prod.google.com ([2002:a17:90a:d40b:b0:325:9404:7ff3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e5c7:b0:240:640a:c576
 with SMTP id d9443c01a7336-2462ee02b9bmr261770115ad.15.1756307353868; Wed, 27
 Aug 2025 08:09:13 -0700 (PDT)
Date: Wed, 27 Aug 2025 08:09:12 -0700
In-Reply-To: <ae363ab5-8985-4c4e-910e-969d442cd7ed@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821133132.72322-1-chao.gao@intel.com> <20250821133132.72322-6-chao.gao@intel.com>
 <ae363ab5-8985-4c4e-910e-969d442cd7ed@zytor.com>
Message-ID: <aK8fmMGH0rB2LuA9@google.com>
Subject: Re: [PATCH v13 05/21] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, john.allen@amd.com, 
	mingo@redhat.com, minipli@grsecurity.net, mlevitsk@redhat.com, 
	pbonzini@redhat.com, rick.p.edgecombe@intel.com, tglx@linutronix.de, 
	weijiang.yang@intel.com, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 26, 2025, Xin Li wrote:
> On 8/21/2025 6:30 AM, Chao Gao wrote:
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index eb3088684e8a..d90f1009ac10 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -701,4 +701,28 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, int cpl,
> >   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
> > +/*
> > + * Lock and/or reload guest FPU and access xstate MSRs. For accesses initiated
> > + * by host, guest FPU is loaded in __msr_io(). For accesses initiated by guest,
> > + * guest FPU should have been loaded already.
> > + */
> > +
> > +static inline void kvm_get_xstate_msr(struct kvm_vcpu *vcpu,
> > +				      struct msr_data *msr_info)
> > +{
> > +	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
> > +	kvm_fpu_get();
> > +	rdmsrl(msr_info->index, msr_info->data);
> 
> s/rdmsrl/rdmsrq/
> 
> > +	kvm_fpu_put();
> > +}
> > +
> > +static inline void kvm_set_xstate_msr(struct kvm_vcpu *vcpu,
> > +				      struct msr_data *msr_info)
> > +{
> > +	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
> > +	kvm_fpu_get();
> > +	wrmsrl(msr_info->index, msr_info->data);
> 
> s/wrmsrl/wrmsrq/
> 
> 
> Perhaps it's time to remove rdmsrl() and wrmsrl(), as keeping them around
> won't trigger any errors when the old APIs are still being used.

Yeah, we should bite the bullet and force in-flight code to adapt.  I was _this_
close to making the same goof in the mediated PMU series, and IIRC it was only
some random conflict that alerted me to using the old/wrong APIs.

