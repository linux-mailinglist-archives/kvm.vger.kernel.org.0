Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330E4675C6C
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 19:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjATSFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 13:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjATSFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 13:05:05 -0500
X-Greylist: delayed 63260 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 Jan 2023 10:05:01 PST
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88594521E2
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 10:05:01 -0800 (PST)
Date:   Fri, 20 Jan 2023 18:04:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674237899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z1CaMcH4x5rtypgK1Xxe771oK8a9hWqV3gyDwwh42eA=;
        b=s+eRmBypvtugBDgcUxeYCjsvJV1Ae4KYybdsroHaliFb55C2HFYchZaA8jsQLjwHC/lmtn
        kYYWKySUBrw07RcLprP4ZxCmfxU8Td+Cx8vDrKSZdQohAxRDZfWRZdgW+sPyJILUzSDNXb
        EnmsfZCqROpfaQcSS24cv2UsT7n+gCs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Reiji Watanabe <reijiw@google.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH v2 3/8] KVM: arm64: PMU: Preserve vCPU's PMCR_EL0.N value
 on vCPU reset
Message-ID: <Y8rXx+7EUob7qPXh@google.com>
References: <20230117013542.371944-1-reijiw@google.com>
 <20230117013542.371944-4-reijiw@google.com>
 <Y8ngqRHhiXHjc0vA@google.com>
 <86pmb9mmkv.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86pmb9mmkv.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Marc,

On Fri, Jan 20, 2023 at 12:12:32PM +0000, Marc Zyngier wrote:
> On Fri, 20 Jan 2023 00:30:33 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:
> > I think we need to derive a sanitised value for PMCR_EL0.N, as I believe
> > nothing in the architecture prevents implementers from gluing together
> > cores with varying numbers of PMCs. We probably haven't noticed it yet
> > since it would appear all Arm designs have had 6 PMCs.
> 
> This brings back the question of late onlining. How do you cope with
> with the onlining of such a CPU that has a smaller set of counters
> than its online counterparts? This is at odds with the way the PMU
> code works.

You're absolutely right, any illusion we derived from the online set of
CPUs could fall apart with a late onlining of a different core.

> If you have a different set of counters, you are likely to have a
> different PMU altogether:
> 
> [    1.192606] hw perfevents: enabled with armv8_cortex_a57 PMU driver, 7 counters available
> [    1.201254] hw perfevents: enabled with armv8_cortex_a53 PMU driver, 7 counters available
> 
> This isn't a broken system, but it has two set of cores which are
> massively different, and two PMUs.
> 
> This really should tie back to the PMU type we're counting on, and to
> the set of CPUs that implements it. We already have some
> infrastructure to check for the affinity of the PMU vs the CPU we're
> running on, and this is already visible to userspace.
> 
> Can't we just leave this responsibility to userspace?

Believe me, I'm always a fan of offloading things to userspace :)

If the VMM is privy to the details of the system it is on then the
differing PMUs can be passed through to the guest w/ pinned vCPU
threads. I just worry about the case of a naive VMM that assumes a
homogenous system. I don't think I could entirely blame the VMM in this
case either as we've gone to lengths to sanitise the feature set
exposed to userspace.

What happens when a vCPU gets scheduled on a core where the vPMU
doesn't match? Ignoring other incongruences, it is not possible to
virtualize more counters than are supported by the vPMU of the core.

Stopping short of any major hacks in the kernel to fudge around the
problem, I believe we may need to provide better documentation of how
heterogeneous CPUs are handled in KVM and what userspace can do about
it.

--
Thanks,
Oliver
