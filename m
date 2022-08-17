Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3EBC5972CD
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 17:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240830AbiHQPOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 11:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240825AbiHQPOI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 11:14:08 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFA427CCF
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 08:14:05 -0700 (PDT)
Date:   Wed, 17 Aug 2022 10:13:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660749243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0KoI88G6WAT+dF0R8d2w0z0ihjudvGquq4fyy5BlDxA=;
        b=bC7pAGwUhbwJREU6OOPWUXVPcGn4K1p31sgeWCKmiRFXP/z/Kke3Uz9btvJQ3pdSG4NgID
        b9CDN9fVg71X61ZML1rPm7X052YgxwC5xl3hT8Ybd312An8Z/KOad3BQurFBiiO5yN7t6R
        KYe+W7X7Lquo479RaPgZUy9zGdrNlRM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        suzuki.poulose@arm.com, will@kernel.org
Subject: Re: [PATCH v2 0/2] KVM: arm64: Uphold 64bit-only behavior on
 asymmetric systems
Message-ID: <Yv0Ft0yGVr5H4NVE@google.com>
References: <20220816192554.1455559-1-oliver.upton@linux.dev>
 <87tu6bw5dd.wl-maz@kernel.org>
 <YvzIVo5H21upnaPt@monolith.localdoman>
 <87sflvw32l.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sflvw32l.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 11:56:50AM +0100, Marc Zyngier wrote:
> On Wed, 17 Aug 2022 11:52:06 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi,
> > 
> > On Wed, Aug 17, 2022 at 11:07:10AM +0100, Marc Zyngier wrote:
> > > On Tue, 16 Aug 2022 20:25:52 +0100,
> > > Oliver Upton <oliver.upton@linux.dev> wrote:
> > > > 
> > > > Small series to fix a couple issues around when 64bit-only behavior is
> > > > applied. As KVM is more restrictive than the kernel in terms of 32bit
> > > > support (no asymmetry), we really needed our own predicate when the
> > > > meaning of system_supports_32bit_el0() changed in commit 2122a833316f
> > > > ("arm64: Allow mismatched 32-bit EL0 support").
> > > > 
> > > > Lightly tested as I do not have any asymmetric systems on hand at the
> > > > moment. Attention on patch 2 would be appreciated as it affects ABI.
> > > 
> > > I don't think this significantly affect the ABI, as it is pretty
> > > unlikely that you'd have been able to execute the result, at least on
> > > VM creation (set PSTATE.M=USR, start executing, get the page fault on
> > > the first instruction... bang).
> > > 
> > > You could have tricked it in other ways, but at the end of the day
> > > you're running a broken hypervisor on an even more broken system...

Lol, fair enough. Just wanted to make sure we're all happy with how we
turn the guest into rubble on the other end :)

> > Just FYI, you can create such a system on models, by running two clusters
> > and setting clusterX.max_32bit_el=-1. Or you can have even crazier
> > configurations, where AArch32 support is present on only one cluster, and
> > only for EL0.

Doh! Forgot about the fast model.

--
Thanks,
Oliver
