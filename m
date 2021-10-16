Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6235542FF8A
	for <lists+kvm@lfdr.de>; Sat, 16 Oct 2021 02:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239381AbhJPAxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 20:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234607AbhJPAxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 20:53:37 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFF8C061570
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 17:51:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 124-20020a251182000000b005a027223ed9so12920612ybr.13
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 17:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=QZoC1kD7qv54sr8ZONbFanRtx6JLbkoqm3kAbKIFFGw=;
        b=rVMU504MHxP5RxE7T817vdCnsHZLhV0efw4lQ5NGjXxVdTjp0iND+WrUOd3rUjv5nB
         wykhcPTpstVBndto2q3oGARTYdv5h+deqXFXDfMl/MSgeumY1+nXP2iQko+yy/O13o+9
         H2W2gw+b6O2KqbMrGQikRFZa9bwoCE0SECIbi/xltfUj2sypWIsfdmgruLqRScX02UdH
         lLWGPJxYB19OfzUHBTysHBJMw2LuQxAy1DkqcmL1i80fQ7b5PaaJrSUFOLHqEfVG+/1i
         /pIh92M09oWMkaUAZQ1CM4Mb5xTPi7ZDa30DeaDuuKzLkaBtWAssdWT4W+Yx5cpHBqhG
         blZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=QZoC1kD7qv54sr8ZONbFanRtx6JLbkoqm3kAbKIFFGw=;
        b=zLV4s0beRThvPTwMlxbm7HklP7HBCdsz+9nxy4Ry0AZr1OHZRWkl6bX2sRNjPHxret
         0v9Yu1SiENkhSp68wNo0jil6aVn1q6oD6aJL9+Ir30LOdrwiUQyoJbIIGecqJgpxtsPa
         /knYOTOz8QMZGLG0MDtc58QWzBn/ijtA1Evq+Fa9U191l5tvgrXHgUk5kx5dOprLVscb
         D0Nkg2Zmawo5RHbaYWTC3sDnPPHFXlIgokLc/yEyND4n94vVxMtyUOTxdZC1rsuBE1GN
         R6Eg7FJdEFFYHiowKvZ5WWbDoYj1FfTGnrn/d+9w/ASx/GaJLTep/k920hlhPGKPU21X
         n5ng==
X-Gm-Message-State: AOAM533+eIqz691/Zb0dbKmZy5ZGICgB1g712I2zFF18qG/EE4Ko1plk
        1ZS6hGoJbaltwn33ehKuGIRCKBR6Z+Hvz6teRmAQF1ddW/IYu4OMhnoo71/9394LfDGF2cjelDH
        wJMuLVes8zcM2hJfK1PE/JqU+YSv/Gdnac4QiRN85BRT3FrgSoZqtz24Hwl+4
X-Google-Smtp-Source: ABdhPJwYCiXZbpRbyRVdXFkiL0Vp4zKn5tgQfEC/BmfwITxfVu/Zb417yT5YMllNasBp4v5y8MHsUTYQxZFz
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:4059:4a9d:8d17:f229])
 (user=junaids job=sendgmr) by 2002:a25:e4c7:: with SMTP id
 b190mr16856421ybh.302.1634345489271; Fri, 15 Oct 2021 17:51:29 -0700 (PDT)
Date:   Fri, 15 Oct 2021 17:50:52 -0700
Message-Id: <20211016005052.3820023-1-junaids@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH] kvm: x86: mmu: Make NX huge page recovery period configurable
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
1 minute (though that is still kept as the default). Users of
large VMs can then adjust both the ratio and the period together to
reduce the number of pages zapped at one time while still
maintaining the same overall duration for cycling through the
entire list (e.g. the period could be set to 1 second and the ratio
to 3600 to maintain the overall cycling period of 1 hour).

Signed-off-by: Junaid Shahid <junaids@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  8 ++++-
 arch/x86/kvm/mmu/mmu.c                        | 33 +++++++++++++------
 2 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 91ba391f9b32..8e2b426726e5 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2353,7 +2353,13 @@
 			[KVM] Controls how many 4KiB pages are periodically zapped
 			back to huge pages.  0 disables the recovery, otherwise if
 			the value is N KVM will zap 1/Nth of the 4KiB pages every
-			minute.  The default is 60.
+			period (see below).  The default is 60.
+
+	kvm.nx_huge_pages_recovery_period_ms=
+			[KVM] Controls the time period at which KVM zaps 4KiB pages
+			back to huge pages. 0 disables the recovery, otherwise if
+			the value is N, KVM will zap a portion (see ratio above) of
+			the pages every N msecs. The default is 60000 (i.e. 1 min).
 
 	kvm-amd.nested=	[KVM,AMD] Allow nested virtualization in KVM/SVM.
 			Default is 1 (enabled)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 24a9f4c3f5e7..47e113fc05ab 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -61,28 +61,33 @@ int __read_mostly nx_huge_pages = -1;
 #ifdef CONFIG_PREEMPT_RT
 /* Recovery can cause latency spikes, disable it for PREEMPT_RT.  */
 static uint __read_mostly nx_huge_pages_recovery_ratio = 0;
+static uint __read_mostly nx_huge_pages_recovery_period_ms = 0;
 #else
 static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
+static uint __read_mostly nx_huge_pages_recovery_period_ms = 60000;
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
@@ -6088,18 +6093,23 @@ void kvm_mmu_module_exit(void)
 	mmu_audit_disable();
 }
 
-static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel_param *kp)
+static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp)
 {
-	unsigned int old_val;
+	bool was_recovery_enabled, is_recovery_enabled;
 	int err;
 
-	old_val = nx_huge_pages_recovery_ratio;
+	was_recovery_enabled = nx_huge_pages_recovery_ratio &&
+			       nx_huge_pages_recovery_period_ms;
+
 	err = param_set_uint(val, kp);
 	if (err)
 		return err;
 
+	is_recovery_enabled = nx_huge_pages_recovery_ratio &&
+			      nx_huge_pages_recovery_period_ms;
+
 	if (READ_ONCE(nx_huge_pages) &&
-	    !old_val && nx_huge_pages_recovery_ratio) {
+	    !was_recovery_enabled && is_recovery_enabled) {
 		struct kvm *kvm;
 
 		mutex_lock(&kvm_lock);
@@ -6162,8 +6172,11 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 
 static long get_nx_lpage_recovery_timeout(u64 start_time)
 {
-	return READ_ONCE(nx_huge_pages) && READ_ONCE(nx_huge_pages_recovery_ratio)
-		? start_time + 60 * HZ - get_jiffies_64()
+	uint ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
+	uint period = READ_ONCE(nx_huge_pages_recovery_period_ms);
+
+	return READ_ONCE(nx_huge_pages) && ratio && period
+		? start_time + msecs_to_jiffies(period) - get_jiffies_64()
 		: MAX_SCHEDULE_TIMEOUT;
 }
 
-- 
2.33.0.1079.g6e70778dc9-goog

