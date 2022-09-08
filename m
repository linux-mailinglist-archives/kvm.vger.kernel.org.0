Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5095B158E
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 09:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiIHHZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 03:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiIHHZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 03:25:48 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548F180F5F;
        Thu,  8 Sep 2022 00:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662621947; x=1694157947;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pKsF5uQWUHQU4hDEQ8RNMaO1sn4gtBd+JNvACFAQ7uA=;
  b=lPl3oNyRd6seIMERKBDUg3GXYm22MRLPq/9PHtX0GJ98bUl1mcalwBkB
   Fs+YWIkRAz+oGJV6xMHXrzo4HbAKWdR7q1/5zLC6WNEqVR2h+O50s9AlA
   l6bAXtQK907nvKeHo/VCU/Hp5X4ztO8oz8mM62QvHKfjgwz7DhgznASTV
   HQ1JE+/QX5gvg99NybN4bFhBzgIDcJu2TBg1tIcWKkK8SPnkBzpgmyOSV
   YNGlZ6BuYUnDm98YGAzVW94E3BYISbMW1LNnt/wRiXWQRV71lvgeYfwPT
   O5PEI0j4V+ppvKDyB5Lk2hFgRGfFpqOppGOLNgsGck0AtqrJUUAJJYTy0
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10463"; a="284112570"
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="scan'208";a="284112570"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 00:25:46 -0700
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="scan'208";a="644960899"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.172.13]) ([10.249.172.13])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 00:25:43 -0700
Message-ID: <3b78a0c7-de8f-fe44-ec58-bcc4e231191b@intel.com>
Date:   Thu, 8 Sep 2022 15:25:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.0
Subject: Re: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Content-Language: en-US
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/29/2022 3:49 PM, Wang, Wei W wrote:
> On Thursday, August 25, 2022 4:56 PM, Xiaoyao Li wrote:
>> There is one bug in KVM that can hit vm-entry failure 100% on platform
>> supporting PT_MODE_HOST_GUEST mode following below steps:
>>
>>    1. #modprobe -r kvm_intel
>>    2. #modprobe kvm_intel pt_mode=1
>>    3. start a VM with QEMU
>>    4. on host: #perf record -e intel_pt//
>>
>> The vm-entry failure happens because it violates the requirement stated in
>> Intel SDM 26.2.1.1 VM-Execution Control Fields
>>
>>    If the logical processor is operating with Intel PT enabled (if
>>    IA32_RTIT_CTL.TraceEn = 1) at the time of VM entry, the "load
>>    IA32_RTIT_CTL" VM-entry control must be 0.
>>
>> On PT_MODE_HOST_GUEST node, PT_MODE_HOST_GUEST is always set. Thus
>> KVM needs to ensure IA32_RTIT_CTL.TraceEn is 0 before VM-entry. Currently
>> KVM manually WRMSR(IA32_RTIT_CTL) to clear TraceEn bit. However, it
>> doesn't work everytime since there is a posibility that IA32_RTIT_CTL.TraceEn
>> is re-enabled in PT PMI handler before vm-entry. This series tries to fix the
>> issue by exposing two interfaces from Intel PT driver for the purose to stop and
>> resume Intel PT on host. It prevents PT PMI handler from re-enabling PT. By the
>> way, it also fixes another issue that PT PMI touches PT MSRs whihc leads to
>> what KVM stores for host bemomes stale.
> 
> I'm thinking about another approach to fixing it. I think we need to have the
> running host pt event disabled when we switch to guest and don't expect to
> receive the host pt interrupt at this point. Also, the host pt context can be
> save/restored by host perf core (instead of KVM) when we disable/enable
> the event.
> 
> diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
> index 82ef87e9a897..1d3e03ecaf6a 100644
> --- a/arch/x86/events/intel/pt.c
> +++ b/arch/x86/events/intel/pt.c
> @@ -1575,6 +1575,7 @@ static void pt_event_start(struct perf_event *event, int mode)
> 
>          pt_config_buffer(buf);
>          pt_config(event);
> +       pt->event = event;
> 
>          return;
> 
> @@ -1600,6 +1601,7 @@ static void pt_event_stop(struct perf_event *event, int mode)
>                  return;
> 
>          event->hw.state = PERF_HES_STOPPED;
> +       pt->event = NULL;
> 
>          if (mode & PERF_EF_UPDATE) {
>                  struct pt_buffer *buf = perf_get_aux(&pt->handle);
> @@ -1624,6 +1626,15 @@ static void pt_event_stop(struct perf_event *event, int mode)
>          }
>   }
> 
> +
> +struct perf_event *pt_get_curr_event(void)
> +{
> +       struct pt *pt = this_cpu_ptr(&pt_ctx);

Wei,

I'm not sure if we can use pt->handle.event instead or not.

> +       return pt->event;
> +}
> +EXPORT_SYMBOL_GPL(pt_get_curr_event);
> +
>   static long pt_event_snapshot_aux(struct perf_event *event,
>                                    struct perf_output_handle *handle,
>                                    unsigned long size)
> diff --git a/arch/x86/events/intel/pt.h b/arch/x86/events/intel/pt.h
> index 96906a62aacd..d46a85bb06bb 100644
> --- a/arch/x86/events/intel/pt.h
> +++ b/arch/x86/events/intel/pt.h
> @@ -121,6 +121,7 @@ struct pt_filters {
>    * @output_mask:       cached RTIT_OUTPUT_MASK MSR value
>    */
>   struct pt {
> +       struct perf_event       *event;
>          struct perf_output_handle handle;
>          struct pt_filters       filters;
>          int                     handle_nmi;
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index f6fc8dd51ef4..be8dd24922a7 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -553,11 +553,14 @@ static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
> 
>   #ifdef CONFIG_CPU_SUP_INTEL
>    extern void intel_pt_handle_vmx(int on);
> + extern struct perf_event *pt_get_curr_event(void);
>   #else
>   static inline void intel_pt_handle_vmx(int on)
>   {
> 
> +
>   }
> +struct perf_event *pt_get_curr_event(void) { }
>   #endif
> 


