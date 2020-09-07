Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EC925F5CD
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 10:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgIGI6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 04:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727954AbgIGI6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 04:58:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 116E5208C7;
        Mon,  7 Sep 2020 08:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599469084;
        bh=bj11huEJoW6fB17BrsnCNFk+tjF6ioUZMlRwy2BKDFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S80B5lubyI/ZvaXuDtKD36y4AteVlFc/cwrIrRsEvblICOuQP7vMusGJzSpWKhe/m
         RZ6gW5CEWwiHy83juD7kEf3cQsaIKMZXl5EmX7dVijvvb8thP2bo8lkGxIZVjLqyra
         ScfLcBT1oLRvZml9uUt+hwWnk+4JkoDPpogGEVGc=
Date:   Mon, 7 Sep 2020 10:58:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>, Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
Subject: Re: [PATCH v8 09/18] nitro_enclaves: Add logic for setting an
 enclave vCPU
Message-ID: <20200907085818.GB1101646@kroah.com>
References: <20200904173718.64857-1-andraprs@amazon.com>
 <20200904173718.64857-10-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904173718.64857-10-andraprs@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 04, 2020 at 08:37:09PM +0300, Andra Paraschiv wrote:
> An enclave, before being started, has its resources set. One of its
> resources is CPU.
> 
> A NE CPU pool is set and enclave CPUs are chosen from it. Offline the
> CPUs from the NE CPU pool during the pool setup and online them back
> during the NE CPU pool teardown. The CPU offline is necessary so that
> there would not be more vCPUs than physical CPUs available to the
> primary / parent VM. In that case the CPUs would be overcommitted and
> would change the initial configuration of the primary / parent VM of
> having dedicated vCPUs to physical CPUs.
> 
> The enclave CPUs need to be full cores and from the same NUMA node. CPU
> 0 and its siblings have to remain available to the primary / parent VM.
> 
> Add ioctl command logic for setting an enclave vCPU.
> 
> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> Reviewed-by: Alexander Graf <graf@amazon.com>
> ---
> Changelog
> 
> v7 -> v8
> 
> * No changes.
> 
> v6 -> v7
> 
> * Check for error return value when setting the kernel parameter string.
> * Use the NE misc device parent field to get the NE PCI device.
> * Update the naming and add more comments to make more clear the logic
>   of handling full CPU cores and dedicating them to the enclave.
> * Calculate the number of threads per core and not use smp_num_siblings
>   that is x86 specific.
> 
> v5 -> v6
> 
> * Check CPUs are from the same NUMA node before going through CPU
>   siblings during the NE CPU pool setup.
> * Update documentation to kernel-doc format.
> 
> v4 -> v5
> 
> * Set empty string in case of invalid NE CPU pool.
> * Clear NE CPU pool mask on pool setup failure.
> * Setup NE CPU cores out of the NE CPU pool.
> * Early exit on NE CPU pool setup if enclave(s) already running.
> * Remove sanity checks for situations that shouldn't happen, only if
>   buggy system or broken logic at all.
> * Add check for maximum vCPU id possible before looking into the CPU
>   pool.
> * Remove log on copy_from_user() / copy_to_user() failure and on admin
>   capability check for setting the NE CPU pool.
> * Update the ioctl call to not create a file descriptor for the vCPU.
> * Split the CPU pool usage logic in 2 separate functions - one to get a
>   CPU from the pool and the other to check the given CPU is available in
>   the pool.
> 
> v3 -> v4
> 
> * Setup the NE CPU pool at runtime via a sysfs file for the kernel
>   parameter.
> * Check enclave CPUs to be from the same NUMA node.
> * Use dev_err instead of custom NE log pattern.
> * Update the NE ioctl call to match the decoupling from the KVM API.
> 
> v2 -> v3
> 
> * Remove the WARN_ON calls.
> * Update static calls sanity checks.
> * Update kzfree() calls to kfree().
> * Remove file ops that do nothing for now - open, ioctl and release.
> 
> v1 -> v2
> 
> * Add log pattern for NE.
> * Update goto labels to match their purpose.
> * Remove the BUG_ON calls.
> * Check if enclave state is init when setting enclave vCPU.
> ---
>  drivers/virt/nitro_enclaves/ne_misc_dev.c | 702 ++++++++++++++++++++++
>  1 file changed, 702 insertions(+)
> 
> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> index 7ad3f1eb75d4..0477b11bf15d 100644
> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> @@ -64,8 +64,11 @@
>   * TODO: Update logic to create new sysfs entries instead of using
>   * a kernel parameter e.g. if multiple sysfs files needed.
>   */
> +static int ne_set_kernel_param(const char *val, const struct kernel_param *kp);
> +
>  static const struct kernel_param_ops ne_cpu_pool_ops = {
>  	.get	= param_get_string,
> +	.set	= ne_set_kernel_param,
>  };
>  
>  static char ne_cpus[NE_CPUS_SIZE];
> @@ -103,6 +106,702 @@ struct ne_cpu_pool {
>  
>  static struct ne_cpu_pool ne_cpu_pool;
>  
> +/**
> + * ne_check_enclaves_created() - Verify if at least one enclave has been created.
> + * @void:	No parameters provided.
> + *
> + * Context: Process context.
> + * Return:
> + * * True if at least one enclave is created.
> + * * False otherwise.
> + */
> +static bool ne_check_enclaves_created(void)
> +{
> +	struct ne_pci_dev *ne_pci_dev = NULL;
> +	struct pci_dev *pdev = NULL;
> +	bool ret = false;
> +
> +	if (!ne_misc_dev.parent)

How can that be the case?

I wouldn't rely on the misc device's internals to be something that you
count on for proper operation of your code, right?

thanks,

greg k-h
