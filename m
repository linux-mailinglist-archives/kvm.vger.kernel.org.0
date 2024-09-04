Return-Path: <kvm+bounces-25860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD59896BA4D
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:23:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51E1F1F23D15
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C703C1D47D7;
	Wed,  4 Sep 2024 11:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YoViJLpF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5591D0DC5
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 11:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725448738; cv=none; b=Vw4ZCdro3jn0yy32lg5K43+ft1sle1oPXw58+9DMHelDPa3bVUnW+9rGzY1Xguez298+7SqK85uPkWeguINyxn1CClHIKEcDKyScPEaXt8rVLjlmJafHraID+Q+LJwPMwqTRNZhHYIKiRGSPEBx0R6IBW9WmG742Yc85U3Ug8EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725448738; c=relaxed/simple;
	bh=oLuMjOXq+AyXgEb8zMu3k60H+6e7aA6ZGz9G17sfUYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YuSAXjMwbpMMG3sTlHdOB7Z6g/uMz2UQVcamjzOk7Y9VZo0tw9ztEzp3DbmHB8Nz1+6WLwYf/2zMfAXzyTD5Haon3EvfPowE9Hr4rXioDQPb3O+iMeQ1YF+YMm1EvzhWQtOn6bMxRWC/1d5QHuH6v70N9RN8aQ8XkQ/m1yjNrTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YoViJLpF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725448735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AOXOx69AjXFnVeSXCiUEnvi9+g/XRHvEVNlHUQEOkmw=;
	b=YoViJLpFseYa+409L27BaUVqs6jEEHeIGBXVxGBWGQJ/q6kaU672fw/46rU8ztm2jYz+Vq
	beN+WZW7azAdPf3srffpS1AKAsIrLlIrs5Cs/YTK9P4wjL3mTN7lBS2474/+mwd9sLNrm8
	cYRc3RHm3Jy5fmFexBRbVR49MRrkglQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-ofAYSMSyOQ-lOH4Y7zlY6Q-1; Wed,
 04 Sep 2024 07:18:50 -0400
X-MC-Unique: ofAYSMSyOQ-lOH4Y7zlY6Q-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C6CEF1955D45;
	Wed,  4 Sep 2024 11:18:41 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9702119560A3;
	Wed,  4 Sep 2024 11:18:38 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 9C53021E6889; Wed,  4 Sep 2024 13:18:36 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: alex.williamson@redhat.com,
	andrew@codeconstruct.com.au,
	andrew@daynix.com,
	arei.gonglei@huawei.com,
	berrange@redhat.com,
	berto@igalia.com,
	borntraeger@linux.ibm.com,
	clg@kaod.org,
	david@redhat.com,
	den@openvz.org,
	eblake@redhat.com,
	eduardo@habkost.net,
	farman@linux.ibm.com,
	farosas@suse.de,
	hreitz@redhat.com,
	idryomov@gmail.com,
	iii@linux.ibm.com,
	jamin_lin@aspeedtech.com,
	jasowang@redhat.com,
	joel@jms.id.au,
	jsnow@redhat.com,
	kwolf@redhat.com,
	leetroy@gmail.com,
	marcandre.lureau@redhat.com,
	marcel.apfelbaum@gmail.com,
	michael.roth@amd.com,
	mst@redhat.com,
	mtosatti@redhat.com,
	nsg@linux.ibm.com,
	pasic@linux.ibm.com,
	pbonzini@redhat.com,
	peter.maydell@linaro.org,
	peterx@redhat.com,
	philmd@linaro.org,
	pizhenwei@bytedance.com,
	pl@dlhnet.de,
	richard.henderson@linaro.org,
	stefanha@redhat.com,
	steven_lee@aspeedtech.com,
	thuth@redhat.com,
	vsementsov@yandex-team.ru,
	wangyanan55@huawei.com,
	yuri.benditovich@daynix.com,
	zhao1.liu@intel.com,
	qemu-block@nongnu.org,
	qemu-arm@nongnu.org,
	qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	avihaih@nvidia.com,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>
