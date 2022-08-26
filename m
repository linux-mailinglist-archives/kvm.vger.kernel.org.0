Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0E35A20E3
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 08:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245002AbiHZGcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 02:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiHZGcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 02:32:17 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C89CEB26;
        Thu, 25 Aug 2022 23:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661495537; x=1693031537;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ITboVH73O8yQJPDsSk/g1d+cvwKUeF9FmO7f/tWeck8=;
  b=lCnBVO9qrQRnwN1+8jBiD5Vtn+7YfKLyUnFy620f3ONoKHe/QajbhbAX
   2XDspsVntvDNQD5ktN/ibfFCVpbY/zS558tBF4l6LEg4Ow5oZ8rNHdAdN
   78P2ZFGqJjvTYp7I1qEoL9D1GhK+x3PFmNYrxB7GNd/RjM23HbaQjPw3T
   hzksyaLkdjXe5SCqXKuHEckyDPiXayOH/fapi7ienwmMbFqbrRyaZcR6n
   5MP2aCwS347ZCH+Bc+yl28XOkOSt2vp0hpN3USS4+azB6elX0aflVWTKn
   pfsIn3uaPYqs7E48yyc078vV/sBGe0Rwj+qZC75t7kwhuQ9bEI1AesYNp
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="292017237"
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="292017237"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 23:32:16 -0700
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="671339011"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.29.246]) ([10.255.29.246])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 23:32:13 -0700
Message-ID: <4e383b85-6777-4452-a073-4d2f439e28b1@intel.com>
Date:   Fri, 26 Aug 2022 14:32:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [RFC PATCH 2/2] KVM: VMX: Stop/resume host PT before/after VM
 entry when PT_MODE_HOST_GUEST
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <20220825085625.867763-3-xiaoyao.li@intel.com> <YweWmF3wMPRnthIh@google.com>
 <6bcab33b-3fde-d470-88b9-7667c7dc4b2d@intel.com>
 <YwecducnM/U6tqJT@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <YwecducnM/U6tqJT@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/2022 11:59 PM, Sean Christopherson wrote:
> On Thu, Aug 25, 2022, Xiaoyao Li wrote:
>> On 8/25/2022 11:34 PM, Sean Christopherson wrote:
>>> On Thu, Aug 25, 2022, Xiaoyao Li wrote:
>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>> index d7f8331d6f7e..3e9ce8f600d2 100644
>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>> @@ -38,6 +38,7 @@
>>>>    #include <asm/fpu/api.h>
>>>>    #include <asm/fpu/xstate.h>
>>>>    #include <asm/idtentry.h>
>>>> +#include <asm/intel_pt.h>
>>>>    #include <asm/io.h>
>>>>    #include <asm/irq_remapping.h>
>>>>    #include <asm/kexec.h>
>>>> @@ -1128,13 +1129,19 @@ static void pt_guest_enter(struct vcpu_vmx *vmx)
>>>>    	if (vmx_pt_mode_is_system())
>>>>    		return;
>>>> +	/*
>>>> +	 * Stop Intel PT on host to avoid vm-entry failure since
>>>> +	 * VM_ENTRY_LOAD_IA32_RTIT_CTL is set
>>>> +	 */
>>>> +	intel_pt_stop();
>>>> +
>>>>    	/*
>>>>    	 * GUEST_IA32_RTIT_CTL is already set in the VMCS.
>>>>    	 * Save host state before VM entry.
>>>>    	 */
>>>>    	rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
>>>
>>> KVM's manual save/restore of MSR_IA32_RTIT_CTL should be dropped.
>>
>> No. It cannot. Please see below.
>>
>>> If PT/RTIT can
>>> trace post-VMXON, then intel_pt_stop() will disable tracing and intel_pt_resume()
>>> will restore the host's desired value.
>>
>> intel_pt_stop() and intel_pt_resume() touches host's RTIT_CTL only when host
>> enables/uses Intel PT. Otherwise, they're just noop. In this case, we cannot
>> assume host's RTIT_CTL is zero (only the RTIT_CTL.TraceEn is 0). After
>> VM-exit, RTIT_CTL is cleared, we need to restore it.
> 
> But ensuring the RTIT_CTL.TraceEn=0 is all that's needed to make VM-Entry happy,
> and if the host isn't using Intel PT, what do we care if other bits that, for all
> intents and purposes are ignored, are lost across VM-Entry/VM-Exit?  I gotta
> imaging the perf will fully initialize RTIT_CTL if it starts using PT.

Personally, I agree with it.

But I'm not sure if there is a criteria that host context needs to be 
unchanged after being virtualized.

> Actually, if the host isn't actively using Intel PT, can KVM avoid saving the
> other RTIT MSRs?

I don't think it's a good idea that it requires PT driver never and 
won't rely on the previous value of PT MSRs. But it's OK if handing it 
over to perf as the idea you gave below.

> Even better, can we hand that off to perf?  I really dislike KVM making assumptions
> about perf's internal behavior.  E.g. can this be made to look like

you mean let perf subsystem to do the context save/restore staff of host 
and KVM focuses on save/restore of guest context, right?

I would like to see comment from perf folks on this and maybe need their 
help on how to implement.

> 	intel_pt_guest_enter(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN);
> 
> and
> 
> 	intel_pt_guest_exit(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN);
> 
