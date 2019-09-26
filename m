Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC09BEAA7
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 04:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390217AbfIZCgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 22:36:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727880AbfIZCgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 22:36:21 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 848A481F0C;
        Thu, 26 Sep 2019 02:36:21 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7620600C8;
        Thu, 26 Sep 2019 02:36:20 +0000 (UTC)
Date:   Wed, 25 Sep 2019 20:36:20 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     kwankhede@nvidia.com, kevin.tian@intel.com,
        baolu.lu@linux.intel.com, yi.y.sun@intel.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yan.y.zhao@intel.com, shaopeng.he@intel.com, chenbo.xia@intel.com,
        jun.j.tian@intel.com
Subject: Re: [PATCH v2 08/13] vfio/pci: protect cap/ecap_perm bits
 alloc/free with atomic op
Message-ID: <20190925203620.301c66ca@x1.home>
In-Reply-To: <1567670370-4484-9-git-send-email-yi.l.liu@intel.com>
References: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
        <1567670370-4484-9-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 26 Sep 2019 02:36:21 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  5 Sep 2019 15:59:25 +0800
Liu Yi L <yi.l.liu@intel.com> wrote:

> There is a case in which cap_perms and ecap_perms can be reallocated
> by different modules. e.g. the vfio-mdev-pci sample driver. To secure
> the initialization of cap_perms and ecap_perms, this patch adds an
> atomic variable to track the user of cap/ecap_perms bits. First caller
> of vfio_pci_init_perm_bits() will initialize the bits. While the last
> caller of vfio_pci_uninit_perm_bits() will free the bits.

Yes, but it still allows races; we're not really protecting the data.
If driver A begins freeing the shared data in the uninit path, driver B
could start allocating shared data in the init path and we're left with
either use after free issues or memory leaks.  Probably better to hold
a semaphore around the allocation/free and a non-atomic for reference
counting.  Thanks,

Alex
 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index f0891bd..1b3e6e5 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -992,11 +992,17 @@ static int __init init_pci_ext_cap_pwr_perm(struct perm_bits *perm)
>  	return 0;
>  }
>  
> +/* Track the user number of the cap/ecap perm_bits */
> +atomic_t vfio_pci_perm_bits_users = ATOMIC_INIT(0);
> +
>  /*
>   * Initialize the shared permission tables
>   */
>  void vfio_pci_uninit_perm_bits(void)
>  {
> +	if (atomic_dec_return(&vfio_pci_perm_bits_users))
> +		return;
> +
>  	free_perm_bits(&cap_perms[PCI_CAP_ID_BASIC]);
>  
>  	free_perm_bits(&cap_perms[PCI_CAP_ID_PM]);
> @@ -1013,6 +1019,9 @@ int __init vfio_pci_init_perm_bits(void)
>  {
>  	int ret;
>  
> +	if (atomic_inc_return(&vfio_pci_perm_bits_users) != 1)
> +		return 0;
> +
>  	/* Basic config space */
>  	ret = init_pci_cap_basic_perm(&cap_perms[PCI_CAP_ID_BASIC]);
>  

