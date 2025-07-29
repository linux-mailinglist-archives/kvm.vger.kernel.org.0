Return-Path: <kvm+bounces-53600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B2B7B14777
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 07:12:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C8A03B5357
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 05:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35494233735;
	Tue, 29 Jul 2025 05:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s7XYKL+5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCF872634
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 05:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753765967; cv=none; b=U7WhS+zb3DVG+i+fdnwkKjzNmD8qC8HcFVvoCoFSs3FzfuQJbstP3WwIheRBRzPxOnt2nJ3reZB7ygrbm9F21JVbzcRE4ZmBMxHTgBVjh2SZwuyntQ9wOTqgQsRej0toMNv7DrSUzy7FbXZP4o4uzcO1WxX/mtyPyz+HJzfUrpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753765967; c=relaxed/simple;
	bh=Pvq203HwTQ+MZpsyPVtQOv+dAbBCq+tDcAw3WF9B8EI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EB99iDrUtjdWcb0TzWQHTMswfQKMWd7zi1QWYWMIQGwwpVdSlChfL3SIiM0QA88EYwiq71v6JMO2WpEfaLt/Hdk3X/XtzuQO1ATgoV5WXOmi/Peo1WMmBPy7NaoT0acgQSp12gsVr6ZczTzhYP40/jiBpHfbtmVSzlpgFlNu59M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s7XYKL+5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD329C4CEEF;
	Tue, 29 Jul 2025 05:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753765966;
	bh=Pvq203HwTQ+MZpsyPVtQOv+dAbBCq+tDcAw3WF9B8EI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=s7XYKL+5GND8gtbO+HIlYkc2tRXTr/GViYVpgt9BPVNNpgdqDAvaoVffvG5HCWFE1
	 LuizlEJpR40ewZJKthnxXtdVa5eBoGoDGoML1eCemAVSbiRgDGxWXtae2uuBpUi3h4
	 oQAC5Nj4VYI0J8BcjpkgRWCwB6y4cGWfyBfV12bWbIGD1MMtIDKdCpCVijLWoam53P
	 OGhZLo0DE+wFt+s+tNBKBTRfvN6RklF93AfDqH7Hxac/+OYikK8V05JH5Q7qzO7qCp
	 0clmSsEmrTJhwKhLoBj6wpOFrdOJOYhPc4Gzb3JX8SQ6leGWJzgxiL7oeOnNCj/CZL
	 6PdpCG2utO4BQ==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 07/10] vfio/iommufd: Add basic iommufd support
In-Reply-To: <aIZwjA-wOPDPD9Co@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-7-aneesh.kumar@kernel.org>
 <aIZwjA-wOPDPD9Co@google.com>
Date: Tue, 29 Jul 2025 10:42:42 +0530
Message-ID: <yq5aectzbmwl.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mostafa Saleh <smostafa@google.com> writes:

> On Sun, May 25, 2025 at 01:19:13PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> This use a stage1 translate stage2 bypass iommu config.
>>=20
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>  Makefile                 |   1 +
>>  builtin-run.c            |   1 +
>>  include/kvm/kvm-config.h |   1 +
>>  include/kvm/vfio.h       |   2 +
>>  vfio/core.c              |   5 +
>>  vfio/iommufd.c           | 368 +++++++++++++++++++++++++++++++++++++++
>>  6 files changed, 378 insertions(+)
>>  create mode 100644 vfio/iommufd.c
>>=20
>> diff --git a/Makefile b/Makefile
>> index 8b2720f73386..740b95c7c3c3 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -64,6 +64,7 @@ OBJS	+=3D mmio.o
>>  OBJS	+=3D pci.o
>>  OBJS	+=3D term.o
>>  OBJS	+=3D vfio/core.o
>> +OBJS	+=3D vfio/iommufd.o
>>  OBJS	+=3D vfio/pci.o
>>  OBJS	+=3D vfio/legacy.o
>>  OBJS	+=3D virtio/blk.o
>> diff --git a/builtin-run.c b/builtin-run.c
>> index 81f255f911b3..39198f9bc0d6 100644
>> --- a/builtin-run.c
>> +++ b/builtin-run.c
>> @@ -262,6 +262,7 @@ static int loglevel_parser(const struct option *opt,=
 const char *arg, int unset)
