Return-Path: <kvm+bounces-20990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BDE2C927FC1
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:25:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74353284577
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D1D411184;
	Fri,  5 Jul 2024 01:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iG6MNBns"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A0279F3
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720142745; cv=none; b=uzLHoHjPb5h4OCYGjwPXgFPrV271rbR1ow4jE5z8e7Q53ZZLwuhIsuUF2BhepysNvuqZ07tC8Tryz5QzKek/mBBLyI2UlNPg3E09OJeHbjWHAZp+ja+EOpQScDhXPWVBsHsVjfDqUoxA49muF9R9eNtiwPWv48U1kQfKoqj5paQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720142745; c=relaxed/simple;
	bh=Ho+mlu7dwciZ6Q1Dx4nGdHTGlTibYuPSyRWLoE9raII=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KaTHwFpK9Sd/ZlxyCWdFiM74doWMAsf9/5oywnLJhqytqt0NcBszMQhmInTQbDdM6SLRsssL+N274VteNBNvz2ru+EuIuOxwEjXFN/zMMqEN5YW86fIePUm+7mJ2u6dr/Ld5u36z6/2Od3hIGQRUkTy0WAxZZXxW2BFYEvQTs8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iG6MNBns; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720142742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=puZHXeuAThZypm5I/tU/VxCkiNM58sSfmRKMsMa3kvE=;
	b=iG6MNBnshqYD54ieXdVgrZV1Df0mVKs6ZAfRXQTC93YRPLmF00Qaq+jlaHPqjlBBYtbS7E
	UDwg/u34cTE9xcEv1zPIQhab4QvdJ1a/Y6VyRjuY+VPEPEbB7RBHF0uR+JGM4/D6myFZgw
	KPH6NYNnmnY7tGXOwow71tI5LyGzzzw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-YvfyvcTMMw6KPQQ4xeuqNQ-1; Thu, 04 Jul 2024 21:25:41 -0400
X-MC-Unique: YvfyvcTMMw6KPQQ4xeuqNQ-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6ab80cb23beso12140466d6.2
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:25:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720142740; x=1720747540;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=puZHXeuAThZypm5I/tU/VxCkiNM58sSfmRKMsMa3kvE=;
        b=dibS5TbO/6ct0sZ2wS280RVuz6p0tlarobRLpmjSVmccFktwhQtOR5y5oMzR/l1LqO
         CWftcp1UswaXwC1nz4fgPrW/xpH8Lc+/U/t4SnK1E4iAOcbeod1KvourCrOP/gEHDZl4
         pOB7qlMQR3OGwXL5sRjlUyTOJM+GAuaIxeej5oyN/VvTirPOFgLKUGm3DomggTjcAhdc
         /UX6pOv9WKavIieaalrNKV15kW7ofh2WXURwjjSKljjLKeszGfMy0yktdgRJQpv+Uv/9
         X71snmomrm8KEuaeltDOMHdR8TLFRzXSC2AhcWULe042oXM6AIqGzDubBWL5A3KXtTqv
         m10g==
X-Gm-Message-State: AOJu0YxnhMRwyIcsUn+MT8J8laDC77o34x04KCk7AKcOzuTQIQGHa53k
	RwKKIb0hPDPt1j/DT5dwqnJDfSlAXwS9/qw3QG7p0Vd+wHxkJEcR1a4OBEW+ar3Jq4BI0QWFGRP
	cZ8qQFuQT0fi8vyORcbzRIhX6OLYGeDU4IQ2tt35c05ehDkS7Ew==
X-Received: by 2002:ad4:5ba4:0:b0:6b5:e099:4d69 with SMTP id 6a1803df08f44-6b5ecfb9422mr31683356d6.26.1720142740562;
        Thu, 04 Jul 2024 18:25:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEF2U1YD+6q18JF3TqogZJNBg0f79mJvZ/g7DB4yQv9lBC9AAPfmiWQZkt3CycumfSymUOXQ==
