Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BF53040B6
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 15:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390188AbhAZOoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 09:44:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731158AbhAZJoI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 04:44:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611654144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9ELbqYkM15Es76ozmIJcHhdpfubxI1cLD4ywGKoPzIA=;
        b=TgB9yCh4u01PAkILeJEqPKCk29JWn/of1V697G0+UBwdO+tXp3zNKNKPgc7W7vyhIe4ep8
        dC83m1HDiNKVqhEXCldWCsbe/Meq9d79uozoMYXf6bHH0/rWvLlXdky2ohBOAbQfuZNp0n
        TPzQD8rVxu+El+hfbXNGaPPIAfuEO+A=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-qHXf7HsoNRa15J5spp2d0g-1; Tue, 26 Jan 2021 04:42:22 -0500
X-MC-Unique: qHXf7HsoNRa15J5spp2d0g-1
Received: by mail-ed1-f71.google.com with SMTP id a26so9166439edx.8
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 01:42:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9ELbqYkM15Es76ozmIJcHhdpfubxI1cLD4ywGKoPzIA=;
        b=fQt0CwRsbGLq/uB1MmZXSCkYs5hPnAyqmDjspOgKaU6QvDrpTynTFLbvKh1rk94NVa
         qBCPm59SbF/PIZdZtOWLH7D4dlWV/BICKzuz5ERrtAJTkbKPf2D7y76OhVoSCPZVphwK
         meWFy+heCkQOYRCYZYefPmIpg+1b+RJtX38EfWwESLt15YZEKbAPMnAdKsxT42jNwQ+a
         468+BHjtCyJp3m5qRC8arCr49CLISoUknuxg1AeW9wPIMhujYLOgEBQ5rn/aKfJKt97w
         doy2HpTCVApJVVFHVdtPyC2q91xxMH9i2KNnJQbUnCKWK3cyThYAVV4XKD7bqpm5yE8k
         TOQg==
X-Gm-Message-State: AOAM531OpLa++peRSr8hiQhBWOEYPOM1/ICRmyqdfxHn/EZcK4g3r1wl
        hO7njj1CR0ZTMHMCiQUryJ4dYXgCBGlwNskcPJgyaAjwW6+EYPw2Z3QY1jxFa0+QxUAaMbWx4MM
        kMVsR+hNtZdar
X-Received: by 2002:a17:906:d0c1:: with SMTP id bq1mr2851338ejb.202.1611654140819;
        Tue, 26 Jan 2021 01:42:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz5q6Cglr8yc4Tr1luUe2n5bPAisSEgBRjI1FR+e19Q51L1XJNavk/drdhQScc+LJysYlFjFA==
X-Received: by 2002:a17:906:d0c1:: with SMTP id bq1mr2851329ejb.202.1611654140650;
        Tue, 26 Jan 2021 01:42:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id de4sm11928924edb.38.2021.01.26.01.42.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 01:42:19 -0800 (PST)
To:     Like Xu <like.xu@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210108013704.134985-1-like.xu@linux.intel.com>
 <20210108013704.134985-4-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RESEND v13 03/10] KVM: x86/pmu: Use IA32_PERF_CAPABILITIES to
 adjust features visibility
Message-ID: <a1291d0b-297c-9146-9689-f4a4129de3c6@redhat.com>
Date:   Tue, 26 Jan 2021 10:42:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108013704.134985-4-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/21 02:36, Like Xu wrote:
> 
> @@ -401,6 +398,9 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
>  		pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
>  		pmu->fixed_counters[i].current_config = 0;
>  	}
> +
> +	vcpu->arch.perf_capabilities = guest_cpuid_has(vcpu, X86_FEATURE_PDCM) ?
> +		vmx_get_perf_capabilities() : 0;

There is one thing I don't understand with this patch: intel_pmu_init is 
not called when CPUID is changed.  So I would have thought that anything 
that uses guest_cpuid_has must stay in intel_pmu_refresh.  As I 
understand it vcpu->arch.perf_capabilities is always set to 0 
(vmx_get_perf_capabilities is never called), and kvm_set_msr_common 
would fail to set any bit in the MSR.  What am I missing?

In addition, the code of patch 4:

+	if (!intel_pmu_lbr_is_enabled(vcpu)) {
+		vcpu->arch.perf_capabilities &= ~PMU_CAP_LBR_FMT;
+		lbr_desc->records.nr = 0;
+	}

is not okay after MSR changes.  The value written by the host must be 
either rejected (with "return 1") or applied unchanged.

Fortunately I think this code is dead if you move the check in 
kvm_set_msr from patch 9 to patch 4.  However, in patch 9 
vmx_get_perf_capabilities() must only set the LBR format bits if 
intel_pmu_lbr_is_compatible(vcpu).


The patches look good apart from these issues and the other nits I 
pointed out.  However, you need testcases here, for both kvm-unit-tests 
and tools/testing/selftests/kvm.

For KVM, it would be at least a basic check that looks for the MSR LBR 
(using the MSR indices for the various processors), does a branch, and 
checks that the FROM_IP/TO_IP are good.  You can write the 
kvm-unit-tests using the QEMU option "-cpu host,migratable=no": if you 
do this, QEMU will pick the KVM_GET_SUPPORTED_CPUID bits and move them 
more or less directly into the guest CPUID.

For tools/testing/selftests/kvm, your test need to check the effect of 
various CPUID settings on the PERF_CAPABILITIES MSR, check that whatever 
you write with KVM_SET_MSR is _not_ modified and can be retrieved with 
KVM_GET_MSR, and check that invalid LBR formats are rejected.

I'm really, really sorry for leaving these patches on my todo list for 
months, but you guys need to understand the main reason for this: they 
come with no testcases.  A large patch series adding userspace APIs and 
complicated CPUID/MSR processing *automatically* goes to the bottom of 
my queue, because:

- I need to go with a fine comb over all the userspace API changes, I 
cannot just look at test code and see if it works.

- I will have no way to test its correctness after it's committed.

For you, the work ends when your patch is accepted.  For me, that's when 
the work begins, and I need to make sure that the patch will be 
maintainable in the future.

Thanks, and sorry again for the delay.

Paolo

