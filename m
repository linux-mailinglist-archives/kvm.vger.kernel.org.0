Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E22C1DE09B
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 09:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgEVHIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 03:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgEVHIc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 03:08:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06C412073B;
        Fri, 22 May 2020 07:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590131310;
        bh=BzVS8OVwPrJ9usz+4Rqa5ClctQ6xgdNY11zQoXzVLQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sbwb30XAgCWht0j4po03wDtrs1XMK+KHKdmgJZDDHdHAeLlM6e86uCXEj9b1yksH3
         V2PIdEEuG8hPhLQMGLv+dhEM4eZ8u0U5SZNQWXxvew2A3hq9G6k5tpWkx4n2YD02NH
         Qj1cACmebegTcb9QcrVu5f5FC1ZqYyvrikq6yjEU=
Date:   Fri, 22 May 2020 09:08:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
Subject: Re: [PATCH v2 08/18] nitro_enclaves: Add logic for enclave vm
 creation
Message-ID: <20200522070828.GD771317@kroah.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
 <20200522062946.28973-9-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522062946.28973-9-andraprs@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 22, 2020 at 09:29:36AM +0300, Andra Paraschiv wrote:
> Add ioctl command logic for enclave VM creation. It triggers a slot
> allocation. The enclave resources will be associated with this slot and
> it will be used as an identifier for triggering enclave run.
> 
> Return a file descriptor, namely enclave fd. This is further used by the
> associated user space enclave process to set enclave resources and
> trigger enclave termination.
> 
> The poll function is implemented in order to notify the enclave process
> when an enclave exits without a specific enclave termination command
> trigger e.g. when an enclave crashes.
> 
> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
>  drivers/virt/nitro_enclaves/ne_misc_dev.c | 169 ++++++++++++++++++++++
>  1 file changed, 169 insertions(+)
> 
> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> index e1866fac8220..1036221238f4 100644
> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> @@ -63,6 +63,146 @@ struct ne_cpu_pool {
>  
>  static struct ne_cpu_pool ne_cpu_pool;
>  
> +static int ne_enclave_open(struct inode *node, struct file *file)
> +{
> +	return 0;
> +}

Again, if a file operation does nothing, don't even provide it.

thanks,

greg k-h
