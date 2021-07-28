Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38C13D924F
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 17:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbhG1Prh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 11:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhG1Prc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 11:47:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F07C061757;
        Wed, 28 Jul 2021 08:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dWH66FbuISrHAWbtQ6UDd+p/YsYudn82c1xwjXqOHGo=; b=oxOuPgQSAEqIQ9vJpZYBFdw7At
        oe7WAs2BgV2OkxQPPcE4LtmJndG0ocMYUoN5+6Tg65fN5eM6UAqQKjRSRaKHA5uNaUeqy7fdb82HX
        eCfsEcHGxQrOEUIz/9u6hQmqrjvsbTETGnIuxa4N8IWthBLNf7UtoYrn+5EKVgka6CJesmEd+7J+X
        fdCT7tTDfzGJfXvHJZJoWlFjNtZenvLXr6VdQ6r/c0efMW+CJyv8OyTjddynr3oPQpnt+P42H1I5d
        hC4CzTivsa0QeOgESzpY9pcH9VhUrTiQo9Yo51By1GM6aKGmKhZseQe0GyW0SGOMsLrHabnrw/is5
        0Ela9u9Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m8lkP-00GDLp-Fu; Wed, 28 Jul 2021 15:45:35 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9F74230022A;
        Wed, 28 Jul 2021 17:45:27 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8B4472CD20653; Wed, 28 Jul 2021 17:45:27 +0200 (CEST)
Date:   Wed, 28 Jul 2021 17:45:27 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     pbonzini@redhat.com, bp@alien8.de, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, boris.ostrvsky@oracle.com
Subject: Re: [PATCH V9 00/18] KVM: x86/pmu: Add *basic* support to enable
 guest PEBS via DS
Message-ID: <YQF7lwM6qzYso0Gg@hirez.programming.kicks-ass.net>
References: <20210722054159.4459-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722054159.4459-1-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 22, 2021 at 01:41:41PM +0800, Zhu Lingshan wrote:
> The guest Precise Event Based Sampling (PEBS) feature can provide an
> architectural state of the instruction executed after the guest instruction
> that exactly caused the event. It needs new hardware facility only available
> on Intel Ice Lake Server platforms. This patch set enables the basic PEBS
> feature for KVM guests on ICX.
> 
> We can use PEBS feature on the Linux guest like native:
> 
>    # echo 0 > /proc/sys/kernel/watchdog (on the host)
>    # perf record -e instructions:ppp ./br_instr a
>    # perf record -c 100000 -e instructions:pp ./br_instr a

Why does the host need to disable the watchdog? IIRC ICL has multiple
PEBS capable counters. Also, I think the watchdog ends up on a fixed
counter by default anyway.

> Like Xu (17):
>   perf/core: Use static_call to optimize perf_guest_info_callbacks
>   perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
>   perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
>   perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
>   KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
>   KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
>   KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
>   KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
>   KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
>   KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS
>   KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
>   KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
>   KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
>   KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations
>   KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
>   KVM: x86/cpuid: Refactor host/guest CPU model consistency check
>   KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
> 
> Peter Zijlstra (Intel) (1):
>   x86/perf/core: Add pebs_capable to store valid PEBS_COUNTER_MASK value

Looks good:

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

How do we want to route this, all through the KVM tree?

One little nit I had; would something like the below (on top perhaps)
make the code easier to read?

---
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3921,9 +3921,12 @@ static struct perf_guest_switch_msr *int
 	struct kvm_pmu *kvm_pmu = (struct kvm_pmu *)data;
 	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
 	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
+	int global_ctrl, pebs_enable;
 
 	*nr = 0;
-	arr[(*nr)++] = (struct perf_guest_switch_msr){
+
+	global_ctrl = (*nr)++;
+	arr[global_ctrl] = (struct perf_guest_switch_msr){
 		.msr = MSR_CORE_PERF_GLOBAL_CTRL,
 		.host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
 		.guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
@@ -3966,23 +3969,23 @@ static struct perf_guest_switch_msr *int
 		};
 	}
 
-	arr[*nr] = (struct perf_guest_switch_msr){
+	pebs_enable = (*nr)++;
+	arr[pebs_enable] = (struct perf_guest_switch_msr){
 		.msr = MSR_IA32_PEBS_ENABLE,
 		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
 		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
 	};
 
-	if (arr[*nr].host) {
+	if (arr[pebs_enable].host) {
 		/* Disable guest PEBS if host PEBS is enabled. */
-		arr[*nr].guest = 0;
+		arr[pebs_enable].guest = 0;
 	} else {
 		/* Disable guest PEBS for cross-mapped PEBS counters. */
-		arr[*nr].guest &= ~kvm_pmu->host_cross_mapped_mask;
+		arr[pebs_enable].guest &= ~kvm_pmu->host_cross_mapped_mask;
 		/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
-		arr[0].guest |= arr[*nr].guest;
+		arr[global_ctrl].guest |= arr[pebs_enable].guest;
 	}
 
-	++(*nr);
 	return arr;
 }
 



