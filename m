Return-Path: <kvm+bounces-65144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 818A9C9C1CC
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:08:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 278BF34A95E
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A25E287503;
	Tue,  2 Dec 2025 16:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jHPEYUrk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15680279792
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691630; cv=none; b=kyLIg5RdBYXiEg4mwySPEjvL7PK6i8n3MBOsypVkDqMViQUEyR+pWI1Jj6nOfXwpyTenBzJL7ZckTzWP1n1pXhBBbGszv+oK8Ga6tvzXcD9nddhFng3LqfOWRPKAXF/prb2U9+q/tXzERIt8R9xyIMenAoCpjLGUleoiysnL2/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691630; c=relaxed/simple;
	bh=89F41mSOuYhugFJj7jF488k0MReP/Q9Ed85C0vFns40=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gmLsjHR1bm7in4A1Wwv2MIhUsPBj1awK36xIu2OZRoir4Pgp64j8iiN+IwUR3mXj1jnVR+gkTS68LCEMvbg9QvFBTlod4XKzcdG4FfoQ9af/s7j0h4rYn1gLRk2Yh7l/s1i3xO6besd4XOxH5yZwkb3dtWUf9gsSGz7g8O0ZbTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jHPEYUrk; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691629; x=1796227629;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=89F41mSOuYhugFJj7jF488k0MReP/Q9Ed85C0vFns40=;
  b=jHPEYUrkBst0Yh9vy993TlOiqAnInyKnfDvbVA7xKPnYdqwQn+T9ntRK
   wCuRxI9ztTxzuH4+7exHrsHeup6ZAd1/xZdmEEmXQgLHUBGX8BjTZizHu
   Eze2Zylbd2nqD78O2qhTPv6825PVofM6pNypKp1aB9wcWP5w71l9Jc1yQ
   9MX6TiNcnPYEmGrYfBE8XfhbgkfM9M09olKChIXGXkvruX9COL7+RK4oJ
   Uv3utdD7BQ9s8mJ5rpxo39mSc7RixA53ofGea7Q8fCcwHIgbu8iY+QW2E
   ClVm7TXSh/svvNmwYs1bX5ZZfPTSVQyZyJkZ3qJTIT2NhximwlL5KzQub
   g==;
X-CSE-ConnectionGUID: phAjRg8dQxuUP/rU9InWWQ==
X-CSE-MsgGUID: Ik7mcwSaTPKWWfpmYOJwig==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="92142854"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="92142854"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:07:08 -0800
X-CSE-ConnectionGUID: chFndAIkR6Gryt9wY9xekA==
X-CSE-MsgGUID: cqcEw527TwmS1tzvB+S+yA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="199537786"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 02 Dec 2025 08:06:59 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Thomas Huth <thuth@redhat.com>
Cc: qemu-devel@nongnu.org,
	devel@lists.libvirt.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Peter Krempa <pkrempa@redhat.com>,
	Jiri Denemark <jdenemar@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 20/28] hw/virtio/virtio-mmio: Remove VirtIOMMIOProxy::format_transport_address field
Date: Wed,  3 Dec 2025 00:28:27 +0800
Message-Id: <20251202162835.3227894-21-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251202162835.3227894-1-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Philippe Mathieu-Daudé <philmd@linaro.org>

The VirtIOMMIOProxy::format_transport_address boolean was only set
in the hw_compat_2_6[] array, via the 'format_transport_address=off'
property. We removed all machines using that array, lets remove
that property, simplifying virtio_mmio_bus_get_dev_path().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/virtio/virtio-mmio.c         | 15 ---------------
 include/hw/virtio/virtio-mmio.h |  1 -
 2 files changed, 16 deletions(-)

diff --git a/hw/virtio/virtio-mmio.c b/hw/virtio/virtio-mmio.c
index c05c00bcd4a7..c779836201d5 100644
--- a/hw/virtio/virtio-mmio.c
+++ b/hw/virtio/virtio-mmio.c
@@ -764,8 +764,6 @@ static void virtio_mmio_pre_plugged(DeviceState *d, Error **errp)
 /* virtio-mmio device */
 
 static const Property virtio_mmio_properties[] = {
-    DEFINE_PROP_BOOL("format_transport_address", VirtIOMMIOProxy,
-                     format_transport_address, true),
     DEFINE_PROP_BOOL("force-legacy", VirtIOMMIOProxy, legacy, true),
     DEFINE_PROP_BIT("ioeventfd", VirtIOMMIOProxy, flags,
                     VIRTIO_IOMMIO_FLAG_USE_IOEVENTFD_BIT, true),
@@ -827,19 +825,6 @@ static char *virtio_mmio_bus_get_dev_path(DeviceState *dev)
     virtio_mmio_proxy = VIRTIO_MMIO(virtio_mmio_bus->parent);
     proxy_path = qdev_get_dev_path(DEVICE(virtio_mmio_proxy));
 
-    /*
-     * If @format_transport_address is false, then we just perform the same as
-     * virtio_bus_get_dev_path(): we delegate the address formatting for the
-     * device on the virtio-mmio bus to the bus that the virtio-mmio proxy
-     * (i.e., the device that implements the virtio-mmio bus) resides on. In
-     * this case the base address of the virtio-mmio transport will be
-     * invisible.
-     */
-    if (!virtio_mmio_proxy->format_transport_address) {
-        return proxy_path;
-    }
-
-    /* Otherwise, we append the base address of the transport. */
     section = memory_region_find(&virtio_mmio_proxy->iomem, 0, 0x200);
     assert(section.mr);
 
diff --git a/include/hw/virtio/virtio-mmio.h b/include/hw/virtio/virtio-mmio.h
index aa492620228d..8b19ec2291ac 100644
--- a/include/hw/virtio/virtio-mmio.h
+++ b/include/hw/virtio/virtio-mmio.h
@@ -66,7 +66,6 @@ struct VirtIOMMIOProxy {
     uint32_t guest_page_shift;
     /* virtio-bus */
     VirtioBusState bus;
-    bool format_transport_address;
     /* Fields only used for non-legacy (v2) devices */
     uint32_t guest_features[2];
     VirtIOMMIOQueue vqs[VIRTIO_QUEUE_MAX];
-- 
2.34.1


