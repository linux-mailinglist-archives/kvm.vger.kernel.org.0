Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D305E5A7B
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 07:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiIVFOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 01:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiIVFOi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 01:14:38 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D0A219C;
        Wed, 21 Sep 2022 22:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663823671; x=1695359671;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zC6PcP2Pk3U5wJWfNPK4xATjAh3qkoLjBspqX0UOKOg=;
  b=WE6IHJ0r6Bx1LdJctbVsu0tLW14r3xi8UZiASv33TNx925fpXGmxm9zS
   oedzmPI4Rk6rncveHh3g0Z7Yqxy5rl28XE979Q0sNdBB9pqLV4ALjKPzV
   b2tdqTOE5BkX86//kAD3Wf0wXa0GgeBDtIwpWZnc4XyungE3lIoixhlDO
   W+4JBTYP45UKNuS80Y/VUI6N0DN9wtlVXowXjWMyOqgHpwefXAqxY7Ack
   kMC6k5JF8xwnCosYwbehNSt8REfiIWM5Ee7qF7KpHYC1Xu73zd5BFk28G
   fb0IAI0ZZCA1WQiYw3LR7J49UgoVoKdOi+48D52RumADcMIP1NKasTmXA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="300184561"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="300184561"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 22:14:20 -0700
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="621954846"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.71]) ([10.255.28.71])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 22:14:17 -0700
Message-ID: <fe1f67be-86ba-3cd3-6396-ddd52a021f1e@intel.com>
Date:   Thu, 22 Sep 2022 13:14:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export
 pt_get_curr_event()
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, wei.w.wang@intel.com,
        kan.liang@linux.intel.com
Cc:     linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220921164521.2858932-1-xiaoyao.li@intel.com>
 <20220921164521.2858932-3-xiaoyao.li@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220921164521.2858932-3-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/22/2022 12:45 AM, Xiaoyao Li wrote:
> KVM supports PT_MODE_HOST_GUEST mode for Intel PT where host and guest
> have separate Intel PT configurations and they work independently.
> 
> Currently, in this mode, when both host and guest enable PT, KVM manually
> clears MSR_IA32_RTIT_CTL.TRACEEN to disable host PT so that it can
> context switch the other PT MSRs. However, PT PMI can be delivered after
> this point and before the VM-entry. As a result, the re-enabling of PT
> leads to VM-entry failure of guest.
> 
> To solve the problem, introduce and export pt_get_curr_event() for KVM
> to get current pt event. Along with perf_event_{dis, en}able_local(),
> With them, KVM can avoid PT re-enabling in PT PMI handler.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   arch/x86/events/intel/pt.c        | 8 ++++++++
>   arch/x86/include/asm/perf_event.h | 2 ++
>   2 files changed, 10 insertions(+)
> 
> diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
> index 82ef87e9a897..62bfc45c11c9 100644
> --- a/arch/x86/events/intel/pt.c
> +++ b/arch/x86/events/intel/pt.c
> @@ -1624,6 +1624,14 @@ static void pt_event_stop(struct perf_event *event, int mode)
>   	}
>   }
>   
> +struct perf_event *pt_get_curr_event(void)
> +{
> +	struct pt *pt = this_cpu_ptr(&pt_ctx);
> +
> +	return pt->handle.event;
> +}
> +EXPORT_SYMBOL_GPL(pt_get_curr_event);
> +
>   static long pt_event_snapshot_aux(struct perf_event *event,
>   				  struct perf_output_handle *handle,
>   				  unsigned long size)
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index f6fc8dd51ef4..7c3533392cf5 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -553,11 +553,13 @@ static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
>   
>   #ifdef CONFIG_CPU_SUP_INTEL
>    extern void intel_pt_handle_vmx(int on);
> + extern struct perf_event *pt_get_curr_event(void);
>   #else
>   static inline void intel_pt_handle_vmx(int on)
>   {
>   
>   }
> +struct perf_event *pt_get_curr_event(void) { return NULL; }

My fault, this needs to be

   static inline ...

>   #endif
>   
>   #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)

