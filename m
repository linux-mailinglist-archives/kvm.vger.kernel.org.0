Return-Path: <kvm+bounces-65149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 48F2AC9C1E4
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:09:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 88B1734996C
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E7BB2874FB;
	Tue,  2 Dec 2025 16:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TD/CYP4w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5742367D5
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691677; cv=none; b=P9dwaSHX0SIlHdB4yMtty3Q9/G4s2oPGdrzK1v7q1VgFvi6N3ufRuIx4ro29kFEQXvfR5yK75UjXuMytw3AAPsM2STQbHUmgMNI6qhq12759z7ws/CnJaLLMdLyDUYgx6/K202qs00QHVu3xghYKbvm8nL1hUUDVg7YnHTOUfCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691677; c=relaxed/simple;
	bh=5aMN8j2k0jbBB+u6F2rOOGgMnpKfY0T/yj0eYFmhIkQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oQSV4WIJqs3KUyb4aANHxF9DsCXi+0fhF3o22OeQBrmXPGvwFjE04KXECI44SWiHFfK+q57vk3vLt9eGCDr56zsUtgokZkcZhOylsYmsZe9rVEK3quDD1iWYIh45d/6+fBnGvPVwdu5B1/9Fa2jERhzOoLt1/ZaQdro5NDhEKx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TD/CYP4w; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691676; x=1796227676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5aMN8j2k0jbBB+u6F2rOOGgMnpKfY0T/yj0eYFmhIkQ=;
  b=TD/CYP4w/bKDf9NO6olsqRtOWElvR0A4NgSzgZxZBwzRoym9SYY+rZpU
   dXXVK+nQIddUHHqTy6C7th1B4/s/iPwjHPH2IilDcrZ3+zYasXr9T+UYt
   Ju/mSfZ7W2b7ammyA9xRTmowy7C8KDfwgrGvVdframAf6DQ2ycoPRfAjH
   6nyX8K4Cn8SjnqJIh4IgkQqM36KW5zoNfXiDZVp90xlFaCrlpFN9h3El/
   YUjpE4sasLP/tNqNPmjkRVSDdDlQqrigD61yNwIWidd4D3YZkJkWJue+w
   F/56h3YJgaWuTIndGSaTsWO1wP0wFj1lA6YBEe8GMm23TYQAdtpt4kDJZ
   w==;
X-CSE-ConnectionGUID: HS3lF3FNQxiWL7dgmqM1Hw==
X-CSE-MsgGUID: l3dn6Sw8Q6eaaaIVVoRhuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="92143084"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="92143084"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:07:55 -0800
X-CSE-ConnectionGUID: 2B2P08tKQPuT42NQAFVwrA==
X-CSE-MsgGUID: FBX7bwLTQCK847S3QDva3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="199537963"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 02 Dec 2025 08:07:46 -0800
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
Subject: [PATCH v5 25/28] hw/core/machine: Remove hw_compat_2_7[] array
Date: Wed,  3 Dec 2025 00:28:32 +0800
Message-Id: <20251202162835.3227894-26-zhao1.liu@intel.com>
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

The hw_compat_2_7[] array was only used by the pc-q35-2.7 and
pc-i440fx-2.7 machines, which got removed. Remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/machine.c   | 9 ---------
 include/hw/boards.h | 3 ---
 2 files changed, 12 deletions(-)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 0b10adb5d538..f3e9346965c3 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -281,15 +281,6 @@ GlobalProperty hw_compat_2_8[] = {
 };
 const size_t hw_compat_2_8_len = G_N_ELEMENTS(hw_compat_2_8);
 
-GlobalProperty hw_compat_2_7[] = {
-    { "virtio-pci", "page-per-vq", "on" },
-    { "virtio-serial-device", "emergency-write", "off" },
-    { "ioapic", "version", "0x11" },
-    { "intel-iommu", "x-buggy-eim", "true" },
-    { "virtio-pci", "x-ignore-backend-features", "on" },
-};
-const size_t hw_compat_2_7_len = G_N_ELEMENTS(hw_compat_2_7);
-
 MachineState *current_machine;
 
 static char *machine_get_kernel(Object *obj, Error **errp)
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 5ddadbfd8a83..83b78b35f2bf 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -879,7 +879,4 @@ extern const size_t hw_compat_2_9_len;
 extern GlobalProperty hw_compat_2_8[];
 extern const size_t hw_compat_2_8_len;
 
-extern GlobalProperty hw_compat_2_7[];
-extern const size_t hw_compat_2_7_len;
-
 #endif
-- 
2.34.1


