Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4847FAB283
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 08:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388337AbfIFGaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 02:30:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59470 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732433AbfIFGaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 02:30:06 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6BADE87521E;
        Fri,  6 Sep 2019 06:30:06 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 297944106;
        Fri,  6 Sep 2019 06:30:05 +0000 (UTC)
Date:   Fri, 6 Sep 2019 08:30:02 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] arm: prevent compiler from using
 unaligned accesses
Message-ID: <20190906063002.xiterzugydfycrlu@kamzik.brq.redhat.com>
References: <20190905171502.215183-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905171502.215183-1-andre.przywara@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Fri, 06 Sep 2019 06:30:06 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 05, 2019 at 06:15:02PM +0100, Andre Przywara wrote:
> The ARM architecture requires all accesses to device memory to be
> naturally aligned[1][2]. Normal memory does not have this strict
> requirement, and in fact many systems do ignore unaligned accesses
> (by the means of clearing the A bit in SCTLR and accessing normal
> memory). So the default behaviour of GCC assumes that unaligned accesses
> are fine, at least if happening on the stack.
> 
> Now kvm-unit-tests runs some C code with the MMU off, which degrades the
> whole system memory to device memory. Now every unaligned access will
> fault, regardless of the A bit.
> In fact there is at least one place in lib/printf.c where GCC merges
> two consecutive char* accesses into one "strh" instruction, writing to
> a potentially unaligned address.
> This can be reproduced by configuring kvm-unit-tests for kvmtool, but
> running it on QEMU, which triggers an early printf that exercises this
> particular code path.
> 
> Add the -mstrict-align compiler option to the arm64 CFLAGS to fix this
> problem. Also add the respective -mno-unaligned-access flag for arm.
> 
> Thanks to Alexandru for helping debugging this.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> 
> [1] ARMv8 ARM DDI 0487E.a, B2.5.2
> [2] ARMv7 ARM DDI 0406C.d, A3.2.1
> ---
>  arm/Makefile.arm   | 1 +
>  arm/Makefile.arm64 | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> index a625267..43b4be1 100644
> --- a/arm/Makefile.arm
> +++ b/arm/Makefile.arm
> @@ -12,6 +12,7 @@ KEEP_FRAME_POINTER := y
>  
>  CFLAGS += $(machine)
>  CFLAGS += -mcpu=$(PROCESSOR)
> +CFLAGS += -mno-unaligned-access
>  
>  arch_LDFLAGS = -Ttext=40010000
>  
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 02c24e8..35de5ea 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -7,6 +7,7 @@ bits = 64
>  ldarch = elf64-littleaarch64
>  
>  arch_LDFLAGS = -pie -n
> +CFLAGS += -mstrict-align
>  
>  define arch_elf_check =
>  	$(if $(shell ! $(OBJDUMP) -R $(1) >&/dev/null && echo "nok"),
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
