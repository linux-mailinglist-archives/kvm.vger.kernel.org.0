Return-Path: <kvm+bounces-45184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ED3DAA6787
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 01:49:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC9AA7A88F2
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 23:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A90220685;
	Thu,  1 May 2025 23:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UVoIgBBl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774003D6A
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 23:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746143353; cv=none; b=jZplR6CUmyyXmPS5n3GEfwzn0jOad9Bu6yKQf4KXgOgPPYv1wYPIXfxWpJZZknOjOrEABgIRxXEbFN4WYa0AymCL9bmjYuFF1h7Xsm0/DIF0V99At7+UgL1prZlXumgu3hsSvnJxvOcfmcfneSVZbkcu3EmNGmqNBR9VA0rVze8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746143353; c=relaxed/simple;
	bh=jZU0SIz9MHtQqTLeIgHVwcXNw/09LKRPJ7/yrnh4F0c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AN748uMfazxh3qea/Rp8SF4cumT1UZpyPqXYCdnmehfzLwz7K/Cm6KmpGuHdB0eYEOxMnxEaIF+dEjhB7ZxllaBy+4k5N2mwTV2/wEIoOV9PV2SX4+0HsJGA8eeUrRllvY79/R62MHNmD0VS2j+z7WLRFl1DYMByIqASsYKYoYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UVoIgBBl; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b0f807421c9so902403a12.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 16:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746143351; x=1746748151; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7YjaeVkecBE4pjAvNhqi1+CbQbpda08FZsnIbLNG4co=;
        b=UVoIgBBlFX7Rx4e17DLrEqxpx4Yz9um0jPUCqPIw4rS6MnTGksEHmrMqG9SU7hQryV
         VWDQYSTzNn7Y+PATA5f3tUh3U2R2d4MZ4Vhjt5kaNJXmfh8Zvnm4CGmDNuhSob9Bt9Dw
         nDhWzabWaUFUjpu5Q8bU13gQxBsPOSZV5FPnr1TWf6GqRzxRqvQsASIfQfx8qf2qbGZD
         vD7K3iSGTjoCZkUMUefNPHtCuNsHztw6RN/iFuoRv0FhvOv8XV17Y9fmv6vE4mkl6AlO
         dPdUnaS/5dyktgriGxCMdimBPY1HfRSTIUbc8yeqOgOaSpxc+PG+uIdA1ATqGMA0ZXJg
         ybQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746143351; x=1746748151;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7YjaeVkecBE4pjAvNhqi1+CbQbpda08FZsnIbLNG4co=;
        b=VRnPTpssI0IuV47vpu8fp9V+vHqJmP1BepqKcJ2razkm8gE83KzH5iZK3zV8doyqHX
         5yadfEQGY0QYxh27c5Z8M33ti07pec2/PKzih2PG0UHm/TeL5mELwlRhUcY/B5sPDUHY
         +58rIHeFTKjxa5cTy9kAllGY3PPejAYJatneZ7Fe1qjkVTUshh5mTvabwWMXDqrWpbdF
         FA0xQM0dxWioRcM2+v4bZNItVKsoL+r7sQoCgD4VOprUABJMi9YnFH4G4ijWM3VdonGz
         z7Imwzsyek0veeS0KPkfdtha7AORjnCpHYeu4fE8sKC2JoXakSEE8GSJzy4bWkidLO75
         LNpA==
X-Forwarded-Encrypted: i=1; AJvYcCW6geiPV9kur7GMrzVmLg9T/Fc8TF58TDZX9CQIjoLAf1KPmG9GdmGtbaiL0ARbT0F7Meg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0Ml3tKS8oaQbsXg3FKibwPnaWcbhWXMBLb3waaKUsKGayKPXf
	nihYSkbn+99RmpaWCzzAQIth81cEqqpQkyGznBiNVxj5D5Pzduz4Eqvpn/xYTfWm4W6O/oZEq5f
	+sA==