>>  	OPT_CALLBACK('\0', "vfio-pci", NULL, "[domain:]bus:dev.fn",	\
>>  		     "Assign a PCI device to the virtual machine",	\
>>  		     vfio_device_parser, kvm),				\
>> +	OPT_BOOLEAN('\0', "iommufd", &(cfg)->iommufd, "Use iommufd interface")=
,	\
>>  									\
>>  	OPT_GROUP("Debug options:"),					\
>>  	OPT_CALLBACK_NOOPT('\0', "debug", kvm, NULL,			\
>> diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
>> index 592b035785c9..632eaf84b7eb 100644
>> --- a/include/kvm/kvm-config.h
>> +++ b/include/kvm/kvm-config.h
>> @@ -65,6 +65,7 @@ struct kvm_config {
>>  	bool ioport_debug;
>>  	bool mmio_debug;
>>  	int virtio_transport;
>> +	bool iommufd;
>>  };
>>=20=20
>>  #endif
>> diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
>> index fed692b0f265..37a2b5ac3dad 100644
>> --- a/include/kvm/vfio.h
>> +++ b/include/kvm/vfio.h
>> @@ -128,6 +128,8 @@ void vfio_pci_teardown_device(struct kvm *kvm, struc=
t vfio_device *vdev);
>>=20=20
>>  extern int (*dma_map_mem_range)(struct kvm *kvm, __u64 host_addr, __u64=
 iova, __u64 size);
>>  extern int (*dma_unmap_mem_range)(struct kvm *kvm, __u64 iova, __u64 si=
ze);
>> +int iommufd__init(struct kvm *kvm);
>> +int iommufd__exit(struct kvm *kvm);
>>=20=20
>>  struct kvm_mem_bank;
>>  int vfio_map_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void =
*data);
>> diff --git a/vfio/core.c b/vfio/core.c
>> index 32a8e0fe67c0..0b1796c54ffd 100644
>> --- a/vfio/core.c
>> +++ b/vfio/core.c
>> @@ -373,6 +373,8 @@ static int vfio__init(struct kvm *kvm)
>>  	}
>>  	kvm_vfio_device =3D device.fd;
>>=20=20
>> +	if (kvm->cfg.iommufd)
>> +		return iommufd__init(kvm);
>>  	return legacy_vfio__init(kvm);
>>  }
>>  dev_base_init(vfio__init);
>> @@ -393,6 +395,9 @@ static int vfio__exit(struct kvm *kvm)
>>=20=20
>>  	free(kvm->cfg.vfio_devices);
>>=20=20
>> +	if (kvm->cfg.iommufd)
>> +		return iommufd__exit(kvm);
>> +
>>  	return legacy_vfio__exit(kvm);
>>  }
>>  dev_base_exit(vfio__exit);
>> diff --git a/vfio/iommufd.c b/vfio/iommufd.c
>> new file mode 100644
>> index 000000000000..3728a06cb318
>> --- /dev/null
>> +++ b/vfio/iommufd.c
>> @@ -0,0 +1,368 @@
>> +#include <sys/types.h>
>> +#include <dirent.h>
>> +
>> +#include "kvm/kvm.h"
>> +#include <linux/iommufd.h>
>> +#include <linux/list.h>
>> +
>> +#define VFIO_DEV_DIR		"/dev/vfio"
> This is duplicate with the legacy file, so maybe move it to the header?
>
>> +#define VFIO_DEV_NODE		VFIO_DEV_DIR "/devices/"
>> +#define IOMMU_DEV		"/dev/iommu"
>> +
>> +static int iommu_fd;
>> +static int ioas_id;
>> +
>> +static int __iommufd_configure_device(struct kvm *kvm, struct vfio_devi=
ce *vdev)
>> +{
>> +	int ret;
>> +
>> +	vdev->info.argsz =3D sizeof(vdev->info);
>> +	if (ioctl(vdev->fd, VFIO_DEVICE_GET_INFO, &vdev->info)) {
>> +		ret =3D -errno;
>> +		vfio_dev_err(vdev, "failed to get info");
>> +		goto err_close_device;
>> +	}
>> +
>> +	if (vdev->info.flags & VFIO_DEVICE_FLAGS_RESET &&
>> +	    ioctl(vdev->fd, VFIO_DEVICE_RESET) < 0)
>> +		vfio_dev_warn(vdev, "failed to reset device");
>> +
>> +	vdev->regions =3D calloc(vdev->info.num_regions, sizeof(*vdev->regions=
));
>> +	if (!vdev->regions) {
>> +		ret =3D -ENOMEM;
>> +		goto err_close_device;
>> +	}
>> +
>> +	/* Now for the bus-specific initialization... */
>> +	switch (vdev->params->type) {
>> +	case VFIO_DEVICE_PCI:
>> +		BUG_ON(!(vdev->info.flags & VFIO_DEVICE_FLAGS_PCI));
>> +		ret =3D vfio_pci_setup_device(kvm, vdev);
>> +		break;
>> +	default:
>> +		BUG_ON(1);
>> +		ret =3D -EINVAL;
>> +	}
>> +
>> +	if (ret)
>> +		goto err_free_regions;
>> +
>> +	vfio_dev_info(vdev, "assigned to device number 0x%x ",
>> +		      vdev->dev_hdr.dev_num) ;
>> +
>> +	return 0;
>> +
>> +err_free_regions:
>> +	free(vdev->regions);
>> +err_close_device:
>> +	close(vdev->fd);
>> +
>> +	return ret;
>> +}
>> +
>> +static int iommufd_configure_device(struct kvm *kvm, struct vfio_device=
 *vdev)
