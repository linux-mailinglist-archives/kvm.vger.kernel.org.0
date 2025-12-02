Return-Path: <kvm+bounces-65141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B44C9C1C0
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:08:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0C7EE349C18
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73DA4280A51;
	Tue,  2 Dec 2025 16:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HM5G0QNY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB62279907
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691603; cv=none; b=gNHw8fPbaliMWJ9vPM9hZg+7hskrXXZtLI4VJ/pleGFDTUpC2gbppds4Psi3Zs9Pl4nZiF+8XmNuXZ/9GVFeW662r5/CqDGQZbX5rzTeP7+/P1uGy8sf2uzwrWICVKsAdPiehLqJky9GAZ0udmo98kMg4FOMj8XUYrDriq9akyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691603; c=relaxed/simple;
	bh=z9VLCU2KIJ73gEsKU4uszkkYOzFWVjXDHPrGQQWvjSM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bLfY6VCnLrc6gqE+scjM7BbNp50PCzNmTl2H+kQbBTt5ASEljpBRVsFBpRDieByypgN41wSVh5WvyFSLhhGNGJz+8OB4lJFnG85RzVz7YntDM/kS2n0nyQHV/ZFM2dbeDkvg9cyajUpQvd+NhCljbZsTSXp2aL/TzAMPu+UETU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HM5G0QNY; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691602; x=1796227602;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z9VLCU2KIJ73gEsKU4uszkkYOzFWVjXDHPrGQQWvjSM=;
  b=HM5G0QNYZJ7HWzXvG8ikpjWIqwDgPLdDMjj8rwHFs+OvsfjrCO1IwpaC
   a5CMbhv/JRdc/UBmNroYmfiO3E5Ip3nAaNiirmVN0QIq4ZE8TDI11Qsca
   sGacKc0zAhANLljyst14LC+gRTxJaCW/siDKlWJ0hkSg/dv8h9UtYmOna
   U/eDAIAGYLwDwVTRdh64v/fMzD8882kjniw9C5ftIbsRvLsevvvm/Oqr4
   JI9yXeUCt4x2HjPuM9DT7NRiuTYtDw79WK+yCC6lUAoL/cyUJ9W4UKKNe
   MESIaRA8vfZVjnBxLIaNAJt4e3zhzB3ZXtqov6yq3ik4jCotDPbv4Xjam
   A==;
X-CSE-ConnectionGUID: /zKHTI3dSuqZRnupg6nMEA==
X-CSE-MsgGUID: aCbBW6A3SO26c8BbENYb7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="92142782"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="92142782"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:06:42 -0800
X-CSE-ConnectionGUID: 2j5JuVBZTAeRDCmPvwAmpA==
X-CSE-MsgGUID: hNxNIjIcTkud57qFIj5A1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="199537677"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 02 Dec 2025 08:06:32 -0800
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
Subject: [PATCH v5 17/28] hw/i386/pc: Remove pc_compat_2_6[] array
Date: Wed,  3 Dec 2025 00:28:24 +0800
Message-Id: <20251202162835.3227894-18-zhao1.liu@intel.com>
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

The pc_compat_2_6[] array was only used by the pc-q35-2.6
and pc-i440fx-2.6 machines, which got removed. Remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/pc.c         | 8 --------
 include/hw/i386/pc.h | 3 ---
 2 files changed, 11 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 2e315414aeaf..85d12f8d0389 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -263,14 +263,6 @@ GlobalProperty pc_compat_2_7[] = {
 };
 const size_t pc_compat_2_7_len = G_N_ELEMENTS(pc_compat_2_7);
 
-GlobalProperty pc_compat_2_6[] = {
-    { TYPE_X86_CPU, "cpuid-0xb", "off" },
-    { "vmxnet3", "romfile", "" },
-    { TYPE_X86_CPU, "fill-mtrr-mask", "off" },
-    { "apic-common", "legacy-instance-id", "on", }
-};
-const size_t pc_compat_2_6_len = G_N_ELEMENTS(pc_compat_2_6);
-
 /*
  * @PC_FW_DATA:
  * Size of the chunk of memory at the top of RAM for the BIOS ACPI tables
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 698e3fb84af0..f8f317aee197 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -295,9 +295,6 @@ extern const size_t pc_compat_2_8_len;
 extern GlobalProperty pc_compat_2_7[];
 extern const size_t pc_compat_2_7_len;
 
-extern GlobalProperty pc_compat_2_6[];
-extern const size_t pc_compat_2_6_len;
-
 #define DEFINE_PC_MACHINE(suffix, namestr, initfn, optsfn) \
     static void pc_machine_##suffix##_class_init(ObjectClass *oc, \
                                                  const void *data) \
-- 
2.34.1


