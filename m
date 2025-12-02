Return-Path: <kvm+bounces-65152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id F3713C9C211
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:10:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CA7E04E471B
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4949B29BDAB;
	Tue,  2 Dec 2025 16:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f22qVNom"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0108D29B77C
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691704; cv=none; b=dz1HZsuC2L0gfJFWzM68H5qKYWg1ekBr/Wqv81dZAPDQA2Y+Ex6gGVc8UwDNVXX+pt4g8nVhP81S4vxPqMe+KfUdQ3mxwkaBGnUcpZYEpUOXAZ0nJdz13ON5y7kuLWgKvd8TVMyMyC7m+20GgFRI5/HtKTyqXQj9R4qixfogPeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691704; c=relaxed/simple;
	bh=jqtFvxj+10vNXec+3ARQzdivBUizNnzSIyg2+TGZekw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NdN2/KQCw7CgefzuzAMC9we8ZhSgM/y9Kn4QTTwZykjafOvEY5wQVZYoHGNATu3t8+qyeLu31i0TitpK62VQxHbO33xb443Dr3e0/aHOXvZDk9tI2pW6yer7TScylsNtC0/eDeIWWo7tJ4+w52hvqEGjqEEphXzGqCfaR9wQ0DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f22qVNom; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691703; x=1796227703;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jqtFvxj+10vNXec+3ARQzdivBUizNnzSIyg2+TGZekw=;
  b=f22qVNomdN8Rgi1DliL3AfDj7xht9qAZ0sWJVxF7mdJefwBAvzaOgwQJ
   uT5qGBPjCwCyVTBH/Jy3ajXh9S+Rj+4wXeXkuyC8zoehNk+wKy2IDnOaw
   5eaKNwrDsFcUC+pql13BjhOiYwY6sFYb+/gEXrbKi2Xxia1r0OE+LrF8i
   R8RAT0cAaGwcVth8BXxWDEg9sgQ2W6TRdOqbr1/N27lGC6e56CrsMl4Uo
   1KXM8mGTUR+0j2ekpU3KgvusGjue+brcFE/FX5jhuEwrjETFZzwWXqGbP
   0psth6LtH9LMY4cXvcUY4/f0U48sypz5BHqSceiEDtkEnkVUHlRsNwudY
   A==;
X-CSE-ConnectionGUID: ZRhPpdFZThCoazhwXfaWgA==
X-CSE-MsgGUID: NEXHMma7QMyeqJiTTZrW5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="92143172"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="92143172"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:08:22 -0800
X-CSE-ConnectionGUID: SjU4LmDdQTiDLSlfpBYPSQ==
X-CSE-MsgGUID: ZAw4+8F8SNSUfxJX7KFWXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="199538081"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 02 Dec 2025 08:08:13 -0800
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
Subject: [PATCH v5 28/28] hw/char/virtio-serial: Do not expose the 'emergency-write' property
Date: Wed,  3 Dec 2025 00:28:35 +0800
Message-Id: <20251202162835.3227894-29-zhao1.liu@intel.com>
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

The VIRTIO_CONSOLE_F_EMERG_WRITE feature bit was only set
in the hw_compat_2_7[] array, via the 'emergency-write=off'
property. We removed all machines using that array, lets remove
that property. All instances have this feature bit set and
it can not be disabled. VirtIOSerial::host_features mask is
now unused, remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/char/virtio-serial-bus.c       | 9 +++------
 include/hw/virtio/virtio-serial.h | 2 --
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/hw/char/virtio-serial-bus.c b/hw/char/virtio-serial-bus.c
index 673c50f0be08..7abb7b5e31bf 100644
--- a/hw/char/virtio-serial-bus.c
+++ b/hw/char/virtio-serial-bus.c
@@ -557,7 +557,7 @@ static uint64_t get_features(VirtIODevice *vdev, uint64_t features,
 
     vser = VIRTIO_SERIAL(vdev);
 
-    features |= vser->host_features;
+    features |= BIT_ULL(VIRTIO_CONSOLE_F_EMERG_WRITE);
     if (vser->bus.max_nr_ports > 1) {
         virtio_add_feature(&features, VIRTIO_CONSOLE_F_MULTIPORT);
     }
@@ -587,8 +587,7 @@ static void set_config(VirtIODevice *vdev, const uint8_t *config_data)
     VirtIOSerialPortClass *vsc;
     uint8_t emerg_wr_lo;
 
-    if (!virtio_has_feature(vser->host_features,
-        VIRTIO_CONSOLE_F_EMERG_WRITE) || !config->emerg_wr) {
+    if (!config->emerg_wr) {
         return;
     }
 
@@ -1040,7 +1039,7 @@ static void virtio_serial_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    if (!virtio_has_feature(vser->host_features,
+    if (!virtio_has_feature(vdev->host_features,
                             VIRTIO_CONSOLE_F_EMERG_WRITE)) {
         config_size = offsetof(struct virtio_console_config, emerg_wr);
     }
@@ -1156,8 +1155,6 @@ static const VMStateDescription vmstate_virtio_console = {
 static const Property virtio_serial_properties[] = {
     DEFINE_PROP_UINT32("max_ports", VirtIOSerial, serial.max_virtserial_ports,
                                                   31),
-    DEFINE_PROP_BIT64("emergency-write", VirtIOSerial, host_features,
-                      VIRTIO_CONSOLE_F_EMERG_WRITE, true),
 };
 
 static void virtio_serial_class_init(ObjectClass *klass, const void *data)
diff --git a/include/hw/virtio/virtio-serial.h b/include/hw/virtio/virtio-serial.h
index 60641860bf83..da0c91e1a403 100644
--- a/include/hw/virtio/virtio-serial.h
+++ b/include/hw/virtio/virtio-serial.h
@@ -186,8 +186,6 @@ struct VirtIOSerial {
     struct VirtIOSerialPostLoad *post_load;
 
     virtio_serial_conf serial;
-
-    uint64_t host_features;
 };
 
 /* Interface to the virtio-serial bus */
-- 
2.34.1


