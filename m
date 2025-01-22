Return-Path: <kvm+bounces-36282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F1413A1974D
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 18:16:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2AE907A289E
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 17:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EB11215175;
	Wed, 22 Jan 2025 17:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tyl3XfqW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A725C17B402
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 17:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737566178; cv=none; b=L0dwK5x3Odn6lPZ9jGd3uD6piiw5XI32dtRtFuh8yXGGpBOu98r+BRQzYLPTyyUXiBPTt8OM4mZX6FTmj8zdRokplkCBaKS0ENr2aC3veMjFIw4bPcJAqXXJZ8ZuSEZiPGdV7/wzpPuXnzmXYkOanipwr1xM6GtT59fXMfR9y7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737566178; c=relaxed/simple;
	bh=5CaSZ86XliYCY/hGkfA5agti5alWmrTCQ9JcxO66VkY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LlSIuYaU6OoEVaouJj+iEErkr2/GtPDcH36o4NsvZzkj0PhHUFfNSJG0GU7foIRrArUubAZVCUqyCt50tKQZj7jBqMCiINcUDdgxY/Q3mBIrRzJkZ0pWMQVcKg5BV/vHLkvHuKbMCeTrOOB/oN1bFmBsTo8KUizbI0hNmKrDePU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tyl3XfqW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737566175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yPo2YX5U30tjOL8/8CRlgmVxLk8wf8Vmgnuycw1vH90=;
	b=Tyl3XfqW9TyUvVc2qAAdllRNiC0mao4/4oIARaa3adAtWWErMk7TQm6BsJtopoo718EZXo
	LDS7K408thlRyQNSkNNmSJi/OvCcQ24XijIMMWHoZThIoXWPwsjqxmsaKWeCkrpr/UcDyS
	W8p/jd2dQbU9dsqFR7/GbzR6zchrWEo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-9bOk0z52My-4KcSNZv9t_Q-1; Wed, 22 Jan 2025 12:16:14 -0500
X-MC-Unique: 9bOk0z52My-4KcSNZv9t_Q-1
X-Mimecast-MFC-AGG-ID: 9bOk0z52My-4KcSNZv9t_Q
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361d4e8359so54463015e9.3
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 09:16:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737566172; x=1738170972;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yPo2YX5U30tjOL8/8CRlgmVxLk8wf8Vmgnuycw1vH90=;
        b=WoBsfxFKWQZLNVek6a3DrNuH8joO3XRR6AuaLpZIkeoG7KdubOBlF0I/dHWRKbJ0HF
         sXheYxWWa9lDmok1o366vN6TCkAvbRibW3o7HKLljc1qW2yVSi/5C8nflbHV2HCpp31i
         uJCuvRRmXeykAxdMdwhheJ4A8m14GkJqWzJZoAd4aTRe7jffItTWfccAcQiOoWEI5w2j
         QgQ6qYFtitsC3wv1UEC3emiUTi4VN93JJiKVoN1vGGHDwSJryKCxxf2oAkLv6yqRcwqF
         dIxtnbkGBZ9pRwttgEdYWoR7qcbawBI7KDiWUXWH7YhFprR4sdJ/vi2d9m1v7WcHYvaF
         k+6A==
X-Forwarded-Encrypted: i=1; AJvYcCU+T4c6KzDcap9wb1ykRwN0hN+pbTIiu3LHjgQHWYjkkI6xYihikhDZQQV+3LIZDY00KP4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjcEpxsqjIZRLsqca+IRIpCPXuOkyqnjZwGomQVN3xI/e4CMri
	bK/WyFZ4Vijo5EP1NqSvHSEnApiuHYA37NQtX7UeZwg6yiDVa1YdNkPemRtD0TnvbuCjOpMKSKZ
	+kHg6GOEmiv9c//QmCxa3JyqB7pElaT7XkxX6StCVapUqDWx/Vw==
X-Gm-Gg: ASbGncv2vSPxfFIdQtVDYjQHxfw4AsVCpt5PCOh8wMjGbenzo09uPcaS8+rDOytwNvc
	Z2LnjgDg+brUe73q2Hr+Bn5tEisRB/d/akQxDCqZWu02dx6PsODE8j35yr3EouJrh5oeoZc+tdY
	ekensMiS/FQu7U/pIOE5YOQsrDnCN2SYSfqS+NAc5KzMg8vljshcdiOtdU9nnuCmrbB30L+1str
	vSMTpmljOFx9VgSh40W9tS0TMddRP6LJgTr23S/agYh5CjMxUtwwzzVBO56huYT
X-Received: by 2002:a05:6000:186f:b0:385:ec6e:e87a with SMTP id ffacd0b85a97d-38bf57b75efmr22167788f8f.43.1737566171820;
        Wed, 22 Jan 2025 09:16:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEoLWkRfIfVCl1uZMiwftX37+pLjDux++uYs2j2gAOfhA8OOXt+vrKiOd7G9Fcjm/FM8VZllg==
