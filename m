Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780056DD950
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 13:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjDKLZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 07:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjDKLZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 07:25:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BE435A6
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 04:25:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0648261FDA
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 11:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB2BC433EF;
        Tue, 11 Apr 2023 11:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681212306;
        bh=B1ZaBaMT7tK1LgbIC9hi0qnUcpYo7fHssf6FQgCYUSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b+6K2xiSZW9LeODlX6QGkuBhaatbr6qJ04rVPuUT9yhUF9ts+pT4CHfnTiJ3DfGFb
         eTlekH9JjtnX8/ZH8bYitLFueHoRKQJomQHbalxo1LpxMQEZlR3DiBIoi4nVPLFnf9
         hbwl+YJHksmSTQKbYBkWj7OY1g5marypXanq7RQe1t9PEjg43vhMNm8Xao9pq1ZVHw
         qhq/oz5ckYg3iGq4p+W1mBvqy20+olh6dtQFvvMgrrVoTkAVpCgrTol0L2tqL3CQ0U
         iLB8lYWxk9uWObv+f8uFxAL+ZXJyUklNvfpYKjxeBzvWmcfIkKyb2rfn3Dg6+V8OYo
         1OMuU0QwnFKHA==
Date:   Tue, 11 Apr 2023 12:24:59 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Reiji Watanabe <reijiw@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 0/2] KVM: arm64: PMU: Correct the handling of
 PMUSERENR_EL0
Message-ID: <20230411112458.GA22090@willie-the-truck>
References: <20230408034759.2369068-1-reijiw@google.com>
 <86r0subv8s.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86r0subv8s.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 08, 2023 at 10:04:19AM +0100, Marc Zyngier wrote:
> On Sat, 08 Apr 2023 04:47:57 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> > 
> > This series will fix bugs in KVM's handling of PMUSERENR_EL0.
> > 
> > With PMU access support from EL0 [1], the perf subsystem would
> > set CR and ER bits of PMUSERENR_EL0 as needed to allow EL0 to have
> > a direct access to PMU counters.  However, KVM appears to assume
> > that the register value is always zero for the host EL0, and has
> > the following two problems in handling the register.
> > 
> > [A] The host EL0 might lose the direct access to PMU counters, as
> >     KVM always clears PMUSERENR_EL0 before returning to userspace.
> > 
> > [B] With VHE, the guest EL0 access to PMU counters might be trapped
> >     to EL1 instead of to EL2 (even when PMUSERENR_EL0 for the guest
> >     indicates that the guest EL0 has an access to the counters).
> >     This is because, with VHE, KVM sets ER, CR, SW and EN bits of
> >     PMUSERENR_EL0 to 1 on vcpu_load() to ensure to trap PMU access
> >     from the guset EL0 to EL2, but those bits might be cleared by
> >     the perf subsystem after vcpu_load() (when PMU counters are
> >     programmed for the vPMU emulation).
> > 
> > Patch-1 will fix [A], and Patch-2 will fix [B] respectively.
> > The series is based on v6.3-rc5.
> > 
> > v2:
> >  - Save the PMUSERENR_EL0 for the host in the sysreg array of
> >    kvm_host_data. [Marc]
> >  - Don't let armv8pmu_start() overwrite PMUSERENR if the vCPU
> >    is loaded, instead have KVM update the saved shadow register
> >    value for the host. [Marc, Mark]
> 
> This looks much better to me. If Mark is OK with it, I'm happy to take
> it in 6.4.
> 
> Speaking of which, this will clash with the queued move of the PMUv3
> code into drivers/perf, and probably break on 32bit. I can either take
> a branch shared with arm64 (009d6dc87a56 ("ARM: perf: Allow the use of
> the PMUv3 driver on 32bit ARM")), or wait until -rc1.
> 
> Will, what do you prefer?

I'd be inclined to wait until -rc1, but for-next/perf is stable if you
decide to take it anyway.

Will
