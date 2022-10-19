Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61275604638
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 15:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiJSNCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 09:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiJSNCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 09:02:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4C91BE91E
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 05:45:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66E69B8226D
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 12:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BDDC433D6;
        Wed, 19 Oct 2022 12:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666183483;
        bh=rhpWY7O0NQoBza1n1SpZHiZbXLW4xC6Pj2/Iz8lNLpM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kYFIGw0Bnwks1cn+rqik2vs8XaJxuEP9taOpstfraaTKvFBqXKvlXqZuwXjihv8fR
         Qa/RdkogYTG3MdYA//0X5LrjioyWQntYxEeAs1dPfPRTe6fjeuUBj/9Z28ZHCDluZj
         9RoaLumJpjfGABVo/H3+pJU4mbQnYT17F2cOV6AVTOCQqLDmx+x2J7OGFhrG4Edkwr
         eEkcNUa2p20uM48Zft9pweaPwiBsbcNYvyqwmir158/9e9Z3sJK5baPTwxQ3lJSsnY
         b7ECEKmeTXgaCqq1eDqT9sv1uqSVhitGo6yazsuUdf+sj9WQIL4ek2rrNkexNInpqu
         g/P2RoQRLAg3w==
Date:   Wed, 19 Oct 2022 13:44:36 +0100
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
Message-ID: <20221019124435.GB4220@willie-the-truck>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-13-will@kernel.org>
 <Y07W63YlwZ6yClOi@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y07W63YlwZ6yClOi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 18, 2022 at 04:40:11PM +0000, Quentin Perret wrote:
> On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> > +static void *map_donated_memory_noclear(unsigned long host_va, size_t size)
> > +{
> > +	void *va = (void *)kern_hyp_va(host_va);
> > +
> > +	if (!PAGE_ALIGNED(va))
> > +		return NULL;
> > +
> > +	if (__pkvm_host_donate_hyp(hyp_virt_to_pfn(va),
> > +				   PAGE_ALIGN(size) >> PAGE_SHIFT))
> > +		return NULL;
> > +
> > +	return va;
> > +}
> > +
> > +static void *map_donated_memory(unsigned long host_va, size_t size)
> > +{
> > +	void *va = map_donated_memory_noclear(host_va, size);
> > +
> > +	if (va)
> > +		memset(va, 0, size);
> > +
> > +	return va;
> > +}
> > +
> > +static void __unmap_donated_memory(void *va, size_t size)
> > +{
> > +	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(va),
> > +				       PAGE_ALIGN(size) >> PAGE_SHIFT));
> > +}
> > +
> > +static void unmap_donated_memory(void *va, size_t size)
> > +{
> > +	if (!va)
> > +		return;
> > +
> > +	memset(va, 0, size);
> > +	__unmap_donated_memory(va, size);
> > +}
> > +
> > +static void unmap_donated_memory_noclear(void *va, size_t size)
> > +{
> > +	if (!va)
> > +		return;
> > +
> > +	__unmap_donated_memory(va, size);
> > +}
> 
> Nit: I'm not a huge fan of the naming here, these do more than just
> map/unmap random pages. This only works for host pages, the donation
> path has permission checks, etc. Maybe {admit,return}_host_memory()?

Hmm, so I made this change locally and I found return_host_memory() to be
really hard to read, particularly on error paths where we 'goto' an error
label and have calls to 'return_host_memory' before an actual 'return'
statement.

So I've left as-is, not because I'm tied to the existing names, but because
I did struggle with your suggestion. At the end of the day, these are static
functions so it's really easy to change the name later on if we can think
of something better.

Will
