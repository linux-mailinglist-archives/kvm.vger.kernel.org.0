Return-Path: <kvm+bounces-58731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F65FB9EA79
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:30:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 920537B5802
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A5322EC557;
	Thu, 25 Sep 2025 10:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gllvohn9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C032EC0B5
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758796089; cv=none; b=Jpk8BGiuxmO9oJ9A4lPWJrpOsgUBMUD5Hbd9eeDmJZ/x5pA5+BUtrQg+nnK0e+LGElx6nIWywe8269/ZvAzEqMUsC1zE/thcW03l2fK9D3S24SGn8xtThraZOO9aEB71RivR82WsmepmM+Rmq13L3xf51X5lf1BVEhpL3MrNkzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758796089; c=relaxed/simple;
	bh=UPmN8zWX6qK/BDJEkiaVEyjwQcgJbk4nHuayO4CCPGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfzpmJQg96yPm11BbQX6JCrNiilBhwh3ODdus4kpZynLnuXb6y3wN6le/PZxAw5aAFirRrGLtekoZd7XGDwU7QsPiq6wujZgC14ekAUKNGqaua5DyW50NzgR2DwtecxRp7nd9svncf2BIzfXPfkJ4FXSBlRokYenpnXdo6UsMwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gllvohn9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04F3C4CEF0;
	Thu, 25 Sep 2025 10:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758796088;
	bh=UPmN8zWX6qK/BDJEkiaVEyjwQcgJbk4nHuayO4CCPGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gllvohn9hMnUbf65eidp3x6eELGh8Ch7RfJYKSBm8H0jzJHdX8jItx7JyiCpJhhNO
	 E/IKSsOwpKK4MiHcs/QzEt/mFz29H22JftZAIOmhdRN7d3pmdIs73mX7g1JA2arPGQ
	 xDePhb/ngpahLXdu++eSLQyEGY/WCma3cxR1omoAQTOdlAj1Ro6kPiel3uDtoZY6kQ
	 TIboZS5bWUdXCmJEjh+NKZn9eln7p8byzLS/J3ucM8wUHPVmsSlNJEuB6SKIFaiWRv
	 vcxMsSAZQqMjwSiWmwJ1Bs8eAuu+98bnMCdq8iyMCwktR9zhWg+18cXzZAQHdCH4Sn
	 A4eSfzsLYEDGQ==
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
Subject: [PATCH v2 3/9] target/i386: SEV: Consolidate SEV feature validation to common init path
Date: Thu, 25 Sep 2025 15:47:32 +0530
Message-ID: <f293557861e96e7c54f2e4fc1bba62e065fcd093.1758794556.git.naveen@kernel.org>
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

Currently, check_sev_features() is called in multiple places when
processing IGVM files: both when processing the initial VMSA SEV
features from IGVM, as well as when validating the full contents of the
VMSA. Move this to a single point in sev_common_kvm_init() to simplify
the flow, as well as to re-use this function when VMSA SEV features are
being set without using IGVM files.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 target/i386/sev.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index ddd7c01f5a56..3b11e61f78d8 100644
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
@@ -1917,6 +1914,10 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
             }
         }
 
+        if (check_sev_features(sev_common, sev_common->sev_features, errp) < 0) {
+            return -1;
+        }
+
         /*
          * KVM maintains a bitmask of allowed sev_features. This does not
          * include SVM_SEV_FEAT_SNP_ACTIVE which is set accordingly by KVM
@@ -2536,9 +2537,6 @@ static int cgs_set_guest_state(hwaddr gpa, uint8_t *ptr, uint64_t len,
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


