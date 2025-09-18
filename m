Return-Path: <kvm+bounces-57994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56E25B841BC
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 12:33:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 830E47204A8
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 10:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3FA52F60D1;
	Thu, 18 Sep 2025 10:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="imMxmRMO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185A82F5A09
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 10:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758191423; cv=none; b=WHWHYFWGUYhUmNdHRY6sFuZP31M/pTegzevFbV+8ns9hxegeJQuLLN6GMDEXILusMXKMwAXvbiQ+64AD6URiUdroDuUCXtZcWBo3M5hmGeLWZAsNHX3sxBD3edzTh3KHi98U+hwVCoSB0YCYhEm+vda9gd/6vBWr7Whj5szzS3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758191423; c=relaxed/simple;
	bh=iInPTCFj8UCEpOkf584ztFBgNmedO/q1q8XQk2av7F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bg48n27cWPCi9i59Dk9O8ZQQJ/z8WnHQNGPflRbRbKvU2eQ+WRHZqXXRWAq9ecoIKL4fhgUfRB3f/zTurUirDKQcV0SMMMoV9WWii/1QqNVlX7ogxzwjQeS79FDiXpzCqoWY2ATit4dBzxRzI3KnLwaYWDpxuvE+s8MENk9KjGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=imMxmRMO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F2FC4CEF7;
	Thu, 18 Sep 2025 10:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758191423;
	bh=iInPTCFj8UCEpOkf584ztFBgNmedO/q1q8XQk2av7F0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imMxmRMOFucVmbbnIljCOoD604kUGRxR+4MK5CZy9169s2vPHOhaFxj6UcmLNuhk0
	 kj2BDLbHIUMoEkXMWPTRXj3D0kSpSWoKI0bj7e1cltPjUSdK2HLNAElEOka/iTzbEL
	 bTM+fpCgOZZ1TtghcV8L/VQOKYTxm6aP4QOvzVti3Go4Ow8lDJl9E+lVw1Axq26pdE
	 N7IFCNQVgdCpz9p2nB39W4qasnNKYDAgyvn6hgxjtOH5mFj70Z2vPlPwKxFEc8HRTd
	 pRr3vFzWo8f9Nrb64QB25A8NccjnjoSDmQlurtZ6qcqe15VFlzdU1RFqiDKQCN4Hbe
	 5SWgV/6JVI+rg==
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
Subject: [PATCH 3/8] target/i386: SEV: Consolidate SEV feature validation to common init path
Date: Thu, 18 Sep 2025 15:57:01 +0530
Message-ID: <eba12d94afd504ff87d25b9426a4a4e74c3a0c70.1758189463.git.naveen@kernel.org>
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

Currently, check_sev_features() is called in multiple places when
processing IGVM files: both when processing the initial VMSA SEV
features from IGVM, as well as when validating the full contents of the
VMSA. Move this to a single point in sev_common_kvm_init() to simplify
the flow, as well as to re-use this function when VMSA SEV features are
being set without using IGVM files.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 target/i386/sev.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index c4011a6f2ef7..7c4cd1146b9a 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -595,9 +595,6 @@ static int check_vmsa_supported(SevCommonState *sev_common, hwaddr gpa,
     vmsa_check.x87_fcw = 0;
     vmsa_check.mxcsr = 0;
 
-    if (check_sev_features(sev_common, vmsa_check.sev_features, errp) < 0) {
-        return -1;
-    }
     vmsa_check.sev_features = 0;
 
     if (!buffer_is_zero(&vmsa_check, sizeof(vmsa_check))) {
@@ -1913,6 +1910,10 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
             }
         }
 
+        if (check_sev_features(sev_common, sev_common->sev_features, errp) < 0) {
+            return -1;
+        }
+
         /*
          * KVM maintains a bitmask of allowed sev_features. This does not
          * include SVM_SEV_FEAT_SNP_ACTIVE which is set accordingly by KVM
@@ -2532,9 +2533,6 @@ static int cgs_set_guest_state(hwaddr gpa, uint8_t *ptr, uint64_t len,
                            __func__);
                 return -1;
             }
-            if (check_sev_features(sev_common, sa->sev_features, errp) < 0) {
-                return -1;
-            }
             sev_common->sev_features = sa->sev_features;
         }
         return 0;
-- 
2.51.0


