Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40650358462
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 15:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhDHNQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 09:16:02 -0400
Received: from linux.microsoft.com ([13.77.154.182]:34986 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhDHNQB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 09:16:01 -0400
Received: from [192.168.86.30] (c-73-38-52-84.hsd1.vt.comcast.net [73.38.52.84])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9246420B5680;
        Thu,  8 Apr 2021 06:15:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9246420B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617887750;
        bh=XZtRYq5agCaEslp2SkcIxFuSoTSHZxnoXDUN99ENL0M=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=GvyHAEg4gxRRvHJLEjU1/eh6x3wmXHkOv357f0YDONPqsL6y4qMEczVbayazjH1Bv
         Hs3/RiSDu8+uCxF3bF1/76pzWb2368cfPni8KfxPghJB9zCyZ7AfQfJ/w+bSOOpGkG
         Acj8eJwqkHh1BXE75Z4yWcBL1OG4d/w/HZ3dWvyM=
Subject: Re: [PATCH 1/7] hyperv: Detect Nested virtualization support for SVM
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
 <e14dac75ff1088b2c4bea361954b37e414edd03c.1617804573.git.viremana@linux.microsoft.com>
 <87lf9tavci.fsf@vitty.brq.redhat.com>
From:   Vineeth Pillai <viremana@linux.microsoft.com>
Message-ID: <af87c25e-78c6-5859-e1c1-2aa07d087a25@linux.microsoft.com>
Date:   Thu, 8 Apr 2021 09:15:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87lf9tavci.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,

On 4/8/21 7:06 AM, Vitaly Kuznetsov wrote:
> -	if (ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED) {
> +	/*
> +	 * AMD does not need enlightened VMCS as VMCB is already a
> +	 * datastructure in memory.
> Well, VMCS is also a structure in memory, isn't it? It's just that we
> don't have a 'clean field' concept for it and we can't use normal memory
> accesses.

Yes, you are right. I was referring to the fact that we cant use normal
memory accesses, but is a bit mis-worded.

>
>> 	We need to get the nested
>> +	 * features if SVM is enabled.
>> +	 */
>> +	if (boot_cpu_has(X86_FEATURE_SVM) ||
>> +	    ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED) {
> Do I understand correctly that we can just look at CPUID.0x40000000.EAX
> and in case it is >= 0x4000000A we can read HYPERV_CPUID_NESTED_FEATURES
> leaf? I'd suggest we do that intead then.
I agree, that is a better way to consolidate both the cases.
Will change it in the next iteration. Probably the above code
comment is not needed when we consolidate the cases here.

Thanks,
Vineeth

