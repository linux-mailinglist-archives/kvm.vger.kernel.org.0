Return-Path: <kvm+bounces-36230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C646EA18DBC
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 09:46:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EFEC3ABE74
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 08:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5434C20FA80;
	Wed, 22 Jan 2025 08:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z/fii6Tc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C944D188721
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 08:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737535584; cv=none; b=PzhUg+OnRjDk/trKf/LKDbP2iP2+rc/4yz/jeVrTP8u6NXZrfc4AXIBgkIK3h3L6s7Seeeex4kPtU+HD1xBaWjIiaHJP6iaaY+kIq8+POWpBir9DtQ4uCUV3HqqSZybnnag6GwTCJYwM04CAUqXNdVbJNJjUk4r7ELp/tSDnL8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737535584; c=relaxed/simple;
	bh=ECviX94xj1MV2LXTaHe4lkd20iyrsoewh1cwlHBtoeQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u4lccTjuV+dmCJtyfqmTMR2pTIzwXd3FMH1IiZod/mNW8FYIJRnwxDFiibT4ufEGUKVIpOIyNy4jGFO1ixvH4I91+irdVA2LmxgMU02RUAfEPc8AceUHWKKzbLykJ27iMEQqazPACmDaUC+F3WS3pbkCBN+2i8lfm2nZ0z+Wq+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z/fii6Tc; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737535583; x=1769071583;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ECviX94xj1MV2LXTaHe4lkd20iyrsoewh1cwlHBtoeQ=;
  b=Z/fii6TcQNwBIJHgJydvLs6Nl+DHVlui8pY+qflypP0fWoozanRPwKk9
   6FiYaqv2wmetBHof00lhRz/gJ3o8pRNv+8370e/57pIiKXc0QIe1HEY+t
   OSGuNh8aqqnN3O/1DbIbVJlqHPMtgt9/XBBWVgKMduAmMwSEGVfR1P8qe
   ER9KzBnGhtI2W3vvglKI+MUPZtKh8z9iT4sIiX+75uFsTZ3uvQOsnPYY7
   fz+RJOMn78YuTe5179aawD086w5rG9tiYdRfS2EA9yy4Q3Lyzg3ZOUJHS
   5IhRcNoTNj1h6Zaru5LJoWcChS/zr6mT0ULAAq6ujVe1e0iwuDrPvQSzp
   A==;
X-CSE-ConnectionGUID: bmMMjeHFTKqVea0s9QK7lg==
X-CSE-MsgGUID: U4tgqdQ7Qs61qYvUuN9K/w==
X-IronPort-AV: E=McAfee;i="6700,10204,11322"; a="60451575"
X-IronPort-AV: E=Sophos;i="6.13,224,1732608000"; 
   d="scan'208";a="60451575"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 00:46:23 -0800
X-CSE-ConnectionGUID: pDSkkKfhRPWinRBdf/uitA==
X-CSE-MsgGUID: CRjnXgP2QpKKNi/NIuNzZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="112049828"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 22 Jan 2025 00:46:18 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Gavin Shan <gshan@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yi Lai <yi1.lai@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 3/5] i386/kvm: Support event with select & umask format in KVM PMU filter
Date: Wed, 22 Jan 2025 17:05:15 +0800
Message-Id: <20250122090517.294083-4-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250122090517.294083-1-zhao1.liu@intel.com>
References: <20250122090517.294083-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The select&umask is the common way for x86 to identify the PMU event,
so support this way as the "x86-default" format in kvm-pmu-filter
object.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since RFC v1:
 * Bump up the supported QAPI version to 10.0.
---
 accel/kvm/kvm-pmu.c      | 62 ++++++++++++++++++++++++++++++++++++++++
 include/system/kvm-pmu.h | 13 +++++++++
 qapi/kvm.json            | 46 +++++++++++++++++++++++++++--
 target/i386/kvm/kvm.c    |  5 ++++
 4 files changed, 123 insertions(+), 3 deletions(-)

diff --git a/accel/kvm/kvm-pmu.c b/accel/kvm/kvm-pmu.c
index 4d0d4e7a452b..cbd32e8e21f8 100644
--- a/accel/kvm/kvm-pmu.c
+++ b/accel/kvm/kvm-pmu.c
@@ -17,6 +17,8 @@
 #include "qom/object_interfaces.h"
 #include "system/kvm-pmu.h"
 