X-Received: by 2002:ad4:5ba4:0:b0:6b5:e099:4d69 with SMTP id 6a1803df08f44-6b5ecfb9422mr31683186d6.26.1720142740270;
        Thu, 04 Jul 2024 18:25:40 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b59e5f2b77sm69034896d6.92.2024.07.04.18.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:25:40 -0700 (PDT)
Message-ID: <43ef06aca700528d956c8f51101715df86f32a91.camel@redhat.com>
Subject: Re: [PATCH v2 22/49] KVM: x86: Add a macro to precisely handle
 aliased 0x1.EDX CPUID features
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:25:39 -0400
In-Reply-To: <20240517173926.965351-23-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-23-seanjc@google.com>
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
> Add a macro to precisely handle CPUID features that AMD duplicated from
> CPUID.0x1.EDX into CPUID.0x8000_0001.EDX.  This will allow adding an
> assert that all features passed to kvm_cpu_cap_init() match the word being
> processed, e.g. to prevent passing a feature from CPUID 0x7 to CPUID 0x1.
> 
> Because the kernel simply reuses the X86_FEATURE_* definitions from
> CPUID.0x1.EDX, KVM's use of the aliased features would result in false
> positives from such an assert.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 5e3b97d06374..f2bd2f5c4ea3 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -88,6 +88,16 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
>  	F(name);						\
>  })
>  
> +/*
> + * Aliased Features - For features in 0x8000_0001.EDX that are duplicates of
> + * identical 0x1.EDX features, and thus are aliased from 0x1 to 0x8000_0001.
> + */
> +#define AF(name)								\
> +({										\
> +	BUILD_BUG_ON(__feature_leaf(X86_FEATURE_##name) != CPUID_1_EDX);	\
> +	feature_bit(name);							\
> +})
> +
>  /*
>   * Magic value used by KVM when querying userspace-provided CPUID entries and
>   * doesn't care about the CPIUD index because the index of the function in
> @@ -758,13 +768,13 @@ void kvm_set_cpu_caps(void)
>  	);
>  
>  	kvm_cpu_cap_init(CPUID_8000_0001_EDX,
> -		F(FPU) | F(VME) | F(DE) | F(PSE) |
> -		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
> -		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SYSCALL) |
> -		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
> -		F(PAT) | F(PSE36) | 0 /* Reserved */ |
> -		F(NX) | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
> -		F(FXSR) | F(FXSR_OPT) | X86_64_F(GBPAGES) | F(RDTSCP) |
> +		AF(FPU) | AF(VME) | AF(DE) | AF(PSE) |
> +		AF(TSC) | AF(MSR) | AF(PAE) | AF(MCE) |
> +		AF(CX8) | AF(APIC) | 0 /* Reserved */ | F(SYSCALL) |
> +		AF(MTRR) | AF(PGE) | AF(MCA) | AF(CMOV) |
> +		AF(PAT) | AF(PSE36) | 0 /* Reserved */ |
> +		F(NX) | 0 /* Reserved */ | F(MMXEXT) | AF(MMX) |
> +		AF(FXSR) | F(FXSR_OPT) | X86_64_F(GBPAGES) | F(RDTSCP) |
>  		0 /* Reserved */ | X86_64_F(LM) | F(3DNOWEXT) | F(3DNOW)
>  	);
>  

Hi,

What if we defined the aliased features instead.
Something like this:

#define __X86_FEATURE_8000_0001_ALIAS(feature) \
	(feature + (CPUID_8000_0001_EDX - CPUID_1_EDX) * 32)

#define KVM_X86_FEATURE_FPU_ALIAS	__X86_FEATURE_8000_0001_ALIAS(KVM_X86_FEATURE_FPU)
#define KVM_X86_FEATURE_VME_ALIAS	__X86_FEATURE_8000_0001_ALIAS(KVM_X86_FEATURE_VME)

And then just use for example the 'F(FPU_ALIAS)' in the CPUID_8000_0001_EDX


Best regards,
	Maxim Levitsky


