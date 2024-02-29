Return-Path: <kvm+bounces-10381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E512986C0F3
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:41:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99421285FA9
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69B1744C9C;
	Thu, 29 Feb 2024 06:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HGyr9hpP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2692744C8C
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188830; cv=none; b=QVv1cnbfZtFH/aZQEsKrX8z2shd0fTVzUDqdheHGNgDs6Xuj5dfLq/Wkx6L5+NxDgzp672tXKsFvIy+5A0EFABIkU6amO+EKcoSuRS36Ka8Z1pQcGmLLkBO9kWTLw3Mt3l8I9sEMKln8Vg2HeNEidodEWNFTgZMeqelM/220WD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188830; c=relaxed/simple;
	bh=Y33t/ibKB7vt/bpyD5EzFAZhx7CESCpU91KCSeJ2pYg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ClpYpj54WLTWa2crfYDwKsqvUdmR6v36cK/j/FZziITJk7C3UBTrr0ysaQs3uUsljBf00eHny9ssWO1eYdUUO5SEeOE5D17fboqlEoT9K1nkoQga1Ww/LH4CdthIkfPjZPxzPy2f/zS6+c6eshwbZIKhzMenJhEJNDAu3IP2P/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HGyr9hpP; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188829; x=1740724829;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y33t/ibKB7vt/bpyD5EzFAZhx7CESCpU91KCSeJ2pYg=;
  b=HGyr9hpPki2nmQpxLaWJr3aoAcaT+jeYUKQopCqdfAHrY6mCbxSCLTWv
   kej6n+sYbudA/9pnWRUKmWKh7a314/es/2D4oaibf3CQOx8JhdnyNlmE7
   BfUus2r319N4sUOrcKlmQ/pt4yxLNyD30SyjxXhyShOuQTomzDsDHcE10
   dxMqOZzPYFWYs1wLP8dVon9QnLGU5h4+PjyuKiuhrvYi1QRXgs2NLOFSm
   P5lb66FNnkBH//yw9b+oimDW3PkTE+Msg+M5E0Wre3Z6QKwAt+v9ei3hl
   otBKhV4mudFe43TA94aEsr/WXLtWsNH6a4TTIWnoadWRwi0lRNdVoFkiD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802733"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802733"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:40:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8075508"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:40:12 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 25/65] i386/tdx: Add property sept-ve-disable for tdx-guest object
Date: Thu, 29 Feb 2024 01:36:46 -0500
Message-Id: <20240229063726.610065-26-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229063726.610065-1-xiaoyao.li@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
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
 qapi/qom.json         |  7 ++++++-
 target/i386/kvm/tdx.c | 24 ++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/qapi/qom.json b/qapi/qom.json
index 220cc6c98d4b..89ed89b9b46e 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -900,10 +900,15 @@
 #
 # Properties for tdx-guest objects.
 #
+# @sept-ve-disable: toggle bit 28 of TD attributes to control disabling
+#     of EPT violation conversion to #VE on guest TD access of PENDING
+#     pages.  Some guest OS (e.g., Linux TD guest) may require this to
+#     be set, otherwise they refuse to boot.
+#
 # Since: 9.0
 ##
 { 'struct': 'TdxGuestProperties',
-  'data': { }}
+  'data': { '*sept-ve-disable': 'bool' } }
 
 ##
 # @ThreadContextProperties:
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index d548ec340285..806192158c9d 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -32,6 +32,8 @@
                                      (1U << KVM_FEATURE_PV_SCHED_YIELD) | \
                                      (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
 
+#define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
+
 #define TDX_ATTRIBUTES_MAX_BITS      64
 
 static FeatureMask tdx_attrs_ctrl_fields[TDX_ATTRIBUTES_MAX_BITS] = {
@@ -514,6 +516,24 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
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
@@ -529,6 +549,10 @@ static void tdx_guest_init(Object *obj)
     qemu_mutex_init(&tdx->lock);
 
     tdx->attributes = 0;
+
+    object_property_add_bool(obj, "sept-ve-disable",
+                             tdx_guest_get_sept_ve_disable,
+                             tdx_guest_set_sept_ve_disable);
 }
 
 static void tdx_guest_finalize(Object *obj)
-- 
2.34.1


