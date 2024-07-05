Return-Path: <kvm+bounces-20993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37D35927FC7
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:31:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0750282A09
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E065710A24;
	Fri,  5 Jul 2024 01:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fcGsu1h5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983061847
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720143084; cv=none; b=uKnxGPy7marPKgM1GUocpQowBw98c9u8lAZmIFUbo2fNX5Qzg+mHcr411Z2iQ4oDdjup9y+hYZx83kGnqnmuqlo9wNugRG6hyJTikcyAyCeQsx2ws1PWkZjGtpIjTAqvOxkoC8DVDCbZ1XBQ5lk+qVqpRnbrxg/b4Gop1FOWWI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720143084; c=relaxed/simple;
	bh=PutunZcqxRgmQwKtJi5JVi6PlOJITD7wVR0S/tsPzOE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TD63J2zOdSg5/6MZMW6Y9pjJigWBQgg0sOSe+Fyqj82pG2lSKDZqER22i8Q7MrZmxNbYp3rdPBQn7L6DJvrFEQQgPWqgRtFbN/mOhzD2QIEZbUoECBlFp2bTFgRMVSmd/ez7IIwOlVbC5hG8agXwWw3Non++k8IEwVaLaB8nHVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fcGsu1h5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720143081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UNMt4DeSv/0bTkIAoghrDHB1I3cQOCQyHHMVho9yhqA=;
	b=fcGsu1h5zAWQJ3S/vVKzei/T74Hn0iGUgSZx8t4GYCi7q11JAzOFktRN3PTMBWwMftLdTp
	w6Md7w27MCLfo+c9HNp7tYKXVKOrprVAvv37IMJxgFrRv+oLeZ7dpJRaWyHvIFbbj8h6jM
	PAFnleZ7aVarKAyV/odSvxZNh/XPC5I=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-eDLLyEeQNqOEjYvKlqbHBQ-1; Thu, 04 Jul 2024 21:31:20 -0400
X-MC-Unique: eDLLyEeQNqOEjYvKlqbHBQ-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-79d82b1babdso117620285a.0
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:31:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720143080; x=1720747880;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UNMt4DeSv/0bTkIAoghrDHB1I3cQOCQyHHMVho9yhqA=;
        b=tVGCNP3gdKzr3u5Nv/J4TDml4HYj/bCdzCWiau9YHZibrfIeHmeEkFPq6qePFLSeJI
         p/GSYWWkPiwP8gUXy+0Fd8hz8btbaYJtxYI6oaIUO6OVcyLDSUlEeMQz/q5lCP/oLnU2
         ++kJDBz1K9nZZ/MMv8E3d1ozFYwzfDPlADY9g8M0lnHBStul76F4DcTdCc2qm01NSOEJ
         AwFDe1kv3Uv25E1xkclsohUOZNCdJ4+3Ge4RT40ZigThYwern6yAZZiSnsADSxBPpqbj
         UH2ok8ZBcFsXJykWHCqWBHmNNidoD4tmuMyQKXpcDXitXo5Pcl6X5/UEGC6dEQ4OrVun
         4fYQ==
X-Gm-Message-State: AOJu0YwhVg86S+MSdD7T/xO/D58iezE7FO5hsMUC9yk5tJFnziqJdU5u
	mKYlGNECbnUTELPhKMI5iw1jxOM4B8nyF4nmRukJDEs9c3+6EQQmHqGoOp1Leihk/g4rS6JWQ37
	tG8MClgDC8ypJ/pVHkf9lx+FRgxnOEPisDTSsOmV3mvZqHeU1+w==
X-Received: by 2002:a05:620a:5224:b0:79d:6fcd:771b with SMTP id af79cd13be357-79eee1d1c94mr321573085a.26.1720143080032;
        Thu, 04 Jul 2024 18:31:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFT6oaWvJIyTsMy63gEKqubf8ANsn0R2tvK9GCaNVrU3YL99UYACTMfGoq8IzAODzSrTVFNrg==
X-Received: by 2002:a05:620a:5224:b0:79d:6fcd:771b with SMTP id af79cd13be357-79eee1d1c94mr321571985a.26.1720143079754;
        Thu, 04 Jul 2024 18:31:19 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79d692ed6d8sm724817885a.78.2024.07.04.18.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:31:19 -0700 (PDT)
