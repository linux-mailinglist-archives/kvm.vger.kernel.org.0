Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3794160E2
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 11:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfEGJ2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 05:28:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49342 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726394AbfEGJ2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 05:28:11 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 09086C057F32;
        Tue,  7 May 2019 09:28:10 +0000 (UTC)
Received: from gondolin (dhcp-192-187.str.redhat.com [10.33.192.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4E651001DDE;
        Tue,  7 May 2019 09:27:55 +0000 (UTC)
Date:   Tue, 7 May 2019 11:27:53 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, arei.gonglei@huawei.com,
        aik@ozlabs.ru, Zhengxiao.zx@alibaba-inc.com,
        shuangtai.tst@alibaba-inc.com, qemu-devel@nongnu.org,
        eauger@redhat.com, yi.l.liu@intel.com, ziye.yang@intel.com,
        mlevitsk@redhat.com, pasic@linux.ibm.com, felipe@nutanix.com,
        changpeng.liu@intel.com, Ken.Xue@amd.com,
        jonathan.davies@nutanix.com, shaopeng.he@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, alex.williamson@redhat.com,
        eskultet@redhat.com, dgilbert@redhat.com, kevin.tian@intel.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, cjia@nvidia.com,
        kwankhede@nvidia.com, berrange@redhat.com, dinechin@redhat.com
Subject: Re: [PATCH v2 2/2] drm/i915/gvt: export mdev device version to
 sysfs for Intel vGPU
Message-ID: <20190507112753.2699d0b5.cohuck@redhat.com>
In-Reply-To: <20190506015102.3691-1-yan.y.zhao@intel.com>
References: <20190506014514.3555-1-yan.y.zhao@intel.com>
        <20190506015102.3691-1-yan.y.zhao@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 07 May 2019 09:28:10 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun,  5 May 2019 21:51:02 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> This feature implements the version attribute for Intel's vGPU mdev
> devices.
> 
> version attribute is rw.
> It's used to check device compatibility for two mdev devices.
> version string format and length are private for vendor driver. vendor
> driver is able to define them freely.
> 
> For Intel vGPU of gen8 and gen9, the mdev device version
> consists of 3 fields: "vendor id" + "device id" + "mdev type".
> 
> Reading from a vGPU's version attribute, a string is returned in below
> format: <vendor id>-<device id>-<mdev type>. e.g.
> 8086-193b-i915-GVTg_V5_2.
> 
> Writing a string to a vGPU's version attribute will trigger GVT to check
> whether a vGPU identified by the written string is compatible with
> current vGPU owning this version attribute. errno is returned if the two
> vGPUs are incompatible. The length of written string is returned in
> compatible case.
> 
> For other platforms, and for GVT not supporting vGPU live migration
> feature, errnos are returned when read/write of mdev devices' version
> attributes.
> 
> For old GVT versions where no version attributes exposed in sysfs, it is
> regarded as not supporting vGPU live migration.
> 
> For future platforms, besides the current 2 fields in vendor proprietary
> part, more fields may be added to identify Intel vGPU well for live
> migration purpose.
> 
> v2:
> 1. removed 32 common part of version string
> (Alex Williamson)
> 2. do not register version attribute for GVT not supporting live
> migration.(Cornelia Huck)
> 3. for platforms out of gen8, gen9, return -EINVAL --> -ENODEV for
> incompatible. (Cornelia Huck)

Should go below '---'.

> 
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Erik Skultety <eskultet@redhat.com>
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: "Tian, Kevin" <kevin.tian@intel.com>
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: "Wang, Zhi A" <zhi.a.wang@intel.com>
> c: Neo Jia <cjia@nvidia.com>
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/gpu/drm/i915/gvt/Makefile         |  2 +-
>  drivers/gpu/drm/i915/gvt/device_version.c | 87 +++++++++++++++++++++++
>  drivers/gpu/drm/i915/gvt/gvt.c            | 51 +++++++++++++
>  drivers/gpu/drm/i915/gvt/gvt.h            |  6 ++
>  4 files changed, 145 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/gpu/drm/i915/gvt/device_version.c
> 

(...)

> diff --git a/drivers/gpu/drm/i915/gvt/device_version.c b/drivers/gpu/drm/i915/gvt/device_version.c
> new file mode 100644
> index 000000000000..bd4cdcbdba95
> --- /dev/null
> +++ b/drivers/gpu/drm/i915/gvt/device_version.c
> @@ -0,0 +1,87 @@
> +/*
> + * Copyright(c) 2011-2017 Intel Corporation. All rights reserved.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a
> + * copy of this software and associated documentation files (the "Software"),
> + * to deal in the Software without restriction, including without limitation
> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
> + * and/or sell copies of the Software, and to permit persons to whom the
> + * Software is furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice (including the next
> + * paragraph) shall be included in all copies or substantial portions of the
> + * Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
> + * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> + * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + * Authors:
> + *    Yan Zhao <yan.y.zhao@intel.com>
> + */
> +#include <linux/vfio.h>
> +#include "i915_drv.h"
> +
> +static bool is_compatible(const char *self, const char *remote)
> +{
> +	if (strlen(remote) != strlen(self))
> +		return false;
> +
> +	return (strncmp(self, remote, strlen(self))) ? false : true;
> +}
> +
> +ssize_t intel_gvt_get_vfio_device_version_len(struct drm_i915_private *dev_priv)
> +{
> +	if (!IS_GEN(dev_priv, 8) && !IS_GEN(dev_priv, 9))
> +		return -ENODEV;
> +
> +	return PAGE_SIZE;
> +}
> +
> +ssize_t intel_gvt_get_vfio_device_version(struct drm_i915_private *dev_priv,
> +		char *buf, const char *mdev_type)
> +{
> +	int cnt = 0, ret = 0;
> +	const char *str = NULL;
> +
> +	/* currently only gen8 & gen9 are supported */
> +	if (!IS_GEN(dev_priv, 8) && !IS_GEN(dev_priv, 9))
> +		return -ENODEV;
> +
> +	/* vendor id + device id + mdev type */
> +	/* vendor id */
> +	cnt = snprintf(buf, 5, "%04x", PCI_VENDOR_ID_INTEL);
> +	buf += cnt;
> +	ret += cnt;
> +
> +	/* device id */
> +	cnt = snprintf(buf, 6, "-%04x", INTEL_DEVID(dev_priv));
> +	buf += cnt;
> +	ret += cnt;
> +
> +	/* mdev type */
> +	str = mdev_type;
> +	cnt = snprintf(buf, strlen(str) + 3, "-%s\n", mdev_type);
> +	buf += cnt;
> +	ret += cnt;
> +
> +	return ret;

I'm not familiar with this driver; but would it make sense to pre-build
the version on init? It does not look to me like the values could
change dynamically.

> +}
> +
> +ssize_t intel_gvt_check_vfio_device_version(struct drm_i915_private *dev_priv,
> +		const char *self, const char *remote)
> +{
> +
> +	/* currently only gen8 & gen9 are supported */
> +	if (!IS_GEN(dev_priv, 8) && !IS_GEN(dev_priv, 9))
> +		return -ENODEV;
> +
> +	if (!is_compatible(self, remote))
> +		return -EINVAL;
> +
> +	return 0;
> +}

Return values look reasonable to me. I'll leave discussions regarding
where the attribute should go to folks familiar with this driver.
