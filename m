Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06A76EBB2A
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 22:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjDVUcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Apr 2023 16:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjDVUcM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Apr 2023 16:32:12 -0400
Received: from out-41.mta1.migadu.com (out-41.mta1.migadu.com [95.215.58.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559F1213D
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 13:32:10 -0700 (PDT)
Date:   Sat, 22 Apr 2023 20:32:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682195528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CZJOD9xaW8frMjk5AuArVyQlU/FYeEtl40G/DCpjWD0=;
        b=rnuYe9Uc+sKPcZjfmwOJ7nChAiphNRpJ3OhpsVRo4wbr19ZdtSZuTqsG2wFoIfscNQqllC
        4dn2TZxGcuvqcoG7850RVwEInd69jby6WhbZytlrSgl6R3vi6csjetufFTdrrJgbqlJmqQ
        ctiIDaaJ2cMU7CjwH394aNPBNev42Vo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Gavin Shan <gshan@redhat.com>, pbonzini@redhat.com, maz@kernel.org,
        oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com,
        Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH v7 03/12] KVM: arm64: Add helper for creating unlinked
 stage2 subtrees
Message-ID: <ZEREQrqmZeLtgbPw@linux.dev>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-5-ricarkol@google.com>
 <9cb621b0-7174-a7c7-1524-801b06f94e8f@redhat.com>
 <ZEQ+9kyXcQS+1i81@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEQ+9kyXcQS+1i81@google.com>
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

On Sat, Apr 22, 2023 at 01:09:26PM -0700, Ricardo Koller wrote:
> On Mon, Apr 17, 2023 at 02:18:26PM +0800, Gavin Shan wrote:
> > > +	/* .addr (the IPA) is irrelevant for an unlinked table */
> > > +	struct kvm_pgtable_walk_data data = {
> > > +		.walker	= &walker,
> > > +		.addr	= 0,
> > > +		.end	= kvm_granule_size(level),
> > > +	};
> > 
> > The comment about '.addr' seems incorrect. The IPA address is still
> > used to locate the page table entry, so I think it would be something
> > like below:
> > 
> > 	/* The IPA address (.addr) is relative to zero */
> > 
> 
> Extended it to say this:
> 
>          * The IPA address (.addr) is relative to zero. The goal is to
>	   * map "kvm_granule_size(level) - 0" worth of pages.

I actually prefer the original wording, as Gavin's suggestion makes this
comment read as though the IPA of the walk bears some degree of
validity, which it does not.

The intent of the code is to create some *ambiguous* input address
range, so maybe:

	/*
	 * The input address (.addr) is irrelevant for walking an
	 * unlinked table. Construct an ambiguous IA range to map
	 * kvm_granule_size(level) worth of memory.
	 */

-- 
Thanks,
Oliver
