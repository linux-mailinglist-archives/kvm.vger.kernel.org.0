Return-Path: <kvm+bounces-36494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70B6FA1B6EA
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:37:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C077188C7B9
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94BB5481D1;
	Fri, 24 Jan 2025 13:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XOIWn+sT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300D23596F
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725856; cv=none; b=ljblrOrgROcKtuPlmUAPCymnXv/yhjovG8I7WKSvj0j+GfMc+zPfhy/IiBLCbzzYo/5xfo6dW7shUxLOCRtY0SXFPpSUROuRxxN3/ExxiaGKgaFeFr16nYSJNCbW9WapucdQehDGK8e5av3CwYJlK5JBt8248GBih7uzO2D95MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725856; c=relaxed/simple;
	bh=8WMcUge9rmtOr6U0aXqB/yjkjjM2B/twbpSG8Wc/MCo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IhkBNlq+03X0Yy5mlobfRdlDunEmlRNkXFaVoiXrTIUtag7oKEcjqsPhlZedu3ar5DvMliMn1+oPtS4R2a0m1u+ERhUp2zjSiJYDWYFmP8k34blbdwwTqUNu7v8iA/CvD4oojdMy6vUOoSmze9u1jh9OcZe/yye1d3WPa7tz8Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XOIWn+sT; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725856; x=1769261856;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8WMcUge9rmtOr6U0aXqB/yjkjjM2B/twbpSG8Wc/MCo=;
  b=XOIWn+sTVQnjwK0ppi+4JMTrdeRPDmTUfquhQG6kuxV7dFkUtNXR2EXj
   S7D7IO/hqKgQcZK6e5wlWBuztteNrg54q297RyVY/OPHXLyt6fbJiNpTa
   7ryYCzpst4zo2ssnlkucP9V2gwWLUefSH0+KNuORmhxga5rjMnpJ+/PlV
   CsV9lRYfPhL/Iyyv/JYhj+y9u51smNZ8bdV+yAbMbpTgSN6MfhKO/w2Lb
   hKgzakOLjGJqpbcIeO1CfPaH7+9YvTOjUr+uCnq999HPzONHxH9Kfhtzc
   Fp/IL051sZKy2DaCVgaguWzCqUHsecrb0dLTGPt0hy9Rfa2dK8uN3x4dE
   Q==;
X-CSE-ConnectionGUID: KrGma/ptQUaz7DvwiTEjOA==
X-CSE-MsgGUID: NjgThYKHTlq39aAZL/66HQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246238"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246238"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:37:35 -0800
X-CSE-ConnectionGUID: P74qXLdRRR2cMWAUc+dSGw==
X-CSE-MsgGUID: CUpxfmNmSJ6bXdmYzO8QLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804180"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:37:31 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 09/52] i386/tdx: Add property sept-ve-disable for tdx-guest object
Date: Fri, 24 Jan 2025 08:20:05 -0500
Message-Id: <20250124132048.3229049-10-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bit 28 of TD attribute, named SEPT_VE_DISABLE. When set to 1, it disables
EPT violation conversion to #VE on guest TD access of PENDING pages.

Some guest OS (e.g., Linux TD guest) may require this bit as 1.
Otherwise refuse to boot.

Add sept-ve-disable property for tdx-guest object, for user to configure
this bit.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Acked-by: Markus Armbruster <armbru@redhat.com>
---
Changes in v4:
- collect Acked-by from Markus

Changes in v3:
- update the comment of property @sept-ve-disable to make it more
  descriptive and use new format. (Daniel and Markus)
---
 qapi/qom.json         |  8 +++++++-
 target/i386/kvm/tdx.c | 23 +++++++++++++++++++++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/qapi/qom.json b/qapi/qom.json
index e3a5e9330b54..8740626c4ee6 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -1055,10 +1055,16 @@
 # @attributes: The 'attributes' of a TD guest that is passed to
 #     KVM_TDX_INIT_VM
 #
+# @sept-ve-disable: toggle bit 28 of TD attributes to control disabling
+#     of EPT violation conversion to #VE on guest TD access of PENDING
+#     pages.  Some guest OS (e.g., Linux TD guest) may require this to
+#     be set, otherwise they refuse to boot.
+#
 # Since: 10.0
 ##
 { 'struct': 'TdxGuestProperties',
-  'data': { '*attributes': 'uint64' } }
+  'data': { '*attributes': 'uint64',
+            '*sept-ve-disable': 'bool' } }
 
 ##
 # @ThreadContextProperties:
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index b8a85f2333ad..214ff7409e1f 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -18,6 +18,8 @@
 #include "kvm_i386.h"
 #include "tdx.h"
 
+#define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
+
 static TdxGuest *tdx_guest;
 
 static struct kvm_tdx_capabilities *tdx_caps;
@@ -250,6 +252,24 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
     return 0;
 }
 
+static bool tdx_guest_get_sept_ve_disable(Object *obj, Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    return !!(tdx->attributes & TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE);
+}
+
+static void tdx_guest_set_sept_ve_disable(Object *obj, bool value, Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    if (value) {
+        tdx->attributes |= TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE;
+    } else {
+        tdx->attributes &= ~TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE;
+    }
+}
+
 /* tdx guest */
 OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
                                    tdx_guest,
@@ -270,6 +290,9 @@ static void tdx_guest_init(Object *obj)
 
     object_property_add_uint64_ptr(obj, "attributes", &tdx->attributes,
                                    OBJ_PROP_FLAG_READWRITE);
+    object_property_add_bool(obj, "sept-ve-disable",
+                             tdx_guest_get_sept_ve_disable,
+                             tdx_guest_set_sept_ve_disable);
 }
 
 static void tdx_guest_finalize(Object *obj)
-- 
2.34.1


