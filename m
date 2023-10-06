Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E957BBE77
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 20:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbjJFSLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 14:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbjJFSLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 14:11:37 -0400
Received: from out-196.mta0.migadu.com (out-196.mta0.migadu.com [91.218.175.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049B4B6
        for <kvm@vger.kernel.org>; Fri,  6 Oct 2023 11:11:35 -0700 (PDT)
Date:   Fri, 6 Oct 2023 18:11:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696615894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L8lSHiz12Aav9oLTb3CvxyN/1lWwyX+P2/Gb3/jsWN8=;
        b=ekM8vZzYxNkS7ov34yAiI2ikVogB11+UMM8enyKgtFmPU0bJJuCG03J+tEnrvdgqESM/9n
        sQbJ/RtmtDy5DsVN276UDVnQt8i7GrUkAE2HwzwTB0DeQVs0XaUQ/Kgva1YqOcqt9cqGfQ
        240/dslRH4LQvWMLIdJzmBarVpzPiWI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Load the stage-2 MMU from vcpu_load()
 for VHE
Message-ID: <ZSBN0nAKANRHsxll@linux.dev>
References: <20231006093600.1250986-1-oliver.upton@linux.dev>
 <8634yongw3.wl-maz@kernel.org>
 <861qe8nd45.wl-maz@kernel.org>
 <86zg0vnaen.wl-maz@kernel.org>
 <86y1gfn67v.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86y1gfn67v.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Marc,

On Fri, Oct 06, 2023 at 04:03:32PM +0100, Marc Zyngier wrote:
> On Fri, 06 Oct 2023 14:33:04 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> 
> Still talking to myself! :D

Seems like you had a good bit of fun :)

> >
> > However, this isn't enough.
> > 
> > [   63.450113] Oh crap 400000435c001 vs 3000004430001
> > 
> > So there are situations where we end-up with the wrong VTTBR, rather
> > than the wrong VMID, which is even worse. Haven't worked out the
> > scenario yet, but it apparently involves being preempted by a vcpu
> > from a different VM and not doing the right thing.
> 
> Actually, no. It is the MMU notifiers kicking in and performing TLB
> invalidation for a guest while we're in the context of another. The
> joy of running 4 large VMs on a box with 2GB of RAM, basically running
> from swap.

Whelp, looks like my self-rule of no patches on the list after midnight
is in force again. Clearly this was all quite gently tested, thanks for
being the guinea pig.

> There's the sum of my hacks, which keeps the box alive.

Thanks! I'll roll it into v2 so we have something that actually works.

-- 
Thanks,
Oliver
