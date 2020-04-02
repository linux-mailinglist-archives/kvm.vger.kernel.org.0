Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F5119BE47
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 10:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387829AbgDBI7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 04:59:10 -0400
Received: from foss.arm.com ([217.140.110.172]:40086 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387749AbgDBI7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 04:59:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E376A31B;
        Thu,  2 Apr 2020 01:59:09 -0700 (PDT)
Received: from [192.168.3.111] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F01EA3F68F;
        Thu,  2 Apr 2020 01:59:08 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 26/32] vesa: Create device exactly once
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-27-alexandru.elisei@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Organization: ARM Ltd.
Message-ID: <f80227c9-a57c-952f-f362-58d15e19690e@arm.com>
Date:   Thu, 2 Apr 2020 09:58:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326152438.6218-27-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/03/2020 15:24, Alexandru Elisei wrote:
> A vesa device is used by the SDL, GTK or VNC framebuffers. Don't allow the
> user to specify more than one of these options because kvmtool will create
> identical devices and bad things will happen:
> 
> $ ./lkvm run -c2 -m2048 -k bzImage --sdl --gtk
>   # lkvm run -k bzImage -m 2048 -c 2 --name guest-10159
>   Error: device region [d0000000-d012bfff] would overlap device region [d0000000-d012bfff]
> *** Error in `./lkvm': free(): invalid pointer: 0x00007fad78002e40 ***
> *** Error in `./lkvm': free(): invalid pointer: 0x00007fad78002e40 ***
> *** Error in `./lkvm': free(): invalid pointer: 0x00007fad78002e40 ***
> ======= Backtrace: =========
> ======= Backtrace: =========
> /lib/x86_64-linux-gnu/libc.so.6(+0x777e5)[0x7fae0ed447e5]
> ======= Backtrace: =========
> /lib/x86_64-linux-gnu/libc.so.6/lib/x86_64-linux-gnu/libc.so.6(+0x8037a)[0x7fae0ed4d37a]
> (+0x777e5)[0x7fae0ed447e5]
> /lib/x86_64-linux-gnu/libc.so.6(+0x777e5)[0x7fae0ed447e5]
> /lib/x86_64-linux-gnu/libc.so.6(+0x8037a)[0x7fae0ed4d37a]
> /lib/x86_64-linux-gnu/libc.so.6(cfree+0x4c)[0x7fae0ed5153c]
> *** Error in `./lkvm': free(): invalid pointer: 0x00007fad78002e40 ***
> /lib/x86_64-linux-gnu/libglib-2.0.so.0(g_string_free+0x3b)[0x7fae0f814dab]
> /lib/x86_64-linux-gnu/libglib-2.0.so.0(g_string_free+0x3b)[0x7fae0f814dab]
> /usr/lib/x86_64-linux-gnu/libgtk-3.so.0(+0x21121c)[0x7fae1023321c]
> /usr/lib/x86_64-linux-gnu/libgtk-3.so.0(+0x21121c)[0x7fae1023321c]
> ======= Backtrace: =========
> Aborted (core dumped)
> 
> The vesa device is explicitly created during the initialization phase of
> the above framebuffers. Remove the superfluous check for their existence.
> 

Not really happy about this pointer comparison, but I don't see a better
way, and it's surely good enough for that purpose.

> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  hw/vesa.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/vesa.c b/hw/vesa.c
> index dd59a112330b..8071ad153f27 100644
> --- a/hw/vesa.c
> +++ b/hw/vesa.c
> @@ -61,8 +61,11 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>  	BUILD_BUG_ON(!is_power_of_two(VESA_MEM_SIZE));
>  	BUILD_BUG_ON(VESA_MEM_SIZE < VESA_BPP/8 * VESA_WIDTH * VESA_HEIGHT);
>  
> -	if (!kvm->cfg.vnc && !kvm->cfg.sdl && !kvm->cfg.gtk)
> -		return NULL;
> +	if (device__find_dev(vesa_device.bus_type, vesa_device.dev_num) == &vesa_device) {
> +		r = -EEXIST;
> +		goto out_error;
> +	}
> +
>  	vesa_base_addr = pci_get_io_port_block(PCI_IO_SIZE);
>  	r = ioport__register(kvm, vesa_base_addr, &vesa_io_ops, PCI_IO_SIZE, NULL);
>  	if (r < 0)
> 

