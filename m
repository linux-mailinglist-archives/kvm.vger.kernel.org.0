Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7102375CFE
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 23:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhEFVvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 17:51:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41891 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230048AbhEFVvX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 17:51:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620337823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q9h3TdRqA3v9lLQkKiiTDr2ssav5eexul01Jy9Pakf4=;
        b=CCfV5m1cWUgOFyEMAyPmn+ARdn+f6Z4jShdIcrM67+8WN+k7eQdjHbDg9fna1QYjhD2f1j
        KS7+ozRIobcZRZQn7QOAyCHSRsuEeq5+RLKDS0GOIj7GM5v0wjVdzWzrRXx7uA19+Y8P6R
        tfOBXfOxJTNu941JPV2lN/Tif3rm4Ts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-eeDIo886N2awTTLzwNq-Ug-1; Thu, 06 May 2021 17:50:21 -0400
X-MC-Unique: eeDIo886N2awTTLzwNq-Ug-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A7B7802938;
        Thu,  6 May 2021 21:50:20 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48D845D9CA;
        Thu,  6 May 2021 21:50:05 +0000 (UTC)
Date:   Thu, 6 May 2021 15:50:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Maxime Coquelin <maxime.coquelin@redhat.com>
Cc:     jmorris@namei.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, kvm@vger.kernel.org,
        mjg59@srcf.ucam.org, keescook@chromium.org, cohuck@redhat.com
Subject: Re: [PATCH] vfio: Lock down no-IOMMU mode when kernel is locked
 down
Message-ID: <20210506155004.7e214d8f@redhat.com>
In-Reply-To: <20210506091859.6961-1-maxime.coquelin@redhat.com>
References: <20210506091859.6961-1-maxime.coquelin@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 May 2021 11:18:59 +0200
Maxime Coquelin <maxime.coquelin@redhat.com> wrote:

> When no-IOMMU mode is enabled, VFIO is as unsafe as accessing
> the PCI BARs via the device's sysfs, which is locked down when
> the kernel is locked down.
> 
> Indeed, it is possible for an attacker to craft DMA requests
> to modify kernel's code or leak secrets stored in the kernel,
> since the device is not isolated by an IOMMU.
> 
> This patch introduces a new integrity lockdown reason for the
> unsafe VFIO no-iommu mode.

I'm hoping security folks will chime in here as I'm not familiar with
the standard practices for new lockdown reasons.  The vfio no-iommu
backend is clearly an integrity risk, which is why it's already hidden
behind a separate Kconfig option, requires RAWIO capabilities, and
taints the kernel if it's used, but I agree that preventing it during
lockdown seems like a good additional step.

Is it generally advised to create specific reasons, like done here, or
should we aim to create a more generic reason related to unrestricted
userspace DMA?

I understand we don't want to re-use PCI_ACCESS because the vfio
no-iommu backend is device agnostic, it can be used for both PCI and
non-PCI devices.

> Signed-off-by: Maxime Coquelin <maxime.coquelin@redhat.com>
> ---
>  drivers/vfio/vfio.c      | 13 +++++++++----
>  include/linux/security.h |  1 +
>  security/security.c      |  1 +
>  3 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 5e631c359ef2..fe466d6ea5d8 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -25,6 +25,7 @@
>  #include <linux/pci.h>
>  #include <linux/rwsem.h>
>  #include <linux/sched.h>
> +#include <linux/security.h>
>  #include <linux/slab.h>
>  #include <linux/stat.h>
>  #include <linux/string.h>
> @@ -165,7 +166,8 @@ static void *vfio_noiommu_open(unsigned long arg)
>  {
>  	if (arg != VFIO_NOIOMMU_IOMMU)
>  		return ERR_PTR(-EINVAL);
> -	if (!capable(CAP_SYS_RAWIO))
> +	if (!capable(CAP_SYS_RAWIO) ||
> +			security_locked_down(LOCKDOWN_VFIO_NOIOMMU))
>  		return ERR_PTR(-EPERM);
>  
>  	return NULL;
> @@ -1280,7 +1282,8 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
>  	if (atomic_read(&group->container_users))
>  		return -EINVAL;
>  
> -	if (group->noiommu && !capable(CAP_SYS_RAWIO))
> +	if (group->noiommu && (!capable(CAP_SYS_RAWIO) ||
> +			security_locked_down(LOCKDOWN_VFIO_NOIOMMU)))
>  		return -EPERM;
>  
>  	f = fdget(container_fd);
> @@ -1362,7 +1365,8 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
>  	    !group->container->iommu_driver || !vfio_group_viable(group))
>  		return -EINVAL;
>  
> -	if (group->noiommu && !capable(CAP_SYS_RAWIO))
> +	if (group->noiommu && (!capable(CAP_SYS_RAWIO) ||
> +			security_locked_down(LOCKDOWN_VFIO_NOIOMMU)))
>  		return -EPERM;
>  
>  	device = vfio_device_get_from_name(group, buf);
> @@ -1490,7 +1494,8 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
>  	if (!group)
>  		return -ENODEV;
>  
> -	if (group->noiommu && !capable(CAP_SYS_RAWIO)) {
> +	if (group->noiommu && (!capable(CAP_SYS_RAWIO) ||
> +			security_locked_down(LOCKDOWN_VFIO_NOIOMMU))) {
>  		vfio_group_put(group);
>  		return -EPERM;
>  	}

In these cases where we're testing RAWIO, the idea is to raise the
barrier of passing file descriptors to unprivileged users.  Is lockdown
sufficiently static that we might really only need the test on open?
The latter three cases here only make sense if the user were able to
open a no-iommu context when lockdown is not enabled, then lockdown is
later enabled preventing them from doing anything with that context...
but not preventing ongoing unsafe usage that might already exist.  I
suspect for that reason that lockdown is static and we really only need
the test on open.  Thanks,

Alex

> diff --git a/include/linux/security.h b/include/linux/security.h
> index 06f7c50ce77f..f29388180fab 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -120,6 +120,7 @@ enum lockdown_reason {
>  	LOCKDOWN_MMIOTRACE,
>  	LOCKDOWN_DEBUGFS,
>  	LOCKDOWN_XMON_WR,
> +	LOCKDOWN_VFIO_NOIOMMU,
>  	LOCKDOWN_INTEGRITY_MAX,
>  	LOCKDOWN_KCORE,
>  	LOCKDOWN_KPROBES,
> diff --git a/security/security.c b/security/security.c
> index b38155b2de83..33c3ddb6dcab 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -58,6 +58,7 @@ const char *const lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
>  	[LOCKDOWN_MMIOTRACE] = "unsafe mmio",
>  	[LOCKDOWN_DEBUGFS] = "debugfs access",
>  	[LOCKDOWN_XMON_WR] = "xmon write access",
> +	[LOCKDOWN_VFIO_NOIOMMU] = "VFIO unsafe no-iommu mode",
>  	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
>  	[LOCKDOWN_KCORE] = "/proc/kcore access",
>  	[LOCKDOWN_KPROBES] = "use of kprobes",

