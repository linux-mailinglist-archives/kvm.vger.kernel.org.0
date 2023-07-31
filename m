Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C254769CF3
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjGaQl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjGaQlO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:41:14 -0400
Received: from out-73.mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE9319B0
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:41:10 -0700 (PDT)
Date:   Mon, 31 Jul 2023 09:41:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690821667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VOFw4Kj4hJRr7MmhNaCZHU6GMvxI4dnHBIGrUAh9zjc=;
        b=VvIXFTWW6k2oIyw87XotFIxTJjXZuSPPxVwOWsEHKndo+pcHaB450FDHoSsL6Vc3AL7W4I
        a61XEJt5N4DiKGw7HSEnyo/KkHHmk98WZjk/1HZaQ6J8d2PniPZ6CvR7aIRp+ynreRfr1B
        Rp5nYB8V2IxbMyyIF5V6o/UCAwKldhM=
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
Subject: Re: [PATCH v2 2/5] KVM: arm64: PMU: Disallow vPMU on non-uniform
 PMUVer systems
Message-ID: <ZMfkHrRNGNA7XLso@linux.dev>
References: <20230728181907.1759513-1-reijiw@google.com>
 <20230728181907.1759513-3-reijiw@google.com>
 <ZMQckrDB7tg9gPfw@linux.dev>
 <CAAeT=FyC42s=kcS3QTC6A-s6EZjhoQL7XJyxWCb5YyisJrQvdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FyC42s=kcS3QTC6A-s6EZjhoQL7XJyxWCb5YyisJrQvdg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023 at 04:54:04AM -0700, Reiji Watanabe wrote:
> Hi Oliver,
> 
> > This doesn't actually disallow userspace from configuring a vPMU, it
> > only hides the KVM cap. kvm_host_pmu_init() will still insert the host
> > PMU instance in the list of valid PMUs, and there doesn't appear to be
> > any check against the static key anywhere on that path.
> 
> In v6.5-rc3, which I used as the base, or even in v6.5-rc4,
> it appears kvm_reset_vcpu() checks against the static key.
> So, the initial KVM_ARM_VCPU_INIT with vPMU configured will
> fail on the systems.  Or am I missing something ? (Or is that
> going to be removed by other patches that are already queued?)

No, I definitely missed something, sorry for the noise! I had only
checked the PMU attributes, forgot about feature flags for a moment.

> > I actually prefer where we flip the static key, as PMU context switching
> > depends on both KVM support as well as the PMU driver coming up successfully.
> > Instead, you could hoist the check against the sanitised PMU version into
> > kvm_host_pmu_init(), maybe something like:
> 
> Thank you, it looks better.  I will fix this in v3.

Sounds good, thanks!

--
Best,
Oliver
