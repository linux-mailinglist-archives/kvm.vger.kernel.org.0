Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8372D15F92F
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 23:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgBNWBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 17:01:32 -0500
Received: from foss.arm.com ([217.140.110.172]:45588 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbgBNWBE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 17:01:04 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF41A328;
        Fri, 14 Feb 2020 14:01:03 -0800 (PST)
Received: from [192.168.1.123] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9FA693F68E;
        Fri, 14 Feb 2020 14:01:02 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: arm64: Add PMU event filtering infrastructure
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200214183615.25498-1-maz@kernel.org>
 <20200214183615.25498-2-maz@kernel.org>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <ac2a8a87-3a90-1abb-30a5-00c20667cd14@arm.com>
Date:   Fri, 14 Feb 2020 22:01:01 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200214183615.25498-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020-02-14 6:36 pm, Marc Zyngier wrote:
[...]
> @@ -585,6 +585,14 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>   	    pmc->idx != ARMV8_PMU_CYCLE_IDX)
>   		return;
>   
> +	/*
> +	 * If we have a filter in place and that the event isn't allowed, do
> +	 * not install a perf event either.
> +	 */
> +	if (vcpu->kvm->arch.pmu_filter &&
> +	    !test_bit(eventsel, vcpu->kvm->arch.pmu_filter))
> +		return;

If I'm reading the derivation of eventsel right, this will end up 
treating cycle counter events (aliased to SW_INCR) differently from 
CPU_CYCLES, which doesn't seem desirable.

Also, if the user did try to blacklist SW_INCR for ridiculous reasons, 
we'd need to special-case kvm_pmu_software_increment() to make it (not) 
work as expected, right?

Robin.

> +
>   	memset(&attr, 0, sizeof(struct perf_event_attr));
>   	attr.type = PERF_TYPE_RAW;
>   	attr.size = sizeof(attr);