Subject: [PATCH v2 04/19] qapi/common: Drop temporary 'prefix'
Date: Wed,  4 Sep 2024 13:18:21 +0200
Message-ID: <20240904111836.3273842-5-armbru@redhat.com>
In-Reply-To: <20240904111836.3273842-1-armbru@redhat.com>
References: <20240904111836.3273842-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Recent commit "qapi: Smarter camel_to_upper() to reduce need for
'prefix'" added a temporary 'prefix' to delay changing the generated
code.

Revert it.  This improves OffAutoPCIBAR's generated enumeration
constant prefix from OFF_AUTOPCIBAR to OFF_AUTO_PCIBAR.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Cédric Le Goater <clg@redhat.com>
---
 qapi/common.json |  1 -
 hw/vfio/pci.c    | 10 +++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/qapi/common.json b/qapi/common.json
index 25726d3113..7558ce5430 100644
--- a/qapi/common.json
+++ b/qapi/common.json
@@ -92,7 +92,6 @@
 # Since: 2.12
 ##
 { 'enum': 'OffAutoPCIBAR',
-  'prefix': 'OFF_AUTOPCIBAR',   # TODO drop
   'data': [ 'off', 'auto', 'bar0', 'bar1', 'bar2', 'bar3', 'bar4', 'bar5' ] }
 
 ##
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 2407720c35..0a99e55247 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -1452,7 +1452,7 @@ static bool vfio_pci_relocate_msix(VFIOPCIDevice *vdev, Error **errp)
     int target_bar = -1;
     size_t msix_sz;
 
-    if (!vdev->msix || vdev->msix_relo == OFF_AUTOPCIBAR_OFF) {
+    if (!vdev->msix || vdev->msix_relo == OFF_AUTO_PCIBAR_OFF) {
         return true;
     }
 
@@ -1464,7 +1464,7 @@ static bool vfio_pci_relocate_msix(VFIOPCIDevice *vdev, Error **errp)
     /* PCI BARs must be a power of 2 */
     msix_sz = pow2ceil(msix_sz);
 
-    if (vdev->msix_relo == OFF_AUTOPCIBAR_AUTO) {
+    if (vdev->msix_relo == OFF_AUTO_PCIBAR_AUTO) {
         /*
          * TODO: Lookup table for known devices.
          *
@@ -1479,7 +1479,7 @@ static bool vfio_pci_relocate_msix(VFIOPCIDevice *vdev, Error **errp)
             return false;
         }
     } else {
-        target_bar = (int)(vdev->msix_relo - OFF_AUTOPCIBAR_BAR0);
+        target_bar = (int)(vdev->msix_relo - OFF_AUTO_PCIBAR_BAR0);
     }
 
     /* I/O port BARs cannot host MSI-X structures */
@@ -1624,7 +1624,7 @@ static bool vfio_msix_early_setup(VFIOPCIDevice *vdev, Error **errp)
         } else if (vfio_pci_is(vdev, PCI_VENDOR_ID_BAIDU,
                                PCI_DEVICE_ID_KUNLUN_VF)) {
             msix->pba_offset = 0xb400;
-        } else if (vdev->msix_relo == OFF_AUTOPCIBAR_OFF) {
+        } else if (vdev->msix_relo == OFF_AUTO_PCIBAR_OFF) {
             error_setg(errp, "hardware reports invalid configuration, "
                        "MSIX PBA outside of specified BAR");
             g_free(msix);
@@ -3403,7 +3403,7 @@ static Property vfio_pci_dev_properties[] = {
                                    nv_gpudirect_clique,
                                    qdev_prop_nv_gpudirect_clique, uint8_t),
     DEFINE_PROP_OFF_AUTO_PCIBAR("x-msix-relocation", VFIOPCIDevice, msix_relo,
-                                OFF_AUTOPCIBAR_OFF),
+                                OFF_AUTO_PCIBAR_OFF),
 #ifdef CONFIG_IOMMUFD
     DEFINE_PROP_LINK("iommufd", VFIOPCIDevice, vbasedev.iommufd,
                      TYPE_IOMMUFD_BACKEND, IOMMUFDBackend *),
-- 
2.46.0


