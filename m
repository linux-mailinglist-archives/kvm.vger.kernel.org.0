Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6897A24D4A2
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 14:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgHUMFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 08:05:32 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30880 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727843AbgHUMF1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Aug 2020 08:05:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598011525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QtKGfR+1iR3kEPsEfjDAOfFZGutCuRuneaQE3YwB9Lg=;
        b=OGx1XxScDqNqx0DyLVsiMUTHwAfWbI2wH19FA03ABwJEZEpGKvLs51V5XzXN4Vyy3fr7i1
        4q18ufGNjoq6q+gtCgNYSoFbibHG0aQtHG+HGflngXOxhPaLVeckLqguGuv+bWzdQGm2Jl
        fDpr9Jek8I4OwLbizGq3Pfz4WUfwpoY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-2ptqIlFQPKaVrVvN1P1Tbw-1; Fri, 21 Aug 2020 08:05:21 -0400
X-MC-Unique: 2ptqIlFQPKaVrVvN1P1Tbw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AF017A162;
        Fri, 21 Aug 2020 12:05:19 +0000 (UTC)
Received: from gondolin (ovpn-113-4.ams2.redhat.com [10.36.113.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0614D5D9CC;
        Fri, 21 Aug 2020 12:05:12 +0000 (UTC)
Date:   Fri, 21 Aug 2020 14:05:10 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v9 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
Message-ID: <20200821140510.3849410c.cohuck@redhat.com>
In-Reply-To: <1597854198-2871-3-git-send-email-pmorel@linux.ibm.com>
References: <1597854198-2871-1-git-send-email-pmorel@linux.ibm.com>
        <1597854198-2871-3-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Aug 2020 18:23:18 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> If protected virtualization is active on s390, VIRTIO has retricted

s/retricted/only restricted/

> access to the guest memory.
> Define CONFIG_ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS and export
> arch_has_restricted_virtio_memory_access to advertize VIRTIO if that's
> the case, preventing a host error on access attempt.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  arch/s390/Kconfig   |  1 +
>  arch/s390/mm/init.c | 11 +++++++++++
>  2 files changed, 12 insertions(+)

(...)

> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> index 6dc7c3b60ef6..8febd73ed6ca 100644
> --- a/arch/s390/mm/init.c
> +++ b/arch/s390/mm/init.c
> @@ -45,6 +45,7 @@
>  #include <asm/kasan.h>
>  #include <asm/dma-mapping.h>
>  #include <asm/uv.h>
> +#include <linux/virtio_config.h>

I don't think you need this include anymore.

>  
>  pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
>  

(...)

With the nit fixed,

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

