Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 388C115101E
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 20:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgBCTGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 14:06:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56438 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727073AbgBCTGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 14:06:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580756761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p7GzZwqEUML3mo66Uh/XzQGGzjDISA4pAfoeedkyHHQ=;
        b=Nvoa8ZPbns+rXcjMtKghbwVY6jkXVlsSwPFqhggnCqj2LB1eh+Ds/wVSMc9hU5vLA4HKC7
        WlPXzJ63wKIdspDU3ZqdKlRZnRR25xHgXxAjeIn9qXiQJ0sd5Q+jmYoqsSocgChCg1cxFi
        008AxJZBOfZkISB0J4NxQ+SMAZCWlZY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-bAkKNTLFPeqpSPYm6W-vCA-1; Mon, 03 Feb 2020 13:59:54 -0500
X-MC-Unique: bAkKNTLFPeqpSPYm6W-vCA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B621DB20;
        Mon,  3 Feb 2020 18:59:53 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F3B12811F8;
        Mon,  3 Feb 2020 18:59:51 +0000 (UTC)
Date:   Mon, 3 Feb 2020 19:59:49 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v4 00/10] arm/arm64: Various fixes
Message-ID: <20200203185949.btxvofvgj6brxmzi@kamzik.brq.redhat.com>
References: <20200131163728.5228-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131163728.5228-1-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 31, 2020 at 04:37:18PM +0000, Alexandru Elisei wrote:
> These are the patches that were left unmerged from the previous version of
> the series, plus a few new patches. Patch #1 "Makefile: Use
> no-stack-protector compiler options" is straightforward and came about
> because of a compile error I experienced on RockPro64.
> 
> Patches #3 and #5 are the result of Andre's comments on the previous
> version. When adding ISBs after register writes I noticed in the ARM ARM
> that a read of the timer counter value can be reordered, and patch #4
> tries to avoid that.
> 
> Patch #7 is also the result of a review comment. For the GIC tests, we wait
> up to 5 seconds for the interrupt to be asserted. However, the GIC tests
> can use more than one CPU, which is not the case with the timer test. And
> waiting for the GIC to assert the interrupt can happen up to 6 times (8
> times after patch #9), so I figured that a timeout of 10 seconds for the
> test is acceptable.
> 
> Patch #8 tries to improve the way we test how the timer generates the
> interrupt. If the GIC asserts the timer interrupt, but the device itself is
> not generating it, that's a pretty big problem.
> 
> Ran the same tests as before:
> 
> - with kvmtool, on an arm64 host kernel: 64 and 32 bit tests, with GICv3
>   (on an Ampere eMAG) and GICv2 (on a AMD Seattle box).
> 
> - with qemu, on an arm64 host kernel:
>     a. with accel=kvm, 64 and 32 bit tests, with GICv3 (Ampere eMAG) and
>        GICv2 (Seattle).
>     b. with accel=tcg, 64 and 32 bit tests, on the Ampere eMAG machine.
> 
> Changes:
> * Patches #1, #3, #4, #5, #7, #8 are new.
> * For patch #2, as per Drew's suggestion, I changed the entry point to halt
>   because the test is supposed to test if CPU_ON is successful.
> * Removed the ISB from patch #6 because that was fixed by #3.
> * Moved the architecture dependent function init_dcache_line_size to
>   cpu_init in lib/arm/setup.c as per Drew's suggestion.
> 
> Alexandru Elisei (10):
>   Makefile: Use no-stack-protector compiler options
>   arm/arm64: psci: Don't run C code without stack or vectors
>   arm64: timer: Add ISB after register writes
>   arm64: timer: Add ISB before reading the counter value
>   arm64: timer: Make irq_received volatile
>   arm64: timer: EOIR the interrupt after masking the timer
>   arm64: timer: Wait for the GIC to sample timer interrupt state
>   arm64: timer: Check the timer interrupt state
>   arm64: timer: Test behavior when timer disabled or masked
>   arm/arm64: Perform dcache clean + invalidate after turning MMU off
> 
>  Makefile                  |  4 +-
>  lib/arm/asm/processor.h   | 13 +++++++
>  lib/arm64/asm/processor.h | 12 ++++++
>  lib/arm/setup.c           |  8 ++++
>  arm/cstart.S              | 22 +++++++++++
>  arm/cstart64.S            | 23 ++++++++++++
>  arm/psci.c                | 15 ++++++--
>  arm/timer.c               | 79 ++++++++++++++++++++++++++++++++-------
>  arm/unittests.cfg         |  2 +-
>  9 files changed, 158 insertions(+), 20 deletions(-)
> 
> -- 
> 2.20.1
>

The series looks good to me. The first patch probably could have been
posted separately, but I'll try to test the whole series tomorrow. If
all looks well, I'll prepare a pull request for Paolo.

Thanks,
drew 

