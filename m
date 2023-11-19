Return-Path: <kvm+bounces-2022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7404F7F0825
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 18:36:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37280280E15
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 17:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 900E71946B;
	Sun, 19 Nov 2023 17:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YNrX/hwA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D62133
	for <kvm@vger.kernel.org>; Sun, 19 Nov 2023 09:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700415406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zSZWaEcrttfVUQAUXiV/dZPRnPufWlgpAWqh2E7JRwk=;
	b=YNrX/hwAEI94nIDHc/Zc5/k63q8000OQjgGGLVFs+O+HZoj6ON+UghOxemtuPFc2X4nyiW
	lGl9nCLJ2rNiGBhdt1ztYMhZKecPutZYMdXAZAqO5N0aYZSGFMRbE9/v3gNosZ7nyDHrVP
	8WdYncOLBKHghPrPqusH1JIYw18LKus=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-ucNck1FaNhe9JAzkAzlozg-1; Sun, 19 Nov 2023 12:36:45 -0500
X-MC-Unique: ucNck1FaNhe9JAzkAzlozg-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5091368e043so4023512e87.2
        for <kvm@vger.kernel.org>; Sun, 19 Nov 2023 09:36:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700415403; x=1701020203;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zSZWaEcrttfVUQAUXiV/dZPRnPufWlgpAWqh2E7JRwk=;
        b=i2bFUKmfBZ7BeHbhpT6ibu0X74WefpgeRmczsSwpWUxBdCMk8we98JaFrksMv2bUp8
         y+O76FskSpHauWJwG2sKzNOaXPiaiyrxtJEdI2PMabga1T2eZX1UQURKiF0zqCiy5ppp
         BF7yJsHkSoPQG3t49C7/8rM0tQVBWToVnrHhXnD6QtoZxHVWRGolycKK3fi2U8j+7ClO
         q4xbuwLSUjhFDelZNW5OOuAjE3scuhX+n0y8PtkdzppJsvJ46J8ZCwqVykt02erHufiT
         mZfdb0tKZFNu9r0KDesswJLPmKPKnNyyCMHP+toKi3U8QR0fWHgzf/hcLFjLky36Tetu
         kPbw==
X-Gm-Message-State: AOJu0YwF+JKsF+7v3yZtbh4AreJsmmDh2uGqtQIDUtKZyrH94zcv+hED
	tScJ+A2WdsqhXJkLb10uRaKd5o4SqtC3jexiEA/qS5EzXWQ+jMGFDSyzpLqZZr+tM+3ZaG/aWWe
	G3haPpgpLty3D
X-Received: by 2002:a05:6512:11cf:b0:509:cbfa:917d with SMTP id h15-20020a05651211cf00b00509cbfa917dmr3440278lfr.37.1700415403727;
        Sun, 19 Nov 2023 09:36:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHuRmqU0kDIKtxILH0KaovH9AaYwyddjLh71/hWyKYE45ZzBTjIXARO/xDEA0LFMXYuEZ4+BA==
X-Received: by 2002:a05:6512:11cf:b0:509:cbfa:917d with SMTP id h15-20020a05651211cf00b00509cbfa917dmr3440274lfr.37.1700415403356;
        Sun, 19 Nov 2023 09:36:43 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id dm8-20020a0560000bc800b00332c08f828bsm3869295wrb.74.2023.11.19.09.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Nov 2023 09:36:43 -0800 (PST)
Message-ID: <9b6645bbe95ef98327c922822b7a4ff6b0b80bad.camel@redhat.com>
Subject: Re: [PATCH 9/9] KVM: x86: Restrict XSAVE in cpu_caps based on KVM
 capabilities
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 19 Nov 2023 19:36:41 +0200
In-Reply-To: <20231110235528.1561679-10-seanjc@google.com>
References: <20231110235528.1561679-1-seanjc@google.com>
	 <20231110235528.1561679-10-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-10 at 15:55 -0800, Sean Christopherson wrote:
> Restrict XSAVE in guest cpu_caps so that XSAVES dependencies on XSAVE are
> automatically handled instead of manually checking for host and guest
> XSAVE support.  Aside from modifying XSAVE in cpu_caps, this should be a
> glorified nop as KVM doesn't query guest XSAVE support (which is also why
> it wasn't/isn't a bug to leave XSAVE set in guest CPUID).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 2 +-
>  arch/x86/kvm/vmx/vmx.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9e3a9191dac1..6fe2d7bf4959 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4315,8 +4315,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	 * XSS on VM-Enter/VM-Exit.  Failure to do so would effectively give
>  	 * the guest read/write access to the host's XSS.
>  	 */
> +	guest_cpu_cap_restrict(vcpu, X86_FEATURE_XSAVE);
>  	guest_cpu_cap_change(vcpu, X86_FEATURE_XSAVES,
> -			     boot_cpu_has(X86_FEATURE_XSAVE) &&
>  			     boot_cpu_has(X86_FEATURE_XSAVES) &&
>  			     guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE));
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 815692dc0aff..7645945af5c5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7752,8 +7752,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	 * to the guest.  XSAVES depends on CR4.OSXSAVE, and CR4.OSXSAVE can be
>  	 * set if and only if XSAVE is supported.
>  	 */
> -	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
> -	    guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
> +	guest_cpu_cap_restrict(vcpu, X86_FEATURE_XSAVE);
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
>  		guest_cpu_cap_restrict(vcpu, X86_FEATURE_XSAVES);
>  	else
>  		guest_cpu_cap_clear(vcpu, X86_FEATURE_XSAVES);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky





