Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2557F62402B
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 11:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiKJKm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 05:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiKJKmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 05:42:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13F7B7ED
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 02:42:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DCF061233
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 10:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25F6C433D7;
        Thu, 10 Nov 2022 10:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668076941;
        bh=r+qt6kAors3KYeKH/GVRE9wZe3RSl+L32qhSytiS8Bk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eSp07hYtumWj2FerpC9vH+x5PZLqC8d5feD+U9WC4WPn85pMm4fhLJ3zTp5DzdVWK
         bNt0NNT9T1tzqYGdQ+FFRYrdSiXkmTR/CHowxVjTogFw9KRQMFq1nV7a1eT5QuPYC0
         W409e7B+YYgBDK9de6SpCMq7aoLNCN2HIzBdE2vBjGuqHH2Ut+OFBwc1tH36WIV3UT
         Cs4fbzqegdE5AJl/dNzIzOFDaRCWCTe79BWO//6i3J9VNI4Z9tfP5Nm8EMACCllStA
         tM3P/oKuI0adtPUXxiPjEjmDugWUgZL1NEk9E81xjHRnyrgEddM0L4tpw+urnF5iCs
         Kq+bbIW9YQEdg==
Date:   Thu, 10 Nov 2022 10:42:15 +0000
From:   Will Deacon <will@kernel.org>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Quentin Perret <qperret@google.com>,
        kvmarm@lists.linux.dev, Fuad Tabba <tabba@google.com>,
        Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Clean out the odd handling of
 completer_addr
Message-ID: <20221110104215.GA26282@willie-the-truck>
References: <20221028083448.1998389-1-oliver.upton@linux.dev>
 <20221028083448.1998389-2-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028083448.1998389-2-oliver.upton@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Fri, Oct 28, 2022 at 08:34:47AM +0000, Oliver Upton wrote:
> The layout of struct pkvm_mem_transition is a bit weird; the destination
> address for the transition is actually stashed in the initiator address
> context. Even weirder so, that address is thrown inside a union and
> return from helpers by use of an out pointer.
> 
> Rip out the whole mess and move the destination address into the
> destination context sub-struct. No functional change intended.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 70 ++++++++++-----------------
>  1 file changed, 25 insertions(+), 45 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 1e78acf9662e..3636a24e1b34 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -393,17 +393,12 @@ struct pkvm_mem_transition {
>  		enum pkvm_component_id	id;
>  		/* Address in the initiator's address space */
>  		u64			addr;
> -
> -		union {
> -			struct {
> -				/* Address in the completer's address space */
> -				u64	completer_addr;
> -			} host;
> -		};
>  	} initiator;
>  
>  	struct {
>  		enum pkvm_component_id	id;
> +		/* Address in the completer's address space */
> +		u64			addr;
>  	} completer;
>  };

I'm reasonably sure we'll end up putting this back like we had it as we gain
support for guest-initiatied transitions, where we have to walk the guest
stage-2 page-table to figure out the physical address of the memory being
shared, which is the host (completer's) IPA thanks to the identity mapping
there.

So here's what I'll do: I'll post a v6 of the EL2 state series, and I'll
include this at the end (before the RFC patch) and let Marc decide whether
to go ahead with it. I do agree that it cleans things up for now but, as
above, I think that's likely to be a short-lived change.

Sound reasonable?

Cheers,

Will
