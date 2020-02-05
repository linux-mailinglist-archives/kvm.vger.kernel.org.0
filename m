Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C67A153307
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgBEOb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:31:57 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35363 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727029AbgBEOb5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 09:31:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580913116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mg1Th2L85ZV+oLUD33kayk4c9HCyioQGXSW157MfbhQ=;
        b=RhL42j6SQRumKXCN4S+l4dbhjk7pV6e7gWX0UxH6gWiUthBEbkpQbm7iEDKeXENZCYNEyk
        8WzFz17zdUHc4G0cmpL2MRNR+TIbQOvuHIhSw9BYQiSWTP1EizXzF5wglERsgJVlNCbBHq
        LYULJwzZbAfNuDk0T20k7OYcKxtb7xM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-nhqpUxDxPhKEh_WqgiR08w-1; Wed, 05 Feb 2020 09:31:54 -0500
X-MC-Unique: nhqpUxDxPhKEh_WqgiR08w-1
Received: by mail-wr1-f71.google.com with SMTP id m15so1245919wrs.22
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 06:31:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Mg1Th2L85ZV+oLUD33kayk4c9HCyioQGXSW157MfbhQ=;
        b=bMTsNukMuQJC3ouQTRK8R6DH09TNPKX4XjZS5BO/AIb1rMlqCMSBt8cHaNRBffFgM3
         XcNaseE/kJNOLKrM5wVxDLaARd1oK5lenzjlStNT/HxTURXoQv+Bw0jKY102guPgUi+j
         A15NOQOQu5maF+XTR1G0wmdJsFtcpk4d26zFK2mFsDwfung7yahTWP0PjdRn0vrqCa1d
         gYYZiJ2PCKxCkQPkA4FAW6/z5h4J3/Xf4SGJt0R7LiIOQL16DbddfJ+iQNWx8beGBtsn
         YW/B5fzxt4frrhNoqwhKbDdrxKF4AI68KV0HIPC9hk8sOvDm2P8y/GukErJDsVFaPoph
         2T8g==
X-Gm-Message-State: APjAAAUSCvMLsa/lNgWnndgTR0WqZo6D/qZNoYhfNAnOMH6mEE4hE3rm
        EnJtLvie2jExJuYglb6Nc2+r/Y3EAoh/VmODNXpF+5/gqHuB2OmpJElrDWgb+ooKDLGvokY2AYi
        TVJmivbnoFmL2
X-Received: by 2002:a5d:484d:: with SMTP id n13mr28177106wrs.420.1580913113248;
        Wed, 05 Feb 2020 06:31:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqy7/dlth4bvAjpy6voR42mx04MHqJ6n03P+H951thY5HiEwl1c3RThylJOEg3jhmaLLE0xvTw==
X-Received: by 2002:a5d:484d:: with SMTP id n13mr28177086wrs.420.1580913113049;
        Wed, 05 Feb 2020 06:31:53 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f207sm8747292wme.9.2020.02.05.06.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 06:31:52 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/26] KVM: x86: Snapshot MSR index in a local variable when processing lists
In-Reply-To: <20200129234640.8147-4-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com> <20200129234640.8147-4-sean.j.christopherson@intel.com>
Date:   Wed, 05 Feb 2020 15:31:51 +0100
Message-ID: <87h805ksvc.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Snapshot the MSR index when processing the virtualized and emulated MSR
> lists in kvm_init_msr_list() to improve code readability, particularly
> in the RTIT and PerfMon MSR checks.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 24597526b5de..3d4a5326d84e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5214,7 +5214,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  static void kvm_init_msr_list(void)
>  {
>  	struct x86_pmu_capability x86_pmu;
> -	u32 dummy[2];
> +	u32 dummy[2], msr_index;
>  	unsigned i;
>  
>  	BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 4,
> @@ -5227,14 +5227,16 @@ static void kvm_init_msr_list(void)
>  	num_msr_based_features = 0;
>  
>  	for (i = 0; i < ARRAY_SIZE(msrs_to_save_all); i++) {
> -		if (rdmsr_safe(msrs_to_save_all[i], &dummy[0], &dummy[1]) < 0)
> +		msr_index = msrs_to_save_all[i];
> +
> +		if (rdmsr_safe(msr_index, &dummy[0], &dummy[1]) < 0)
>  			continue;
>  
>  		/*
>  		 * Even MSRs that are valid in the host may not be exposed
>  		 * to the guests in some cases.
>  		 */
> -		switch (msrs_to_save_all[i]) {
> +		switch (msr_index) {
>  		case MSR_IA32_BNDCFGS:
>  			if (!kvm_mpx_supported())
>  				continue;
> @@ -5262,17 +5264,17 @@ static void kvm_init_msr_list(void)
>  			break;
>  		case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
>  			if (!kvm_x86_ops->pt_supported() ||
> -				msrs_to_save_all[i] - MSR_IA32_RTIT_ADDR0_A >=
> +				msr_index - MSR_IA32_RTIT_ADDR0_A >=
>  				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
>  				continue;
>  			break;
>  		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
> -			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
> +			if (msr_index - MSR_ARCH_PERFMON_PERFCTR0 >=
>  			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>  				continue;
>  			break;
>  		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 17:
> -			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
> +			if (msr_index - MSR_ARCH_PERFMON_EVENTSEL0 >=
>  			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>  				continue;
>  			break;
> @@ -5280,14 +5282,16 @@ static void kvm_init_msr_list(void)
>  			break;
>  		}
>  
> -		msrs_to_save[num_msrs_to_save++] = msrs_to_save_all[i];
> +		msrs_to_save[num_msrs_to_save++] = msr_index;
>  	}
>  
>  	for (i = 0; i < ARRAY_SIZE(emulated_msrs_all); i++) {
> -		if (!kvm_x86_ops->has_emulated_msr(emulated_msrs_all[i]))
> +		msr_index = emulated_msrs_all[i];
> +
> +		if (!kvm_x86_ops->has_emulated_msr(msr_index))
>  			continue;
>  
> -		emulated_msrs[num_emulated_msrs++] = emulated_msrs_all[i];
> +		emulated_msrs[num_emulated_msrs++] = msr_index;
>  	}
>  
>  	for (i = 0; i < ARRAY_SIZE(msr_based_features_all); i++) {

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

