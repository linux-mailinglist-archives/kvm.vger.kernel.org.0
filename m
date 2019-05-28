Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 552672C1F4
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 11:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfE1JCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 05:02:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726418AbfE1JCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 05:02:06 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3AF07C05D266;
        Tue, 28 May 2019 09:01:55 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1815611BB;
        Tue, 28 May 2019 09:01:38 +0000 (UTC)
Date:   Tue, 28 May 2019 11:01:35 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, aik@ozlabs.ru,
        Zhengxiao.zx@alibaba-inc.com, shuangtai.tst@alibaba-inc.com,
        qemu-devel@nongnu.org, eauger@redhat.com, yi.l.liu@intel.com,
        ziye.yang@intel.com, mlevitsk@redhat.com, pasic@linux.ibm.com,
        felipe@nutanix.com, changpeng.liu@intel.com, Ken.Xue@amd.com,
        jonathan.davies@nutanix.com, shaopeng.he@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, alex.williamson@redhat.com,
        eskultet@redhat.com, dgilbert@redhat.com, kevin.tian@intel.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, cjia@nvidia.com,
        kwankhede@nvidia.com, berrange@redhat.com, dinechin@redhat.com
Subject: Re: [PATCH v3 2/2] drm/i915/gvt: export migration_version to mdev
 sysfs for Intel vGPU
Message-ID: <20190528110135.222aa24e.cohuck@redhat.com>
In-Reply-To: <20190527034437.31594-1-yan.y.zhao@intel.com>
References: <20190527034155.31473-1-yan.y.zhao@intel.com>
        <20190527034437.31594-1-yan.y.zhao@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 28 May 2019 09:02:05 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 26 May 2019 23:44:37 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> This feature implements the migration_version attribute for Intel's vGPU
> mdev devices.
> 
> migration_version attribute is rw.
> It's used to check migration compatibility for two mdev devices of the
> same mdev type.
> migration_version string is defined by vendor driver and opaque to
> userspace.
> 
> For Intel vGPU of gen8 and gen9, the format of migration_version string
> is:
>   <vendor id>-<device id>-<vgpu type>-<software version>.
> 
> For future platforms, the format of migration_version string is to be
> expanded to include more meta data to identify Intel vGPUs for live
> migration compatibility check
> 
> For old platforms, and for GVT not supporting vGPU live migration
> feature, -ENODEV is returned on read(2)/write(2) of migration_version
> attribute.
> For vGPUs running old GVT who do not expose migration_version
> attribute, live migration is regarded as not supported for those vGPUs.
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
> 
> ---
> v3:
> 1. renamed version to migration_version
> (Christophe de Dinechin, Cornelia Huck, Alex Williamson)
> 2. instead of generating migration version strings each time, storing
> them in vgpu types generated during initialization.
> (Zhenyu Wang, Cornelia Huck)
> 3. replaced multiple snprintf to one big snprintf in
> intel_gvt_get_vfio_migration_version()
> (Dr. David Alan Gilbert)
> 4. printed detailed error log
> (Alex Williamson, Erik Skultety, Cornelia Huck, Dr. David Alan Gilbert)
> 5. incorporated <software version> into migration_version string
> (Alex Williamson)
> 6. do not use ifndef macro to switch off migration_version attribute
> (Zhenyu Wang)
> 
> v2:
> 1. removed 32 common part of version string
> (Alex Williamson)
> 2. do not register version attribute for GVT not supporting live
> migration.(Cornelia Huck)
> 3. for platforms out of gen8, gen9, return -EINVAL --> -ENODEV for
> incompatible. (Cornelia Huck)
> ---
>  drivers/gpu/drm/i915/gvt/Makefile            |   2 +-
>  drivers/gpu/drm/i915/gvt/gvt.c               |  39 +++++
>  drivers/gpu/drm/i915/gvt/gvt.h               |   5 +
>  drivers/gpu/drm/i915/gvt/migration_version.c | 167 +++++++++++++++++++
>  drivers/gpu/drm/i915/gvt/vgpu.c              |  13 +-
>  5 files changed, 223 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/gpu/drm/i915/gvt/migration_version.c
> 

(...)

