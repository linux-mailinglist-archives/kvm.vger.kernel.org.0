Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4845C2D761
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 10:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfE2IJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 04:09:57 -0400
Received: from mga12.intel.com ([192.55.52.136]:23237 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbfE2IJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 04:09:55 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 01:09:53 -0700
X-ExtLoop1: 1
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by orsmga003.jf.intel.com with ESMTP; 29 May 2019 01:09:47 -0700
Date:   Wed, 29 May 2019 04:04:03 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "Zhengxiao.zx@alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>
Subject: Re: [PATCH v3 2/2] drm/i915/gvt: export migration_version to mdev
 sysfs for Intel vGPU
Message-ID: <20190529080403.GI27438@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20190527034155.31473-1-yan.y.zhao@intel.com>
 <20190527034437.31594-1-yan.y.zhao@intel.com>
 <20190529030750.GN29553@zhen-hp.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529030750.GN29553@zhen-hp.sh.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 29, 2019 at 11:07:50AM +0800, Zhenyu Wang wrote:
> On 2019.05.26 23:44:37 -0400, Yan Zhao wrote:
> > This feature implements the migration_version attribute for Intel's vGPU
> > mdev devices.
> > 
> > migration_version attribute is rw.
> > It's used to check migration compatibility for two mdev devices of the
> > same mdev type.
> > migration_version string is defined by vendor driver and opaque to
> > userspace.
> > 
> > For Intel vGPU of gen8 and gen9, the format of migration_version string
> > is:
> >   <vendor id>-<device id>-<vgpu type>-<software version>.
> > 
> > For future platforms, the format of migration_version string is to be
> > expanded to include more meta data to identify Intel vGPUs for live
> > migration compatibility check
> > 
> > For old platforms, and for GVT not supporting vGPU live migration
> > feature, -ENODEV is returned on read(2)/write(2) of migration_version
> > attribute.
> > For vGPUs running old GVT who do not expose migration_version
> > attribute, live migration is regarded as not supported for those vGPUs.
> > 
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Erik Skultety <eskultet@redhat.com>
> > Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > Cc: Cornelia Huck <cohuck@redhat.com>
> > Cc: "Tian, Kevin" <kevin.tian@intel.com>
> > Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> > Cc: "Wang, Zhi A" <zhi.a.wang@intel.com>
> > c: Neo Jia <cjia@nvidia.com>
> > Cc: Kirti Wankhede <kwankhede@nvidia.com>
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > 
> > ---
> > v3:
> > 1. renamed version to migration_version
> > (Christophe de Dinechin, Cornelia Huck, Alex Williamson)
> > 2. instead of generating migration version strings each time, storing
> > them in vgpu types generated during initialization.
> > (Zhenyu Wang, Cornelia Huck)
> > 3. replaced multiple snprintf to one big snprintf in
> > intel_gvt_get_vfio_migration_version()
> > (Dr. David Alan Gilbert)
> > 4. printed detailed error log
> > (Alex Williamson, Erik Skultety, Cornelia Huck, Dr. David Alan Gilbert)
> > 5. incorporated <software version> into migration_version string
> > (Alex Williamson)
> > 6. do not use ifndef macro to switch off migration_version attribute
> > (Zhenyu Wang)
> > 
> > v2:
> > 1. removed 32 common part of version string
> > (Alex Williamson)
> > 2. do not register version attribute for GVT not supporting live
> > migration.(Cornelia Huck)
> > 3. for platforms out of gen8, gen9, return -EINVAL --> -ENODEV for
> > incompatible. (Cornelia Huck)
> > ---
> >  drivers/gpu/drm/i915/gvt/Makefile            |   2 +-
> >  drivers/gpu/drm/i915/gvt/gvt.c               |  39 +++++
> >  drivers/gpu/drm/i915/gvt/gvt.h               |   5 +
> >  drivers/gpu/drm/i915/gvt/migration_version.c | 167 +++++++++++++++++++
> >  drivers/gpu/drm/i915/gvt/vgpu.c              |  13 +-
> >  5 files changed, 223 insertions(+), 3 deletions(-)
> >  create mode 100644 drivers/gpu/drm/i915/gvt/migration_version.c
> > 
> > diff --git a/drivers/gpu/drm/i915/gvt/Makefile b/drivers/gpu/drm/i915/gvt/Makefile
> > index 271fb46d4dd0..a9d561c93ab8 100644
> > --- a/drivers/gpu/drm/i915/gvt/Makefile
> > +++ b/drivers/gpu/drm/i915/gvt/Makefile
> > @@ -3,7 +3,7 @@ GVT_DIR := gvt
> >  GVT_SOURCE := gvt.o aperture_gm.o handlers.o vgpu.o trace_points.o firmware.o \
> >  	interrupt.o gtt.o cfg_space.o opregion.o mmio.o display.o edid.o \
> >  	execlist.o scheduler.o sched_policy.o mmio_context.o cmd_parser.o debugfs.o \
> > -	fb_decoder.o dmabuf.o page_track.o
> > +	fb_decoder.o dmabuf.o page_track.o migration_version.o
> >  
> >  ccflags-y				+= -I$(src) -I$(src)/$(GVT_DIR)
> >  i915-y					+= $(addprefix $(GVT_DIR)/, $(GVT_SOURCE))
> > diff --git a/drivers/gpu/drm/i915/gvt/gvt.c b/drivers/gpu/drm/i915/gvt/gvt.c
> > index 43f4242062dd..be2980e8ac75 100644
> > --- a/drivers/gpu/drm/i915/gvt/gvt.c
> > +++ b/drivers/gpu/drm/i915/gvt/gvt.c
> > @@ -105,14 +105,53 @@ static ssize_t description_show(struct kobject *kobj, struct device *dev,
> >  		       type->weight);
> >  }
> >  
> > +static ssize_t migration_version_show(struct kobject *kobj, struct device *dev,
> > +		char *buf)
> > +{
> > +	struct intel_vgpu_type *type;
> > +	void *gvt = kdev_to_i915(dev)->gvt;
> > +
> > +	type = intel_gvt_find_vgpu_type(gvt, kobject_name(kobj));
> > +	if (!type || !type->migration_version) {
> > +		gvt_err("Does not support migraion on type %s. Please search previous detailed log\n",
> > +				kobject_name(kobj));
> > +		return -ENODEV;
> > +	}
> > +
> > +	return snprintf(buf, strlen(type->migration_version) + 2,
> > +			"%s\n", type->migration_version);
> > +}
> > +
> > +static ssize_t migration_version_store(struct kobject *kobj, struct device *dev,
> > +		const char *buf, size_t count)
> > +{
> > +	int ret = 0;
> > +	struct intel_vgpu_type *type;
> > +	void *gvt = kdev_to_i915(dev)->gvt;
> > +
> > +	type = intel_gvt_find_vgpu_type(gvt, kobject_name(kobj));
> > +	if (!type || !type->migration_version) {
> > +		gvt_err("Does not support migraion on type %s. Please search previous detailed log\n",
> > +				kobject_name(kobj));
> > +		return -ENODEV;
> > +	}
> > +
> > +	ret = intel_gvt_check_vfio_migration_version(gvt,
> > +			type->migration_version, buf);
> > +
> > +	return (ret < 0 ? ret : count);
> > +}
> > +
> >  static MDEV_TYPE_ATTR_RO(available_instances);
> >  static MDEV_TYPE_ATTR_RO(device_api);
> >  static MDEV_TYPE_ATTR_RO(description);
> > +static MDEV_TYPE_ATTR_RW(migration_version);
> >  
> >  static struct attribute *gvt_type_attrs[] = {
> >  	&mdev_type_attr_available_instances.attr,
> >  	&mdev_type_attr_device_api.attr,
> >  	&mdev_type_attr_description.attr,
> > +	&mdev_type_attr_migration_version.attr,
> >  	NULL,
> >  };
> >  
> > diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
> > index f5a328b5290a..265319d35c25 100644
> > --- a/drivers/gpu/drm/i915/gvt/gvt.h
> > +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> > @@ -296,6 +296,7 @@ struct intel_vgpu_type {
> >  	unsigned int fence;
> >  	unsigned int weight;
> >  	enum intel_vgpu_edid resolution;
> > +	char *migration_version;
> >  };
> >  
> >  struct intel_gvt {
> > @@ -687,6 +688,10 @@ void intel_gvt_debugfs_remove_vgpu(struct intel_vgpu *vgpu);
> >  int intel_gvt_debugfs_init(struct intel_gvt *gvt);
> >  void intel_gvt_debugfs_clean(struct intel_gvt *gvt);
> >  
> > +ssize_t intel_gvt_check_vfio_migration_version(struct intel_gvt *gvt,
> > +		const char *self, const char *remote);
> > +char *intel_gvt_get_vfio_migration_version(struct intel_gvt *gvt,
> > +		const char *vgpu_type);
> >  
> >  #include "trace.h"
> >  #include "mpt.h"
> > diff --git a/drivers/gpu/drm/i915/gvt/migration_version.c b/drivers/gpu/drm/i915/gvt/migration_version.c
> > new file mode 100644
> > index 000000000000..e6acf188b29a
> > --- /dev/null
> > +++ b/drivers/gpu/drm/i915/gvt/migration_version.c
> > @@ -0,0 +1,167 @@
> > +/*
> > + * Copyright(c) 2011-2017 Intel Corporation. All rights reserved.
> > + *
> > + * Permission is hereby granted, free of charge, to any person obtaining a
> > + * copy of this software and associated documentation files (the "Software"),
> > + * to deal in the Software without restriction, including without limitation
> > + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
> > + * and/or sell copies of the Software, and to permit persons to whom the
> > + * Software is furnished to do so, subject to the following conditions:
> > + *
> > + * The above copyright notice and this permission notice (including the next
> > + * paragraph) shall be included in all copies or substantial portions of the
> > + * Software.
> > + *
> > + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> > + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> > + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
> > + * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> > + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> > + * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> > + * SOFTWARE.
> > + *
> > + * Authors:
> > + *    Yan Zhao <yan.y.zhao@intel.com>
> > + */
> > +#include <linux/vfio.h>
> > +#include "i915_drv.h"
> > +#include "gvt.h"
> > +
> > +#define INV_SOFTWARE_VERSION (-1U)
> > +#define VENDOR_ID_LEN (4)
> > +#define DEVICE_ID_LEN (4)
> > +#define VGPU_TYPE_LEN (16)
> > +#define SOFTWARE_VER_LEN (8)
> > +
> > +/* total length of vfio migration version string.
> > + * never exceed limit of PATH_MAX (4096)
> > + */
> > +#define MIGRATION_VERSION_TOTAL_LEN (VENDOR_ID_LEN + DEVICE_ID_LEN + \
> > +					VGPU_TYPE_LEN + SOFTWARE_VER_LEN + 4)
> > +
> > +#define GVT_VFIO_MIGRATION_SOFTWARE_VERSION INV_SOFTWARE_VERSION
> > +
> > +
> > +#define PRINTF_FORMAT "%04x-%04x-%s-%08x"
> > +#define SCANF_FORMAT "%x-%x-%16[^-]-%x"
> > +
> > +enum incompatible_reason {
> > +	IREASON_WRONG_REMOTE_FORMAT = 0,
> > +	IREASON_HARDWARE_MISMATCH,
> > +	IREASON_SOFTWARE_VERSION_MISMATCH,
> > +	IREASON_VGPU_TYPE_MISMATCH,
> > +};
> > +
> > +static const char *const incompatible_reason_str[] = {
> > +	[IREASON_WRONG_REMOTE_FORMAT] =
> > +		"wrong string format. probably wrong GVT version",
> > +	[IREASON_HARDWARE_MISMATCH] =
> > +		"physical device not matched",
> > +	[IREASON_SOFTWARE_VERSION_MISMATCH] =
> > +		"migration software version not matched",
> > +	[IREASON_VGPU_TYPE_MISMATCH] =
> > +		"vgpu type not matched"
> > +};
> > +
> > +static bool is_compatible(const char *local, const char *remote)
> > +{
> > +	bool ret;
> > +
> > +	ret = sysfs_streq(local, remote);
> > +
> > +	if (!ret) {
> > +		int vid_l = 0, did_l = 0, vid_r = 0, did_r = 0;
> > +		char type_l[VGPU_TYPE_LEN], type_r[VGPU_TYPE_LEN];
> > +		u32 sv_l = 0, sv_r = 0;
> > +		int rl = 0, rr = 0;
> > +		enum incompatible_reason reason = IREASON_WRONG_REMOTE_FORMAT;
> > +
> > +		memset(type_l, 0, sizeof(type_l));
> > +		memset(type_r, 0, sizeof(type_r));
> > +
> > +		rl = sscanf(local, SCANF_FORMAT,
> > +				&vid_l, &did_l, type_l, &sv_l);
> > +		rr = sscanf(remote, SCANF_FORMAT,
> > +				&vid_r, &did_r, type_r, &sv_r);
> > +
> > +		if (rl == rr) {
> > +			if (vid_l != vid_r || did_l != did_r)
> > +				reason = IREASON_HARDWARE_MISMATCH;
> > +			else if (sv_l != sv_r)
> > +				reason = IREASON_SOFTWARE_VERSION_MISMATCH;
> > +			else if (strncmp(type_l, type_r, VGPU_TYPE_LEN))
> > +				reason = IREASON_VGPU_TYPE_MISMATCH;
> > +		}
> > +
> > +		gvt_err("Migration version mismatched. Possible reason: %s. Local migration version:%s, Remote migration version:%s\n",
> > +				incompatible_reason_str[reason], local,	remote);
> > +
> > +	}
> > +	return ret;
> > +
> > +}
> > +
> > +
> > +char *
> > +intel_gvt_get_vfio_migration_version(struct intel_gvt *gvt,
> > +		const char *vgpu_type)
> > +{
> > +	int cnt = 0;
> > +	struct drm_i915_private *dev_priv = gvt->dev_priv;
> > +	char *version = NULL;
> > +
> > +	/* currently only gen8 & gen9 are supported */
> > +	if (!IS_GEN(dev_priv, 8) && !IS_GEN(dev_priv, 9)) {
> > +		gvt_err("Local hardware does not support migration on %d\n",
> > +				INTEL_INFO(dev_priv)->gen);
> > +		return NULL;
> > +	}
> > +
> > +	if (GVT_VFIO_MIGRATION_SOFTWARE_VERSION == INV_SOFTWARE_VERSION) {
> > +		gvt_err("Local GVT does not support migration\n");
> > +		return NULL;
> > +	}
> > +
> > +	version = kzalloc(MIGRATION_VERSION_TOTAL_LEN, GFP_KERNEL);
> > +
> > +	if (unlikely(!version)) {
> > +		gvt_err("memory allocation failed when get local migraiton version\n");
> > +		return NULL;
> > +	}
> > +
> > +	/* vendor id + device id + vgpu type + software version */
> > +	cnt = snprintf(version, MIGRATION_VERSION_TOTAL_LEN, PRINTF_FORMAT,
> > +			PCI_VENDOR_ID_INTEL,
> > +			INTEL_DEVID(dev_priv),
> > +			vgpu_type,
> > +			GVT_VFIO_MIGRATION_SOFTWARE_VERSION);
> > +
> > +	if (cnt)
> > +		return version;
> > +
> > +	gvt_err("string generation failed when get local migration version\n");
> > +	return NULL;
> 
> Handle version kfree for possible error here. The approach looks fine to me.
> I think some of those messages might be too chatty or maybe debug message instead.
> Others are good to me.
> 
> Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> 
Got it. will add the kfree in next revision.
But debug message is only available for debug version of driver? If that's true,
maybe keep it printed also for non-debug version is better? as it is intended to
be checked by userspace software to see what's going wrong on migration
compatibility test.
Thank you:)

