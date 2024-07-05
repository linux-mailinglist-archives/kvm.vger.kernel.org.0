Return-Path: <kvm+bounces-21001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20FBC928002
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:04:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC994282072
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A072914AA0;
	Fri,  5 Jul 2024 02:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c+EsQHPr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32983EEDD
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 02:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720145064; cv=none; b=TyeRwi/66stqunczpB/YvvMlIw4ShQxBDm4GJKJxqVZywWtddqgB1kjO1IiDMUrtmAcspJBwVu/HmKrWg5znKgDmnyMfDc1mygPqZLlLICTeShCKoSIDAJXdwdcERJTAY4pi6/bCw0LNSMej547vW5Rdl97ZRwxJ1WGF6Qc0lRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720145064; c=relaxed/simple;
	bh=5sxmntopPiro+dAs2d7Dodq7BAt/c25oh/tvEL5NMD4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PEo3zelghQjz6TOVmvte2daP/PD7WlzW8Eop8dAOTt6gWqDVg5DpoNXrw8SK9H9cAftl06AUtSq+LkCIInjtQTbf/xf67A0JzilkgkkYl0dU0V/1DYMSPL2kMtwJ8G1UBfrJx6Kz2He2WkiFgN6DxSu0gyc3s4f66wZ6gFmVO48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c+EsQHPr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720145062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Aowq2gEnaeA5ddl8aoPNqVlKxWrjgZgHM1kmUUIcA0A=;
	b=c+EsQHPreASQDCYH04fk5QqR4GjpicYLJCyaAsENZE6yedMsMAa86Y094l9bHiU4fWFnDW
	efDFJQB9WgzOgrOAhxPUU10fRnSiU9jmz9b6MmNUEFircdeGILMZ2v68fCTgQSGW8i+KtZ
	4ic8ruca3B3E2KqrGcwVQlJj3c0VJM8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-H1bUsdHpPaCgNS5QjLuD6g-1; Thu, 04 Jul 2024 22:04:20 -0400
X-MC-Unique: H1bUsdHpPaCgNS5QjLuD6g-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-79d58cde738so134659085a.3
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 19:04:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720145059; x=1720749859;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Aowq2gEnaeA5ddl8aoPNqVlKxWrjgZgHM1kmUUIcA0A=;
        b=g5lFPyhk+QW972ytDrmIDxNHHPmZnV8nUmiAlJ6WdBJ1nCkyNygpWZyTub8BCtxcOq
         1AmEs+vGyqxzobNnar6u71l7o1RxJ8XI6q1pk8g6TesW48zb3XJPL/bQJPpsWgfWV8ZM
         GTHyz0mn9Xe1Rg1oAh3N8kwFtPstEMzq+G2HzgVMiNQlF090SSH1dDj6eQBIZoRf35NA
         BCYyBJ1Bd2W9gtn7eGVFtLmn5Mca6wsZYvrStmRrAzm+DZUvqky4kKqzYvpKAB8VLFa2
         sbJBFMLXs2kxnH7kvuGcasWuddfpY07PFyV+1KYgvAXSceZPcgcPDaE1IurDglEL0V1U
         v2Bg==
X-Gm-Message-State: AOJu0YwUisuEqCDJi+pgPFVhmd/DPzXQO7HeKG/W2oVP1Bfl0ReWr6qB
	7RbHIpHRIIiwtmMnBw/ula/w0WFR4RjYPH2a2M81FHQNiTQIv/ak7yNceuR4XLhG+5+NjJ5SKaN
	ITHU0OP72hoVmJV3n+K8hTrE63+2CpJwFKypbq070YQohApkJjA==
X-Received: by 2002:a05:620a:294b:b0:79d:58ac:9168 with SMTP id af79cd13be357-79eee2ace83mr407929485a.67.1720145059581;
        Thu, 04 Jul 2024 19:04:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFM9rxjElwrzqkT3+9N9Tjrxb8rLoVUarUDB11vtraE1M7t24/rqloulV7k9L5NynHbiUoag==
