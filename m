Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C39E26DE8C
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 16:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgIQOYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 10:24:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33843 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727484AbgIQOXD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 10:23:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600352582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N+XzmnG+kvw8mjEMuvlgAW7WnalZB0YK2WPw8iOe2js=;
        b=EiJzqc/8xpx7SfVYBiodL5K08DvOgERMnZXMdF6e53RS6mZsK5lx1IqO6YfwTxorBz0bsI
        9XE8G0hE4vXOW1tn6/F9D3dsnPBPGoAGun/41rWXZolnd9UWPXuc0GGYRaX4SpEa/c10X+
        E5rWohnA2aLuTjhosN/OoMUQvDqlyNc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-feP4RJ-zM12Dp-YPlH5Nqg-1; Thu, 17 Sep 2020 10:22:57 -0400
X-MC-Unique: feP4RJ-zM12Dp-YPlH5Nqg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F39880EDA5;
        Thu, 17 Sep 2020 14:22:55 +0000 (UTC)
Received: from gondolin (ovpn-113-19.ams2.redhat.com [10.36.113.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85DB455763;
        Thu, 17 Sep 2020 14:22:45 +0000 (UTC)
Date:   Thu, 17 Sep 2020 16:22:42 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 06/16] s390/vfio-ap: introduce shadow APCB
Message-ID: <20200917162242.1941772a.cohuck@redhat.com>
In-Reply-To: <20200821195616.13554-7-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-7-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Aug 2020 15:56:06 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The APCB is a field within the CRYCB that provides the AP configuration
> to a KVM guest. Let's introduce a shadow copy of the KVM guest's APCB and
> maintain it for the lifespan of the guest.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c     | 32 ++++++++++++++++++++++-----
>  drivers/s390/crypto/vfio_ap_private.h |  2 ++
>  2 files changed, 29 insertions(+), 5 deletions(-)

(...)

> @@ -1202,13 +1223,12 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  	if (ret)
>  		return NOTIFY_DONE;
>  
> -	/* If there is no CRYCB pointer, then we can't copy the masks */
> -	if (!matrix_mdev->kvm->arch.crypto.crycbd)
> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
>  		return NOTIFY_DONE;
>  
> -	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
> -				  matrix_mdev->matrix.aqm,
> -				  matrix_mdev->matrix.adm);
> +	memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
> +	       sizeof(matrix_mdev->shadow_apcb));
> +	vfio_ap_mdev_commit_crycb(matrix_mdev);

We are sure that the shadow APCB always matches up as we are the only
ones manipulating the APCB in the CRYCB, right?

>  
>  	return NOTIFY_OK;
>  }

