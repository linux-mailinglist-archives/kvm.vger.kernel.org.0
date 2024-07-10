Return-Path: <kvm+bounces-21265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8B4C92C9F0
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 06:38:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11362B23613
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 04:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD2258AC4;
	Wed, 10 Jul 2024 04:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FfSL3R8w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DFE53804
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 04:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720586180; cv=none; b=Nuz1KVX8zt84wylbcHe/3aOw3dMifzF06GLda4jVAJ/Ux+91OA7WhYGBzxhN6ynRlqcswiB1B02ZOs+nPsZOeiyvM1h+QmMQA8LiCrSyBpwgaU2FkqomsvPUnMO3xceIATbA1MmnN9NT8nT3VXoEKWxI/BcXIrL0mVCMFsftgjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720586180; c=relaxed/simple;
	bh=COv/wxh7LoZnCJkoFwP3rD91fqQddYuwNXRcw9JrnaY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NN1QGDRX//NQzVleLHaUCJB3txSqliZeBPm9E1qGivAhmREUeqdBSLWnYLydcPf69DslCDBQCG21MYSkpMVb02dTHfsPWa2uXullW5l3+wNDYrV21eF8za2j/VZEPItp8Zr4Wpz1l73ab3roL7SeNL0SKdOxhSwvvT0ZAVi47YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FfSL3R8w; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720586178; x=1752122178;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=COv/wxh7LoZnCJkoFwP3rD91fqQddYuwNXRcw9JrnaY=;
  b=FfSL3R8wXBLPH6fX0vpJacPHdMdZ1LgmUaFN6hFI5cX/o0OyVzAKyVom
   r9sY1CXf1YYMmDpXb3ui88p0Xxyl5n1gS8YIC7SMd2JQIALrOx0PcL2yu
   cRMOFNUTlWS+axfgLLQ6ozv6d4LsYEqyOJQ7yuGBTdebJkklnbui654S5
   Et7M/qdN7LgCbfoQKnO1XvWZ975Wf3jh2/5gum8wPJTedeIj73b7vSFW/
   HL71V7L5PMJxEaTeS+neTS21cR/N/dxaon5Pb6CJaPL8m7H8q7cGNOVq4
   0CILWdB3xADcbr60olzHnc/0svrVqD1m9mpjFilR2BbTYl7CpoN8C2qct
   Q==;
X-CSE-ConnectionGUID: aThTDcVCRW6VFXhfd8KWPg==
X-CSE-MsgGUID: 4wuKGvS0SoGXil2L5KD6Zg==
X-IronPort-AV: E=McAfee;i="6700,10204,11128"; a="28473812"
X-IronPort-AV: E=Sophos;i="6.09,197,1716274800"; 
   d="scan'208";a="28473812"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 21:36:18 -0700
X-CSE-ConnectionGUID: Ut4ZFwZWRJORPKf2PD8ZPA==
X-CSE-MsgGUID: 4gBlVdnnQgqUHIvPHWt6kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,197,1716274800"; 
   d="scan'208";a="79238210"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 09 Jul 2024 21:36:13 -0700
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
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yuan Yao <yuan.yao@intel.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Jim Mattson <jmattson@google.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 4/5] i386/kvm: Support event with masked entry format in KVM PMU filter
Date: Wed, 10 Jul 2024 12:51:16 +0800
Message-Id: <20240710045117.3164577-5-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240710045117.3164577-1-zhao1.liu@intel.com>
References: <20240710045117.3164577-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM_SET_PMU_EVENT_FILTER of x86 KVM supports masked events mode, which
accepts masked entry format event to flexibly represent a group of PMU
events.

Support masked entry format in kvm-pmu-filter object and handle this in
i386 kvm codes.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 accel/kvm/kvm-pmu.c   | 91 +++++++++++++++++++++++++++++++++++++++++++
 qapi/kvm.json         | 68 ++++++++++++++++++++++++++++++--
 target/i386/kvm/kvm.c | 39 +++++++++++++++++++
 3 files changed, 195 insertions(+), 3 deletions(-)