X-Received: by 2002:a05:620a:294b:b0:79d:58ac:9168 with SMTP id af79cd13be357-79eee2ace83mr407927585a.67.1720145059193;
        Thu, 04 Jul 2024 19:04:19 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79d6925f58esm726668485a.12.2024.07.04.19.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 19:04:18 -0700 (PDT)
Message-ID: <924352564a5ab003b85bf7e2ee422907f9951e26.camel@redhat.com>
Subject: Re: [PATCH v2 33/49] KVM: x86: Advertise TSC_DEADLINE_TIMER in
 KVM_GET_SUPPORTED_CPUID
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 22:04:18 -0400
In-Reply-To: <20240517173926.965351-34-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-34-seanjc@google.com>
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
> Advertise TSC_DEADLINE_TIMER via KVM_GET_SUPPORTED_CPUID when it's
> supported in hardware, as the odds of a VMM emulating the local APIC in
> userspace, not emulating the TSC deadline timer, _and_ reflecting
> KVM_GET_SUPPORTED_CPUID back into KVM_SET_CPUID2 are extremely low.
> 
> KVM has _unconditionally_ advertised X2APIC via CPUID since commit
> 0d1de2d901f4 ("KVM: Always report x2apic as supported feature"), and it
> is completely impossible for userspace to emulate X2APIC as KVM doesn't
> support forwarding the MSR accesses to userspace.  I.e. KVM has relied on
> userspace VMMs to not misreport local APIC capabilities for nearly 13
> years.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 9 ++++++---
>  arch/x86/kvm/cpuid.c           | 4 ++--
>  2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 884846282d06..cb744a646de6 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1804,15 +1804,18 @@ emulate them efficiently. The fields in each entry are defined as follows:
>           the values returned by the cpuid instruction for
>           this function/index combination
>  
> -The TSC deadline timer feature (CPUID leaf 1, ecx[24]) is always returned
> -as false, since the feature depends on KVM_CREATE_IRQCHIP for local APIC
> -support.  Instead it is reported via::
> +x2APIC (CPUID leaf 1, ecx[21) and TSC deadline timer (CPUID leaf 1, ecx[24])
> +may be returned as true, but they depend on KVM_CREATE_IRQCHIP for in-kernel
> +emulation of the local APIC.  TSC deadline timer support is also reported via::
>  
>    ioctl(KVM_CHECK_EXTENSION, KVM_CAP_TSC_DEADLINE_TIMER)
>  
>  if that returns true and you use KVM_CREATE_IRQCHIP, or if you emulate the
>  feature in userspace, then you can enable the feature for KVM_SET_CPUID2.
>  
> +Enabling x2APIC in KVM_SET_CPUID2 requires KVM_CREATE_IRQCHIP as KVM doesn't
> +support forwarding x2APIC MSR accesses to userspace, i.e. KVM does not support
> +emulating x2APIC in userspace.
>  
>  4.47 KVM_PPC_GET_PVINFO
>  -----------------------
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 699ce4261e9c..d1f427284ccc 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -680,8 +680,8 @@ void kvm_set_cpu_caps(void)
>  		F(FMA) | F(CX16) | 0 /* xTPR Update */ | F(PDCM) |
>  		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
>  		F(XMM4_2) | EMUL_F(X2APIC) | F(MOVBE) | F(POPCNT) |
> -		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
> -		F(F16C) | F(RDRAND)
> +		EMUL_F(TSC_DEADLINE_TIMER) | F(AES) | F(XSAVE) |
> +		0 /* OSXSAVE */ | F(AVX) | F(F16C) | F(RDRAND)
>  	);
>  
>  	kvm_cpu_cap_init(CPUID_1_EDX,

Hi,

I have a mixed feeling about this.

First of all KVM_GET_SUPPORTED_CPUID documentation explicitly states that it returns bits
that are supported in *default* configuration
TSC_DEADLINE_TIMER and arguably X2APIC are only supported after enabling various caps,
e.g not default configuration.

However, since X2APIC also in KVM_GET_SUPPORTED_CPUID (also wrongly IMHO), for consistency it does make
sense to add TSC_DEADLINE_TIMER as well.


I do think that we need at least to update the documentation of KVM_GET_SUPPORTED_CPUID
and KVM_GET_EMULATED_CPUID, as I state in a review of a later patch.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




