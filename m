Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E8672AFE3
	for <lists+kvm@lfdr.de>; Sun, 11 Jun 2023 02:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbjFKA54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Jun 2023 20:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjFKA5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Jun 2023 20:57:55 -0400
Received: from out-18.mta1.migadu.com (out-18.mta1.migadu.com [95.215.58.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0218713E
        for <kvm@vger.kernel.org>; Sat, 10 Jun 2023 17:57:53 -0700 (PDT)
Date:   Sat, 10 Jun 2023 17:57:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686445072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IPX3drkYGXtZ5NfhWGgC7KgqI4QYfnQoNpwaPEZFU9I=;
        b=QfnKZecAfKMBzH0AzHxXT6pbVIZpnEv+ilaxEExQQdibAZIqRimfcWGx9jYfgvJDyNA6jx
        q0o+X4OVQFP9VcQmv22hx+9S3UeuzPAuMmmRUgU3RAFeStdy8krSPK5e/SR+aX/nkz9Yr4
        2d4kh/vWlfmBeF/REXwkT6vsolbQEME=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH 1/1] KVM: arm64: PMU: Avoid inappropriate use of host's
 PMUVer
Message-ID: <ZIUb/ozyloOm6DfY@linux.dev>
References: <20230610194510.4146549-1-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230610194510.4146549-1-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On Sat, Jun 10, 2023 at 12:45:10PM -0700, Reiji Watanabe wrote:
> @@ -735,7 +736,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
>  		 * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
>  		 * as RAZ
>  		 */
> -		if (vcpu->kvm->arch.arm_pmu->pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P4)
> +		if (vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P4)
>  			val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);

I don't think this conditional masking is correct in the first place,
and this change would only make it worse.

We emulate reads of PMCEID1_EL0 using the literal value of the CPU. The
_advertised_ PMU version has no bearing on the core PMU version. So,
assuming we hit this on a v3p5+ part with userspace (stupidly)
advertising an older implementation level, we never clear the bit for
STALL_SLOT.

So let's just fix the issue by unconditionally masking the bit.

>  		base = 32;
>  	}
> @@ -932,11 +933,17 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  		return 0;
>  	}
>  	case KVM_ARM_VCPU_PMU_V3_FILTER: {
> +		u8 pmuver = kvm_arm_pmu_get_pmuver_limit();
>  		struct kvm_pmu_event_filter __user *uaddr;
>  		struct kvm_pmu_event_filter filter;
>  		int nr_events;
>  
> -		nr_events = kvm_pmu_event_mask(kvm) + 1;
> +		/*
> +		 * Allow userspace to specify an event filter for the entire
> +		 * event range supported by PMUVer of the hardware, rather
> +		 * than the guest's PMUVer for KVM backward compatibility.
> +		 */
> +		nr_events = __kvm_pmu_event_mask(pmuver) + 1;

This is a rather signifcant change from the existing behavior though,
no?

The 'raw' PMU version of the selected instance has been used as the
basis of the maximum event list, but this uses the sanitised value. I'd
rather we consistently use the selected PMU instance as the basis for
all guest-facing PMU emulation.

I get that asymmetry in this deparment is exceedingly rare in the wild,
but I'd rather keep a consistent model in the PMU emulation code where
all our logic is based on the selected PMU instance.

--
Thanks,
Oliver
