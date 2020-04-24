Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63021B6FEA
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 10:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgDXIlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 04:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726659AbgDXIlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 04:41:20 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F1C420728;
        Fri, 24 Apr 2020 08:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587717679;
        bh=PV534O9kwIgM8gDEbfwGPkZ8V9ac73fo3ahFLX6BjaI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1QqFfDfHUZgwGjrY43McTUlwILsc/6ziND4I36dhOBF4rEx1WpkDu9M5aGRqxq1y5
         +pAxF9b8HtcN4f8UZie1asNf2n35KNPqVEcw+JPzUGBpIj5e/eOvd3Nx/tNG3l3gM8
         hS1S0sTZf8mElx7IMuum09loH9rM5EBx9wNsKbHc=
Date:   Fri, 24 Apr 2020 09:41:15 +0100
From:   Will Deacon <will@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Raphael Gault <raphael.gault@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH kvmtool v4 4/5] memslot: Add support for READONLY mappings
Message-ID: <20200424084114.GC20801@willie-the-truck>
References: <20200423173844.24220-1-andre.przywara@arm.com>
 <20200423173844.24220-5-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423173844.24220-5-andre.przywara@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 06:38:43PM +0100, Andre Przywara wrote:
> A KVM memslot has a flags field, which allows to mark a region as
> read-only.
> Add another memory type bit to allow kvmtool-internal users to map a
> write-protected region. Write access would trap and can be handled by
> the MMIO emulation, which should register on the same guest address
> region.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/kvm.h | 12 ++++++++----
>  kvm.c             |  5 +++++
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index 9428f57a..53373b08 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -40,10 +40,12 @@ enum kvm_mem_type {
>  	KVM_MEM_TYPE_RAM	= 1 << 0,
>  	KVM_MEM_TYPE_DEVICE	= 1 << 1,
>  	KVM_MEM_TYPE_RESERVED	= 1 << 2,
> +	KVM_MEM_TYPE_READONLY	= 1 << 3,
>  
>  	KVM_MEM_TYPE_ALL	= KVM_MEM_TYPE_RAM
>  				| KVM_MEM_TYPE_DEVICE
>  				| KVM_MEM_TYPE_RESERVED
> +				| KVM_MEM_TYPE_READONLY
>  };
>  
>  struct kvm_ext {
> @@ -158,17 +160,19 @@ u64 host_to_guest_flat(struct kvm *kvm, void *ptr);
>  bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
>  				 const char *kernel_cmdline);
>  
> +#define add_read_only(type, str)					\

nit: this is a bit broad to throw in a header file. How about
__kvm_mem_add_read_only()  instead?

Will
