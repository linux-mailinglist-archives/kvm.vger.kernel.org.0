Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B5443445D
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 06:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhJTEek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 00:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhJTEeh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 00:34:37 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EA7C06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 21:32:23 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id oa4so1553967pjb.2
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 21:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dvi61QFuvuShv+3C4W94ogPVceuR/aowJYZsiY4/3GI=;
        b=D9r70ySclJHKVJ9bC4/FcPlel7f1QWFjuli76epDNbwmbz0PxfcHX+bRUCkRfLTatj
         2K/XPWsh197AI8534C19FofjRsAD6EokQv7VtmvCphlBdY7cSazbSr008tq0vAKKCCTP
         KqLzuffGvd0ExJUeO9DKqXNkujt0bBHSBPwjMv0VYMnJPVNgPAnQm8682SiZQc5tJRkZ
         WyiKD/fXAdJAFdJnOPZTDwTkndx4n5MMfGUVziOeSDDnCGAUvTzaj7iHCf2Jur0VDz/H
         IDcMdWigR6RBgRFS0lYrSgnLL44xY4IvKSE2mV5mLOcv0fo4+qLOdHswfK53xFg1Sfna
         FPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dvi61QFuvuShv+3C4W94ogPVceuR/aowJYZsiY4/3GI=;
        b=G1nehBcIRyeNKHnNnU/SQF11BEvzjGrRRLbOt/7KFuPdFYeZ0ojMj4AcBaaFCQV+lZ
         b0vycH7DMgZrWPStearde71wszo0UZCoSpgUZLp8xMMmDB0CDUlSTwAVplhDcJNaDotd
         bSasUjjOTTV1GIL0TRDp1mnld/NVTounpTKm0gxoG9ewI1kLXsHyhiI5a2ss8tT6LwSU
         7j4op2L/5fOP4i2gJfWN4bgNBE6KsRdtrO0ZlqufPTKUaw1SWdrO8NK0kgzNaVNST7sr
         cyltdO0DRINr8/pdQts4xfpCitHewbuyK3sdsCQ2T7meFVFQjVoVl2C3gplY4QMzqZnH
         4Zng==
X-Gm-Message-State: AOAM530ZvwJ8MU78aN9DArPSiHe3Ef8YQ2UkyLiHbwYxxpdakhEUEpI+
        SVul1f+hPeP3vjqhv5ypmp/pHw==
X-Google-Smtp-Source: ABdhPJyCoNonj7i9wFbTo7ZEqVWDMc1CTUpPzabuuzyv/Gykgij5ZNgb52DYBeBkMiFXLwaPq3CmGA==
X-Received: by 2002:a17:902:ab8c:b0:13a:22d1:88d with SMTP id f12-20020a170902ab8c00b0013a22d1088dmr36924331plr.33.1634704342883;
        Tue, 19 Oct 2021 21:32:22 -0700 (PDT)
Received: from n210-191-019.byted.org ([49.7.45.193])
        by smtp.googlemail.com with ESMTPSA id f84sm788324pfa.25.2021.10.19.21.32.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Oct 2021 21:32:22 -0700 (PDT)
From:   Li Yu <liyu.yukiteru@bytedance.com>
To:     pbonzini@redhat.com
Cc:     liyu.yukiteru@bytedance.com, Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Muchun Song <songmuchun@bytedance.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v3] KVM: x86/mmu: Warn on iTLB multi-hit for possible problems
Date:   Wed, 20 Oct 2021 12:31:27 +0800
Message-Id: <20211020043131.1222542-1-liyu.yukiteru@bytedance.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <YW7w8g+65PjGs2wc@google.com>
References: <YW7w8g+65PjGs2wc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Warn for guest huge pages split if iTLB multi-hit bug is present
and CPU mitigations is enabled.

Warn for possible CPU lockup if iTLB multi-hit bug is present but
CPU mitigations is disabled.

Signed-off-by: Li Yu <liyu.yukiteru@bytedance.com>
---
 Documentation/admin-guide/hw-vuln/multihit.rst  |  8 +++--
 Documentation/admin-guide/kernel-parameters.txt | 10 +++---
 arch/x86/kvm/mmu/mmu.c                          | 48 +++++++++++++++++++++----
 3 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/multihit.rst b/Documentation/admin-guide/hw-vuln/multihit.rst
index 140e4cec38c3..7b2cd027d759 100644
--- a/Documentation/admin-guide/hw-vuln/multihit.rst
+++ b/Documentation/admin-guide/hw-vuln/multihit.rst
@@ -129,19 +129,21 @@ boot time with the option "kvm.nx_huge_pages=".
 
 The valid arguments for these options are:
 
