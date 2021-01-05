Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31312EB4C7
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 22:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbhAEVRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 16:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbhAEVQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 16:16:59 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F324C061795
        for <kvm@vger.kernel.org>; Tue,  5 Jan 2021 13:16:19 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id j1so431131pld.3
        for <kvm@vger.kernel.org>; Tue, 05 Jan 2021 13:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QbMPt8I3VcRDdWxFclid09bafyeFef46ToM33ENhg8c=;
        b=fpeX5OkkCMF1T8lCjn/AmjHrXc25G2Nzid/hZkoJCp3XOp+2OVdMIKyyBw/z2DlDiI
         a25BAr1DWsHBb/mI6kl2fcWxRwrvWi7EvKbWkjcluD2mY3fZIOUjCb397KCJDm+ctaKx
         mXB5BoRR4GrMhnsA5vvHOUltn0OEBX8PglQiuUqeMPKJ7zU/5GWUQO5Izb9u0lV5wkR5
         Lrg5o3cu6or3N1DQ0B12I1LPrPMRS4IIsVwGG4YIiR6sjuE5j1/WesCf9a+cp9Xnu8qc
         szC8UOrvG9rVI7cmCA9wqg7TfDd2pSko//4lnULUjSCV1oOCWUenVU5t3EQDEiAluKZe
         aCzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QbMPt8I3VcRDdWxFclid09bafyeFef46ToM33ENhg8c=;
        b=MzoUXULJdrG9BA/taEVysjRGICPN+4NDQ3kLi4z9Q2cr56ApGCUx7vbZfViBX+Ad6k
         hEoKMgILNCjZ3jaIetlRa7WFbBjg5vpw6bTE0tfraRePMzWO/Tca8sEW5CSd/gkRDSG7
         TvrxON4u1c9arajYdynft+rDvkFF1eWIx+0GNITArRNXdkjzDdoqtRTWMX+PRunvGKAI
         ONGP4/Q3f2ugol8AHYJmo6rBrg7r+zl9JmHRZQszmOctUBznA3jBdrXF0AwNfa+Jj9t/
         oI48RPx1TXMvbivGj8Cq7MNrFKTDwi71zpvUwG2xXW73GyV3b/L8zx/YYezkXBc7n1ds
         khtw==
X-Gm-Message-State: AOAM530a2sj5bD4zbIa147pfUH3wMCjpmiId03XEdn3v1BceMmlYrshN
        +akxv2TlOUtAuBLz9vyNj0/Khw==
X-Google-Smtp-Source: ABdhPJzq5QwWRsJrE96Y2r1fco4KEk7Wm4xkd6N+WrDv4kW4wImLyEPrOR/TQmsWiBYpbZX7KkJuVg==
X-Received: by 2002:a17:902:7292:b029:dc:ac9:25b5 with SMTP id d18-20020a1709027292b02900dc0ac925b5mr1147305pll.2.1609881378803;
        Tue, 05 Jan 2021 13:16:18 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id b129sm113138pgc.52.2021.01.05.13.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 13:16:18 -0800 (PST)
Date:   Tue, 5 Jan 2021 13:16:11 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 07/17] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to
 manage guest DS buffer
Message-ID: <X/TXGylLUVLHNIC7@google.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-8-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104131542.495413-8-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 04, 2021, Like Xu wrote:
> When CPUID.01H:EDX.DS[21] is set, the IA32_DS_AREA MSR exists and
> points to the linear address of the first byte of the DS buffer
> management area, which is used to manage the PEBS records.
> 
> When guest PEBS is enabled and the value is different from the
> host, KVM will add the IA32_DS_AREA MSR to the msr-switch list.
> The guest's DS value can be loaded to the real HW before VM-entry,
> and will be removed when guest PEBS is disabled.
> 
> The WRMSR to IA32_DS_AREA MSR brings a #GP(0) if the source register
> contains a non-canonical address. The switch of IA32_DS_AREA MSR would
> also, setup a quiescent period to write the host PEBS records (if any)
> to host DS area rather than guest DS area.
> 
> When guest PEBS is enabled, the MSR_IA32_DS_AREA MSR will be
> added to the perf_guest_switch_msr() and switched during the
> VMX transitions just like CORE_PERF_GLOBAL_CTRL MSR.
> 
> Originally-by: Andi Kleen <ak@linux.intel.com>
> Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  arch/x86/events/intel/core.c    | 13 +++++++++++++
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/vmx/pmu_intel.c    | 11 +++++++++++
>  arch/x86/kvm/vmx/vmx.c          |  6 ++++++
>  4 files changed, 31 insertions(+)
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 6453b8a6834a..ccddda455bec 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -3690,6 +3690,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
>  {
>  	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>  	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
> +	struct debug_store *ds = __this_cpu_read(cpu_hw_events.ds);
>  
>  	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
>  	arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
> @@ -3735,6 +3736,18 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
>  		*nr = 2;
>  	}
>  
> +	if (arr[1].guest) {
> +		arr[2].msr = MSR_IA32_DS_AREA;
> +		arr[2].host = (unsigned long)ds;
> +		/* KVM will update MSR_IA32_DS_AREA with the trapped guest value. */
> +		arr[2].guest = 0ull;
> +		*nr = 3;
> +	} else if (*nr == 2) {
> +		arr[2].msr = MSR_IA32_DS_AREA;
> +		arr[2].host = arr[2].guest = 0;
> +		*nr = 3;
> +	}

Similar comments as the previous patch, please figure out a way to properly
integrate this into the PEBS logic instead of querying arr/nr.

> +
>  	return arr;
>  }
