Return-Path: <kvm+bounces-52902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A0ABB0A6B0
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 16:56:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C739E5A3908
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 14:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DC0E299957;
	Fri, 18 Jul 2025 14:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wTxJNbos"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C632F50
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 14:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752850593; cv=none; b=jdJRe6qYMHIyqyuvXh0dPrLE072s6S61R0nb+hI4jjVdUhc/SWGG63RJuydXNSydwH3AZzdXaiqUHsIS+OJXl4FbNf9cZTGvuyyxmBP4WVgbvdrJPtK1t321gT4LSqmpNuSx1rQJMGkEfloMFwq2bayAxt0Jy1DMo0n8MTJWAWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752850593; c=relaxed/simple;
	bh=G/mXNdzlpx/r47ry1dlH+90UQRrqMjtg2d7U7XLBKZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UPJ/k2rCsjRqfAjckwImRAd7l4+49Fm55QtDAsIBCgdlx2RliIOkTj0+CQjoALuNXXDos7b8aenLPZE4R3cQ+uHaYdjRV2eXgFm/7pzmZlqXr7vHDm91Afh9io1t+DRYI6HMThR1fYxFuKwL+U7MFPxnAsAbzp/JM9a2Db16Aqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wTxJNbos; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4563a57f947so4257025e9.1
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 07:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752850590; x=1753455390; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iEAp8dP6AjgyVn7db0JF0bqPEF/UG2/ADnUQkjMWjew=;
        b=wTxJNbos5igXmYnOFaHDEPcS1djXfcOIPtfWJIDsDcJcimJ8TW3pBwi4Xpy3blGX/N
         jxUNxQ7GgV7irDFCh2Y49eX97nHIYnySCsYTKzkrcVh1wDtcKeWdZUK7QqT+speIVD/W
         WgvFpktoD2xFfa7lqGb8RWjmi6TJCsvhd1GCzBWXlGmYkiIJUKM8jmBaUyfiPWRXnWUT
         8+ILlJB4Djl9uuDyP0LpeXvI7G32Qs78AS8obKjkytFiwWKDO7kRMhFAj4v7EpaTATr+
         O/OOA0M5fu2CCBQJL+6GmL5OyjFQfiplrDKacxUZ+DS4o4CPz28vjj57huLHuXtY5VEK
         GNdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752850590; x=1753455390;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iEAp8dP6AjgyVn7db0JF0bqPEF/UG2/ADnUQkjMWjew=;
        b=i1RVXMn+RxDHkNMY0f7butetcCMkBzyGIEnkBle+RJgPks7fMVF35avq9EjiP98VYp
         /SJe3jKEHI7oegKNiPS637N6qErwoNjPWjJYXjUNpIASIoGWQtPbfPYWi1uJEgLybAg5
         3Nt5wRerzLnGqPbLSS2a6Fobr+0Z89PGhqWgQELnGsSry6lHKmQP/ufrzbAltC6IQccb
         17nWJ5x4UhH+bToYsmwpewxH2xqzm/nmt5llf46AB6A/bsXb0bPha5I2yYwzxyDVDpxH
         M8Hnc/6/ml0hvGRpKgsMP5RJCHOeOec2vgjOspA41B6Kjp3k+WYkrvRJxk1vpNaRuCVc
         /zFA==
X-Forwarded-Encrypted: i=1; AJvYcCU8AbsjYQTz1LNJaZqe224ZH0p3+N13NIrUHQPSZ4yxN6BLUgBTi1W4DKv7XLzL2GbeBwE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOX5svLYZz0r55CkA4igNM3xofIinn8mP9C4RerDD0qbk99e4L
	jgxWZM3lG2EK6+ynIwggM/rPb/FUmrbEt8d7yQ+M3XBr1VAuNmLyxlKvGp0PsktC1Q==
