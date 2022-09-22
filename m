Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6127C5E6272
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 14:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiIVMeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 08:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiIVMeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 08:34:00 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359A9E7200;
        Thu, 22 Sep 2022 05:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663850040; x=1695386040;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=fEa2ip9mQtyr7F7USzyCepof/02V3lHZ1gK1tJOlWjM=;
  b=ZB5aXgSlK9l8UeUuYfk0M9x+il1Q87bzzYbhj5FwbrBs75QXnUMhD/G9
   pqaNCmXHldTMFpkSAM3c3rclKutDOSO1c40h2eOWqD8SbAFFCnptnG+IO
   yR8jFaNcRgP+asiamI7LQeQbt5J0M6SO84B6cxIHVLaal8GLvVnDRYpGx
   mSqicu0e4lW+Uvzrt9pxhXsI53bBhFD+XU//eRTS6QBwhHa0in9V10zNa
   mDEaUqRniAfrU0sV5XoGd+2Bm3WyLjBg/IYWjy4zy3vkYqI/eMDHCVTVT
   jIffsek0k37inXkdTAD09+cYjKeLPsjt1OaP8gHSZyadLc56GL7VKL4JR
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="301692684"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="301692684"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 05:33:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="622077186"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga007.fm.intel.com with ESMTP; 22 Sep 2022 05:33:58 -0700
Received: from [10.252.210.171] (kliang2-mobl1.ccr.corp.intel.com [10.252.210.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 909515802E4;
        Thu, 22 Sep 2022 05:33:56 -0700 (PDT)
Message-ID: <175b518c-d202-644e-a3a7-67e877852548@linux.intel.com>
Date:   Thu, 22 Sep 2022 08:33:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, wei.w.wang@intel.com
Cc:     linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220921164521.2858932-1-xiaoyao.li@intel.com>
 <20220921164521.2858932-3-xiaoyao.li@intel.com>
Content-Language: en-US
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Subject: Re: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export
 pt_get_curr_event()
In-Reply-To: <20220921164521.2858932-3-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022-09-21 12:45 p.m., Xiaoyao Li wrote:
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
> to get current pt event. 

I don't think the current pt event is created by KVM. IIUC, the patch
basically expose the event created by the other user to KVM. That
doesn't sounds correct.

I think it should be perf's responsibility to decide which events should
be disabled, and which MSRs should be switched. Because only perf can
see all the events. The users should only see the events they created.

Thanks,
Kan

> Along with perf_event_{dis, en}able_local(),
> With them, KVM can avoid PT re-enabling in PT PMI handler.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/events/intel/pt.c        | 8 ++++++++
>  arch/x86/include/asm/perf_event.h | 2 ++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
> index 82ef87e9a897..62bfc45c11c9 100644
> --- a/arch/x86/events/intel/pt.c
> +++ b/arch/x86/events/intel/pt.c
> @@ -1624,6 +1624,14 @@ static void pt_event_stop(struct perf_event *event, int mode)
>  	}
>  }
>  
> +struct perf_event *pt_get_curr_event(void)
> +{
> +	struct pt *pt = this_cpu_ptr(&pt_ctx);
> +
> +	return pt->handle.event;
> +}
> +EXPORT_SYMBOL_GPL(pt_get_curr_event);
> +
>  static long pt_event_snapshot_aux(struct perf_event *event,
>  				  struct perf_output_handle *handle,
>  				  unsigned long size)
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index f6fc8dd51ef4..7c3533392cf5 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -553,11 +553,13 @@ static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
>  
>  #ifdef CONFIG_CPU_SUP_INTEL
>   extern void intel_pt_handle_vmx(int on);
> + extern struct perf_event *pt_get_curr_event(void);
>  #else
>  static inline void intel_pt_handle_vmx(int on)
>  {
>  
>  }
> +struct perf_event *pt_get_curr_event(void) { return NULL; }
>  #endif
>  
>  #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