X-Received: by 2002:a05:6000:186f:b0:385:ec6e:e87a with SMTP id ffacd0b85a97d-38bf57b75efmr22167756f8f.43.1737566171415;
        Wed, 22 Jan 2025 09:16:11 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf322ad74sm17066506f8f.56.2025.01.22.09.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 09:16:10 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Fred Griffoul <fgriffo@amazon.co.uk>, kvm@vger.kernel.org
Cc: Fred Griffoul <fgriffo@amazon.co.uk>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>,
 Paul Durrant <paul@xen.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Update Xen-specific CPUID leaves during mangling
In-Reply-To: <20250122161612.20981-1-fgriffo@amazon.co.uk>
References: <20250122161612.20981-1-fgriffo@amazon.co.uk>
Date: Wed, 22 Jan 2025 18:16:09 +0100
Message-ID: <87tt9q7orq.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Fred Griffoul <fgriffo@amazon.co.uk> writes:

> Previous commit ee3a5f9e3d9b ("KVM: x86: Do runtime CPUID update before
> updating vcpu->arch.cpuid_entries") implemented CPUID data mangling in
> KVM_SET_CPUID2 support before verifying that no changes occur on running
> vCPUs. However, it overlooked the CPUID leaves that are modified by
> KVM's Xen emulation.
>
> Fix this by calling a Xen update function when mangling CPUID data.
>
> Fixes: ee3a5f9e3d9b ("KVM: x86: Do runtime CPUID update before
> updating vcpu->arch.cpuid_entries")

Well, kvm_xen_update_tsc_info() was added with

commit f422f853af0369be27d2a9f1b20079f2bc3d1ca2
Author: Paul Durrant <pdurrant@amazon.com>
Date:   Fri Jan 6 10:36:00 2023 +0000

    KVM: x86/xen: update Xen CPUID Leaf 4 (tsc info) sub-leaves, if present

and the commit you mention in 'Fixes' is older:

commit ee3a5f9e3d9bf94159f3cc80da542fbe83502dd8
Author: Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Mon Jan 17 16:05:39 2022 +0100

    KVM: x86: Do runtime CPUID update before updating vcpu->arch.cpuid_entries

so I guess we should be 'Fixing' f422f853af03 instead :-)

> Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
> ---
>  arch/x86/kvm/cpuid.c | 1 +
>  arch/x86/kvm/xen.c   | 5 +++++
>  arch/x86/kvm/xen.h   | 5 +++++
>  3 files changed, 11 insertions(+)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index edef30359c19..432d8e9e1bab 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -212,6 +212,7 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
>  	 */
>  	kvm_update_cpuid_runtime(vcpu);
>  	kvm_apply_cpuid_pv_features_quirk(vcpu);
> +	kvm_xen_update_cpuid_runtime(vcpu);

This one is weird as we update it in runtime (kvm_guest_time_update())
and values may change when we e.g. migrate the guest. First, I do not
understand how the guest is supposed to notice the change as CPUID data
is normally considered static. Second, I do not see how the VMM is
supposed to track it as if it tries to supply some different data for
these Xen leaves, kvm_cpuid_check_equal() will still fail.

Would it make more sense to just ignore these Xen CPUID leaves with TSC
information when we do the comparison?

>  
>  	if (nent != vcpu->arch.cpuid_nent)
>  		return -EINVAL;
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index a909b817b9c0..219f9a9a92be 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -2270,6 +2270,11 @@ void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
>  		entry->eax = vcpu->arch.hw_tsc_khz;
>  }
>  
> +void kvm_xen_update_cpuid_runtime(struct kvm_vcpu *vcpu)
> +{
> +	kvm_xen_update_tsc_info(vcpu);
> +}
> +
>  void kvm_xen_init_vm(struct kvm *kvm)
>  {
>  	mutex_init(&kvm->arch.xen.xen_lock);
> diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
> index f5841d9000ae..d3182b0ab7e3 100644
> --- a/arch/x86/kvm/xen.h
> +++ b/arch/x86/kvm/xen.h
> @@ -36,6 +36,7 @@ int kvm_xen_setup_evtchn(struct kvm *kvm,
>  			 struct kvm_kernel_irq_routing_entry *e,
>  			 const struct kvm_irq_routing_entry *ue);
>  void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu);
> +void kvm_xen_update_cpuid_runtime(struct kvm_vcpu *vcpu);
>  
>  static inline void kvm_xen_sw_enable_lapic(struct kvm_vcpu *vcpu)
>  {
> @@ -160,6 +161,10 @@ static inline bool kvm_xen_timer_enabled(struct kvm_vcpu *vcpu)
>  static inline void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
>  {
>  }
> +
> +static inline void kvm_xen_update_cpuid_runtime(struct kvm_vcpu *vcpu)
> +{
> +}
>  #endif
>  
>  int kvm_xen_hypercall(struct kvm_vcpu *vcpu);

-- 
Vitaly


