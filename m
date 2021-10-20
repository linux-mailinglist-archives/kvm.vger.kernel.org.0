Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1708F4342B9
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 03:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhJTBI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 21:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbhJTBIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 21:08:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7611AC061769
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 18:06:40 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i21-20020a253b15000000b005b9c0fbba45so28013572yba.20
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 18:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=+TeazuyIGE0b+xVHNR0aHwtN74RSpUoopfjfP6MomrY=;
        b=Ln8iqKC9DJ6UxeW0FTwABMXFNb9SI/dNxEj49U66ZgqJiUdpdlszBjqOsIe5LM6Hhe
         N8fmwL1E4t1wKXVNu+X2rL5qQlxFac7ii+2DXJtz3AHQPreEt0ZfavIo53RN4g4iodGr
         dGqKJ+fD2ffzPucFA5+1MnbjI3XUoyPm6j6ZpghhH9MTOhEqaY2qhY/47w+gnz2bnvpD
         zTg4vmJcDTYe6mU+2sct19CBk+1dCJdvqWcDu64IYkNR1ioJGhmIPkMRHqPcOGHnEhYs
         RN/BPSsR+Su66Fro5mIb6ckbqynIRuAhAeZVl4pjzszwoNx1GX6uuz0LIJJdnqGhD8vM
         um1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=+TeazuyIGE0b+xVHNR0aHwtN74RSpUoopfjfP6MomrY=;
        b=qYbMPTp10iBDgvqHug2W9ADxeGdlpU/tlqtkopIZxrTNG7IEhzXvImI71MB2a9VwdS
         50enEMKld7D+9FdwNnX+eTX+IQ7NK7BYZuz044GJ5xZvtKvDruKVtZ94TlIVwITXIHni
         OyWqZD4J/sttVsx2Nj0SZcfWsyyiL9ZYqYC5XSA3jHp0KJx+IeaacfLDlm74GaCQ0muk
         7hQRDL4mwD7MpaR5s2Yp8bEMyqa7z5VnSBdku2NLxFejvSuogTSJpER6Fo8acpCm18tc
         Ba3/7luBH9fA5LCJbaJPcl/Ol8XMlfwBv9aPgTpgWWNbOoXQDi0ZpmWSe9jZnUAijL07
         Zbvg==
X-Gm-Message-State: AOAM530NKYWA2Dkurf8KcEIyUwUmLUJEtE7O4WF9c9weldSlAITKudej
        23xTzt8GPTroM1/TziPr9VWCh9Zs+HCzjaQh8FBYgSBjDQ9NyPH2T6jrPF+1EA3frUvwcCCXYQW
        ZpXUKEB2POIWJokYJY85Lc+6UMy7LWvHyUP1iHrs+s9CNIlytcz2uKNbqVOvg
X-Google-Smtp-Source: ABdhPJxu162vtC7B9MGQt8LGVxM3e9BPULyYSli1HTz1DxK0tlNmMIJncaUciQanDIMG/vnO2u1NatcQBfkI
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:25da:c6d7:bf2a:7102])
 (user=junaids job=sendgmr) by 2002:a25:14d6:: with SMTP id
 205mr38996873ybu.93.1634691999579; Tue, 19 Oct 2021 18:06:39 -0700 (PDT)
Date:   Tue, 19 Oct 2021 18:06:27 -0700
Message-Id: <20211020010627.305925-1-junaids@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v3] kvm: x86: mmu: Make NX huge page recovery period configurable
From:   Junaid Shahid <junaids@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, seanjc@google.com, bgardon@google.com,
        dmatlack@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the NX huge page recovery thread wakes up every minute and
zaps 1/nx_huge_pages_recovery_ratio of the total number of split NX
huge pages at a time. This is intended to ensure that only a
relatively small number of pages get zapped at a time. But for very
large VMs (or more specifically, VMs with a large number of
executable pages), a period of 1 minute could still result in this
number being too high (unless the ratio is changed significantly,
but that can result in split pages lingering on for too long).

This change makes the period configurable instead of fixing it at
1 minute. Users of large VMs can then adjust the period and/or the
ratio to reduce the number of pages zapped at one time while still
maintaining the same overall duration for cycling through the
entire list. By default, KVM derives a period from the ratio such
that the entire list can be zapped in 1 hour.

Signed-off-by: Junaid Shahid <junaids@google.com>
---
v3:
 - Wake up the recovery thread if the new period is less than the old.
 
v2:
 - A configured period of 0 now automatically derives the actual period
   from the ratio.
    
 .../admin-guide/kernel-parameters.txt         | 10 ++++-
 arch/x86/kvm/mmu/mmu.c                        | 38 +++++++++++++------
 2 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 91ba391f9b32..dd47336a525f 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2353,7 +2353,15 @@
 			[KVM] Controls how many 4KiB pages are periodically zapped
 			back to huge pages.  0 disables the recovery, otherwise if
 			the value is N KVM will zap 1/Nth of the 4KiB pages every