X-Google-Smtp-Source: AGHT+IFpk4LLtbCzk2o8pzjb4TQk7dvH4GDNA8trq7RtjjE6BSA0YG95We3X0NAUVh3kC6UoEPUU8DD0QKc=
X-Received: from pjee15.prod.google.com ([2002:a17:90b:578f:b0:308:65f7:9f24])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2541:b0:305:5f55:899
 with SMTP id 98e67ed59e1d1-30a4e5a579cmr1510514a91.11.1746143350753; Thu, 01
 May 2025 16:49:10 -0700 (PDT)
Date: Thu, 1 May 2025 16:49:09 -0700
In-Reply-To: <aAcfcB8ZyBuz7t7J@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250325041350.1728373-1-suleiman@google.com> <20250325041350.1728373-2-suleiman@google.com>
 <aAcfcB8ZyBuz7t7J@google.com>
Message-ID: <aBQIdcOB5ORNFzx2@google.com>
Subject: Re: [PATCH v5 1/2] KVM: x86: Advance guest TSC after deep suspend.
From: Sean Christopherson <seanjc@google.com>
To: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Suleiman Souhlal <suleiman@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 22, 2025, Tzung-Bi Shih wrote:
> On Tue, Mar 25, 2025 at 01:13:49PM +0900, Suleiman Souhlal wrote:
> > Advance guest TSC to current time after suspend when the host
> > TSCs went backwards.
> > 
> > This makes the behavior consistent between suspends where host TSC
> > resets and suspends where it doesn't, such as suspend-to-idle, where
> > in the former case if the host TSC resets, the guests' would
> > previously be "frozen" due to KVM's backwards TSC prevention, while
> > in the latter case they would advance.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> 
> Tested with comparing `date` before and after suspend-to-RAM[1]:
>   echo deep >/sys/power/mem_sleep
>   echo $(date '+%s' -d '+3 minutes') >/sys/class/rtc/rtc0/wakealarm
>   echo mem >/sys/power/state
> 
> Without the patch, the guest's `date` is slower (~3 mins) than the host's
> after resuming.
> 
> Tested-by: Tzung-Bi Shih <tzungbi@kernel.org>
> 
> [1]: https://www.kernel.org/doc/Documentation/power/states.txt
> 
> Some non-functional comments inline below.
> 
> > @@ -4971,7 +4971,37 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  
> >  	/* Apply any externally detected TSC adjustments (due to suspend) */
> >  	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
> > -		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
> > +		unsigned long flags;
> > +		struct kvm *kvm;
> > +		bool advance;
> > +		u64 kernel_ns, l1_tsc, offset, tsc_now;
> > +
> > +		kvm = vcpu->kvm;
> 
> It will be more clear (at least to me) if moving the statement to its declaration:
>   struct kvm *kvm = vcpu->kvm;
> 
> Other than that, the following code should better utilitize the local
> variable, e.g. s/vcpu->kvm/kvm/g.
> 
> > +		advance = kvm_get_time_and_clockread(&kernel_ns,
> > +		    &tsc_now);

In addition to Tzung-Bi's feedback...

Please don't wrap at weird points, and align when you do wrap.  The 80 char limit
isn't a super hard limit, and many of these wraps are well below that anyways.

		advance = kvm_get_time_and_clockread(&kernel_ns, &tsc_now);
		raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
		/*
		 * Advance the guest's TSC to current time instead of only
		 * preventing it from going backwards, while making sure
		 * all the vCPUs use the same offset.
		 */
		if (kvm->arch.host_was_suspended && advance) {
			l1_tsc = nsec_to_cycles(vcpu,
						vcpu->kvm->arch.kvmclock_offset + kernel_ns);
			offset = kvm_compute_l1_tsc_offset(vcpu, l1_tsc);
			kvm->arch.cur_tsc_offset = offset;
			kvm_vcpu_write_tsc_offset(vcpu, offset);
		} else if (advance) {
			kvm_vcpu_write_tsc_offset(vcpu, vcpu->kvm->arch.cur_tsc_offset);
		} else {
			adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
		}
		kvm->arch.host_was_suspended = 0;
		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);


As for the correctness of this code with respect to masterclock and TSC
synchronization, I'm definitely going to have to stare even more, and probably
bring in at least Paolo for a consult, because KVM's TSC code is all kinds of
brittle and complex.

