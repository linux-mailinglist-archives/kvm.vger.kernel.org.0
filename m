Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD467C5965
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 18:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbjJKQn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 12:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbjJKQnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 12:43:25 -0400
Received: from out-205.mta1.migadu.com (out-205.mta1.migadu.com [95.215.58.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1BAA4
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 09:43:23 -0700 (PDT)
Date:   Wed, 11 Oct 2023 16:43:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697042602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W5lOz35M0x1aN2ysT8ZX9nxH+qHqZrHg933+lted7Yk=;
        b=NFolT7SQWnRYnQepsthcPuiyATqHBgCcNZXqHbOKimGiOGTnYkFFfNXdysdtNYqaVtEPHI
        el9MaHHAZbCw8+pKn7XFv76rQP/vrnmdhO6u4WsuMCqKPMmTW3OU7Yx3CqgNl8Pg9l92pL
        EgH1ry7d7mCRRSF/00mRb+hS3GbQn9w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        James Clark <james.clark@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Disallow vPMU for NV guests
Message-ID: <ZSbQpJADvMOHgs3A@linux.dev>
References: <20231011081649.3226792-1-oliver.upton@linux.dev>
 <20231011081649.3226792-2-oliver.upton@linux.dev>
 <281b88c0d74b9260b659e6be579a4984@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <281b88c0d74b9260b659e6be579a4984@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 04:54:49PM +0100, Marc Zyngier wrote:
> On 2023-10-11 09:16, Oliver Upton wrote:
> > The existing PMU emulation code is inadequate for use with nested
> > virt. Disable the feature altogether with NV until the hypervisor
> > controls are handled correctly.
> 
> Could you at least mention *what* is missing? Most of the handling
> should identical, and the couple of bits what would need to be
> handled (such as MDCR_EL2) are not covered by this disabling.

Heh, I could've spelled it out a bit more :)

The part that caught my attention is that we don't honor the NSH bit
(hence the next patch), and doing that correctly isn't going to be
trivial. In cases where event filtering is mismatched between vEL2
and EL1 I think we need to reprogram the associated perf events on
nested transitions. We could probably optimize this by using two sets of
perf events to make the switch a bit faster, but that's beside the
point.

Looks like MDCR_EL2.{HPMN,HPME} aren't handled yet either. These are all
easy enough to work on (and my interest is certainly piqued), but it
seems to me PMU+NV isn't going to work out of the gate. It'd be nice to
permit the combination only when we're confident the feature is
complete.

I haven't any strong opinions here though, and you're the one carrying
the whole NV pile in the first place. Up to you what to do here.

-- 
Thanks,
Oliver
