Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F31D248CE2
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 19:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbgHRRWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 13:22:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42357 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728620AbgHRRWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 13:22:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597771368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R08BwjXqzWFxBJwSN04NiBU/noVfIjB10z++NeMlyQE=;
        b=LwYkRXg01VKLan5aPoa1M77JDcvLYnc0ppZoPR0llFf/p47XKKygtCWRarKKkJGBTixsMR
        JX0Fz75ua8cCJltDkpyvW9x3FbPpVo38Tzbk98MPl75UwE0jkivwGHNXhx5hPjN5VTT5Km
        FJhQCH83jPzAQV31rzQVg0oB3YifrCk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-Njsv1FvbPQazsJW1j4QtZw-1; Tue, 18 Aug 2020 13:22:43 -0400
X-MC-Unique: Njsv1FvbPQazsJW1j4QtZw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A709310066FF;
        Tue, 18 Aug 2020 17:22:41 +0000 (UTC)
Received: from gondolin (ovpn-112-221.ams2.redhat.com [10.36.112.221])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE2BF5D9DC;
        Tue, 18 Aug 2020 17:22:35 +0000 (UTC)
Date:   Tue, 18 Aug 2020 19:22:33 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v8 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
Message-ID: <20200818192233.6c80798e.cohuck@redhat.com>
In-Reply-To: <1597762711-3550-3-git-send-email-pmorel@linux.ibm.com>
References: <1597762711-3550-1-git-send-email-pmorel@linux.ibm.com>
        <1597762711-3550-3-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Aug 2020 16:58:31 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> If protected virtualization is active on s390, the virtio queues are
> not accessible to the host, unless VIRTIO_F_IOMMU_PLATFORM has been
> negotiated.
> Define CONFIG_ARCH_HAS_RESTRICTED_MEMORY_ACCESS and export
> arch_has_restricted_memory_access to fail probe if that's
> not the case, preventing a host error on access attempt.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  arch/s390/Kconfig   |  1 +
>  arch/s390/mm/init.c | 30 ++++++++++++++++++++++++++++++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 9cfd8de907cb..d4a3ef4fa27b 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -820,6 +820,7 @@ menu "Virtualization"
>  config PROTECTED_VIRTUALIZATION_GUEST
>  	def_bool n
>  	prompt "Protected virtualization guest support"
> +	select ARCH_HAS_RESTRICTED_MEMORY_ACCESS
>  	help
>  	  Select this option, if you want to be able to run this
>  	  kernel as a protected virtualization KVM guest.
> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> index 6dc7c3b60ef6..aec04d7dd089 100644
> --- a/arch/s390/mm/init.c
> +++ b/arch/s390/mm/init.c
> @@ -45,6 +45,7 @@
>  #include <asm/kasan.h>
>  #include <asm/dma-mapping.h>
>  #include <asm/uv.h>
> +#include <linux/virtio_config.h>
>  
>  pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
>  
> @@ -161,6 +162,35 @@ bool force_dma_unencrypted(struct device *dev)
>  	return is_prot_virt_guest();
>  }
>  
> +#ifdef CONFIG_ARCH_HAS_RESTRICTED_MEMORY_ACCESS
> +/*
> + * arch_has_restricted_memory_access
> + * @dev: the VIRTIO device being added
> + *
> + * Return an error if required features are missing on a guest running
> + * with protected virtualization.
> + */
> +int arch_has_restricted_memory_access(struct virtio_device *dev)
> +{
> +	if (!is_prot_virt_guest())
> +		return 0;

If you just did a

return is_prot_virt_guest();

and did the virtio feature stuff in the virtio core, this function
would be short and sweet :)

> +
> +	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
> +		dev_warn(&dev->dev, "device must provide VIRTIO_F_VERSION_1\n");
> +		return -ENODEV;
> +	}
> +
> +	if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
> +		dev_warn(&dev->dev,
> +			 "device must provide VIRTIO_F_IOMMU_PLATFORM\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(arch_has_restricted_memory_access);
> +#endif
> +
>  /* protected virtualization */
>  static void pv_init(void)
>  {

