Return-Path: <kvm+bounces-20972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A9D8927F7F
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:59:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D0BA1F23D6B
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 00:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C0379E5;
	Fri,  5 Jul 2024 00:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h0mPcCnF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1149610C
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 00:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141165; cv=none; b=QdiNjeBfDNLX9NlXfCgn+l0XHDqNGHzCf4PMocFNC4iLHbQ91/Ur+CjoJrRW9bP6fmrm0RINqhtGaJnIChlsf0npHtPC9+JXLjsv0F2QpNjRoYVaXgete445Ssr3X6b91k3TMlLwmEq6Z28zIas2P3zgC8/8Jm4MfDjh1Y57sww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141165; c=relaxed/simple;
	bh=2gnOh7yQ1eUaZ9i8ptSxU8xXzYB77XNU6fRbg43qQ4c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XOjp/peTm3LvNSeFQsyaFM18b66equFk2JTJr5D55WXFpi5oxJT5A3BCPzgIHFntcApWMQAAlM75mfTuQ//oHEfanimAAeeEk9NBd8kpMDawiV6Tsr4PFFzjjoQqecaYiUcPBn/n/3mhsM7xGoVkDGg58uIZRMrRJPuuCPOVtik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h0mPcCnF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720141163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W/MrpNgFXdPYysnDYf59wKwoFThqYInIXADfGzTPBl4=;
	b=h0mPcCnFqCim006O/zDVp2HBx1O7cJy9RKemOqtPK8ow1JfJ/NX5ekUmJQnnyNdw7koFCS
	uWVTujqkEMAgxqhiAYzKkg8VATiQqISUF/wbcWygS/UbTGhXazIY59PRcTC8NFjMFydGOx
	uO1HRAfSY7ZNuSrrwp79sJMmxuDRIbU=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-OxMbof_wOMeln1Pnng2iJg-1; Thu, 04 Jul 2024 20:59:19 -0400
X-MC-Unique: OxMbof_wOMeln1Pnng2iJg-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4467f700bb4so14957801cf.0
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 17:59:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720141159; x=1720745959;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W/MrpNgFXdPYysnDYf59wKwoFThqYInIXADfGzTPBl4=;
        b=DYmyodBYYe5p9ISvkPhiVIs1XpuEauldEmXtvzCvLt24JUHUlLau2sPurHvGm9yzQG
         wGZ9G6wBwPy/IP5mgfpxrkAo9vUKb/ayORsVsbykSTKQorxpPHCa5Y0zot35RxwQjS9u
         RyeTyXL1aOISMDv4pEzRCCCKJZBDMrdMxvirpglSz63RnXa3nw0ACF1HMsz5qupYqME2
         nNO7xEsfIV626wIsegY+gr28JsprFyq8ZlI4NEkT6Wgvn6yVa5vZgyJV+80We1v25YAU
         rHG0ABcX3qQeJN+X7VdUNPBrOu1rT8nw6xOxBl4f3tvsAWkrkHiypEQbJ8UX+RqOQv8W
         Ancg==
X-Gm-Message-State: AOJu0Yxs7rWPnCZi+b2Q2QB2hgQRXpbw2FNSLyty9aDZu9MKi7H7N564
	2AM496Cz+N/CowzwRarta5spOr12KlG8NtiiAeIX0cCuXAXo/4FGQXjNfV7yC/f7XSvvMSaRR5t
	cXZOGcVZyny4wyVdGLwMfSKu0ekqZtdcgvArttVKGsKN3dhHReQ==
X-Received: by 2002:ac8:580b:0:b0:446:4032:e2bb with SMTP id d75a77b69052e-447cbf3b712mr35451381cf.30.1720141159000;
        Thu, 04 Jul 2024 17:59:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUQSOx4yYI1N/+70DWW5DUNey5/xMVwYLCvM8dGKXraFvjg1JgeV//N6PLraahsDn0JnGd8w==
X-Received: by 2002:ac8:580b:0:b0:446:4032:e2bb with SMTP id d75a77b69052e-447cbf3b712mr35451181cf.30.1720141158612;
        Thu, 04 Jul 2024 17:59:18 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-446514b386bsm64565331cf.85.2024.07.04.17.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 17:59:18 -0700 (PDT)
Message-ID: <2c776a37ac2c2191e37993d2fc435755c95e78cb.camel@redhat.com>
Subject: Re: [PATCH v2 06/49] KVM: selftests: Refresh vCPU CPUID cache in
 __vcpu_get_cpuid_entry()
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 20:59:17 -0400
In-Reply-To: <20240517173926.965351-7-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-7-seanjc@google.com>
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
> Refresh selftests' CPUID cache in the vCPU structure when querying a CPUID
> entry so that tests don't consume stale data when KVM modifies CPUID as a
> side effect to a completely unrelated change.  E.g. KVM adjusts OSXSAVE in
> response to CR4.OSXSAVE changes.
> 
> Unnecessarily invoking KVM_GET_CPUID is suboptimal, but vcpu->cpuid exists
> to simplify selftests development, not for performance reasons.  And,
> unfortunately, trying to handle the side effects in tests or other flows
> is unpleasant, e.g. selftests could manually refresh if KVM_SET_SREGS is
> successful, but that would still leave a gap with respect to guest CR4
> changes.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/include/x86_64/processor.h  | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 8eb57de0b587..99aa3dfca16c 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -992,10 +992,17 @@ static inline struct kvm_cpuid2 *allocate_kvm_cpuid2(int nr_entries)
>  void vcpu_init_cpuid(struct kvm_vcpu *vcpu, const struct kvm_cpuid2 *cpuid);
>  void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu);
>  
> +static inline void vcpu_get_cpuid(struct kvm_vcpu *vcpu)
> +{
> +	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
> +}
> +
>  static inline struct kvm_cpuid_entry2 *__vcpu_get_cpuid_entry(struct kvm_vcpu *vcpu,
>  							      uint32_t function,
>  							      uint32_t index)
>  {
> +	vcpu_get_cpuid(vcpu);
> +
>  	return (struct kvm_cpuid_entry2 *)get_cpuid_entry(vcpu->cpuid,
>  							  function, index);
>  }
> @@ -1016,7 +1023,7 @@ static inline int __vcpu_set_cpuid(struct kvm_vcpu *vcpu)
>  		return r;
>  
>  	/* On success, refresh the cache to pick up adjustments made by KVM. */
> -	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
> +	vcpu_get_cpuid(vcpu);
>  	return 0;
>  }
>  
> @@ -1026,7 +1033,7 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
>  	vcpu_ioctl(vcpu, KVM_SET_CPUID2, vcpu->cpuid);
>  
>  	/* Refresh the cache to pick up adjustments made by KVM. */
> -	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
> +	vcpu_get_cpuid(vcpu);
>  }
>  
>  void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,

Hi,

Indeed - fully agree with this, and again very sad that Intel
made their CPUID dynamic - what a hack :(

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


