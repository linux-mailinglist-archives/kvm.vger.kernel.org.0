Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A7D72CFB0
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 21:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237520AbjFLTgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 15:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjFLTgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 15:36:48 -0400
Received: from out-32.mta0.migadu.com (out-32.mta0.migadu.com [91.218.175.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F243F0
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 12:36:43 -0700 (PDT)
Date:   Mon, 12 Jun 2023 21:36:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686598600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sHOwRria8WiDlXjDW/If+zix7QRbjzZycNIlyopWw1E=;
        b=Nj+wHbsVq4H20uyeoZmzpV3GNcl+aFzofDCBDUjH8vFfG4bXqmwGfba/FxsZ6f85vVQkNG
        auPFdIo+2EyWYeqMP52EbjfW4bPtAO7c8YmtM5iqaBcW7Dk+CKeHhnu3yvwm7DOMtzZEd2
        /AFLIrJncbFjbydlQWl6+teycrVojzE=
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
Message-ID: <ZIdzxmgt8257Kv09@linux.dev>
References: <20230610194510.4146549-1-reijiw@google.com>
 <ZIUb/ozyloOm6DfY@linux.dev>
 <20230611045430.evkcp4py4yuw5qgr@google.com>
 <ZIV7+yKUdRticwfF@linux.dev>
 <20230611160105.orvjohigsaevkcrf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230611160105.orvjohigsaevkcrf@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 11, 2023 at 09:01:05AM -0700, Reiji Watanabe wrote:

[...]

> > Suppose KVM is running on a v3p5+ implementation, but userspace has set
> > ID_AA64DFR0_EL1.PMUVer to v3p0. In this case the read of PMCEID1_EL0 on
> > the preceding line would advertise the STALL_SLOT event, and KVM fails
> > to mask it due to the ID register value. The fact we do not support the
> > event is an invariant, in the worst case we wind up clearing a bit
> > that's already 0.
> 
> As far as I checked ArmARM, the STALL_SLOT event can be supported on
> any PMUv3 version (including on v3p0).  Assuming that is true, I don't
> see any reason to not expose the event to the guest in this particular
> example. Or can the STALL_SLOT event only be implemented from certain
> versions of PMUv3 ?

Well, users of the event don't get the full picture w/o PMMIR_EL1.SLOTS,
which is only available on v3p4+. We probably should start exposing the
register + event (separate from this change).

> > This is why I'd suggested just unconditionally clearing the bit. While
> 
> When the hardware supports the STALL_SLOT event (again, I assume any
> PMUv3 version hardware can support the event), and the guest's PMUVer
> is older than v3p4, what is the reason why we want to clear the bit ?

What's the value of the event w/o PMMIR_EL1? I agree there's no
fundamental issue with letting it past, but I'd rather we start
exposing the feature when we provide all the necessary detail.

--
Thanks,
Oliver
