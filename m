Return-Path: <kvm+bounces-30637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDB849BC57A
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:36:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EC2F282ECB
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB291F76A8;
	Tue,  5 Nov 2024 06:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kUVH4UCi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B791F16B
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788596; cv=none; b=XL4TMbUK0XlRh7swQQU5378+/5WNNvrm9T3xN3JaKEv0NE/e+iPpaaPQF84SLhFNn51xNDRq/2FcLxanX8vGgEyPl1+Bu1v2cTorkq27mr+7yJyqrU1LzLIpIFQLBc2TQHy5LjDwxVhNmvPy8lS1qA3RBuU4KGTVGP1csrsTw6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788596; c=relaxed/simple;
	bh=OubJ0frbbHV7MSdZrZwfSjPq/m9f7s+BIewp1R/ME4Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ffkY7IyX+z+jpbr7psu13Vo5IG2Y2cDih0ghfEUIRWXUUwfMzYNVCIOpn9z3vucCTwC9cMJjUi2zcFpnncyJb+L1V53V5oI7E5SKyNl5aF9qDMdFdf29uOe4ezWZDN81vviT1G6POpDR3Up6IKSYZsQGCut/NUXSVBZaFylzMrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kUVH4UCi; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788594; x=1762324594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OubJ0frbbHV7MSdZrZwfSjPq/m9f7s+BIewp1R/ME4Y=;
  b=kUVH4UCiOhidEEGjsh5PYQPanbuiqGmNBSvowIOzWn2H0WICphbeN0Pd
   0H0xoMGPoo0neR5r1xWpe/EN2bOdNHXSQwwmuZUsjxFO+RXpATv/Aj/77
   5ynG2FR1U8LmDiNUwdI8JkzJKCxJjPD+HaXIyMm8yO5H7pv8xfTxSJJ48
   CGLR8l4rw/NZrzSvj6KiO8MEjPJYyJQwvS8PWtKkHT8JZxl0fmsyIFA2g
   MqgO2ZLQE433eqSRFo7Npe0V/VmTpcbl+9/xik5pz14CNecK5WqlxOyjJ
   z418EY+xi5Xl3tqZS/puPHWL+gaC2s6ztuhkhE6KdhuPP8fumvmr3aVx1
   Q==;
X-CSE-ConnectionGUID: Of3QTW5VTb2kmBICIRhK1A==
X-CSE-MsgGUID: +AvS7N7HSkG9FA/ZqT0Izg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689237"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689237"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:36:34 -0800
X-CSE-ConnectionGUID: xfz50WFbT2mM6g0uRJBg8A==
X-CSE-MsgGUID: 23LnzFrqQVehOjvo+qmMZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83988589"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:36:30 -0800
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
Subject: [PATCH v6 03/60] i386/tdx: Implement tdx_kvm_type() for TDX
Date: Tue,  5 Nov 2024 01:23:11 -0500
Message-Id: <20241105062408.3533704-4-xiaoyao.li@intel.com>
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

TDX VM requires VM type to be KVM_X86_TDX_VM. Implement tdx_kvm_type()
as X86ConfidentialGuestClass->kvm_type.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v6:
 - new added patch;
---
 target/i386/kvm/kvm.c |  1 +
 target/i386/kvm/tdx.c | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 8e17942c3ba1..ed2e89946c44 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -194,6 +194,7 @@ static const char *vm_type_name[] = {
     [KVM_X86_SEV_VM] = "SEV",
     [KVM_X86_SEV_ES_VM] = "SEV-ES",
     [KVM_X86_SNP_VM] = "SEV-SNP",
+    [KVM_X86_TDX_VM] = "TDX",
 };
 
 bool kvm_is_vm_type_supported(int type)
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 166f53d2b9e3..bf8947549a96 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -14,8 +14,17 @@
 #include "qemu/osdep.h"
 #include "qom/object_interfaces.h"
 
+#include "kvm_i386.h"
 #include "tdx.h"
 
+static int tdx_kvm_type(X86ConfidentialGuest *cg)
+{
+    /* Do the object check */
+    TDX_GUEST(cg);
+
+    return KVM_X86_TDX_VM;
+}
+
 /* tdx guest */
 OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
                                    tdx_guest,
@@ -42,4 +51,7 @@ static void tdx_guest_finalize(Object *obj)
 
 static void tdx_guest_class_init(ObjectClass *oc, void *data)
 {
+    X86ConfidentialGuestClass *x86_klass = X86_CONFIDENTIAL_GUEST_CLASS(oc);
+
+    x86_klass->kvm_type = tdx_kvm_type;
 }
-- 
2.34.1


