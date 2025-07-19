Return-Path: <kvm+bounces-52939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D7D0B0AD7C
	for <lists+kvm@lfdr.de>; Sat, 19 Jul 2025 04:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8D731C26CA1
	for <lists+kvm@lfdr.de>; Sat, 19 Jul 2025 02:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 170081DF75C;
	Sat, 19 Jul 2025 02:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aHA1Ye1B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF70B33EC;
	Sat, 19 Jul 2025 02:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752892408; cv=none; b=OxVZ1bJas3uLRhRFp9Tb9z5XVLy+gMEtjr7ms/zNNnWVui4Sq5Na4tlalqp6I3MxM8euvwoZ9CYjMznOIBB0Heoh9RB5+OV/l6qEd+3tRVqTea7x815PunnxDeLojE0loSQ5V42Vj+5vH4IvwIv8RNdGde2GckuYTpoO8TBMaSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752892408; c=relaxed/simple;
	bh=N/0d8ZYpRiesfUFWrudZLLGI5zncqRs3p3U+AfycZag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UV6sbSauhrnMxyVv92TLV2ArQEDk6Nhq8t1fGycN8HIpoKRnHCtbT3MHvqzZaeoyaBE/Yv/2uGBe62jc8yGfGmnkmF38YqPZM1GhmVaroefNWN684hR/8qsXAjvCHczP21jN4f10o82nUIUrRQP845oADgA3manDiyei7McYICk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aHA1Ye1B; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b391ca6146eso2309448a12.3;
        Fri, 18 Jul 2025 19:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752892406; x=1753497206; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Km3E7HJGqkRcH0Nlf/SQc9KxwYivV0AKdXoW0Ns1pQ=;
        b=aHA1Ye1BJSSRMon84Pgv5ToWoz4UKz5qLf5UfFqjnzz1SANksc2ev+usuvvsxEgpbx
         pXlqngIxtPi8J5Gkawm+2jK/yJdICRO7enzgTz+K+FInGcvRcekjPmU1/6v+rWSUf1wY
         yjjXTVRG7UGTCaqgMCStd+mdClkgeeA1+640bsVMS/nJjsuD/YJjlxvSRSUHfUWf6cQi
         vbhBWfqZa1rYNeb8ECFvwh+4RrqGOjoQus2rJ1Cnr/JYjRCJZEWpbRYhr+fynP3GDdSY
         uAiiCPU+z/ojlmJZBn3Wtd2XMABJCO99c8osfKrXZWn/mo70kHGSd6eMYHroNmLQwmyu
         0tlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752892406; x=1753497206;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Km3E7HJGqkRcH0Nlf/SQc9KxwYivV0AKdXoW0Ns1pQ=;
        b=OBrhirNssBVYC1MLtzvXZnU9EDw+TBBbQ5iS4Xt1Of0T3g6jzD8kCcSqSuwnl/+r3w
         hR7Bv3yBrosqbwyDCQPmQjjvkDQc29Ma2XOWUSlCYWJzuXQmD8rJzYafkCi/JEyunOjn
         0TZZFa7FsmZu/KCaVTQT2unxY6esekaP5+/yTgRN5z/tNLzzTB74TUsOes5+ChfTHv4E
         /59vmqpATYP7BtcXUAofeB2koMc6mzbboK1yr833XIHHtd2Z7KpqUnOXF94i2CX12Gdq
         wg42SRS/BhEfobbkdPor8m/nArH6Hu0Xn6AzuSG6oNpVgendy49KxS7Br5o1E/muFuyq
         LBgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXOI9yDupOptrhc7G1HX22ArJDti8dS24EcD8SOOmfIpxTPPmxBYYP2t1iABIka8KCz5o=@vger.kernel.org, AJvYcCUwlEyyY+mOwaYN/mjsUB0o+UiTSQTYlwj5PW9MlxZUtHlsklUPD4lbTHWRUmtZYtty361naYJNXhlxNf5/@vger.kernel.org
X-Gm-Message-State: AOJu0YyYVLC77IzSWDzrsyj6z+bciiDYmTXNSp37PMfxBvJoPks+c/Xa
	vBMCA4sVpn3vX6QFyq/iyV0ZEIG/c+Hsw91wmXBicHuRnhm2hL5n1Ls1
