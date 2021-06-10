Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE1B3A304B
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 18:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhFJQPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 12:15:33 -0400
Received: from foss.arm.com ([217.140.110.172]:35822 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229802AbhFJQPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 12:15:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B222ED1;
        Thu, 10 Jun 2021 09:13:36 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B9F33F719;
        Thu, 10 Jun 2021 09:13:35 -0700 (PDT)
Date:   Thu, 10 Jun 2021 17:13:24 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: Re: [PATCH kvmtool 1/4] Move fdt_irq_fn typedef to fdt.h
Message-ID: <20210610171324.6f227028@slackpad.fritz.box>
In-Reply-To: <20210609183812.29596-2-alexandru.elisei@arm.com>
References: <20210609183812.29596-1-alexandru.elisei@arm.com>
        <20210609183812.29596-2-alexandru.elisei@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  9 Jun 2021 19:38:09 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> The device tree code passes the function generate_irq_prop() to MMIO
> devices to create the "interrupts" property. The typedef fdt_irq_fn is the
> type used to pass the function to the device. It makes more sense for the
> typedef to be in fdt.h with the rest of the device tree functions, so move
> it there.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Not sure why we really need that, but doesn't seem to hurt:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  hw/rtc.c          | 1 +
>  include/kvm/fdt.h | 2 ++
>  include/kvm/kvm.h | 1 -
>  3 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/rtc.c b/hw/rtc.c
> index aec31c52a85a..9b8785a869dd 100644
> --- a/hw/rtc.c
> +++ b/hw/rtc.c
> @@ -1,5 +1,6 @@
>  #include "kvm/rtc.h"
>  
> +#include "kvm/fdt.h"
>  #include "kvm/ioport.h"
>  #include "kvm/kvm.h"
>  
> diff --git a/include/kvm/fdt.h b/include/kvm/fdt.h
> index 4e6157256482..060c37b947cc 100644
> --- a/include/kvm/fdt.h
> +++ b/include/kvm/fdt.h
> @@ -25,6 +25,8 @@ enum irq_type {
>  	IRQ_TYPE_LEVEL_MASK	= (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH),
>  };
>  
> +typedef void (*fdt_irq_fn)(void *fdt, u8 irq, enum irq_type irq_type);
> +
>  extern char *fdt_stdout_path;
>  
>  /* Helper for the various bits of code that generate FDT nodes */
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index 6c28afa3f0bb..56e9c8e347a0 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -44,7 +44,6 @@
>  struct kvm_cpu;
>  typedef void (*mmio_handler_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data,
>  				u32 len, u8 is_write, void *ptr);
> -typedef void (*fdt_irq_fn)(void *fdt, u8 irq, enum irq_type irq_type);
>  
>  enum {
>  	KVM_VMSTATE_RUNNING,

