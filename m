Return-Path: <kvm+bounces-20983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA44D927FAB
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 45BC51F22243
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1F2161FFC;
	Fri,  5 Jul 2024 01:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YsZx7Tsy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFDE4962D
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720142277; cv=none; b=CW8q/MgVcPyj0WDaU5ivmqYLSBkji4B56lJMrFSPK5yRQ37wQTpZem9WWjCyHZvT198+87EFT/m3ujvSggsySh+cmW7/4ouwbQFWcK7jIP5p0ZAvT13vidm90Uz43r3gJc3+Ol69ZOUPCBSr6GlM2monWtXNpqaI/TZYLiUOiRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720142277; c=relaxed/simple;
	bh=n7UVv1WA93U7YlWGXirVicQTSjGz0eawe+gBS0tcgYA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NHcAJNuj+EW5oqQRXQAVq5EKFDM2kV2hPp+6HQuopYCzzmdXNZ3CXoF6l5AhwqFYdo9JVAB+npknr4czzIjyIXKrVpq2YRikdKhnbe6VtRd1EHXiYY5sZ5gQET0dnUXuWiO3Q/FA/LdeJReaNgK3ekii5icQ/a1s+LdQPYSQ55Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YsZx7Tsy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720142275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1/ry0iGhY1xFy8pb9J/aGWStOny/Pe+IJXWZIUBRwfw=;
	b=YsZx7TsyNXx8fjkFOZ12NQ9apB8/m3cj3DFE9wEikx+gknqY2yGK/vfrsbi3dajmm7IvZV
	b8AgMg23+8PLqRs2C/gFLnuBmp5qRvspG4kXVwy9prroaF1x3h2F4GQj+V37HkeX7DClbm
	w8PcPIJm7SOJY4tmtFv29aZACFM/YnQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-jXoFW7FNMliZmCQj-8X2pA-1; Thu, 04 Jul 2024 21:17:53 -0400
X-MC-Unique: jXoFW7FNMliZmCQj-8X2pA-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-444ff2c9a07so18498921cf.0
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:17:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720142273; x=1720747073;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1/ry0iGhY1xFy8pb9J/aGWStOny/Pe+IJXWZIUBRwfw=;
        b=qdW5uCe81nQwO00xUjtMerDMDdoP5+WDM/W+Knsuw6SZmMvKaUHn8CgyT7GaQWx2Tu
         e6UAIJx3vBF6xfCGhh0KpTSwQtL5j2PS3NmeFblDeTsv/OaoH+QXxXdSLu49qLFjk0cP
         oCAq4Pl09P77O3paZMIhbsXozub+jVmthHSt4dpWi9aU1y+VhQqdV25HskqpekRfE7T+
         9CIVVew5mV/jTjntYe0U8lLMy8UBsnUSuaNNJ6FBED0oEzTNIqKJOAUSpoGlM1APahcV
         YZwVi4BeHxuyluDVA/gr/aMG5gks3LaqnCBAPSH8zXanZHLiTylqWLafKJvsa7ZKPdpD
         aaOw==
X-Gm-Message-State: AOJu0Ywz4JkRyTINfd0RP7PQTmjpz8HvIX61tTHZfupAGeqpngi0s/mf
	zRL5o3xMDF9bAPw6Dm13SKkpjNvg/J014/kl34I68lVpxTzrY8+VAH6gKU/rP2l4EWbLvwluZ8h
	PgeKRfxHxLL7LuL7Oi7MuCvT6fkVzUpUPq7hpwpYQ+C2Ax0bAkA==
X-Received: by 2002:a05:622a:1104:b0:446:5d98:bbb1 with SMTP id d75a77b69052e-447cbf5778fmr41822441cf.32.1720142273126;
        Thu, 04 Jul 2024 18:17:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFBnWWKQ+/hy3tFj3UGtv2FlkhLclr89+sVQm9HpFjxfb4EOMBspCv6n07WlHrzUboQoHBj4g==
X-Received: by 2002:a05:622a:1104:b0:446:5d98:bbb1 with SMTP id d75a77b69052e-447cbf5778fmr41822281cf.32.1720142272824;
        Thu, 04 Jul 2024 18:17:52 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4465143eeefsm65145331cf.51.2024.07.04.18.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:17:52 -0700 (PDT)
Message-ID: <e24729812e915b4d195ec0259a6dfa0c4c6d5be8.camel@redhat.com>
Subject: Re: [PATCH v2 17/49] KVM: x86: Do reverse CPUID sanity checks in
 __feature_leaf()
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:17:51 -0400
In-Reply-To: <20240517173926.965351-18-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-18-seanjc@google.com>
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
> Do the compile-time sanity checks on reverse_cpuid in __feature_leaf() so
> that higher level APIs don't need to "manually" perform the sanity checks.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.h         | 3 ---
>  arch/x86/kvm/reverse_cpuid.h | 6 ++++--
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 7eb3d7318fc4..d68b7d879820 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -198,7 +198,6 @@ static __always_inline void kvm_cpu_cap_clear(unsigned int x86_feature)
>  {
>  	unsigned int x86_leaf = __feature_leaf(x86_feature);
>  
> -	reverse_cpuid_check(x86_leaf);
>  	kvm_cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
>  }
>  
> @@ -206,7 +205,6 @@ static __always_inline void kvm_cpu_cap_set(unsigned int x86_feature)
>  {
>  	unsigned int x86_leaf = __feature_leaf(x86_feature);
>  
> -	reverse_cpuid_check(x86_leaf);
>  	kvm_cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
>  }
>  
> @@ -214,7 +212,6 @@ static __always_inline u32 kvm_cpu_cap_get(unsigned int x86_feature)
>  {
>  	unsigned int x86_leaf = __feature_leaf(x86_feature);
>  
> -	reverse_cpuid_check(x86_leaf);
>  	return kvm_cpu_caps[x86_leaf] & __feature_bit(x86_feature);
>  }
>  
> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> index 2f4e155080ba..245f71c16272 100644
> --- a/arch/x86/kvm/reverse_cpuid.h
> +++ b/arch/x86/kvm/reverse_cpuid.h
> @@ -136,7 +136,10 @@ static __always_inline u32 __feature_translate(int x86_feature)
>  
>  static __always_inline u32 __feature_leaf(int x86_feature)
>  {
> -	return __feature_translate(x86_feature) / 32;
> +	u32 x86_leaf = __feature_translate(x86_feature) / 32;
> +
> +	reverse_cpuid_check(x86_leaf);
> +	return x86_leaf;
>  }
>  
>  /*
> @@ -159,7 +162,6 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned int x86_featu
>  {
>  	unsigned int x86_leaf = __feature_leaf(x86_feature);
>  
> -	reverse_cpuid_check(x86_leaf);
>  	return reverse_cpuid[x86_leaf];
>  }
>  

Makes sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


