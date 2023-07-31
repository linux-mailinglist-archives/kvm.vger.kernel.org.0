Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84895769D97
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 19:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbjGaRDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 13:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbjGaRDH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 13:03:07 -0400
Received: from out-127.mta1.migadu.com (out-127.mta1.migadu.com [IPv6:2001:41d0:203:375::7f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7C8173F
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 10:02:55 -0700 (PDT)
Date:   Mon, 31 Jul 2023 10:02:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690822973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q4aDTEIrJywenjhfbG8yboiQILyqizo5vlKZ1bSMxlk=;
        b=gGEekKkQTDUSJrfZjaiI5kxTm4QtmjLE9qRIi8zD74QBW08ItkmnOBzN9t9TYgvhxW2vdd
        MQy6dVizpNWkbduvGm4ht1x9B9O12x4NLAALd8jhm0BDdErG38hyDDR4ttw4boCOxtm7ZK
        nZTAuEWk2big1Lmd3mXwrUZt7iiRFlE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 14/26] KVM: arm64: nv: Add trap forwarding
 infrastructure
Message-ID: <ZMfpN4nTEBpbvHBc@linux.dev>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-15-maz@kernel.org>
 <ZMQJ+7VPbGVnz0kP@linux.dev>
 <87fs57qdm2.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fs57qdm2.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 29, 2023 at 10:19:17AM +0100, Marc Zyngier wrote:
> On Fri, 28 Jul 2023 19:33:31 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > Correct me if I'm wrong, but I don't think the compiler is going to
> > whine if any of these bitfields are initialized with a larger value than
> > can be represented... Do you think some BUILD_BUG_ON() is in order to
> > ensure that trap_group fits in ::cgt?
> > 
> > 	BUILD_BUG_ON(__NR_TRAP_IDS__ >= BIT(10));
> 
> Indeed. This might also apply to ::fgt, and I want to add some sanity
> checks to verify that the whole union isn't larger than a 'void *', as
> we rely on that.

Agreed on both.

> > > +/*
> > > + * Map encoding to trap bits for exception reported with EC=0x18.
> > > + * These must only be evaluated when running a nested hypervisor, but
> > > + * that the current context is not a hypervisor context. When the
> > > + * trapped access matches one of the trap controls, the exception is
> > > + * re-injected in the nested hypervisor.
> > > + */
> > > +static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
> > > +};
> > > +
> > > +static DEFINE_XARRAY(sr_forward_xa);
> > > +
> > > +static union trap_config get_trap_config(u32 sysreg)
> > > +{
> > > +	return (union trap_config) {
> > > +		.val = xa_to_value(xa_load(&sr_forward_xa, sysreg)),
> > > +	};
> > 
> > Should we be checking for NULL here? AFAICT, the use of sentinel values
> > in the trap_group enum would effectively guarantee each trap_config has
> > a nonzero value.
> 
> if xa_load() returns NULL, xa_to_value() will still give us a 0, which
> is an indication of a sysreg that isn't present in the trap
> configuration. This can happen if we trap something that isn't yet
> supported in NV, which is quite common. This allows us to use features
> on the host without having to immediately write the same support for
> NV guests.

That's fine by me, I couldn't piece it together where a value of 0 is
explicitly handled as having no trap config.

> But this is obviously a temporary situation. At some point, I'll
> become a total bastard and demand that people treat NV as a first
> class citizen. One day ;-).

No time like the present!

--
Thanks,
Oliver
