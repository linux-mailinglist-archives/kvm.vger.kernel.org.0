Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661145EF357
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 12:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbiI2KVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 06:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbiI2KVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 06:21:07 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA9C343614
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 03:21:05 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 38A712309;
        Thu, 29 Sep 2022 03:21:12 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB8B63F73B;
        Thu, 29 Sep 2022 03:21:04 -0700 (PDT)
Date:   Thu, 29 Sep 2022 11:21:02 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     dinhngoc.tu@irit.fr
Cc:     kvm@vger.kernel.org, Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH kvmtool] mmio: Fix wrong PIO tree search size
Message-ID: <20220929112102.04c1c3ab@donnerap.cambridge.arm.com>
In-Reply-To: <20220928151651.1846-1-dinhngoc.tu@irit.fr>
References: <20220928151651.1846-1-dinhngoc.tu@irit.fr>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Sep 2022 17:16:51 +0200
dinhngoc.tu@irit.fr wrote:

Hi,

> From: Tu Dinh Ngoc <dinhngoc.tu@irit.fr>
> 
> The `len' parameter of kvm__register_pio specifies a range of I/O ports
> to be registered for the same handler. However, the `size' parameter of
> PIO events specifies the number of bytes read/written to a single I/O
> port.
> 
> kvm__emulate_io confuses the two and uses the number of bytes
> read/written in its I/O handler search, meaning reads/writes with a size
> larger than the registered range length will be silently dropped.

Yes, and this is intended. On real hardware you just cannot
generally expect larger I/O accesses to work and affect multiple
registers, this is true for both the legacy IBM PC I/O operations, and
also for modern MMIO devices.
And specifically exceeding the registered range should be outright denied.

So where did you see this problem? Because this looks like a misbehaving
guest, and we should not take any chances and prefer denying dodgy
requests over potentially running into security issues by allowing
accesses beyond the allocated range.

Cheers,
Andre

> 
> Fix this issue by specifying a MMIO tree search range of 1 port.
> ---
>  mmio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mmio.c b/mmio.c
> index 5a114e9..212e979 100644
> --- a/mmio.c
> +++ b/mmio.c
> @@ -222,7 +222,7 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data,
>  	struct mmio_mapping *mmio;
>  	bool is_write = direction == KVM_EXIT_IO_OUT;
>  
> -	mmio = mmio_get(&pio_tree, port, size);
> +	mmio = mmio_get(&pio_tree, port, 1);
>  	if (!mmio) {
>  		if (vcpu->kvm->cfg.ioport_debug) {
>  			fprintf(stderr, "IO error: %s port=%x, size=%d, count=%u\n",

