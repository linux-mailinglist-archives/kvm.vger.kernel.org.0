Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119D067E3D4
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbjA0Lmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbjA0LmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:42:00 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3586270D7E;
        Fri, 27 Jan 2023 03:41:28 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06657176A;
        Fri, 27 Jan 2023 03:41:45 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7CD023F64C;
        Fri, 27 Jan 2023 03:41:00 -0800 (PST)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     suzuki.poulose@arm.com,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, linux-coco@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC kvmtool 26/31] virtio: Add a wrapper for get_host_features
Date:   Fri, 27 Jan 2023 11:39:27 +0000
Message-Id: <20230127113932.166089-27-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127113932.166089-1-suzuki.poulose@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127113932.166089-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a wrapper to the vdev->ops->get_host_features() to allow
setting platform specific flags outside the device

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 include/kvm/virtio.h | 2 ++
 virtio/core.c        | 5 +++++
 virtio/mmio-legacy.c | 2 +-
 virtio/mmio-modern.c | 2 +-
 virtio/pci-legacy.c  | 2 +-
 virtio/pci-modern.c  | 2 +-
 6 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 94bddefe..e95cfad5 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -248,4 +248,6 @@ void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
 void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
 			  void *dev, u8 status);
 
+u64 virtio_dev_get_host_features(struct virtio_device *vdev, struct kvm *kvm, void *dev);
+
 #endif /* KVM__VIRTIO_H */
diff --git a/virtio/core.c b/virtio/core.c
index ea0e5b65..50e7f86d 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -283,6 +283,11 @@ void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
 		vdev->ops->notify_status(kvm, dev, ext_status);
 }
 
+u64 virtio_dev_get_host_features(struct virtio_device *vdev, struct kvm *kvm, void *dev)
+{
+	return vdev->ops->get_host_features(kvm, dev);
+}
+
 bool virtio_access_config(struct kvm *kvm, struct virtio_device *vdev,
 			  void *dev, unsigned long offset, void *data,
 			  size_t size, bool is_write)
diff --git a/virtio/mmio-legacy.c b/virtio/mmio-legacy.c
index 7ca7e69f..42673236 100644
--- a/virtio/mmio-legacy.c
+++ b/virtio/mmio-legacy.c
@@ -26,7 +26,7 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
 		break;
 	case VIRTIO_MMIO_DEVICE_FEATURES:
 		if (vmmio->hdr.host_features_sel == 0)
-			val = vdev->ops->get_host_features(vmmio->kvm,
+			val = virtio_dev_get_host_features(vdev, vmmio->kvm,
 							   vmmio->dev);
 		ioport__write32(data, val);
 		break;
diff --git a/virtio/mmio-modern.c b/virtio/mmio-modern.c
index 6c0bb382..a09fa8e9 100644
--- a/virtio/mmio-modern.c
+++ b/virtio/mmio-modern.c
@@ -26,7 +26,7 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
 	case VIRTIO_MMIO_DEVICE_FEATURES:
 		if (vmmio->hdr.host_features_sel > 1)
 			break;
-		features |= vdev->ops->get_host_features(vmmio->kvm, vmmio->dev);
+		features |= virtio_dev_get_host_features(vdev, vmmio->kvm, vmmio->dev);
 		val = features >> (32 * vmmio->hdr.host_features_sel);
 		break;
 	case VIRTIO_MMIO_QUEUE_NUM_MAX:
diff --git a/virtio/pci-legacy.c b/virtio/pci-legacy.c
index 58047967..d5f5dee7 100644
--- a/virtio/pci-legacy.c
+++ b/virtio/pci-legacy.c
@@ -44,7 +44,7 @@ static bool virtio_pci__data_in(struct kvm_cpu *vcpu, struct virtio_device *vdev
 
 	switch (offset) {
 	case VIRTIO_PCI_HOST_FEATURES:
-		val = vdev->ops->get_host_features(kvm, vpci->dev);
+		val = virtio_dev_get_host_features(vdev, kvm, vpci->dev);
 		ioport__write32(data, val);
 		break;
 	case VIRTIO_PCI_QUEUE_PFN:
diff --git a/virtio/pci-modern.c b/virtio/pci-modern.c
index c5b4bc50..2c5bf3f8 100644
--- a/virtio/pci-modern.c
+++ b/virtio/pci-modern.c
@@ -158,7 +158,7 @@ static bool virtio_pci__common_read(struct virtio_device *vdev,
 	case VIRTIO_PCI_COMMON_DF:
 		if (vpci->device_features_sel > 1)
 			break;
-		features |= vdev->ops->get_host_features(vpci->kvm, vpci->dev);
+		features |= virtio_dev_get_host_features(vdev, vpci->kvm, vpci->dev);
 		val = features >> (32 * vpci->device_features_sel);
 		ioport__write32(data, val);
 		break;
-- 
2.34.1

