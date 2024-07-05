Return-Path: <kvm+bounces-20982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DF53927FA7
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:18:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C12261C20996
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F0CA2BD18;
	Fri,  5 Jul 2024 01:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YmCItJYx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF6279CE
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720142272; cv=none; b=btgk19nKb0blxLQkb+bYnMd4SHIb2XLuplpVotFKsBsYrlOrIkftF8VRX008mp3bKpc8cygUqagi2owzAUoEoRBwOcPWpL8a/BEszhDpcg4sINpINMvhtb/+1d6SbxiRrE7Vdl7IwKo830bBzIXKJ3JJDLo4PaH6EAXAjNUL1OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720142272; c=relaxed/simple;
	bh=CSoUqM5CdE4URTrdg0/2CXOXP5HlDRhHWf02ErQyjVA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HQ+t9GcXpiWVSf567Xv72dl8+5jPyeCZTs1M4Zqw+wtSHTDCkT7VWTU6Uudc0DBbjfgkvU/BNtwymtiCuMCkxLn7TwPSXsnQE87ZvhwHYSqFC/uyFNXwDd+a+fds5yImXUiQsjw0EOYJ4IES8hg9mKnl87WFibCdeVjMWhFFQKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YmCItJYx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720142269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C57JsNfHDOwn1B/arEpnckvbaTqrN1W4Vlj4CWKNz/w=;
	b=YmCItJYxP91KcluED8BYQKbE45ekfLO3syg/PcALHfXQz0XfZRAkjUYw5I91qVrV4Itu4k
	AB7QcJ2rxvPqTuyNHGnZXOMDEXZ2Q7DY7DqDHpArkwDjoEeyvN5ovO7FGqoSus8T+uPUbR
	TewnnNqM/W6sSD2vgF6HmN/fLuaXib8=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-iofiVpyIP1m_Bm8KeIobpg-1; Thu, 04 Jul 2024 21:17:46 -0400
X-MC-Unique: iofiVpyIP1m_Bm8KeIobpg-1
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-4f2ed1c2a86so325077e0c.1
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:17:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720142266; x=1720747066;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C57JsNfHDOwn1B/arEpnckvbaTqrN1W4Vlj4CWKNz/w=;
        b=WnHZNWS/dlmGg38nraedyW/NGoKY1VctZupqYDb9pMZjfsRsf4NQPhf6N/WiD/jKuh
         95D2wHkVgA6JcDp+rLB4MooqgIqiBUb74BkI+dZlvehXjGLMxHBhc5JTUAO6zpBo5FV1
         kHF0So0GwT7WZP8H2AXDc9nFjvGGuGqAYntYkBvPXhtwqEvjFD3cY/P8ZaRfxUtmZIFo
         +hQ+pciDhxJWvIKb1cIptQ5fTRuYufGDl93WnHVcR/78DV+2ZcNd+9bdNWaUWl1aaDUB
         8IHQyIlNiDE/H0a59Hno1IRwpFNGGLM9qq8WqwSnA9Ufh5mBiJLrbRu7JSC3klFKnWQr
         PnVA==
X-Gm-Message-State: AOJu0YwI4eblB6jSmWjUz3kz07LA8oksqqX1qsCrKyCfZAAt6Gvi0qxz
	fBirUe2iB1Fa99fOk8qRiK1o3343YnSavW7ClHXiPyXJ/0ZkxyeY7AjQmlh+gASlMTWAHGF+qOk
	e6FxUAS0YFQG0CxK5VNAJPGnpBGe/HDGXwKPdHFy0b/QfM5jfBQ==
X-Received: by 2002:a05:6122:1693:b0:4f2:fc5c:b89 with SMTP id 71dfb90a1353d-4f2fc5c0e14mr1781519e0c.15.1720142265887;
        Thu, 04 Jul 2024 18:17:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsjVtfVQD65fX5PnK3vXNcKyNfEGugS6LTJD1/ZklFbF0Nwi9jlytNq9VNa2KuCl7P3V9z+A==
