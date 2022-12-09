Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA02647F2B
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 09:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiLIIYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 03:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiLIIYa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 03:24:30 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B9651C37
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 00:24:29 -0800 (PST)
Date:   Fri, 9 Dec 2022 09:24:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670574267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Ujz0yDFlzjy73eRFThISN+4ybbqpoYq14hTZV0v3A8=;
        b=X1tn0ibWUZ9h8j6sycvZQrHaBQ/KIgXvJq3J+tF/hK7yE9U1924sn4kaJn5IdxS8U+CH+l
        erTziAmwd8ZLP3fbSUZwztsRMog4NkcuIVZXe4ICqNhgLLBqlAQtn9e7R1qii1iIV8nEVQ
        AhmX6RPI+5XaqXe6KdrIDjh2oMrc7V8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/7] KVM: selftests: Fixes for ucall pool +
 page_fault_test
Message-ID: <20221209082423.yideydkw6ig6x5zg@kamzik>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209015307.1781352-1-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 01:52:59AM +0000, Oliver Upton wrote:
> The combination of the pool-based ucall implementation + page_fault_test
> resulted in some 'fun' bugs. As has always been the case, KVM selftests
> is a house of cards.
> 
> Small series to fix up the issues on kvm/queue. Patches 1-2 can probably
> be squashed into Paolo's merge resolution, if desired.
> 
> Tested on Ampere Altra and a Skylake box, since there was a decent
> amount of munging in architecture-generic code.
> 
> v1 -> v2:
>  - Collect R-b from Sean (thanks!)
>  - Use a common routine for split and contiguous VA spaces, with
>    commentary on why arm64 is different since we all get to look at it
>    now. (Sean)
>  - Don't identity map the ucall MMIO hole
>  - Fix an off-by-one issue in the accounting of virtual memory,
>    discovered in fighting with #2
>  - Fix an infinite loop in ucall_alloc(), discovered fighting with the
>    ucall_init() v. kvm_vm_elf_load() ordering issue
> 
> Mark Brown (1):
>   KVM: selftests: Fix build due to ucall_uninit() removal
> 
> Oliver Upton (6):
>   KVM: selftests: Setup ucall after loading program into guest memory
>   KVM: selftests: Mark correct page as mapped in virt_map()
>   KVM: selftests: Correctly initialize the VA space for TTBR0_EL1
>   KVM: arm64: selftests: Don't identity map the ucall MMIO hole
>   KVM: selftests: Allocate ucall pool from MEM_REGION_DATA
>   KVM: selftests: Avoid infinite loop if ucall_alloc() fails
> 
>  .../selftests/kvm/aarch64/page_fault_test.c   |  9 +++-
>  .../selftests/kvm/include/kvm_util_base.h     |  1 +
>  .../testing/selftests/kvm/lib/aarch64/ucall.c |  6 ++-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 53 ++++++++++++++++---
>  .../testing/selftests/kvm/lib/ucall_common.c  | 14 +++--
>  5 files changed, 68 insertions(+), 15 deletions(-)
> 
> 
> base-commit: 89b2395859651113375101bb07cd6340b1ba3637

This commit doesn't seem to exist linux-next or kvm/queue, but the patch
context seems to match up with linux-next pretty well. Anyway,

For the series

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew
