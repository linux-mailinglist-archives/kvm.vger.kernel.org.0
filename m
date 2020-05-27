Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5171E3B0F
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 09:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387679AbgE0HzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 03:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387566AbgE0HzW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 03:55:22 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1272C206DF;
        Wed, 27 May 2020 07:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590566121;
        bh=jzOmuKHr7MlkKhB0uHGzKnveUIYCQtnDxs2JjhAI0Qw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IQfUN1SSOnwGbA+wQOaXCUtXhUe/1PYgxn+dBcov9P1qwLHE1jEo++wGH2RrhqjNF
         kWQpzqI991EMT2EFP/jykooRM94vdRXLiSCFAUmRwPm1btiDP9GdDvo90nhr7gPubd
         LG1u151RsnIxhDv4CAeA++tUcpAG6m+m9it6yv88=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jdquF-00FdO9-Bn; Wed, 27 May 2020 08:55:19 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 27 May 2020 08:55:19 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        kernel-team@android.com, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] KVM: arm64: Allow in-atomic injection of SPIs
In-Reply-To: <47d6d521-f05e-86fe-4a94-ce21754100ae@huawei.com>
References: <20200526161136.451312-1-maz@kernel.org>
 <47d6d521-f05e-86fe-4a94-ce21754100ae@huawei.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <1d3658f4b92a690ba05367f2a22a7331@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, eric.auger@redhat.com, kernel-team@android.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 2020-05-27 08:41, Zenghui Yu wrote:
> On 2020/5/27 0:11, Marc Zyngier wrote:
>> On a system that uses SPIs to implement MSIs (as it would be
>> the case on a GICv2 system exposing a GICv2m to its guests),
>> we deny the possibility of injecting SPIs on the in-atomic
>> fast-path.
>> 
>> This results in a very large amount of context-switches
>> (roughly equivalent to twice the interrupt rate) on the host,
>> and suboptimal performance for the guest (as measured with
>> a test workload involving a virtio interface backed by vhost-net).
>> Given that GICv2 systems are usually on the low-end of the spectrum
>> performance wise, they could do without the aggravation.
>> 
>> We solved this for GICv3+ITS by having a translation cache. But
>> SPIs do not need any extra infrastructure, and can be immediately
>> injected in the virtual distributor as the locking is already
>> heavy enough that we don't need to worry about anything.
>> 
>> This halves the number of context switches for the same workload.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   arch/arm64/kvm/vgic/vgic-irqfd.c | 20 ++++++++++++++++----
>>   arch/arm64/kvm/vgic/vgic-its.c   |  3 +--
>>   2 files changed, 17 insertions(+), 6 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c 
>> b/arch/arm64/kvm/vgic/vgic-irqfd.c
>> index d8cdfea5cc96..11a9f81115ab 100644
>> --- a/arch/arm64/kvm/vgic/vgic-irqfd.c
>> +++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
>> @@ -107,15 +107,27 @@ int kvm_arch_set_irq_inatomic(struct 
>> kvm_kernel_irq_routing_entry *e,
>>   			      struct kvm *kvm, int irq_source_id, int level,
>>   			      bool line_status)
> 
> ... and you may also need to update the comment on top of it to
> reflect this change.
> 
> /**
>  * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
>  *
>  * Currently only direct MSI injection is supported.
>  */

As far as I can tell, it is still valid (at least from the guest's
perspective). You could in practice use that to deal with level
interrupts, but we only inject the rising edge on this path, never
the falling edge. So effectively, this is limited to edge interrupts,
which is mostly MSIs.

Unless you are thinking of something else which I would have missed?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