Message-ID: <7c072dac426f77953158b0c804d81c664c00d1e3.camel@redhat.com>
Subject: Re: [PATCH v2 25/49] KVM: x86: Harden CPU capabilities processing
 against out-of-scope features
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:31:18 -0400
In-Reply-To: <20240517173926.965351-26-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-26-seanjc@google.com>
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
> Add compile-time assertions to verify that usage of F() and friends in
> kvm_set_cpu_caps() is scoped to the correct CPUID word, e.g. to detect
> bugs where KVM passes a feature bit from word X into word y.
> 
> Add a one-off assertion in the aliased feature macro to ensure that only
> word 0x8000_0001.EDX aliased the features defined for 0x1.EDX.
> 
> To do so, convert kvm_cpu_cap_init() to a macro and have it define a
> local variable to track which CPUID word is being initialized that is
> then used to validate usage of F() (all of the inputs are compile-time
> constants and thus can be fed into BUILD_BUG_ON()).
> 
> Redefine KVM_VALIDATE_CPU_CAP_USAGE after kvm_set_cpu_caps() to be a nop
> so that F() can be used in other flows that aren't as easily hardened,
> e.g. __do_cpuid_func_emulated() and __do_cpuid_func().
> 
> Invoke KVM_VALIDATE_CPU_CAP_USAGE() in SF() and X86_64_F() to ensure the
> validation occurs, e.g. if the usage of F() is completely compiled out
> (which shouldn't happen for boot_cpu_has(), but could happen in the future,
> e.g. if KVM were to use cpu_feature_enabled()).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 55 +++++++++++++++++++++++++++++++-------------
>  1 file changed, 39 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index a16d6e070c11..1064e4d68718 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -61,18 +61,24 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
>  	return ret;
>  }
>  
> -#define F feature_bit
> +#define F(name)							\
> +({								\
> +	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
> +	feature_bit(name);					\
> +})
>  
>  /* Scattered Flag - For features that are scattered by cpufeatures.h. */
>  #define SF(name)						\
>  ({								\
>  	BUILD_BUG_ON(X86_FEATURE_##name >= MAX_CPU_FEATURES);	\
> +	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
>  	(boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0);	\
>  })
>  
>  /* Features that KVM supports only on 64-bit kernels. */
>  #define X86_64_F(name)						\
>  ({								\
> +	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
>  	(IS_ENABLED(CONFIG_X86_64) ? F(name) : 0);		\
>  })
>  
> @@ -95,6 +101,7 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
>  #define AF(name)								\
>  ({										\
>  	BUILD_BUG_ON(__feature_leaf(X86_FEATURE_##name) != CPUID_1_EDX);	\
> +	BUILD_BUG_ON(kvm_cpu_cap_init_in_progress != CPUID_8000_0001_EDX);	\
>  	feature_bit(name);							\
>  })
>  
> @@ -622,22 +629,34 @@ static __always_inline u32 raw_cpuid_get(struct cpuid_reg cpuid)
>  	return *__cpuid_entry_get_reg(&entry, cpuid.reg);
>  }
>  
> -static __always_inline void kvm_cpu_cap_init(u32 leaf, u32 mask)
> -{
> -	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
> +/*
> + * Assert that the feature bit being declared, e.g. via F(), is in the CPUID
> + * word that's being initialized.  Exempt 0x8000_0001.EDX usage of 0x1.EDX
> + * features, as AMD duplicated many 0x1.EDX features into 0x8000_0001.EDX.
> + */
> +#define KVM_VALIDATE_CPU_CAP_USAGE(name)				\
> +do {									\
> +	u32 __leaf = __feature_leaf(X86_FEATURE_##name);		\
> +									\
> +	BUILD_BUG_ON(__leaf != kvm_cpu_cap_init_in_progress);		\
> +} while (0)
>  
> -	/*
> -	 * For kernel-defined leafs, mask the boot CPU's pre-populated value.
> -	 * For KVM-defined leafs, explicitly set the leaf, as KVM is the one
> -	 * and only authority.
> -	 */
> -	if (leaf < NCAPINTS)
> -		kvm_cpu_caps[leaf] &= mask;
> -	else
> -		kvm_cpu_caps[leaf] = mask;
> -
> -	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);
> -}
> +/*
> + * For kernel-defined leafs, mask the boot CPU's pre-populated value.  For KVM-
> + * defined leafs, explicitly set the leaf, as KVM is the one and only authority.
> + */
> +#define kvm_cpu_cap_init(leaf, mask)					\
> +do {									\
> +	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);	\
> +	const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;	\

Why not to #define the kvm_cpu_cap_init_in_progress as well instead of a variable?

> +									\
> +	if (leaf < NCAPINTS)						\
> +		kvm_cpu_caps[leaf] &= (mask);				\
> +	else								\
> +		kvm_cpu_caps[leaf] = (mask);				\
> +									\
> +	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);			\
> +} while (0)
>  
>  /*
>   * Undefine the MSR bit macro to avoid token concatenation issues when
> @@ -870,6 +889,10 @@ void kvm_set_cpu_caps(void)
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_cpu_caps);
>  
> +#undef kvm_cpu_cap_init
> +#undef KVM_VALIDATE_CPU_CAP_USAGE
> +#define KVM_VALIDATE_CPU_CAP_USAGE(name)
> +
>  struct kvm_cpuid_array {
>  	struct kvm_cpuid_entry2 *entries;
>  	int maxnent;


Best regards,
	Maxim Levitsky


