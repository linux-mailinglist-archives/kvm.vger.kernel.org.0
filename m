Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AFA37B55B
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 07:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhELFRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 01:17:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:45309 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229580AbhELFRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 01:17:24 -0400
IronPort-SDR: y+coDPJ48ShC7ojQHe5xmi8/uAIEdfYqp8uIri11BRKgqSa6RXaGl7WyvKu/lu5jQv5wqy0gCI
 EDhoKRHaVcnA==
X-IronPort-AV: E=McAfee;i="6200,9189,9981"; a="199669477"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="199669477"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2021 22:16:16 -0700
IronPort-SDR: YleV+Nw6O3LvC1QvlvOsQSPuPEls/NC9HzTbJV3KjN6qs/pclckvippAAwo/tbT3/Ooc90UBZh
 gFIQJ0Pn+1+w==
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="437019326"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2021 22:16:11 -0700
Subject: Re: [PATCH v6 08/16] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to
 support guest DS
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-9-like.xu@linux.intel.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <329b4cc8-d42c-d2f0-7f25-e28c5049397a@intel.com>
Date:   Wed, 12 May 2021 13:16:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210511024214.280733-9-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/11 10:42, Like Xu wrote:
> @@ -3908,7 +3911,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>   		.guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
>   	};
>   
> -	if (!x86_pmu.pebs)
> +	if (!pmu || !x86_pmu.pebs_vmx)
>   		return arr;
>   
>   	/*
> @@ -3931,6 +3934,12 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>   	if (!x86_pmu.pebs_vmx)
>   		return arr;
>   
> +	arr[(*nr)++] = (struct perf_guest_switch_msr){
> +		.msr = MSR_IA32_DS_AREA,
> +		.host = (unsigned long)ds,
> +		.guest = pmu->ds_area,
> +	};
> +
>   	arr[*nr] = (struct perf_guest_switch_msr){
>   		.msr = MSR_IA32_PEBS_ENABLE,
>   		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,

Sorry, this part should be:

@@ -3928,9 +3931,15 @@ static struct perf_guest_switch_msr 
*intel_guest_get_msrs(int *nr, void *data)
                 return arr;
         }

-       if (!x86_pmu.pebs_vmx)
+       if (!pmu || !x86_pmu.pebs_vmx)
                 return arr;

+       arr[(*nr)++] = (struct perf_guest_switch_msr){
+               .msr = MSR_IA32_DS_AREA,
+               .host = (unsigned long)ds,
+               .guest = pmu->ds_area,
+       };
+
         arr[*nr] = (struct perf_guest_switch_msr){
                 .msr = MSR_IA32_PEBS_ENABLE,
                 .host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,

