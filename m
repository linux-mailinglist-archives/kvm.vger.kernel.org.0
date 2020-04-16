Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48F81AC15D
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 14:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635681AbgDPMfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 08:35:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:34880 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2635766AbgDPMem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 08:34:42 -0400
IronPort-SDR: dgo+hgPQiIBqmVV9ZUxj7p4eOO7ukGZgqJhMrjJ4jmTlpCmxUKpXG9bg47ztEISI0l217Y22Cv
 JK1G2KHfkdvg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 05:34:40 -0700
IronPort-SDR: mFMcIBAK/jT8VE4Yu6XUa8DtoLEzKdkryg/C8If+LIQCBaB6uxJDC5ravQzMkMVHgWV/39sZRk
 011MvqydcMTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,390,1580803200"; 
   d="scan'208";a="272054775"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.29.241]) ([10.255.29.241])
  by orsmga002.jf.intel.com with ESMTP; 16 Apr 2020 05:34:37 -0700
Subject: Re: [PATCH v8 4/4] kvm: vmx: virtualize split lock detection
To:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>
References: <20200414063129.133630-5-xiaoyao.li@intel.com>
 <871rooodad.fsf@nanos.tec.linutronix.de>
 <20200415191802.GE30627@linux.intel.com>
 <87tv1kmol8.fsf@nanos.tec.linutronix.de>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <a6e9867c-15f0-96be-04fa-456cbe826ffb@intel.com>
Date:   Thu, 16 Apr 2020 20:34:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87tv1kmol8.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/16/2020 5:22 AM, Thomas Gleixner wrote:
> Sean,
> 
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> On Wed, Apr 15, 2020 at 07:43:22PM +0200, Thomas Gleixner wrote:
>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>> +static inline void vmx_update_sld(struct kvm_vcpu *vcpu, bool on)
>>>> +{
>>>> +	/*
>>>> +	 * Toggle SLD if the guest wants it enabled but its been disabled for
>>>> +	 * the userspace VMM, and vice versa.  Note, TIF_SLD is true if SLD has
>>>> +	 * been turned off.  Yes, it's a terrible name.
>>>
>>> Instead of writing that useless blurb you could have written a patch
>>> which changes TIF_SLD to TIF_SLD_OFF to make it clear.
>>
>> Hah, that's my comment, though I must admit I didn't fully intend for the
>> editorial at the end to get submitted upstream.
>>
>> Anyways, I _did_ point out that TIF_SLD is a terrible name[1][2], and my
>> feedback got ignored/overlooked.  I'd be more than happy to write a
>> patch, I didn't do so because I assumed that people wanted TIF_SLD as the name for
>> whatever reason.
> 
> I somehow missed that in the maze of mails regarding this stuff. I've
> already written a patch to rename it to TIF_SLD_DISABLED which is pretty
> self explaining. But see below.
> 
[...]
> 
>>>> @@ -1188,6 +1217,10 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>>>>   #endif
>>>>
>>>> 	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
>>>> +
>>>> +	vmx->host_sld_on = !test_thread_flag(TIF_SLD);
>>>
>>> This inverted storage is non-intuitive. What's wrong with simply
>>> reflecting the TIF_SLD state?
>>
>> So that the guest/host tracking use the same polairy, and IMO it makes
>> the restoration code more intuitive, e.g.:
>>
>> 	vmx_update_sld(&vmx->vcpu, vmx->host_sld_on);
>> vs
>> 	vmx_update_sld(&vmx->vcpu, !vmx->host_tif_sld);
>>
>> I.e. the inversion needs to happen somewhere.
> 
> Correct, but we can make it consistently use the 'disabled' convention.
> 
> I briefly thought about renaming the flag to TIF_SLD_ENABLED, set it by
> default and update the 5 places where it is used. But that's
> inconsistent as well simply because it does not make any sense to set
> that flag when detection is not available or disabled on the command
> line.
> 

Assuming you'll pick TIF_SLD_DISABLED, I guess we need to set this flag 
by default for the case SLD is no available or disabled on the command, 
for consistency?

