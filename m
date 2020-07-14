Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4E321EFDE
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 13:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgGNL4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 07:56:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41140 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728093AbgGNL4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 07:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594727770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ykcZBNksAR9Za8nLz+KVj+UU2/4kb9H0fHJr+dQVzzs=;
        b=cePRBJXKGmH10MtMaZRS2DNW/WxuBHQPYfsWEkptt3quCqojZmjcBsoV2KuF4LIJb40jC7
        oMgnW59Qxja0Luz3CsEH2v8wlf8N2kpm4duNTJ9FuQFxYEctKF0k0dz8u9k44NBdt4AUsN
        BZGsIQOWBPvq/Mo1De3JRPLvdEmSiiA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-Odd-OnzdOimKF9ZZRcmQPA-1; Tue, 14 Jul 2020 07:56:06 -0400
X-MC-Unique: Odd-OnzdOimKF9ZZRcmQPA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A5E08014D7;
        Tue, 14 Jul 2020 11:56:04 +0000 (UTC)
Received: from gondolin (ovpn-112-240.ams2.redhat.com [10.36.112.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 717F260CD0;
        Tue, 14 Jul 2020 11:55:58 +0000 (UTC)
Date:   Tue, 14 Jul 2020 13:55:55 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v6 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
Message-ID: <20200714135555.2148fb83.cohuck@redhat.com>
In-Reply-To: <1594726682-12076-3-git-send-email-pmorel@linux.ibm.com>
References: <1594726682-12076-1-git-send-email-pmorel@linux.ibm.com>
        <1594726682-12076-3-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Jul 2020 13:38:02 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> If protected virtualization is active on s390, the virtio queues are
> not accessible to the host, unless VIRTIO_F_IOMMU_PLATFORM has been
> negotiated. Use the new arch_validate_virtio_features() interface to
> fail probe if that's not the case, preventing a host error on access
> attempt.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Acked-by: Halil Pasic <pasic@linux.ibm.com>
> ---
>  arch/s390/mm/init.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)

(...)

> +int arch_validate_virtio_features(struct virtio_device *dev)
> +{
> +	if (!is_prot_virt_guest())
> +		return 0;
> +
> +	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
> +		dev_warn(&dev->dev,
> +			 "legacy virtio not supported with protected virtualizatio\n");

typo: s/virtualizatio/virtualization/

> +		return -ENODEV;
> +	}
> +
> +	if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
> +		dev_warn(&dev->dev,
> +			 "support for limited memory access required for protected virtualization\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
>  /* protected virtualization */
>  static void pv_init(void)
>  {

