Return-Path: <kvm+bounces-53420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EC86B11482
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 01:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D68E188F04A
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 23:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DAA8242936;
	Thu, 24 Jul 2025 23:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="uuIkmGxr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8BA1553A3
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 23:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753399837; cv=none; b=JM9NTBUNdKmWLfqZXv+IBbAA4l1DXt5t2b/Qw4Zq9DY2rz4U2vLDJZtepw12mqtrvotGEVu7MRJ0+iEhT4bTjarAEx9M+3ZEQjNeaPo+N0V0nZnDXZtIglb4TIAqqgnqbe+UiZMczgQbzHj2JTBnnlUhbehtqKZD84/TAF4NLSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753399837; c=relaxed/simple;
	bh=cm9lVkdrUaYvDK0DlFW5HCcydFsq2T/oMNAihmb5fXw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=dFu5jvDuyCFls14KwJJfvd0pQAAlmIBCvVnltRVx/q0Ai9oTD301znjETwfpe0SdFynExfpyzwDoqYDUkxa4oHnDhurpLTtOR4sZEpBzBVsZ109snXlFnZ8Olu8I7p4zxxkvSCxO5NvdlgnB/16cnSOUwYKwtsqwavghx6wkEIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=uuIkmGxr; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56ONKCAn017310
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 16:30:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=nZZNbGXUGDCX5BH39w
	vpoe5DEFL6K8f/ETWeCvWR+lI=; b=uuIkmGxr/sNYS30iOYBeqsTPx5/WjPjtPb
	TrNSj+jd4GtQ8blC/N/Qt+mffY/y1wyrjqtdyGtZmLRpmcpJwEfA1mirJmm3QLjI
	UM4CpzbkWxXBi2u++gwzYm4p06OAFl9XiuSPeVgABQ7oHIWaIZvsLYy7Q9NIQh28
	RQBSYOdHVcunijqyfJM51uudA0dip8PiG1fNrtowGyc6mBO+MSHLYovdPpUFM+po
	amYhU+LXJBF2jOuK6Z05bCErMFbOtogMbQyfoqAC0rQEYqMEqLcoWmS8n9F9TThR
	7wB11fEOPTCVijhE1wzJh+1wDgn8sfbt6JVwCS1I4cdD9McyIW+A==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 483w39rk8h-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 16:30:34 -0700 (PDT)
Received: from twshared28243.32.prn2.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.17; Thu, 24 Jul 2025 23:30:31 +0000
Received: by devgpu007.eag1.facebook.com (Postfix, from userid 199522)
	id 4DB7626DE84; Thu, 24 Jul 2025 16:30:18 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
Date: Thu, 24 Jul 2025 16:29:53 -0700
Subject: [PATCH v2] vfio/pci: print vfio-device syspath to fdinfo
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250724-show-fdinfo-v2-1-2952115edc10@fb.com>
X-B4-Tracking: v=1; b=H4sIAPDBgmgC/5XOQQ6CMBCF4auQrh1DRympK+5hWNQytbOAmpZUD
 eHuFhLj2uW/eF/eIhJFpiQu1SIiZU4cphJ4qIT1ZroT8FBaYI1N3eIZkg9PcANPLoA2Wiqr2la
 7RpTFI5Lj165d+9IuhhFmH8n8DIUnyI7D18gSJFhtyarGoEbs3O1ow7h5ntMc4ns/l+Wm/mn06
 7p+AEi5k0zjAAAA
To: <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <peterx@redhat.com>, <kbusch@kernel.org>,
        <jgg@ziepe.ca>, Alex Mastro <amastro@fb.com>
X-Mailer: b4 0.13.0
X-FB-Internal: Safe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDE4NiBTYWx0ZWRfX5iMpiCHvs0ST 42j8WaVB5AYja2mklOS6o08j+s08CuzjqdaN9Ah87jOBm0tamgL3eBuiv1kSIM9Gg8hPm5GbpGF dk6Tno8wtUT2zazDMb/X7UfG/q2D8Tb+XCpwRYNYx6lFHZt9BuheSe8l0onu/QGIhIJ/nxkT2If
 XDYJvs+dzD96/W1fTBO/c65MuRLoaiCzVod3fq2JEflnBN4W0JUqPgUnoyT7rGryGFbqInKURo0 MN8hmT7L6LTA1wXmlylFt+wufNrNVPK1pjXWMauAXeiH1Yq7hH7Lu1ccnQ49TVJXUl4XOxnQk8z 4GOK+AKgCHaID/kjnwvl3EeBD6UKVyupx6P4Xu0O9QOAW0TDBjqu1trrMO3NsT37slIJIEaPIih
 /IXXhIDcPP+vg6v6pFg+rydkjScAKSDx97umAo0J5E6wSJQgUXW1OSbeUeqFOB8lITr9uzQ1
X-Authority-Analysis: v=2.4 cv=HoF2G1TS c=1 sm=1 tr=0 ts=6882c21a cx=c_pps a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=FOH2dFAWAAAA:8 a=HenG7Eq3vJZAMZ7HSsMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: KYJL-MeYQT7qweGH3rM01OXg3z6Fi6Zo
X-Proofpoint-ORIG-GUID: KYJL-MeYQT7qweGH3rM01OXg3z6Fi6Zo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_06,2025-07-24_01,2025-03-28_01

Print the PCI device syspath to a vfio device's fdinfo. This enables tools
to query which device is associated with a given vfio device fd.

This results in output like below:

$ cat /proc/"$SOME_PID"/fdinfo/"$VFIO_FD" | grep vfio
vfio-device-syspath: /sys/devices/pci0000:e0/0000:e0:01.1/0000:e1:00.0/0000:e2:05.0/0000:e8:00.0

Signed-off-by: Alex Mastro <amastro@fb.com>
---
Based on the feedback received from Jason G. and Alex W. in v1, print
the PCI device syspath to fdinfo instead of the BDF. This provides a
more specific waypoint for user space to query for any other relevant
information about the device.

There was discussion about removing vfio_device_ops callbacks, and
relying on just dev_name() in vfio_main.c, but since the concept of PCI
syspath is implementation-specific, I think we need to keep some form
of callback.

Signed-off-by: Alex Mastro <amastro@fb.com>

Changes in v2:
- Instead of PCI bdf, print the fully-qualified syspath (prefixed by
  /sys) to fdinfo.
- Rename the field to "vfio-device-syspath". The term "syspath" was
  chosen for consistency e.g. libudev's usage of the term.
- Link to v1: https://lore.kernel.org/r/20250623-vfio-fdinfo-v1-1-c9cec65a2922@fb.com
---
 drivers/vfio/pci/vfio_pci.c | 21 +++++++++++++++++++++
 drivers/vfio/vfio_main.c    | 14 ++++++++++++++
 include/linux/vfio.h        |  2 ++
 3 files changed, 37 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 5ba39f7623bb..bf3e7d873990 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -17,10 +17,12 @@
 #include <linux/file.h>
 #include <linux/interrupt.h>
 #include <linux/iommu.h>
+#include <linux/kobject.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/notifier.h>
 #include <linux/pm_runtime.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
@@ -125,6 +127,22 @@ static int vfio_pci_open_device(struct vfio_device *core_vdev)
 	return 0;
 }
 
+#ifdef CONFIG_PROC_FS
+static void vfio_pci_core_show_fdinfo(struct vfio_device *core_vdev, struct seq_file *m)
+{
+	char *path;
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+
+	path = kobject_get_path(&vdev->pdev->dev.kobj, GFP_KERNEL);
+	if (!path)
+		return;
+
+	seq_printf(m, "vfio-device-syspath: /sys%s\n", path);
+	kfree(path);
+}
+#endif
+
 static const struct vfio_device_ops vfio_pci_ops = {
 	.name		= "vfio-pci",
 	.init		= vfio_pci_core_init_dev,
@@ -138,6 +156,9 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.mmap		= vfio_pci_core_mmap,
 	.request	= vfio_pci_core_request,
 	.match		= vfio_pci_core_match,
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= vfio_pci_core_show_fdinfo,
+#endif
 	.bind_iommufd	= vfio_iommufd_physical_bind,
 	.unbind_iommufd	= vfio_iommufd_physical_unbind,
 	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 1fd261efc582..6e883c0c320b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1354,6 +1354,17 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 	return device->ops->mmap(device, vma);
 }
 
+#ifdef CONFIG_PROC_FS
+static void vfio_device_show_fdinfo(struct seq_file *m, struct file *filep)
+{
+	struct vfio_device_file *df = filep->private_data;
+	struct vfio_device *device = df->device;
+
+	if (device->ops->show_fdinfo)
+		device->ops->show_fdinfo(device, m);
+}
+#endif
+
 const struct file_operations vfio_device_fops = {
 	.owner		= THIS_MODULE,
 	.open		= vfio_device_fops_cdev_open,
@@ -1363,6 +1374,9 @@ const struct file_operations vfio_device_fops = {
 	.unlocked_ioctl	= vfio_device_fops_unl_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 	.mmap		= vfio_device_fops_mmap,
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= vfio_device_show_fdinfo,
+#endif
 };
 
 static struct vfio_device *vfio_device_from_file(struct file *file)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 707b00772ce1..54076045a44f 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -16,6 +16,7 @@
 #include <linux/cdev.h>
 #include <uapi/linux/vfio.h>
 #include <linux/iova_bitmap.h>
+#include <linux/seq_file.h>
 
 struct kvm;
 struct iommufd_ctx;
@@ -135,6 +136,7 @@ struct vfio_device_ops {
 	void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length);
 	int	(*device_feature)(struct vfio_device *device, u32 flags,
 				  void __user *arg, size_t argsz);
+	void	(*show_fdinfo)(struct vfio_device *device, struct seq_file *m);
 };
 
 #if IS_ENABLED(CONFIG_IOMMUFD)

---
base-commit: c1d9dac0db168198b6f63f460665256dedad9b6e
change-id: 20250724-show-fdinfo-9a916c6779f5

Best regards,
-- 
Alex Mastro <amastro@fb.com>


