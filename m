Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8777663708
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 03:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjAJCBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 21:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjAJCBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 21:01:08 -0500
Received: from out-231.mta0.migadu.com (out-231.mta0.migadu.com [IPv6:2001:41d0:1004:224b::e7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C14E19282
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 18:01:06 -0800 (PST)
Date:   Tue, 10 Jan 2023 02:01:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1673316064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QlpukRc+Putp0ejqXteDPBnVcvmJAb1SPiaGSSl2fVw=;
        b=ZeFdRb1DNlq70KAQVg6FRY1iV3JBdghauAa4cPTFJVdHFcFpHvC6208PYlE1RfXVgwKPXA
        BDmHZmehmHUOlIuXub373b7KigvbndxnMcQ76I67OEUE4aoeogayV+ZMvd4NIyRke8QO3g
        kAnCHznoskMbxs4GnfvGpRV+BAoaq7Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH 0/7] KVM: arm64: PMU: Allow userspace to limit the number
 of PMCs on vCPU
Message-ID: <Y7zG3B3DmFZLU200@google.com>
References: <20221230035928.3423990-1-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230035928.3423990-1-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On Thu, Dec 29, 2022 at 07:59:21PM -0800, Reiji Watanabe wrote:
> The goal of this series is to allow userspace to limit the number
> of PMU event counters on the vCPU.
> 
> The number of PMU event counters is indicated in PMCR_EL0.N.
> For a vCPU with PMUv3 configured, its value will be the same as
> the host value by default. Userspace can set PMCR_EL0.N for the
> vCPU to a lower value than the host value, using KVM_SET_ONE_REG.
> However, it is practically unsupported, as KVM resets PMCR_EL0.N
> to the host value on vCPU reset and some KVM code uses the host
> value to identify (un)implemented event counters on the vCPU.
> 
> This series will ensure that the PMCR_EL0.N value is preserved
> on vCPU reset and that KVM doesn't use the host value
> to identify (un)implemented event counters on the vCPU.
> This allows userspace to limit the number of the PMU event
> counters on the vCPU.

I just wanted to bring up the conversation we had today on the list as
it is a pretty relevant issue.

KVM currently allows any value to be written to PMCR_EL0.N, meaning that
userspace could advertize more PMCs than are supported by the system.

IDK if Marc feels otherwise, but it doesn't seem like we should worry
about ABI change here (i.e. userspace can no longer write junk to the
register) as KVM has advertized the correct value to userspace. The only
case that breaks would be a userspace that intentionally sets PMCR_EL0.N
to something larger than the host. As accesses to unadvertized PMC
indices is CONSTRAINED UNPRED behavior, I'm having a hard time coming up
with a use case.

--
Thanks,
Oliver