X-Gm-Gg: ASbGncuHttXhMIDZYQXQyWpnMl0NHqDlFdeOQ/GGYZ/AQJpr+J/didKdhBHmwii2xgO
	zNrAdkUgS3ZX7TdXthMj6Mg1UMyf5QYqg4sMDuOHWQPxcNL5TmICn1NjIJ6ewc15i1Y4vTSP+cR
	eLPoAU+cp1ChHjdq3Xhqh7ilftSNqyG9QsZ3uWu1fxzdd1BEDTL5LTBQlkkI8Dg4i0cmtHwxDIP
	aqFU9AQejtaXznOwuWQKKj4Rh6ZsavG/2nX/M1T05eJThue3SqCbjX+A6FFFA/KPmqgBdnAceD7
	kro7Bv87Qe/0TJDp1FfE0HDYOGgKEgUhUwQqTfpFrFhMQm5+OJg1dH6H0zT5uqIkPuuK1IvlEjU
	nWvu+cyFR0c1FLZv6vgRFweTGCGtYdDkTZNm56QA/oV1AYo/V48Ge0R63Fpfa3Gdf1B9EKA==
X-Google-Smtp-Source: AGHT+IE6K9PCe1/f03eN10YVcPKdqSo5WW/5ySwf626QG9XmgSbJ3XvOtBetG5zBVNJiHNtKxkiH5A==
X-Received: by 2002:a05:600c:c0ce:b0:450:c9e3:91fe with SMTP id 5b1f17b1804b1-456346e2767mr59646595e9.0.1752850589578;
        Fri, 18 Jul 2025 07:56:29 -0700 (PDT)
