Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5D57CE64E
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 20:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjJRSYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 14:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjJRSYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 14:24:18 -0400
Received: from out-197.mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF3CF7
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 11:24:17 -0700 (PDT)
Date:   Wed, 18 Oct 2023 18:24:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697653455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tZgmiugmq/HuBF5Zgqs1/aVDylBOTyMyklK/nxHkNZ4=;
        b=NIh9liS5bJh/WOPbD55WnlgC/C/wMZrQeknCxk9fU1J9HgF3P7ntRtml/Yf43ORrP9GqDa
        /2lsDFGE/pCnVvkNFcvsmGmTx8jCdyb67VZJMlIhtcdS47Wn0NibkCgIOfo9iHC8OWOmFY
        wKUtYOOZ8ymffr2i2K5EqJHJX9W3dWE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Virtualise PMEVTYPER<n>_EL1.{NSU,NSK}
Message-ID: <ZTAiy7Ijq2UmySyX@linux.dev>
References: <20231013052901.170138-1-oliver.upton@linux.dev>
 <20231013052901.170138-3-oliver.upton@linux.dev>
 <86o7gwm50g.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86o7gwm50g.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 02:31:11PM +0100, Marc Zyngier wrote:
> On Fri, 13 Oct 2023 06:29:01 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Suzuki noticed that KVM's PMU emulation is oblivious to the NSU and NSK
> > event filter bits. On systems that have EL3 these bits modify the
> > filter behavior in non-secure EL0 and EL1, respectively. Even though the
> > kernel doesn't use these bits, it is entirely possible some other guest
> > OS does.
> 
> But what does it mean for KVM itself? We have no EL3 to speak of as
> far as a guest is concerned. And the moment we allow things like
> NSU/NSK to be set, why don't we allow M as well?

Yeah, we need to have a think about all these extra bits TBH.

KVM doesn't filter the advertised ELs in PFR0, so from the guest POV
both EL2 and EL3 could potentially be implemented by the vCPU. Based
on that I think the bits at least need to be stateful, even though KVM's
emulation will never let the guest count events in a higher EL.

My patches aren't even consistent with the above statement, as NSH gets
RES0 treatment and the NS{U,K} bits do not. So how about this:

 - If EL3 is advertised in the guest's ID registers NS{U,K}, and M can
   be set. NS{U,K} work as proposed, M is ignored in KVM emulation.

 - If EL2 is advertised in the guest's ID registers NSH can be set but
   is ignored in KVM emulation.

Thoughts?

-- 
Thanks,
Oliver
