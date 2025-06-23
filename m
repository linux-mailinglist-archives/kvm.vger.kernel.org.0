Return-Path: <kvm+bounces-50430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81A49AE57DB
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 01:19:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 823EA4E2A4E
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 23:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D47222750FD;
	Mon, 23 Jun 2025 23:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S5ygN3ZA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F75623A9AD
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 23:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750720647; cv=none; b=adJikxDo7rT1forkipFogR4MoZX5yrceIFeDdwtgeyQRgPTDlzmvTJIua94JB7AKqOIpWsw+mrFGQawJRY4Nol72eJRmXAASZdy42jtfiAfsU/bZytsVOzLlwJVoJl9Dvv628mzJftlo17+6yZqTR4L9mfyeBREbRRX0Iar8hhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750720647; c=relaxed/simple;
	bh=cgrE9342uSRf63myGdouIQCJ22jJc+5tANVbegpfq3I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JuFRfmB4L6YSQFEvv9prR6B6w6yb5p801ECrWe2yUffUbpuR3nh11hVoPoc2D+3bQrjVBMuWszdY9kv1JZag3O9mjmY+Tv+xR0eXJJJrze8qEhC9+NtejD0letwbJqP0kBlW76w9g/8YI3XMV8TKowPVN0Pr7QWh87p7wveAygI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S5ygN3ZA; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23689228a7fso74260755ad.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 16:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750720635; x=1751325435; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B2U97lvMtIgl9ojC8niuGErncTXrxip0ynV99jRG/3k=;
        b=S5ygN3ZAOQ1MufMEs6vXxCvyM9aU9+jZZJMor4bjbcXLyUSWgYUNRW/u49x5PN96FU
         M8ALmtvSfL1oy4UeJdDS9hg5gZ8wZPQLB2QlLbLey9Tcpe+xDSSOVYJrbCaRko8D3iU9
         gcAiYhn+aOkVw6gIkVyBZOqiYX83LglAZLB+M3Bir2PVAL6F/bWfOegVHUYGpcJse2Tt
         gWKqB+nKhwkT0LkAeb2+iIZYOHEVR1bF1sZ37ybA9Mj9LwtZCluikN44t6L9c/nHOkL5
         JMuokxvWVU1MRcGPh4iGLUvByT9L0wE3mu9GMuaY2vydT5mDxJPHIajSyWVTdRNB2FTg
         AaFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750720635; x=1751325435;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B2U97lvMtIgl9ojC8niuGErncTXrxip0ynV99jRG/3k=;
        b=KMomEZqZgpuonXfLmXUB0ZTIV+ycSDmg0lPspn0/tuXH5w9R/lT8DdE8D2582hyfJ1
         1AE3XsYH20UiWRbLDiVlrbnaE7ajnqBhe47LBVdFbeLIDaVr/gBz3+9f0+Cp/Hqu7r8S
         ZEhlL/ZizdTSm1LfhL19DbBdMTX7krJLUFygLSO0ocHEbQsxjiD9bqGpbCPMscn+dMhI
         vN2N/TUdl7RRrbT0DUkddWz01wzrkxcPbJ4CtGPinPD/Xc931GDwFagju3fGQmpqLEfR
         CwP7OWKJK3Nh0T8iBNleCUEP1LOdh/a0J8E2tIA6QBrsVYkghl3n85yN5UcP1CEtxb9X
         N9iQ==
X-Gm-Message-State: AOJu0Yw6JiSX0Kn5JPVbwqDGB7cJi36c3QE+6hk1YCTYxE9Rfh0MFVhe
	WtUcm6CDO4tn06pb3y1uQIcdtmB9wzmOgnLlDE+MCuqD8+K0oZXoL7zTxXQOElAojpHc12ovrTa
	7SBg3Gw==
