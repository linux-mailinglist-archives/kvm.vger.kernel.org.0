Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEA1D6766
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 18:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388125AbfJNQdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 12:33:12 -0400
Received: from foss.arm.com ([217.140.110.172]:48554 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbfJNQdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 12:33:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CFB728;
        Mon, 14 Oct 2019 09:33:11 -0700 (PDT)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF2443F718;
        Mon, 14 Oct 2019 09:33:10 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/1] pci: use uint64_t for unsigned long
 values
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     jmattson@google.com
References: <81990077-23b0-b150-1373-2bb5734d4f23@arm.com>
 <20191012082623.249497-1-morbo@google.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <69743a4f-4a1b-b84c-b58e-cfbac19583a8@arm.com>
Date:   Mon, 14 Oct 2019 17:33:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191012082623.249497-1-morbo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 10/12/19 9:26 AM, Bill Wendling wrote:
> The "pci_bar_*" functions use 64-bit masks, but the results are assigned
> to 32-bit variables. Use 32-bit masks, since we're interested only in
> the least significant 4-bits.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  lib/linux/pci_regs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

In my first comment I didn't realize that the file is actually a copy of a Linux
user API header file (it's taken from include/uapi/linux/pci_regs.h). I don't
think relying on changes to our own copy of the file is the best idea, because we
might forget to include them the next time we sync our version with Linux.

I think the best approach would be to do the explicit cast to uint32_t in
pci_bar_mask.

Thanks,
Alex
>
> diff --git a/lib/linux/pci_regs.h b/lib/linux/pci_regs.h
> index 1becea8..3bc2b92 100644
> --- a/lib/linux/pci_regs.h
> +++ b/lib/linux/pci_regs.h
> @@ -96,8 +96,8 @@
>  #define  PCI_BASE_ADDRESS_MEM_TYPE_1M	0x02	/* Below 1M [obsolete] */
>  #define  PCI_BASE_ADDRESS_MEM_TYPE_64	0x04	/* 64 bit address */
>  #define  PCI_BASE_ADDRESS_MEM_PREFETCH	0x08	/* prefetchable? */
> -#define  PCI_BASE_ADDRESS_MEM_MASK	(~0x0fUL)
> -#define  PCI_BASE_ADDRESS_IO_MASK	(~0x03UL)
> +#define  PCI_BASE_ADDRESS_MEM_MASK	(~0x0fU)
> +#define  PCI_BASE_ADDRESS_IO_MASK	(~0x03U)
>  /* bit 1 is reserved if address_space = 1 */
>  
>  /* Header type 0 (normal devices) */
