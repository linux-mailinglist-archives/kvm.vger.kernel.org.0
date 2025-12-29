Return-Path: <kvm+bounces-66781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C26B0CE746F
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 16:58:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 390933001BDB
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 15:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FFC132B9BA;
	Mon, 29 Dec 2025 15:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h2/8SG9e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AFD329E42
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 15:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767023915; cv=none; b=fRtsFkURXsE4Jc+NFeIi14ZRGFBbwTmX9Ty49vmpsaYO0/MH/Sb1/t4hlmFVVa3MiLuQl1dlzt8P9x2ejEXxAnBimoAdZQD6bQ7rHXsfhtFrnBHkFB0clnz915kQucnomzw0BvnZxev/vxYdY/qa40+VK5EpyOE78kU6MPMmk7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767023915; c=relaxed/simple;
	bh=1q4GxWTKxNhBnKy5rhKHfNQPUo5qaFihuAu+sE9BCE4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WBcBOrOW6wH6LNfJxkVQvn3WdEtuYEQJJvcsERK4vnAJaf+cOZODKymiXPAHIdGLMFp7UxGN13jMUPGlDoq12JmL46OOHY6xw0EFojd5BequGRxQm1o11a6z+rKE5qUemeGMgRigZrtlzaqMGNbogLGFNnUQr7omkZAQ/6+k94Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h2/8SG9e; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7a99a5f77e0so15503996b3a.2
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 07:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767023913; x=1767628713; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZsY7DmCtEBPG/2V9InsEE1AQkRIUnM2k6RE8KjmAuX8=;
        b=h2/8SG9e2kiB2JhaHXPFSxkc+WJ1MPn1mNSIQp9y1nVglKdDFsqlA4s09EC2Yq/L1o
         JqD75zmweHzRbs2znEraTyC7E7fzA0AuytKPy63o5JW2AqJyWWUC3A+udiu7U8q3gRxW
         dx1k6C/Eu5vHKirUyPmL66xRR2IzlWRxLJipfo6v6gbJZVN/niaRdbVyooTmdihAIPGy
         UNkNA5BjNWgKgziw5zcEwuka+t37UQ3oIxd4LKYxdUKSle/kOPyTTn9MPIOQ9vGa4Y6R
         6G1STHo7xXktHd+hURRwFJSsfS/7dxegbhGNAHlL/dDfeuhr3RUch2aBOiitSPD2/I2r
         sLlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767023913; x=1767628713;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZsY7DmCtEBPG/2V9InsEE1AQkRIUnM2k6RE8KjmAuX8=;
        b=BkUnLqIJTQM2FdHyo/0Hh6T+tT5l6ZvhA2jWC4eVtNQE0Zh1/Rk/g24kkBR2THhJwy
         AcD5ug5zSHeHvTmnM5ZM1N/tJ7PAbLiQg3pLAZJRnY7QGhL+01DOCs57A/8avW3SszNP
         4/u/X7mloPmTfX1DHMyUnfNIvVWZa3whpMNFOBIbeMa3r8LgbgIWg31ZMtyzF1vVJKBy
         6PSRYCenafv22yyUsewALp9RzUSudMKIxqzh7ngWGe6QR7Q3pYrrorABsp99cjtMvv/8
         +t3P5n5h5v+33lHahmTGyx34rFxu2MPpq5mGS5HviG5Q0tS7F26IWnoeh/dNnfo7O70B
         Mgzg==
X-Forwarded-Encrypted: i=1; AJvYcCWOdc3vs8XlaU/RCzsk2ee75iIAaqYmmap26eER85yjp+3bpjElwAcAgtJswgJGYVV7Whs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwpqhfcFfeDshwPGEMsewXMAl2WL/BbpkUOFsxHInlud7QaSN4
	oxyDWws+91KW+Kyq44aojYOiM2E8gRQwsJrRE9QibrG0jouy1xDvs2dhMxuHtW6tqhrdS9BOV1D
	jztIydQ==
