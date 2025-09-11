Return-Path: <kvm+bounces-57315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F173FB53194
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 13:58:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B1C71B27221
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 11:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B572E320CAC;
	Thu, 11 Sep 2025 11:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1ntO9aE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FDA320A1C
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 11:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757591877; cv=none; b=Uu5RpyegJ6+WsxP8XTrqOhTysJ4oUdNc8FYSDIhS7ogrbF12NJx+7cBKPYLVT787PbdbGCcAAH5xRcOdS6pIsU6DdHixhwvOHG3Vqtr79fCTL2Tj4FstsgD1xASOlVMkDHhV0qEbEm/b0JWE+w11AiddVABg/qnkqeSfiTcTXa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757591877; c=relaxed/simple;
	bh=7HOJXed/grVIwqxVnBC0UOQowTK5L/FCl7Cie6uBUm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reaWFv/mOJU7BGQ8b/YGJCm3NacgPoVKG3BriDF5VDFP3FAOY5ymEBE96izQxOdax9z0S+gRJoD0eDAQk2RweCN6xg+cKzvrWCMloUgnBQA8x0ykt0sABOtNoSVA0oQL3uG4r4XVHVux5Yz/clKEs6EMwncggj1vSGDCKYBG97s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1ntO9aE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B73C4CEF0;
	Thu, 11 Sep 2025 11:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757591877;
	bh=7HOJXed/grVIwqxVnBC0UOQowTK5L/FCl7Cie6uBUm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1ntO9aEo82Qc78/YNeyI6LSQHMMSt10UyA//C2B2KcD0FLcWLj18okAIoyxhZ4LM
	 sxbA1oBVssrhDk6VCVyEh/Q75omSlQw04GBqJzB9ZyLsXdeh8u3yLFaGo0ixvV+tW+
	 k2uRaFFE0EIcOeGLjf3PT/NY8NyJBaZcFNfqeQjGBziSs217O57pipb+fZpjanrYFL
	 MdJKEqA+FvP3sgqZKdnzSDuChWOP3DvsnY8ixHeRohuWXmc1J1M/S+8ccp9H3m738D
	 rPNQ6KWdsAEcPSCcWKJRoxdDIPZxQWaICJ/aEFwvjPmy0qZHrB8CSfw1U3TWtTD6nk
	 MDpIinpFepTIw==
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
Subject: [RFC PATCH 7/7] target/i386: SEV: Add support for enabling Secure AVIC SEV feature
Date: Thu, 11 Sep 2025 17:24:26 +0530
Message-ID: <632eaad0ef28943520a1285c8efb3d8a756e4624.1757589490.git.naveen@kernel.org>
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

Add support for enabling Secure AVIC VMSA SEV feature in SEV-SNP guests
through a new "secure-avic" boolean property on SEV-SNP guest objects.

Sample command-line:
  -machine q35,confidential-guest-support=sev0 \
  -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-avic=on

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 target/i386/sev.h |  1 +
 target/i386/sev.c | 13 +++++++++++++
 qapi/qom.json     |  5 ++++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/target/i386/sev.h b/target/i386/sev.h
index 87e73034ad15..a374c144bccd 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -47,6 +47,7 @@ bool sev_snp_enabled(void);
 #define SVM_SEV_FEAT_SNP_ACTIVE     BIT(0)
 #define SVM_SEV_FEAT_DEBUG_SWAP     BIT(5)
 #define SVM_SEV_FEAT_SECURE_TSC     BIT(9)
+#define SVM_SEV_FEAT_SECURE_AVIC    BIT(16)
 
 typedef struct SevKernelLoaderContext {
     char *setup_data;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index facf51c810d9..f9170e21ca57 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -3147,6 +3147,16 @@ static void sev_snp_guest_set_secure_tsc(Object *obj, bool value, Error **errp)
     sev_set_feature(SEV_COMMON(obj), SVM_SEV_FEAT_SECURE_TSC, value);
 }
 
+static bool sev_snp_guest_get_secure_avic(Object *obj, Error **errp)
+{
+    return is_sev_feature_set(SEV_COMMON(obj), SVM_SEV_FEAT_SECURE_AVIC);
+}
+
+static void sev_snp_guest_set_secure_avic(Object *obj, bool value, Error **errp)
+{
+    sev_set_feature(SEV_COMMON(obj), SVM_SEV_FEAT_SECURE_AVIC, value);
+}
+
 static void
 sev_snp_guest_get_tsc_frequency(Object *obj, Visitor *v, const char *name,
                                 void *opaque, Error **errp)
@@ -3210,6 +3220,9 @@ sev_snp_guest_class_init(ObjectClass *oc, const void *data)
     object_class_property_add(oc, "tsc-frequency", "uint32",
                               sev_snp_guest_get_tsc_frequency,
                               sev_snp_guest_set_tsc_frequency, NULL, NULL);
+    object_class_property_add_bool(oc, "secure-avic",
+                                  sev_snp_guest_get_secure_avic,
+                                  sev_snp_guest_set_secure_avic);
 }
 
 static void
diff --git a/qapi/qom.json b/qapi/qom.json
index 5b99148cb790..5dce560a2f54 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -1105,6 +1105,8 @@
 # @tsc-frequency: set secure TSC frequency. Only valid if Secure TSC
 #     is enabled (default: zero) (since 10.2)
 #
+# @secure-avic: enable Secure AVIC (default: false) (since 10.2)
+#
 # Since: 9.1
 ##
 { 'struct': 'SevSnpGuestProperties',
@@ -1118,7 +1120,8 @@
             '*host-data': 'str',
             '*vcek-disabled': 'bool',
             '*secure-tsc': 'bool',
-            '*tsc-frequency': 'uint32' } }
+            '*tsc-frequency': 'uint32',
+            '*secure-avic': 'bool' } }
 
 ##
 # @TdxGuestProperties:
-- 
2.50.1