> > +}
> > +
> > +ssize_t intel_gvt_check_vfio_migration_version(struct intel_gvt *gvt,
> > +		const char *self, const char *remote)
> > +{
> > +	struct drm_i915_private *dev_priv = gvt->dev_priv;
> > +
> > +	/* currently only gen8 & gen9 are supported */
> > +	if (!IS_GEN(dev_priv, 8) && !IS_GEN(dev_priv, 9)) {
> > +		gvt_err("Local hardware does not support migration on %d\n",
> > +				INTEL_INFO(dev_priv)->gen);
> > +		return -ENODEV;
> > +	}
> > +
> > +	if (GVT_VFIO_MIGRATION_SOFTWARE_VERSION == INV_SOFTWARE_VERSION) {
> > +		gvt_err("Local GVT does not support migration\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	if (!is_compatible(self, remote))
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/vgpu.c
> > index 44ce3c2b9ac1..7642b21641bd 100644
> > --- a/drivers/gpu/drm/i915/gvt/vgpu.c
> > +++ b/drivers/gpu/drm/i915/gvt/vgpu.c
> > @@ -155,13 +155,18 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
> >  			sprintf(gvt->types[i].name, "GVTg_V5_%s",
> >  						vgpu_types[i].name);
> >  
> > -		gvt_dbg_core("type[%d]: %s avail %u low %u high %u fence %u weight %u res %s\n",
> > +		gvt->types[i].migration_version =
> > +			intel_gvt_get_vfio_migration_version(gvt,
> > +					gvt->types[i].name);
> > +		gvt_dbg_core("type[%d]: %s avail %u low %u high %u fence %u weight %u res %s, migratio_version:%s\n",
> >  			     i, gvt->types[i].name,
> >  			     gvt->types[i].avail_instance,
> >  			     gvt->types[i].low_gm_size,
> >  			     gvt->types[i].high_gm_size, gvt->types[i].fence,
> >  			     gvt->types[i].weight,
> > -			     vgpu_edid_str(gvt->types[i].resolution));
> > +			     vgpu_edid_str(gvt->types[i].resolution),
> > +			     (gvt->types[i].migration_version ?
> > +			     gvt->types[i].migration_version : "null"));
> >  	}
> >  
> >  	gvt->num_types = i;
> > @@ -170,6 +175,10 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
> >  
> >  void intel_gvt_clean_vgpu_types(struct intel_gvt *gvt)
> >  {
> > +	int i;
> > +
> > +	for (i = 0; i < gvt->num_types; i++)
> > +		kfree(gvt->types[i].migration_version);
> >  	kfree(gvt->types);
> >  }
> >  
> > -- 
> > 2.17.1
> > 
> 
> -- 
> Open Source Technology Center, Intel ltd.
> 
> $gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827


