Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4452C7BB424
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 11:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbjJFJYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 05:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjJFJYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 05:24:07 -0400
Received: from out-202.mta1.migadu.com (out-202.mta1.migadu.com [95.215.58.202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82229AD
        for <kvm@vger.kernel.org>; Fri,  6 Oct 2023 02:24:05 -0700 (PDT)
Date:   Fri, 6 Oct 2023 09:23:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696584243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/IIKUHbbzngkYROt7CqixZ39/hN2IEvK5vkgRssqWP4=;
        b=ou0KnC/NS++ij5FdnXWPcY/vg/hka++XD9QxMgjybkiETVo8oCDBLw6DbLkx0SbkNrUqYb
        7InXDKX3rtlMW75PGXQuIaOj3bbasBdEM6mrJB6+M0RhzjEJM9kqXGiltjOBRSYd6Jlk1z
        iegGHFDp83BZr8O6QgQcGQpVgjIuTFs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Mark Brown <broonie@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 1/2] tools: arm64: Add a copy of sysreg-defs.h generated
 from the kernel
Message-ID: <ZR_SLyTfkhmdZoXI@linux.dev>
References: <20231005180325.525236-1-oliver.upton@linux.dev>
 <20231005180325.525236-2-oliver.upton@linux.dev>
 <66914631-c2fe-4a20-bfd6-561657cfe8e8@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66914631-c2fe-4a20-bfd6-561657cfe8e8@sirena.org.uk>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 06, 2023 at 01:23:08AM +0100, Mark Brown wrote:
> On Thu, Oct 05, 2023 at 06:03:23PM +0000, Oliver Upton wrote:
> 
> > Wiring up the build infrastructure necessary to generate the sysreg
> > definitions for dependent targets (e.g. perf, KVM selftests) is a bit of
> > an undertaking with near zero benefit. Just take what the kernel
> > generated instead.
> > 
> > Cc: Mark Brown <broonie@kernel.org>
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  tools/arch/arm64/include/asm/sysreg-defs.h | 6806 ++++++++++++++++++++
> >  1 file changed, 6806 insertions(+)
> >  create mode 100644 tools/arch/arm64/include/asm/sysreg-defs.h
> 
> If we're going to go with this approach we should probably script the
> syncing of the generated file and ideally have something that detects if
> there is a generated copy in the main kernel build with differences to
> what's here.  There are regular syncs which I'm guessing are automated
> somehow, and I see that perf has some tooling to notice differences in
> the checked in files alraedy.

Yeah, I see no reason why this can't plug in to the check-headers script
to look at the output from the kernel side of the show.

> That said I'm not 100% clear why this isn't being added to "make
> headers" and/or the perf build stuff?

Isn't 'make headers' just for UAPI headers though? Also, perf is just an
incidental user of this via cputype.h, KVM selftests is what's taking
the direct dependency.

> Surely if perf is happy to peer into the main kernel source it could
> just as well do the generation as part of the build?  There's no great
> obstacle to having a target which runs the generation script that I
> can see.

That'd be less than ideal, IMO. tools maintaining a separate set of kernel
headers from the authoritative source avoids the need to coordinate
changes across kernel and tools. To keep things that way we either need
to copy the script+encoding or the header output. The latter isn't that
bothersome if/when we need an update.

-- 
Thanks,
Oliver
