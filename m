Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA086193D22
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 11:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgCZKmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 06:42:22 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:41192 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727560AbgCZKmW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Mar 2020 06:42:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585219340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SMOUI+bvAPqK1BfD7RNWCSWqgZw9IrmuuEDiPkLMo8o=;
        b=c1RV+JYkg+0DhQnTwAHziNKGo7EyHFAG2EkW9G/gwelhavv1m0xM9GnkPSs1ecYN0q2Yzh
        2TUndEV6HO4jp41g6Cnf0ifhHPZRmqmThNwsXDGOnsdOmpgA4xOVZdk0woftc79Bx8ULgZ
        qUKqQaTbWX4VDYs024e5vT0SVJw5Y4w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-CBT80w8hODW5QOrUM5d4VQ-1; Thu, 26 Mar 2020 06:42:17 -0400
X-MC-Unique: CBT80w8hODW5QOrUM5d4VQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8059DB94;
        Thu, 26 Mar 2020 10:42:08 +0000 (UTC)
Received: from gondolin (ovpn-112-191.ams2.redhat.com [10.36.112.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2E7B1001F43;
        Thu, 26 Mar 2020 10:41:53 +0000 (UTC)
Date:   Thu, 26 Mar 2020 11:41:50 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <alex.williamson@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v16 Kernel 1/7] vfio: KABI for migration interface for
 device state
Message-ID: <20200326114150.2b5430b9.cohuck@redhat.com>
In-Reply-To: <1585078359-20124-2-git-send-email-kwankhede@nvidia.com>
References: <1585078359-20124-1-git-send-email-kwankhede@nvidia.com>
        <1585078359-20124-2-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 25 Mar 2020 01:02:33 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> - Defined MIGRATION region type and sub-type.
> 
> - Defined vfio_device_migration_info structure which will be placed at the
>   0th offset of migration region to get/set VFIO device related
>   information. Defined members of structure and usage on read/write access.
> 
> - Defined device states and state transition details.
> 
> - Defined sequence to be followed while saving and resuming VFIO device.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 228 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 228 insertions(+)

(...)

> +struct vfio_device_migration_info {
> +	__u32 device_state;         /* VFIO device state */
> +#define VFIO_DEVICE_STATE_STOP      (0)
> +#define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
> +#define VFIO_DEVICE_STATE_SAVING    (1 << 1)
> +#define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
> +#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
> +				     VFIO_DEVICE_STATE_SAVING |  \
> +				     VFIO_DEVICE_STATE_RESUMING)
> +
> +#define VFIO_DEVICE_STATE_VALID(state) \
> +	(state & VFIO_DEVICE_STATE_RESUMING ? \
> +	(state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_RESUMING : 1)
> +
> +#define VFIO_DEVICE_STATE_IS_ERROR(state) \
> +	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_SAVING | \
> +					      VFIO_DEVICE_STATE_RESUMING))
> +
> +#define VFIO_DEVICE_STATE_SET_ERROR(state) \
> +	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
> +					     VFIO_DEVICE_STATE_RESUMING)
> +
> +	__u32 reserved;
> +	__u64 pending_bytes;
> +	__u64 data_offset;
> +	__u64 data_size;
> +} __attribute__((packed));

The 'packed' should not even be needed, I think?

> +
>  /*
>   * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
>   * which allows direct access to non-MSIX registers which happened to be within

Generally, this looks sane to me; however, we should really have
something under Documentation/ in the long run that describes how this
works, so that you can find out about the protocol without having to
dig through headers.

