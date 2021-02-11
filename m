Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F27B31907D
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 17:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhBKQ6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 11:58:42 -0500
Received: from foss.arm.com ([217.140.110.172]:54624 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230252AbhBKQ4O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 11:56:14 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5611E11D4;
        Thu, 11 Feb 2021 08:55:28 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5CF773F73B;
        Thu, 11 Feb 2021 08:55:27 -0800 (PST)
Subject: Re: [PATCH kvmtool 05/21] hw/i8042: Clean up data types
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-6-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <04b5f537-1594-61b9-b7ef-4062e732e380@arm.com>
Date:   Thu, 11 Feb 2021 16:55:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20201210142908.169597-6-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 12/10/20 2:28 PM, Andre Przywara wrote:

> The i8042 is clearly an 8-bit era device, so there is little room for
> 32-bit registers.
> Clean up the data types used.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  hw/i8042.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/hw/i8042.c b/hw/i8042.c
> index 37a99a2d..36ee183f 100644
> --- a/hw/i8042.c
> +++ b/hw/i8042.c
> @@ -64,11 +64,11 @@
>  struct kbd_state {
>  	struct kvm		*kvm;
>  
> -	char			kq[QUEUE_SIZE];	/* Keyboard queue */
> +	u8			kq[QUEUE_SIZE];	/* Keyboard queue */
>  	int			kread, kwrite;	/* Indexes into the queue */
>  	int			kcount;		/* number of elements in queue */
>  
> -	char			mq[QUEUE_SIZE];
> +	u8			mq[QUEUE_SIZE];
>  	int			mread, mwrite;
>  	int			mcount;

I think the write_cmd field further down should also be u8 because it stores the
first byte of a command (and it's set only to an 8 bit value in kbd_write_command()).

Otherwise, it looks ok to me. osdev wiki seems to confirm that the device is
indeed 8 bit only, and all the registers are 8 bit now:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>  
> @@ -173,9 +173,9 @@ static void kbd_write_command(struct kvm *kvm, u8 val)
>  /*
>   * Called when the OS reads from port 0x60 (PS/2 data)
>   */
> -static u32 kbd_read_data(void)
> +static u8 kbd_read_data(void)
>  {
> -	u32 ret;
> +	u8 ret;
>  	int i;
>  
>  	if (state.kcount != 0) {
> @@ -202,9 +202,9 @@ static u32 kbd_read_data(void)
>  /*
>   * Called when the OS read from port 0x64, the command port
>   */
> -static u32 kbd_read_status(void)
> +static u8 kbd_read_status(void)
>  {
> -	return (u32)state.status;
> +	return state.status;
>  }
>  
>  /*
> @@ -212,7 +212,7 @@ static u32 kbd_read_status(void)
>   * Things written here are generally arguments to commands previously
>   * written to port 0x64 and stored in state.write_cmd
>   */
> -static void kbd_write_data(u32 val)
> +static void kbd_write_data(u8 val)
>  {
>  	switch (state.write_cmd) {
>  	case I8042_CMD_CTL_WCTR:
> @@ -304,8 +304,8 @@ static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *
>  		break;
>  	}
>  	case I8042_DATA_REG: {
> -		u32 value = kbd_read_data();
> -		ioport__write32(data, value);
> +		u8 value = kbd_read_data();
> +		ioport__write8(data, value);
>  		break;
>  	}
>  	case I8042_PORT_B_REG: {
> @@ -328,7 +328,7 @@ static bool kbd_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void
>  		break;
>  	}
>  	case I8042_DATA_REG: {
> -		u32 value = ioport__read32(data);
> +		u8 value = ioport__read8(data);
>  		kbd_write_data(value);
>  		break;
>  	}