X-Google-Smtp-Source: AGHT+IEm1Henxy7WNKshf2l4r3viWwWVwM5WWhx/D1rwx8s6sLIMg02yiyYe9UxrlES/7PAqEhXA6MKem3A=
X-Received: from pfwp41.prod.google.com ([2002:a05:6a00:26e9:b0:776:1344:ca77])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:301f:b0:7aa:4f1d:c458
 with SMTP id d2e1a72fcca58-7ff657a303bmr27264653b3a.19.1767023913436; Mon, 29
 Dec 2025 07:58:33 -0800 (PST)
Date: Mon, 29 Dec 2025 07:58:31 -0800
In-Reply-To: <ub4djdh4iqy5mhl4ea6gpalu2tpv5ymnw63wdkwehldzh477eq@frxtjt3umsqh>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251224001249.1041934-1-pbonzini@redhat.com> <20251224001249.1041934-2-pbonzini@redhat.com>
 <ub4djdh4iqy5mhl4ea6gpalu2tpv5ymnw63wdkwehldzh477eq@frxtjt3umsqh>
Message-ID: <aVKlJ5OBc8yRqjlF@google.com>
Subject: Re: [PATCH 1/5] x86, fpu: introduce fpu_load_guest_fpstate()
From: Sean Christopherson <seanjc@google.com>
To: Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	x86@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 26, 2025, Yao Yuan wrote:
> On Wed, Dec 24, 2025 at 01:12:45AM +0800, Paolo Bonzini wrote:
> > Create a variant of fpregs_lock_and_load() that KVM can use in its
> > vCPU entry code after preemption has been disabled.  While basing
> > it on the existing logic in vcpu_enter_guest(), ensure that
> > fpregs_assert_state_consistent() always runs and sprinkle a few
> > more assertions.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 820a6ee944e7 ("kvm: x86: Add emulation for IA32_XFD", 2022-01-14)
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/include/asm/fpu/api.h |  1 +
> >  arch/x86/kernel/fpu/core.c     | 17 +++++++++++++++++
> >  arch/x86/kvm/x86.c             |  8 +-------
> >  3 files changed, 19 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
> > index cd6f194a912b..0820b2621416 100644
> > --- a/arch/x86/include/asm/fpu/api.h
> > +++ b/arch/x86/include/asm/fpu/api.h
> > @@ -147,6 +147,7 @@ extern void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
> >  /* KVM specific functions */
> >  extern bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu);
> >  extern void fpu_free_guest_fpstate(struct fpu_guest *gfpu);
> > +extern void fpu_load_guest_fpstate(struct fpu_guest *gfpu);
> >  extern int fpu_swap_kvm_fpstate(struct fpu_guest *gfpu, bool enter_guest);
> >  extern int fpu_enable_guest_xfd_features(struct fpu_guest *guest_fpu, u64 xfeatures);
> >
> > diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> > index 3ab27fb86618..a480fa8c65d5 100644
> > --- a/arch/x86/kernel/fpu/core.c
> > +++ b/arch/x86/kernel/fpu/core.c
> > @@ -878,6 +878,23 @@ void fpregs_lock_and_load(void)
> >  	fpregs_assert_state_consistent();
> >  }
> >
> > +void fpu_load_guest_fpstate(struct fpu_guest *gfpu)
> > +{
> > +#ifdef CONFIG_X86_DEBUG_FPU
> > +	struct fpu *fpu = x86_task_fpu(current);
> > +	WARN_ON_ONCE(gfpu->fpstate != fpu->fpstate);
> > +#endif
> > +
> > +	lockdep_assert_preemption_disabled();
> 
> Hi Paolo,
> 
> Do we need make sure the irq is disabled w/ lockdep ?

Yes please, e.g. see commit 2620fe268e80 ("KVM: x86: Revert "KVM: X86: Fix fpu
state crash in kvm guest"").

> The irq_fpu_usable() returns true for:
> 
> !in_nmi () && in_hardirq() and !softirq_count()
> 
> It's possible that the TIF_NEED_FPU_LOAD is set again
> w/ interrupt is enabled.

