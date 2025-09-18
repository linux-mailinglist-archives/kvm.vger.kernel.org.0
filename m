Return-Path: <kvm+bounces-58000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 379BEB84204
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 12:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 337EF4A1B21
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 10:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F7332FDC52;
	Thu, 18 Sep 2025 10:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gG+PfqBG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448562FDC24
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 10:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758191455; cv=none; b=rEbWmsxGEJ+JxezOx7M0800YC/gtZG+8KIHL8AKs9Vue7++xNhPiAcoxqhdQmWtJdMt6fWlQTa5+owiZVXUBU3zBDgTXV/lt69yVFDVkE4j4JNOB7F8275a8zMpfpBkIKakie+AqBpDtOQSnF/SRD1cyTZ0QMUP3SsAQVMzgBdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758191455; c=relaxed/simple;
	bh=voC3RuuXy69NPBRMGb0xMv9euf2H4XXFvE+T4oED/WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2vgWxrV0LzAyhCCfLotikThF6VEofZ/59z6KE4wgusHspVtOmDPIpq80uv+rjdh36nM00u/DMDqJYX8/ENKl5mmN7stl4dVOQdmqJ5f3YO9PP8qRFGphHTc+lazsbpFVz0QYJGtqXEqsKxChPWzfdNToutBUy7UGzXjTafq3k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gG+PfqBG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDF1C4CEF7;
	Thu, 18 Sep 2025 10:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758191455;
	bh=voC3RuuXy69NPBRMGb0xMv9euf2H4XXFvE+T4oED/WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gG+PfqBGv1j+jb6yRHWZoN+/mWb3whrz8kOQhHomYHkQRjhNdA6XdplcZtrmgzz7H
	 I3+gKLwLGAFhedLUHgwtEYsv6t4ucrUFWkBUnNUelWJPGdzB6+dKhndAEvxj27zSx/
	 Q4kZumUi1TibWJFKApMlYxMVzojd4RDk0ZIpEQoiVfJZOJH2dePB+lNHkAztLvVqx8
	 wKuUwQzP+wp2PTFXIpAZS6uygfRzJzz5BwyA++/LGQUiBi20jpKqs1kXEbNOwEvKwv
	 Ln6d0rT2jJquixFKCDdN9yB7OzA09n3ZdzwcRCONouJCI3IkiXK5pyNMLyGa9s6wD+
	 iRCho0JkFUmKg==
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
Subject: [PATCH 1/8] target/i386: SEV: Generalize handling of SVM_SEV_FEAT_SNP_ACTIVE
Date: Thu, 18 Sep 2025 15:56:59 +0530
Message-ID: <d7473c88d4f2cfefd9249eb414a28806494c4e5e.1758189463.git.naveen@kernel.org>
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

Align with IGVM files providing sev features with
SVM_SEV_FEAT_SNP_ACTIVE set by setting the same when creating a
sev-snp-guest object.

Since KVM sets this feature itself, SVM_SEV_FEAT_SNP_ACTIVE is unset
before KVM_SEV_INIT2 ioctl is invoked. Move that out of IGVM-specific
section to common code.

While at it, convert the existing SVM_SEV_FEAT_SNP_ACTIVE definition to
use the BIT() macro for consistency with upcoming feature flags.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 target/i386/sev.h |  2 +-
 target/i386/sev.c | 24 +++++++++++++++++-------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/target/i386/sev.h b/target/i386/sev.h
index 9db1a802f6bb..102546b112d6 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -44,7 +44,7 @@ bool sev_snp_enabled(void);
 #define SEV_SNP_POLICY_SMT      0x10000
 #define SEV_SNP_POLICY_DBG      0x80000
 
-#define SVM_SEV_FEAT_SNP_ACTIVE 1
+#define SVM_SEV_FEAT_SNP_ACTIVE     BIT(0)
 
 typedef struct SevKernelLoaderContext {
     char *setup_data;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 1057b8ab2c60..2fb1268ed788 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -319,6 +319,15 @@ sev_set_guest_state(SevCommonState *sev_common, SevState new_state)
     sev_common->state = new_state;
 }
 
+static void sev_set_feature(SevCommonState *sev_common, uint64_t feature, bool set)
+{
+    if (set) {
+        sev_common->sev_features |= feature;
+    } else {
+        sev_common->sev_features &= ~feature;
+    }
+}
+
 static void
 sev_ram_block_added(RAMBlockNotifier *n, void *host, size_t size,
                     size_t max_size)
@@ -1897,15 +1906,15 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
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
@@ -3127,6 +3136,7 @@ sev_snp_guest_instance_init(Object *obj)
 
     /* default init/start/finish params for kvm */
     sev_snp_guest->kvm_start_conf.policy = DEFAULT_SEV_SNP_POLICY;
+    sev_set_feature(SEV_COMMON(sev_snp_guest), SVM_SEV_FEAT_SNP_ACTIVE, true);
 }
 
 /* guest info specific to sev-snp */
-- 
2.51.0


