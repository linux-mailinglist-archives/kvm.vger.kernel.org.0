Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9197C2A4E76
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 19:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbgKCSVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 13:21:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33444 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729401AbgKCSVv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Nov 2020 13:21:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604427710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5HaZF0HHG9oO3e49yeD9DsV0qAb3GYn1OcgqbvDseMU=;
        b=KAGeQVv0lF1FKijso/bWQfL/+1m3Wf3tkpVuU0jE/68sP1sSqWYa46ZKK6CS6XKu1yvaDq
        xqb5n7evSVsnjSDV5RHpCD5h+3PDZUUTVH7TxNgmJmHi1kyPixhDd/H/XGz7hb+VuKrp+t
        EWFc47S9hO12SJ8c0UYtuWB+VCNuQAc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-y6tC8vg3OimS9rP6mtrDrw-1; Tue, 03 Nov 2020 13:21:46 -0500
X-MC-Unique: y6tC8vg3OimS9rP6mtrDrw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6E8B1009E23;
        Tue,  3 Nov 2020 18:21:44 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13B251002D46;
        Tue,  3 Nov 2020 18:21:44 +0000 (UTC)
Date:   Tue, 3 Nov 2020 11:21:43 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Fred Gao <fred.gao@intel.com>
Cc:     kvm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Hang Yuan <hang.yuan@linux.intel.com>,
        Stuart Summers <stuart.summers@intel.com>
Subject: Re: [PATCH v3] vfio/pci: Bypass IGD init in case of -ENODEV
Message-ID: <20201103112143.07682d41@w520.home>
In-Reply-To: <20201102180120.25319-1-fred.gao@intel.com>
References: <20200929161038.15465-1-fred.gao@intel.com>
        <20201102180120.25319-1-fred.gao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  3 Nov 2020 02:01:20 +0800
Fred Gao <fred.gao@intel.com> wrote:

> Bypass the IGD initialization when -ENODEV returns,
> that should be the case if opregion is not available for IGD
> or within discrete graphics device's option ROM,
> or host/lpc bridge is not found.
> 
> Then use of -ENODEV here means no special device resources found
> which needs special care for VFIO, but we still allow other normal
> device resource access.
> 
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Xiong Zhang <xiong.y.zhang@intel.com>
> Cc: Hang Yuan <hang.yuan@linux.intel.com>
> Cc: Stuart Summers <stuart.summers@intel.com>
> Signed-off-by: Fred Gao <fred.gao@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to vfio for-linus branch for v5.10.  Thanks,

Alex

> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index f634c81998bb..c88cf9937469 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -341,7 +341,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
>  	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
>  	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
>  		ret = vfio_pci_igd_init(vdev);
> -		if (ret) {
> +		if (ret && ret != -ENODEV) {
>  			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
>  			goto disable_exit;
>  		}

