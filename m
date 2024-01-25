Return-Path: <kvm+bounces-6927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4024783B7F0
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:30:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDA96285D92
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96A07134C7;
	Thu, 25 Jan 2024 03:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ClXbt0wj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB9E12E4F
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153316; cv=none; b=KNpiT4CpZmsrpyziwn22GAFFAgjOefuMpCp7d32wM7b05bpkdTr/ekSPiLRjf/dArUmjmN0SJf4dpPMWPuwFzDm12jgvmVWnfZ+Evp+YVIxU7IDoo8oVKGHauAFMUtg3gYHTMTszSz1rvxdGdS2A4gI9N9SbmrgBtdCNNBAA744=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153316; c=relaxed/simple;
	bh=4xH30obpzju+HkXz72Fksgx3mUojVcIP/XKw7H+oMbY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jVIfCJoC6mDMGYBF6KoHjbXAig3VX3SIql67Gi1MCNaXgyYl0fOGMEC1J/lqR3+MYXdmIGdjYqqIglDVTZefC6yS7QkiYBh7tRt/ICRsDgIxB13QQ7z3R6cWzMIssHQkYhr26aLCgPq8BAB8HuAK00snd0l8n5r0T1Ue031E6Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ClXbt0wj; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153315; x=1737689315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4xH30obpzju+HkXz72Fksgx3mUojVcIP/XKw7H+oMbY=;
  b=ClXbt0wj37vY6qvTKsb21PfiUjptPHrSsIwMG0Cv1P4U0ft8C/MZFubN
   hEQ1VwUcI2OsReIGoTEc3umc/wWDap3O8aAvxB+TOWDiaQkOmybZctCYa
   oR+YWOJV2JcpeBsxgMygp6+Ra+eG+SnkaxfRRjf7eXXHw6OFQMQcBPwrd
   yipRmuyJXFXeUO+mHAV9gXFHPxc8N02smtXT2RJ+Cu4H74Y3RJcrBsG1y
   Fi55EZ4eiGlaCOhgM3vUSxSRG9Ty5ZjZpjp9FTnkGWyP0psWH5/9IgukW
   r0yPrTQxSjuxajQGdwsI4Jf/Yrk3VuiA1XlLS+8HLf3zxeHGQ9kcxckHt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9428788"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9428788"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:25:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2085651"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:25:50 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 25/66] i386/tdx: Add property sept-ve-disable for tdx-guest object
Date: Wed, 24 Jan 2024 22:22:47 -0500
Message-Id: <20240125032328.2522472-26-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
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
index 5b3c3146947f..2177f3101382 100644
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
index 634aca504b32..51db64bec7ce 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -32,6 +32,8 @@
                                      (1U << KVM_FEATURE_PV_SCHED_YIELD) | \
                                      (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
 
+#define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
+
 #define TDX_ATTRIBUTES_MAX_BITS      64
 
 static FeatureMask tdx_attrs_ctrl_fields[TDX_ATTRIBUTES_MAX_BITS] = {
@@ -513,6 +515,24 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
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
@@ -528,6 +548,10 @@ static void tdx_guest_init(Object *obj)
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


