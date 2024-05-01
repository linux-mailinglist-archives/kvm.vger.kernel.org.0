Return-Path: <kvm+bounces-16381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 371D18B9219
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 01:15:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E09641F21EA7
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 23:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738AF168AE4;
	Wed,  1 May 2024 23:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sNHY3byj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4AA43AC3
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 23:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714605332; cv=none; b=glZ5EXypE4slTcB3fg//w11ae4i8jg6VQBvU1Jyy13YEQd/ro9U/vgflnVp6C78/1Oy1oW0mmUe6yCkx8qjeDzq7RCGjRHK/S67hhAo56ER1L4jBDsXTMmRO73JWLzFC2TwH18wW9k1xt3vCOv+glZMBvaBFEo1Mstw8X/AZaAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714605332; c=relaxed/simple;
	bh=3AM2EWff9SwBfyQdM1iIgurVCO8gQYGt1lNkAfst2vM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C4l4h4I2TfSCg0DDThCQFxRLLOTHoSg2+J+oEs0KxLszGjy0IOvjUCse2F4/GtnGJag94MLG7q9VpMgPzFq2uRzMhkUiN/8QI8cLNpavLpywy3YDHKKvPk0Yj5pN+gkOLE+aMPHGcrcLbNbwAXPAwBdvCgtg1FMnQ1JcmPYPMYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sNHY3byj; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de8b66d59f7so419688276.0
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 16:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714605330; x=1715210130; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rLsdIwymTCHMRiGzZhz/oYnmKJwch+ZfMdjTvC31E8w=;
        b=sNHY3byjO3koyPG2YQ+HHE8hcMBqJr/Z1+sayNL28W8riMusWbo0YsEDsqm36jR9of
         LRoNJq4mL64tnmhAPB0Kjhi+FVUY3OGzuEEnjxL0t7kFPeZUJH5S9G5bGik9rjUVwC8Y
         54IynVwEoLG7Vq1bYeLmi4Rkl2/2b/mHHeYQYuqMsw11Nq4oiLNre8zAxIvTHpC/evUz
         3gv0l/z8WYSPk6lgPQvWVzly2SAj0Vut/XnG99mUJp9kwkARSHvB3JvusUKAB2EJFlkQ
         MV73VVKLGOspzSQpEM0/jvYXe8Ds2/BaPaQZXF5KEgZTfhWg9GhOk9ccO2OaG9cLzt8L
         RmTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714605330; x=1715210130;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rLsdIwymTCHMRiGzZhz/oYnmKJwch+ZfMdjTvC31E8w=;
        b=Yfa2Xs6w4tvQHWh1o1sPqinxVu+azGZr+82vfT1JseymwM/dm9qy+QJsntClU2H6Tr
         7c/ejAN2FqVKkGniaZQwI6DGt/mLl4bx4j42eNAP520a7V5EV/5/KCzovnUVD7gWOI48
         pOgd30TR6ZDqok0g3ts9+ym4SlnOsK/KFayEYPQ6Mg24GpJBi4IWemUQ+OIBRfgbTHLP
         Xc/XV3PJnPx14trKs0g+ll27EQwiqh5JF34vkJmGQa9ngAF9FoWqTVcajoXfsSxDerdf
         cXSHbdZdDu9Dkxv6stYyPh1AG+ofJu2zGE0lR982TULKOtvVQ+KDjQDLIa38r/iwOUeX
         d1TA==
X-Forwarded-Encrypted: i=1; AJvYcCXAnHiSlgCbcQkso3O6Nrj3Ny8nPi3Mfwut/Y30UP74m+zsXJLcRQ/CPEABwztv4hKr+iTBcEOvP6n1nMTzN/+Io58I
X-Gm-Message-State: AOJu0YwHyIMeK273D+LO0w3HxlmRcA0tBhZf+j5zuBE39/eNs8exiudv
	sS3W1xGmZS16P8uWEj67K436LwGOSPHDNn934KF3F+wp5PGl873LW8SqsnkrY7GKff19iaJrmKL
	8wA==
X-Google-Smtp-Source: AGHT+IH5Jbyvd3OHt3LMjFeRYVLdua5jhWirNWwQZU+zhsPQlAr4tntyRhPDF3UtZtz+lXOjBlBpJeVMz/c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100a:b0:dd9:2782:d1c6 with SMTP id
 w10-20020a056902100a00b00dd92782d1c6mr263457ybt.1.1714605330246; Wed, 01 May
 2024 16:15:30 -0700 (PDT)
Date: Wed, 1 May 2024 16:15:28 -0700
In-Reply-To: <20240219074733.122080-25-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com> <20240219074733.122080-25-weijiang.yang@intel.com>
Message-ID: <ZjLNEPwXwPFJ5HJ3@google.com>
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
From: Sean Christopherson <seanjc@google.com>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, dave.hansen@intel.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, mlevitsk@redhat.com, 
	john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Feb 18, 2024, Yang Weijiang wrote:
> @@ -696,6 +697,20 @@ void kvm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
>  	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
> +	/*
> +	 * Don't use boot_cpu_has() to check availability of IBT because the
> +	 * feature bit is cleared in boot_cpu_data when ibt=off is applied
> +	 * in host cmdline.

I'm not convinced this is a good reason to diverge from the host kernel.  E.g.
PCID and many other features honor the host setup, I don't see what makes IBT
special.

LA57 is special because it's entirely reasonable, likely even, for a host to
only want to use 48-bit virtual addresses, but still want to let the guest enable
LA57.

> @@ -4934,6 +4935,14 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  
>  	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
>  
> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> +		vmcs_writel(GUEST_SSP, 0);
> +		vmcs_writel(GUEST_S_CET, 0);
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
> +	} else if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
> +		vmcs_writel(GUEST_S_CET, 0);
> +	}

Similar to my comments about MSR interception, I think it would be better to
explicitly handle the "common" field.  At first glance, code like the above makes
it look like IBT is mutually exclusive with SHSTK, e.g. a reader that isn't
looking closely could easily miss that both paths write GUEST_S_CET.

	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
		vmcs_writel(GUEST_SSP, 0);
		vmcs_writel(GUEST_INTR_SSP_TABLE, 0); 
	}
	if (kvm_cpu_cap_has(X86_FEATURE_IBT) ||
	    kvm_cpu_cap_has(X86_FEATURE_SHSTK))
		vmcs_writel(GUEST_S_CET, 0);

