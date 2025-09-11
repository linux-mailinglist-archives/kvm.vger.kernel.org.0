Return-Path: <kvm+bounces-57311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A290B53190
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 13:58:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 855AD1B27073
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 11:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E865431E117;
	Thu, 11 Sep 2025 11:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NFpBqLtg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7ED2D0612
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 11:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757591859; cv=none; b=Fbom9yJ7O4lHJ9lrOci9Ls7705CwQ8QI4WVtfETYLvqh4/gD5GxJ8T2gplTcJlHZF65keC2EkuXJHIGqeK7z4FJfBLThOdnUaAwT3ApuT7Tbk4Lpg3Dp4NZ6USvGO4Z61ts8i9YS5Yt90E7e1s303E5RCEhLhrg8DQV+033ZcAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757591859; c=relaxed/simple;
	bh=I3D/RCo9dBe/+uHLQzw9ngK0cT2br+oK6Tf6IcL4Lms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1aNEXnYTg99UGStRR/gaq0MWFfFv8pmLLFMoDbTq2Z3Dsg7YFrAOkmZ2TQnnVElUsoOBAGqZn98j5LXlQHB3kbQdhl8izKFUrO0dWY5rSVu3DSv9xlISBfSkiMOqzBBqO4M7SITy9ZSPzFUND5dNFtlAQigr7q/lgUkBXZ/IA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NFpBqLtg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866E3C4CEF0;
	Thu, 11 Sep 2025 11:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757591858;
	bh=I3D/RCo9dBe/+uHLQzw9ngK0cT2br+oK6Tf6IcL4Lms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFpBqLtgJlxOnPhGzDOUqGCLkqjzdF6Ato/12zvO+VzqgyIrbSdMidqC7cmDLXviO
	 lxq7c0wPB/zqeVTgZWwGdidDtDIlHZt37KzgBOSwt67Dh6y/EWD5NfYpowosOxU3vL
	 B2rVGJ5iCG+G7jZ1WITzuqe5gnWcJ7d7e1eMcjMYXM1wi9aiy5bWPc0hf8/gbQfELm
	 PO6FFRprnLiUFJ+W3LlkhxuhzDTIE8z7LLLyYSL1FjMFxdTXMcC1zayY1WR7e1FnLW
	 uyppU8UfpVsZRu7SynRp5cnwmMr9NUmzJTXxBHDAP1fyNHDF0x1zjzxzrbBBuFUtZt
	 stDkUWXgevvlQ==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: qemu-devel <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>,
	"Daniel P. Berrange" <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Neeraj Upadhyay <neeraj.upadhyay@amd.com>,
	Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: [RFC PATCH 3/7] target/i386: SEV: Add support for enabling debug-swap SEV feature
Date: Thu, 11 Sep 2025 17:24:22 +0530
Message-ID: <0a77cf472bc36fee7c1be78fc7d6d514d22bca9a.1757589490.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1757589490.git.naveen@kernel.org>
References: <cover.1757589490.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for enabling debug-swap VMSA SEV feature in SEV-ES and
SEV-SNP guests through a new "debug-swap" boolean property on SEV guest
objects. Though the boolean property is available for plain SEV guests,
check_sev_features() will reject setting this for plain SEV guests.

Add helpers for setting and querying the VMSA SEV features so that they
can be re-used for subsequent VMSA SEV features, and convert the
existing SVM_SEV_FEAT_SNP_ACTIVE definition to use the BIT() macro for
consistency with the new feature flag.

Sample command-line:
  -machine q35,confidential-guest-support=sev0 \
  -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,debug-swap=on

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 target/i386/sev.h |  3 ++-
 target/i386/sev.c | 29 +++++++++++++++++++++++++++++
 qapi/qom.json     |  6 +++++-
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/target/i386/sev.h b/target/i386/sev.h
index 9db1a802f6bb..8e09b2ce1976 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -44,7 +44,8 @@ bool sev_snp_enabled(void);
 #define SEV_SNP_POLICY_SMT      0x10000
 #define SEV_SNP_POLICY_DBG      0x80000
 
-#define SVM_SEV_FEAT_SNP_ACTIVE 1
+#define SVM_SEV_FEAT_SNP_ACTIVE     BIT(0)
+#define SVM_SEV_FEAT_DEBUG_SWAP     BIT(5)
 
 typedef struct SevKernelLoaderContext {
     char *setup_data;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index fa23b5c38e9b..b3e4d0f2c1d5 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -319,6 +319,20 @@ sev_set_guest_state(SevCommonState *sev_common, SevState new_state)
     sev_common->state = new_state;
 }
 
+static bool is_sev_feature_set(SevCommonState *sev_common, uint64_t feature)
+{
+    return !!(sev_common->sev_features & feature);
+}
+
+static void sev_set_feature(SevCommonState *sev_common, uint64_t feature, bool value)
+{
+    if (value) {
+        sev_common->sev_features |= feature;
+    } else {
+        sev_common->sev_features &= ~feature;
+    }
+}
+
 static void
 sev_ram_block_added(RAMBlockNotifier *n, void *host, size_t size,
                     size_t max_size)
@@ -2732,6 +2746,16 @@ static int cgs_set_guest_policy(ConfidentialGuestPolicyType policy_type,
     return 0;
 }
 
+static bool sev_common_get_debug_swap(Object *obj, Error **errp)
+{
+    return is_sev_feature_set(SEV_COMMON(obj), SVM_SEV_FEAT_DEBUG_SWAP);
+}
+
+static void sev_common_set_debug_swap(Object *obj, bool value, Error **errp)
+{
+    sev_set_feature(SEV_COMMON(obj), SVM_SEV_FEAT_DEBUG_SWAP, value);
+}
+
 static void
 sev_common_class_init(ObjectClass *oc, const void *data)
 {
@@ -2749,6 +2773,11 @@ sev_common_class_init(ObjectClass *oc, const void *data)
                                    sev_common_set_kernel_hashes);
     object_class_property_set_description(oc, "kernel-hashes",
             "add kernel hashes to guest firmware for measured Linux boot");
+    object_class_property_add_bool(oc, "debug-swap",
+                                   sev_common_get_debug_swap,
+                                   sev_common_set_debug_swap);
+    object_class_property_set_description(oc, "debug-swap",
+            "enable virtualization of debug registers");
 }
 
 static void
diff --git a/qapi/qom.json b/qapi/qom.json
index 830cb2ffe781..71cd8ad588b5 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -1010,13 +1010,17 @@
 #     designated guest firmware page for measured boot with -kernel
 #     (default: false) (since 6.2)
 #
+# @debug-swap: enable virtualization of debug registers (default: false)
+#              (since 10.2)
+#
 # Since: 9.1
 ##
 { 'struct': 'SevCommonProperties',
   'data': { '*sev-device': 'str',
             '*cbitpos': 'uint32',
             'reduced-phys-bits': 'uint32',
-            '*kernel-hashes': 'bool' } }
+            '*kernel-hashes': 'bool',
+            '*debug-swap': 'bool' } }
 
 ##
 # @SevGuestProperties:
-- 
2.50.1