X-Received: by 2002:a05:6122:1693:b0:4f2:fc5c:b89 with SMTP id 71dfb90a1353d-4f2fc5c0e14mr1781506e0c.15.1720142265476;
        Thu, 04 Jul 2024 18:17:45 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-446513db848sm65140931cf.1.2024.07.04.18.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:17:45 -0700 (PDT)
Message-ID: <2c0cb572deeec525da8e265d64ba20c7a6367fb4.camel@redhat.com>
Subject: Re: [PATCH v2 16/49] KVM: x86: Don't update PV features caches when
 enabling enforcement capability
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:17:44 -0400
In-Reply-To: <20240517173926.965351-17-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-17-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> Revert the chunk of commit 01b4f510b9f4 ("kvm: x86: ensure pv_cpuid.features
> is initialized when enabling cap") that forced a PV features cache refresh
> during KVM_CAP_ENFORCE_PV_FEATURE_CPUID, as whatever ioctl() ordering
> issue it alleged to have fixed never existed upstream, and likely never
> existed in any kernel.
> 
> At the time of the commit, there was a tangentially related ioctl()
> ordering issue, as toggling KVM_X86_DISABLE_EXITS_HLT after KVM_SET_CPUID2
> would have resulted in KVM potentially leaving KVM_FEATURE_PV_UNHALT set.
> But (a) that bug affected the entire guest CPUID, not just the cache, (b)
> commit 01b4f510b9f4 didn't address that bug, it only refreshed the cache
> (with the bad CPUID), and (c) setting KVM_X86_DISABLE_EXITS_HLT after vCPU
> creation is completely broken as KVM configures HLT-exiting only during
> vCPU creation, which is why KVM_CAP_X86_DISABLE_EXITS is now disallowed if
> vCPUs have been created.
> 
> Another tangentially related bug was KVM's failure to clear the cache when
> handling KVM_SET_CPUID2, but again commit 01b4f510b9f4 did nothing to fix
> that bug.
> 
> The most plausible explanation for the what commit 01b4f510b9f4 was trying
> to fix is a bug that existed in Google's internal kernel that was the
> source of commit 01b4f510b9f4.  At the time, Google's internal kernel had
> not yet picked up commit 0d3b2ba16ba68 ("KVM: X86: Go on updating other
> CPUID leaves when leaf 1 is absent"), i.e. KVM would not initialize the
> PV features cache if KVM_SET_CPUID2 was called without a CPUID.0x1 entry.
> 
> Of course, no sane real world VMM would omit CPUID.0x1, including the KVM
> selftest added by commit ac4a4d6de22e ("selftests: kvm: test enforcement
> of paravirtual cpuid features").  And the test didn't actually try to
> verify multiple orderings, nor did the selftest enter the guest without
> doing KVM_SET_CPUID2, so who knows what motivated the change.
> 
> Regardless of why commit 01b4f510b9f4 ("kvm: x86: ensure pv_cpuid.features
> is initialized when enabling cap") was added, refreshing the cache during
> KVM_CAP_ENFORCE_PV_FEATURE_CPUID isn't necessary.
> 
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  arch/x86/kvm/cpuid.h | 1 -
>  arch/x86/kvm/x86.c   | 3 ---
>  3 files changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index be1c8f43e090..a51e48663f53 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -242,7 +242,7 @@ static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcp
>  					     vcpu->arch.cpuid_nent, base);
>  }
>  
> -void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
> +static void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpuid_entry2 *best = kvm_find_kvm_cpuid_features(vcpu);
>  
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 0a8b561b5434..7eb3d7318fc4 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -13,7 +13,6 @@ void kvm_set_cpu_caps(void);
>  
>  void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
>  void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
> -void kvm_update_pv_runtime(struct kvm_vcpu *vcpu);
>  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
>  						    u32 function, u32 index);
>  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c729227c6501..7160c5ab8e3e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5849,9 +5849,6 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  
>  	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
>  		vcpu->arch.pv_cpuid.enforce = cap->args[0];
> -		if (vcpu->arch.pv_cpuid.enforce)
> -			kvm_update_pv_runtime(vcpu);
> -
>  		return 0;
>  	default:
>  		return -EINVAL;

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


