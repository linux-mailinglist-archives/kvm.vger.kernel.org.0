Return-Path: <kvm+bounces-21078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94E92929BFA
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 08:12:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48F531F210F5
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 06:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE3F213AF9;
	Mon,  8 Jul 2024 06:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iGBLTY++"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24CE125B2;
	Mon,  8 Jul 2024 06:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720419113; cv=none; b=RTlPQK9duRFd/rUWwFzFyDHmtVyiGJQH/RMSjEIEby+QI1uG+++pNQgQSBfsno1VEOtLo1z898Nam/wjw7gfyfNdfOmX0lTPJz5o3H+bMChMY9EHZoNkm4ZFFHeLQFp+jEhyFgRLNnq9LCz78psVOwMlJtNWR6sYpeQaiVUzt2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720419113; c=relaxed/simple;
	bh=X2KVL6YQOgnPBKLUq269h6w9whJt0F4SHH/PlyLx5Fg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dRUlmN8pti+JkobghpAOkG5QqpDuGnmABZAtFCv5v8U+hj5bJ/KYHgpt6looQ+bTb7Ax+k3vA3hRp/zORfsJ3Bs2nORIbThZ3hT/vDg3K5gi/kMWRyXlm0Umr4q/Vuo304mm7BU4AyxBeMwAYimHjB2OGktjcNpDilRUxKK7YXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iGBLTY++; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720419111; x=1751955111;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=X2KVL6YQOgnPBKLUq269h6w9whJt0F4SHH/PlyLx5Fg=;
  b=iGBLTY++ehT/fvpzWr/tbHnNzOQxbQumH2ARSWqP1G5o4MmmVar19Hb4
   fCB16FmW64ibYhhBlkWlRPqgAPXEG81bqLBw2AqXhdvNQqNIGxw8ZqNkq
   DEJ3uQDLsDFMckPcx8PGd04a7ZeesuMe50d1sCzh4ZJSxHbXxCLo3/rSm
   oVZcSoqdSwxRUjFtg+ApwXMMFh/eMl0fM/EhKd0N4SwUtu0aQ5/wbEj1C
   917J8ftKVrDOjwcrm6vj3qJLPls4mL5DAS1J1soHoUicVW2papNhSeWyQ
   9mJEkuMp0/HZ5xVPFlxfTDAvu2gTlvFGOVJSP+NNVxko/ucGV6ZipfdPD
   A==;
X-CSE-ConnectionGUID: 5T0c9RmAQMSTBqlehaqNcA==
X-CSE-MsgGUID: 4jEdGuQGSPmg5jostYk/DQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11126"; a="28994616"
X-IronPort-AV: E=Sophos;i="6.09,191,1716274800"; 
   d="scan'208";a="28994616"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2024 23:11:50 -0700
X-CSE-ConnectionGUID: Xrm0uJ7vSSGiyufFvIQFKw==
X-CSE-MsgGUID: uFMFVtEyQpSwkRwIEEIq9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,191,1716274800"; 
   d="scan'208";a="78143283"
Received: from chungegx-mobl1.ccr.corp.intel.com (HELO [10.238.1.52]) ([10.238.1.52])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2024 23:11:46 -0700
Message-ID: <ba11a01a-c299-43a0-bef1-0e71497946aa@linux.intel.com>
Date: Mon, 8 Jul 2024 14:11:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 085/130] KVM: TDX: Complete interrupts after tdexit
To: Yuan Yao <yuan.yao@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
 erdemaktas@google.com, Sagi Shahar <sagis@google.com>,
 Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, hang.yuan@intel.com,
 tina.zhang@intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>, avi@redhat.com,
 dzickus@redhat.com, Chao Gao <chao.gao@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <aa6a927214a5d29d5591a0079f4374b05a82a03f.1708933498.git.isaku.yamahata@intel.com>
 <20240617080729.j5nottky5bjmgdmf@yy-desk-7060>
 <c1426d14-3c00-4956-89a3-c06336905330@linux.intel.com>
 <20240618032834.a6tuv353vk6vqybw@yy-desk-7060>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240618032834.a6tuv353vk6vqybw@yy-desk-7060>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/18/2024 11:28 AM, Yuan Yao wrote:
