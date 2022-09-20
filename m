Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5047D5BE238
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 11:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiITJkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 05:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiITJkD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 05:40:03 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707C514D00
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 02:39:59 -0700 (PDT)
Date:   Tue, 20 Sep 2022 11:39:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663666797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7dNROyoxS+g3hHfCHA0pUmuMDvUdin/kdGo/Zdh4wHQ=;
        b=v8o2BsttYYNeFs2fJPrLnNZu5NubYl4wo6Cn3DwPe9sFXkE4zh9amzOnksQlmGPttjShY7
        FF7o/ChkRR4Hf0cjN0Bb+2T7XvGQz555K2Sfk2r+HGIQmgER4GPDmF5H+77/rzAhcgKJqv
        iDXxoR/FsQeO7MFFcw/a/b9PDBtToRA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 13/19] arm: page.h: Add missing
 libcflat.h include
Message-ID: <20220920093956.sh4lunjssia376gf@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-14-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220809091558.14379-14-alexandru.elisei@arm.com>
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


I guess this should be squashed into one of the early patches in this
series since we don't have this issue with the current code.

Thanks,
drew


On Tue, Aug 09, 2022 at 10:15:52AM +0100, Alexandru Elisei wrote:
> Include libcflat from page.h to avoid error like this one:
> 
> /path/to/kvm-unit-tests/lib/asm/page.h:19:9: error: unknown type name ‘u64’
>    19 | typedef u64 pteval_t;
>       |         ^~~
> [..]
> /path/to/kvm-unit-tests/lib/asm/page.h:47:8: error: unknown type name ‘phys_addr_t’
>    47 | extern phys_addr_t __virt_to_phys(unsigned long addr);
>       |        ^~~~~~~~~~~
>       |                                     ^~~~~~~~~~~
> [..]
> /path/to/kvm-unit-tests/lib/asm/page.h:50:47: error: unknown type name ‘size_t’
>    50 | extern void *__ioremap(phys_addr_t phys_addr, size_t size);
> 
> The arm64 version of the header already includes libcflat since commit
> a2d06852fe59 ("arm64: Add support for configuring the translation
> granule").
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/asm/page.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/lib/arm/asm/page.h b/lib/arm/asm/page.h
> index 8eb4a883808e..0a46bda018c7 100644
> --- a/lib/arm/asm/page.h
> +++ b/lib/arm/asm/page.h
> @@ -8,6 +8,8 @@
>  
>  #include <linux/const.h>
>  
> +#include <libcflat.h>
> +
>  #define PAGE_SHIFT		12
>  #define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
>  #define PAGE_MASK		(~(PAGE_SIZE-1))
> -- 
> 2.37.1
> 