+#define UINT12_MAX (4095)
+
 static void kvm_pmu_filter_set_action(Object *obj, int value,
                                       Error **errp G_GNUC_UNUSED)
 {
@@ -54,6 +56,12 @@ static void kvm_pmu_filter_get_event(Object *obj, Visitor *v, const char *name,
             str_event->u.raw.code = g_strdup_printf("0x%lx",
                                                     event->u.raw.code);
             break;
+        case KVM_PMU_EVENT_FMT_X86_DEFAULT:
+            str_event->u.x86_default.select =
+                g_strdup_printf("0x%x", event->u.x86_default.select);
+            str_event->u.x86_default.umask =
+                g_strdup_printf("0x%x", event->u.x86_default.umask);
+            break;
         default:
             g_assert_not_reached();
         }
@@ -98,6 +106,60 @@ static void kvm_pmu_filter_set_event(Object *obj, Visitor *v, const char *name,
                 goto fail;
             }
             break;
+        case KVM_PMU_EVENT_FMT_X86_DEFAULT: {
+            uint64_t select, umask;
+
+            ret = qemu_strtou64(str_event->u.x86_default.select, NULL,
+                                0, &select);
+            if (ret < 0) {
+                error_setg(errp,
+                           "Invalid %s PMU event (select: %s): %s. "
+                           "The select must be a "
+                           "12-bit unsigned number string.",
+                           KVMPMUEventEncodeFmt_str(str_event->format),
+                           str_event->u.x86_default.select,
+                           strerror(-ret));
+                g_free(event);
+                goto fail;
+            }
+            if (select > UINT12_MAX) {
+                error_setg(errp,
+                           "Invalid %s PMU event (select: %s): "
+                           "Numerical result out of range. "
+                           "The select must be a "
+                           "12-bit unsigned number string.",
+                           KVMPMUEventEncodeFmt_str(str_event->format),
+                           str_event->u.x86_default.select);
+                g_free(event);
+                goto fail;
+            }
+            event->u.x86_default.select = select;
+
+            ret = qemu_strtou64(str_event->u.x86_default.umask, NULL,
+                                0, &umask);
+            if (ret < 0) {
+                error_setg(errp,
+                           "Invalid %s PMU event (umask: %s): %s. "
+                           "The umask must be a uint8 string.",
+                           KVMPMUEventEncodeFmt_str(str_event->format),
+                           str_event->u.x86_default.umask,
+                           strerror(-ret));
+                g_free(event);
+                goto fail;
+            }
+            if (umask > UINT8_MAX) {
+                error_setg(errp,
+                           "Invalid %s PMU event (umask: %s): "
+                           "Numerical result out of range. "
+                           "The umask must be a uint8 string.",
+                           KVMPMUEventEncodeFmt_str(str_event->format),
+                           str_event->u.x86_default.umask);
+                g_free(event);
+                goto fail;
+            }
+            event->u.x86_default.umask = umask;
+            break;
+        }
         default:
             g_assert_not_reached();
         }
diff --git a/include/system/kvm-pmu.h b/include/system/kvm-pmu.h
index b09f70d3a370..63402f75cfdc 100644
--- a/include/system/kvm-pmu.h
+++ b/include/system/kvm-pmu.h
@@ -27,4 +27,17 @@ struct KVMPMUFilter {
     KVMPMUFilterEventList *events;
 };
 
+/*
+ * Stolen from Linux kernel (RAW_EVENT at tools/testing/selftests/kvm/include/
+ * x86_64/pmu.h).
+ *
+ * Encode an eventsel+umask pair into event-select MSR format.  Note, this is
+ * technically AMD's format, as Intel's format only supports 8 bits for the
+ * event selector, i.e. doesn't use bits 24:16 for the selector.  But, OR-ing
+ * in '0' is a nop and won't clobber the CMASK.
+ */
+#define X86_PMU_RAW_EVENT(eventsel, umask) (((eventsel & 0xf00UL) << 24) | \
+                                            ((eventsel) & 0xff) | \
+                                            ((umask) & 0xff) << 8)
+
 #endif /* KVM_PMU_H */
