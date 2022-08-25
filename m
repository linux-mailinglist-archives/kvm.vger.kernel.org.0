Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178045A1602
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 17:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242241AbiHYPpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 11:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235132AbiHYPpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 11:45:33 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5439896FC4;
        Thu, 25 Aug 2022 08:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661442332; x=1692978332;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=e8jmfFS/99sfQ/rSZ/S76vILeeQlsqVlmU0vRDuE9N8=;
  b=fRsVMtYXFYQdYFXWWgEu3IKsO/YVBnzSfNKSn62advFFq7zh546WVQTo
   kzqaC3lTbuRYP2+6/+jBhrgEtsfVQJ6eM+S1HPNDVtvOKhgM/f6THpgW+
   tuRdrJxyF5v9hrfm+KIDvbrpirtvU2jbz9RhwfQF//9e3/HXmAGyRGpi/
   GuCdan9uimZBf90TB2FV0fhA3ktt+dm1DrotGFlBZXtufQC1dtBDjc8nf
   GfawSV3yU422rWuPwVaJqnYHhn3sndPfDoKShfskq4xxKxLIHO3RP/XjD
   fXFIgPkwDRRdpt3lQPv1MTYq/Wn3mDIZWXJTmyumRpbBqSRTX9zGOxfYr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="295054189"
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="295054189"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 08:45:31 -0700
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="671041464"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.29.55]) ([10.255.29.55])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 08:45:29 -0700
Message-ID: <6bcab33b-3fde-d470-88b9-7667c7dc4b2d@intel.com>
Date:   Thu, 25 Aug 2022 23:45:26 +0800
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
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <YweWmF3wMPRnthIh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/2022 11:34 PM, Sean Christopherson wrote:
> On Thu, Aug 25, 2022, Xiaoyao Li wrote:
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index d7f8331d6f7e..3e9ce8f600d2 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -38,6 +38,7 @@
>>   #include <asm/fpu/api.h>
>>   #include <asm/fpu/xstate.h>
>>   #include <asm/idtentry.h>
>> +#include <asm/intel_pt.h>
>>   #include <asm/io.h>
>>   #include <asm/irq_remapping.h>
>>   #include <asm/kexec.h>
>> @@ -1128,13 +1129,19 @@ static void pt_guest_enter(struct vcpu_vmx *vmx)
>>   	if (vmx_pt_mode_is_system())
>>   		return;
>>   
>> +	/*
>> +	 * Stop Intel PT on host to avoid vm-entry failure since
>> +	 * VM_ENTRY_LOAD_IA32_RTIT_CTL is set
>> +	 */
>> +	intel_pt_stop();
>> +
>>   	/*
>>   	 * GUEST_IA32_RTIT_CTL is already set in the VMCS.
>>   	 * Save host state before VM entry.
>>   	 */
>>   	rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
> 
> KVM's manual save/restore of MSR_IA32_RTIT_CTL should be dropped.  

No. It cannot. Please see below.

> If PT/RTIT can
> trace post-VMXON, then intel_pt_stop() will disable tracing and intel_pt_resume()
> will restore the host's desired value.

intel_pt_stop() and intel_pt_resume() touches host's RTIT_CTL only when 
host enables/uses Intel PT. Otherwise, they're just noop. In this case, 
we cannot assume host's RTIT_CTL is zero (only the RTIT_CTL.TraceEn is 
0). After VM-exit, RTIT_CTL is cleared, we need to restore it.

>>   	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
>> -		wrmsrl(MSR_IA32_RTIT_CTL, 0);
>> +		/* intel_pt_stop() ensures RTIT_CTL.TraceEn is zero */
>>   		pt_save_msr(&vmx->pt_desc.host, vmx->pt_desc.num_address_ranges);
> 
> Isn't this at risk of the same corruption?  What prevents a PT NMI that arrives
> after this point from changing other RTIT MSRs, thus causing KVM to restore the
> wrong values?

intel_pt_stop() -> pt_event_stop() will do

	WRITE_ONCE(pt->handle_nmi, 0);

which ensure PT NMI handler as noop that at the beginning of 
intel_pt_interrupt():

	if (!READ_ONCE(pt->handle_nmi))
		return;

>>   		pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.num_address_ranges);
>>   	}
>> @@ -1156,6 +1163,8 @@ static void pt_guest_exit(struct vcpu_vmx *vmx)
>>   	 */
>>   	if (vmx->pt_desc.host.ctl)
>>   		wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
>> +
>> +	intel_pt_resume();
>>   }
>>   
>>   void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
>> -- 
>> 2.27.0
>>

