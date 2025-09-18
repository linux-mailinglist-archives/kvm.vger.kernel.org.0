Return-Path: <kvm+bounces-57998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28472B841DD
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 12:34:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 666F317EB81
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 10:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDDD43043A1;
	Thu, 18 Sep 2025 10:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRivwrlF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EEE303A29
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 10:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758191443; cv=none; b=V+O64rJ1IE1NixZ12G+bBNrEXWZxBz7PXz+8QRrmASIgbBDP3z7zWMayikE3mE7EjnPTylptu3tv4F+v+IraubmDnqMUEcjBSMJ72O8WfqJ0cwxfl8GvFZ9L5XRP9GXyUzXXAm2A46j6pajT1B/2dPAjWt3GcCR1kxr0txxxcYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758191443; c=relaxed/simple;
	bh=WQk9MBDv7nge73LxcacIBKkMtT+aMc7tLLXhrGU/S2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOcDNTKn0vU2aV970mIqnkb4kdirWedCABJI44E9CMti9mnf+s/4dBK0LzffPiXUVHuT85yTc9eTw9YAJ935DrVFXJ5uPLX5PVLxe9IDXPs+s4XNW2LWmMbHBIDRNYz5S9F4cIXe/sSxl2lwUsMRLWbwJgDFYZT9b2kDHnIjnRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRivwrlF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCC2C4CEFE;
	Thu, 18 Sep 2025 10:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758191442;
	bh=WQk9MBDv7nge73LxcacIBKkMtT+aMc7tLLXhrGU/S2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRivwrlFpEdBE9zknDmPdHKbYcPZ0PDWvVe9w4+L62Fx9C1AnE9cuyOppiXwteHKc
	 3zq46P/m1t0vXAUMUqRH0BsokBHBTvWqEJ92tbV4s1xrYu2zesOwqa1pAUm5KFmR7R
	 3lw+yG5n7bb09WXGGcJOTFHGyLfBXiwnsAgG/g5Z7Ol2pyxmHNfVwisELciCxMOt51
	 HQySSWhCw31+MFqMgydqFOvd51CGiyx6/5OWX1iYkjV+Rfat6flCLF3OfZm3wlioDt
	 6/fkG8/FnqQm22VOoCs0TL6piRKvNl0oRFSP50khi2Nb6eUremK+GjuFkgrnMvDHQq
	 B3Hd3W2YClWaw==
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
Subject: [PATCH 7/8] target/i386: SEV: Add support for enabling Secure TSC SEV feature
Date: Thu, 18 Sep 2025 15:57:05 +0530
Message-ID: <9ef2a9ef63f4737efe7a926703222b6bf51b7bad.1758189463.git.naveen@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758189463.git.naveen@kernel.org>
References: <cover.1758189463.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for enabling Secure TSC VMSA SEV feature in SEV-SNP guests
through a new "secure-tsc" boolean property on SEV-SNP guest objects. By
default, KVM uses the host TSC frequency for Secure TSC.

Sample command-line:
  -machine q35,confidential-guest-support=sev0 \
  -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on

Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 target/i386/sev.h |  1 +
 target/i386/sev.c | 13 +++++++++++++
 qapi/qom.json     |  6 +++++-
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/target/i386/sev.h b/target/i386/sev.h
index 8e09b2ce1976..87e73034ad15 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -46,6 +46,7 @@ bool sev_snp_enabled(void);
 
 #define SVM_SEV_FEAT_SNP_ACTIVE     BIT(0)
 #define SVM_SEV_FEAT_DEBUG_SWAP     BIT(5)
+#define SVM_SEV_FEAT_SECURE_TSC     BIT(9)
 
 typedef struct SevKernelLoaderContext {
     char *setup_data;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 6b11359f06dd..679bedb63c3a 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -3117,6 +3117,16 @@ sev_snp_guest_set_host_data(Object *obj, const char *value, Error **errp)
     memcpy(finish->host_data, blob, len);
 }
 
+static bool sev_snp_guest_get_secure_tsc(Object *obj, Error **errp)
+{
+    return is_sev_feature_set(SEV_COMMON(obj), SVM_SEV_FEAT_SECURE_TSC);
+}
+
+static void sev_snp_guest_set_secure_tsc(Object *obj, bool value, Error **errp)
+{
+    sev_set_feature(SEV_COMMON(obj), SVM_SEV_FEAT_SECURE_TSC, value);
+}
+
 static void
 sev_snp_guest_class_init(ObjectClass *oc, const void *data)
 {
@@ -3152,6 +3162,9 @@ sev_snp_guest_class_init(ObjectClass *oc, const void *data)
     object_class_property_add_str(oc, "host-data",
                                   sev_snp_guest_get_host_data,
                                   sev_snp_guest_set_host_data);
+    object_class_property_add_bool(oc, "secure-tsc",
+                                  sev_snp_guest_get_secure_tsc,
+                                  sev_snp_guest_set_secure_tsc);
 }
 
 static void
diff --git a/qapi/qom.json b/qapi/qom.json
index df962d4a5215..52c23e85e349 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -1100,6 +1100,9 @@
 #     firmware.  Set this to true to disable the use of VCEK.
 #     (default: false) (since: 9.1)
 #
+# @secure-tsc: enable Secure TSC
+#     (default: false) (since 10.2)
+#
 # Since: 9.1
 ##
 { 'struct': 'SevSnpGuestProperties',
@@ -1111,7 +1114,8 @@
             '*id-auth': 'str',
             '*author-key-enabled': 'bool',
             '*host-data': 'str',
-            '*vcek-disabled': 'bool' } }
+            '*vcek-disabled': 'bool',
+            '*secure-tsc': 'bool' } }
 
 ##
 # @TdxGuestProperties:
-- 
2.51.0


