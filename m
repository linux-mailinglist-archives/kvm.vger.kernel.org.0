Return-Path: <kvm+bounces-30692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 259F99BC5C1
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:42:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 580BB1C20FC5
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CAC51FF031;
	Tue,  5 Nov 2024 06:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KPA27s+Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24941FE0F1
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788832; cv=none; b=F4ovdWgiM3zttEv+2Py7tYYGVXe6Jkw080SWmlp3qYKuDzEe/lH4eMd5FgY0Obv0iC26X+hoP2uBTihLpRqYdn5K1wv+1vVZ6XOanjLpFFGdM6xFl40qRL2W13IPV86x/ISrV7e/+uQAMhE6SzQYAYqueWG0X7HDaO/WX31aPqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788832; c=relaxed/simple;
	bh=Pfq6Mcq11nNik95S/q8D/VnbY9hYdtshEgdTuCa1i80=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QRM/OpUZOry0xEYoY3zDkLX1yC5GifUtqfi6+HL6xgmd82zmQJNf4deLX/8+osCAvnceK3aXk1X5+g0Tm1a8icsBvqgxHBLuVwxuH77FF5ZrGpT4+MsGpTLdO/R+RoaqB8aZPyruiSDW6VjeaRNKCIFTfwEyJWUmjA33HGOkSTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KPA27s+Z; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788831; x=1762324831;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Pfq6Mcq11nNik95S/q8D/VnbY9hYdtshEgdTuCa1i80=;
  b=KPA27s+Zs6pjKv7J8BiSeSaYLOmioxj8R2L/OgXCjpyChneRlVHoOl9V
   cW16UteI1WRahhxBjETxXv+DphfnS/KealIybN5unuUKioKPyKQtqcQar
   nJtrExiS4zHGRfbPsoVVYVcMC4GakYQPOjtD7Lw7qaXNe/PsAKfGlRPLN
   vzoOEvYclhctCah9x2UMPcrgtULFrgS/VQEzGw1hdA1+HpxX4atWBYv1D
   g5kbmNbTJTzlg8LdxYOORQVz6yGK0Sfne1bTMSPITeSFb2w3fElPZL08c
   Vfcat0DrTFYZeHOJhHmxUeiJaBwRn68cjXhChcllse/2qaX+Pjjk5PuQV
   w==;
X-CSE-ConnectionGUID: HwY+tuDCRlu4NBnmk8Utqw==
X-CSE-MsgGUID: 3BH4l/8NQMCe1vgBIPKLvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689953"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689953"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:40:31 -0800
X-CSE-ConnectionGUID: 1JcGSuUsQHiwhLm+UNgIxA==
X-CSE-MsgGUID: 7h2gpC2BS6GDQQ3w3SMvwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83990113"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:40:26 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 58/60] cpu: Introduce qemu_early_init_vcpu()
Date: Tue,  5 Nov 2024 01:24:06 -0500
Message-Id: <20241105062408.3533704-59-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently cpu->nr_cores and cpu->nr_threads are initialized in
qemu_init_vcpu(), which is called a bit late in *cpu_realizefn() for
each ARCHes.

x86 arch would like to set CPUID_HT in env->features[FEAT_1_EDX] based
on the value of cpu->nr_threads * cpu->nr_cores. It requires nr_cores
and nr_threads being initialized earlier.

Introdue qemu_early_init_vcpu() for this purpose.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/tcg/user-exec-stub.c | 4 ++++
 include/hw/core/cpu.h      | 8 ++++++++
 system/cpus.c              | 8 ++++++++
 3 files changed, 20 insertions(+)

diff --git a/accel/tcg/user-exec-stub.c b/accel/tcg/user-exec-stub.c
index 4fbe2dbdc883..64baf917b55c 100644
--- a/accel/tcg/user-exec-stub.c
+++ b/accel/tcg/user-exec-stub.c
@@ -10,6 +10,10 @@ void cpu_remove_sync(CPUState *cpu)
 {
 }
 
+void qemu_early_init_vcpu(CPUState *cpu)
+{
+}
+
 void qemu_init_vcpu(CPUState *cpu)
 {
 }
diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index c3ca0babcb3f..854b244e1ad6 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -1063,6 +1063,14 @@ void start_exclusive(void);
  */
 void end_exclusive(void);
 
+/**
+ * qemu_early_init_vcpu:
+ * @cpu: The vCPU to initialize.
+ *
+ * Early initializes a vCPU.
+ */
+void qemu_early_init_vcpu(CPUState *cpu);
+
 /**
  * qemu_init_vcpu:
  * @cpu: The vCPU to initialize.
diff --git a/system/cpus.c b/system/cpus.c
index 1c818ff6828c..98cb8aafa50b 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -662,6 +662,14 @@ const AccelOpsClass *cpus_get_accel(void)
     return cpus_accel;
 }
 
+void qemu_early_init_vcpu(CPUState *cpu)
+{
+    MachineState *ms = MACHINE(qdev_get_machine());
+
+    cpu->nr_cores = machine_topo_get_cores_per_socket(ms);
+    cpu->nr_threads =  ms->smp.threads;
+}
+
 void qemu_init_vcpu(CPUState *cpu)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
-- 
2.34.1


