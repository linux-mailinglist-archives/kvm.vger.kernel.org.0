Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F118C63CA66
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 22:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236974AbiK2VPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 16:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236771AbiK2VP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 16:15:28 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCB823E84;
        Tue, 29 Nov 2022 13:15:26 -0800 (PST)
Date:   Tue, 29 Nov 2022 21:15:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669756525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FtYFpXu5/fa0TaYiI4P0+GO9iWhqJmCXUsHphTqwjGw=;
        b=oE86JcLcGxsicJ5+/muPqhDr7FrTiNs6WD8LcTD34Qo6fvG4ULczduWra99AnJWXD8Xtg0
        garTf7J0LX7RmBFNAhjKicG/NVDNgHM7JNlVsJIgPMT0ZyHg3SMpR3SR8h5DHbZkmS+wfD
        UYYEx/SftPydGa+lK+iguxXp2/OPh14=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: arm64: Don't serialize if the access flag isn't
 set
Message-ID: <Y4Z2aWVEnluy+d3+@google.com>
References: <20221129191946.1735662-1-oliver.upton@linux.dev>
 <20221129191946.1735662-3-oliver.upton@linux.dev>
 <Y4Zw/J3srTsZ57P7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4Zw/J3srTsZ57P7@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

Thanks for having a look.

On Tue, Nov 29, 2022 at 12:52:12PM -0800, Ricardo Koller wrote:
> On Tue, Nov 29, 2022 at 07:19:44PM +0000, Oliver Upton wrote:

[...]

> > +	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> > +				       &pte, NULL, 0);
> > +	if (!ret)
> > +		dsb(ishst);
> 
> At the moment, the only reason for stage2_update_leaf_attrs() to not
> update the PTE is if it's not valid:
> 
> 	if (!kvm_pte_valid(pte))
> 			return 0;
> 
> I guess you could check that as well:
> 
> +	if (!ret || kvm_pte_valid(pte))
> +		dsb(ishst);

Thanks for catching this.

Instead of pivoting on the returned PTE value, how about we return
-EAGAIN from the early return in stage2_attr_walker()? It would better
match the pattern used elsewhere in the pgtable code.

--
Thanks,
Oliver
