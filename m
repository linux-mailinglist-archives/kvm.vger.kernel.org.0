Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10D72FE3D2
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 08:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbhAUHWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 02:22:14 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:43804 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727303AbhAUHVE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 02:21:04 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UMOzPSM_1611213609;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMOzPSM_1611213609)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 21 Jan 2021 15:20:13 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] kvm: x86/mmu: Assign boolean values to a bool variable
Date:   Thu, 21 Jan 2021 15:20:07 +0800
Message-Id: <1611213607-4062-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the following coccicheck warnings:

./arch/x86/kvm/mmu/mmu.c:5829:2-9: WARNING: Assignment of 0/1
to bool variable.

./arch/x86/kvm/mmu/mmu.c:2505:1-11: WARNING: Assignment of 0/1
to bool variable.

./arch/x86/kvm/mmu/mmu.c:1814:1-11: WARNING: Assignment of 0/1
to bool variable.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481..ced0bd5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1819,7 +1819,7 @@ static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	WARN_ON(!sp->unsync);
 	trace_kvm_mmu_sync_page(sp);
-	sp->unsync = 0;
+	sp->unsync = false;
 	--kvm->stat.mmu_unsync;
 }
 
@@ -2510,7 +2510,7 @@ static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
 	trace_kvm_mmu_unsync_page(sp);
 	++vcpu->kvm->stat.mmu_unsync;
-	sp->unsync = 1;
+	sp->unsync = true;
 
 	kvm_mmu_mark_parents_unsync(sp);
 }
@@ -5839,9 +5839,9 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 
 	/* In "auto" mode deploy workaround only if CPU has the bug. */
 	if (sysfs_streq(val, "off"))
-		new_val = 0;
+		new_val = false;
 	else if (sysfs_streq(val, "force"))
-		new_val = 1;
+		new_val = true;
 	else if (sysfs_streq(val, "auto"))
 		new_val = get_nx_auto_mode();
 	else if (strtobool(val, &new_val) < 0)
-- 
1.8.3.1

