Return-Path: <kvm+bounces-57313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3868CB53192
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 13:58:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDA704859AF
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 11:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8772F3203BD;
	Thu, 11 Sep 2025 11:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9Kq2SBb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B0E3203B5
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 11:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757591868; cv=none; b=td371t7Oo8vCUlQhgLlcCll8v5cFSSXFy1hZDfiydFB55PH8ZU8/b0TfNtdSYQqC0ivPvHwKxZiSeEQfRmVciSG5Igy8fGMjI7JYOwYPg05/+oAGRfrCYCQYiQh0XJ6hbtvAlrFWfLEvMD1rKrb7lufI3rlGTNS+UgZ3aI40QNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757591868; c=relaxed/simple;
	bh=Q3CepnBB4cHosxsbgQq/BWCHIzMOIfZtr4L86ETM60c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1cvRfoaMuQTwecxiISNWD7Wp6t+kR7L1BKZebMrgDOXMfWP+yDL9wF7b2VUHE1/CgHyUamlpZmqi9t+F0V/LU6ovdPmEHNnC6A4hb3noIeyQv78snyh5ZOowlyKSzOnrkedj1BIwD1fyDD8Ri+A0IwIkgZnzCeMdLO30uc5MPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9Kq2SBb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67916C4CEF0;
	Thu, 11 Sep 2025 11:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757591867;
	bh=Q3CepnBB4cHosxsbgQq/BWCHIzMOIfZtr4L86ETM60c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9Kq2SBbcrBBgMPPopSCW8mK4WtaloHNpIkxibYgl7dxtwYYuFRYv1dfw9+tVjvsp
	 2NRdtenfxAPDguvFryFEASdoDoxHjLIcyBujCNdO0fx+YSFRyg4xAC+1eANefmxElQ
	 MnQyVnidCecqJQmtkbfRAs8N9GVzZgOucuwJCQNxuKMhVhK57HPER5trA/G/3UQm8w
	 aNrzbYLroM4Mt3BefQqNmhxOjZExFlYOo27gztca9eq43YHWhJhPtS6734qRSfyuu7
	 iB/UCZZwN8YUkgOK87u3bSg/kK+SpA41zpwCOOdXhmxRJS3x3vSHZEv7xv6pRkFh/u
	 JxeOHaL29eaKA==
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
Subject: [RFC PATCH 5/7] target/i386: SEV: Add support for enabling Secure TSC SEV feature
Date: Thu, 11 Sep 2025 17:24:24 +0530
Message-ID: <4c5ecb5835d8600e1b7b30fba2e36e1163b8da83.1757589490.git.naveen@kernel.org>
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

Add support for enabling Secure TSC VMSA SEV feature in SEV-SNP guests
through a new "secure-tsc" boolean property on SEV-SNP guest objects.

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
 qapi/qom.json     |  5 ++++-
 3 files changed, 18 insertions(+), 1 deletion(-)

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
index 3063ad2d077a..8f88df19a408 100644
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
index 71cd8ad588b5..b05a475ef499 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -1100,6 +1100,8 @@
 #     firmware.  Set this to true to disable the use of VCEK.
 #     (default: false) (since: 9.1)
 #
+# @secure-tsc: enable Secure TSC (default: false) (since 10.2)
+#
 # Since: 9.1
 ##
 { 'struct': 'SevSnpGuestProperties',
@@ -1111,7 +1113,8 @@
             '*id-auth': 'str',
             '*author-key-enabled': 'bool',
             '*host-data': 'str',
-            '*vcek-disabled': 'bool' } }
+            '*vcek-disabled': 'bool',
+            '*secure-tsc': 'bool' } }
 
 ##
 # @TdxGuestProperties:
-- 
2.50.1


