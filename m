Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD22871F76B
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 02:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbjFBA7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 20:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjFBA7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 20:59:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93B5E4
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 17:59:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba802c775caso2118092276.2
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 17:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685667542; x=1688259542;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0u7y5QK/IUNVLjf4PP/AE2dTkQWeXWOPAwDPk1OpCag=;
        b=wIQaJ+pMgik/b6GJwDHzo6Jgj2/3eBSKUPtjVYobTGqnFrLpg+apm6uFGdvnH/0xTq
         6pyYMcvEboxUZ90nuhRIKotL3IA4OWwkUUf2t8INbGwAEsuL2S4Mm6q7GMUGr2TPlk4D
         Yz29+TXn6p8x8afCO7EwW6HA6rR0EXmSkyvgmKtUzusZ3+u0hwfAxP3YkK6D0iGB+HdT
         5Ly1lWrLuW1C8AIAVCnrt0e/O8wLfm1OV3N7gIwdxpSz9kD/q5Gbjv48KPYoGrXnz9VM
         ao0x13kkeffb0FL+kXWrDhl5QNu1B6Ea/0VayqPjbseL8m2x6OVv4PSQ8mddGx8HNB0V
         JxDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685667542; x=1688259542;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0u7y5QK/IUNVLjf4PP/AE2dTkQWeXWOPAwDPk1OpCag=;
        b=Eg7ChcYOVyMlVAUyI1aEs14p+lbanKtfPotaHm32ngYJJjYFg90aZgIZcgma0Sn2Q5
         jYAI9UCxAnq5ne5uYso7FbsUj072UBGA6UG0AvOBq8KdI8kVg2N6Ls7gY10JwaKUzSLX
         zZEgouP2Z5x9OQl/O04gOJNvAjEXGev+aEJRM0KpH281dReBZpCwVdYi+Z2qj0lmWjSD
         JKO/p0g3fBdKb5V3v5osKTh6YLBL0hhA/6IZNzbu/H+x+j3K0vMpqef21w99fqW2Ldma
         xudNWaKhZ8tFJH1ZGFYYrhOE6M09y/u6HzVz77f+T04q4lVOG97NwnsSc/0Q329L4spd
         lEUQ==
X-Gm-Message-State: AC+VfDwIL+vq/nPp+lCU4umfs0aEJ8Cw9Xw5xi2yRIUB9Ynd+KrgZ44Y
        VUxyIa0e3V78z5KZ0k5WV0mFQNl/fz0=
X-Google-Smtp-Source: ACHHUZ4Wrm/D2X9Qznpq2Wz0ZUzUu5A5UFlVyVWNyUsItS+gbX8jjJDG8zEIrqDN3RdhbIHZokkWdSGF6FE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5d6:0:b0:ba7:d142:eada with SMTP id
 205-20020a2505d6000000b00ba7d142eadamr952269ybf.7.1685667542036; Thu, 01 Jun
 2023 17:59:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Jun 2023 17:58:59 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230602005859.784190-1-seanjc@google.com>
Subject: [PATCH] KVM: x86/mmu: Add "never" option to allow sticky disabling of nx_huge_pages
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li RongQing <lirongqing@baidu.com>,
        Yong He <zhuangel570@gmail.com>,
        Robert Hoo <robert.hoo.linux@gmail.com>,
        Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a "never" option to the nx_huge_pages module param to allow userspace
to do a one-way hard disabling of the mitigation, and don't create the
per-VM recovery threads when the mitigation is hard disabled.  Letting
userspace pinky swear that userspace doesn't want to enable NX mitigation
(without reloading KVM) allows certain use cases to avoid the latency
problems associated with spawning a kthread for each VM.

E.g. in FaaS use cases, the guest kernel is trusted and the host may
create 100+ VMs per logical CPU, which can result in 100ms+ latencies when
a burst of VMs is created.

Reported-by: Li RongQing <lirongqing@baidu.com>
Closes: https://lore.kernel.org/all/1679555884-32544-1-git-send-email-lirongqing@baidu.com
Cc: Yong He <zhuangel570@gmail.com>
Cc: Robert Hoo <robert.hoo.linux@gmail.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8961f45e3b1..2ed38916b904 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -58,6 +58,8 @@
 
 extern bool itlb_multihit_kvm_mitigation;
 
+static bool nx_hugepage_mitigation_hard_disabled;
+
 int __read_mostly nx_huge_pages = -1;
 static uint __read_mostly nx_huge_pages_recovery_period_ms;
 #ifdef CONFIG_PREEMPT_RT
@@ -67,12 +69,13 @@ static uint __read_mostly nx_huge_pages_recovery_ratio = 0;
 static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
 #endif
 
+static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp);
 static int set_nx_huge_pages(const char *val, const struct kernel_param *kp);
 static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp);
 
 static const struct kernel_param_ops nx_huge_pages_ops = {
 	.set = set_nx_huge_pages,
-	.get = param_get_bool,
+	.get = get_nx_huge_pages,
 };
 
 static const struct kernel_param_ops nx_huge_pages_recovery_param_ops = {
@@ -6844,6 +6847,14 @@ static void mmu_destroy_caches(void)
 	kmem_cache_destroy(mmu_page_header_cache);
 }
 
+static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp)
+{
+	if (nx_hugepage_mitigation_hard_disabled)
+		return sprintf(buffer, "never\n");
+
+	return param_get_bool(buffer, kp);
+}
+
 static bool get_nx_auto_mode(void)
 {
 	/* Return true when CPU has the bug, and mitigations are ON */
@@ -6860,15 +6871,29 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 	bool old_val = nx_huge_pages;
 	bool new_val;
 
+	if (nx_hugepage_mitigation_hard_disabled)
+		return -EPERM;
+
 	/* In "auto" mode deploy workaround only if CPU has the bug. */
-	if (sysfs_streq(val, "off"))
+	if (sysfs_streq(val, "off")) {
 		new_val = 0;
-	else if (sysfs_streq(val, "force"))
+	} else if (sysfs_streq(val, "force")) {
 		new_val = 1;
-	else if (sysfs_streq(val, "auto"))
+	} else if (sysfs_streq(val, "auto")) {
 		new_val = get_nx_auto_mode();
-	else if (kstrtobool(val, &new_val) < 0)
+	} else if (sysfs_streq(val, "never")) {
+		new_val = 0;
+
+		mutex_lock(&kvm_lock);
+		if (!list_empty(&vm_list)) {
+			mutex_unlock(&kvm_lock);
+			return -EBUSY;
+		}
+		nx_hugepage_mitigation_hard_disabled = true;
+		mutex_unlock(&kvm_lock);
+	} else if (kstrtobool(val, &new_val) < 0) {
 		return -EINVAL;
+	}
 
 	__set_nx_huge_pages(new_val);
 
@@ -7006,6 +7031,9 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
 	uint old_period, new_period;
 	int err;
 
+	if (nx_hugepage_mitigation_hard_disabled)
+		return -EPERM;
+
 	was_recovery_enabled = calc_nx_huge_pages_recovery_period(&old_period);
 
 	err = param_set_uint(val, kp);
@@ -7161,6 +7189,9 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
 {
 	int err;
 
+	if (nx_hugepage_mitigation_hard_disabled)
+		return 0;
+
 	err = kvm_vm_create_worker_thread(kvm, kvm_nx_huge_page_recovery_worker, 0,
 					  "kvm-nx-lpage-recovery",
 					  &kvm->arch.nx_huge_page_recovery_thread);

base-commit: 39428f6ea9eace95011681628717062ff7f5eb5f
-- 
2.41.0.rc2.161.g9c6817b8e7-goog

