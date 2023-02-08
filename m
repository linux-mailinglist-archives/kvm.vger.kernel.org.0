Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC06F68FA15
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 23:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbjBHWKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 17:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbjBHWKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 17:10:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9972E812;
        Wed,  8 Feb 2023 14:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AAE7617EB;
        Wed,  8 Feb 2023 22:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E719C433EF;
        Wed,  8 Feb 2023 22:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675894212;
        bh=0FN9stD3dgEOqgNuBgXmNCQ4tkcWqFsjS9TTePPJU9A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=mbrvv9HtNAqv5dEEjcVhuo9vhqhljRdX5BwvJCUgBE+R44aq2qWyTxfsDUl69Kbko
         rNo2hNgH4kT6p6xiOps5fh9/zBA1JkvE4ZAR+m9Hm66uiW0ZL2CMfnlKeuuO8Nb7Wf
         1eEl+lRDNHGQIB0LZ0+rF8MqbxlBIkhqHPczTl4JzC95fLHnH5KmYqijv+1S6V6dA8
         wsyEscrZiECZED+xB+U5Mq+AEWiqoXxMrVD//Tc2DwfuyvJqU8INyVslVcPSgGREB4
         /RH8kPbhY0wM3oi6WrQ2irJGbxtvDUDNYNLg6tjYf0c4WaNiZLsdIVYVQIxBMVFT/k
         W+idXu0XFlXVA==
Date:   Wed, 8 Feb 2023 16:10:10 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Seunggyun Lee <sglee97@dankook.ac.kr>
Cc:     bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] pci/mmap: add pci device EBUSY check
Message-ID: <20230208221010.GA2489371@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207113949.17943-1-sglee97@dankook.ac.kr>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[+cc VFIO folks, Leon]

On Tue, Feb 07, 2023 at 08:39:49PM +0900, Seunggyun Lee wrote:
> When using a pci device through the vfio-pci driver, other software was
> also able to access the pci device memory through sysfs.
> 
> To prevent this, when mmap is performed through sysfs, a process of
> checking whether the device is in use is added.
> 
> Signed-off-by: Seunggyun Lee <sglee97@dankook.ac.kr>
> ---
>  drivers/pci/mmap.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pci/mmap.c b/drivers/pci/mmap.c
> index 4504039056d1..4c9df2e23e03 100644
> --- a/drivers/pci/mmap.c
> +++ b/drivers/pci/mmap.c
> @@ -25,6 +25,8 @@ int pci_mmap_resource_range(struct pci_dev *pdev, int bar,
>  {
>  	unsigned long size;
>  	int ret;
> +	if (pdev->driver)
> +		return -1;
>  
>  	size = ((pci_resource_len(pdev, bar) - 1) >> PAGE_SHIFT) + 1;
>  	if (vma->vm_pgoff + vma_pages(vma) > size)
> -- 
> 2.25.1
> 
