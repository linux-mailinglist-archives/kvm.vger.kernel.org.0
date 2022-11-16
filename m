Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C72862B4CB
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 09:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238436AbiKPIP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 03:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238521AbiKPIPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 03:15:02 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA54F10553;
        Wed, 16 Nov 2022 00:14:24 -0800 (PST)
Date:   Wed, 16 Nov 2022 08:14:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668586463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SmFKdEdkwEAGGvbba+Uew4TFmYCA4I8/v/XU6v8w0iw=;
        b=EiQC3QrF9TRB/NYfKenXrf+k5M2yFh3QICvTBjAHp2S2AgBjJTR7+0EESbrJW9MZnTM2ku
        HalxstlcPjFrhMFiUG6PeC1w/Rn21yzoE6U8m4RxGK2nKHc8gl9WjePXjwLsyGfzBN/HBd
        WcAO9UckNtb5AMRTHW2N9kDIujgjrjQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] KVM: arm64: Don't acquire RCU read lock for exclusive
 table walks
Message-ID: <Y3Sb20U9rCIuOU3L@google.com>
References: <20221115225502.2240227-1-oliver.upton@linux.dev>
 <868rkbppdq.wl-maz@kernel.org>
 <Y3SQ3wogsVUEu1Qe@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3SQ3wogsVUEu1Qe@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022 at 07:27:27AM +0000, Oliver Upton wrote:
> On Wed, Nov 16, 2022 at 03:08:49AM +0000, Marc Zyngier wrote:
> > I'm not crazy about this sort of parameters. I think it would make a
> > lot more sense to pass a pointer to the walker structure and do the
> > flag check inside the helper.
> > 
> > That way, we avoid extra churn if/when we need extra state or
> > bookkeeping around the walk.
> 
> Sure, let's go that way instead. v3 on the way lol :)

Well, going this route is going to require hoisting around a few things.

I'd very much prefer to keep the RCU indirection ifdeffery all in one
place, but I'll need to haul it all after the definitions of kvm_pgtable_walker
and kvm_pgtable_walk_flags but before the definition of kvm_pgtable
(as it needs kvm_pteref_t).

I'm not too bothered by it, but not quite as small of a bandaid this
time around.

--
Thanks,
Oliver