> diff --git a/drivers/gpu/drm/i915/gvt/gvt.c b/drivers/gpu/drm/i915/gvt/gvt.c
> index 43f4242062dd..be2980e8ac75 100644
> --- a/drivers/gpu/drm/i915/gvt/gvt.c
> +++ b/drivers/gpu/drm/i915/gvt/gvt.c
> @@ -105,14 +105,53 @@ static ssize_t description_show(struct kobject *kobj, struct device *dev,
>  		       type->weight);
>  }
>  
> +static ssize_t migration_version_show(struct kobject *kobj, struct device *dev,
> +		char *buf)

Indentation looks a bit odd? (Also below.)

> +{
> +	struct intel_vgpu_type *type;
> +	void *gvt = kdev_to_i915(dev)->gvt;
> +
> +	type = intel_gvt_find_vgpu_type(gvt, kobject_name(kobj));
> +	if (!type || !type->migration_version) {
> +		gvt_err("Does not support migraion on type %s. Please search previous detailed log\n",

s/migraion/migration/ (also below)

Or reword to "Migration not supported on type %s."?

> +				kobject_name(kobj));
> +		return -ENODEV;
> +	}
> +
> +	return snprintf(buf, strlen(type->migration_version) + 2,
> +			"%s\n", type->migration_version);
> +}
> +
> +static ssize_t migration_version_store(struct kobject *kobj, struct device *dev,
> +		const char *buf, size_t count)
> +{
> +	int ret = 0;
> +	struct intel_vgpu_type *type;
> +	void *gvt = kdev_to_i915(dev)->gvt;
> +
> +	type = intel_gvt_find_vgpu_type(gvt, kobject_name(kobj));
> +	if (!type || !type->migration_version) {
> +		gvt_err("Does not support migraion on type %s. Please search previous detailed log\n",
> +				kobject_name(kobj));
> +		return -ENODEV;
> +	}
> +
> +	ret = intel_gvt_check_vfio_migration_version(gvt,
> +			type->migration_version, buf);
> +
> +	return (ret < 0 ? ret : count);
> +}
> +
>  static MDEV_TYPE_ATTR_RO(available_instances);
>  static MDEV_TYPE_ATTR_RO(device_api);
>  static MDEV_TYPE_ATTR_RO(description);
> +static MDEV_TYPE_ATTR_RW(migration_version);
>  
>  static struct attribute *gvt_type_attrs[] = {
>  	&mdev_type_attr_available_instances.attr,
>  	&mdev_type_attr_device_api.attr,
>  	&mdev_type_attr_description.attr,
> +	&mdev_type_attr_migration_version.attr,
>  	NULL,
>  };

(...)

> +char *
> +intel_gvt_get_vfio_migration_version(struct intel_gvt *gvt,
> +		const char *vgpu_type)
> +{
> +	int cnt = 0;
> +	struct drm_i915_private *dev_priv = gvt->dev_priv;
> +	char *version = NULL;
> +
> +	/* currently only gen8 & gen9 are supported */
> +	if (!IS_GEN(dev_priv, 8) && !IS_GEN(dev_priv, 9)) {
> +		gvt_err("Local hardware does not support migration on %d\n",
> +				INTEL_INFO(dev_priv)->gen);
> +		return NULL;
> +	}
> +
> +	if (GVT_VFIO_MIGRATION_SOFTWARE_VERSION == INV_SOFTWARE_VERSION) {
> +		gvt_err("Local GVT does not support migration\n");
> +		return NULL;
> +	}
> +
> +	version = kzalloc(MIGRATION_VERSION_TOTAL_LEN, GFP_KERNEL);
> +
> +	if (unlikely(!version)) {
> +		gvt_err("memory allocation failed when get local migraiton version\n");

s/migraiton/migration/

Or "cannot allocate memory for local migration version"?

> +		return NULL;
> +	}
> +
> +	/* vendor id + device id + vgpu type + software version */
> +	cnt = snprintf(version, MIGRATION_VERSION_TOTAL_LEN, PRINTF_FORMAT,
> +			PCI_VENDOR_ID_INTEL,
> +			INTEL_DEVID(dev_priv),
> +			vgpu_type,
> +			GVT_VFIO_MIGRATION_SOFTWARE_VERSION);
> +
> +	if (cnt)
> +		return version;
> +
> +	gvt_err("string generation failed when get local migration version\n");
> +	return NULL;
> +}

(...)

Only some nitpicks from me, but I'm not really familiar with this
driver. Overall, this looks sane to me, so have an

Acked-by: Cornelia Huck <cohuck@redhat.com>
