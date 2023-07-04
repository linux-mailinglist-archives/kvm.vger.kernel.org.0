Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935D774760B
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 18:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbjGDQEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 12:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbjGDQEG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 12:04:06 -0400
Received: from out-28.mta1.migadu.com (out-28.mta1.migadu.com [95.215.58.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419D3E49
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 09:04:02 -0700 (PDT)
Date:   Tue, 4 Jul 2023 09:04:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688486639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xg1CxT90wNmSWa/vx8SW5k6nUJUgbxG4tgKxda7745o=;
        b=uaRPw79dm4tUwP/VcgTH/hskZNj+VzcQJ36RKXDXu0TGH2w7ty2bSyzUxwCF/MEH22YRL7
        l8Wjxr9kN+IOFC1wPh7SbH0PJiTzddIGLKylgFpABhbXVZ6ot1UsqNrRfBhmyc3v2pUPSh
        VyxXFHDBJClzHSI1N8Ie+KOtCG/u80Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v4 1/4] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
Message-ID: <ZKRC80hb4hXwW8WK@thinky-boi>
References: <20230607194554.87359-1-jingzhangos@google.com>
 <20230607194554.87359-2-jingzhangos@google.com>
 <ZJm+Kj0C5YySp055@linux.dev>
 <874jmjiumh.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874jmjiumh.fsf@redhat.com>
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

Hi Cornelia,

On Tue, Jul 04, 2023 at 05:06:30PM +0200, Cornelia Huck wrote:
> On Mon, Jun 26 2023, Oliver Upton <oliver.upton@linux.dev> wrote:
> 
> > On Wed, Jun 07, 2023 at 07:45:51PM +0000, Jing Zhang wrote:
> >> +	brps = FIELD_GET(ID_AA64DFR0_EL1_BRPs_MASK, val);
> >> +	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs_MASK, val);
> >> +	if (ctx_cmps > brps)
> >> +		return -EINVAL;
> >> +
> >
> > I'm not fully convinced on the need to do this sort of cross-field
> > validation... I think it is probably more trouble than it is worth. If
> > userspace writes something illogical to the register, oh well. All we
> > should care about is that the advertised feature set is a subset of
> > what's supported by the host.
> >
> > The series doesn't even do complete sanity checking, and instead works
> > on a few cherry-picked examples. AA64PFR0.EL{0-3} would also require
> > special handling depending on how pedantic you're feeling. AArch32
> > support at a higher exception level implies AArch32 support at all lower
> > exception levels.
> >
> > But that isn't a suggestion to implement it, more of a suggestion to
> > just avoid the problem as a whole.
> 
> Generally speaking, how much effort do we want to invest to prevent
> userspace from doing dumb things? "Make sure we advertise a subset of
> features of what the host supports" and "disallow writing values that
> are not allowed by the architecture in the first place" seem reasonable,
> but if userspace wants to create weird frankencpus[1], should it be
> allowed to break the guest and get to keep the pieces?

What I'm specifically objecting to is having KVM do sanity checks across
multiple fields. That requires explicit, per-field plumbing that will
eventually become a tangled mess that Marc and I will have to maintain.
The context-aware breakpoints is one example, as is ensuring SVE is
exposed iff FP is too. In all likelihood we'll either get some part of
this wrong, or miss a required check altogether.

Modulo a few exceptions to this case, I think per-field validation is
going to cover almost everything we're worried about, and we get that
largely for free from arm64_check_features().

> I'd be more in favour to rely on userspace to configure something that
> is actually usable; it needs to sanitize any user-provided configuration
> anyway.

Just want to make sure I understand your sentiment here, you'd be in
favor of the more robust sanitization?

> [1] I think userspace will end up creating frankencpus in any case, but
> at least it should be the kind that doesn't look out of place in the
> subway if you dress it in proper clothing.

I mean, KVM already advertises a frankencpu in the first place, so we're
off to a good start :)

--
Thanks,
Oliver