Received: from google.com (120.142.205.35.bc.googleusercontent.com. [35.205.142.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4563b75ca42sm21610715e9.31.2025.07.18.07.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 07:56:28 -0700 (PDT)
Date: Fri, 18 Jul 2025 14:56:25 +0000
From: Keir Fraser <keirf@google.com>
To: Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 3/4] KVM: Implement barriers before accessing
 kvm->buses[] on SRCU read paths
Message-ID: <aHpgmTD0J9UpTzQb@google.com>
References: <20250716110737.2513665-1-keirf@google.com>
 <20250716110737.2513665-4-keirf@google.com>
 <ndwhwg4lmy22vnqy3yqnpdqj7o366crbrhgj5py5fm3g3l2ow3@5s24dzpkswa2>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ndwhwg4lmy22vnqy3yqnpdqj7o366crbrhgj5py5fm3g3l2ow3@5s24dzpkswa2>

On Thu, Jul 17, 2025 at 02:01:32PM +0800, Yao Yuan wrote:
> On Wed, Jul 16, 2025 at 11:07:36AM +0800, Keir Fraser wrote:
> > This ensures that, if a VCPU has "observed" that an IO registration has
> > occurred, the instruction currently being trapped or emulated will also
> > observe the IO registration.
> >
> > At the same time, enforce that kvm_get_bus() is used only on the
> > update side, ensuring that a long-term reference cannot be obtained by
> > an SRCU reader.
> >
> > Signed-off-by: Keir Fraser <keirf@google.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c   |  7 +++++++
> >  include/linux/kvm_host.h | 10 +++++++---
> >  virt/kvm/kvm_main.c      | 33 +++++++++++++++++++++++++++------
> >  3 files changed, 41 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 191a9ed0da22..425e3d8074ab 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -5861,6 +5861,13 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
> >  		if (kvm_test_request(KVM_REQ_EVENT, vcpu))
> >  			return 1;
> >
> > +		/*
> > +		 * Ensure that any updates to kvm->buses[] observed by the
> > +		 * previous instruction (emulated or otherwise) are also
> > +		 * visible to the instruction we are about to emulate.
> > +		 */
> > +		smp_rmb();
> > +
> >  		if (!kvm_emulate_instruction(vcpu, 0))
> >  			return 0;
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 3bde4fb5c6aa..9132148fb467 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -965,11 +965,15 @@ static inline bool kvm_dirty_log_manual_protect_and_init_set(struct kvm *kvm)
> >  	return !!(kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET);
> >  }
> >
> > +/*
> > + * Get a bus reference under the update-side lock. No long-term SRCU reader
> > + * references are permitted, to avoid stale reads vs concurrent IO
> > + * registrations.
> > + */
> >  static inline struct kvm_io_bus *kvm_get_bus(struct kvm *kvm, enum kvm_bus idx)
> >  {
> > -	return srcu_dereference_check(kvm->buses[idx], &kvm->srcu,
> > -				      lockdep_is_held(&kvm->slots_lock) ||
> > -				      !refcount_read(&kvm->users_count));
> > +	return rcu_dereference_protected(kvm->buses[idx],
> > +					 lockdep_is_held(&kvm->slots_lock));
> 
> I want to consult the true reason for using protected version here,
> save unnecessary READ_ONCE() ?

We don't want this function to be callable from SRCU read section, but
*only* during teardown. Hence protected version provides a better,
stricter safety check (that there are no users).

 -- Keir

> >  }
> >
> >  static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 222f0e894a0c..9ec3b96b9666 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1103,6 +1103,15 @@ void __weak kvm_arch_create_vm_debugfs(struct kvm *kvm)
> >  {
> >  }
> >
> > +/* Called only on cleanup and destruction paths when there are no users. */
> > +static inline struct kvm_io_bus *kvm_get_bus_for_destruction(struct kvm *kvm,
> > +							     enum kvm_bus idx)
> > +{
> > +	return rcu_dereference_protected(kvm->buses[idx],
> > +					 !refcount_read(&kvm->users_count));
> > +}
> > +
> > +
> >  static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
> >  {
> >  	struct kvm *kvm = kvm_arch_alloc_vm();
> > @@ -1228,7 +1237,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
> >  out_err_no_arch_destroy_vm:
> >  	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
> >  	for (i = 0; i < KVM_NR_BUSES; i++)
> > -		kfree(kvm_get_bus(kvm, i));
> > +		kfree(kvm_get_bus_for_destruction(kvm, i));
> >  	kvm_free_irq_routing(kvm);
> >  out_err_no_irq_routing:
> >  	cleanup_srcu_struct(&kvm->irq_srcu);
> > @@ -1276,7 +1285,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
> >
> >  	kvm_free_irq_routing(kvm);
> >  	for (i = 0; i < KVM_NR_BUSES; i++) {
> > -		struct kvm_io_bus *bus = kvm_get_bus(kvm, i);
> > +		struct kvm_io_bus *bus = kvm_get_bus_for_destruction(kvm, i);
> >
> >  		if (bus)
> >  			kvm_io_bus_destroy(bus);
> > @@ -5838,6 +5847,18 @@ static int __kvm_io_bus_write(struct kvm_vcpu *vcpu, struct kvm_io_bus *bus,
> >  	return -EOPNOTSUPP;
> >  }
> >
> > +static struct kvm_io_bus *kvm_get_bus_srcu(struct kvm *kvm, enum kvm_bus idx)
> > +{
> > +	/*
> > +	 * Ensure that any updates to kvm_buses[] observed by the previous VCPU
> > +	 * machine instruction are also visible to the VCPU machine instruction
> > +	 * that triggered this call.
> > +	 */
> > +	smp_mb__after_srcu_read_lock();
> > +
> > +	return srcu_dereference(kvm->buses[idx], &kvm->srcu);
> > +}
> > +
> >  int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
> >  		     int len, const void *val)
> >  {
> > @@ -5850,7 +5871,7 @@ int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
> >  		.len = len,
> >  	};
> >
> > -	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
> > +	bus = kvm_get_bus_srcu(vcpu->kvm, bus_idx);
> >  	if (!bus)
> >  		return -ENOMEM;
> >  	r = __kvm_io_bus_write(vcpu, bus, &range, val);
> > @@ -5869,7 +5890,7 @@ int kvm_io_bus_write_cookie(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx,
> >  		.len = len,
> >  	};
> >
> > -	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
> > +	bus = kvm_get_bus_srcu(vcpu->kvm, bus_idx);
> >  	if (!bus)
> >  		return -ENOMEM;
> >
> > @@ -5919,7 +5940,7 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
> >  		.len = len,
> >  	};
> >
> > -	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
> > +	bus = kvm_get_bus_srcu(vcpu->kvm, bus_idx);
> >  	if (!bus)
> >  		return -ENOMEM;
> >  	r = __kvm_io_bus_read(vcpu, bus, &range, val);
> > @@ -6028,7 +6049,7 @@ struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
> >
> >  	srcu_idx = srcu_read_lock(&kvm->srcu);
> >
> > -	bus = srcu_dereference(kvm->buses[bus_idx], &kvm->srcu);
> > +	bus = kvm_get_bus_srcu(kvm, bus_idx);
> >  	if (!bus)
> >  		goto out_unlock;
> >
> > --
> > 2.50.0.727.gbf7dc18ff4-goog
> >

