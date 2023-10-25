Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FF27D5EE9
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 02:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344711AbjJYABd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 20:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344685AbjJYABa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 20:01:30 -0400
Received: from out-207.mta1.migadu.com (out-207.mta1.migadu.com [95.215.58.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62BC10CF
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 17:01:27 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698192085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gulJryeOiAII7rRti1FgpAMjLmQKWyqOB8guMGZkbTk=;
        b=LOm2g80fdK+Zk5MnmgUOQet8LgbtP/tQYKA6OMIXPTBEC7vrNUPmgB628GHUI7I8ZaII4i
        IVDHYLJXyoM8876962oTh9j+WU1EHNo9f+EOR5vArflelhg6qZzgZ6T5Ntt8db+kZ9N0zf
        gLQ6XHnz90rwmGJ9eyd1uB2fX6JeIWA=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>, kvm@vger.kernel.org,
        Reiji Watanabe <reijiw@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
        Colton Lewis <coltonlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v8 00/13] KVM: arm64: PMU: Allow userspace to limit the number of PMCs on vCPU
Date:   Wed, 25 Oct 2023 00:01:12 +0000
Message-ID: <169819197647.2014901.5722928932912558103.b4-ty@linux.dev>
In-Reply-To: <20231020214053.2144305-1-rananta@google.com>
References: <20231020214053.2144305-1-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Oct 2023 21:40:40 +0000, Raghavendra Rao Ananta wrote:
> The goal of this series is to allow userspace to limit the number
> of PMU event counters on the vCPU.  We need this to support migration
> across systems that implement different numbers of counters.
> 
> The number of PMU event counters is indicated in PMCR_EL0.N.
> For a vCPU with PMUv3 configured, its value will be the same as
> the current PE by default.  Userspace can set PMCR_EL0.N for the
> vCPU to any value even with the current KVM using KVM_SET_ONE_REG.
> However, it is practically unsupported, as KVM resets PMCR_EL0.N
> to the host value on vCPU reset and some KVM code uses the host
> value to identify (un)implemented event counters on the vCPU.
> 
> [...]

I've applied this with Marc + I's fixes. I'm happy to toss any fixes
on top of this series if folks spot issues.

[01/13] KVM: arm64: PMU: Introduce helpers to set the guest's PMU
        https://git.kernel.org/kvmarm/kvmarm/c/1616ca6f3c10
[02/13] KVM: arm64: PMU: Set the default PMU for the guest before vCPU reset
        https://git.kernel.org/kvmarm/kvmarm/c/427733579744
[03/13] KVM: arm64: PMU: Add a helper to read a vCPU's PMCR_EL0
        https://git.kernel.org/kvmarm/kvmarm/c/57fc267f1b5c
[04/13] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based on the associated PMU
        https://git.kernel.org/kvmarm/kvmarm/c/4d20debf9ca1
[05/13] KVM: arm64: Add {get,set}_user for PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
        https://git.kernel.org/kvmarm/kvmarm/c/a45f41d754e0
[06/13] KVM: arm64: Sanitize PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR} before first run
        https://git.kernel.org/kvmarm/kvmarm/c/27131b199f9f
[07/13] KVM: arm64: PMU: Allow userspace to limit PMCR_EL0.N for the guest
        https://git.kernel.org/kvmarm/kvmarm/c/ea9ca904d24f
[08/13] tools: Import arm_pmuv3.h
        https://git.kernel.org/kvmarm/kvmarm/c/9f4b3273dfbe
[09/13] KVM: selftests: aarch64: Introduce vpmu_counter_access test
        https://git.kernel.org/kvmarm/kvmarm/c/8d0aebe1ca2b
[10/13] KVM: selftests: aarch64: vPMU register test for implemented counters
        https://git.kernel.org/kvmarm/kvmarm/c/ada1ae68262d
[11/13] KVM: selftests: aarch64: vPMU register test for unimplemented counters
        https://git.kernel.org/kvmarm/kvmarm/c/e1cc87206348
[12/13] KVM: selftests: aarch64: vPMU test for validating user accesses
        https://git.kernel.org/kvmarm/kvmarm/c/62708be351fe

--
Best,
Oliver
