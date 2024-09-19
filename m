Return-Path: <kvm+bounces-27160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05FF797C3FA
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 07:56:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0C3B28374F
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 05:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC36D131BDF;
	Thu, 19 Sep 2024 05:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n9swSznh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667CA6A039
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 05:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726725360; cv=none; b=AkEa4rvtMLXNgUxBTBctGJe8Rgts8dRa4I0BUhuSprB7r8Ax4FaO11Qwdo9F6P+0sK0OfjBV3UYsm4e6mWM8I8ZkD8KAdRb+vaqhjUzW9V67bMYuzO59Pn4NFQBV2kgQ76xB4HBOqApcD0RkktxYiou88QWdpFu9loC8A2876LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726725360; c=relaxed/simple;
	bh=T5fYW0Qp5HK4dCgA8zTvCnqjoH/YS2wAEp4x5hqFcPU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DvpuzeKQiJ/k9vBQ9E5jJVMCMPPj5DfN52LUTWGzsdCbgreMB0nL4nirh010hRMg7TZYUkXohpFSDwckzbMLiwYA27gzF/N9pR9Qsm0WP1TpCy07/JJwdnwa8i74/gc2JIv4LiisSTfSF19LIP9fZKt8a7rgDuJGomcYwe0dbFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n9swSznh; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726725360; x=1758261360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T5fYW0Qp5HK4dCgA8zTvCnqjoH/YS2wAEp4x5hqFcPU=;
  b=n9swSznhF5tss+LnCfOixIZf8mpPulWp1bF4Jdydi2KjPRNgBsGLOsaa
   bub14GVdZHi049zc5Va4bJew4EAvFtFEOly6JAVwsN/vv7N1ONyAOk7SZ
   2K+RPcOvd1IhLE6EMKA0v3+HWqCpDaqI6KE3e5QxNWN6fkeHm1imYI04S
   0H33uEguFmAITwRXqCarACnL+PGWQaEaA4jf7YznFkS0+BxnCi1zhxi2F
   empKOAtgnqbO1ez7yMOdUTEOmfJtjuucDvGGqPARpoP/ecy8jRKbQOZYa
   90H9hXsLR8mz1kkZoGjXCOSLgnjEa6/1cDpZVxJaf4CDPMwLC6XdHy5tm
   g==;
X-CSE-ConnectionGUID: Lnig9UboTDSCY/Uz8DWITw==
X-CSE-MsgGUID: EHc97fGOTsmmqL9r36NYQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25813532"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25813532"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 22:55:55 -0700
X-CSE-ConnectionGUID: izHbtgFiQeKuhayuq/BgHg==
X-CSE-MsgGUID: 8GpqZCUxQfG5uQ4iHEKGyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="69418665"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 18 Sep 2024 22:55:49 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 04/12] hw/core/machine: Split machine initialization around qemu_add_cli_devices_early()
Date: Thu, 19 Sep 2024 14:11:20 +0800
Message-Id: <20240919061128.769139-5-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240919061128.769139-1-zhao1.liu@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Split machine initialization and machine_run_board_init() into two parts
around qemu_add_cli_devices_early(), allowing initialization to continue
after the CPU creation from the CLI.

This enables machine to place the initialization steps with CPU
dependencies in post_init().

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/machine.c   | 10 ++++++++++
 include/hw/boards.h |  2 ++
 system/vl.c         |  4 +++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 076bd365197b..7b4ac5ac52b2 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -1645,6 +1645,16 @@ void machine_run_board_init(MachineState *machine, const char *mem_path, Error *
 
     accel_init_interfaces(ACCEL_GET_CLASS(machine->accelerator));
     machine_class->init(machine);
+}
+
+void machine_run_board_post_init(MachineState *machine, Error **errp)
+{
+    MachineClass *machine_class = MACHINE_GET_CLASS(machine);
+
+    if (machine_class->post_init) {
+        machine_class->post_init(machine);
+    }
+
     phase_advance(PHASE_MACHINE_INITIALIZED);
 }
 
diff --git a/include/hw/boards.h b/include/hw/boards.h
index a49677466ef6..9f706223e848 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -33,6 +33,7 @@ const char *machine_class_default_cpu_type(MachineClass *mc);
 
 void machine_add_audiodev_property(MachineClass *mc);
 void machine_run_board_init(MachineState *machine, const char *mem_path, Error **errp);
+void machine_run_board_post_init(MachineState *machine, Error **errp);
 bool machine_usb(MachineState *machine);
 int machine_phandle_start(MachineState *machine);
 bool machine_dump_guest_core(MachineState *machine);
@@ -271,6 +272,7 @@ struct MachineClass {
     const char *deprecation_reason;
 
     void (*init)(MachineState *state);
+    void (*post_init)(MachineState *state);
     void (*reset)(MachineState *state, ShutdownCause reason);
     void (*wakeup)(MachineState *state);
     int (*kvm_type)(MachineState *machine, const char *arg);
diff --git a/system/vl.c b/system/vl.c
index 8540454aa1c2..00370f7a52aa 100644
--- a/system/vl.c
+++ b/system/vl.c
@@ -2659,12 +2659,14 @@ static void qemu_init_board(void)
     /* process plugin before CPUs are created, but once -smp has been parsed */
     qemu_plugin_load_list(&plugin_list, &error_fatal);
 
-    /* From here on we enter MACHINE_PHASE_INITIALIZED.  */
     machine_run_board_init(current_machine, mem_path, &error_fatal);
 
     /* Create CPU topology device if any. */
     qemu_add_cli_devices_early();
 
+    /* From here on we enter MACHINE_PHASE_INITIALIZED.  */
+    machine_run_board_post_init(current_machine, &error_fatal);
+
     drive_check_orphaned();
 
     realtime_init();
-- 
2.34.1


