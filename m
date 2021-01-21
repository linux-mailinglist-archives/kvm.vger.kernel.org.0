Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326E62FF5FC
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 21:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbhAUUfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 15:35:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725842AbhAUUfI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 15:35:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611261203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pmArDKlP8XROGh7SSuqalHmLY6449V7ifWHPpsdrgcQ=;
        b=cY18VlBNXe+7vt6aFE81oa+xii7bx7PIZYiiU6EuIWzYOlr9NuOHhOiFrxDhEncVRb9KSM
        0DKG8wY1s4WKnsh7W5dZB4qvbEg3FsORS9nGrjpQqO6Y+gMsab0cYfdQNC0HegTeuI0yLC
        BTAM1rlhXs6BzjzQ/jDTRfpDWsbYCcA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-r-gj-hvoO0aukqMVw7Mi4A-1; Thu, 21 Jan 2021 15:33:21 -0500
X-MC-Unique: r-gj-hvoO0aukqMVw7Mi4A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73931800D55;
        Thu, 21 Jan 2021 20:33:19 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E50316EF49;
        Thu, 21 Jan 2021 20:33:18 +0000 (UTC)
Date:   Thu, 21 Jan 2021 13:33:18 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Fred Gao <fred.gao@intel.com>
Cc:     kvm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Swee Yee Fonn <swee.yee.fonn@intel.com>
Subject: Re: [PATCH v2] vfio/pci: Add support for opregion v2.0+
Message-ID: <20210121133318.3f0824e8@omen.home.shazbot.org>
In-Reply-To: <20210118123834.5991-1-fred.gao@intel.com>
References: <20201202171249.17083-1-fred.gao@intel.com>
        <20210118123834.5991-1-fred.gao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 Jan 2021 20:38:34 +0800
Fred Gao <fred.gao@intel.com> wrote:

> Before opregion version 2.0 VBT data is stored in opregion mailbox #4,
> However, When VBT data exceeds 6KB size and cannot be within mailbox #4
> starting from opregion v2.0+, Extended VBT region, next to opregion, is
> used to hold the VBT data, so the total size will be opregion size plus
> extended VBT region size.
> 
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Signed-off-by: Swee Yee Fonn <swee.yee.fonn@intel.com>
> Signed-off-by: Fred Gao <fred.gao@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_igd.c | 59 +++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
> index 53d97f459252..fc470278a492 100644
> --- a/drivers/vfio/pci/vfio_pci_igd.c
> +++ b/drivers/vfio/pci/vfio_pci_igd.c
> @@ -21,6 +21,10 @@
>  #define OPREGION_SIZE		(8 * 1024)
>  #define OPREGION_PCI_ADDR	0xfc
>  
> +#define OPREGION_RVDA		0x3ba
> +#define OPREGION_RVDS		0x3c2
> +#define OPREGION_VERSION	0x16
> +
>  static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
>  			      size_t count, loff_t *ppos, bool iswrite)
>  {
> @@ -58,6 +62,7 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
>  	u32 addr, size;
>  	void *base;
>  	int ret;
> +	u16 version;
>  
>  	ret = pci_read_config_dword(vdev->pdev, OPREGION_PCI_ADDR, &addr);
>  	if (ret)
> @@ -83,6 +88,60 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
>  
>  	size *= 1024; /* In KB */
>  
> +	/*
> +	 * Support opregion v2.0+
> +	 * When VBT data exceeds 6KB size and cannot be within mailbox #4
> +	 * Extended VBT region, next to opregion, is used to hold the VBT data.
> +	 * RVDA (Relative Address of VBT Data from Opregion Base) and RVDS
> +	 * (VBT Data Size) from opregion structure member are used to hold the
> +	 * address from region base and size of VBT data while RVDA/RVDS
> +	 * are not defined before opregion 2.0.
> +	 *
> +	 * opregion 2.0: rvda is the physical VBT address.
> +	 *
> +	 * opregion 2.1+: rvda is unsigned, relative offset from
> +	 * opregion base, and should never point within opregion.
> +	 */
> +	version = le16_to_cpu(*(__le16 *)(base + OPREGION_VERSION));
> +	if (version >= 0x0200) {
> +		u64 rvda;
> +		u32 rvds;
> +
> +		rvda = le64_to_cpu(*(__le64 *)(base + OPREGION_RVDA));
> +		rvds = le32_to_cpu(*(__le32 *)(base + OPREGION_RVDS));
> +		if (rvda && rvds) {
> +			u32 offset;
> +
> +			if (version == 0x0200)
> +				offset = rvda - (u64)addr;
> +			else
> +				offset = rvda;
> +
> +			if (offset != size) {
> +				pci_err(vdev->pdev,
> +				"Extended VBT does not follow opregion !\n"
> +				"opregion version 0x%x:offset 0x%x\n", version, offset);
> +				return -EINVAL;
> +			}
> +
> +			/*
> +			 * the only difference between opregion 2.0 and 2.1 is
> +			 * rvda addressing mode. since rvda is physical host
> +			 * VBT address and cannot be directly used in guest,
> +			 * faked into opregion 2.1's relative offset.
> +			 */
> +			if (version == 0x0200) {
> +				*(__le16 *)(base + OPREGION_VERSION) =
> +					cpu_to_le16(0x0201);
> +				(*(__le64 *)(base + OPREGION_RVDA)) =
> +					cpu_to_le64((rvda - (u64)addr));
> +			}

There's a much better description of the fields and logic here, thanks
for that.  I also see we've closed the gap to require the extended
region to immediately follow the opregion table.  The code
immediately above still makes me nervous as even if this is the only
difference between the specs, code might make some differentiation
based on the spec version, which we're changing in host memory for all
subsequent drivers until the host is rebooted.  Could we use a pci_dbg()
in this branch to flag that event in dmesg for debugging?  Thanks,

Alex

> +
> +			/* region size for opregion v2.0+: opregion and VBT size */
> +			size = offset + rvds;
> +		}
> +	}
> +
>  	if (size != OPREGION_SIZE) {
>  		memunmap(base);
>  		base = memremap(addr, size, MEMREMAP_WB);