> On Mon, Jun 17, 2024 at 05:07:56PM +0800, Binbin Wu wrote:
>>
>> On 6/17/2024 4:07 PM, Yuan Yao wrote:
>>> On Mon, Feb 26, 2024 at 12:26:27AM -0800, isaku.yamahata@intel.com wrote:
>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>
>>>> This corresponds to VMX __vmx_complete_interrupts().  Because TDX
>>>> virtualize vAPIC, KVM only needs to care NMI injection.
>>>>
>>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>>>> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
>>>> ---
>>>> v19:
>>>> - move tdvps_management_check() to this patch
>>>> - typo: complete -> Complete in short log
>>>> ---
>>>>    arch/x86/kvm/vmx/tdx.c | 10 ++++++++++
>>>>    arch/x86/kvm/vmx/tdx.h |  4 ++++
>>>>    2 files changed, 14 insertions(+)
>>>>
>>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>>> index 83dcaf5b6fbd..b8b168f74dfe 100644
>>>> --- a/arch/x86/kvm/vmx/tdx.c
>>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>>> @@ -535,6 +535,14 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>>>    	 */
>>>>    }
>>>>
>>>> +static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	/* Avoid costly SEAMCALL if no nmi was injected */
>>>> +	if (vcpu->arch.nmi_injected)
>>>> +		vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
>>>> +							      TD_VCPU_PEND_NMI);
>>>> +}
>>> Looks this leads to NMI injection delay or even won't be
>>> reinjected if KVM_REQ_EVENT is not set on the target cpu
>>> when more than 1 NMIs are pending there.
>>>
>>> On normal VM, KVM uses NMI window vmexit for injection
>>> successful case to rasie the KVM_REQ_EVENT again for remain
>>> pending NMIs, see handle_nmi_window(). KVM also checks
>>> vectoring info after VMEXIT for case that the NMI is not
>>> injected successfully in this vmentry vmexit round, and
>>> raise KVM_REQ_EVENT to try again, see __vmx_complete_interrupts().
>>>
>>> In TDX, consider there's no way to get vectoring info or
>>> handle nmi window vmexit, below checking should cover both
>>> scenarios for NMI injection:
>>>
>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>> index e9c9a185bb7b..9edf446acd3b 100644
>>> --- a/arch/x86/kvm/vmx/tdx.c
>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>> @@ -835,9 +835,12 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>>    static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
>>>    {
>>>           /* Avoid costly SEAMCALL if no nmi was injected */
>>> -       if (vcpu->arch.nmi_injected)
>>> +       if (vcpu->arch.nmi_injected) {
>>>                   vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
>>>                                                                 TD_VCPU_PEND_NMI);
>>> +               if (vcpu->arch.nmi_injected || vcpu->arch.nmi_pending)
>>> +                       kvm_make_request(KVM_REQ_EVENT, vcpu);
>> For nmi_injected, it should be OK because TD_VCPU_PEND_NMI is still set.
>> But for nmi_pending, it should be checked and raise event.
> Right, I just forgot the tdx module can do more than "hardware":
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index e9c9a185bb7b..3530a4882efc 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -835,9 +835,16 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
>   {
>          /* Avoid costly SEAMCALL if no nmi was injected */
> -       if (vcpu->arch.nmi_injected)
> +       if (vcpu->arch.nmi_injected) {
>                  vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
>                                                                TD_VCPU_PEND_NMI);
> +               /*
> +                  tdx module will retry injection in case of TD_VCPU_PEND_NMI,
> +                  so don't need to set KVM_REQ_EVENT for it again.
> +                */
> +               if (!vcpu->arch.nmi_injected && vcpu->arch.nmi_pending)
> +                       kvm_make_request(KVM_REQ_EVENT, vcpu);
> +       }
>   }
>
>> I remember there was a discussion in the following link:
>> https://lore.kernel.org/kvm/20240402065254.GY2444378@ls.amr.corp.intel.com/
>> It said  tdx_vcpu_run() will ignore force_immediate_exit.
>> If force_immediate_exit is igored for TDX, then the nmi_pending handling
>> could still be delayed if the previous NMI was injected successfully.
> Yes, not sure the possibility of meeting this in real use
> case, I know it happens in some testing, e.g. the kvm
> unit test's multiple NMI tesing.

Delay the pending NMI to the next VM exit will have problem.
Current Linux kernel code on NMI handling, it will check back-to-back 
NMI when handling unknown NMI.
Here are the comments in arch/x86/kernel/nmi.c
         /*
          * Only one NMI can be latched at a time.  To handle
          * this we may process multiple nmi handlers at once to
          * cover the case where an NMI is dropped.  The downside
          * to this approach is we may process an NMI prematurely,
          * while its real NMI is sitting latched.  This will cause
          * an unknown NMI on the next run of the NMI processing.
          *
          * We tried to flag that condition above, by setting the
          * swallow_nmi flag when we process more than one event.
          * This condition is also only present on the second half
          * of a back-to-back NMI, so we flag that condition too.
          *
          * If both are true, we assume we already processed this
          * NMI previously and we swallow it. ...
          */
Assume there are two NMIs pending in KVM, i.e. nmi_pending is 2.
KVM injects one NMI by settting TD_VCPU_PEND_NMI field and the 
nmi_pending is decreased to 1.
The pending NMI will be delayed until the next VM Exit, it will not be 
detected as the second half of back-to-back NMI in guest.
Then it will be considered as a real unknown NMI, and if no one handles 
it (because it could have been handled in the previous NMI handler).
At last, guest kernel will fire error message for the "unhandled" 
unknown NMI, and even panic if unknown_nmi_panic or 
panic_on_unrecovered_nmi is set true.


Since KVM doesn't have the capability to get NMI blocking status or 
request NMI-window exit for TDX, how about limiting the nmi pending to 1 
for TDX?
I.e. if TD_VCPU_PEND_NMI is not set, limit nmi_pending to 1 in 
process_nmi();
      if TD_VCPU_PEND_NMI is set, limit nmi_pending to 0 in process_nmi().

Had some checks about the history when nmi_pending limit changed to 2.
The discussion in the 
link https://lore.kernel.org/all/4E723A8A.7050405@redhat.com/ said:
" ... the NMI handlers are now being reworked to handle
just one NMI source (hopefully the cheapest) in the handler, and if we
detect a back-to-back NMI, handle all possible NMI sources."
IIUC, the change in NMI handlers described above is referring to the 
patch set "x86, nmi: new NMI handling routines"
https://lore.kernel.org/all/1317409584-23662-1-git-send-email-dzickus@redhat.com/

I noticed that in v6 of the patch series, there was an optimization, but 
removed in v7.
v6 link: 
https://lore.kernel.org/all/1316805435-14832-5-git-send-email-dzickus@redhat.com/
v7 link: 
https://lore.kernel.org/all/1317409584-23662-5-git-send-email-dzickus@redhat.com/
The Optimization code in v6, but removed in v7:
           -static int notrace __kprobes nmi_handle(unsigned int type, 
struct pt_regs *regs)
           +static int notrace __kprobes nmi_handle(unsigned int type, 
struct pt_regs *regs, bool b2b)
           {
                struct nmi_desc *desc = nmi_to_desc(type);
                struct nmiaction *a;
           @@ -89,6 +89,15 @@ static int notrace __kprobes 
nmi_handle(unsigned int type, struct pt_regs *regs)

                handled += a->handler(type, regs);

           +        /*
           +          * Optimization: only loop once if this is not a
           +          * back-to-back NMI.  The idea is nothing is dropped
           +          * on the first NMI, only on the second of a 
back-to-back
           +          * NMI.  No need to waste cycles going through all the
           +          * handlers.
           +          */
           +        if (!b2b && handled)
           +            break;
                }

At last, back-to-back NMI optimization is not used in Linux kernel.
So the kernel is able to handle NMI sources if we drop later NMIs when 
there is already one virtual NMI pending for TDX.



