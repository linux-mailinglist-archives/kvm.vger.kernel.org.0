Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87692310FDA
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 19:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbhBEQor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 11:44:47 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:49314 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbhBEQkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 11:40:46 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612549345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A/92HZX/dfq8HitTi96rT9xpyPXwLeFFh5msh9r7w3M=;
        b=xTa6MR6TWhzRBiCd8owrpvBt5Ol9ja/HgNJ7nMOWv3qLuEdUF9njJiUTcKJ8XOgcFymgvJ
        1lAIE8/bZN0wevXmS1HJ6PMubH9K9VxrkTSwvMGBAs31+3hpakqwgFZTlifxDGJsBPCL0T
        JozrnuXo1/zWR1Y9YPYl0HidATPrkT/LQZG4Gkvws5Jq3KTWnxaWBnwVZXJWDy574gppE/
        rb93w6ifaEfdJILRPUKW4GtONjhrA2BwbfLkPr4OETng28msl47S91z4Mz7te+D58iRfIr
        g6MbTNBrme/dsOAkOfe70OPfuigEz89AVTsuql7EO4E3zlY13LO3wrbRvzhy2A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612549345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A/92HZX/dfq8HitTi96rT9xpyPXwLeFFh5msh9r7w3M=;
        b=KELeB1gc4swIE8rIFG/rjCM4PbIjRuguODKp/CflGVaA84bhjtpGAdNmdhzCaXzghc9ZoQ
        suAZNhQV2+x7JQCw==
To:     Peter Zijlstra <peterz@infradead.org>,
        Zhimin Feng <fengzhimin@bytedance.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, fweisbec@gmail.com,
        zhouyibo@bytedance.com, zhanghaozhong@bytedance.com
Subject: Re: [RFC: timer passthrough 5/9] KVM: vmx: use tsc_adjust to enable tsc_offset timer passthrough
In-Reply-To: <YB09f5oJ+sP9hiy6@hirez.programming.kicks-ass.net>
References: <20210205100317.24174-1-fengzhimin@bytedance.com> <20210205100317.24174-6-fengzhimin@bytedance.com> <YB09f5oJ+sP9hiy6@hirez.programming.kicks-ass.net>
Date:   Fri, 05 Feb 2021 19:22:24 +0100
Message-ID: <87blcy8jdr.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05 2021 at 13:43, Peter Zijlstra wrote:
> On Fri, Feb 05, 2021 at 06:03:13PM +0800, Zhimin Feng wrote:
>> +static void vmx_adjust_tsc_offset(struct kvm_vcpu *vcpu, bool to_host)
>> +{
>> +	u64 tsc_adjust;
>> +	struct timer_passth_info *local_timer_info;
>> +
>> +	local_timer_info = &per_cpu(passth_info, smp_processor_id());
>> +
>> +	if (to_host) {
>> +		tsc_adjust = local_timer_info->host_tsc_adjust;
>> +		wrmsrl(MSR_IA32_TSC_ADJUST, tsc_adjust);
>> +		vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
>> +	} else {
>> +		rdmsrl(MSR_IA32_TSC_ADJUST, tsc_adjust);
>> +		local_timer_info->host_tsc_adjust = tsc_adjust;
>> +
>> +		wrmsrl(MSR_IA32_TSC_ADJUST, tsc_adjust + vcpu->arch.tsc_offset);
>> +		vmcs_write64(TSC_OFFSET, 0);
>> +	}
>> +}
>
> NAK
>
> This wrecks the host TSC value, any host code between this and actually
> entering that VM will observe batshit time.

VMCS TSC offset is there for a reason...

Thanks,

        tglx
