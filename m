Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A97472FEE4
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 14:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244578AbjFNMmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 08:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235769AbjFNMmI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 08:42:08 -0400
Received: from out-33.mta1.migadu.com (out-33.mta1.migadu.com [IPv6:2001:41d0:203:375::21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA38A137
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 05:41:59 -0700 (PDT)
Date:   Wed, 14 Jun 2023 12:41:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686746518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vVgohHr+8y/naKxQ8awxRJilZdLTVuzyEw7fAcdG64A=;
        b=vXtoWCWGoWUj4X5qVEdoEmWU3Lyx+lZaNsCO4a9ZC729SBpKTdzHAGvXWIq1eE6BaF+f5C
        I3pxRCZKlinyC6IeKMy0sqHImLvoZTu17N/DA0fxQBR4wOWyX1CWIFKgz0mI3m8GDtNr7l
        D7Q2U/q5bDPVLB5U2ddsJl1pTPLiTaI=
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
Message-ID: <ZIm1kdFBfXYMdfbV@linux.dev>
References: <20230610194510.4146549-1-reijiw@google.com>
 <ZIUb/ozyloOm6DfY@linux.dev>
 <20230611045430.evkcp4py4yuw5qgr@google.com>
 <ZIV7+yKUdRticwfF@linux.dev>
 <20230611160105.orvjohigsaevkcrf@google.com>
 <ZIdzxmgt8257Kv09@linux.dev>
 <20230613002633.gdttlmn5bnkr4l5i@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613002633.gdttlmn5bnkr4l5i@google.com>
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

On Mon, Jun 12, 2023 at 05:26:33PM -0700, Reiji Watanabe wrote:
> On Mon, Jun 12, 2023 at 09:36:38PM +0200, Oliver Upton wrote:
> > I'd rather we start exposing the feature when we provide all the
> > necessary detail.
> 
> To confirm, are you suggesting to stop exposing the event even on hosts
> w/o PMMIR_EL1 until KVM gets ready to support PMMIR_EL1 ?
> (guests on those hosts won't get PMMIR_EL1 in any case though?)
> Could you please explain why ?
> 
> Perhaps I think I would rather keep the code as it is?
> (since I'm simply not sure what would be the benefits of that)

I'd rather not keep confusing code hanging around. The fact that KVM
does not support the STALL_SLOTS event is invariant of both the hardware
PMU implementation and the userspace value for the ID register field.
Let's make sure the implementation exactly matches this position.

-- 
Thanks,
Oliver