X-Gm-Gg: ASbGncuRwI5mvNcroAYW1xNfOXi/AhT7YDeWc/HdKA3MVkuP3QsS4mleiP1oKurdvWD
	qYqjUFEve1FfCfWLM1AN+gJuthCqsRHNMjsa9vHkZqQotLujGwN8m9ClbkPaCJAqBIyjRHa48ez
	xxDrACcI6NxFCqtUvbtSlUfTPU1AgWpBLKAkyMkQBUpFpuzi9IlQ3AIt8V642lNPMDIijhz+eUr
	Dg9ptEW1sxUCg8xgVL9j8VQetWI8drcLnPttk9GNPu0Xtzyc0vGNHzS4I8Xxl7qz1SMWXdge9wr
	G8IB99KIcl7yFbaXCbF3kyvv71ZWVsCZvfUFMvBlgoQSbmdFlBvTjwT0/KqNLPlmYOtXGz5ZQwz
	0k7cG78iW1Vsvnw0wiJE6dFJTIw==
X-Google-Smtp-Source: AGHT+IFddcDEX4gdepWIQ/BvG0Nwo+HQvjjThFlet4NsWkmc1fwbmYyZR3mGKsrsM2y2NTjRjFnSNA==
X-Received: by 2002:a17:90b:58e8:b0:312:db8:dbdc with SMTP id 98e67ed59e1d1-31caf8db4f3mr14317726a91.20.1752892405750;
        Fri, 18 Jul 2025 19:33:25 -0700 (PDT)
Received: from localhost ([2409:891f:6a27:93c:d451:d825:eb30:1bcc])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-b3f2ff9af8csm1838901a12.58.2025.07.18.19.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 19:33:25 -0700 (PDT)
Date: Sat, 19 Jul 2025 10:33:19 +0800
From: Yao Yuan <yaoyuan0329os@gmail.com>
To: Keir Fraser <keirf@google.com>
Cc: Yao Yuan <yaoyuan@linux.alibaba.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Eric Auger <eric.auger@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 3/4] KVM: Implement barriers before accessing
 kvm->buses[] on SRCU read paths
Message-ID: <knb7uh5fk2okmszyncigplu2drimnfaprnjiburfsip2fnkce2@c2czybicw22d>
References: <20250716110737.2513665-1-keirf@google.com>
 <20250716110737.2513665-4-keirf@google.com>
 <ndwhwg4lmy22vnqy3yqnpdqj7o366crbrhgj5py5fm3g3l2ow3@5s24dzpkswa2>
 <aHpgmTD0J9UpTzQb@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHpgmTD0J9UpTzQb@google.com>

