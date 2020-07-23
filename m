Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF8222A6C4
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 07:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbgGWFCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 01:02:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52117 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725814AbgGWFCS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jul 2020 01:02:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595480536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WQ8HFJRjSjgVFhmZYkcj0k9hnN0PLKzblt1+tXuDhM8=;
        b=LeK8RXpwcXfg/sby/mFnkIXUMW3zwQBprvIgyoYYj53Rjv9hCNgkIt0qpsyM6m45ntG9ke
        mKYxcMHxUClT6WhdYBW70R4Zl+6gofetef89sDz/0ix0rXmTRp7ttgz9yv4FgNrZGDsemy
        rkUFd9c4oWzS++swLUnBbT8nFeevp4Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-aDaIhfkuPLWS2wb98L5psw-1; Thu, 23 Jul 2020 01:02:14 -0400
X-MC-Unique: aDaIhfkuPLWS2wb98L5psw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94015106B245;
        Thu, 23 Jul 2020 05:02:12 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51CE01A888;
        Thu, 23 Jul 2020 05:02:11 +0000 (UTC)
Date:   Wed, 22 Jul 2020 23:02:10 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     herbert@gondor.apana.org.au, cohuck@redhat.com, nhorman@redhat.com,
        vdronov@redhat.com, bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] vfio/pci: Add device blocklist
Message-ID: <20200722230210.55b2d326@x1.home>
In-Reply-To: <20200714063610.849858-3-giovanni.cabiddu@intel.com>
References: <20200714063610.849858-1-giovanni.cabiddu@intel.com>
        <20200714063610.849858-3-giovanni.cabiddu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Jul 2020 07:36:07 +0100
Giovanni Cabiddu <giovanni.cabiddu@intel.com> wrote:

> Add blocklist of devices that by default are not probed by vfio-pci.
> Devices in this list may be susceptible to untrusted application, even
> if the IOMMU is enabled. To be accessed via vfio-pci, the user has to
> explicitly disable the blocklist.
> 
> The blocklist can be disabled via the module parameter disable_blocklist.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)

Hi Giovanni,

I'm pretty satisfied with this series, except "blocklist" makes me
think of block devices, ie. storage, or block chains, or building block
types of things before I get to "block" as in a barrier.  The other
alternative listed as a suggestion currently in linux-next is denylist,
which is the counter to an allowlist.  I've already proposed changing
some other terminology in vfio.c to use the term "allowed", so
allow/deny would be my preference versus pass/block.

> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 7c0779018b1b..ea5904ca6cbf 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -60,6 +60,10 @@ module_param(enable_sriov, bool, 0644);
>  MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV configuration.  Enabling SR-IOV on a PF typically requires support of the userspace PF driver, enabling VFs without such support may result in non-functional VFs or PF.");
>  #endif
>  
> +static bool disable_blocklist;
> +module_param(disable_blocklist, bool, 0444);
> +MODULE_PARM_DESC(disable_blocklist, "Disable device blocklist. If set, i.e. blocklist disabled, then blocklisted devices are allowed to be probed by vfio-pci.");

This seems a little obtuse, could we expand a bit to allow users to
understand why a device might be on the denylist?  Ex:

"Disable use of device denylist, which prevents binding to device with
known errata that may lead to exploitable stability or security issues
when accessed by untrusted users."

I think that more properly sets expectations when a device is denied
via this list and the admin looks to see how they might workaround it.

> +
>  static inline bool vfio_vga_disabled(void)
>  {
>  #ifdef CONFIG_VFIO_PCI_VGA
> @@ -69,6 +73,29 @@ static inline bool vfio_vga_disabled(void)
>  #endif
>  }
>  
> +static bool vfio_pci_dev_in_blocklist(struct pci_dev *pdev)
> +{
> +	return false;
> +}
> +
> +static bool vfio_pci_is_blocklisted(struct pci_dev *pdev)
> +{
> +	if (!vfio_pci_dev_in_blocklist(pdev))
> +		return false;
> +
> +	if (disable_blocklist) {
> +		pci_warn(pdev,
> +			 "device blocklist disabled - allowing device %04x:%04x.\n",

Here we even use "allowing" to describe what happens when the blocklist
is disabled, "deny" is a more proper antonym of allow.

> +			 pdev->vendor, pdev->device);
> +		return false;
> +	}
> +
> +	pci_warn(pdev, "%04x:%04x is blocklisted - probe will fail.\n",

Perhaps "%04x:%04x exists in vfio-pci device denylist, driver probing
disallowed.\n",...

Thanks,
Alex

> +		 pdev->vendor, pdev->device);
> +
> +	return true;
> +}
> +
>  /*
>   * Our VGA arbiter participation is limited since we don't know anything
>   * about the device itself.  However, if the device is the only VGA device
> @@ -1847,6 +1874,9 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	struct iommu_group *group;
>  	int ret;
>  
> +	if (vfio_pci_is_blocklisted(pdev))
> +		return -EINVAL;
> +
>  	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
>  		return -EINVAL;
>  
> @@ -2336,6 +2366,9 @@ static int __init vfio_pci_init(void)
>  
>  	vfio_pci_fill_ids();
>  
> +	if (disable_blocklist)
> +		pr_warn("device blocklist disabled.\n");
> +
>  	return 0;
>  
>  out_driver:

