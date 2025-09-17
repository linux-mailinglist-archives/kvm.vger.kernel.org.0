Return-Path: <kvm+bounces-57944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E8CEB81F6D
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:26:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39AC47211C5
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0764304963;
	Wed, 17 Sep 2025 21:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2cq5EGwi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDEA27A46A
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144328; cv=none; b=Q+fE7qGA4MDgZWHWsg+B8JJot85UuiA8iXeqyHQlbX5ARbOoVlMtFVoAV5drryhI/Bj87z/IIqpVPIQWvbM85yIZHKmbjMhMVfPP+VJ7VqXDTS+9hZdNNk0phnOLtU57PAweYemUpquzXvjfNL9ma/dI0V/dMJLkwayrHpWt0yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144328; c=relaxed/simple;
	bh=JP39cW2hbi9m89rYjm6fMmNO44J29P7MpA5dKQARQX4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XJwBL5YrpeXTy2PsLktS5kCP8clmld/eQmCGo+uSz1tUhqc5IqUhZcJR5+qjYc6Kr5/kaQZDfT+nhjiJpzmqD9KpXDzT6txfrMUZLjOcP+6ZpDnkJQdpvvieM5147SLJ+F3JgZuyP7cDhja82drFudVZ6JtHMpsGiNxb//NLdjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2cq5EGwi; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b54f6a4bf11so143386a12.0
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 14:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758144326; x=1758749126; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VzmS6vlS4aGQUGCsqqVnjAUV5zRiihlDMEI25Ee0wp4=;
        b=2cq5EGwiR6RIUgAcTQ69UY6QUldG4O4f5U4wtfMN7rc31DtJ0dzMhcdXBPIoxldA7b
         9dZytR+kHSdqxNNzjIoTjz1JlBSA1EWIXptjBUP+qdIYpgZVrOMp+M7ci+wN79Z4x3fY
         5kSn6ved+PnDUUHWsVxx23WSOREFZV8nDghSn/EV1h3fuqWWuhl1/oB5jQlf6wNKDVlz
         JljLb5o6A9EniY1eP1czwLiR6KdiLws3Ct0DOJTzHjr6UsPhjNiQEDnLXXn9vQnfiha9
         zflU2kkq129XIieMzLi/LDPHg8cynk98dPcsS4y+lwSq+EMnERggcnTtxI+mmMqrOYw8
         sXoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758144326; x=1758749126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VzmS6vlS4aGQUGCsqqVnjAUV5zRiihlDMEI25Ee0wp4=;
        b=oQwvx44r7CfcVxmsM88XEtX0ETxlfuEROTtmcQOrbNhM9veCIOyUTvWaOY3/1GHPV7
         6WWxaJXf1FOX6qr2+gAhxnwKIw8HnJOBsHbWTDDuD4gxq13tu2Q5aYOiHVXg754eDf7A
         /lNe4IVQIU6c6GFPlibHAD9tYXEVMbrKUiEgjGtrkYlSjqkVMfXSgTMwA3RmdUvJjhGE
         6Th/O/7fm9ubxzi1H3wOPhkcInCrZHc9c6OAWljRrssyPKEdHr5+3mNqAOHLE2TnfOVR
         pRemxH029KstMIyr3RnrLVgUvz4fJ+vvfvEUKFSUsP4UtuN2JOPVGe+nRBVxg48lDUj+
         zfOQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4l6i1nFkyPH3+TO0wwswtOQ5QRxEgvu3J7FAW/oZyGZ9FJqdGWsLzEmKaFXZRbVCcyp8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnfcbY7hUmzzkv4pneaRdVQYT6NQSgLrMVO97/+YGxORwJOJ5b
	+6Z22eUzouUsWa/eNybcCnTI5Yal6ys3f/B1qXuzTpqU55OPaCDulpSe0R7n+haPsM7h0HaqY9S
	AZDazTA==
X-Google-Smtp-Source: AGHT+IEt9OdbWxtc6AYige90fBSwtnNPY6nA9lHy3V8mdb8lVXQEswni2xr/2m7RjmFhT4E+7RMjQTSbWpw=
X-Received: from pjbhl16.prod.google.com ([2002:a17:90b:1350:b0:32d:a0b1:2b03])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3947:b0:243:c274:1a7f
 with SMTP id adf61e73a8af0-27aac993578mr5089210637.46.1758144326668; Wed, 17
 Sep 2025 14:25:26 -0700 (PDT)
Date: Wed, 17 Sep 2025 14:25:25 -0700
In-Reply-To: <65465d1e-a7bd-4eac-a0ba-8c6cce85e3ed@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-18-seanjc@google.com>
 <65465d1e-a7bd-4eac-a0ba-8c6cce85e3ed@intel.com>
Message-ID: <aMsnRY9PG6UeTzGY@google.com>
Subject: Re: [PATCH v15 17/41] KVM: VMX: Set host constant supervisor states
 to VMCS fields
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 17, 2025, Xiaoyao Li wrote:
> On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> ...
> > +static inline bool cpu_has_load_cet_ctrl(void)
> > +{
> > +	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE);
> > +}
> 
> When looking at the patch 19, I realize that
> 
>   { VM_ENTRY_LOAD_CET_STATE,		VM_EXIT_LOAD_CET_STATE }
> 
> is added into vmcs_entry_exit_pairs[] there.
> 
> So ...
> 
> >   static inline bool cpu_has_vmx_mpx(void)
> >   {
> >   	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS;
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index adf5af30e537..e8155635cb42 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -4320,6 +4320,21 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
> >   	if (cpu_has_load_ia32_efer())
> >   		vmcs_write64(HOST_IA32_EFER, kvm_host.efer);
> > +
> > +	/*
> > +	 * Supervisor shadow stack is not enabled on host side, i.e.,
> > +	 * host IA32_S_CET.SHSTK_EN bit is guaranteed to 0 now, per SDM
> > +	 * description(RDSSP instruction), SSP is not readable in CPL0,
> > +	 * so resetting the two registers to 0s at VM-Exit does no harm
> > +	 * to kernel execution. When execution flow exits to userspace,
> > +	 * SSP is reloaded from IA32_PL3_SSP. Check SDM Vol.2A/B Chapter
> > +	 * 3 and 4 for details.
> > +	 */
> > +	if (cpu_has_load_cet_ctrl()) {
> 
> ... cpu_has_load_cet_ctrl() cannot ensure the existence of host CET fields,
> unless we change it to check vmcs_config.vmexit_ctrl or add CET entry_exit
> pair into the vmcs_entry_exit_pairs[] in this patch.

I *love* the attention to detail, but I think we're actually good, technically.

cpu_has_load_cet_ctrl() will always return %false until patch 19, because
VM_ENTRY_LOAD_CET_STATE isn't added to the set of OPTIONAL controls until then,
i.e. VM_ENTRY_LOAD_CET_STATE won't be set in vmcs_config.vmentry_ctrl until
the exit control is as well (and the sanity check is in place).

> > +		vmcs_writel(HOST_S_CET, kvm_host.s_cet);
> > +		vmcs_writel(HOST_SSP, 0);
> > +		vmcs_writel(HOST_INTR_SSP_TABLE, 0);
> > +	}
> >   }

