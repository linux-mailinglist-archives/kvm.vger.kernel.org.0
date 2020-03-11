Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE3518244F
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 22:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729848AbgCKV7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 17:59:03 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50365 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729833AbgCKV7C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Mar 2020 17:59:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583963941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1whyTaqxeWmeVmELcBZBM1vsDc7mnyOsYZAT5SidNlY=;
        b=ATj8Gmbr1BpKEYd6TE4gDbxS8gfnC6N1XCNn1W2kfrXHMxXzLSxEdAam09OqHkB8oUe3Rt
        F3vmibYrHEokzmKksSymjlBS5+nyWA3nNacjzjcRGRRnwfgZG0IDdgITEGD283r2OeFL82
        v0MNmfPVTwN50Ch2K/94pDYeNQjSq6E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-8_sjdowoNpWk5ZKP2Yj-RQ-1; Wed, 11 Mar 2020 17:58:57 -0400
X-MC-Unique: 8_sjdowoNpWk5ZKP2Yj-RQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 268CF100550E;
        Wed, 11 Mar 2020 21:58:56 +0000 (UTC)
Received: from gimli.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3D1492D2A;
        Wed, 11 Mar 2020 21:58:52 +0000 (UTC)
Subject: [PATCH v3 3/7] vfio/pci: Introduce VF token
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@dpdk.org, mtosatti@redhat.com, thomas@monjalon.net,
        bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com, kevin.tian@intel.com
Date:   Wed, 11 Mar 2020 15:58:52 -0600
Message-ID: <158396393244.5601.10297430724964025753.stgit@gimli.home>
In-Reply-To: <158396044753.5601.14804870681174789709.stgit@gimli.home>
References: <158396044753.5601.14804870681174789709.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If we enable SR-IOV on a vfio-pci owned PF, the resulting VFs are not
fully isolated from the PF.  The PF can always cause a denial of service
to the VF, even if by simply resetting itself.  The degree to which a PF
can access the data passed through a VF or interfere with its operation
is dependent on a given SR-IOV implementation.  Therefore we want to
avoid a scenario where an existing vfio-pci based userspace driver might
assume the PF driver is trusted, for example assigning a PF to one VM
and VF to another with some expectation of isolation.  IOMMU grouping
could be a solution to this, but imposes an unnecessarily strong
relationship between PF and VF drivers if they need to operate with the
same IOMMU context.  Instead we introduce a "VF token", which is
essentially just a shared secret between PF and VF drivers, implemented
as a UUID.

The VF token can be set by a vfio-pci based PF driver and must be known
by the vfio-pci based VF driver in order to gain access to the device.
This allows the degree to which this VF token is considered secret to be
determined by the applications and environment.  For example a VM might
generate a random UUID known only internally to the hypervisor while a
userspace networking appliance might use a shared, or even well know,
UUID among the application drivers.

To incorporate this VF token, the VFIO_GROUP_GET_DEVICE_FD interface is
extended to accept key=value pairs in addition to the device name.  This
allows us to most easily deny user access to the device without risk
that existing userspace drivers assume region offsets, IRQs, and other
device features, leading to more elaborate error paths.  The format of
these options are expected to take the form:

"$DEVICE_NAME $OPTION1=$VALUE1 $OPTION2=$VALUE2"

Where the device name is always provided first for compatibility and
additional options are specified in a space separated list.  The
relation between and requirements for the additional options will be
vfio bus driver dependent, however unknown or unused option within this
schema should return error.  This allow for future use of unknown
options as well as a positive indication to the user that an option is
used.

An example VF token option would take this form:

"0000:03:00.0 vf_token=2ab74924-c335-45f4-9b16-8569e5b08258"

When accessing a VF where the PF is making use of vfio-pci, the user
MUST provide the current vf_token.  When accessing a PF, the user MUST
provide the current vf_token IF there are active VF users or MAY provide
a vf_token in order to set the current VF token when no VF users are
active.  The former requirement assures VF users that an unassociated
driver cannot usurp the PF device.  These semantics also imply that a
VF token MUST be set by a PF driver before VF drivers can access their
device, the default token is random and mechanisms to read the token are
not provided in order to protect the VF token of previous users.  Use of
the vf_token option outside of these cases will return an error, as
discussed above.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c         |  198 +++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |    8 +
 2 files changed, 205 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 2ec6c31d0ab0..5277c6c2fa72 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -466,6 +466,44 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 }
 
