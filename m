Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0096A452F16
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 11:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbhKPKdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 05:33:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234080AbhKPKdG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 05:33:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637058608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0HL/aUpmK12MV0NqhjZ/BCNTIxGMV93d3ybqH4nzJRo=;
        b=DBCataU7H+xkeHvGxTcIJaHcVl0maNH0iXH0AKq+92aaD3kaZ/S7kTkOUe/HASGQaRVBC4
        1+v4nBtw09O/He20Gd3Yr9qW5+zkm2VB/wO7+iEGY9NYRuLOh83YNqMO5kMegyZsogIMgn
        ZY1+0ApLjQNnEk+qhKQll0Eo2lXOlYM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-VfBFNv_VNpmrZGMBdn1FAg-1; Tue, 16 Nov 2021 05:30:05 -0500
X-MC-Unique: VfBFNv_VNpmrZGMBdn1FAg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6BB4C1851722;
        Tue, 16 Nov 2021 10:30:04 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D7E59808;
        Tue, 16 Nov 2021 10:30:03 +0000 (UTC)
Message-ID: <5ce937a9-5c14-189a-2aff-08476fb942f2@redhat.com>
Date:   Tue, 16 Nov 2021 11:30:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/2] KVM: x86: Update vPMCs when retiring instructions
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Eric Hankland <ehankland@google.com>
References: <20211112235235.1125060-1-jmattson@google.com>
 <20211112235235.1125060-2-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211112235235.1125060-2-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/13/21 00:52, Jim Mattson wrote:
> When KVM retires a guest instruction through emulation, increment any
> vPMCs that are configured to monitor "instructions retired," and
> update the sample period of those counters so that they will overflow
> at the right time.
> 
> Signed-off-by: Eric Hankland <ehankland@google.com>
> [jmattson:
>    - Split the code to increment "branch instructions retired" into a
>      separate commit.
>    - Added 'static' to kvm_pmu_incr_counter() definition.
>    - Modified kvm_pmu_incr_counter() to check pmc->perf_event->state ==
>      PERF_EVENT_STATE_ACTIVE.
> ]
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")

Queued both, with the addition of an

+	if (!pmu->event_count)
+		return;

check in kvm_pmu_record_event.

Paolo

> ---
>   arch/x86/kvm/pmu.c | 31 +++++++++++++++++++++++++++++++
>   arch/x86/kvm/pmu.h |  1 +
>   arch/x86/kvm/x86.c |  3 +++
>   3 files changed, 35 insertions(+)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 09873f6488f7..153c488032a5 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -490,6 +490,37 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
>   	kvm_pmu_reset(vcpu);
>   }
>   
> +static void kvm_pmu_incr_counter(struct kvm_pmc *pmc, u64 evt)
> +{
> +	u64 counter_value, sample_period;
> +
> +	if (pmc->perf_event &&
> +	    pmc->perf_event->attr.type == PERF_TYPE_HARDWARE &&
> +	    pmc->perf_event->state == PERF_EVENT_STATE_ACTIVE &&
> +	    pmc->perf_event->attr.config == evt) {
> +		pmc->counter++;
> +		counter_value = pmc_read_counter(pmc);
> +		sample_period = get_sample_period(pmc, counter_value);
> +		if (!counter_value)
> +			perf_event_overflow(pmc->perf_event, NULL, NULL);
> +		if (local64_read(&pmc->perf_event->hw.period_left) >
> +		    sample_period)
> +			perf_event_period(pmc->perf_event, sample_period);
> +	}
> +}
> +
> +void kvm_pmu_record_event(struct kvm_vcpu *vcpu, u64 evt)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	int i;
> +
> +	for (i = 0; i < pmu->nr_arch_gp_counters; i++)
> +		kvm_pmu_incr_counter(&pmu->gp_counters[i], evt);
> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
> +		kvm_pmu_incr_counter(&pmu->fixed_counters[i], evt);
> +}
> +EXPORT_SYMBOL_GPL(kvm_pmu_record_event);
> +
>   int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_pmu_event_filter tmp, *filter;
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 59d6b76203d5..d1dd2294f8fb 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -159,6 +159,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu);
>   void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
>   void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
>   int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
> +void kvm_pmu_record_event(struct kvm_vcpu *vcpu, u64 evt);
>   
>   bool is_vmware_backdoor_pmc(u32 pmc_idx);
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d7def720227d..bd49e2a204d5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7854,6 +7854,8 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
>   	if (unlikely(!r))
>   		return 0;
>   
> +	kvm_pmu_record_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
> +
>   	/*
>   	 * rflags is the old, "raw" value of the flags.  The new value has
>   	 * not been saved yet.
> @@ -8101,6 +8103,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
>   		if (!ctxt->have_exception ||
>   		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
> +			kvm_pmu_record_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
>   			kvm_rip_write(vcpu, ctxt->eip);
>   			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
>   				r = kvm_vcpu_do_singlestep(vcpu);
> 

