Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4081E10DC
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 16:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390992AbgEYOpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 10:45:06 -0400
Received: from mga04.intel.com ([192.55.52.120]:34251 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388687AbgEYOpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 10:45:05 -0400
IronPort-SDR: Bmo5vKki7nsXC8+8CfFruKuVs+SOW0nk9i2DtYF9+3p6W/MNCkD+Z7CIknsSt/AXsfwuFo1Yza
 QK5SA7vd7eEw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2020 07:45:05 -0700
IronPort-SDR: ZARH7TqTOXBIcr+UZK902lPAlXXpqow1iZGtYTLq/gULvQT3CpFEc0h4G1Cl9XllPA056+uEUx
 UDdP3ZSLQoXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,433,1583222400"; 
   d="scan'208";a="266165828"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu.ger.corp.intel.com) ([10.249.41.109])
  by orsmga003.jf.intel.com with ESMTP; 25 May 2020 07:45:02 -0700
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v2 1/5] vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
Date:   Mon, 25 May 2020 16:44:54 +0200
Message-Id: <20200525144458.8413-2-guennadi.liakhovetski@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200525144458.8413-1-guennadi.liakhovetski@linux.intel.com>
References: <20200525144458.8413-1-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VHOST_VSOCK_SET_RUNNING is used by the vhost vsock driver to perform
crucial VirtQueue initialisation, like assigning .private fields and
calling vhost_vq_init_access(), and clean up. However, this ioctl is
actually extremely useful for any vhost driver, that doesn't have a
side channel to inform it of a status change, e.g. upon a guest
reboot. This patch makes that ioctl generic, while preserving its
numeric value and also keeping the original alias.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
---
 include/uapi/linux/vhost.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 9fe72e4..b54af9d 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -93,6 +93,8 @@
 #define VHOST_SET_BACKEND_FEATURES _IOW(VHOST_VIRTIO, 0x25, __u64)
 #define VHOST_GET_BACKEND_FEATURES _IOR(VHOST_VIRTIO, 0x26, __u64)
 
+#define VHOST_SET_RUNNING _IOW(VHOST_VIRTIO, 0x61, int)
+
 /* VHOST_NET specific defines */
 
 /* Attach virtio net ring to a raw socket, or tap device.
@@ -114,7 +116,7 @@
 /* VHOST_VSOCK specific defines */
 
 #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
-#define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
+#define VHOST_VSOCK_SET_RUNNING		VHOST_SET_RUNNING
 
 /* VHOST_VDPA specific defines */
 
-- 
1.9.3