X-Google-Smtp-Source: AGHT+IEZoYdqVNB7akE6IgP9niVgwAxNf85zpIYvFK58KzbbkMS0KPZA6X9ClqT9Lv2H6YzlKPSZHE0HEr8=
X-Received: from pjboi14.prod.google.com ([2002:a17:90b:3a0e:b0:311:ff32:a85d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e842:b0:235:f1e4:3383
 with SMTP id d9443c01a7336-237d96b63camr221358465ad.7.1750720634958; Mon, 23
 Jun 2025 16:17:14 -0700 (PDT)
Date: Mon, 23 Jun 2025 16:17:13 -0700
In-Reply-To: <330d10700c1172982bcb7947a37c0351f7b50958.1740036492.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1740036492.git.naveen@kernel.org> <330d10700c1172982bcb7947a37c0351f7b50958.1740036492.git.naveen@kernel.org>
Message-ID: <aFngeQ5x6QiP7SsK@google.com>
Subject: Re: [PATCH v3 1/2] KVM: SVM: Increase X2AVIC limit to 4096 vcpus
From: Sean Christopherson <seanjc@google.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 20, 2025, Naveen N Rao (AMD) wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> Newer AMD platforms enhance x2AVIC feature to support up to 4096 vcpus.
> This capatility is detected via CPUID_Fn8000000A_ECX[x2AVIC_EXT].
> 
> Modify the SVM driver to check the capability. If detected, extend bitmask
> for guest max physical APIC ID to 0xFFF, increase maximum vcpu index to
> 4095, and increase the size of the Phyical APIC ID table from 4K to 32K in
> order to accommodate up to 4096 entries.

Kinda silly, but please split this into (at least) two patches.  One to introduce
the variables to replace the macros, and then one to actually implement support
for 4096 entries.  That makes it a _lot_ easier to review each change (I'm having
trouble teasing out what's actually changing for 4k support).

The changelog also needs more info.  Unless I'm misreading the diff, only the
physical table is being expanded?  How does that work?  (I might be able to
figure it out if I think hard, but I shouldn't have to think that hard).

> @@ -182,7 +185,8 @@ void avic_vm_destroy(struct kvm *kvm)
>  	if (kvm_svm->avic_logical_id_table_page)
>  		__free_page(kvm_svm->avic_logical_id_table_page);
>  	if (kvm_svm->avic_physical_id_table_page)
> -		__free_page(kvm_svm->avic_physical_id_table_page);
> +		__free_pages(kvm_svm->avic_physical_id_table_page,
> +			     get_order(sizeof(u64) * (x2avic_max_physical_id + 1)));

The order should be encapsulated in some way, e.g. through a global or a helper.

> @@ -1218,8 +1224,19 @@ bool avic_hardware_setup(void)
>  
>  	/* AVIC is a prerequisite for x2AVIC. */
>  	x2avic_enabled = boot_cpu_has(X86_FEATURE_X2AVIC);
> -	if (x2avic_enabled)
> -		pr_info("x2AVIC enabled\n");
> +	if (x2avic_enabled) {
> +		x2avic_4k_vcpu_supported = !!(cpuid_ecx(0x8000000a) & 0x40);

No, add an X86_FEATURE_xxx for this, don't open code the CPUID lookup.  I think
I'd even be tempted to use helpers instead of  

> +		if (x2avic_4k_vcpu_supported) {
> +			x2avic_max_physical_id = X2AVIC_MAX_PHYSICAL_ID_4K;
> +			avic_physical_max_index_mask = AVIC_PHYSICAL_MAX_INDEX_4K_MASK;
> +		} else {
> +			x2avic_max_physical_id = X2AVIC_MAX_PHYSICAL_ID;
> +			avic_physical_max_index_mask = AVIC_PHYSICAL_MAX_INDEX_MASK;
> +		}
> +
> +		pr_info("x2AVIC enabled%s\n",
> +			x2avic_4k_vcpu_supported ? " (w/ 4K-vcpu)" : "");

Maybe print the max number of vCPUs that are supported?  That way there is clear
signal when 4k *isn't* supported (and communicating the max number of vCPUs in
the !4k case would be helpful too).

> +	}
>  
>  	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
>  
> -- 
> 2.48.1
> 

