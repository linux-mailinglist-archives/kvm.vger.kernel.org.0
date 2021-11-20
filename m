Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918F0457A86
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 02:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbhKTCAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 21:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbhKTCAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 21:00:12 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB667C061574
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 17:57:09 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id lt10-20020a17090b354a00b001a649326aedso7607232pjb.5
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 17:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=KrbbWwTYAYpbfb8RZZsX15NqaAxDG8BItIa+niGTlEk=;
        b=lYEZZ3hpyEBNFBTV+81BSUwcFX40weMuhwWa/i70LhjiSbVrDoiyJQHWJO4hP+XzPm
         5UOQlwbsOn7X6jc4qWN/T//Q5P6eI0tRQQeb7UPzjVn7I5ZuMuPXgb3MO8BUUjHIfRua
         bX8cWv+Z+THojJiihUCuUDnAqFD3OlJOgMHw9/x25RERuelld/mZYgQ52sQxaSVVyIfC
         1bhm9ZXawqYBoSXAGUYIiEqMUeV+T8wOXvbbwAqsLxeX5PSIa1pW+71tx73rVsS8rEuR
         ASNZL2Px+ELqKlczjR0v107ZOSjf/BXriB+9rJ6wfacI8xrJwspk+1GsqvZXmHewFvlG
         YkLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=KrbbWwTYAYpbfb8RZZsX15NqaAxDG8BItIa+niGTlEk=;
        b=LX0lv8VLgFl7HUS+Zk4fxbiMD12SgEHuTQ0RGU2YGub/gJ8+lwjOcOi9zD1JJP4ron
         axihqfhla4aahIJdRgK3Ntub0YhIVIVpgJprCR1U2T6Av2M+AjrKtdXVqkGTBnRpQYwI
         mO/SuGMZEJufIH0hi37ZIbeT46ZTqL/G0ENY05wUzsPzM+uoEdarclC54I/REwioM3lH
         8Dqr2qJStZMk5YzZwJVNOPfMdEpnUuz7h3yvLkiiVWX5cKVtIbikiKS4AtEI2MOsxZg9
         4yFgYzO1W8Lnz9RJvpkBL2apg4ED/SrfjKP24ifwYLibKcUZRca4VdkLfg4noGQiCbbz
         N36w==
X-Gm-Message-State: AOAM533yWHOI49cx/GNP304ehSEePzSJdfEZ6gpTp0TE+o07zuIoMdAD
        +XIzSJWHTZuGKT/hrPtP8jWqRx1eo0E=
X-Google-Smtp-Source: ABdhPJyIJ5Q2QfuuEejoxgJn4d6h17tsial0wLdeo15vwuLRl9OOZzUoxXtFqmzpF0H8R9owtG4Kh6eckdk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:390c:: with SMTP id
 y12mr664126pjb.0.1637373428916; Fri, 19 Nov 2021 17:57:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 01:57:06 +0000
Message-Id: <20211120015706.3830341-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH] KVM: x86/mmu: Handle "default" period when selectively waking kthread
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Account for the '0' being a default, "let KVM choose" period, when
determining whether or not the recovery worker needs to be awakened in
response to userspace reducing the period.  Failure to do so results in
the worker not being awakened properly, e.g. when changing the period
from '0' to any small-ish value.

Fixes: 4dfe4f40d845 ("kvm: x86: mmu: Make NX huge page recovery period configurable")
Cc: stable@vger.kernel.org
Cc: Junaid Shahid <junaids@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 48 +++++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8f0035517450..db7e1ad4d046 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6165,23 +6165,46 @@ void kvm_mmu_module_exit(void)
 	mmu_audit_disable();
 }
 
+/*
+ * Calculate the effective recovery period, accounting for '0' meaning "let KVM
+ * select a period of ~1 hour per page".  Returns true if recovery is enabled.
+ */
+static bool calc_nx_huge_pages_recovery_period(uint *period)
+{
+	/*
+	 * Use READ_ONCE to get the params, this may be called outside of the
+	 * param setters, e.g. by the kthread to compute its next timeout.
+	 */
+	bool enabled = READ_ONCE(nx_huge_pages);
+	uint ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
+
+	if (!enabled || !ratio)
+		return false;
+
+	*period = READ_ONCE(nx_huge_pages_recovery_period_ms);
+	if (!*period) {
+		/* Make sure the period is not less than one second.  */
+		ratio = min(ratio, 3600u);
+		*period = 60 * 60 * 1000 / ratio;
+	}
+	return true;
+}
+
 static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp)
 {
 	bool was_recovery_enabled, is_recovery_enabled;
 	uint old_period, new_period;
 	int err;
 
-	was_recovery_enabled = nx_huge_pages_recovery_ratio;
-	old_period = nx_huge_pages_recovery_period_ms;
+	was_recovery_enabled = calc_nx_huge_pages_recovery_period(&old_period);
 
 	err = param_set_uint(val, kp);
 	if (err)
 		return err;
 
-	is_recovery_enabled = nx_huge_pages_recovery_ratio;
-	new_period = nx_huge_pages_recovery_period_ms;
+	is_recovery_enabled = calc_nx_huge_pages_recovery_period(&new_period);
 
-	if (READ_ONCE(nx_huge_pages) && is_recovery_enabled &&
+	if (is_recovery_enabled &&
 	    (!was_recovery_enabled || old_period > new_period)) {
 		struct kvm *kvm;
 
@@ -6245,18 +6268,13 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 
 static long get_nx_lpage_recovery_timeout(u64 start_time)
 {
-	uint ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
-	uint period = READ_ONCE(nx_huge_pages_recovery_period_ms);
+	bool enabled;
+	uint period;
 
-	if (!period && ratio) {
-		/* Make sure the period is not less than one second.  */
-		ratio = min(ratio, 3600u);
-		period = 60 * 60 * 1000 / ratio;
-	}
+	enabled = calc_nx_huge_pages_recovery_period(&period);
 
-	return READ_ONCE(nx_huge_pages) && ratio
-		? start_time + msecs_to_jiffies(period) - get_jiffies_64()
-		: MAX_SCHEDULE_TIMEOUT;
+	return enabled ? start_time + msecs_to_jiffies(period) - get_jiffies_64()
+		       : MAX_SCHEDULE_TIMEOUT;
 }
 
 static int kvm_nx_lpage_recovery_worker(struct kvm *kvm, uintptr_t data)
-- 
2.34.0.rc2.393.gf8c9666880-goog

