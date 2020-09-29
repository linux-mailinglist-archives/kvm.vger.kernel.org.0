Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EB527DB64
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 00:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgI2WGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 18:06:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53232 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728169AbgI2WGd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 18:06:33 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601417191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vumJlGpwUKK+qdTQHXc4b0hHir+AlD58BoyC7olPt8A=;
        b=Cii21L/CxBTAkiEsrxXPDbMbh+rLXDU/veG0cHjDj0eXD+yT6Jgd3KhZzk5o7bs85/+pPO
        S/K1XhE7ZhiabhRRuKmqGbMoaJnhNpVum/1hmaJ+c+KSH6qs1yr3g4gGAuAK7W07jAoRgi
        nOtYuCET8oPjwwWG2zPgVJ2lqY2RqPA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-iG-B3dcEO029IGk2dQjm0g-1; Tue, 29 Sep 2020 18:06:27 -0400
X-MC-Unique: iG-B3dcEO029IGk2dQjm0g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFAA3873081;
        Tue, 29 Sep 2020 22:06:25 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 101875D9CA;
        Tue, 29 Sep 2020 22:06:24 +0000 (UTC)
Date:   Tue, 29 Sep 2020 16:06:24 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Fred Gao <fred.gao@intel.com>
Cc:     kvm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Hang Yuan <hang.yuan@linux.intel.com>,
        Stuart Summers <stuart.summers@intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>
Subject: Re: [PATCH v2] vfio/pci: Refine Intel IGD OpRegion support
Message-ID: <20200929160624.767f0d9e@x1.home>
In-Reply-To: <20200929161038.15465-1-fred.gao@intel.com>
References: <20200929161038.15465-1-fred.gao@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 30 Sep 2020 00:10:38 +0800
Fred Gao <fred.gao@intel.com> wrote:

> Bypass the IGD initialization for Intel's dgfx devices with own expansion
> ROM and the host/LPC bridge config space are no longer accessed.
> 
> v2: simply test if discrete or integrated gfx device
>     with root bus. (Alex Williamson)
> 
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Xiong Zhang <xiong.y.zhang@intel.com>
> Cc: Hang Yuan <hang.yuan@linux.intel.com>
> Cc: Stuart Summers <stuart.summers@intel.com>
> Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
> Signed-off-by: Fred Gao <fred.gao@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index f634c81998bb..9258ccfadb79 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -336,10 +336,11 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
>  	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
>  		vdev->has_vga = true;
>  
> -
> +	/* Intel's dgfx should not appear on root bus */
>  	if (vfio_pci_is_vga(pdev) &&
>  	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
> -	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
> +	    IS_ENABLED(CONFIG_VFIO_PCI_IGD) &&
> +	    pci_is_root_bus(pdev->bus)) {
>  		ret = vfio_pci_igd_init(vdev);
>  		if (ret) {
>  			pci_warn(pdev, "Failed to setup Intel IGD regions\n");


The comment seems rather misplaced here, it only refers to one switch,
several lines down within the set of conditions, but looks like a
header for the entire branch.  I think it would be better to either
expand the comment to describe the entire branch, including the
exclusion, or try to fit the exclusion comment alongside the test, ie.

	/*
	 * Intel IGD requires quirks to support guest drivers.  IGD is
	 * identified as an Intel VGA device on the root bus.
	 */

Or
	    pci_is_root_bus(pdev->bus)) { /* Skip discrete gfx */

The commit title should really include something about excluding
discrete graphics from IGD quirks as well.  It might help downstreams
backport it for support.

It also occurs to me that relying on the physical topology only works
at the bare metal level.  We could for example assign a dgfx device at
address 00:02.0 in the guest.  Nested assignment of that device would
trigger calling vfio_pci_igd_init() and fail.  I see igd has a PCIe
capability type of PCI_EXP_TYPE_RC_END and I'd expect dgfx to have a
type of PCI_EXP_TYPE_LEG_END, but unfortunately QEMU does too good of a
job emulating the PCIe capability and will mangle these to suit the
guest topology.  I wonder then if our best course is to make the above
branch more lenient, for example pruning the failure paths such that we
could use -ENODEV as a non-terminal error like is done for the NVLink
quirks below this code block.  Failure to find an OpRegion might be our
differentiation, where on bare metal we might have both igd and dgfx,
so we'd need the root bus test, but assigning dgfx to a VM and placing
it on the VM root bus wouldn't generate an OpRegion, so both levels
would take the dgfx path.  IGD placed on a non-root bus in the guest
could probably just be considered a misconfiguration by the user...
Thanks,

Alex

