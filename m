Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF916D677A
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 18:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388099AbfJNQgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 12:36:55 -0400
Received: from mga06.intel.com ([134.134.136.31]:6213 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731506AbfJNQgz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 12:36:55 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 09:36:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="189072304"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 14 Oct 2019 09:36:54 -0700
Date:   Mon, 14 Oct 2019 09:36:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Bill Wendling <morbo@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH 1/1] pci: use uint64_t for unsigned long
 values
Message-ID: <20191014163654.GC22962@linux.intel.com>
References: <81990077-23b0-b150-1373-2bb5734d4f23@arm.com>
 <20191012082623.249497-1-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191012082623.249497-1-morbo@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The subject "pci: use uint64_t for unsigned long values" does not reflect
what the patch does.

This should be tagged v2.

Generally speaking, resend the whole series as v2 (or v3, etc...) even if
only one patch is being tweaked.  It's fairly obvious in this case that
the other two other patches from v1 are still relevant, but that won't
always be true.

On Sat, Oct 12, 2019 at 01:26:23AM -0700, Bill Wendling wrote:
> The "pci_bar_*" functions use 64-bit masks, but the results are assigned
> to 32-bit variables. Use 32-bit masks, since we're interested only in
> the least significant 4-bits.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  lib/linux/pci_regs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
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

The defines themselves should still be 64-bit, e.g. there's a flag right
above to denote a 64-bit address.  Explicitly casting the return value in
pci_bar_mask() where we're dealing with 32-bit addresses would be
preferable.

>  /* bit 1 is reserved if address_space = 1 */
>  
>  /* Header type 0 (normal devices) */
> -- 
> 2.23.0.700.g56cf767bdb-goog
> 
