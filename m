Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF3B3BA018
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 13:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbhGBLzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 07:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbhGBLzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 07:55:37 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EDAC061762;
        Fri,  2 Jul 2021 04:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/sLwb7Cxkc1PFTyYiL5GsOTR4TUt3nINwnHPE+BGuo0=; b=YpMOOV00UxinpjzrmMGOLPVn52
        zW5a8SeV7X5BWstNgbMvDWMtF9TEc0vpSx2VJQyUJ+py5LIKjpGQcB+SOivcTZ6xr+P4J551yDbho
        lrWof83QJfDmOF7RQr87jRGwcrcoiYWVeeOcyIaIwfHvyR8RQ6vCug822lktaN6Evkyg7t8S+V3+H
        DP/aeNxHOt9YbEHhW47TqRZ/u1Ej6U7pMxPl3jYTdA8KMtCibWFsfh5xe6AUAAdUGSq97zH4BSzQq
        xCh1Ihc36Ba6gM084VJFvIIcQHsOtPToKQsLvMk7gDeIZgx0Dv3EvYQbgsRuDsuG8wPUGV7JeqTyw
        RBrha1aA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzHic-00Dqhi-J4; Fri, 02 Jul 2021 11:52:41 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 00AC83001DC;
        Fri,  2 Jul 2021 13:52:22 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DDFB62CEACAE1; Fri,  2 Jul 2021 13:52:21 +0200 (CEST)
Date:   Fri, 2 Jul 2021 13:52:21 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     pbonzini@redhat.com, bp@alien8.de, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, weijiang.yang@intel.com,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH V7 11/18] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to
 support guest DS
Message-ID: <YN799S5hwWqsbY/h@hirez.programming.kicks-ass.net>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <20210622094306.8336-12-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622094306.8336-12-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 22, 2021 at 05:42:59PM +0800, Zhu Lingshan wrote:
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 190d8d98abf0..b336bcaad626 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -21,6 +21,7 @@
>  #include <asm/intel_pt.h>
>  #include <asm/apic.h>
>  #include <asm/cpu_device_id.h>
> +#include <asm/kvm_host.h>
>  
>  #include "../perf_event.h"
>  
> @@ -3915,6 +3916,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>  {
>  	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>  	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
> +	struct kvm_pmu *pmu = (struct kvm_pmu *)data;
>  	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
>  	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
>  
> @@ -3945,9 +3947,15 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>  		return arr;
>  	}
>  
> -	if (!x86_pmu.pebs_vmx)
> +	if (!pmu || !x86_pmu.pebs_vmx)
>  		return arr;
>  
> +	arr[(*nr)++] = (struct perf_guest_switch_msr){
> +		.msr = MSR_IA32_DS_AREA,
> +		.host = (unsigned long)cpuc->ds,
> +		.guest = pmu->ds_area,
> +	};
> +
>  	arr[*nr] = (struct perf_guest_switch_msr){
>  		.msr = MSR_IA32_PEBS_ENABLE,
>  		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,

s/pmu/kvm_pmu/ or something. pmu is normally a struct pmu *, and having
it be kvm_pmu here is super confusing.
