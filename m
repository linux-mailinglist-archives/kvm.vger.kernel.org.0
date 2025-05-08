Return-Path: <kvm+bounces-45935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 625C6AAFEA4
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:13:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B28FC7BF166
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CB30286413;
	Thu,  8 May 2025 15:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SG/QhAxr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496F326F478
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716795; cv=none; b=gwE2EuMnt3gS6TpjBdiutBbh1ndUYNbebzhWavmJ7GGU8hXOywTqUIQMakuS/KdHmZ4eP2jIkVIXHrjs3evU7M+NdwsMr8YxdTKtuqWe8F3QktxIr/pZe0DXNCGrdNJtXlOiKuR682KJBDRu+rhFNjW7WBdacmDGpJ+dGsHF5Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716795; c=relaxed/simple;
	bh=KWILXHL0VnAkibk99IHWXywOOvMvm6j0ss8g3Pct9KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0DZ703gwlMKRoDWBmiQxKwGArGIu/baosmZzsRE6IZG463jfh1V3I9ee983tsMhybvHvVmyP1cEqGV6HHPH5ZwTwpRdc/ZkZVEiOLp3869rVraophRBMgy05pnedP7a6UhJYosRa6ZXi5IDtAjTqvxxyMm2r/45HDVTMJXP+LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SG/QhAxr; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716794; x=1778252794;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KWILXHL0VnAkibk99IHWXywOOvMvm6j0ss8g3Pct9KA=;
  b=SG/QhAxrGD4tsTDxRcNv6txvW2Aied3UYoLDprf1PfMO8+VpEub+o/E0
   s3r2Ei0Md7UuGbGUtsMGGMqqKy7W0nw+XQlPVFOsmv6lf2P1nmvc9QQR9
   iiO29FzsBj3ljKRRKEn7XvWaXSkTdbNQ+N3IXSK098Nq3SXK+v0c4wxlp
   7KspvlZoKDRN5qytMT0K5O5jRa+Wqx2Hv+LCaEb12i4qp+domPwks7OW+
   gVHW6Uzv4SN4BrY+Fzx496840OxVuqVnZDoJCLSU+8junSDaa3nNk3ppB
   /4bNd+rGBIeSGzJdXwcsfFeMgley7g8cS4cbC1UR69t2C2JXbgYa/TS4K
   w==;
X-CSE-ConnectionGUID: EfV07yqRSWeyO55ZhAwURw==
X-CSE-MsgGUID: 32yH88fCSBa7pQzhzb+iwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888283"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888283"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:34 -0700
X-CSE-ConnectionGUID: rHuE/TQhQV+05hUWj1ZjLQ==
X-CSE-MsgGUID: 9EW3V2vNRP+CgPj01swmxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440145"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:31 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 32/55] i386/tdx: implement tdx_cpu_instance_init()
Date: Thu,  8 May 2025 10:59:38 -0400
Message-ID: <20250508150002.689633-33-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, pmu is not supported for TDX by KVM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
chanegs in v6:
 - new patch;
---
 target/i386/kvm/tdx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index e80586feb704..0d6342b51dbc 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -405,6 +405,11 @@ static int tdx_kvm_type(X86ConfidentialGuest *cg)
     return KVM_X86_TDX_VM;
 }
 
+static void tdx_cpu_instance_init(X86ConfidentialGuest *cg, CPUState *cpu)
+{
+    object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
+}
+
 static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
 {
     if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
@@ -798,4 +803,5 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
 
     klass->kvm_init = tdx_kvm_init;
     x86_klass->kvm_type = tdx_kvm_type;
+    x86_klass->cpu_instance_init = tdx_cpu_instance_init;
 }
-- 
2.43.0