-			minute.  The default is 60.
+			period (see below).  The default is 60.
+
+	kvm.nx_huge_pages_recovery_period_ms=
+			[KVM] Controls the time period at which KVM zaps 4KiB pages
+			back to huge pages. If the value is a non-zero N, KVM will
+			zap a portion (see ratio above) of the pages every N msecs.
+			If the value is 0 (the default), KVM will pick a period based
+			on the ratio such that the entire set of pages can be zapped
+			in approximately 1 hour on average.
 
 	kvm-amd.nested=	[KVM,AMD] Allow nested virtualization in KVM/SVM.
 			Default is 1 (enabled)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 24a9f4c3f5e7..4ffabad29baf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -58,6 +58,7 @@
 extern bool itlb_multihit_kvm_mitigation;
 
 int __read_mostly nx_huge_pages = -1;
+static uint __read_mostly nx_huge_pages_recovery_period_ms;
 #ifdef CONFIG_PREEMPT_RT
 /* Recovery can cause latency spikes, disable it for PREEMPT_RT.  */
 static uint __read_mostly nx_huge_pages_recovery_ratio = 0;
@@ -66,23 +67,26 @@ static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
 #endif
 
 static int set_nx_huge_pages(const char *val, const struct kernel_param *kp);
-static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel_param *kp);
+static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp);
 
 static const struct kernel_param_ops nx_huge_pages_ops = {
 	.set = set_nx_huge_pages,
 	.get = param_get_bool,
 };
 
-static const struct kernel_param_ops nx_huge_pages_recovery_ratio_ops = {
-	.set = set_nx_huge_pages_recovery_ratio,
+static const struct kernel_param_ops nx_huge_pages_recovery_param_ops = {
+	.set = set_nx_huge_pages_recovery_param,
 	.get = param_get_uint,
 };
 
 module_param_cb(nx_huge_pages, &nx_huge_pages_ops, &nx_huge_pages, 0644);
 __MODULE_PARM_TYPE(nx_huge_pages, "bool");
-module_param_cb(nx_huge_pages_recovery_ratio, &nx_huge_pages_recovery_ratio_ops,
+module_param_cb(nx_huge_pages_recovery_ratio, &nx_huge_pages_recovery_param_ops,
 		&nx_huge_pages_recovery_ratio, 0644);
 __MODULE_PARM_TYPE(nx_huge_pages_recovery_ratio, "uint");
+module_param_cb(nx_huge_pages_recovery_period_ms, &nx_huge_pages_recovery_param_ops,
+		&nx_huge_pages_recovery_period_ms, 0644);
+__MODULE_PARM_TYPE(nx_huge_pages_recovery_period_ms, "uint");
 
 static bool __read_mostly force_flush_and_sync_on_reuse;
 module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
@@ -6088,18 +6092,24 @@ void kvm_mmu_module_exit(void)
 	mmu_audit_disable();
 }
 
-static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel_param *kp)
+static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp)
 {
-	unsigned int old_val;
+	bool was_recovery_enabled, is_recovery_enabled;
+	uint old_period, new_period;
 	int err;
 
-	old_val = nx_huge_pages_recovery_ratio;
+	was_recovery_enabled = nx_huge_pages_recovery_ratio;
+	old_period = nx_huge_pages_recovery_period_ms;
+
 	err = param_set_uint(val, kp);
 	if (err)
 		return err;
 
-	if (READ_ONCE(nx_huge_pages) &&
-	    !old_val && nx_huge_pages_recovery_ratio) {
+	is_recovery_enabled = nx_huge_pages_recovery_ratio;
+	new_period = nx_huge_pages_recovery_period_ms;
+
+	if (READ_ONCE(nx_huge_pages) && is_recovery_enabled &&
+	    (!was_recovery_enabled || old_period > new_period)) {
 		struct kvm *kvm;
 
 		mutex_lock(&kvm_lock);
@@ -6162,8 +6172,14 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 
 static long get_nx_lpage_recovery_timeout(u64 start_time)
 {
-	return READ_ONCE(nx_huge_pages) && READ_ONCE(nx_huge_pages_recovery_ratio)
-		? start_time + 60 * HZ - get_jiffies_64()
+	uint ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
+	uint period = READ_ONCE(nx_huge_pages_recovery_period_ms);
+
+	if (!period && ratio)
+		period = 60 * 60 * 1000 / ratio;
+
+	return READ_ONCE(nx_huge_pages) && ratio
+		? start_time + msecs_to_jiffies(period) - get_jiffies_64()
 		: MAX_SCHEDULE_TIMEOUT;
 }
 
-- 
2.33.0.1079.g6e70778dc9-goog

