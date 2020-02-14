Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71A2615D56C
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 11:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387426AbgBNKVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 05:21:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46103 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387422AbgBNKVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 05:21:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581675675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Ayh2tnJQJdwrE+Izh3eyPQUsTl4xHoZTP2dpD1dWY8=;
        b=EVfl6fK9RHICajNtjFNI0Ic5QLjW2GIChgpgW7fK9LTIsXMP16CkCR3Q+sUwJf38rDSQbX
        sv/NlUBnlsPYO/iSskgPojhjX6hv5REj5m5KEtJOnijXEksRX2ryrwhVXZqfV8gW3NbLYp
        kvzcVGcCGbOCks8RLTZuhV1QPPeHLsg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-tytk9UiWPmGVpa_zEbOjyg-1; Fri, 14 Feb 2020 05:21:13 -0500
X-MC-Unique: tytk9UiWPmGVpa_zEbOjyg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31080A0CC0;
        Fri, 14 Feb 2020 10:21:10 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BC7A5C115;
        Fri, 14 Feb 2020 10:21:03 +0000 (UTC)
Date:   Fri, 14 Feb 2020 11:21:00 +0100
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
Subject: Re: [PATCH v12 Kernel 1/7] vfio: KABI for migration interface for
 device state
Message-ID: <20200214112100.4e73722b.cohuck@redhat.com>
In-Reply-To: <1581104554-10704-2-git-send-email-kwankhede@nvidia.com>
References: <1581104554-10704-1-git-send-email-kwankhede@nvidia.com>
        <1581104554-10704-2-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 8 Feb 2020 01:12:28 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

(...)

Minor wording nits:

> +/*
> + * Structure vfio_device_migration_info is placed at 0th offset of

"...at the 0th offset..."

> + * VFIO_REGION_SUBTYPE_MIGRATION region to get/set VFIO device related migration
> + * information. Field accesses from this structure are only supported at their
> + * native width and alignment, otherwise the result is undefined and vendor
> + * drivers should return an error.
> + *
> + * device_state: (read/write)
> + *      - User application writes this field to inform vendor driver about the

I'd probably add a definitive article before "user application",
"vendor driver", etc. Not sure if it's too much churn.

> + *        device state to be transitioned to.
> + *      - Vendor driver should take necessary actions to change device state.
> + *        On successful transition to given state, vendor driver should return
> + *        success on write(device_state, state) system call. If device state
> + *        transition fails, vendor driver should return error, -EFAULT.
> + *      - On user application side, if device state transition fails, i.e. if
> + *        write(device_state, state) returns error, read device_state again to
> + *        determine the current state of the device from vendor driver.
> + *      - Vendor driver should return previous state of the device unless vendor
> + *        driver has encountered an internal error, in which case vendor driver
> + *        may report the device_state VFIO_DEVICE_STATE_ERROR.
> + *	- User application must use the device reset ioctl in order to recover
> + *	  the device from VFIO_DEVICE_STATE_ERROR state. If the device is
> + *	  indicated in a valid device state via reading device_state, the user
> + *	  application may decide attempt to transition the device to any valid
> + *	  state reachable from the current state or terminate itself.
> + *
> + *      device_state consists of 3 bits:
> + *      - If bit 0 set, indicates _RUNNING state. When it's clear, that
> + *	  indicates _STOP state. When device is changed to _STOP, driver should
> + *	  stop device before write() returns.

"If set, bit 0 indicates _RUNNING state. If unset, it indicates _STOP
state. When the device is changed to _STOP state, the driver should
stop the device before write() returns."

?

> + *      - If bit 1 set, indicates _SAVING state. When set, that indicates driver
> + *        should start gathering device state information which will be provided
> + *        to VFIO user application to save device's state.

"If set, bit 1 indicates _SAVING state. When it is set, the driver
should start to gather the device state information that will be
provided to the VFIO user application to save the device's state."

?

> + *      - If bit 2 set, indicates _RESUMING state. When set, that indicates
> + *        prepare to resume device, data provided through migration region
> + *        should be used to resume device.

"If set, bit 2 indicates _RESUMING state. When it is set, the driver
should prepare to resume the device, using the data provided via the
migration region."

?

> + *      Bits 3 - 31 are reserved for future use. In order to preserve them,
> + *	user application should perform read-modify-write operation on this
> + *	field when modifying the specified bits.

"In order to preserve them, the user application should use a
read-modify-write operation on the device_state field when modifying
the state."

?


(...)

