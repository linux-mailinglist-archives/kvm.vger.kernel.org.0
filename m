Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243CD2EB4B9
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 22:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbhAEVMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 16:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbhAEVMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 16:12:16 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135BBC061793
        for <kvm@vger.kernel.org>; Tue,  5 Jan 2021 13:11:30 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id g3so427699plp.2
        for <kvm@vger.kernel.org>; Tue, 05 Jan 2021 13:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I+ecmB8P4LM1sQ+xFfF2GmApzt0t3GO8C8SxXkADzN0=;
        b=mLOqKmsuKDEyTHjWJIAfJaxvoDZRfRxfiSxvvExeBSacNcJZLogu1EvG/so3xFk/2y
         sVJk6KS9w5QK/wL1G3WWG6PREdcpkzS4BSb6Y21Q1JSBVhveqp9EFDcek5BhUaMm//81
         lkGGBm/Ycch9uK8XkgR3XHjIqPA/gDjZtLdI424lq0q/Yi2rILw6yj9oaMoL7Hb0ZkXM
         ttM0ut0b4uv2twPKYL0rOwhhlHhsF/DAmv1yQUHz+JX3AOZ7a+yLsQPnpfCezGfResyb
         wDinvdvYslJUIplqgdzuruWsFOzEmuVznOuqqT9/GRkAbQrrSF9DapO8eyTfwDVO8QZj
         +8vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I+ecmB8P4LM1sQ+xFfF2GmApzt0t3GO8C8SxXkADzN0=;
        b=ms7nm/OL0fDKdHV8JrTv2t1KDSnqT6YV2f9G1stBUYdkpXgeB12nQuXahmeE4CfI9/
         iyQvhLVYybm+QHADVjluJQfV8hIdcz0XoXDE6OIO5foQ3/a3Ly4H8TGrZnjPxjilu9YL
         JZ6d4s1x4Ms9wm2Wg5n9h14a54iqVyI8CK7dOCvpQ3IYXFpPyCU6Jk8if44xHlhoA4qx
         oFMLuTyFHxYntmouCZo5j57Umk9XLLoqiwMck7etH2BYfF2BmDfyhAPTrA6B5wcq4mIy
         L1gtVKZ/+w8OEFi7BD5hFD3YnFRksHF4Bg+TD7U9WzqXQOYqLkIgB+ZJfIW/aVzpXVvD
         zvXw==
X-Gm-Message-State: AOAM530wO3JvB1eG2NrWB0z0rUKZV6bcSbQDmPKtBrE6PF/gAKtQWGUD
        YXSLbnXYAfnCqpUqDPPoKAQZwA==
X-Google-Smtp-Source: ABdhPJx62s0Z1sHl9ITSwkjI4AAY7sPOOHbNnPhM/zQv0birx4XEWtVCyg2Iu/CAsrAoNjD55MhDBA==
X-Received: by 2002:a17:90a:c798:: with SMTP id gn24mr995980pjb.49.1609881089352;
        Tue, 05 Jan 2021 13:11:29 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id s21sm112537pga.12.2021.01.05.13.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 13:11:28 -0800 (PST)
Date:   Tue, 5 Jan 2021 13:11:18 -0800
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
Subject: Re: [PATCH v3 06/17] KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR
 emulation for extended PEBS
