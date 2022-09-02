Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A977C5AB683
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 18:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbiIBQ27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 12:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236404AbiIBQ25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 12:28:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B7FDAA2E
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 09:28:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D30B61FDB
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 16:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E34C433D6;
        Fri,  2 Sep 2022 16:28:50 +0000 (UTC)
Date:   Fri, 2 Sep 2022 17:28:47 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Peter Collingbourne <pcc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH v3 4/7] arm64: mte: Lock a page for MTE tag initialisation
Message-ID: <YxIvP+a2P0DGIUrA@arm.com>
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-5-pcc@google.com>
 <e72fee25-5ece-76f5-db53-dafa1fef6054@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e72fee25-5ece-76f5-db53-dafa1fef6054@arm.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 02, 2022 at 03:47:33PM +0100, Steven Price wrote:
> On 10/08/2022 20:30, Peter Collingbourne wrote:
> > diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
> > index a78c1db23c68..cd5ad0936e16 100644
> > --- a/arch/arm64/mm/mteswap.c
> > +++ b/arch/arm64/mm/mteswap.c
> > @@ -53,6 +53,9 @@ bool mte_restore_tags(swp_entry_t entry, struct page *page)
> >  	if (!tags)
> >  		return false;
> >  
> > +	/* racing tag restoring? */
> > +	if (!try_page_mte_tagging(page))
> > +		return false;
> >  	mte_restore_page_tags(page_address(page), tags);
> 
> I feel like adding a "set_page_mte_tagged(page);" in here would avoid
> the need for the comments about mte_restore_tags() taking the lock.

Good point. I think I blindly followed the set_bit() places but it makes
sense to move the bit setting to mte_restore_tags().

Thanks for the review.

-- 
Catalin
