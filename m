Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B798432B87
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 03:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhJSBmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 21:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhJSBmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 21:42:16 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08531C06161C
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 18:40:05 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p8-20020a056902114800b005bad2571fbeso22387446ybu.23
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 18:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8ZGVOmgnrw3s6UMC4PDN0P/gpK9ZjdTc2r+UNW3E1Eg=;
        b=j12vZIjZDqywMeg+1mnTKUaaeWM/tfKwf314XZHrCL/XnKh/LAHCRj8Ef1WgrYZ4Tn
         0NIc9RM7Rud3ET7OqV7VXsiedqDk4vaNgK3LTlZmhbxJ6IylQq9d/2S5xkm6yoGYDSOc
         bEG+UZgOWOabZBfoSMDQoQxE+5/OlcNWWlVUSgaF6g57//AGoGLlIC9ItoC8vIy81TTw
         4x9bxF/ts9SlhT5559vr0Dlp6Gm4SvmhN+FiOLensP3oY8gydzAYq+2be/TY0RZakH2b
         GCOUiy4xMA78Sz7NuU0xY4wItSq9gBsKFn4VAlbiZxhK+ZiovOcfRisnraHA1f7sWB9i
         xxBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8ZGVOmgnrw3s6UMC4PDN0P/gpK9ZjdTc2r+UNW3E1Eg=;
        b=0bNaz+iKtUdii1GHrCaVw0bRwMgO+5gkGuuLYrlTpBmKfIq3cgaKZYZrrVVnXE5wmP
         KzQPdvIyyYG2ErWviDdhvngFssXYRZa/sanXeR1DOuYG4tG2NLty9u4MkktJ8LLsyRbM
         DayKqDwypC0CAGVOhIp57j8OFKdTtI0G0Hw8XVEj+wh5FcbJDqbfYqo2rUHpQ8z4pgtQ
         xXVCgmfDbbyfeSCrO2v8ykJepQFpeR2JDFozG/RKeeyLsCop8tLq9+IdSKO0tDmQwf1+
         q1Xnp0Xr7aBJb9oFHtXaYMpt7MMBrjhD6++3pMbEZRKdU+pwNe2KcwwouhLm9WKWMrnx
         6sQQ==
X-Gm-Message-State: AOAM533GmD4ejY04luea1jRmcFVzKFmEffdbyl5mPXfUtWUUTfOOsbCY
        oGBXZ7DPFVxTBopM+VJ/L/JwdJRfOcca5DuxqT6PCAvzFbYw2/BLJkRZ+c5ZzW+GFc2RviCw/qG
        qWeEI+gKi3k0zZfTdgsg11cNKgU8piFTytL9byGbG/QbqmsFd8UTB6mCH+qyl
X-Google-Smtp-Source: ABdhPJxAYx+6qJYg9PfVcUOSOKqsvPpXlozgsozgQa/mNqfBxynobeTZOE+4ghrhnJ1JRlrpv4yEqXJ0a/YS
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:5a68:ed5a:d645:ec88])
 (user=junaids job=sendgmr) by 2002:a25:e7d7:: with SMTP id
 e206mr30769738ybh.267.1634607604183; Mon, 18 Oct 2021 18:40:04 -0700 (PDT)
Date:   Mon, 18 Oct 2021 18:39:53 -0700
Message-Id: <20211019013953.116390-1-junaids@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2] kvm: x86: mmu: Make NX huge page recovery period configurable
From:   Junaid Shahid <junaids@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, seanjc@google.com, bgardon@google.com,
        dmatlack@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
 - A configured period of 0 now automatically derives the actual period
   from the ratio.

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
 .../admin-guide/kernel-parameters.txt         | 10 +++++-
 arch/x86/kvm/mmu/mmu.c                        | 33 +++++++++++++------
 2 files changed, 32 insertions(+), 11 deletions(-)

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
index 24a9f4c3f5e7..273b43272c4d 100644
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
@@ -6088,18 +6092,21 @@ void kvm_mmu_module_exit(void)
 	mmu_audit_disable();
 }
 
-static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel_param *kp)
+static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp)
 {
-	unsigned int old_val;
+	bool was_recovery_enabled, is_recovery_enabled;
 	int err;
 
-	old_val = nx_huge_pages_recovery_ratio;
+	was_recovery_enabled = nx_huge_pages_recovery_ratio;
+
 	err = param_set_uint(val, kp);
 	if (err)
 		return err;
 
+	is_recovery_enabled = nx_huge_pages_recovery_ratio;
+
 	if (READ_ONCE(nx_huge_pages) &&
-	    !old_val && nx_huge_pages_recovery_ratio) {
+	    !was_recovery_enabled && is_recovery_enabled) {
 		struct kvm *kvm;
 
 		mutex_lock(&kvm_lock);
@@ -6162,8 +6169,14 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 
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

