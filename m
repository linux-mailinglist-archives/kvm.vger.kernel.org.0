Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF0114A96C
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 19:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgA0SHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 13:07:20 -0500
Received: from foss.arm.com ([217.140.110.172]:47788 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgA0SHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 13:07:20 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 711A430E;
        Mon, 27 Jan 2020 10:07:19 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 63BBB3F67D;
        Mon, 27 Jan 2020 10:07:18 -0800 (PST)
Date:   Mon, 27 Jan 2020 18:07:15 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: Re: [PATCH v2 kvmtool 02/30] hw/i8042: Compile only for x86
Message-ID: <20200127180715.13e726d7@donnerap.cambridge.arm.com>
In-Reply-To: <20200123134805.1993-3-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
        <20200123134805.1993-3-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jan 2020 13:47:37 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> The initialization function for the i8042 emulated device does exactly
> nothing for all architectures, except for x86. As a result, the device
> is usable only for x86, so let's make the file an architecture specific
> object file.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> ---
>  Makefile   | 2 +-
>  hw/i8042.c | 4 ----
>  2 files changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 6d6880dd4f8a..33eddcbb4d66 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -103,7 +103,6 @@ OBJS	+= hw/pci-shmem.o
>  OBJS	+= kvm-ipc.o
>  OBJS	+= builtin-sandbox.o
>  OBJS	+= virtio/mmio.o
> -OBJS	+= hw/i8042.o
>  
>  # Translate uname -m into ARCH string
>  ARCH ?= $(shell uname -m | sed -e s/i.86/i386/ -e s/ppc.*/powerpc/ \
> @@ -124,6 +123,7 @@ endif
>  #x86
>  ifeq ($(ARCH),x86)
>  	DEFINES += -DCONFIG_X86
> +	OBJS	+= hw/i8042.o
>  	OBJS	+= x86/boot.o
>  	OBJS	+= x86/cpuid.o
>  	OBJS	+= x86/interrupt.o
> diff --git a/hw/i8042.c b/hw/i8042.c
> index 288b7d1108ac..2d8c96e9c7e6 100644
> --- a/hw/i8042.c
> +++ b/hw/i8042.c
> @@ -349,10 +349,6 @@ static struct ioport_operations kbd_ops = {
>  
>  int kbd__init(struct kvm *kvm)
>  {
> -#ifndef CONFIG_X86
> -	return 0;
> -#endif
> -
>  	kbd_reset();
>  	state.kvm = kvm;
>  	ioport__register(kvm, I8042_DATA_REG, &kbd_ops, 2, NULL);

