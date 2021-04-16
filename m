Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C574B362651
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 19:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238600AbhDPRHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 13:07:35 -0400
Received: from linux.microsoft.com ([13.77.154.182]:53654 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235535AbhDPRHa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 13:07:30 -0400
Received: from [192.168.86.23] (c-73-38-52-84.hsd1.vt.comcast.net [73.38.52.84])
        by linux.microsoft.com (Postfix) with ESMTPSA id 56DC020B8001;
        Fri, 16 Apr 2021 10:07:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 56DC020B8001
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618592825;
        bh=aQ2nMf6p7JAo/eTml5qCXpa9nirMhLaQNfU2xL/fxvM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=erY+xcbw6X7T0sZPUTOa8e/DXH71J0xDzcbrUOQAz8CGwmHO3FcN5I0beC4rWIAph
         P/5C9I2Nr1IYiYJetLO10aTjRKsArqPfJJo3POQIidJcjTT6NTXGHg4PKdlXrOp6k8
         ZENzTJfu/JenJhLf6I1kLeDGpRpVnK9gVO5vTCz8=
Subject: Re: [PATCH v2 4/7] KVM: SVM: hyper-v: Nested enlightenments in VMCB
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, viremana@linux.microsoft.com
References: <cover.1618492553.git.viremana@linux.microsoft.com>
 <ffe0e81164e5577a43f7499e40922b6abb663430.1618492553.git.viremana@linux.microsoft.com>
 <87v98m7gi4.fsf@vitty.brq.redhat.com>
From:   Vineeth Pillai <viremana@linux.microsoft.com>
Message-ID: <4aaab6f9-7785-5c0a-4f9d-f972ec21888b@linux.microsoft.com>
Date:   Fri, 16 Apr 2021 13:07:00 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <87v98m7gi4.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/16/2021 4:58 AM, Vitaly Kuznetsov wrote:
>
>> +
>> +#if IS_ENABLED(CONFIG_HYPERV)
>> +struct __packed hv_enlightenments {
>> +	struct __packed hv_enlightenments_control {
>> +		u32 nested_flush_hypercall:1;
>> +		u32 msr_bitmap:1;
>> +		u32 enlightened_npt_tlb: 1;
>> +		u32 reserved:29;
>> +	} hv_enlightenments_control;
>> +	u32 hv_vp_id;
>> +	u64 hv_vm_id;
>> +	u64 partition_assist_page;
>> +	u64 reserved;
>> +};
> Enlightened VMCS seems to have the same part:
>
>          struct {
>                  u32 nested_flush_hypercall:1;
>                  u32 msr_bitmap:1;
>                  u32 reserved:30;
>          }  __packed hv_enlightenments_control;
>          u32 hv_vp_id;
>          u64 hv_vm_id;
>          u64 partition_assist_page;
>
> Would it maybe make sense to unify these two (in case they are the same
> thing in Hyper-V, of course)?
They are very similar but,  the individual bits are a bit different. SVM 
struct has an
additional bit 'enlightened_npt_tlb'. There might be future changes as 
well if new
enlightenments are designed for performance optimization. So I feel, we 
can have
it as separate structs.


>>   
>> +#define VMCB_ALL_CLEAN_MASK (					\
>> +	(1U << VMCB_INTERCEPTS) | (1U << VMCB_PERM_MAP) |	\
>> +	(1U << VMCB_ASID) | (1U << VMCB_INTR) |			\
>> +	(1U << VMCB_NPT) | (1U << VMCB_CR) | (1U << VMCB_DR) |	\
>> +	(1U << VMCB_DT) | (1U << VMCB_SEG) | (1U << VMCB_CR2) |	\
>> +	(1U << VMCB_LBR) | (1U << VMCB_AVIC)			\
>> +	)
> What if we preserve VMCB_DIRTY_MAX and drop this newly introduced
> VMCB_ALL_CLEAN_MASK (which basically lists all the members of the enum
> above)? '1 << VMCB_DIRTY_MAX' can still work. (If the 'VMCB_DIRTY_MAX'
> name becomes misleading we can e.g. rename it to VMCB_NATIVE_DIRTY_MAX
> or something but I'm not sure it's worth it)

I thought of keeping this code because, if we have non-contiguous bits 
in future, we
would need this kinda logic anyways. But I get your point. Will revert this.


>
>> +#if IS_ENABLED(CONFIG_HYPERV)
>> +#define VMCB_HYPERV_CLEAN_MASK (1U << VMCB_HV_NESTED_ENLIGHTENMENTS)
>> +#endif
> VMCB_HYPERV_CLEAN_MASK is a single bit, why do we need it at all
> (BIT(VMCB_HV_NESTED_ENLIGHTENMENTS) is not super long)

Agreed. Will change it in next revision.

Thanks,
Vineeth

