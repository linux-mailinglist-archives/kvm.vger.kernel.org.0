Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8B7331493
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 18:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhCHRVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 12:21:45 -0500
Received: from foss.arm.com ([217.140.110.172]:41162 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230143AbhCHRVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 12:21:42 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82B21D6E;
        Mon,  8 Mar 2021 09:21:42 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 886EA3F71B;
        Mon,  8 Mar 2021 09:21:41 -0800 (PST)
Subject: Re: [PATCH kvmtool v2 07/22] hw/i8042: Switch to new trap handlers
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
 <20210225005915.26423-8-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <3a77522e-c3f7-7250-5a9a-0533400ce9bd@arm.com>
Date:   Mon, 8 Mar 2021 17:22:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210225005915.26423-8-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 2/25/21 12:59 AM, Andre Przywara wrote:
> Now that the PC keyboard has a trap handler adhering to the MMIO fault
> handler prototype, let's switch over to the joint registration routine.
>
> This allows us to get rid of the ioport shim routines.
>
> Make the kbd_init() function static on the way.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  hw/i8042.c          | 30 ++++--------------------------
>  include/kvm/i8042.h |  1 -
>  2 files changed, 4 insertions(+), 27 deletions(-)
>
> diff --git a/hw/i8042.c b/hw/i8042.c
> index ab866662..20be36c4 100644
> --- a/hw/i8042.c
> +++ b/hw/i8042.c
> @@ -325,40 +325,18 @@ static void kbd_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
>  		ioport__write8(data, value);
>  }
>  
> -/*
> - * Called when the OS has written to one of the keyboard's ports (0x60 or 0x64)
> - */
> -static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> -{
> -	kbd_io(vcpu, port, data, size, false, NULL);
> -
> -	return true;
> -}
> -
> -static bool kbd_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> -{
> -	kbd_io(vcpu, port, data, size, true, NULL);
> -
> -	return true;
> -}
> -
> -static struct ioport_operations kbd_ops = {
> -	.io_in		= kbd_in,
> -	.io_out		= kbd_out,
> -};
> -
> -int kbd__init(struct kvm *kvm)
> +static int kbd__init(struct kvm *kvm)
>  {
>  	int r;
>  
>  	kbd_reset();
>  	state.kvm = kvm;
> -	r = ioport__register(kvm, I8042_DATA_REG, &kbd_ops, 2, NULL);
> +	r = kvm__register_pio(kvm, I8042_DATA_REG, 2, kbd_io, NULL);
>  	if (r < 0)
>  		return r;
> -	r = ioport__register(kvm, I8042_COMMAND_REG, &kbd_ops, 2, NULL);
> +	r = kvm__register_pio(kvm, I8042_COMMAND_REG, 2, kbd_io, NULL);
>  	if (r < 0) {
> -		ioport__unregister(kvm, I8042_DATA_REG);
> +		kvm__deregister_pio(kvm, I8042_DATA_REG);
>  		return r;
>  	}
>  
> diff --git a/include/kvm/i8042.h b/include/kvm/i8042.h
> index 3b4ab688..cd4ae6bb 100644
> --- a/include/kvm/i8042.h
> +++ b/include/kvm/i8042.h
> @@ -7,6 +7,5 @@ struct kvm;
>  
>  void mouse_queue(u8 c);
>  void kbd_queue(u8 c);
> -int kbd__init(struct kvm *kvm);
>  
>  #endif

Looks good, I also compile tested the code:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