diff --git a/qapi/kvm.json b/qapi/kvm.json
index d51aeeba7cd8..93b869e3f90c 100644
--- a/qapi/kvm.json
+++ b/qapi/kvm.json
@@ -27,11 +27,13 @@
 #
 # @raw: the encoded event code that KVM can directly consume.
 #
+# @x86-default: standard x86 encoding format with select and umask.
+#
 # Since 10.0
 ##
 { 'enum': 'KVMPMUEventEncodeFmt',
   'prefix': 'KVM_PMU_EVENT_FMT',
-  'data': ['raw'] }
+  'data': ['raw', 'x86-default'] }
 
 ##
 # @KVMPMURawEvent:
@@ -46,6 +48,25 @@
 { 'struct': 'KVMPMURawEvent',
   'data': { 'code': 'uint64' } }
 
+##
+# @KVMPMUX86DefalutEvent:
+#
+# x86 PMU event encoding with select and umask.
+# raw_event = ((select & 0xf00UL) << 24) | \
+#              (select) & 0xff) | \
+#              ((umask) & 0xff) << 8)
+#
+# @select: x86 PMU event select field, which is a 12-bit unsigned
+#     number.
+#
+# @umask: x86 PMU event umask field.
+#
+# Since 10.0
+##
+{ 'struct': 'KVMPMUX86DefalutEvent',
+  'data': { 'select': 'uint16',
+            'umask': 'uint8' } }
+
 ##
 # @KVMPMUFilterEvent:
 #
@@ -58,7 +79,8 @@
 { 'union': 'KVMPMUFilterEvent',
   'base': { 'format': 'KVMPMUEventEncodeFmt' },
   'discriminator': 'format',
-  'data': { 'raw': 'KVMPMURawEvent' } }
+  'data': { 'raw': 'KVMPMURawEvent',
+            'x86-default': 'KVMPMUX86DefalutEvent' } }
 
 ##
 # @KVMPMUFilterProperty:
@@ -86,6 +108,23 @@
 { 'struct': 'KVMPMURawEventVariant',
   'data': { 'code': 'str' } }
 
+##
+# @KVMPMUX86DefalutEventVariant:
+#
+# The variant of KVMPMUX86DefalutEvent with the string, rather than
+# the numeric value.
+#
+# @select: x86 PMU event select field.  This field is a 12-bit
+#     unsigned number string.
+#
+# @umask: x86 PMU event umask field. This field is a uint8 string.
+#
+# Since 10.0
+##
+{ 'struct': 'KVMPMUX86DefalutEventVariant',
+  'data': { 'select': 'str',
+            'umask': 'str' } }
+
 ##
 # @KVMPMUFilterEventVariant:
 #
@@ -98,7 +137,8 @@
 { 'union': 'KVMPMUFilterEventVariant',
   'base': { 'format': 'KVMPMUEventEncodeFmt' },
   'discriminator': 'format',
-  'data': { 'raw': 'KVMPMURawEventVariant' } }
+  'data': { 'raw': 'KVMPMURawEventVariant',
+            'x86-default': 'KVMPMUX86DefalutEventVariant' } }
 
 ##
 # @KVMPMUFilterPropertyVariant:
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index b82adbed50f4..bab58761417a 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5970,6 +5970,10 @@ static bool kvm_config_pmu_event(KVMPMUFilter *filter,
         case KVM_PMU_EVENT_FMT_RAW:
             code = event->u.raw.code;
             break;
+        case KVM_PMU_EVENT_FMT_X86_DEFAULT:
+            code = X86_PMU_RAW_EVENT(event->u.x86_default.select,
+                                     event->u.x86_default.umask);
+            break;
         default:
             g_assert_not_reached();
         }
@@ -6640,6 +6644,7 @@ static void kvm_arch_check_pmu_filter(const Object *obj, const char *name,
 
         switch (event->format) {
         case KVM_PMU_EVENT_FMT_RAW:
+        case KVM_PMU_EVENT_FMT_X86_DEFAULT:
             break;
         default:
             error_setg(errp,
-- 
2.34.1


