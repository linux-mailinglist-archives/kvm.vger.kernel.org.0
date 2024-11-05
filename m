Return-Path: <kvm+bounces-30641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1C989BC57E
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67F331F21EAB
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B73A91FDFA1;
	Tue,  5 Nov 2024 06:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lEcwwHWs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AE21F708B
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788613; cv=none; b=nprM0fyg/wpo300shuTSCsZeAqMI3o/cUMfPJqCPIdQt04G5a3l/hmsMOcL+jIEbLXFgYMjP1Xkq6zvsqwHbugaFYmiM05wY8YonQrvQ/5SZsrrZkUYHrc6sI7wuZsXcc1gIl0DJyxTL+OCn8SUbMwPfE3CgXefqu/AixnvH0Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788613; c=relaxed/simple;
	bh=A6C88ZryYnZ5BmBKN8njc0C6s0vxQGqEOftEOyDrLG0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C/hTQ9mv9rUxInnnJNXBA9mc3Jm7+QUS+qAEKbM3HW63g4b+3B8D8BrkZi/SA7uhvgoKPUZCjK8B50/tiEgYJELqMwXM1UM9+diTw1sSb67rOsAnVV9Ve5MaWCdG4Uwf7KCZpzgye9XE//MW03DsCR6zZjblw0PEiv2p9BLlVJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lEcwwHWs; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788611; x=1762324611;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A6C88ZryYnZ5BmBKN8njc0C6s0vxQGqEOftEOyDrLG0=;
  b=lEcwwHWsd8uvqVi7Cj8HmQ0A7j7MSY3gGeaFRK/lcxN6P9+Vyh1Rd0g6
   4Fy9QGtaTTh4mY7cjKm9JavBAp500TbeO0Nzueh4kboJ3itZBNVz0sYFv
   +7zJP1O2RJS/e3Q0e2jDKVqZwuewBWFgmna3OP6PY5BHLzfMXOw4OB7j/
   jqc6iLuswBraRhsvBYYtvsp+jBIMDDqjiZVhzeqz6fu4sB0Dx35aDED4r
   ed82TErjI99eUvDsiu+BgCnV7t4o4wKZWT7CPdFaBeM3MVu33HOodBrYP
   4NcVkrlmOi/kOYKYikyNHVaFsrc5oMYXNNhQqLbiK9o6YmO0e/RD95igR
   A==;
X-CSE-ConnectionGUID: 91ck1+aqTR+xenOrlDoAaQ==
X-CSE-MsgGUID: 0z3RjDDoSPWPdWg4W9Esuw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689317"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689317"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:36:51 -0800
X-CSE-ConnectionGUID: W+heuwoAQZOjmJ+rdV79Pw==
X-CSE-MsgGUID: sN9Xd87dRTyBfJlJhz4auA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83988636"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:36:47 -0800
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
Subject: [PATCH v6 07/60] kvm: Introduce kvm_arch_pre_create_vcpu()
Date: Tue,  5 Nov 2024 01:23:15 -0500
Message-Id: <20241105062408.3533704-8-xiaoyao.li@intel.com>
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

Introduce kvm_arch_pre_create_vcpu(), to perform arch-dependent
work prior to create any vcpu. This is for i386 TDX because it needs
call TDX_INIT_VM before creating any vcpu.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
Changes in v3:
- pass @errp to kvm_arch_pre_create_vcpu(); (Per Daniel)
---
 accel/kvm/kvm-all.c  | 10 ++++++++++
 include/sysemu/kvm.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 930a5bfed58f..1732fa1adecd 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -523,6 +523,11 @@ void kvm_destroy_vcpu(CPUState *cpu)
     }
 }
 
+int __attribute__ ((weak)) kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
+{
+    return 0;
+}
+
 int kvm_init_vcpu(CPUState *cpu, Error **errp)
 {
     KVMState *s = kvm_state;
@@ -531,6 +536,11 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
 
     trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
 
+    ret = kvm_arch_pre_create_vcpu(cpu, errp);
+    if (ret < 0) {
+        goto err;
+    }
+
     ret = kvm_create_vcpu(cpu);
     if (ret < 0) {
         error_setg_errno(errp, -ret,
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index c3a60b28909a..643ca4950543 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -374,6 +374,7 @@ int kvm_arch_get_default_type(MachineState *ms);
 
 int kvm_arch_init(MachineState *ms, KVMState *s);
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp);
 int kvm_arch_init_vcpu(CPUState *cpu);
 int kvm_arch_destroy_vcpu(CPUState *cpu);
 
-- 
2.34.1


