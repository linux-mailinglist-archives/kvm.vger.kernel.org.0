Return-Path: <kvm+bounces-20996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9798927FDF
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:51:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EEE428527F
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1757D11184;
	Fri,  5 Jul 2024 01:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OukcECRJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A173DFBFC
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720144286; cv=none; b=HOU6uv7ijGv4ujgBwfi8YaOJTMTPwjgHc8BtqCPVyDixAueLjqsQVtVmNZ76YYTTL78pTBw4PRlwolsmVC4tCBbq+hr/JzyNYUM0/R9rN8BV5NNCpNc2lMqExnWrkKp3PhBZaH59alJyGQMJx1Yo+Fqa6QwRhZLKjELvJmqtKuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720144286; c=relaxed/simple;
	bh=XjZ6pzcNFCoUGcDXnFbuUhEjP1A33bOYiKVrZYpuewE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=alR8MBWj7ECBNbH4Q7CZimLeHCDAUOepIUEcW6tgsXa9YipCu/UsmGxPUWg6bRh6X4N/dltQB6JisKPW1yzXFjslm6hjZBEZnxnTjZ+R/AJJ2PcqSG0z/G8QOfKcr9wRU5YHp2bo3rPZ9i17BoO5b4h+ETFJRqZzMvu+9zeI4Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OukcECRJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720144283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D8vSsoNcZobrbM8hAcvriCyP9iuCpBhlHA1LnqmlgdY=;
	b=OukcECRJKJiRnusX2tqIpteDREuh7r2JmjoPf/XVPSISxOTm0+D3mhyS5TZxdDD0Xts8uf
	qDbM/FkCCw7l5MQRfQUMDcBy/XaJXYh1C8bnihG8t/iES+aUBCDbU6gXuQuv9HNJ2G4yL8
	00e5KhOrBRbfwNXvNpbG9yW91v0xlOc=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-qkSNIL3EOQeT5dZEuu3i_Q-1; Thu, 04 Jul 2024 21:51:22 -0400
X-MC-Unique: qkSNIL3EOQeT5dZEuu3i_Q-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-64b2a73ad0bso19506837b3.3
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:51:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720144281; x=1720749081;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D8vSsoNcZobrbM8hAcvriCyP9iuCpBhlHA1LnqmlgdY=;
        b=wv/vfl4XYMbl6nmhzU1MDPewXO/ue0NRmzuresL0dF3vcZYxj0kAlz4OWq4ZG0qQWo
         xyku+BvYMVLaXC651kb2QA9MjYEVvVfga/BsrgIrHTjUnYCUZX4zJ8CqGpK1XKEvVWnF
         ZTL9ApC3uwDSAGweSpDqdD9N2GWw4hawJXLqU0eN+cPMkEQa1tOxwJRts+NEorejyBwR
         k20oktZmXnEAGZwA9GEKhllnFR2aAqAziTKS1DXPU5/68Sv+3m2JQ7idRpYy+KslzwUi
         OmrHJy0rtU+7i+iUHzyYrT58Qltvxg3tIIXsRjikftmLGa8paXuR2vkQhbPcD12yNpdg
         AK3w==
X-Gm-Message-State: AOJu0YwdA4jw74NweBXMWAjaxsZlcwjdILjZvsGQblqQ9C1H1xdyARhk
	Lb1vg023/MABLr9Nv+91EK+UVHE25pPbjYQDbcUaMx8fUTUatSd6tiuM37xoy0yFTN31U2FK5eW
	peuWHNKpSmmz5BZMipLPckXYYd4hddKRWlnAuLBIS7nwCsI2FXw==
X-Received: by 2002:a81:848b:0:b0:650:9c5e:f6e2 with SMTP id 00721157ae682-652d7a681aamr31530637b3.34.1720144281625;
        Thu, 04 Jul 2024 18:51:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVKeur05z/2xhfRybr6qg4xeivBpl+zDXHx77mYCfXbQjJDPrbdraw5f6BWGFb30Jr2VeJ+g==
