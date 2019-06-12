Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30D364265E
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 14:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439207AbfFLMsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 08:48:10 -0400
Received: from foss.arm.com ([217.140.110.172]:52646 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439208AbfFLMsK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 08:48:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 80036337;
        Wed, 12 Jun 2019 05:48:09 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 39D8E3F246;
        Wed, 12 Jun 2019 05:48:07 -0700 (PDT)
Subject: Re: [PATCH v1 1/5] KVM: arm/arm64: Remove kvm_mmio_emulate tracepoint
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, marc.zyngier@arm.com,
        catalin.marinas@arm.com, will.deacon@arm.com, acme@kernel.org,
        linuxarm@huawei.com, acme@redhat.com, peterz@infradead.org,
        alexander.shishkin@linux.intel.com, mingo@redhat.com,
        ganapatrao.kulkarni@cavium.com, namhyung@kernel.org,
        jolsa@redhat.com, xiexiangyou@huawei.com
References: <1560330526-15468-1-git-send-email-yuzenghui@huawei.com>
 <1560330526-15468-2-git-send-email-yuzenghui@huawei.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <e915c19a-51df-be88-ea3a-7c9a211f4518@arm.com>
Date:   Wed, 12 Jun 2019 13:48:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1560330526-15468-2-git-send-email-yuzenghui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 12/06/2019 10:08, Zenghui Yu wrote:
> In current KVM/ARM code, no one will invoke trace_kvm_mmio_emulate().
> Remove this TRACE_EVENT definition.

Oooer. We can't just go removing these things, they are visible to user-space.

I recall an article on this: https://lwn.net/Articles/737530/
"Another attempt to address the tracepoint ABI problem"

I agree this is orphaned, it was added by commit 45e96ea6b369 ("KVM: ARM: Handle I/O
aborts"), but there never was a caller.

The problem with removing it is /sys/kernel/debug/tracing/events/kvm/kvm_mmio_emulate
disappears. Any program relying on that being present (but useless) is now broken.


Thanks,

James


> diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
> index 204d210..8b7dff2 100644
> --- a/virt/kvm/arm/trace.h
> +++ b/virt/kvm/arm/trace.h
> @@ -114,27 +114,6 @@
>  		  __entry->type, __entry->vcpu_idx, __entry->irq_num, __entry->level)
>  );
>  
> -TRACE_EVENT(kvm_mmio_emulate,
> -	TP_PROTO(unsigned long vcpu_pc, unsigned long instr,
> -		 unsigned long cpsr),
> -	TP_ARGS(vcpu_pc, instr, cpsr),
> -
> -	TP_STRUCT__entry(
> -		__field(	unsigned long,	vcpu_pc		)
> -		__field(	unsigned long,	instr		)
> -		__field(	unsigned long,	cpsr		)
> -	),
> -
> -	TP_fast_assign(
> -		__entry->vcpu_pc		= vcpu_pc;
> -		__entry->instr			= instr;
> -		__entry->cpsr			= cpsr;
> -	),
> -
> -	TP_printk("Emulate MMIO at: 0x%08lx (instr: %08lx, cpsr: %08lx)",
> -		  __entry->vcpu_pc, __entry->instr, __entry->cpsr)
> -);
> -
>  TRACE_EVENT(kvm_unmap_hva_range,
>  	TP_PROTO(unsigned long start, unsigned long end),
>  	TP_ARGS(start, end),
> 