diff --git a/accel/kvm/kvm-pmu.c b/accel/kvm/kvm-pmu.c
index 51d3fba5a72a..7a1720c68f8f 100644
--- a/accel/kvm/kvm-pmu.c
+++ b/accel/kvm/kvm-pmu.c
@@ -46,6 +46,16 @@ static void kvm_pmu_filter_get_event(Object *obj, Visitor *v, const char *name,
             str_event->u.x86_default.umask =
                 g_strdup_printf("0x%x", event->u.x86_default.umask);
             break;
+        case KVM_PMU_EVENT_FMT_X86_MASKED_ENTRY:
+            str_event->u.x86_masked_entry.select =
+                g_strdup_printf("0x%x", event->u.x86_masked_entry.select);
+            str_event->u.x86_masked_entry.match =
+                g_strdup_printf("0x%x", event->u.x86_masked_entry.match);
+            str_event->u.x86_masked_entry.mask =
+                g_strdup_printf("0x%x", event->u.x86_masked_entry.mask);
+            str_event->u.x86_masked_entry.exclude =
+                event->u.x86_masked_entry.exclude;
+            break;
         default:
             g_assert_not_reached();
         }
@@ -145,6 +155,87 @@ static void kvm_pmu_filter_set_event(Object *obj, Visitor *v, const char *name,
             event->u.x86_default.umask = umask;
             break;
         }
+        case KVM_PMU_EVENT_FMT_X86_MASKED_ENTRY: {
+            uint64_t select, match, mask;
+
+            ret = qemu_strtou64(str_event->u.x86_masked_entry.select,
+                                NULL, 0, &select);
+            if (ret < 0) {
+                error_setg(errp,
+                           "Invalid %s PMU event (select: %s): %s. "
+                           "The select must be a "
+                           "12-bit unsigned number string.",
+                           KVMPMUEventEncodeFmt_str(str_event->format),
+                           str_event->u.x86_masked_entry.select,
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
+                           str_event->u.x86_masked_entry.select);
+                g_free(event);
+                goto fail;
+            }
+            event->u.x86_masked_entry.select = select;
+
+            ret = qemu_strtou64(str_event->u.x86_masked_entry.match,
+                                NULL, 0, &match);
+            if (ret < 0) {
+                error_setg(errp,
+                           "Invalid %s PMU event (match: %s): %s. "
+                           "The match must be a uint8 string.",
+                           KVMPMUEventEncodeFmt_str(str_event->format),
+                           str_event->u.x86_masked_entry.match,
+                           strerror(-ret));
+                g_free(event);
+                goto fail;
+            }
+            if (match > UINT8_MAX) {
+                error_setg(errp,
+                           "Invalid %s PMU event (match: %s): "
+                           "Numerical result out of range. "
+                           "The match must be a uint8 string.",
+                           KVMPMUEventEncodeFmt_str(str_event->format),
+                           str_event->u.x86_masked_entry.match);
+                g_free(event);
+                goto fail;
+            }
+            event->u.x86_masked_entry.match = match;
+
+            ret = qemu_strtou64(str_event->u.x86_masked_entry.mask,
+                                NULL, 0, &mask);
+            if (ret < 0) {
+                error_setg(errp,
+                           "Invalid %s PMU event (mask: %s): %s. "
+                           "The mask must be a uint8 string.",
+                           KVMPMUEventEncodeFmt_str(str_event->format),
+                           str_event->u.x86_masked_entry.mask,
+                           strerror(-ret));
+                g_free(event);
+                goto fail;
+            }
+            if (mask > UINT8_MAX) {
+                error_setg(errp,
+                           "Invalid %s PMU event (mask: %s): "
+                           "Numerical result out of range. "
+                           "The mask must be a uint8 string.",
+                           KVMPMUEventEncodeFmt_str(str_event->format),
+                           str_event->u.x86_masked_entry.mask);
+                g_free(event);
+                goto fail;
+            }
+            event->u.x86_masked_entry.mask = mask;
+
+            event->u.x86_masked_entry.exclude =
+                str_event->u.x86_masked_entry.exclude;
+            break;
+        }
         default:
             g_assert_not_reached();
         }
