Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04E02168FE
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 11:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgGGJ1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 05:27:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37993 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726540AbgGGJ1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 05:27:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594114026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TOdN6oueiJxGC26XWRVlU9vS6Ei4rnzo4eoopPeqQeU=;
        b=I+2VSG+66MXfTth3TPMyd3n8VWGhRlLZhyxbcs162btoXSQNE9Pq97+L/MeQrfZKuQqU5P
        bz6R8hPbsQIPCwR5Vbf/Akj6IozSMRklydRBaFMg6wh/NFL3T356x9ISy2q93nPNyzWBZw
        hxLhs13/C1LL9hc7QWCdsm6w7GHm4QM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-_ge2CFzUMZOYaw2qde8EQA-1; Tue, 07 Jul 2020 05:27:03 -0400
X-MC-Unique: _ge2CFzUMZOYaw2qde8EQA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D14F5800406;
        Tue,  7 Jul 2020 09:27:00 +0000 (UTC)
Received: from gondolin (ovpn-113-54.ams2.redhat.com [10.36.113.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE25A60E3E;
        Tue,  7 Jul 2020 09:26:54 +0000 (UTC)
Date:   Tue, 7 Jul 2020 11:26:52 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v4 1/2] virtio: let arch validate VIRTIO features
Message-ID: <20200707112652.42fcab80.cohuck@redhat.com>
In-Reply-To: <1594111477-15401-2-git-send-email-pmorel@linux.ibm.com>
References: <1594111477-15401-1-git-send-email-pmorel@linux.ibm.com>
        <1594111477-15401-2-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Jul 2020 10:44:36 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> An architecture may need to validate the VIRTIO devices features
> based on architecture specificities.

s/specifities/specifics/

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  drivers/virtio/virtio.c       | 19 +++++++++++++++++++
>  include/linux/virtio_config.h |  1 +
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index a977e32a88f2..3179a8aa76f5 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -167,6 +167,21 @@ void virtio_add_status(struct virtio_device *dev, unsigned int status)
>  }
>  EXPORT_SYMBOL_GPL(virtio_add_status);
>  
> +/*
> + * arch_needs_virtio_iommu_platform - provide arch specific hook when finalizing

s/arch_needs_virtio_iommu_platform/arch_validate_virtio_features/

:)

> + *				      features for VIRTIO device dev
> + * @dev: the VIRTIO device being added
> + *
> + * Permits the platform to provide architecture specific functionality when

s/provide architecture specific functionality/handle architecture-specific requirements/

?

> + * devices features are finalized. This is the default implementation.

s/devices/device/

> + * Architecture implementations can override this.
> + */
> +
> +int __weak arch_validate_virtio_features(struct virtio_device *dev)
> +{
> +	return 0;
> +}
> +
>  int virtio_finalize_features(struct virtio_device *dev)
>  {
>  	int ret = dev->config->finalize_features(dev);
> @@ -176,6 +191,10 @@ int virtio_finalize_features(struct virtio_device *dev)
>  	if (ret)
>  		return ret;
>  
> +	ret = arch_validate_virtio_features(dev);
> +	if (ret)
> +		return ret;
> +
>  	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
>  		return 0;
>  
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index bb4cc4910750..3f4117adf311 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -459,4 +459,5 @@ static inline void virtio_cwrite64(struct virtio_device *vdev,
>  		_r;							\
>  	})
>  
> +int arch_validate_virtio_features(struct virtio_device *dev);
>  #endif /* _LINUX_VIRTIO_CONFIG_H */

With the wording fixed,

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