+static struct pci_driver vfio_pci_driver;
+
+static struct vfio_pci_device *get_pf_vdev(struct vfio_pci_device *vdev,
+					   struct vfio_device **pf_dev)
+{
+	struct pci_dev *physfn = pci_physfn(vdev->pdev);
+
+	if (!vdev->pdev->is_virtfn)
+		return NULL;
+
+	*pf_dev = vfio_device_get_from_dev(&physfn->dev);
+	if (!*pf_dev)
+		return NULL;
+
+	if (pci_dev_driver(physfn) != &vfio_pci_driver) {
+		vfio_device_put(*pf_dev);
+		return NULL;
+	}
+
+	return vfio_device_data(*pf_dev);
+}
+
+static void vfio_pci_vf_token_user_add(struct vfio_pci_device *vdev, int val)
+{
+	struct vfio_device *pf_dev;
+	struct vfio_pci_device *pf_vdev = get_pf_vdev(vdev, &pf_dev);
+
+	if (!pf_vdev)
+		return;
+
+	mutex_lock(&pf_vdev->vf_token->lock);
+	pf_vdev->vf_token->users += val;
+	WARN_ON(pf_vdev->vf_token->users < 0);
+	mutex_unlock(&pf_vdev->vf_token->lock);
+
+	vfio_device_put(pf_dev);
+}
+
 static void vfio_pci_release(void *device_data)
 {
 	struct vfio_pci_device *vdev = device_data;
@@ -473,6 +511,7 @@ static void vfio_pci_release(void *device_data)
 	mutex_lock(&vdev->reflck->lock);
 
 	if (!(--vdev->refcnt)) {
+		vfio_pci_vf_token_user_add(vdev, -1);
 		vfio_spapr_pci_eeh_release(vdev->pdev);
 		vfio_pci_disable(vdev);
 	}
@@ -498,6 +537,7 @@ static int vfio_pci_open(void *device_data)
 			goto error;
 
 		vfio_spapr_pci_eeh_open(vdev->pdev);
+		vfio_pci_vf_token_user_add(vdev, 1);
 	}
 	vdev->refcnt++;
 error:
@@ -1278,11 +1318,148 @@ static void vfio_pci_request(void *device_data, unsigned int count)
 	mutex_unlock(&vdev->igate);
 }
 