-  ==========  ================================================================
+  ==========  =================================================================
   force       Mitigation is enabled. In this case, the mitigation implements
               non-executable huge pages in Linux kernel KVM module. All huge
               pages in the EPT are marked as non-executable.
               If a guest attempts to execute in one of those pages, the page is
               broken down into 4K pages, which are then marked executable.
 
-  off	      Mitigation is disabled.
+  off         Mitigation is disabled.
+
+  off,nowarn  Same as 'off', but hypervisors will not warn when KVM is loaded.
 
   auto        Enable mitigation only if the platform is affected and the kernel
               was not booted with the "mitigations=off" command line parameter.
 	      This is the default option.
-  ==========  ================================================================
+  ==========  =================================================================
 
 
 Mitigation selection guide
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 43dc35fe5bc0..8f014cf462a3 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2339,10 +2339,12 @@
 	kvm.nx_huge_pages=
 			[KVM] Controls the software workaround for the
 			X86_BUG_ITLB_MULTIHIT bug.
-			force	: Always deploy workaround.
-			off	: Never deploy workaround.
-			auto    : Deploy workaround based on the presence of
-				  X86_BUG_ITLB_MULTIHIT.
+			force	   : Always deploy workaround.
+			off	   : Never deploy workaround.
+			off,nowarn : Same as 'off', but hypervisors will not
+				     warn when KVM is loaded.
+			auto	   : Deploy workaround based on the presence of
+				     X86_BUG_ITLB_MULTIHIT and cpu mitigations.
 
 			Default is 'auto'.
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1a64ba5b9437..b9dc68e3dc2c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6056,20 +6056,41 @@ static void __set_nx_huge_pages(bool val)
 	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
 }
 
+#define ITLB_MULTIHIT_NX_ON  "iTLB multi-hit CPU bug present and cpu mitigations enabled, guest huge pages may split by kernel for security. See CVE-2018-12207 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/multihit.html for details.\n"
+#define ITLB_MULTIHIT_NX_OFF "iTLB multi-hit CPU bug present but cpu mitigations disabled, malicious guest may cause a CPU lockup. See CVE-2018-12207 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/multihit.html for details.\n"
+
 static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 {
 	bool old_val = nx_huge_pages;
 	bool new_val;
+	bool nowarn = false;
 
 	/* In "auto" mode deploy workaround only if CPU has the bug. */
-	if (sysfs_streq(val, "off"))
+	if (sysfs_streq(val, "off")) {
+		new_val = 0;
+	} else if (sysfs_streq(val, "off,nowarn")) {
 		new_val = 0;
-	else if (sysfs_streq(val, "force"))
+		nowarn = true;
+	} else if (sysfs_streq(val, "force")) {
+		/*
+		 * When `force` is set, admin should know that no matter whether
+		 * CPU has the bug or not, guest pages may split anyway. So warn
+		 * is not needed.
+		 */
 		new_val = 1;
-	else if (sysfs_streq(val, "auto"))
+		nowarn = true;
+	} else if (sysfs_streq(val, "auto")) {
 		new_val = get_nx_auto_mode();
-	else if (strtobool(val, &new_val) < 0)
+	} else if (strtobool(val, &new_val) < 0) {
 		return -EINVAL;
+	}
+
+	if (!nowarn && boot_cpu_has_bug(X86_BUG_ITLB_MULTIHIT)) {
+		if (new_val)
+			pr_warn_once(ITLB_MULTIHIT_NX_ON);
+		else
+			pr_warn_once(ITLB_MULTIHIT_NX_OFF);
+	}
 
 	__set_nx_huge_pages(new_val);
 
@@ -6094,9 +6115,24 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 int kvm_mmu_module_init(void)
 {
 	int ret = -ENOMEM;
+	bool mode;
 
-	if (nx_huge_pages == -1)
-		__set_nx_huge_pages(get_nx_auto_mode());
+	if (nx_huge_pages == -1) {
+		mode = get_nx_auto_mode();
+		if (boot_cpu_has_bug(X86_BUG_ITLB_MULTIHIT)) {
+			/*
+			 * Warn on the CPU multi-hit bug when `nx_huge_pages` is `auto`
+			 * by default. If cpu mitigations was enabled, warn that guest
+			 * huge pages may split, otherwise warn that the bug may cause
+			 * a CPU lockup because of a malicious guest.
+			 */
+			if (mode)
+				pr_warn_once(ITLB_MULTIHIT_NX_ON);
+			else
+				pr_warn_once(ITLB_MULTIHIT_NX_OFF);
+		}
+		__set_nx_huge_pages(mode);
+	}
 
 	/*
 	 * MMU roles use union aliasing which is, generally speaking, an
-- 
2.11.0

