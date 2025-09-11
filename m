Return-Path: <kvm+bounces-57316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17DC9B53195
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 13:58:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D0B11B271AF
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 11:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FA4B320CB4;
	Thu, 11 Sep 2025 11:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="si55fs3t"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F0431DD83
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 11:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757591882; cv=none; b=QA80pfTSf+YtONFVMeI5AeCQno8o+MoQQABMym6lJA9VdX4/PIr/W3uS73EtuFpAwtKwfHFL98qhEskPp/6gIEB5Fc+hiPJuH+O8tySdhVH4yOrsMoKMkX5lbXrg1wT86l61FdkhxoL9xu2+P0B8dXa568Ah7IBuvxfDJoZcdIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757591882; c=relaxed/simple;
	bh=/D55pFyt3VJdmuGX0Hft3q3YJw6AKpeKJBy5hh1wrNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwM2LjZi1ZUcMUhOkgZXo9dlGIY8lmEzhuEvaE9fEpZ/ZND05pWABAUQMLqN5PizZ0cAPsuKU00svgTg4WCJ7t/f/RPqShTrf8UY7v1nG2wAjxEZ13gYcce6kuJ1n/K1ymF7T0bkjh7Sto7WYd9vHiPSp1s+y8ClwP4dRPs252o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=si55fs3t; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8952CC4CEF1;
	Thu, 11 Sep 2025 11:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757591881;
	bh=/D55pFyt3VJdmuGX0Hft3q3YJw6AKpeKJBy5hh1wrNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=si55fs3taRGv6SAX3cphNIIaluOEZV9VQnKLgYUNGSmXMaNchVlUd+JsPJ2xwRiH8
	 zwH6MXBgSOZRGaP4LPMkkQhyde1HwI8aHaKga9zE3IjfC5RZUkmv4onCzhiGPP02UX
	 enhtrEf8Iaae5HK5+5vS+BnHyKz3Bx5Dx5X/jQUriX+6WYd4QVc35fi/N0evXgKXry
	 GLmfdagiyDawSQmpxtB7XHDWFUfV/bJRlziv2YQ+BLgNQnfIfKsCLrwqqUhRe29yXw
	 4rVtjJdnrKQyz5EUu395/OcvyurmkfpmHGOA6mM/N96kLdsOSAqRXfi+UMLvMYmpL/
	 XPfcoggS7JszA==
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
Subject: [RFC PATCH 1/7] target/i386: SEV: Consolidate SEV feature validation to common init path
Date: Thu, 11 Sep 2025 17:24:20 +0530
Message-ID: <bd64baf06e483cf8df0f7b0f98cf5ad3dd5bff80.1757589490.git.naveen@kernel.org>
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

Currently, check_sev_features() is called in multiple places when
processing IGVM files: both when processing the initial VMSA SEV
features from IGVM, as well as when validating the full contents of the
VMSA. Move this to a single point in sev_common_kvm_init() to simplify
the flow, as well as to re-use this function when VMSA SEV features are
being set without using IGVM files.

Since check_sev_features() relies on SVM_SEV_FEAT_SNP_ACTIVE being set
in VMSA SEV features depending on the guest type, set this flag by
default when creating SEV-SNP guests. When using IGVM files, this field
is anyway over-written so that validation in check_sev_features() is
still relevant.

Finally, add a check to ensure SEV features aren't also set through qemu
cli if using IGVM files.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 target/i386/sev.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 1057b8ab2c60..243e9493ba8d 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -586,9 +586,6 @@ static int check_vmsa_supported(SevCommonState *sev_common, hwaddr gpa,
     vmsa_check.x87_fcw = 0;
     vmsa_check.mxcsr = 0;
 
-    if (check_sev_features(sev_common, vmsa_check.sev_features, errp) < 0) {
-        return -1;
-    }
     vmsa_check.sev_features = 0;
 
     if (!buffer_is_zero(&vmsa_check, sizeof(vmsa_check))) {
@@ -1892,20 +1889,29 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
          * as SEV_STATE_UNINIT.
          */
         if (x86machine->igvm) {
+            if (sev_common->sev_features & ~SVM_SEV_FEAT_SNP_ACTIVE) {
+                error_setg(errp, "%s: SEV features can't be specified when using IGVM files",
+                           __func__);
+                return -1;
+            }
             if (IGVM_CFG_GET_CLASS(x86machine->igvm)
                     ->process(x86machine->igvm, machine->cgs, true, errp) ==
                 -1) {
                 return -1;
             }
-            /*
-             * KVM maintains a bitmask of allowed sev_features. This does not
-             * include SVM_SEV_FEAT_SNP_ACTIVE which is set accordingly by KVM
-             * itself. Therefore we need to clear this flag.
-             */
-            args.vmsa_features = sev_common->sev_features &
-                                 ~SVM_SEV_FEAT_SNP_ACTIVE;
         }
 
+        if (check_sev_features(sev_common, sev_common->sev_features, errp) < 0) {
+            return -1;
+        }
+
+        /*
+         * KVM maintains a bitmask of allowed sev_features. This does not
+         * include SVM_SEV_FEAT_SNP_ACTIVE which is set accordingly by KVM
+         * itself. Therefore we need to clear this flag.
+         */
+        args.vmsa_features = sev_common->sev_features & ~SVM_SEV_FEAT_SNP_ACTIVE;
+
         ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_INIT2, &args, &fw_error);
         break;
     }
@@ -2518,9 +2524,6 @@ static int cgs_set_guest_state(hwaddr gpa, uint8_t *ptr, uint64_t len,
                            __func__);
                 return -1;
             }
-            if (check_sev_features(sev_common, sa->sev_features, errp) < 0) {
-                return -1;
-            }
             sev_common->sev_features = sa->sev_features;
         }
         return 0;
@@ -3127,6 +3130,7 @@ sev_snp_guest_instance_init(Object *obj)
 
     /* default init/start/finish params for kvm */
     sev_snp_guest->kvm_start_conf.policy = DEFAULT_SEV_SNP_POLICY;
+    SEV_COMMON(sev_snp_guest)->sev_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 }
 
 /* guest info specific to sev-snp */
-- 
2.50.1


