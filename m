Return-Path: <kvm+bounces-23459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74A87949C87
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 02:00:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D6AB282B82
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 00:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 497BD176FAB;
	Wed,  7 Aug 2024 00:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tZuOINgP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BBC176FA4
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 00:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722988808; cv=none; b=gdEDS8hN58gVnGkIqfMBVfgF+sGJFRq9+A9DAxuWn/va8k8/Ck67D+lsm1t/h+Cu1a3T5hOIUdvkC9WsFYFexLg4UlNO3rbipCzFe+4r2FRxJDG7xIEAmoovzikTl8NdkHvmINU/4/553SWKgd17rKnx1FxqFS6pxZeBtK/HVmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722988808; c=relaxed/simple;
	bh=UHgIWVKvGfmyugfK+5SUX8pCsbKk968BZK+Jt1c65xc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jyl3pwp7/jaF/FuZBkhHuBIjnOQntWlgK1Jj1+zXlpMBFhDRxauNA9uljknbVx9g9sMHyLbLydd5B1sa/ciszBzfKE5C4Y4zBvQRW25YV41MFdJgchyVS80Ap0mUpq1fvJHUjUQTvtOKfgzwLMWXRayNpTSreIhdtR5DaGox0Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tZuOINgP; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7b696999c65so947885a12.3
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 17:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722988806; x=1723593606; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Q2NRiav7MDRT7LLYySbofxe/7oFalUeoZKG+LR63fQ=;
        b=tZuOINgPZnMdi9v4GMYmHna5biCt5cMm8nKMJNgu8dr0hnRqfRyXSDSDAjOsJ11mGB
         jhcMMGJu9e61LPnCr4weFK89Jk+J02KL1AUaoi/DRRzpUIwC4IPs6nfZrgZjBQoVVb4p
         hBoMBNnae0JkFsueJqhwtLkhj/TuajQz76u4qFRwgsH3HFyF+nbMU+w/BtBYgjhfYXdK
         ss/o/ohOA2wPWuhymFk4sGIw/0IzXlUEmaG/da77jmeBrTF+5KjiwXmVyqq5PGLogzLo
         ovnCxPGxREByI0fwRe5FiLGLUNfM+Uo9ZUfi+Vf3/T8UPGacrTH7b4XsqQirmNdoa7Jt
         fm9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722988806; x=1723593606;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Q2NRiav7MDRT7LLYySbofxe/7oFalUeoZKG+LR63fQ=;
        b=tfIwR8mdRT18GgcNfsaeuti5QWu/p2TXNvaYQhL9jcJvVaKR8JD+eCKuCAEe2ChPoi
         ef+J206Klms+fUM1Wu6DxDQpfX6T4ORnHaa0AABqQqJsfKFo6zPAsdtxvt/v/8L8miJa
         EUav69bshgjxoi+TZhfWS05nTFcC7i0jntW6QuY4nM4w18fwTJM8/JgisxA7iKMiGUZq
         xcjuLMqhr63kJQBtpTfork60gsJfyS2hd8FE6nA4KFAF2W8bxZ2OIcoGgp//0ee9yFYc
         dj1bVw+Z6XLuYYZJypSeqjvIHgOc7txjyy2q8WSZS92K1nXU3WZBXzzMSLxwL7N/SdVL
         aYvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBVKEHLz2Bt16sqRtZH6z/DwUVYkOmzd4inI5s0ik0LW/xjTMOuovKrGgT0/ttF1+fsd/P939cTxMYTfSylGiGEC4t
X-Gm-Message-State: AOJu0Yz1mKRMl8xJc1+KWENf+XPZUqt2kAI706zn/Q/s7ZCH1T2h2f9O
	yc07JWd6Ir88zQb0sTOYW1rnEbLQndC806yusR5yEwUK5XMnyYBfcFXn5xw+VIRorRPX8qwVMhN
	ZPg==
X-Google-Smtp-Source: AGHT+IHvS0fM2LOTssx0eAi+ioCPUdUHmTfVhIBg5USnscLvdfSuqB0Ekxw+gGimmHjT/noSv8q+S+cCN3A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6904:0:b0:7a0:cd17:c701 with SMTP id
 41be03b00d2f7-7b74a9d0286mr33925a12.10.1722988805874; Tue, 06 Aug 2024
 17:00:05 -0700 (PDT)
Date: Tue, 6 Aug 2024 16:59:03 -0700
In-Reply-To: <ZrKqrCnNpNQ_K_qi@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802200136.329973-1-seanjc@google.com> <20240802200136.329973-3-seanjc@google.com>
 <ZrKqrCnNpNQ_K_qi@linux.dev>
Message-ID: <ZrK4x4LLz1wlwGQN@google.com>
Subject: Re: [PATCH 2/2] KVM: Protect vCPU's "last run PID" with rwlock, not RCU
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Steve Rutherford <srutherford@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 06, 2024, Oliver Upton wrote:
> On Fri, Aug 02, 2024 at 01:01:36PM -0700, Sean Christopherson wrote:
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index a33f5996ca9f..7199cb014806 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1115,7 +1115,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
> >  void kvm_arm_halt_guest(struct kvm *kvm);
> >  void kvm_arm_resume_guest(struct kvm *kvm);
> >  
> > -#define vcpu_has_run_once(vcpu)	!!rcu_access_pointer((vcpu)->pid)
> > +#define vcpu_has_run_once(vcpu)	(!!READ_ONCE((vcpu)->pid))
> >  
> >  #ifndef __KVM_NVHE_HYPERVISOR__
> >  #define kvm_call_hyp_nvhe(f, ...)						\
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 689e8be873a7..d6f4e8b2b44c 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -342,7 +342,8 @@ struct kvm_vcpu {
> >  #ifndef __KVM_HAVE_ARCH_WQP
> >  	struct rcuwait wait;
> >  #endif
> > -	struct pid __rcu *pid;
> > +	struct pid *pid;
> > +	rwlock_t pid_lock;
> >  	int sigset_active;
> >  	sigset_t sigset;
> >  	unsigned int halt_poll_ns;
> 
> Adding yet another lock is never exciting, but this looks fine.

Heh, my feelings too.  Maybe that's why I didn't post this for two years.

> Can you nest this lock inside of the vcpu->mutex acquisition in
> kvm_vm_ioctl_create_vcpu() so lockdep gets the picture?

I don't think that's necessary.  Commit 42a90008f890 ("KVM: Ensure lockdep knows
about kvm->lock vs. vcpu->mutex ordering rule") added the lock+unlock in
kvm_vm_ioctl_create_vcpu() purely because actually taking vcpu->mutex inside
kvm->lock is rare, i.e. lockdep would be unable to detect issues except for very
specific VM types hitting very specific flows.

But for this lock, every arch is guaranteed to take the lock on the first KVM_RUN,
as "oldpid" is '0' and guaranteed to mismatch task_pid(current).  So I don't think
we go out of our way to alert lockdep.

> > @@ -4466,7 +4469,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
> >  		r = -EINVAL;
> >  		if (arg)
> >  			goto out;
> > -		oldpid = rcu_access_pointer(vcpu->pid);
> > +		oldpid = vcpu->pid;
> 
> It'd be good to add a comment here about how this is guarded by the
> vcpu->mutex, as Steve points out.

Roger that.