Message-ID: <X/TV9nZw49XFwDF/@google.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-7-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104131542.495413-7-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 04, 2021, Like Xu wrote:
> If IA32_PERF_CAPABILITIES.PEBS_BASELINE [bit 14] is set, the
> IA32_PEBS_ENABLE MSR exists and all architecturally enumerated fixed
> and general purpose counters have corresponding bits in IA32_PEBS_ENABLE
> that enable generation of PEBS records. The general-purpose counter bits
> start at bit IA32_PEBS_ENABLE[0], and the fixed counter bits start at
> bit IA32_PEBS_ENABLE[32].
> 
> When guest PEBS is enabled, the IA32_PEBS_ENABLE MSR will be
> added to the perf_guest_switch_msr() and switched during the
> VMX transitions just like CORE_PERF_GLOBAL_CTRL MSR.
> 
> Originally-by: Andi Kleen <ak@linux.intel.com>
> Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Co-developed-by: Luwei Kang <luwei.kang@intel.com>
> Signed-off-by: Luwei Kang <luwei.kang@intel.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  arch/x86/events/intel/core.c     | 20 ++++++++++++++++++++
>  arch/x86/include/asm/kvm_host.h  |  1 +
>  arch/x86/include/asm/msr-index.h |  6 ++++++
>  arch/x86/kvm/vmx/pmu_intel.c     | 28 ++++++++++++++++++++++++++++
>  4 files changed, 55 insertions(+)
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index af457f8cb29d..6453b8a6834a 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -3715,6 +3715,26 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
>  		*nr = 2;
>  	}
>  
> +	if (cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask) {
> +		arr[1].msr = MSR_IA32_PEBS_ENABLE;
> +		arr[1].host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask;
> +		arr[1].guest = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
> +		/*
> +		 * The guest PEBS will be disabled once the host PEBS is enabled
> +		 * since the both enabled case may brings a unknown PMI to
> +		 * confuse host and the guest PEBS overflow PMI would be missed.
> +		 */
> +		if (arr[1].host)
> +			arr[1].guest = 0;
> +		arr[0].guest |= arr[1].guest;

Can't you modify the code that strips the PEBS counters from the guest's
value instead of poking into the array entry after the fact?

Also, why is this scenario even allowed?  Can't we force exclude_guest for
events that use PEBS?

> +		*nr = 2;
> +	} else if (*nr == 1) {
> +		/* Remove MSR_IA32_PEBS_ENABLE from MSR switch list in KVM */
> +		arr[1].msr = MSR_IA32_PEBS_ENABLE;
> +		arr[1].host = arr[1].guest = 0;
> +		*nr = 2;

Similar to above, rather then check "*nr == 1", this should properly integrate
with the "x86_pmu.pebs && x86_pmu.pebs_no_isolation" logic instead of poking
into the array after the fact.

By incorporating both suggestions, the logic can be streamlined significantly,
and IMO makes the overall flow much more understandable.  Untested...

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index d4569bfa83e3..c5cc7e558c8e 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3708,24 +3708,39 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
        arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
        arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
        arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
-       if (x86_pmu.flags & PMU_FL_PEBS_ALL)
-               arr[0].guest &= ~cpuc->pebs_enabled;
-       else
-               arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
+
+       /*
+        * Disable PEBS in the guest if PEBS is used by the host; enabling PEBS
+        * in both will lead to unexpected PMIs in the host and/or missed PMIs
+        * in the guest.
+        */
+       if (cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask) {
+               if (x86_pmu.flags & PMU_FL_PEBS_ALL)
+                       arr[0].guest &= ~cpuc->pebs_enabled;
+               else
+                       arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
+       }
        *nr = 1;

-       if (x86_pmu.pebs && x86_pmu.pebs_no_isolation) {
-               /*
-                * If PMU counter has PEBS enabled it is not enough to
-                * disable counter on a guest entry since PEBS memory
-                * write can overshoot guest entry and corrupt guest
-                * memory. Disabling PEBS solves the problem.
-                *
-                * Don't do this if the CPU already enforces it.
-                */
+       if (x86_pmu.pebs) {
                arr[1].msr = MSR_IA32_PEBS_ENABLE;
-               arr[1].host = cpuc->pebs_enabled;
-               arr[1].guest = 0;
+               arr[1].host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask;
+
+               /*
+                * Host and guest PEBS are mutually exclusive.  Load the guest
+                * value iff PEBS is disabled in the host.  If PEBS is enabled
+                * in the host and the CPU supports PEBS isolation, disabling
+                * the counters is sufficient (see above); skip the MSR loads
+                * by stuffing guest=host (KVM will remove the entry).  Without
+                * isolation, PEBS must be explicitly disabled prior to
+                * VM-Enter to prevent PEBS writes from overshooting VM-Enter.
+                */
+               if (!arr[1].host)
+                       arr[1].guest = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
+               else if (x86_pmu.pebs_no_isolation)
+                       arr[1].guest = 0;
+               else
+                       arr[1].guest = arr[1].host;
                *nr = 2;
        }
