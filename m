Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E8647FCC4
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 13:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236750AbhL0MtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 07:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236733AbhL0MtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Dec 2021 07:49:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B218FC061401
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 04:49:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70AE5B8102E
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 12:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA69C36AEB;
        Mon, 27 Dec 2021 12:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640609338;
        bh=ffbdeZ5bQPyh8MTqynKoFo8gtfzkNyhGOr52LWv3kkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvNMjf0hvJ7DNKX69BVUF9vI35GaPiULQwrldc0WNqJhLjhXYakaWJ603+ruZq7UX
         +zBr8aZvjqE7gwIhGv9VqS4RpT/9d2SDK8fOvozgZ3M/Xxrrriu9GgnQ2mrbXjcZlz
         mP/SIDuVL2eiTvq/BDEkL083Yb9734it3WNeLvewJE/BICAxCs/Gys5ztd0uO2tbmG
         0R8iVog71+mTB7nOLinA7K3CX4K7o5KsTvAfgHcfdn15V740PTG9XYj+Pc4Zm3HMBJ
         LoKwy20OLoGtlqfd891ouZdJ/IXJiHknPiCm/ruB1RLhadllUFyQm9RVoSFUNQ4h6T
         vSMwYSj6CJq8g==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n1pQu-00EYBY-Az; Mon, 27 Dec 2021 12:48:56 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: [PATCH v2 2/6] KVM: selftests: arm64: Introduce a variable default IPA size
Date:   Mon, 27 Dec 2021 12:48:05 +0000
Message-Id: <20211227124809.1335409-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211227124809.1335409-1-maz@kernel.org>
References: <20211227124809.1335409-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Contrary to popular belief, there is no such thing as a default
IPA size on arm64. Anything goes, and implementations are the
usual Wild West.

The selftest infrastructure default to 40bit IPA, which obviously
doesn't work for some systems out there.

Turn VM_MODE_DEFAULT from a constant into a variable, and let
guest_modes_append_default() populate it, depending on what
the HW can do. In order to preserve the current behaviour, we
still pick 40bits IPA as the default if it is available, and
the largest supported IPA space otherwise.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  4 ++-
 tools/testing/selftests/kvm/lib/guest_modes.c | 30 +++++++++++++++++--
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 2d62edc49d67..7fa0a93d7526 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -53,7 +53,9 @@ enum vm_guest_mode {
 
 #if defined(__aarch64__)
 
-#define VM_MODE_DEFAULT			VM_MODE_P40V48_4K
+extern enum vm_guest_mode vm_mode_default;
+
+#define VM_MODE_DEFAULT			vm_mode_default
 #define MIN_PAGE_SHIFT			12U
 #define ptes_per_page(page_size)	((page_size) / 8)
 
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index c330f414ef96..5e3fdbd992fd 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -4,22 +4,46 @@
  */
 #include "guest_modes.h"
 
+#ifdef __aarch64__
+enum vm_guest_mode vm_mode_default;
+#endif
+
 struct guest_mode guest_modes[NUM_VM_MODES];
 
 void guest_modes_append_default(void)
 {
+#ifndef __aarch64__
 	guest_mode_append(VM_MODE_DEFAULT, true, true);
-
-#ifdef __aarch64__
-	guest_mode_append(VM_MODE_P40V48_64K, true, true);
+#else
 	{
 		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
+		int i;
+
+		vm_mode_default = NUM_VM_MODES;
+
 		if (limit >= 52)
 			guest_mode_append(VM_MODE_P52V48_64K, true, true);
 		if (limit >= 48) {
 			guest_mode_append(VM_MODE_P48V48_4K, true, true);
 			guest_mode_append(VM_MODE_P48V48_64K, true, true);
 		}
+		if (limit >= 40) {
+			guest_mode_append(VM_MODE_P40V48_4K, true, true);
+			guest_mode_append(VM_MODE_P40V48_64K, true, true);
+			vm_mode_default = VM_MODE_P40V48_4K;
+		}
+
+		/*
+		 * Pick the first supported IPA size if the default
+		 * isn't available.
+		 */
+		for (i = 0; vm_mode_default == NUM_VM_MODES && i < NUM_VM_MODES; i++) {
+			if (guest_modes[i].supported && guest_modes[i].enabled)
+				vm_mode_default = i;
+		}
+
+		TEST_ASSERT(vm_mode_default != NUM_VM_MODES,
+			    "No supported mode!");
 	}
 #endif
 #ifdef __s390x__
-- 
2.30.2

