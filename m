Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324B260454F
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 14:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbiJSMbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 08:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbiJSMb0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 08:31:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6332C157F48
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 05:09:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ED8760A5F
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 11:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FE8C433C1;
        Wed, 19 Oct 2022 11:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666180651;
        bh=7dYUeVMl0ljljG/gREOSgn67ek1PhgEFY91pBBbAxwg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FhjdSpJQ8uYcQJVX7CfVuAb3mQh4YGQqss/P9iO096UxFvlaBpt8TtUeMiQUKr+3V
         WcUM4gQVr2OqxxwGV+nwGWU1ZUqiu92l79qBkuCNdrrbvSCqvNdfkhpRDyRQswyL1B
         3ZyDIN8dqx/moSdaMaGnzcc4cQHPozAtsWQDz3qO5yqJGPucL/QQlP4z62H94vEfum
         r4OdzPOlDTUErlKTnWVSfvak8jI3ThyYwH6Lh5QOp7zHuwqS9nhH4IRGLvrJzaVPXb
         PV6CJdmI8XxYHpt1OdJwfLfz0CqX98/5bA8mOa5ruSs1z+O5VCtfA1O6YRa011A240
         /qdl2LNThAvjA==
Date:   Wed, 19 Oct 2022 12:57:24 +0100
From:   Will Deacon <will@kernel.org>
To:     Quentin Perret <qperret@google.com>
Cc:     kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 12/25] KVM: arm64: Add infrastructure to create and
 track pKVM instances at EL2
Message-ID: <20221019115723.GA4067@willie-the-truck>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-13-will@kernel.org>
 <Y07VaRwVf3McX27a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y07VaRwVf3McX27a@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 18, 2022 at 04:33:45PM +0000, Quentin Perret wrote:
> On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> > +void pkvm_hyp_vm_table_init(void *tbl)
> > +{
> > +	WARN_ON(vm_table);
> > +	vm_table = tbl;
> > +}
> 
> Uh, why does this one need to be exposed outside pkvm.c ?

We need to initialise the table using the memory donated by the host
on the __pkvm_init path. That's all private to nvhe/setup.c, so rather
than expose the raw pointers (of either the table or the donated memory),
we've got this initialisation function instead which is invoked by
__pkvm_init_finalise() on the deprivilege path.

Happy to repaint it if you have a patch?

Will
