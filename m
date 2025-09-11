Return-Path: <kvm+bounces-57314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20378B53193
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 13:58:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF110485C77
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 11:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA9E92D0612;
	Thu, 11 Sep 2025 11:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bLBIDwTY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01816320A0F
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 11:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757591872; cv=none; b=D419G1hs+cKtbMCvuqvsiaNM9up068mlsbhH2GCXfU5XXShK/s2zqIQV5uBP3/2XUyXNk4a9ZY1/iOZyfx3kt97KloUZoh1fNG84lXT+ucFaGGF2LiiI5aRJ1OWGBofnePy+5xzJgXstgK70H09nLxNzKX3iieZjNVWhwtrwAY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757591872; c=relaxed/simple;
	bh=lqDFC3PoMqY9bhdEGeCOP+WTgMv8uQWnXYCTLdQ56bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9gsX3LZ06SVrPCvAcJwraA4sKH6ESm7eOjr3Bs8qpIGrhGlfD0m9uJnYNO9ebaBUfE4CxUffqRZmOXTYZPXRATLwDf03mqAzAHiVItJwBTglukfA2BMeE0TqMUayl3BS7cuTb7TOeF4JDm5KZtYbWDogrY/L82ZWxM2hJ5GLJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bLBIDwTY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F4AC4CEF0;
	Thu, 11 Sep 2025 11:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757591871;
	bh=lqDFC3PoMqY9bhdEGeCOP+WTgMv8uQWnXYCTLdQ56bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLBIDwTY0eNGv0Rr5xkjt5j4BPbo5qRqjI1sv8UwH5yx/2EHnVBEd17rk0LVJcVga
	 jw5b/TVri/bbUHZDBtxIVH1r3NxK6rf0hI8zSKVU0/reB2wLuIdIZkYqZBh2Y8X+dc
	 x/CAvloeKHvhF/mGC7Ajb1TRf0deMrxCbpIK4IzO5OKOcrUcdlEww30AWoSbWK6Ui3
	 OJvQsPJGQi6234x5baxPkeegfv3XMGUgHyggnMyhBBkL9VIN554o2Gw9S9xLjSsPRy
	 YLWiEtz/1RI/D/6zLk8VkuavrVazlUIc9YF7wZLJ6uy6GKx9iXMdj+06r/eYv4YI3w
	 aGNL1pvj4V+kQ==
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
	Roy Hopkins <roy.hopkins@randomman.co.uk>,
	Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Subject: [RFC PATCH 6/7] target/i386: SEV: Add support for setting TSC frequency for Secure TSC
Date: Thu, 11 Sep 2025 17:24:25 +0530
Message-ID: <23a293fca3e2ac22c7da052123e27c2794f40932.1757589490.git.naveen@kernel.org>
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

Add support for configuring the TSC frequency when Secure TSC is enabled
in SEV-SNP guests through a new "tsc-frequency" property on SEV-SNP
guest objects, similar to the vCPU-specific property used by regular
guests and TDX. A new property is needed since SEV-SNP guests require
the TSC frequency to be specified during early SNP_LAUNCH_START command
before any vCPUs are created.

The user-provided TSC frequency is set through KVM_SET_TSC_KHZ before
issuing KVM_SEV_SNP_LAUNCH_START.

Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 target/i386/sev.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 qapi/qom.json     |  6 +++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 8f88df19a408..facf51c810d9 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -178,6 +178,7 @@ struct SevSnpGuestState {
     char *id_auth_base64;
     uint8_t *id_auth;
     char *host_data;
+    uint32_t tsc_khz;
 
     struct kvm_sev_snp_launch_start kvm_start_conf;
     struct kvm_sev_snp_launch_finish kvm_finish_conf;
@@ -536,6 +537,13 @@ static int check_sev_features(SevCommonState *sev_common, uint64_t sev_features,
                    __func__, sev_features, sev_common->supported_sev_features);
         return -1;
     }
+    if (sev_snp_enabled() && SEV_SNP_GUEST(sev_common)->tsc_khz &&
+        !(sev_features & SVM_SEV_FEAT_SECURE_TSC)) {
+        error_setg(errp,
+                   "%s: TSC frequency can only be set if Secure TSC is enabled",
+                   __func__);
+        return -1;
+    }
     return 0;
 }
 
@@ -1085,6 +1093,18 @@ sev_snp_launch_start(SevCommonState *sev_common)
             return 1;
     }
 
+    if (is_sev_feature_set(sev_common, SVM_SEV_FEAT_SECURE_TSC)) {
+        rc = -EINVAL;
+        if (kvm_check_extension(kvm_state, KVM_CAP_VM_TSC_CONTROL)) {
+            rc = kvm_vm_ioctl(kvm_state, KVM_SET_TSC_KHZ, sev_snp_guest->tsc_khz);
+        }
+        if (rc < 0) {
+            error_report("%s: Unable to set Secure TSC frequency to %u kHz ret=%d",
+                         __func__, sev_snp_guest->tsc_khz, rc);
+            return 1;
+        }
+    }
+
     rc = sev_ioctl(sev_common->sev_fd, KVM_SEV_SNP_LAUNCH_START,
                    start, &fw_error);
     if (rc < 0) {
@@ -3127,6 +3147,28 @@ static void sev_snp_guest_set_secure_tsc(Object *obj, bool value, Error **errp)
     sev_set_feature(SEV_COMMON(obj), SVM_SEV_FEAT_SECURE_TSC, value);
 }
 
+static void
+sev_snp_guest_get_tsc_frequency(Object *obj, Visitor *v, const char *name,
+                                void *opaque, Error **errp)
+{
+    uint32_t value = SEV_SNP_GUEST(obj)->tsc_khz * 1000;
+
+    visit_type_uint32(v, name, &value, errp);
+}
+
+static void
+sev_snp_guest_set_tsc_frequency(Object *obj, Visitor *v, const char *name,
+                                void *opaque, Error **errp)
+{
+    uint32_t value;
+
+    if (!visit_type_uint32(v, name, &value, errp)) {
+        return;
+    }
+
+    SEV_SNP_GUEST(obj)->tsc_khz = value / 1000;
+}
+
 static void
 sev_snp_guest_class_init(ObjectClass *oc, const void *data)
 {
@@ -3165,6 +3207,9 @@ sev_snp_guest_class_init(ObjectClass *oc, const void *data)
     object_class_property_add_bool(oc, "secure-tsc",
                                   sev_snp_guest_get_secure_tsc,
                                   sev_snp_guest_set_secure_tsc);
+    object_class_property_add(oc, "tsc-frequency", "uint32",
+                              sev_snp_guest_get_tsc_frequency,
+                              sev_snp_guest_set_tsc_frequency, NULL, NULL);
 }
 
 static void
diff --git a/qapi/qom.json b/qapi/qom.json
index b05a475ef499..5b99148cb790 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -1102,6 +1102,9 @@
 #
 # @secure-tsc: enable Secure TSC (default: false) (since 10.2)
 #
+# @tsc-frequency: set secure TSC frequency. Only valid if Secure TSC
+#     is enabled (default: zero) (since 10.2)
+#
 # Since: 9.1
 ##
 { 'struct': 'SevSnpGuestProperties',
@@ -1114,7 +1117,8 @@
             '*author-key-enabled': 'bool',
             '*host-data': 'str',
             '*vcek-disabled': 'bool',
-            '*secure-tsc': 'bool' } }
+            '*secure-tsc': 'bool',
+            '*tsc-frequency': 'uint32' } }
 
 ##
 # @TdxGuestProperties:
-- 
2.50.1