diff --git a/qapi/kvm.json b/qapi/kvm.json
index 0d759884c229..f4e8854fa6c6 100644
--- a/qapi/kvm.json
+++ b/qapi/kvm.json
@@ -29,11 +29,14 @@
 #
 # @x86-default: standard x86 encoding format with select and umask.
 #
+# @x86-masked-entry: KVM's masked entry format for x86, which could
+#                    mask bunch of events.
+#
 # Since 9.1
 ##
 { 'enum': 'KVMPMUEventEncodeFmt',
   'prefix': 'KVM_PMU_EVENT_FMT',
-  'data': ['raw', 'x86-default'] }
+  'data': ['raw', 'x86-default', 'x86-masked-entry'] }
 
 ##
 # @KVMPMURawEvent:
@@ -67,6 +70,40 @@
   'data': { 'select': 'uint16',
             'umask': 'uint8' } }
 
+##
+# @KVMPMUX86MaskedEntry:
+#
+# x86 PMU events encoding in KVM masked entry format.
+#
+# Encoding layout:
+# Bits   Description
+# ----   -----------
+# 7:0    event select (low bits)
+# 15:8   (umask) match
+# 31:16  unused
+# 35:32  event select (high bits)
+# 36:54  unused
+# 55     exclude bit
+# 63:56  (umask) mask
+#
+# Events are selected by (umask & mask == match)
+#
+# @select: x86 PMU event select, which is a 12-bit unsigned number.
+#
+# @match: umask match.
+#
+# @mask: umask mask
+#
+# @exclude: Whether the matched events are excluded.
+#
+# Since 9.1
+##
+{ 'struct': 'KVMPMUX86MaskedEntry',
+  'data': { 'select': 'uint16',
+            'match': 'uint8',
+            'mask': 'uint8',
+            'exclude': 'bool' } }
+
 ##
 # @KVMPMUFilterEvent:
 #
@@ -83,7 +120,8 @@
             'format': 'KVMPMUEventEncodeFmt' },
   'discriminator': 'format',
   'data': { 'raw': 'KVMPMURawEvent',
-            'x86-default': 'KVMPMUX86DefalutEvent' } }
+            'x86-default': 'KVMPMUX86DefalutEvent',
+            'x86-masked-entry': 'KVMPMUX86MaskedEntry' } }
 
 ##
 # @KVMPMUFilterProperty:
@@ -128,6 +166,29 @@
   'data': { 'select': 'str',
             'umask': 'str' } }
 
+##
+# @KVMPMUX86MaskedEntryVariant:
+#
+# The variant of KVMPMUX86MaskedEntry with the string, rather than
+# the numeric value.
+#
+# @select: x86 PMU event select.  This field is a 12-bit unsigned
+#     number string.
+#
+# @match: umask match.  This field is a uint8 string.
+#
+# @mask: umask mask.  This field is a uint8 string.
+#
+# @exclude: Whether the matched events are excluded.
+#
+# Since 9.1
+##
+{ 'struct': 'KVMPMUX86MaskedEntryVariant',
+  'data': { 'select': 'str',
+            'match': 'str',
+            'mask': 'str',
+            'exclude': 'bool' } }
+
 ##
 # @KVMPMUFilterEventVariant:
 #