On Fri, Jul 18, 2025 at 02:56:25PM +0000, Keir Fraser wrote:
> On Thu, Jul 17, 2025 at 02:01:32PM +0800, Yao Yuan wrote:
> > On Wed, Jul 16, 2025 at 11:07:36AM +0800, Keir Fraser wrote:
> > > This ensures that, if a VCPU has "observed" that an IO registration has
> > > occurred, the instruction currently being trapped or emulated will also
> > > observe the IO registration.
> > >
> > > At the same time, enforce that kvm_get_bus() is used only on the
> > > update side, ensuring that a long-term reference cannot be obtained by
> > > an SRCU reader.
> > >
> > > Signed-off-by: Keir Fraser <keirf@google.com>
> > > ---
> > >  arch/x86/kvm/vmx/vmx.c   |  7 +++++++
> > >  include/linux/kvm_host.h | 10 +++++++---
> > >  virt/kvm/kvm_main.c      | 33 +++++++++++++++++++++++++++------
> > >  3 files changed, 41 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 191a9ed0da22..425e3d8074ab 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -5861,6 +5861,13 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
> > >  		if (kvm_test_request(KVM_REQ_EVENT, vcpu))
> > >  			return 1;
> > >
> > > +		/*
> > > +		 * Ensure that any updates to kvm->buses[] observed by the
> > > +		 * previous instruction (emulated or otherwise) are also
> > > +		 * visible to the instruction we are about to emulate.
> > > +		 */
> > > +		smp_rmb();
> > > +
> > >  		if (!kvm_emulate_instruction(vcpu, 0))
> > >  			return 0;
> > >
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index 3bde4fb5c6aa..9132148fb467 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -965,11 +965,15 @@ static inline bool kvm_dirty_log_manual_protect_and_init_set(struct kvm *kvm)
> > >  	return !!(kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET);
> > >  }
> > >
> > > +/*
> > > + * Get a bus reference under the update-side lock. No long-term SRCU reader
> > > + * references are permitted, to avoid stale reads vs concurrent IO
> > > + * registrations.
> > > + */
> > >  static inline struct kvm_io_bus *kvm_get_bus(struct kvm *kvm, enum kvm_bus idx)
> > >  {
> > > -	return srcu_dereference_check(kvm->buses[idx], &kvm->srcu,
> > > -				      lockdep_is_held(&kvm->slots_lock) ||
> > > -				      !refcount_read(&kvm->users_count));
> > > +	return rcu_dereference_protected(kvm->buses[idx],
> > > +					 lockdep_is_held(&kvm->slots_lock));
> >
> > I want to consult the true reason for using protected version here,
> > save unnecessary READ_ONCE() ?
>
> We don't want this function to be callable from SRCU read section, but
> *only* during teardown. Hence protected version provides a better,
> stricter safety check (that there are no users).

I see, thanks for your explanation!

>
>  -- Keir
>
> > >  }
> > >
> > >  static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 222f0e894a0c..9ec3b96b9666 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -1103,6 +1103,15 @@ void __weak kvm_arch_create_vm_debugfs(struct kvm *kvm)
> > >  {
> > >  }
> > >
> > > +/* Called only on cleanup and destruction paths when there are no users. */
> > > +static inline struct kvm_io_bus *kvm_get_bus_for_destruction(struct kvm *kvm,
> > > +							     enum kvm_bus idx)
> > > +{
> > > +	return rcu_dereference_protected(kvm->buses[idx],
> > > +					 !refcount_read(&kvm->users_count));
> > > +}
> > > +
> > > +
> > >  static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
> > >  {
> > >  	struct kvm *kvm = kvm_arch_alloc_vm();
> > > @@ -1228,7 +1237,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
> > >  out_err_no_arch_destroy_vm:
> > >  	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
> > >  	for (i = 0; i < KVM_NR_BUSES; i++)
> > > -		kfree(kvm_get_bus(kvm, i));
> > > +		kfree(kvm_get_bus_for_destruction(kvm, i));
> > >  	kvm_free_irq_routing(kvm);
> > >  out_err_no_irq_routing:
> > >  	cleanup_srcu_struct(&kvm->irq_srcu);
> > > @@ -1276,7 +1285,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
> > >
> > >  	kvm_free_irq_routing(kvm);
> > >  	for (i = 0; i < KVM_NR_BUSES; i++) {
> > > -		struct kvm_io_bus *bus = kvm_get_bus(kvm, i);
> > > +		struct kvm_io_bus *bus = kvm_get_bus_for_destruction(kvm, i);
> > >
> > >  		if (bus)
> > >  			kvm_io_bus_destroy(bus);
> > > @@ -5838,6 +5847,18 @@ static int __kvm_io_bus_write(struct kvm_vcpu *vcpu, struct kvm_io_bus *bus,
> > >  	return -EOPNOTSUPP;
> > >  }
> > >
> > > +static struct kvm_io_bus *kvm_get_bus_srcu(struct kvm *kvm, enum kvm_bus idx)
> > > +{
> > > +	/*
> > > +	 * Ensure that any updates to kvm_buses[] observed by the previous VCPU
> > > +	 * machine instruction are also visible to the VCPU machine instruction
> > > +	 * that triggered this call.
> > > +	 */
> > > +	smp_mb__after_srcu_read_lock();
> > > +
> > > +	return srcu_dereference(kvm->buses[idx], &kvm->srcu);
> > > +}
> > > +
> > >  int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
> > >  		     int len, const void *val)
> > >  {
> > > @@ -5850,7 +5871,7 @@ int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
> > >  		.len = len,
> > >  	};
> > >
> > > -	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
> > > +	bus = kvm_get_bus_srcu(vcpu->kvm, bus_idx);
> > >  	if (!bus)
> > >  		return -ENOMEM;
> > >  	r = __kvm_io_bus_write(vcpu, bus, &range, val);
> > > @@ -5869,7 +5890,7 @@ int kvm_io_bus_write_cookie(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx,
> > >  		.len = len,
> > >  	};
> > >
> > > -	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
> > > +	bus = kvm_get_bus_srcu(vcpu->kvm, bus_idx);
> > >  	if (!bus)
> > >  		return -ENOMEM;
> > >
> > > @@ -5919,7 +5940,7 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
> > >  		.len = len,
> > >  	};
> > >
> > > -	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
> > > +	bus = kvm_get_bus_srcu(vcpu->kvm, bus_idx);
> > >  	if (!bus)
> > >  		return -ENOMEM;
> > >  	r = __kvm_io_bus_read(vcpu, bus, &range, val);
> > > @@ -6028,7 +6049,7 @@ struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
> > >
> > >  	srcu_idx = srcu_read_lock(&kvm->srcu);
> > >
> > > -	bus = srcu_dereference(kvm->buses[bus_idx], &kvm->srcu);
> > > +	bus = kvm_get_bus_srcu(kvm, bus_idx);
> > >  	if (!bus)
> > >  		goto out_unlock;
> > >
> > > --
> > > 2.50.0.727.gbf7dc18ff4-goog
> > >
>

