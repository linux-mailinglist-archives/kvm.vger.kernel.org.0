Return-Path: <kvm+bounces-58734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AC56B9EA9A
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:31:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D24C67B6C98
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:28:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFE9B2ED843;
	Thu, 25 Sep 2025 10:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V+PoQa9v"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69AB2EC57B
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758796114; cv=none; b=JnQISflI4RCOMnYrURz1RPW8d8I9kpvmZ2hqEB0slPHRy9fpzv6CM4vgwrh2rsONSvNClNFkP3gVncZuQ2gwos0b6wweFdJ7usw/ZM6pKqJgORJ4QDa94emDCdsCZdAvYtCr2DZQV7HEukqB/I8K6HNuU5PH19UvDW6vTHCKEQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758796114; c=relaxed/simple;
	bh=66MPz/kZ5VYubvKvzrX3KPVZW96GhE0LtThIizkq+7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbdkCpK+7jPFrhKMunEFUFiY2uj5HHTygvOkm1ledhHfAUdB+bqHTivAF9X4SdgXYfmAI/Clmy+J86NmsW5vLcnBJQTLxGYXoOGNLQWh7F04QdysUeMLqqUanvQaUtI4Wn0RcCXpms4+fmLB92Icq83cBrz65eDeD/zFqyBHIcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V+PoQa9v; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110D2C4CEF0;
	Thu, 25 Sep 2025 10:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758796113;
	bh=66MPz/kZ5VYubvKvzrX3KPVZW96GhE0LtThIizkq+7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+PoQa9vxi1puotgt9Xp4O7Y6Wf0qteXCbIlufLMLuvVp2RaqbvwVn/FQe327mToe
	 wJKG5hTs0tqfBV4kzSWT3lKbD3yImpUSBE5XkQM/vGVZ9DXU+0YVF8CLXbfQmFK36R
	 0KX7jMLTNhmQeaZ5eiPSsbVsSdBImT6hlaQAUIa9Ya/OIxIfZHYKDqjqVsxpXkW9zV
	 LB968jyhKTdzGKb7XBI1MmCOdzoQUGenzwRM2gytiXeD93YKBiLQGZKO0pMmbPYTfZ
	 ziJUMfSsMEuliDHBxJt4WSWSMo8wHco1gcuwlUA7BhUNIbxmYBPl0n89t9xUAsIcfa
	 5COY1FaoXXepQ==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Daniel P. Berrange" <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: [PATCH v2 6/9] target/i386: SEV: Add support for enabling debug-swap SEV feature
Date: Thu, 25 Sep 2025 15:47:35 +0530
Message-ID: <4f0f28154342d562e76107dfd60ed3a02665fbfe.1758794556.git.naveen@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758794556.git.naveen@kernel.org>
References: <cover.1758794556.git.naveen@kernel.org>
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

Though this SEV feature is called "Debug virtualization" in the APM, KVM
calls this "debug swap" so use the same name for consistency.

Sample command-line:
  -machine q35,confidential-guest-support=sev0 \
  -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,debug-swap=on

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 target/i386/sev.h |  1 +
 target/i386/sev.c | 20 ++++++++++++++++++++
 qapi/qom.json     |  6 +++++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/target/i386/sev.h b/target/i386/sev.h
index 102546b112d6..8e09b2ce1976 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -45,6 +45,7 @@ bool sev_snp_enabled(void);
 #define SEV_SNP_POLICY_DBG      0x80000
 
 #define SVM_SEV_FEAT_SNP_ACTIVE     BIT(0)
+#define SVM_SEV_FEAT_DEBUG_SWAP     BIT(5)
 
 typedef struct SevKernelLoaderContext {
     char *setup_data;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 88dd0750d481..e9d84ea25571 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -319,6 +319,11 @@ sev_set_guest_state(SevCommonState *sev_common, SevState new_state)
     sev_common->state = new_state;
 }
 
+static bool is_sev_feature_set(SevCommonState *sev_common, uint64_t feature)
+{
+    return !!(sev_common->sev_features & feature);
+}
+
 static void sev_set_feature(SevCommonState *sev_common, uint64_t feature, bool set)
 {
     if (set) {
@@ -2744,6 +2749,16 @@ static int cgs_set_guest_policy(ConfidentialGuestPolicyType policy_type,
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
@@ -2761,6 +2776,11 @@ sev_common_class_init(ObjectClass *oc, const void *data)
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
index 830cb2ffe781..df962d4a5215 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -1010,13 +1010,17 @@
 #     designated guest firmware page for measured boot with -kernel
 #     (default: false) (since 6.2)
 #
+# @debug-swap: enable virtualization of debug registers
+#     (default: false) (since 10.2)
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
2.51.0


