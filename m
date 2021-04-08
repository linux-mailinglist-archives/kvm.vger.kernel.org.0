Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C2E358475
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 15:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhDHNSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 09:18:50 -0400
Received: from linux.microsoft.com ([13.77.154.182]:35392 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhDHNSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 09:18:50 -0400
Received: from [192.168.86.30] (c-73-38-52-84.hsd1.vt.comcast.net [73.38.52.84])
        by linux.microsoft.com (Postfix) with ESMTPSA id A411B20B5680;
        Thu,  8 Apr 2021 06:18:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A411B20B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617887918;
        bh=Uvq3RHp7zfj+SgleBAFg1sqKAQHQLyNq9zpMXhnErH8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=juVIgNa7Vc+ziH/Msl5xciwWFD1g6WdeZO+Nq6uKJ16YK5Si5OhGNAd/4RC27IN/L
         pEB0SpdpoVetBRxgwjsbHAkyRNd2o2BoyNzd79dOnCXbw8+1EPCf1SheKLZzyMGPnp
         Z8BDmRP1EvyCrpHV3b3FrgGZ8mkj63x7AReEExDc=
Subject: Re: [PATCH 3/7] KVM: x86: hyper-v: Move the remote TLB flush logic
 out of vmx
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
References: <cover.1617804573.git.viremana@linux.microsoft.com>
 <bb757810c7b7c27ebbefe344c20b99d67524ee29.1617804573.git.viremana@linux.microsoft.com>
 <87im4xav05.fsf@vitty.brq.redhat.com>
From:   Vineeth Pillai <viremana@linux.microsoft.com>
Message-ID: <88cf8856-6f72-9c50-6eca-4aca96419259@linux.microsoft.com>
Date:   Thu, 8 Apr 2021 09:18:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87im4xav05.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/8/21 7:14 AM, Vitaly Kuznetsov wrote:
> + /*
>> +	 * Two Dimensional paging CR3
>> +	 * EPTP for Intel
>> +	 * nCR3 for AMD
>> +	 */
>> +	u64 tdp_pointer;
>>   };
> 'struct kvm_vcpu_hv' is only allocated when we emulate Hyper-V in KVM
> (run Windows/Hyper-V guests on top of KVM). Remote TLB flush is used
> when we run KVM on Hyper-V and this is a very different beast. Let's not
> mix these things together. I understand that some unification is needed
> to bring the AMD specific feature but let's do it differently.
>
> E.g. 'ept_pointer' and friends from 'struct kvm_vmx' can just go to
> 'struct kvm_vcpu_arch' (in case they really need to be unified).
Ahh yes, thanks for catching this. Will fix this in the next version.

Thanks,
Vineeth
