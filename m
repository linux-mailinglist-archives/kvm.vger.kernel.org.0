Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27549368CFD
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 08:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbhDWGNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 02:13:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229456AbhDWGNw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 02:13:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619158396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wybd0wJ6WAZPnvMkKChhqxUz10KMVtvkXfbGe/E+wbQ=;
        b=JnNWN/N6oqwjcmiSirGqIGLpWmYRbfUEs+HE8lmSEE0ifmYBtV/9I3dPiWt/1g4bKjCviq
        oB7zG6zeawUuNBw6xKEmxgZtGdl7MvhP78LnijVXAv8tDHlexBDXJcvUR41aQmrQSaylmJ
        nMKIxOFqap2hMgDVdh33kr3YbxmKx8M=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-eYD-mA9POwyAtalhV_pDeA-1; Fri, 23 Apr 2021 02:13:14 -0400
X-MC-Unique: eYD-mA9POwyAtalhV_pDeA-1
Received: by mail-ed1-f71.google.com with SMTP id t11-20020aa7d4cb0000b0290382e868be07so18035706edr.20
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 23:13:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wybd0wJ6WAZPnvMkKChhqxUz10KMVtvkXfbGe/E+wbQ=;
        b=qAn6YybrAraKp7uklFpWSB2fYOIMp/YEVW182RgP19m4cSeKS5ePv5VjDN0ARs7MZs
         94VpHQtinYB4LLGybNrPOaqdCPkidz+fyfp4zSsV9Ky936digvrYKnDJJAyYIsqbNVCl
         J3oa2HpHbbpjy5Azjmv3zcvbhpV6XOzCB/fTX5zMTumPMlgtRYhxxELYYvHW7ZeR2GGR
         6oyC5bUo2q2B0wuoxnIO/MrQwPL/4hSYWVT8X9Qdc48yc6AwvAIawIGCEbKy147zDJCJ
         IvqhpVKQQal8wxfXDpPm58/G79PrEk2sgMee1vKn5Cs4Dsubz23KY0lfDSv0R33AO6zs
         flBw==
X-Gm-Message-State: AOAM532dch8nd5dpLHLe3qbmQXGOF3Ez+T5C6MNEw7ijC3KIRCQ/++4I
        ZTrImiZTCKWbcH4ZOg480JsINt23agpOFk5pY7E5wnNasnhDwDftuw5IfsdZ3BcGkLyLKCMGPMl
        VpobbbiZXlsB8
X-Received: by 2002:aa7:c1c9:: with SMTP id d9mr2448436edp.155.1619158392891;
        Thu, 22 Apr 2021 23:13:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTp4CHjAKVg+y1nrs+atxnkdEHzq45cg6dqUACvcdikUOJ2JPAjRSTl68FvD+1YL74m4CYww==
X-Received: by 2002:aa7:c1c9:: with SMTP id d9mr2448420edp.155.1619158392714;
        Thu, 22 Apr 2021 23:13:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u13sm3151102ejj.16.2021.04.22.23.13.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 23:13:12 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: SVM: Delay restoration of host MSR_TSC_AUX until
 return to userspace
To:     Sean Christopherson <seanjc@google.com>,
        Reiji Watanabe <reijiw@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20210422001736.3255735-1-seanjc@google.com>
 <CAAeT=FxaRV+za7yk8_9p45k4ui3QJx90gN4b8k4egrxux=QWFA@mail.gmail.com>
 <YIHYsa1+psfnszcv@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8cc2bb9a-167e-598c-6a9e-c23e943b1248@redhat.com>
Date:   Fri, 23 Apr 2021 08:13:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YIHYsa1+psfnszcv@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 22:12, Sean Christopherson wrote:
> 	case MSR_TSC_AUX:
> 		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
> 			return 1;
> 
> 		if (!msr_info->host_initiated &&
> 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> 			return 1;
> 
> 		/*
> 		 * TSC_AUX is usually changed only during boot and never read
> 		 * directly.  Intercept TSC_AUX instead of exposing it to the
> 		 * guest via direct_access_msrs, and switch it via user return.
> 		 */
> 		preempt_disable();
> 		r = kvm_set_user_return_msr(TSC_AUX_URET_SLOT, data, -1ull);
> 		preempt_enable();
> 		if (r)
> 			return 1;
> 
> 		/*
> 		 * Bits 63:32 are dropped by AMD CPUs, but are reserved on
> 		 * Intel CPUs.  AMD's APM has incomplete and conflicting info
> 		 * on the architectural behavior; emulate current hardware as
> 		 * doing so ensures migrating from AMD to Intel won't explode.
> 		 */
> 		svm->tsc_aux = (u32)data;
> 		break;
> 

Ok, squashed in the following:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 14ff7f0963e9..00e9680969a2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2875,16 +2875,28 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
  		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
  			return 1;
  
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+			return 1;
+
  		/*
  		 * TSC_AUX is usually changed only during boot and never read
  		 * directly.  Intercept TSC_AUX instead of exposing it to the
  		 * guest via direct_access_msrs, and switch it via user return.
  		 */
-		svm->tsc_aux = data;
-
  		preempt_disable();
-		kvm_set_user_return_msr(TSC_AUX_URET_SLOT, data, -1ull);
+		r = kvm_set_user_return_msr(TSC_AUX_URET_SLOT, data, -1ull);
  		preempt_enable();
+		if (r)
+			return 1;
+
+		/*
+		 * Bits 63:32 are dropped by AMD CPUs, but are reserved on
+		 * Intel CPUs.  AMD's APM has incomplete and conflicting info
+		 * on the architectural behavior; emulate current hardware as
+		 * doing so ensures migrating from AMD to Intel won't explode.
+		 */
+		svm->tsc_aux = (u32)data;
  		break;
  	case MSR_IA32_DEBUGCTLMSR:
  		if (!boot_cpu_has(X86_FEATURE_LBRV)) {

Paolo

