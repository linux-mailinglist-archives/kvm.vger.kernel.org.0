Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553EC5BE168
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 11:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiITJHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 05:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiITJHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 05:07:22 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E7F6D558
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 02:05:14 -0700 (PDT)
Date:   Tue, 20 Sep 2022 11:05:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663664713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Lic4VqJwH8G8xBgMbRztRy4JLPWsDMcumTEkF8Sc/kM=;
        b=jGmrSCsCaVmNO+MuboYs+bgPKEDUBpGga9UeiCmENxDIxI3OFkePgZR8olCIO0iNZkM1Tl
        5ikd1/voQogkfj2OsRI5jcoVKF01zNaKATWENDqE5RcQGviWNq5EslIGHxLjBQv+JwBOF7
        4tnukEg09KWms2G0caw7FTIVy8o3jZw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 08/19] arm/arm64: Use pgd_alloc() to
 allocate mmu_idmap
Message-ID: <20220920090512.2633rhzqt62frxdn@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-9-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-9-alexandru.elisei@arm.com>
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

On Tue, Aug 09, 2022 at 10:15:47AM +0100, Alexandru Elisei wrote:
> Until commit 031755dbfefb ("arm: enable vmalloc"), the idmap was allocated
> using pgd_alloc(). After that commit, all the page table allocator
> functions were switched to using the page allocator, but pgd_alloc() was
> left unchanged and became unused, with the idmap now being allocated with
> alloc_page().
> 
> For arm64, the pgd table size varies based on the page size, which is
> configured by the user. For arm, it will always contain 4 entries (it
> translates bits 31:30 of the input address). To keep things simple and
> consistent with the other functions and across both architectures, modify
> pgd_alloc() to use alloc_page() instead of memalign like the rest of the
> page table allocator functions and use it to allocate the idmap.
> 
> Note that when the idmap is created, alloc_ops->memalign is
> memalign_pages() which allocates memory with page granularity. Using
> memalign() as before would still have allocated a full page.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/asm/pgtable.h   | 4 ++--
>  lib/arm/mmu.c           | 4 ++--
>  lib/arm64/asm/pgtable.h | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
