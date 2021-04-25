Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25EAB36A781
	for <lists+kvm@lfdr.de>; Sun, 25 Apr 2021 15:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhDYNbX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Apr 2021 09:31:23 -0400
Received: from linux.microsoft.com ([13.77.154.182]:43566 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhDYNbW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Apr 2021 09:31:22 -0400
Received: from [192.168.86.30] (c-73-38-52-84.hsd1.vt.comcast.net [73.38.52.84])
        by linux.microsoft.com (Postfix) with ESMTPSA id 50EC720B8000;
        Sun, 25 Apr 2021 06:30:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 50EC720B8000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1619357442;
        bh=Kc0oAIUnVUkQ1h+dBy1jBjYsvzdBD19GYfEUFG19BVI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=aQpbDHjdvnOaBmYs06fWF9xy2LIYL1PCo4YfDfeU7AIQY4H6J5xM8VLpK08X9mNGQ
         au4X+h77xCC7QGMiaceYjvZGngk/JWtjIWnn7UJU4bxCUms1/GiKFblXBONYmMuEvU
         UsDGj6d+YT7e95MepeE0KFJXyu38o8LUgKSw3gVY=
Subject: Re: [PATCH v3 4/7] KVM: SVM: hyper-v: Nested enlightenments in VMCB
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        viremana@linux.microsoft.com
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
References: <cover.1619013347.git.viremana@linux.microsoft.com>
 <8c24e4fe8bee44730716e28a1985b6536a9f15c5.1619013347.git.viremana@linux.microsoft.com>
 <81cc0700-ab88-0b37-4a6f-685589e73212@amd.com>
From:   Vineeth Pillai <viremana@linux.microsoft.com>
Message-ID: <59bcf102-d6e7-361d-abc9-7fe046d246c8@linux.microsoft.com>
Date:   Sun, 25 Apr 2021 09:30:39 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <81cc0700-ab88-0b37-4a6f-685589e73212@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tom,


>>   
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
>> +#define VMCB_CONTROL_END	992	// 32 bytes for Hyper-V
>> +#else
>> +#define VMCB_CONTROL_END	1024
>> +#endif
>> +
>>   struct vmcb {
>>   	struct vmcb_control_area control;
>> -	u8 reserved_control[1024 - sizeof(struct vmcb_control_area)];
>> +	u8 reserved_control[VMCB_CONTROL_END - sizeof(struct vmcb_control_area)];
>> +#if IS_ENABLED(CONFIG_HYPERV)
>> +	struct hv_enlightenments hv_enlightenments;
>> +#endif
> I believe the 32 bytes at the end of the VMCB control area will be for use
> by any software/hypervisor. The APM update that documents this change,
> along with clean bit 31, isn't public, yet, but should be in a month or so
> (from what I was told).
>
> So these fields should be added generically and then your code should make
> use of the generic field mapped with your structure.
>
> To my knowledge (until the APM is public and documents everything), I
> believe the following will be in place:
>
>    VMCB offset 0x3e0 - 0x3ff is reserved for software
>    Clean bit 31 is reserved for software
>    SVM intercept exit code 0xf0000000 is reserved for software

Thanks for the details. I shall modify the code to accommodate this.


>   
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	if (hypervisor_is_type(X86_HYPER_MS_HYPERV))
> +		vmcb_all_clean_mask |= BIT(VMCB_HV_NESTED_ENLIGHTENMENTS);
> +#endif
> +
> Is there any way to hide all the #if's in this and the other patches so
> that the .c files are littered with the #if IS_ENABLED() lines. Put them
> in svm.h or a new svm-hv.h file?

Will do.


>
>>   			  */
>>   	VMCB_DIRTY_MAX,
>> +#if IS_ENABLED(CONFIG_HYPERV)
>> +	VMCB_HV_NESTED_ENLIGHTENMENTS = 31,
>> +#endif
> Again, this should be generic.
Will do.

Thanks,
Vineeth