X-Received: by 2002:a81:848b:0:b0:650:9c5e:f6e2 with SMTP id 00721157ae682-652d7a681aamr31530457b3.34.1720144281274;
        Thu, 04 Jul 2024 18:51:21 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79d81e66bf9sm564515685a.45.2024.07.04.18.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:51:21 -0700 (PDT)
Message-ID: <5b747a9dacb0ead3d16c71192df8a61e8545d0e6.camel@redhat.com>
Subject: Re: [PATCH v2 29/49] KVM: x86: Remove unnecessary caching of KVM's
 PV CPUID base
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:51:19 -0400
In-Reply-To: <20240517173926.965351-30-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-30-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> Now that KVM only searches for KVM's PV CPUID base when userspace sets
> guest CPUID, drop the cache and simply do the search every time.
> 
> Practically speaking, this is a nop except for situations where userspace
> sets CPUID _after_ running the vCPU, which is anything but a hot path,
> e.g. QEMU does so only when hotplugging a vCPU.  And on the flip side,
> caching guest CPUID information, especially information that is used to
> query/modify _other_ CPUID state, is inherently dangerous as it's all too
> easy to use stale information, i.e. KVM should only cache CPUID state when
> the performance and/or programming benefits justify it.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/cpuid.c            | 34 +++++++--------------------------
>  2 files changed, 7 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index aabf1648a56a..3003e99155e7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -858,7 +858,6 @@ struct kvm_vcpu_arch {
>  
>  	int cpuid_nent;
>  	struct kvm_cpuid_entry2 *cpuid_entries;
> -	struct kvm_hypervisor_cpuid kvm_cpuid;
>  	bool is_amd_compatible;
>  
>  	/*
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 93a7399dc0db..7290f91c422c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -269,28 +269,16 @@ static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcp
>  					  vcpu->arch.cpuid_nent, sig);
>  }
>  
> -static struct kvm_cpuid_entry2 *__kvm_find_kvm_cpuid_features(struct kvm_cpuid_entry2 *entries,
> -							      int nent, u32 kvm_cpuid_base)
> -{
> -	return cpuid_entry2_find(entries, nent, kvm_cpuid_base | KVM_CPUID_FEATURES,
> -				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> -}
> -
> -static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu)
> -{
> -	u32 base = vcpu->arch.kvm_cpuid.base;
> -
> -	if (!base)
> -		return NULL;
> -
> -	return __kvm_find_kvm_cpuid_features(vcpu->arch.cpuid_entries,
> -					     vcpu->arch.cpuid_nent, base);
> -}
> -
>  static u32 kvm_apply_cpuid_pv_features_quirk(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_cpuid_entry2 *best = kvm_find_kvm_cpuid_features(vcpu);
> +	struct kvm_hypervisor_cpuid kvm_cpuid;
> +	struct kvm_cpuid_entry2 *best;
>  
> +	kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
> +	if (!kvm_cpuid.base)
> +		return 0;
> +
> +	best = kvm_find_cpuid_entry(vcpu, kvm_cpuid.base | KVM_CPUID_FEATURES);
>  	if (!best)
>  		return 0;
>  
> @@ -491,13 +479,6 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>  	 * whether the supplied CPUID data is equal to what's already set.
>  	 */
>  	if (kvm_vcpu_has_run(vcpu)) {
> -		/*
> -		 * Note, runtime CPUID updates may consume other CPUID-driven
> -		 * vCPU state, e.g. KVM or Xen CPUID bases.  Updating runtime
> -		 * state before full CPUID processing is functionally correct
> -		 * only because any change in CPUID is disallowed, i.e. using
> -		 * stale data is ok because KVM will reject the change.
> -		 */
Hi,

Any reason why this comment was removed? As I said earlier in the review.
It might make sense to replace this comment with a comment reflecting on why
we need to call kvm_update_cpuid_runtime, that is solely to allow old == new
compare to succeed.

>  		kvm_update_cpuid_runtime(vcpu);
>  		kvm_apply_cpuid_pv_features_quirk(vcpu);
>  
> @@ -519,7 +500,6 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>  	if (r)
>  		goto err;
>  
> -	vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
>  #ifdef CONFIG_KVM_XEN
>  	vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
>  #endif



Best regards,
	Maxim Levitsky