>> +{
>> +	int ret;
>> +	DIR *dir =3D NULL;
>> +	struct dirent *dir_ent;
>> +	bool found_dev =3D false;
>> +	char pci_dev_path[PATH_MAX];
>> +	char vfio_dev_path[PATH_MAX];
>> +	struct iommu_hwpt_alloc alloc_hwpt;
>> +	struct vfio_device_bind_iommufd bind;
>> +	struct vfio_device_attach_iommufd_pt attach_data;
>> +
>> +	ret =3D snprintf(pci_dev_path, PATH_MAX, "%s/vfio-dev/", vdev->sysfs_p=
ath);
>> +	if (ret < 0 || ret =3D=3D PATH_MAX)
>> +		return -EINVAL;
>> +
>> +	dir =3D opendir(pci_dev_path);
>> +	if (!dir)
>> +		return -EINVAL;
>> +
>> +	while ((dir_ent =3D readdir(dir))) {
>> +		if (!strncmp(dir_ent->d_name, "vfio", 4)) {
>> +			ret =3D snprintf(vfio_dev_path, PATH_MAX, VFIO_DEV_NODE "%s", dir_en=
t->d_name);
>> +			if (ret < 0 || ret =3D=3D PATH_MAX) {
>> +				ret =3D -EINVAL;
>> +				goto err_close_dir;
>> +			}
>> +			found_dev =3D true;
>> +			break;
>> +		}
>> +	}
>> +	if (!found_dev) {
>> +		ret =3D -ENODEV;
>> +		goto err_close_dir;
>> +	}
>
> At this point we already found the device, as in error there is "err_clos=
e_dir"
> so there is no need for the extra flag.
>

I didn't follow this. So if we didn't find the "vfio<x>" directory in
pci devices sysfspatch/vfio-dev/ we need to error out.

>
>> +
>> +	vdev->fd =3D open(vfio_dev_path, O_RDWR);
>> +	if (vdev->fd =3D=3D -1) {
>> +		ret =3D errno;
>> +		pr_err("Failed to open %s", vfio_dev_path);
>> +		goto err_close_dir;
>> +	}
>> +
>> +	struct kvm_device_attr attr =3D {
>> +		.group =3D KVM_DEV_VFIO_FILE,
>> +		.attr =3D KVM_DEV_VFIO_FILE_ADD,
>> +		.addr =3D (__u64)&vdev->fd,
>> +	};
>> +
>> +	if (ioctl(kvm_vfio_device, KVM_SET_DEVICE_ATTR, &attr)) {
>> +		ret =3D -errno;
>> +		pr_err("Failed KVM_SET_DEVICE_ATTR for KVM_DEV_VFIO_FILE");
>> +		goto err_close_device;
>> +	}
>> +
>> +	bind.argsz =3D sizeof(bind);
>> +	bind.flags =3D 0;
>> +	bind.iommufd =3D iommu_fd;
>> +
>> +	/* now bind the iommufd */
>> +	if (ioctl(vdev->fd, VFIO_DEVICE_BIND_IOMMUFD, &bind)) {
>> +		ret =3D -errno;
>> +		vfio_dev_err(vdev, "failed to get info");
>> +		goto err_close_device;
>> +	}
>> +
>> +	alloc_hwpt.size =3D sizeof(struct iommu_hwpt_alloc);
>> +	alloc_hwpt.flags =3D 0;
>> +	alloc_hwpt.dev_id =3D bind.out_devid;
>> +	alloc_hwpt.pt_id =3D ioas_id;
>> +	alloc_hwpt.data_type =3D IOMMU_HWPT_DATA_NONE;
>> +	alloc_hwpt.data_len =3D 0;
>> +	alloc_hwpt.data_uptr =3D 0;
>> +
>> +	if (ioctl(iommu_fd, IOMMU_HWPT_ALLOC, &alloc_hwpt)) {
>> +		ret =3D -errno;
>> +		pr_err("Failed to allocate HWPT");
>> +		goto err_close_device;
>> +	}
>> +
>> +	attach_data.argsz =3D sizeof(attach_data);
>> +	attach_data.flags =3D 0;
>> +	attach_data.pt_id =3D alloc_hwpt.out_hwpt_id;
>> +
>> +	if (ioctl(vdev->fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data)) {
>> +		ret =3D -errno;
>> +		vfio_dev_err(vdev, "failed to attach to IOAS ");
>
> Extra space.
>
>> +		goto err_close_device;
>> +	}
>> +
>> +	closedir(dir);
>> +	return __iommufd_configure_device(kvm, vdev);
>> +
>> +err_close_device:
>> +	close(vdev->fd);
>> +err_close_dir:
>> +	closedir(dir);
>> +	return ret;
>> +}
>> +
>> +static int iommufd_configure_devices(struct kvm *kvm)
>> +{
>> +	int i, ret;
>> +
>> +	for (i =3D 0; i < kvm->cfg.num_vfio_devices; ++i) {
>> +		ret =3D iommufd_configure_device(kvm, &vfio_devices[i]);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int iommufd_create_ioas(struct kvm *kvm)
>> +{
>> +	int ret;
>> +	struct iommu_ioas_alloc alloc_data;
>> +	iommu_fd =3D open(IOMMU_DEV, O_RDWR);
>> +	if (iommu_fd =3D=3D -1) {
>> +		ret =3D errno;
>> +		pr_err("Failed to open %s", IOMMU_DEV);
>> +		return ret;
>> +	}
>> +
>> +	alloc_data.size =3D sizeof(alloc_data);
>> +	alloc_data.flags =3D 0;
>> +
>> +	if (ioctl(iommu_fd, IOMMU_IOAS_ALLOC, &alloc_data)) {
>> +		ret =3D errno;
>
> For all other ioctls, we return -errorno, except here, is there a reason
> for that?
>

No. Will update the patch.


>> +		pr_err("Failed to alloc IOAS ");
> Also, extra space at the end, also maybe more consistent with the rest of
> the code with =E2=80=9Cvfio_dev_err=E2=80=9D.
>
>> +		goto err_close_device;
>> +	}
>> +	ioas_id =3D alloc_data.out_ioas_id;
>> +	return 0;
>> +
>> +err_close_device:
>> +	close(iommu_fd);
>> +	return ret;
>> +}
>> +
>> +static int vfio_device_init(struct kvm *kvm, struct vfio_device *vdev)
>> +{
>> +	int ret, dirfd;
>> +	char *group_name;
>> +	unsigned long group_id;
>> +	char dev_path[PATH_MAX];
>> +	struct vfio_group *group =3D NULL;
>> +
>> +	ret =3D snprintf(dev_path, PATH_MAX, "/sys/bus/%s/devices/%s",
>> +		       vdev->params->bus, vdev->params->name);
>> +	if (ret < 0 || ret =3D=3D PATH_MAX)
>> +		return -EINVAL;
>> +
>> +	vdev->sysfs_path =3D strndup(dev_path, PATH_MAX);
>> +	if (!vdev->sysfs_path)
>> +		return -ENOMEM;
>> +
>> +	/* Find IOMMU group for this device */
>> +	dirfd =3D open(vdev->sysfs_path, O_DIRECTORY | O_PATH | O_RDONLY);
>> +	if (dirfd < 0) {
>> +		vfio_dev_err(vdev, "failed to open '%s'", vdev->sysfs_path);
>> +		return -errno;
>> +	}
>> +
>> +	ret =3D readlinkat(dirfd, "iommu_group", dev_path, PATH_MAX);
>> +	if (ret < 0) {
>> +		vfio_dev_err(vdev, "no iommu_group");
>> +		goto out_close;
>> +	}
>> +	if (ret =3D=3D PATH_MAX) {
>> +		ret =3D  -ENOMEM;
>> +		goto out_close;
>> +	}
>> +
>> +	dev_path[ret] =3D '\0';
>> +	group_name =3D basename(dev_path);
>> +	errno =3D 0;
>> +	group_id =3D strtoul(group_name, NULL, 10);
>> +	if (errno) {
>> +		ret =3D -errno;
>> +		goto out_close;
>> +	}
>> +
>> +	list_for_each_entry(group, &vfio_groups, list) {
>> +		if (group->id =3D=3D group_id) {
>> +			group->refs++;
>> +			break;
>> +		}
>> +	}
>> +	if (group->id !=3D group_id) {
>> +		group =3D calloc(1, sizeof(*group));
>> +		if (!group) {
>> +			ret =3D -ENOMEM;
>> +			goto out_close;
>> +		}
>> +		group->id	=3D group_id;
>> +		group->refs	=3D 1;
>> +		/* no group fd for iommufd */
>> +		group->fd	=3D -1;
>> +		list_add(&group->list, &vfio_groups);
>> +	}
>> +	vdev->group =3D group;
>> +	ret =3D 0;
>> +
>
> There is some duplication with =E2=80=9Cvfio_group_get_for_dev=E2=80=9D, =
I wonder if we could
> re-use some of this code in a helper.
>
>> +out_close:
>> +	close(dirfd);
>> +	return ret;
>> +}
>> +
>> +static int iommufd_map_mem_range(struct kvm *kvm, __u64 host_addr, __u6=
4 iova, __u64 size)
>> +{
>> +	int ret =3D 0;
>> +	struct iommu_ioas_map dma_map;
>> +
>> +	dma_map.size =3D sizeof(dma_map);
>> +	dma_map.flags =3D IOMMU_IOAS_MAP_READABLE | IOMMU_IOAS_MAP_WRITEABLE |
>> +			IOMMU_IOAS_MAP_FIXED_IOVA;
>> +	dma_map.ioas_id =3D ioas_id;
>> +	dma_map.__reserved =3D 0;
>> +	dma_map.user_va =3D host_addr;
>> +	dma_map.iova =3D iova;
>> +	dma_map.length =3D size;
>> +
>> +	/* Map the guest memory for DMA (i.e. provide isolation) */
>> +	if (ioctl(iommu_fd, IOMMU_IOAS_MAP, &dma_map)) {
>> +		ret =3D -errno;
>> +		pr_err("Failed to map 0x%llx -> 0x%llx (%u) for DMA",
>> +		       dma_map.iova, dma_map.user_va, dma_map.size);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int iommufd_unmap_mem_range(struct kvm *kvm,  __u64 iova, __u64 =
size)
>> +{
>> +	int ret =3D 0;
>> +	struct iommu_ioas_unmap dma_unmap;
>> +
>> +	dma_unmap.size =3D sizeof(dma_unmap);
>> +	dma_unmap.ioas_id =3D ioas_id;
>> +	dma_unmap.iova =3D iova;
>> +	dma_unmap.length =3D size;
>> +
>> +	if (ioctl(iommu_fd, IOMMU_IOAS_UNMAP, &dma_unmap)) {
>> +		ret =3D -errno;
>> +		if (ret !=3D -ENOENT)
>> +			pr_err("Failed to unmap 0x%llx - size (%u) for DMA %d",
>> +			       dma_unmap.iova, dma_unmap.size, ret);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int iommufd_map_mem_bank(struct kvm *kvm, struct kvm_mem_bank *b=
ank, void *data)
>> +{
>> +	return iommufd_map_mem_range(kvm, (u64)bank->host_addr, bank->guest_ph=
ys_addr, bank->size);
>> +}
>> +
>> +static int iommufd_configure_reserved_mem(struct kvm *kvm)
>> +{
>> +	int ret;
>> +	struct vfio_group *group;
>> +
>> +	list_for_each_entry(group, &vfio_groups, list) {
>> +		ret =3D vfio_configure_reserved_regions(kvm, group);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +	return 0;
>> +}
>> +
>> +int iommufd__init(struct kvm *kvm)
>> +{
>> +	int ret, i;
>> +
>> +	for (i =3D 0; i < kvm->cfg.num_vfio_devices; ++i) {
>> +		vfio_devices[i].params =3D &kvm->cfg.vfio_devices[i];
>> +
>> +		ret =3D vfio_device_init(kvm, &vfio_devices[i]);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>> +	ret =3D iommufd_create_ioas(kvm);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret =3D iommufd_configure_devices(kvm);
>> +	if (ret)
>> +		return ret;
>> +
>
> Any failure after this point will just return, although iommufd_create_io=
as()
> would =E2=80=9Cclose(iommu_fd)=E2=80=9D on failure.
> Also, don=E2=80=99t we want to close =E2=80=9Ciommu_fd=E2=80=9D at exit s=
imilar to the VFIO container?
>

That is already fixed in the latest version=20

> Thanks,
> Mostafa
>
>> +	ret =3D iommufd_configure_reserved_mem(kvm);
>> +	if (ret)
>> +		return ret;
>> +
>> +	dma_map_mem_range =3D iommufd_map_mem_range;
>> +	dma_unmap_mem_range =3D iommufd_unmap_mem_range;
>> +	/* Now map the full memory */
>> +	return kvm__for_each_mem_bank(kvm, KVM_MEM_TYPE_RAM, iommufd_map_mem_b=
ank,
>> +				      NULL);
>> +}
>> +
>> +int iommufd__exit(struct kvm *kvm)
>> +{
>> +	return 0;
>> +}
>> --=20
>> 2.43.0
>>=20

-aneesh

