Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDBA06056E4
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 07:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiJTFmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 01:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiJTFm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 01:42:29 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923E7143A47
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:42:28 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n6-20020a5b0486000000b006aff8dc9865so18277543ybp.11
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 22:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OtsUIATys8SkfvMgOGJq0e0j5nN53CM4H2CIbL5rRi0=;
        b=ZX+JU8/V1nRnIZUBPbKK0qGTCivJ3Y9kvTcZGWISj2umve+Lkc1zeEUrboyT0Inj7Y
         346h2aTSgGDQ76woN32t78HuTwfn28egkrPJcJ4zRgPNIdga8G0bBC3+GBsZiNMRzufB
         aL7kC2Uc2v79AmFgOrlg56nnJTlo5YnORZPdbS/hpakZlDVKuORnYIKxe3FKAy1g3xiK
         DkdHNol0fH/Ag+E+revtePM+AKUrVz+D6EtTvBr2kf8AedsI6W2nk6/QsuhbdmMxG5j1
         xbuN9wr6PpMOqgof1JPBF5A+cRj8YX+X4pxuECrOTMtLYHiDN+g7fJj2HzVHqMk3J4Ln
         nLLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OtsUIATys8SkfvMgOGJq0e0j5nN53CM4H2CIbL5rRi0=;
        b=7bsONevJZhzm6ul10/xjlSSqIpoTySG19Z213R6wHeeAPL57irpOG1pYMZFNGlFPe2
         9FCPZpuFoizw62ngT/TwjzSWBgBIiQkF8lEVCWG235wYLT2IPd/Tx0i3w6rFf3JVPMmf
         G+iSWTxj0Cy0IvqO8Fg6ofAHnjdggwtZuQVohrJRM3yT7jxNtd1NellvpRI99OvLUzkt
         TJIej33SfA6+k21VIB+eN4lASgtN2QV91H2ETVgxaOvj/7Q+YiWfHXkNy0duVJ58qaVr
         D9GaonkXJXX/OTbI3VqAixGOOg93pXWPxKMChJVFM8L4e4iadClXvJvu8MIyXCH3/kqC
         icOw==
X-Gm-Message-State: ACrzQf3GebFzly+iv86gE86klHx/CFwhFfdBqhot8kWfoACuDZA7iaTC
        JyKUEajbwwGNhydS9vaw+RxeGwgMPcM=
X-Google-Smtp-Source: AMsMyM62d9qUBEI9Szy5XvNyeaXoCZg+BAERgrHl1ogyZK/rKzQd7G+6eh0cX2mqgOijUie19nTObinLjW4=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:e705:0:b0:6ca:6ae:e194 with SMTP id
 e5-20020a25e705000000b006ca06aee194mr4508847ybh.113.1666244547836; Wed, 19
 Oct 2022 22:42:27 -0700 (PDT)
Date:   Wed, 19 Oct 2022 22:41:54 -0700
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-2-reijiw@google.com>
Subject: [PATCH v2 1/9] KVM: arm64: selftests: Use FIELD_GET() to extract ID
 register fields
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use FIELD_GET() macro to extract ID register fields for existing
aarch64 selftests code. No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c  | 3 ++-
 tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 3 ++-
 tools/testing/selftests/kvm/lib/aarch64/processor.c    | 7 ++++---
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c b/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
index 6f9c1f19c7f6..b6a5e8861b35 100644
--- a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
@@ -13,6 +13,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "test_util.h"
+#include <linux/bitfield.h>
 
 #define BAD_ID_REG_VAL	0x1badc0deul
 
@@ -145,7 +146,7 @@ static bool vcpu_aarch64_only(struct kvm_vcpu *vcpu)
 
 	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &val);
 
-	el0 = (val & ARM64_FEATURE_MASK(ID_AA64PFR0_EL0)) >> ID_AA64PFR0_EL0_SHIFT;
+	el0 = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0), val);
 	return el0 == ID_AA64PFR0_ELx_64BIT_ONLY;
 }
 
diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 947bd201435c..3808d3d75055 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -2,6 +2,7 @@
 #include <test_util.h>
 #include <kvm_util.h>
 #include <processor.h>
+#include <linux/bitfield.h>
 
 #define MDSCR_KDE	(1 << 13)
 #define MDSCR_MDE	(1 << 15)
@@ -284,7 +285,7 @@ static int debug_version(struct kvm_vcpu *vcpu)
 	uint64_t id_aa64dfr0;
 
 	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
-	return id_aa64dfr0 & 0xf;
+	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), id_aa64dfr0);
 }
 
 static void test_guest_debug_exceptions(void)
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 6f5551368944..7c96b931edd5 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -11,6 +11,7 @@
 #include "guest_modes.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include <linux/bitfield.h>
 
 #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN	0xac0000
 
@@ -486,9 +487,9 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
 	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
 	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, vcpu_fd));
 
-	*ps4k = ((val >> 28) & 0xf) != 0xf;
-	*ps64k = ((val >> 24) & 0xf) == 0;
-	*ps16k = ((val >> 20) & 0xf) != 0;
+	*ps4k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN4), val) != 0xf;
+	*ps64k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN64), val) == 0;
+	*ps16k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN16), val) != 0;
 
 	close(vcpu_fd);
 	close(vm_fd);
-- 
2.38.0.413.g74048e4d9e-goog

