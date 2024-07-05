Return-Path: <kvm+bounces-21014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37CAA928076
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:37:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B039E1F230DC
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 178221C2AF;
	Fri,  5 Jul 2024 02:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qf2wVQTc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5C012B77
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 02:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720147016; cv=none; b=rBP2JebYDSEpB8zKnE60HpSSm0KkJXFwpco8TvI+0Z/3MdCYI3D5OUsoOnTDlm7PFgh1t1RfXAxgyFAe/nVzS0KKxSefy2CZapX6oVTMUC6E4Vr9YQC780oUBXRdi3l6pYk6Lc3aN4S1cLSuydM9Oe1gUeIhkCqWt50J8BCtKUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720147016; c=relaxed/simple;
	bh=v9OmgWrcgi2iMRVQV/aQiA5Cbw0Rs6Pnul1PFLcxJ4o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=F0EyvAgdnt+CQQfX7PTbJ/qm8XiyeKSN12hrRfJPsOdErrjDp6RsQzWjYrUXtS5iqr45wp6ZMVH7gZw+50jKdNY+0bNA2fDDL4Lend+x2o3oD8EW5LV3dDVld/fBAKDengBQ32+0UOBQtA4V1IctZm39/y48XGYwUM7Lgjs7ypk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qf2wVQTc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720147013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2CY2pdHWwgzF9spn4goYpidxcOqHNB7VNnMsNX5GrPs=;
	b=Qf2wVQTcSr99VaC8+LltiOngjGapRSbm7axGbMh8v1gGslaUIKrh24ZDFxwZbRChBS4QTB
	bSe9pB2wcS+t2xVspGow7iGc5D00z87GQBsO3n9j6rXvyb3qXMX2gl1mOzWw63LbTNnDO9
	lIx4QK4k4KLPhpw8llyaT+rsyRNSwco=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-tivhpwkpNtKKnjTTjbzKfg-1; Thu, 04 Jul 2024 22:36:52 -0400
X-MC-Unique: tivhpwkpNtKKnjTTjbzKfg-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-79cca28445bso119424185a.1
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 19:36:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720147011; x=1720751811;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2CY2pdHWwgzF9spn4goYpidxcOqHNB7VNnMsNX5GrPs=;
        b=EKFzkUx38hMixo6XcP+saRSwQ6rHWlu89krPIktVF3MMOZkQSb/CFxOaGJb+yMB4hN
         GIFFgp0F+B8R/v1eqt23KD3gdI44Dh37pPnNlMPSKgXcJBjB2eivEtB5q5yH/ehbjiFD
         lfNb5GgVqc+Yocu2v4opkk+O4P+bXZtHz07qA4wX+LkRPjzMlScwcvIIRom5LnFI02Hh
         FyIwxBDWYY1IbiGCoCnZcl6zJZBbqObk7ptLiHgbr2ghMLa0iUsaLD047qUYbNtgEynn
         8SekUiRje6rHAUjRhdCS0Pp/qf/DH8cF6dz0ImkLlRAWMNGQoa91Ivjv/CL/B/UbcMIF
         OYZA==
X-Gm-Message-State: AOJu0Ywb2ivQXoiqJk1gBiKqTDFguwdyr2KeVbJGw+MVxPp2AmvFa07M
	SVjPDt9Qgy7EI4FlE40Nz7EdGUxVCfX7PIRNnf/kb+nUFsr/DjXq4ZdzP56iDE5dVd99WA4GTC3
	9/Mm2ISRSMisgNAWsqj7XSJnB2eoOrczrsquN4ETxcM8NKWe0gw==
X-Received: by 2002:a05:620a:b1c:b0:79d:53b5:9e94 with SMTP id af79cd13be357-79eee2bc295mr375704285a.63.1720147011656;
        Thu, 04 Jul 2024 19:36:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1Xq4eF9vAd6slC3xosMDSsAaFQIhx2y5lmUGdqmIWHFHBw4AiAqs7wKb4WhdI9Ufy6W3k/Q==
X-Received: by 2002:a05:620a:b1c:b0:79d:53b5:9e94 with SMTP id af79cd13be357-79eee2bc295mr375702785a.63.1720147011323;
        Thu, 04 Jul 2024 19:36:51 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79d6927aa57sm732020085a.39.2024.07.04.19.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 19:36:51 -0700 (PDT)
Message-ID: <46361f0c834a25ad0a45ca2f1813ade603d29201.camel@redhat.com>
Subject: Re: [PATCH v2 47/49] KVM: x86: Drop superfluous host XSAVE check
 when adjusting guest XSAVES caps
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 22:36:50 -0400
In-Reply-To: <20240517173926.965351-48-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-48-seanjc@google.com>
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
> Drop the manual boot_cpu_has() checks on XSAVE when adjusting the guest's
> XSAVES capabilities now that guest cpu_caps incorporates KVM's support.
> The guest's cpu_caps are initialized from kvm_cpu_caps, which are in turn
> initialized from boot_cpu_data, i.e. checking guest_cpu_cap_has() also
> checks host/KVM capabilities (which is the entire point of cpu_caps).
> 
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 1 -
>  arch/x86/kvm/vmx/vmx.c | 3 +--
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 06770b60c0ba..4aaffbf22531 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4340,7 +4340,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	 * the guest read/write access to the host's XSS.
>  	 */
>  	guest_cpu_cap_change(vcpu, X86_FEATURE_XSAVES,
> -			     boot_cpu_has(X86_FEATURE_XSAVE) &&
>  			     boot_cpu_has(X86_FEATURE_XSAVES) &&
>  			     guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE));

>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 741961a1edcc..6fbdf520c58b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7833,8 +7833,7 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	 * to the guest.  XSAVES depends on CR4.OSXSAVE, and CR4.OSXSAVE can be
>  	 * set if and only if XSAVE is supported.
>  	 */


> -	if (!boot_cpu_has(X86_FEATURE_XSAVE) ||
> -	    !guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
> +	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
>  		guest_cpu_cap_clear(vcpu, X86_FEATURE_XSAVES);

Hi,

I have a question about this code, even before the patch was applied:

While it is obviously correct to disable XSAVES when XSAVE not supported, I wonder:
There are a lot more cases like that and KVM explicitly doesn't bother checking them,
e.g all of the AVX family also depends on XSAVE due to XCR0.

What makes XSAVES/XSAVE dependency special here? Maybe we can remove this code to be consistent?

AMD portion of this patch, on the other hand does makes sense, 
due to a lack of a separate XSAVES intercept.

Best regards,
	Maxim Levitsky

>  

>  	vmx_setup_uret_msrs(vmx);





