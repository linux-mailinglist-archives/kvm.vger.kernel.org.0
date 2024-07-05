Return-Path: <kvm+bounces-20998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63ED2927FE3
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:52:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EC071C21AA3
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10AD517995;
	Fri,  5 Jul 2024 01:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NenlXpTs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA03C1758C
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720144320; cv=none; b=LKYFHcx/LhfqkylUUGETOb4umYdxGmFDraDfLth3jM0S9CLmRPVEQhXzle/HUNvRYHsq/H5BMO4+68N4ayMG4RUEadCelu9DRDSC+fakAcL9f097Un/Fkz8MSAHYmmmVjCMSb/O09+SvI5jTlq4nrej7CYl6jQnW5zI022yyW2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720144320; c=relaxed/simple;
	bh=y1K4/3AKQIY1iPO1F45D2kPBpwd9iasJJv/d3MHXoC0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Asbf9ZqYx9A63qEYf+jdk7n7RVXZwVR9urnXEoJ04iWFKOvGeGSRttDRZw8h3zFq9LSPw83wLLurlpO8W6B2aUx2bl2HyqXFgYLzcm3YJyJQaFDyy4lA7Y0mpZs4kIEh11FLAP1HHT0Dh7BFUUsEcSZ6dEdAp88qnaqRq3wiu/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NenlXpTs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720144317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QFEmqM2S4F/fr7Hr4LR2lKfwp8vGDXOGQYSAfcHtT6w=;
	b=NenlXpTsDyBLLJe06mqKGLPeFbWGgeKXVOx7uTiP9Q9IlC+fSPOJU+GcaN9DF8J3ry7EzU
	fi7Hc2uUJTSjpZ8azc73+IWdSgROS3a3gxIyllCy1gsDGURzyOsKouXQrKCE4Aajbfxcmx
	TWt3fhKC0z1sl1fK26k9YSjrhjtHKxU=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-XHSRKCdAMJaMcudq9IcbTg-1; Thu, 04 Jul 2024 21:51:56 -0400
X-MC-Unique: XHSRKCdAMJaMcudq9IcbTg-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-65033922659so18009647b3.0
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:51:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720144315; x=1720749115;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QFEmqM2S4F/fr7Hr4LR2lKfwp8vGDXOGQYSAfcHtT6w=;
        b=wgUmYcYvQQ7tj2w9zg8iLKPGnKu8CIIHli+B+grwEpk8FNir6h5osaxFvNkdb8T6pi
         RqphFdIFF1YZ3bhMM//M/lkxaLIE+5Dd1yoMJ1HoSxQOW787TPOzh8qLEWmtisCB1EKw
         le/d4ngDPn+78KiNpk+CtpUo277eSxiDGss0s4Ws9h0XDSKCoQ1goLa2SqA+o+JbWuub
         UFH11PZlggA/rDs4itnl4WS+Ti1WY9KInR7yq8AveNIRpJwRuTQE32L3LQ0yJfiytdBF
         gXEz4DF7XCfVI9PNG5jA6mD5j7XcLw77kK1JTCPYlQSrjD2+mDMjljytDgfW2NFD+fAV
         /hNg==
X-Gm-Message-State: AOJu0YzE1tqcCzafaitrMI03MArNkuIe2BF6bhHhQgTcC7I2Gqcw5lvQ
	9vF4Eii41useD2wFuoDyWX5lrfclXpXuggSRFY5BoMIK0KsSULebUq5QKWM8mQliH9Y5f6t2uHP
	z5B1RqvTv7E5KJ/cOELaFJvPS+NAD9SgDUp29ZpaxHMu4fiIq0g==
X-Received: by 2002:a05:690c:6481:b0:632:b827:a1ba with SMTP id 00721157ae682-654438ce637mr659557b3.7.1720144315708;
        Thu, 04 Jul 2024 18:51:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLE2ITBPr5VAyC3YxZL1I18Xb7Cnl3jcQL4lU5olrNVVDhEPiC780t3ElTIHFx6pImkg7hlg==
X-Received: by 2002:a05:690c:6481:b0:632:b827:a1ba with SMTP id 00721157ae682-654438ce637mr659437b3.7.1720144315430;
        Thu, 04 Jul 2024 18:51:55 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79d692613e0sm728418085a.9.2024.07.04.18.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:51:55 -0700 (PDT)
Message-ID: <4d8731a21b3a040b92f862efd7032b1823f11235.camel@redhat.com>
Subject: Re: [PATCH v2 31/49] KVM: x86: Move kvm_find_cpuid_entry{,_index}()
 up near cpuid_entry2_find()
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:51:54 -0400
In-Reply-To: <20240517173926.965351-32-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-32-seanjc@google.com>
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
> Move kvm_find_cpuid_entry{,_index}() "up" in cpuid.c so that they are
> colocated with cpuid_entry2_find(), e.g. to make it easier to see the
> effective guts of the helpers without having to bounce around cpuid.c.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0526f25a7c80..d7390ade1c29 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -175,6 +175,20 @@ static struct kvm_cpuid_entry2 *cpuid_entry2_find(struct kvm_vcpu *vcpu,
>  	return NULL;
>  }
>  
> +struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
> +						    u32 function, u32 index)
> +{
> +	return cpuid_entry2_find(vcpu, function, index);
> +}
> +EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry_index);
> +
> +struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
> +					      u32 function)
> +{
> +	return cpuid_entry2_find(vcpu, function, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> +}
> +EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
> +
>  static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpuid_entry2 *best;
> @@ -1511,20 +1525,6 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>  	return r;
>  }
>  
> -struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
> -						    u32 function, u32 index)
> -{
> -	return cpuid_entry2_find(vcpu, function, index);
> -}
> -EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry_index);
> -
> -struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
> -					      u32 function)
> -{
> -	return cpuid_entry2_find(vcpu, function, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> -}
> -EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
> -
>  /*
>   * Intel CPUID semantics treats any query for an out-of-range leaf as if the
>   * highest basic leaf (i.e. CPUID.0H:EAX) were requested.  AMD CPUID semantics

Makes sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