+static int vfio_pci_validate_vf_token(struct vfio_pci_device *vdev,
+				      bool vf_token, uuid_t *uuid)
+{
+	/*
+	 * There's always some degree of trust or collaboration between SR-IOV
+	 * PF and VFs, even if just that the PF hosts the SR-IOV capability and
+	 * can disrupt VFs with a reset, but often the PF has more explicit
+	 * access to deny service to the VF or access data passed through the
+	 * VF.  We therefore require an opt-in via a shared VF token (UUID) to
+	 * represent this trust.  This both prevents that a VF driver might
+	 * assume the PF driver is a trusted, in-kernel driver, and also that
+	 * a PF driver might be replaced with a rogue driver, unknown to in-use
+	 * VF drivers.
+	 *
+	 * Therefore when presented with a VF, if the PF is a vfio device and
+	 * it is bound to the vfio-pci driver, the user needs to provide a VF
+	 * token to access the device, in the form of appending a vf_token to
+	 * the device name, for example:
+	 *
+	 * "0000:04:10.0 vf_token=bd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
+	 *
+	 * When presented with a PF which has VFs in use, the user must also
+	 * provide the current VF token to prove collaboration with existing
+	 * VF users.  If VFs are not in use, the VF token provided for the PF
+	 * device will act to set the VF token.
+	 *
+	 * If the VF token is provided but unused, an error is generated.
+	 */
+	if (!vdev->pdev->is_virtfn && !vdev->vf_token && !vf_token)
+		return 0; /* No VF token provided or required */
+
+	if (vdev->pdev->is_virtfn) {
+		struct vfio_device *pf_dev;
+		struct vfio_pci_device *pf_vdev = get_pf_vdev(vdev, &pf_dev);
+		bool match;
+
+		if (!pf_vdev) {
+			if (!vf_token)
+				return 0; /* PF is not vfio-pci, no VF token */
+
+			pci_info_ratelimited(vdev->pdev,
+				"VF token incorrectly provided, PF not bound to vfio-pci\n");
+			return -EINVAL;
+		}
+
+		if (!vf_token) {
+			vfio_device_put(pf_dev);
+			pci_info_ratelimited(vdev->pdev,
+				"VF token required to access device\n");
+			return -EACCES;
+		}
+
+		mutex_lock(&pf_vdev->vf_token->lock);
+		match = uuid_equal(uuid, &pf_vdev->vf_token->uuid);
+		mutex_unlock(&pf_vdev->vf_token->lock);
+
+		vfio_device_put(pf_dev);
+
+		if (!match) {
+			pci_info_ratelimited(vdev->pdev,
+				"Incorrect VF token provided for device\n");
+			return -EACCES;
+		}
+	} else if (vdev->vf_token) {
+		mutex_lock(&vdev->vf_token->lock);
+		if (vdev->vf_token->users) {
+			if (!vf_token) {
+				mutex_unlock(&vdev->vf_token->lock);
+				pci_info_ratelimited(vdev->pdev,
+					"VF token required to access device\n");
+				return -EACCES;
+			}
+
+			if (!uuid_equal(uuid, &vdev->vf_token->uuid)) {
+				mutex_unlock(&vdev->vf_token->lock);
+				pci_info_ratelimited(vdev->pdev,
+					"Incorrect VF token provided for device\n");
+				return -EACCES;
+			}
+		} else if (vf_token) {
+			uuid_copy(&vdev->vf_token->uuid, uuid);
+		}
+
+		mutex_unlock(&vdev->vf_token->lock);
+	} else if (vf_token) {
+		pci_info_ratelimited(vdev->pdev,
+			"VF token incorrectly provided, not a PF or VF\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+#define VF_TOKEN_ARG "vf_token="
+
 static int vfio_pci_match(void *device_data, char *buf)
 {
 	struct vfio_pci_device *vdev = device_data;
+	bool vf_token = false;
+	uuid_t uuid;
+	int ret;
+
+	if (strncmp(pci_name(vdev->pdev), buf, strlen(pci_name(vdev->pdev))))
+		return 0; /* No match */
+
+	if (strlen(buf) > strlen(pci_name(vdev->pdev))) {
+		buf += strlen(pci_name(vdev->pdev));
+
+		if (*buf != ' ')
+			return 0; /* No match: non-whitespace after name */
+
+		while (*buf) {
+			if (*buf == ' ') {
+				buf++;
+				continue;
+			}
+
+			if (!vf_token && !strncmp(buf, VF_TOKEN_ARG,
+						  strlen(VF_TOKEN_ARG))) {
+				buf += strlen(VF_TOKEN_ARG);
+
+				if (strlen(buf) < UUID_STRING_LEN)
+					return -EINVAL;
+
+				ret = uuid_parse(buf, &uuid);
+				if (ret)
+					return ret;
 
-	return !strcmp(pci_name(vdev->pdev), buf);
+				vf_token = true;
+				buf += UUID_STRING_LEN;
+			} else {
+				/* Unknown/duplicate option */
+				return -EINVAL;
+			}
+		}
+	}
+
+	ret = vfio_pci_validate_vf_token(vdev, vf_token, &uuid);
+	if (ret)
+		return ret;
+
+	return 1; /* Match */
 }
 
 static const struct vfio_device_ops vfio_pci_ops = {
@@ -1354,6 +1531,19 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return ret;
 	}
 
+	if (pdev->is_physfn) {
+		vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
+		if (!vdev->vf_token) {
+			vfio_pci_reflck_put(vdev->reflck);
+			vfio_del_group_dev(&pdev->dev);
+			vfio_iommu_group_put(group, &pdev->dev);
+			kfree(vdev);
+			return -ENOMEM;
+		}
+		mutex_init(&vdev->vf_token->lock);
+		uuid_gen(&vdev->vf_token->uuid);
+	}
+
 	if (vfio_pci_is_vga(pdev)) {
 		vga_client_register(pdev, vdev, NULL, vfio_pci_set_vga_decode);
 		vga_set_legacy_decoding(pdev,
@@ -1387,6 +1577,12 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 	if (!vdev)
 		return;
 
+	if (vdev->vf_token) {
+		WARN_ON(vdev->vf_token->users);
+		mutex_destroy(&vdev->vf_token->lock);
+		kfree(vdev->vf_token);
+	}
+
 	vfio_pci_reflck_put(vdev->reflck);
 
 	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 8a2c7607d513..76c11c915949 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/irqbypass.h>
 #include <linux/types.h>
+#include <linux/uuid.h>
 
 #ifndef VFIO_PCI_PRIVATE_H
 #define VFIO_PCI_PRIVATE_H
@@ -84,6 +85,12 @@ struct vfio_pci_reflck {
 	struct mutex		lock;
 };
 
+struct vfio_pci_vf_token {
+	struct mutex		lock;
+	uuid_t			uuid;
+	int			users;
+};
+
 struct vfio_pci_device {
 	struct pci_dev		*pdev;
 	void __iomem		*barmap[PCI_STD_NUM_BARS];
@@ -122,6 +129,7 @@ struct vfio_pci_device {
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
+	struct vfio_pci_vf_token	*vf_token;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)

