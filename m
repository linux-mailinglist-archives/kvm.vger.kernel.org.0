Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05FF6A5F8F
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 20:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjB1TXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 14:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjB1TW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 14:22:56 -0500
Received: from out-4.mta0.migadu.com (out-4.mta0.migadu.com [IPv6:2001:41d0:1004:224b::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE541A6
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 11:22:11 -0800 (PST)
Date:   Tue, 28 Feb 2023 19:22:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677612128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LbYuqfCuY3T1CvXJk+av0g4V2EXiiWFsKxVBORVL9FY=;
        b=W7Ugjs4PVgdnEmIQg8Hu9a+sy1r8G/aQDSGCJyZXds0p9QGUPsQ+IeRSQxkZl12yaK1rgv
        VMquNdhCIBv7TWGYoGA9LbdVhhUz9LbKOfgJadT/dUOV6kvMzegUjIGsUVL6FBGdyIVjKO
        HUVhx/1ae9JBSrM8t7WbdShqBYoJH2E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Reiji Watanabe <reijiw@google.com>, nd@arm.com
Subject: Re: [PATCH v2] KVM: arm64: timers: Convert per-vcpu virtual offset
 to a global value
Message-ID: <Y/5UXKoK38fENlkb@linux.dev>
References: <20230224191640.3396734-1-maz@kernel.org>
 <20230228112607.GA18683@e124191.cambridge.arm.com>
 <87sfepha41.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sfepha41.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 07:18:38PM +0000, Marc Zyngier wrote:
> On Tue, 28 Feb 2023 11:26:07 +0000,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Fri, Feb 24, 2023 at 07:16:40PM +0000, Marc Zyngier wrote:
> > > Having a per-vcpu virtual offset is a pain. It needs to be synchronized
> > > on each update, and expands badly to a setup where different timers can
> > > have different offsets, or have composite offsets (as with NV).
> > > 
> > > So let's start by replacing the use of the CNTVOFF_EL2 shadow register
> > > (which we want to reclaim for NV anyway), and make the virtual timer
> > > carry a pointer to a VM-wide offset.
> > > 
> > > This simplifies the code significantly. It also addresses two terrible bugs:
> > > 
> > > - The use of CNTVOFF_EL2 leads to some nice offset corruption
> > >   when the sysreg gets reset, as reported by Joey.
> > > 
> > > - The kvm mutex is taken from a vcpu ioctl, which goes against
> > >   the locking rules...
> > > 
> > > Reported-by: Joey Gouly <joey.gouly@arm.com>
> > > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > Link: https://lore.kernel.org/r/20230224173915.GA17407@e124191.cambridge.arm.com
> > 
> > Fixes my mismatched timer offset issues.
> > 
> > Tested-by: Joey Gouly <joey.gouly@arm.com>
> 
> Thanks for having given it a go. Hopefully Oliver will be able to send
> this to as a fix shortly.

Absolutely, I have this queued up. Thanks for testing the patch Joey.

Want to see if I can get push access to the kvmarm repository in time,
otherwise I'll send a pull to you Marc.

-- 
Thanks,
Oliver
