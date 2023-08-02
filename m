Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6129A76D4AA
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 19:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbjHBRFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 13:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbjHBRFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 13:05:09 -0400
Received: from out-84.mta0.migadu.com (out-84.mta0.migadu.com [91.218.175.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D362D6A
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 10:04:52 -0700 (PDT)
Date:   Wed, 2 Aug 2023 17:04:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690995878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WJgiPi3z5fgU4lTzUcaeihvoVV4/arRmDPqFGrxctos=;
        b=fkFkihM77h5zK99tash/Nlp41RcOozNnYYf++vLojGZDRyhHUYuWTDI7P5D79nJdokZhbq
        ZKcshmP9FPi6MpXqE6SJ4MyX+U8ZZawvQbvkh3bH5uacL3SUvpPWaMJTsSlHQy9Le9cSxl
        fYGgLtGp6N2nBXN+lITPi+y6pHfmvyA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v7 01/10] KVM: arm64: Allow userspace to get the writable
 masks for feature ID registers
Message-ID: <ZMqMofRCmB14XUZr@linux.dev>
References: <20230801152007.337272-1-jingzhangos@google.com>
 <20230801152007.337272-2-jingzhangos@google.com>
 <ZMmdnou5Pk/9V1Gs@linux.dev>
 <CAAdAUtj-6tk53TE6p0TYBfmFghj94g+Sg2KK_80Gar18kJ=5OA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAdAUtj-6tk53TE6p0TYBfmFghj94g+Sg2KK_80Gar18kJ=5OA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023 at 08:55:43AM -0700, Jing Zhang wrote:
> > > +#define ARM64_FEATURE_ID_SPACE_SIZE  (3 * 8 * 8)
> > > +
> > > +struct feature_id_writable_masks {
> > > +     __u64 mask[ARM64_FEATURE_ID_SPACE_SIZE];
> > > +};
> >
> > This UAPI is rather difficult to extend in the future. We may need to
> > support describing the masks of multiple ranges of registers in the
> > future. I was thinking something along the lines of:
> >
> >         enum reg_mask_range_idx {
> >                 FEATURE_ID,
> >         };
> >
> >         struct reg_mask_range {
> >                 __u64 idx;
> >                 __u64 *masks;
> >                 __u64 rsvd[6];
> >         };
> >
> Since have the way to map sysregs encoding to the index in the mask
> array, we can extend the UAPI by just adding a size field in struct
> feature_id_writable_masks like below:
> struct feature_id_writable_masks {
>          __u64 size;
>          __u64 mask[ARM64_FEATURE_ID_SPACE_SIZE];
> };
> The 'size' field can be used as input for the size of 'mask' array and
> output for the number of masks actually read in.
> This way, we can freely add more ranges without breaking anything in userspace.
> WDYT?

Sorry, 'index' is a bit overloaded in this context. The point I was
trying to get across is that we might want to describe a completely
different range of registers than the feature ID registers in the
future. Nonetheless, we shouldn't even presume the shape of future
extensions to the ioctl.

	struct reg_mask_range {
		__u64 addr;	/* pointer to mask array */
		__u64 rsvd[7];
	};

Then in KVM we should require ::rsvd be zero and fail the ioctl
otherwise.

-- 
Thanks,
Oliver
