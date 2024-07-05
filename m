Return-Path: <kvm+bounces-21012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DBEB992806B
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:26:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 924AB281202
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95A9219ED;
	Fri,  5 Jul 2024 02:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B8j640GE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D27A29D06
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 02:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720146382; cv=none; b=nzZDFuBE6LmKsPX8ey1OfCxiAFvVNiOKxeDbXhC87hMHmOG0tDuMG4InGIqVxyZ3iTeZV24jcq3bKW4qbfRBRtJCJpnPJnKHsxmyH7byfe0DAvAE1D+QhkyKIF/SsYEslvGJnPBftW3jmlT6QafcXlqtMtAx/W+bKZAlYZ+QWmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720146382; c=relaxed/simple;
	bh=VI6uYP43VrCE5BVgAqM1izsxwt2f74U2UGKYfXHejVo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dzq8i+2IlAU81kd872kqrnG2fITUQ57b2ss9mZlWwpINIfdChKDPbkottpA7wSP+DSZCiqR96N4OcPr+WNoLOEVj4LAkR0suLkWxXdO3kSKQ0JJaOXRwFBsi3BODsnMmvqhterQaLj4Cve+aM3NavjmQOo8zrgAln79Ch6gvqGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B8j640GE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720146379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b7skmqPFDAkxHjvcg2f8mSug2SFsFPGybHobLUjeio4=;
	b=B8j640GEmXOlWR5QbsRdhTvFohPlk5Z4rYsNlTmmHD72kzelSVqKEbUiPgSEIDZPA5TN7L
	4vydK8HjBTeBK8TYR6/yUcgv+Yztc4025wBLKngsBHMA+IdVSkxAVLGHqgT3p0GZr0hYpB
	JewGso8LnYVPpjYbfWOUhxc9hBmSvtU=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-pi7PSoXKPkyiDlADLKQoXg-1; Thu, 04 Jul 2024 22:26:14 -0400
X-MC-Unique: pi7PSoXKPkyiDlADLKQoXg-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6b5d97b7431so15339036d6.3
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 19:26:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720146373; x=1720751173;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b7skmqPFDAkxHjvcg2f8mSug2SFsFPGybHobLUjeio4=;
        b=Ahp5EDY+z/yXYjCPI6qBJMYpZSKepYHtvGHwU87hanoc2SkY+TzkipEv1SzVOMtvOY
         XqBq81fw3K+6e3HRogSf9k9Upa3j4gfJwaIj3jmRMcAJNJENvfzLnFaIrdYRRzCRnlYx
         E/PfM2gRbvMKR9bRIEAjshk9Veoo4HQ8mj2aDWYoiIzydj6IC1EIXb5fGqJMStXPu08A
         b6TrMmTKFCN2uISn7kmFfTZmNQbRy9by7AccHg+dbZ2KXPxN/6fAuBTT6/dEnJ6hG/Nw
         rZOk4kidtMLTnjru4pND96KLhosN5wjfGNSohQUn73aGTDlVInx5NpeDYpIFaPxj6DhE
         37Ww==
X-Gm-Message-State: AOJu0YzJdFSsI8hvfwuDOGPn7CywRkWvJfgfoH++cyIXruIOhx2/xE7o
	gsUYpAjiAj4jjrWfKuJ6R9JPMi0njElQsl5FqCyjAySyPJ8iYwxsSBi2+7jiMLzEnf2I75MLlGt
	Ttlhkv+5/gl5Wy4M0Zs0y02VHqizvl5Do3VLRFpX0JaF0cE5UQA==
X-Received: by 2002:a05:6214:19ca:b0:6b4:fc6f:17ba with SMTP id 6a1803df08f44-6b5ed1d7658mr43946136d6.33.1720146373668;
        Thu, 04 Jul 2024 19:26:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqI7IRFDsn77qjda0I38S1/gkfCdQdiN4hn+6CwUqbAFzPHngy7jEHUMC30UiL0vIeUWvCZA==
X-Received: by 2002:a05:6214:19ca:b0:6b4:fc6f:17ba with SMTP id 6a1803df08f44-6b5ed1d7658mr43946046d6.33.1720146373385;
        Thu, 04 Jul 2024 19:26:13 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b5a705bc83sm65249216d6.131.2024.07.04.19.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 19:26:13 -0700 (PDT)
Message-ID: <eafcee4f973d3d76bb43c8ee8d59461a14574157.camel@redhat.com>
Subject: Re: [PATCH v2 45/49] KVM: x86: Shuffle code to prepare for dropping
 guest_cpuid_has()
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 22:26:12 -0400
In-Reply-To: <20240517173926.965351-46-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-46-seanjc@google.com>
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
> Move the implementations of guest_has_{spec_ctrl,pred_cmd}_msr() down
> below guest_cpu_cap_has() so that their use of guest_cpuid_has() can be
> replaced with calls to guest_cpu_cap_has().
> 
> No functional change intended.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.h | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 60da304db4e4..7be56fa62342 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -168,21 +168,6 @@ static inline int guest_cpuid_stepping(struct kvm_vcpu *vcpu)
>  	return x86_stepping(best->eax);
>  }
>  
> -static inline bool guest_has_spec_ctrl_msr(struct kvm_vcpu *vcpu)
> -{
> -	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
> -		guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) ||
> -		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) ||
> -		guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD));
> -}
> -
> -static inline bool guest_has_pred_cmd_msr(struct kvm_vcpu *vcpu)
> -{
> -	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
> -		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB) ||
> -		guest_cpuid_has(vcpu, X86_FEATURE_SBPB));
> -}
> -
>  static inline bool supports_cpuid_fault(struct kvm_vcpu *vcpu)
>  {
>  	return vcpu->arch.msr_platform_info & MSR_PLATFORM_INFO_CPUID_FAULT;
> @@ -301,4 +286,19 @@ static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr
>  	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
>  }
>  
> +static inline bool guest_has_spec_ctrl_msr(struct kvm_vcpu *vcpu)
> +{
> +	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
> +		guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) ||
> +		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) ||
> +		guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD));
> +}
> +
> +static inline bool guest_has_pred_cmd_msr(struct kvm_vcpu *vcpu)
> +{
> +	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
> +		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB) ||
> +		guest_cpuid_has(vcpu, X86_FEATURE_SBPB));
> +}
> +
>  #endif

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


