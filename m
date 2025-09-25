Return-Path: <kvm+bounces-58738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F077B9EA84
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:30:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CC83E4E34BF
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B7D52F0693;
	Thu, 25 Sep 2025 10:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t/EkI5S0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBDA2EC0AF
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758796154; cv=none; b=HS4XxW80rTCiARQcdspN0E7AfcI9RfYvjvGLf3OThAGwxmYAh83ueloE7zG2uJgdCHZPorkbhEh/hXWYG9AlZFlfblxyUj1b0hf/PaAFAjmULxZUICFxuuXPJZ8vcnGWaOOqt5b1Y1FOkwiomKqM2+ESs6GIXbcxpk3oJyj/YiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758796154; c=relaxed/simple;
	bh=DMy/sGWIKYOYAjfxscxSO7zrh4vdvWXqXux+y2OofO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lvt6OYsovZ4lKju1+bj0Ab1/+KU9Z1WukinQrSoXbpPFNvNpiLp/yEWs8mBpvC7jMx1jaU6byVEHcI6FSH2ZhKerpQ2dCqp52kK3Fxc+agFe4pq8Gvxues4+VOKMRqDbme9z8AFb9A2gwkdmE2hAbvjqEvnAFj/RvFGFkRJaZmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t/EkI5S0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3920FC4CEF4;
	Thu, 25 Sep 2025 10:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758796153;
	bh=DMy/sGWIKYOYAjfxscxSO7zrh4vdvWXqXux+y2OofO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/EkI5S0VXn22jZ0NfmyryodVuBzaev8zU0XMomxtV/FKlYA3SIrLqQfUKiCh1SDy
	 BEh32ylP4yJC9JVOXLpL1uHrmJVLsn2LQ3VaKPUqMB2OKbkhyG0I1p7eyOJkTDDi2l
	 VCI/uvNJ+NVVSLRXVmz/MwLPRxH9v//24gZ90b47KD+FPdkOGfdwK5aiEbxu4keZgx
	 xuLOEN+ynbZUiiksD82Ah+HPk5R4IwzmLRv1oPB5MQzV1cDvVygHvUAcPzU6Byud4X
	 4UaMsERSgKbV4CEamdxkjfoZczsiZWJIhs4MQWktPJKLs6SARDf8gWRHsXCSE98u1C
	 lDun9ezTQ+pug==
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
Subject: [PATCH v2 1/9] target/i386: SEV: Generalize handling of SVM_SEV_FEAT_SNP_ACTIVE
Date: Thu, 25 Sep 2025 15:47:30 +0530
Message-ID: <6dd579655ec0be6183479f6bc75279117403c2b8.1758794556.git.naveen@kernel.org>
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

Align with IGVM files providing SEV features with
SVM_SEV_FEAT_SNP_ACTIVE set by setting the same when creating a
sev-snp-guest object.

Since KVM sets this feature itself, SVM_SEV_FEAT_SNP_ACTIVE is unset
before KVM_SEV_INIT2 ioctl is invoked. Move that out of IGVM-specific
section to common code.

While at it, convert the existing SVM_SEV_FEAT_SNP_ACTIVE definition to
use the BIT() macro for consistency with upcoming feature flags.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
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


