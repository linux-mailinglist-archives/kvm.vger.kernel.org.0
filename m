Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C655B5BE22E
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 11:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiITJhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 05:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiITJho (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 05:37:44 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465A760523
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 02:37:42 -0700 (PDT)
Date:   Tue, 20 Sep 2022 11:37:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663666660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SyFC0KJGAwjjfK8g+X0MjVckVUVCJL+c1Ewito/NJAg=;
        b=pFVXVy6ygSWbbhZG0Fq6o4wfNZ682N7xfolZ2zGOta6IHVnBOrVq1KV+AM76LrwbYniXwg
        1AmcNm/1bF4UOTqTVXnlwEsda0m4p3iFqx65k5x8BgAJn6twYK3hgkNg7Sf+ybYkfLMcXl
        cqWYbNwUydxPvYkRN7b+DkT3dTqghC4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 12/19] arm/arm64: assembler.h: Replace
 size with end address for dcache_by_line_op
Message-ID: <20220920093739.owclltsryhpxkh6h@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-13-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-13-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 09, 2022 at 10:15:51AM +0100, Alexandru Elisei wrote:
> Commit b5f659be4775 ("arm/arm64: Remove dcache_line_size global
> variable") moved the dcache_by_line_op macro to assembler.h and changed
> it to take the size of the regions instead of the end address as
> parameter. This was done to keep the file in sync with the upstream
> Linux kernel implementation at the time.
> 
> But in both places where the macro is used, the code has the start and
> end address of the region, and it has to compute the size to pass it to
> dcache_by_line_op. Then the macro itsef computes the end by adding size
> to start.
> 
> Get rid of this massaging of parameters and change the macro to the end
> address as parameter directly.
> 
> Besides slightly simplyfing the code by remove two unneeded arithmetic
> operations, this makes the macro compatible with the current upstream
> version of Linux (which was similarly changed to take the end address in
> commit 163d3f80695e ("arm64: dcache_by_line_op to take end parameter
> instead of size")), which will allow us to reuse (part of) the Linux C
> wrappers over the assembly macro.
> 
> The change has been tested with the same snippet of code used to test
> commit 410b3bf09e76 ("arm/arm64: Perform dcache clean + invalidate after
> turning MMU off").
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/cstart.S              |  1 -
>  arm/cstart64.S            |  1 -
>  lib/arm/asm/assembler.h   | 11 +++++------
>  lib/arm64/asm/assembler.h | 11 +++++------
>  4 files changed, 10 insertions(+), 14 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
