Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBDC7053E8
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 18:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbjEPQdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 12:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbjEPQci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 12:32:38 -0400
Received: from out-54.mta0.migadu.com (out-54.mta0.migadu.com [IPv6:2001:41d0:1004:224b::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9270DD9E
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 09:31:41 -0700 (PDT)
Date:   Tue, 16 May 2023 16:31:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684254694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1uT5678vYdu1Mhydj6fwo4gp85uMJ7JLyMNfrcXuqD4=;
        b=uYEuGCosTFAO6PtxhVykb0npHnpsVArogzuKafwhxu14acARVet43TgjgS35aP28KVfv4m
        o8weizNlix/9EDbjD0LFisZapuPrmCAI0jWa5ufq/7ZJ1fqn2pjtCw+q1qrpOug2CeN55y
        FRSy9kWr/T+YAQX/7EXGDsfZ9IC1oU4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v8 0/6] Support writable CPU ID registers from userspace
Message-ID: <ZGOv4ZA9qxcC5wKv@linux.dev>
References: <20230503171618.2020461-1-jingzhangos@google.com>
 <2ef9208dabe44f5db445a1061a0d5918@huawei.com>
 <868rdomtfo.wl-maz@kernel.org>
 <1a96a72e87684e2fb3f8c77e32516d04@huawei.com>
 <87cz30h4nx.fsf@redhat.com>
 <867ct8mnel.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867ct8mnel.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 16, 2023 at 02:11:30PM +0100, Marc Zyngier wrote:
> On Tue, 16 May 2023 12:55:14 +0100,
> Cornelia Huck <cohuck@redhat.com> wrote:
> > 
> > Do you have more concrete ideas for QEMU CPU models already? Asking
> > because I wanted to talk about this at KVM Forum, so collecting what
> > others would like to do seems like a good idea :)
> 
> I'm not being asked, but I'll share my thoughts anyway! ;-)
> 
> I don't think CPU models are necessarily the most important thing.
> Specially when you look at the diversity of the ecosystem (and even
> the same CPU can be configured in different ways at integration
> time). Case in point, Neoverse N1 which can have its I/D caches made
> coherent or not. And the guest really wants to know which one it is
> (you can only lie in one direction).
> 
> But being able to control the feature set exposed to the guest from
> userspace is a huge benefit in terms of migration.
> 
> Now, this is only half of the problem (and we're back to the CPU
> model): most of these CPUs have various degrees of brokenness. Most of
> the workarounds have to be implemented by the guest, and are keyed on
> the MIDR values. So somehow, you need to be able to expose *all* the
> possible MIDR values that a guest can observe in its lifetime.
> 
> I have a vague prototype for that that I'd need to dust off and
> finish, because that's also needed for this very silly construct
> called big-little...

And the third half of the problem is all of the other IP bits that get
strung together into an SOC :) Errata that live beyond the CPU can
become guest-visible (interconnect for example) and that becomes a bit
difficult to express to the guest OS. So, beyond something like a
big-little VM where the rest of the IP should be shared, I'm a bit
fearful of migrating a VM cross-system.

But hey, userspace is in the drivers seat and it can do as it pleases.

Hopefully we wouldn't need a KVM-specific PV interface for MIDR
enumeration. Perhaps the errata management spec could be expanded to
describe a set of CPU implementations and associated errata...

-- 
Thanks,
Oliver
