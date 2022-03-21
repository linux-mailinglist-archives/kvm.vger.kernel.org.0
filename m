Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F5F4E2AD4
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 15:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237078AbiCUOeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 10:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349524AbiCUOcn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 10:32:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01095D5F6
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 07:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F34AB8170A
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 14:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7DFC340F3;
        Mon, 21 Mar 2022 14:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647872965;
        bh=9mxvzfFWtwfQLECDMiS80V8FJcePBS2XkbDd8KDSM+k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lnlZmG035UNg/wUBwsfHuA+FG11MDnCCSyE4QbLtZyMbQKsBy0ozovwbulJRIKrzL
         DJxTRRuh6GKrSdWI9BrPe4UuuXwgNy8cfcq96/dDnVMTHx5Z4m5V58xuhI0si67zqJ
         d9lXvq7xOV5jz5BokdAEVb08JhJuX8LsquN7J4PrtJAxf6B7JNGENpfO9vYQwW/aJ6
         478bbvXq4jx835dFass3aCEQVzDS3k0UNJrBFECBmWJiUashwKEDXR6vzeJhLlvA9O
         38TgjuKi1tlgaDbV0L39sKqalluyd91XeG1kpthLF6sX09kLKYF7Hv4UOhxYUsfPr1
         LkqtsH6nvp9pA==
Date:   Mon, 21 Mar 2022 14:29:19 +0000
From:   Will Deacon <will@kernel.org>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fixes for SMC64 SYSTEM_RESET2 calls
Message-ID: <20220321142918.GA11145@willie-the-truck>
References: <20220318193831.482349-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318193831.482349-1-oupton@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 18, 2022 at 07:38:29PM +0000, Oliver Upton wrote:
> This series addresses a couple of issues with how KVM exposes SMC64
> calls to its guest. It is currently possible for an AArch32 guest to
> discover the SMC64 SYSTEM_RESET2 function (via
> PSCI_1_0_FN_PSCI_FEATURES) and even make a call to it. SMCCC does not
> allow for 64 bit calls to be made from a 32 bit state.
> 
> Patch 1 cleans up the way we filter SMC64 calls in PSCI. Using a switch
> with case statements for each possibly-filtered function is asking for
> trouble. Instead, pivot off of the bit that indicates the desired
> calling convention. This plugs the PSCI_FEATURES hole for SYSTEM_RESET2.
> 
> Patch 2 adds a check to the PSCI v1.x call handler in KVM, bailing out
> early if the guest is not allowed to use a particular function. This
> closes the door on calls to 64-bit SYSTEM_RESET2 from AArch32.
> 
> My first crack at this [1] was missing the fix for direct calls to
> SYSTEM_RESET2. Taking the patch out of that series and sending
> separately.
> 
> Applies on top of today's kvmarm pull, commit:
> 
>   21ea45784275 ("KVM: arm64: fix typos in comments")
> 
> [1]: https://patchwork.kernel.org/project/kvm/patch/20220311174001.605719-3-oupton@google.com/
> 
> Oliver Upton (2):
>   KVM: arm64: Generally disallow SMC64 for AArch32 guests
>   KVM: arm64: Actually prevent SMC64 SYSTEM_RESET2 from AArch32
> 
>  arch/arm64/kvm/psci.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)

For both patches:

Acked-by: Will Deacon <will@kernel.org>

Thanks for fixing this!

Will
