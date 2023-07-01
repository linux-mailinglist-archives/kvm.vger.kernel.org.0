Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800B97448D8
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 14:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjGAMUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 08:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjGAMUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 08:20:00 -0400
Received: from out-45.mta0.migadu.com (out-45.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B5C3C05
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 05:19:58 -0700 (PDT)
Date:   Sat, 1 Jul 2023 14:19:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688213997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HZB2bGBkn5d6CHuki+ERtjHGx2S+05KaB+KmuyYenvM=;
        b=nNDx4JgNEClmHgDdJP8DL3JRx5IhV2N1WGvDsOWVDfAwjwvfIDRR+Y/YvT3+9wZtTIVJYP
        IGnzjiomk4ERi26ufTIUFyQzW0UpWsq/LlJiMhpieZWgHEC4cKysm3BKT4LHsE0a4ZQ26D
        YTpIBucGSKIll02+7cfIHAPbAdvXJIU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Nadav Amit <namit@vmware.com>
Subject: Re: [kvm-unit-tests PATCH v3 0/6] arm64: improve debuggability
Message-ID: <20230701-dccaf2ea1b37017f542857ee@orel>
References: <20230628001356.2706-1-namit@vmware.com>
 <20230628001356.2706-2-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230628001356.2706-2-namit@vmware.com>
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

On Wed, Jun 28, 2023 at 12:13:49AM +0000, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> My recent experience in debugging ARM64 tests on EFI was not as fun as I
> expected it to be.
> 
> There were several reasons for that besides the questionable definition
> of "fun":
> 
> 1. ARM64 is not compiled with frame pointers and there is no stack
>    unwinder when the stack is dumped.
> 
> 2. Building an EFI drops the debug information.
> 
> 3. The addresses that are printed on dump_stack() and the use of GDB
>    are hard because taking code relocation into account is non trivial.
> 
> The patches help both ARM64 and EFI for this matter. The image address
> is printed when EFI is used to allow the use of GDB. Symbols are emitted
> into a separate debug file. The frame pointer is included and special
> entry is added upon an exception to allow backtracing across
> exceptions.
> 
> [ PowerPC: Please ack patches 1,2 ]
> [ x86: Please ack patches 1,2,5 ]
> 
> v2->v3:
> * Consider PowerPC for reloc and related fixes [Andrew]
> 
> v1->v2:
> * Andrew comments [see in individual patches]
> * Few cleanups
> 
> Nadav Amit (6):
>   efi: keep efi debug information in a separate file
>   lib/stack: print base addresses on relocation setups
>   arm64: enable frame pointer and support stack unwinding
>   arm64: stack: update trace stack on exception
>   efi: print address of image
>   arm64: dump stack on bad exception
> 
>  .gitignore              |  1 +
>  Makefile                |  2 +-
>  arm/Makefile.arm        |  3 --
>  arm/Makefile.arm64      |  2 ++
>  arm/Makefile.common     |  8 +++++-
>  arm/cstart64.S          | 13 +++++++++
>  lib/arm64/asm-offsets.c |  6 +++-
>  lib/arm64/asm/stack.h   |  3 ++
>  lib/arm64/processor.c   |  1 +
>  lib/arm64/stack.c       | 62 +++++++++++++++++++++++++++++++++++++++++
>  lib/efi.c               |  4 +++
>  lib/stack.c             | 31 +++++++++++++++++++--
>  powerpc/Makefile.common |  1 +
>  x86/Makefile.common     |  5 +++-
>  14 files changed, 133 insertions(+), 9 deletions(-)
>  create mode 100644 lib/arm64/stack.c
> 
> -- 
> 2.34.1
>

Merged. arm64 backtraces will be really nice to have!

Thanks, Nadav!

drew
