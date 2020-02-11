Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C437159CCA
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 00:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgBKXGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 18:06:06 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45163 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727965AbgBKXGF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Feb 2020 18:06:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581462363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=euk0LJLXtslM2hWqkPSQesMItzrYYYlSLZ2gYZ8UrSA=;
        b=ciJBLk8Vn0WjxLNS3s2XpgrSwXYxwVA5DL4eRLhJtudR7O+kVe5zLjdOXRMNmnwxxivHbH
        vfectgfIIae7svgYRLPeym2ed+BMnxM57CzanMOa9BZo4Kw1+F5QE0bSXTJpBvUtJ6BmC0
        zZtux5m4CjHeYWow6QsQistWEJE2W0U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-d2Gkq4rFN-yYNZBVxKuSkQ-1; Tue, 11 Feb 2020 18:05:56 -0500
X-MC-Unique: d2Gkq4rFN-yYNZBVxKuSkQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF411800EB2;
        Tue, 11 Feb 2020 23:05:54 +0000 (UTC)
Received: from gimli.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B902426FAA;
        Tue, 11 Feb 2020 23:05:51 +0000 (UTC)
Subject: [PATCH 4/7] vfio: Introduce VFIO_DEVICE_FEATURE ioctl and first user
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@dpdk.org, mtosatti@redhat.com, thomas@monjalon.net,
        bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com
Date:   Tue, 11 Feb 2020 16:05:51 -0700
Message-ID: <158146235133.16827.7215789038918853214.stgit@gimli.home>
In-Reply-To: <158145472604.16827.15751375540102298130.stgit@gimli.home>
References: <158145472604.16827.15751375540102298130.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VFIO_DEVICE_FEATURE ioctl is meant to be a general purpose, device
agnostic ioctl for setting, retrieving, and probing device features.
This implementation provides a 16-bit field for specifying a feature
index, where the data porition of the ioctl is determined by the
semantics for the given feature.  Additional flag bits indicate the
direction and nature of the operation; SET indicates user data is
provided into the device feature, GET indicates the device feature is
written out into user data.  The PROBE flag augments determining
whether the given feature is supported, and if provided, whether the
given operation on the feature is supported.

The first user of this ioctl is for setting the vfio-pci VF token,
where the user provides a shared secret key (UUID) on a SR-IOV PF
device, which users must provide when opening associated VF devices.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |   52 +++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h   |   37 +++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 26aea9ac4863..5414744a3ead 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1171,6 +1171,58 @@ static long vfio_pci_ioctl(void *device_data,
 
 		return vfio_pci_ioeventfd(vdev, ioeventfd.offset,
 					  ioeventfd.data, count, ioeventfd.fd);
+	} else if (cmd == VFIO_DEVICE_FEATURE) {
+		struct vfio_device_feature feature;
+		uuid_t uuid;
+
+		minsz = offsetofend(struct vfio_device_feature, flags);
+
+		if (copy_from_user(&feature, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (feature.argsz < minsz)
+			return -EINVAL;
+
+		if (feature.flags & ~(VFIO_DEVICE_FEATURE_MASK |
+				      VFIO_DEVICE_FEATURE_SET |
+				      VFIO_DEVICE_FEATURE_GET |
+				      VFIO_DEVICE_FEATURE_PROBE))
+			return -EINVAL;
+
+		switch (feature.flags & VFIO_DEVICE_FEATURE_MASK) {
+		case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
+			if (!vdev->vf_token)
+				return -ENOTTY;
+
+			/*
+			 * We do not support GET of the VF Token UUID as this
+			 * could expose the token of the previous device user.
+			 */
+			if (feature.flags & VFIO_DEVICE_FEATURE_GET)
+				return -EINVAL;
+
+			if (feature.flags & VFIO_DEVICE_FEATURE_PROBE)
+				return 0;
+
+			/* Don't SET unless told to do so */
+			if (!(feature.flags & VFIO_DEVICE_FEATURE_SET))
+				return -EINVAL;
+
+			if (feature.argsz < minsz + sizeof(uuid))
+				return -EINVAL;
+
+			if (copy_from_user(&uuid, (void __user *)(arg + minsz),
+					   sizeof(uuid)))
+				return -EFAULT;
+
+			mutex_lock(&vdev->vf_token->lock);
+			uuid_copy(&vdev->vf_token->uuid, &uuid);
+			mutex_unlock(&vdev->vf_token->lock);
+
+			return 0;
+		default:
+			return -ENOTTY;
+		}
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9e843a147ead..c5cbf04ce5a7 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -707,6 +707,43 @@ struct vfio_device_ioeventfd {
 
 #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+/**
+ * VFIO_DEVICE_FEATURE - _IORW(VFIO_TYPE, VFIO_BASE + 17,
+ *			       struct vfio_device_feature
+ *
+ * Get, set, or probe feature data of the device.  The feature is selected
+ * using the FEATURE_MASK portion of the flags field.  Support for a feature
+ * can be probed by setting both the FEATURE_MASK and PROBE bits.  A probe
+ * may optionally include the GET and/or SET bits to determine read vs write
+ * access of the feature respectively.  Probing a feature will return success
+ * if the feature is supported and all of the optionally indicated GET/SET
+ * methods are supported.  The format of the data portion of the structure is
+ * specific to the given feature.  The data portion is not required for
+ * probing.
+ *
+ * Return 0 on success, -errno on failure.
+ */
+struct vfio_device_feature {
+	__u32	argsz;
+	__u32	flags;
+#define VFIO_DEVICE_FEATURE_MASK	(0xffff) /* 16-bit feature index */
+#define VFIO_DEVICE_FEATURE_GET		(1 << 16) /* Get feature into data[] */
+#define VFIO_DEVICE_FEATURE_SET		(1 << 17) /* Set feature from data[] */
+#define VFIO_DEVICE_FEATURE_PROBE	(1 << 18) /* Probe feature support */
+	__u8	data[];
+};
+
+#define VFIO_DEVICE_FEATURE		_IO(VFIO_TYPE, VFIO_BASE + 17)
+
+/*
+ * Provide support for setting a PCI VF Token, which is used as a shared
+ * secret between PF and VF drivers.  This feature may only be set on a
+ * PCI SR-IOV PF when SR-IOV is enabled on the PF and there are no existing
+ * open VFs.  Data provided when setting this feature is a 16-byte array
+ * (__u8 b[16]), representing a UUID.
+ */
+#define VFIO_DEVICE_FEATURE_PCI_VF_TOKEN	(0)
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**

