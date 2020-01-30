Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB92D14DD52
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 15:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbgA3OwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 09:52:24 -0500
Received: from foss.arm.com ([217.140.110.172]:53986 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727193AbgA3OwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 09:52:24 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2D0B731B;
        Thu, 30 Jan 2020 06:52:24 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 244DF3F68E;
        Thu, 30 Jan 2020 06:52:23 -0800 (PST)
Date:   Thu, 30 Jan 2020 14:52:20 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: Re: [PATCH v2 kvmtool 17/30] hw/vesa: Don't ignore fatal errors
Message-ID: <20200130145220.52d61500@donnerap.cambridge.arm.com>
In-Reply-To: <20200123134805.1993-18-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
        <20200123134805.1993-18-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jan 2020 13:47:52 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Failling an mmap call or creating a memslot means that device emulation
> will not work, don't ignore it.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  hw/vesa.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/vesa.c b/hw/vesa.c
> index b92cc990b730..a665736a76d7 100644
> --- a/hw/vesa.c
> +++ b/hw/vesa.c
> @@ -76,9 +76,11 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>  
>  	mem = mmap(NULL, VESA_MEM_SIZE, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
>  	if (mem == MAP_FAILED)
> -		ERR_PTR(-errno);
> +		return ERR_PTR(-errno);
>  
> -	kvm__register_dev_mem(kvm, VESA_MEM_ADDR, VESA_MEM_SIZE, mem);
> +	r = kvm__register_dev_mem(kvm, VESA_MEM_ADDR, VESA_MEM_SIZE, mem);
> +	if (r < 0)
> +		return ERR_PTR(r);

For the sake of correctness, we should munmap here, I think.
With that fixed:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

>  
>  	vesafb = (struct framebuffer) {
>  		.width			= VESA_WIDTH,

