Return-Path: <kvm+bounces-67321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BA66D00C84
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 04:07:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 70D373017644
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 03:06:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49AAA276038;
	Thu,  8 Jan 2026 03:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bxi32duK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74BC277013
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 03:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767841595; cv=none; b=GMRRu3tUvBFh/b40digJ+JteKFOKzQte4Ztnc/zMz6ElviSvpAKUR/L2EnkTeahosH95r4wO3wusEGRsQdAyrZ20PkjcoLxaNdqjfwkmyibEuq61QWWX5W3SocZ7N4AsMXFS/NViV7MXA+IRHc11qDvqqB3ehqNoL5JhEz56cCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767841595; c=relaxed/simple;
	bh=ELgJcv3mEZ+O8nlcj6D4atKRvgJj+dX2pFI7N//FqfA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VXBfB46QpAswAjJYuDedxIb0rJz0qSMYjXu5UxaCJfq1lNm/n5pFf+Ww9hO1A2Ym7uqQBTvUr8uD1vFci0i/1jre2UeJYH0ymlaRwvPkx7qQ2iznDgeQS5kkoTLxcM2gbgVJbm3o/F8qw7A654C3jy+ahmQNaUEBdwoYGw+/Too=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bxi32duK; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767841594; x=1799377594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ELgJcv3mEZ+O8nlcj6D4atKRvgJj+dX2pFI7N//FqfA=;
  b=bxi32duK3SXMTsF1hG2HdPPzGvdLbLMli6dFDTKFoL1uTHJzp5G7hKu1
   Yhy051l2MTsCd+aECFGfSNeGBBP9W7NczEnuT6tuJU1hwYh704zCAOeVN
   YKRWU28e9BJKELDda5BJyChchrewCKJgIuHnx8Hj7rV0DYuA11XNzeTcW
   4aUWKWuEPKjpbLPR0Eij4cP74EHBCdo/0pSNpgeleY0PPhz6P6QU5mkXA
   vEnTpPyZGudvV5W3cliFIOtteuIr5Coheuil/fjrY/KJegnoiMTZYlcls
   icFnl/P8usgX3jJGl9qbYiWdIt7TGkZxzTWKZuKr3p30H+mkZ8MTawhiU
   Q==;
X-CSE-ConnectionGUID: iGaJk57MRxKn2PxazflYCQ==
X-CSE-MsgGUID: G23TiCByRuKuBeKKy2+/EA==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="91877065"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="91877065"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 19:06:34 -0800
X-CSE-ConnectionGUID: ysNjkMk7Qa2NK3bUI/dGfg==
X-CSE-MsgGUID: 5ZJVjVQ3SiySuCabFlUuFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="202210652"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa006.jf.intel.com with ESMTP; 07 Jan 2026 19:06:24 -0800
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
Subject: [PATCH v6 06/27] docs/specs/acpi_cpu_hotplug: Remove legacy cpu hotplug descriptions
Date: Thu,  8 Jan 2026 11:30:30 +0800
Message-Id: <20260108033051.777361-7-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260108033051.777361-1-zhao1.liu@intel.com>
References: <20260108033051.777361-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Legacy cpu hotplug has been removed totally and machines start with
modern cpu hotplug interface directly.

Therefore, update the documentation to describe current QEMU cpu hotplug
logic.

Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v4:
 * New patch.
---
 docs/specs/acpi_cpu_hotplug.rst | 28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff --git a/docs/specs/acpi_cpu_hotplug.rst b/docs/specs/acpi_cpu_hotplug.rst
index 351057c96761..f49678100044 100644
--- a/docs/specs/acpi_cpu_hotplug.rst
+++ b/docs/specs/acpi_cpu_hotplug.rst
@@ -8,22 +8,6 @@ ACPI BIOS GPE.2 handler is dedicated for notifying OS about CPU hot-add
 and hot-remove events.
 
 
-Legacy ACPI CPU hotplug interface registers
--------------------------------------------
-
-CPU present bitmap for:
-
-- ICH9-LPC (IO port 0x0cd8-0xcf7, 1-byte access)
-- PIIX-PM  (IO port 0xaf00-0xaf1f, 1-byte access)
-- One bit per CPU. Bit position reflects corresponding CPU APIC ID. Read-only.
-- The first DWORD in bitmap is used in write mode to switch from legacy
-  to modern CPU hotplug interface, write 0 into it to do switch.
-
-QEMU sets corresponding CPU bit on hot-add event and issues SCI
-with GPE.2 event set. CPU present map is read by ACPI BIOS GPE.2 handler
-to notify OS about CPU hot-add events. CPU hot-remove isn't supported.
-
-
 Modern ACPI CPU hotplug interface registers
 -------------------------------------------
 
@@ -189,20 +173,14 @@ Typical usecases
 (x86) Detecting and enabling modern CPU hotplug interface
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-QEMU starts with legacy CPU hotplug interface enabled. Detecting and
-switching to modern interface is based on the 2 legacy CPU hotplug features:
-
-#. Writes into CPU bitmap are ignored.
-#. CPU bitmap always has bit #0 set, corresponding to boot CPU.
-
-Use following steps to detect and enable modern CPU hotplug interface:
+QEMU starts with modern CPU hotplug interface enabled. Use following steps to
+detect modern CPU hotplug interface:
 
-#. Store 0x0 to the 'CPU selector' register, attempting to switch to modern mode
 #. Store 0x0 to the 'CPU selector' register, to ensure valid selector value
 #. Store 0x0 to the 'Command field' register
 #. Read the 'Command data 2' register.
    If read value is 0x0, the modern interface is enabled.
-   Otherwise legacy or no CPU hotplug interface available
+   Otherwise no CPU hotplug interface available
 
 Get a cpu with pending event
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- 
2.34.1


