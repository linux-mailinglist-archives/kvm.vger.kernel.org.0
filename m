Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3742DC048
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 13:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgLPM0b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 07:26:31 -0500
Received: from foss.arm.com ([217.140.110.172]:49912 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbgLPM0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 07:26:31 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 99EC11FB;
        Wed, 16 Dec 2020 04:25:45 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A2483F66E;
        Wed, 16 Dec 2020 04:25:44 -0800 (PST)
Subject: Re: [PATCH kvmtool] pci: Deactivate BARs before reactivating
To:     Sergey Temerkhanov <s.temerkhanov@gmail.com>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20201215143512.559367-1-s.temerkhanov@gmail.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <ac8de7f6-392c-509b-26a5-f34f8cbe1173@arm.com>
Date:   Wed, 16 Dec 2020 12:24:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201215143512.559367-1-s.temerkhanov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sergey,

On 12/15/20 2:35 PM, Sergey Temerkhanov wrote:
> Deactivate BARs before reactivating them to avoid breakage.
> Some firmware components do not check whether the COMMAND
> register contains any values before writing BARs which leads
> to kvmtool errors during subsequent BAR deactivation
>
> Signed-off-by: Sergey Temerkhanov <s.temerkhanov@gmail.com>
> ---
>  pci.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/pci.c b/pci.c
> index 2e2c027..515d9dc 100644
> --- a/pci.c
> +++ b/pci.c
> @@ -320,10 +320,6 @@ static void pci_config_bar_wr(struct kvm *kvm,
>  	 */
>  	if (value == 0xffffffff) {
>  		value = ~(pci__bar_size(pci_hdr, bar_num) - 1);
> -		/* Preserve the special bits. */
> -		value = (value & mask) | (pci_hdr->bar[bar_num] & ~mask);
> -		pci_hdr->bar[bar_num] = value;
> -		return;

I think the PCI spec is clear what should happen when software writes all 1's to
the BAR (PCI LOCAL BUS SPECIFICATION, REV. 3.0, page 226):

"Power-up software can determine how much address space the device requires by
writing a value of all 1's to the register and then reading the value back. The
device will return 0's in all don't-care address bits, effectively specifying the
address space required."

Your patch breaks this mechanism for sizing a BAR.

It also looks to me like the firmware is doing something very strange: it writes
all 1's to a BAR, which with your patch enables emulation for the memory region
[~(bar_size-1), ~(bar_size-1)+bar_size]. How does the firmware know the value of
bar_size? It reads it back and confuses it with the address instead of the region
size?

Would you mind posting more details about the error you are seeing? Maybe we can
find a different solution.

Thanks,

Alex

