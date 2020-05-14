Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032461D3722
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 18:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgENQ5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 12:57:00 -0400
Received: from foss.arm.com ([217.140.110.172]:40616 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgENQ47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 12:56:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF8151045;
        Thu, 14 May 2020 09:56:58 -0700 (PDT)
Received: from [192.168.2.22] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC0B03F71E;
        Thu, 14 May 2020 09:56:57 -0700 (PDT)
Subject: Re: [PATCH v4 kvmtool 07/12] Don't allow more than one framebuffers
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com, maz@kernel.org
References: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
 <1589470709-4104-8-git-send-email-alexandru.elisei@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Organization: ARM Ltd.
Message-ID: <8335e606-a36f-149d-f765-a3ba13ca4bab@arm.com>
Date:   Thu, 14 May 2020 17:56:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1589470709-4104-8-git-send-email-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/05/2020 16:38, Alexandru Elisei wrote:
> A vesa device is used by the SDL, GTK or VNC framebuffers. Don't allow the
> user to specify more than one of these options because kvmtool will create
> identical vesa devices and bad things will happen:
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
> the above framebuffers. Also remove the superfluous check for their
> existence.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  builtin-run.c | 5 +++++
>  hw/vesa.c     | 2 --
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/builtin-run.c b/builtin-run.c
> index 03b119e29995..c23e7a2e5ecd 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -543,6 +543,11 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
>  		kvm->cfg.console = DEFAULT_CONSOLE;
>  
>  	video = kvm->cfg.vnc || kvm->cfg.sdl || kvm->cfg.gtk;
> +	if (video) {
> +		if ((kvm->cfg.vnc && (kvm->cfg.sdl || kvm->cfg.gtk)) ||
> +		    (kvm->cfg.sdl && kvm->cfg.gtk))
> +			die("Only one of --vnc, --sdl or --gtk can be specified");
> +	}
>  
>  	if (!strncmp(kvm->cfg.console, "virtio", 6))
>  		kvm->cfg.active_console  = CONSOLE_VIRTIO;
> diff --git a/hw/vesa.c b/hw/vesa.c
> index dd59a112330b..a4ec7e16e1e6 100644
> --- a/hw/vesa.c
> +++ b/hw/vesa.c
> @@ -61,8 +61,6 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>  	BUILD_BUG_ON(!is_power_of_two(VESA_MEM_SIZE));
>  	BUILD_BUG_ON(VESA_MEM_SIZE < VESA_BPP/8 * VESA_WIDTH * VESA_HEIGHT);
>  
> -	if (!kvm->cfg.vnc && !kvm->cfg.sdl && !kvm->cfg.gtk)
> -		return NULL;
>  	vesa_base_addr = pci_get_io_port_block(PCI_IO_SIZE);
>  	r = ioport__register(kvm, vesa_base_addr, &vesa_io_ops, PCI_IO_SIZE, NULL);
>  	if (r < 0)
> 