@@ -144,7 +205,8 @@
             'format': 'KVMPMUEventEncodeFmt' },
   'discriminator': 'format',
   'data': { 'raw': 'KVMPMURawEventVariant',
-            'x86-default': 'KVMPMUX86DefalutEventVariant' } }
+            'x86-default': 'KVMPMUX86DefalutEventVariant',
+            'x86-masked-entry': 'KVMPMUX86MaskedEntryVariant' } }
 
 ##
 # @KVMPMUFilterPropertyVariant:
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 391531c036a6..396a93efe745 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5397,6 +5397,13 @@ kvm_config_pmu_event(KVMPMUFilter *filter,
             code = X86_PMU_RAW_EVENT(event->u.x86_default.select,
                                      event->u.x86_default.umask);
             break;
+        case KVM_PMU_EVENT_FMT_X86_MASKED_ENTRY:
+            code = KVM_PMU_ENCODE_MASKED_ENTRY(
+                       event->u.x86_masked_entry.select,
+                       event->u.x86_masked_entry.mask,
+                       event->u.x86_masked_entry.match,
+                       event->u.x86_masked_entry.exclude ? 1 : 0);
+            break;
         default:
             g_assert_not_reached();
         }
@@ -5432,6 +5439,21 @@ static bool kvm_install_pmu_event_filter(KVMState *s)
         g_assert_not_reached();
     }
 
+    /*
+     * The check in kvm_arch_check_pmu_filter() ensures masked entry
+     * format won't be mixed with other formats.
+     */
+    kvm_filter->flags = filter->events->value->format ==
+                        KVM_PMU_EVENT_FMT_X86_MASKED_ENTRY ?
+                        KVM_PMU_EVENT_FLAG_MASKED_EVENTS : 0;
+
+    if (kvm_filter->flags == KVM_PMU_EVENT_FLAG_MASKED_EVENTS &&
+        !kvm_vm_check_extension(s, KVM_CAP_PMU_EVENT_MASKED_EVENTS)) {
+        error_report("Masked entry format of PMU event "
+                     "is not supported by Host.");
+        goto fail;
+    }
+
     if (!kvm_config_pmu_event(filter, kvm_filter)) {
         goto fail;
     }
@@ -6064,6 +6086,7 @@ static void kvm_arch_check_pmu_filter(const Object *obj, const char *name,
     KVMPMUFilter *filter = KVM_PMU_FILTER(child);
     KVMPMUFilterEventList *events = filter->events;
     KVMPMUFilterAction action;
+    uint32_t base_flag;
 
     if (!filter->nevents) {
         error_setg(errp,
@@ -6071,13 +6094,22 @@ static void kvm_arch_check_pmu_filter(const Object *obj, const char *name,
         return;
     }
 
+    /* Pick the first event's flag as the base one. */
+    base_flag = events->value->format ==
+                KVM_PMU_EVENT_FMT_X86_MASKED_ENTRY ?
+                KVM_PMU_EVENT_FLAG_MASKED_EVENTS : 0;
     action = KVM_PMU_FILTER_ACTION__MAX;
     while (events) {
         KVMPMUFilterEvent *event = events->value;
+        uint32_t flag;
 
         switch (event->format) {
         case KVM_PMU_EVENT_FMT_RAW:
         case KVM_PMU_EVENT_FMT_X86_DEFAULT:
+            flag = 0;
+            break;
+        case KVM_PMU_EVENT_FMT_X86_MASKED_ENTRY:
+            flag = KVM_PMU_EVENT_FLAG_MASKED_EVENTS;
             break;
         default:
             error_setg(errp,
@@ -6086,6 +6118,13 @@ static void kvm_arch_check_pmu_filter(const Object *obj, const char *name,
             return;
         }
 
+        if (flag != base_flag) {
+            error_setg(errp,
+                       "Masked entry format cannot be mixed with "
+                       "other formats.");
+            return;
+        }
+
         if (action == KVM_PMU_FILTER_ACTION__MAX) {
             action = event->action;
         } else if (action != event->action) {
-- 
2.34.1


