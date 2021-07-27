Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BF73D7D2E
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 20:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhG0SMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 14:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230139AbhG0SMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 14:12:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD3946056B;
        Tue, 27 Jul 2021 18:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627409529;
        bh=fUgkuFB9VQtgL1VRh8fF7edi9U2ibRcCUZV2oZL57h8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cpxx1nirtagKB64kip87dBNB4SjfC/kG0WM5+aseu385nTOwDTylRCPPxcHHEKwf4
         S/qfl0CnSLCp9sK+uhtUVArERHSiTR7kkyPKN3sq91+Zg5hJSy5mlTys4lOcf64vbg
         Uzt9HkAx8h1hcXSUxH2ZVPiwZInxVvvWK6Yd2+f2RvEJSo7d4I04xtqexTPdTbtzSq
         6pPq1ijZab66hHRoS6BHWS/xdQG0UfWek6Cq3yLNt+lx7b1GmqOeo3uT4+9QhCTbuj
         obYyb3hXWK+0f4QnJlejAIT2PVix0kDbobIpTmsJqi74OX4pei/3hFhpxQmVgnTisi
         P/T7JGHLrHYog==
Date:   Tue, 27 Jul 2021 19:12:04 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        qperret@google.com, dbrazdil@google.com,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 12/16] mm/ioremap: Add arch-specific callbacks on
 ioremap/iounmap calls
Message-ID: <20210727181203.GG19173@willie-the-truck>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-13-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715163159.1480168-13-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021 at 05:31:55PM +0100, Marc Zyngier wrote:
> Add a pair of hooks (ioremap_page_range_hook/iounmap_page_range_hook)
> that can be implemented by an architecture.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  include/linux/io.h |  3 +++
>  mm/ioremap.c       | 13 ++++++++++++-
>  mm/vmalloc.c       |  8 ++++++++
>  3 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/io.h b/include/linux/io.h
> index 9595151d800d..0ffc265f114c 100644
> --- a/include/linux/io.h
> +++ b/include/linux/io.h
> @@ -21,6 +21,9 @@ void __ioread32_copy(void *to, const void __iomem *from, size_t count);
>  void __iowrite64_copy(void __iomem *to, const void *from, size_t count);
>  
>  #ifdef CONFIG_MMU
> +void ioremap_page_range_hook(unsigned long addr, unsigned long end,
> +			     phys_addr_t phys_addr, pgprot_t prot);
> +void iounmap_page_range_hook(phys_addr_t phys_addr, size_t size);
>  int ioremap_page_range(unsigned long addr, unsigned long end,
>  		       phys_addr_t phys_addr, pgprot_t prot);
>  #else

Can we avoid these hooks by instead not registering the regions proactively
in the guest and moving that logic to a fault handler which runs off the
back of the injected data abort? From there, we could check if the faulting
IPA is a memory address and register it as MMIO if not.

Dunno, you've spent more time than me thinking about this, but just
wondering if you'd had a crack at doing it that way, as it _seems_ simpler
to my naive brain.

Will
