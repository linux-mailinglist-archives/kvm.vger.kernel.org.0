Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15119433817
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 16:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhJSOO2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 10:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhJSOO1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 10:14:27 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2255C061746
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 07:12:14 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ls18so21726pjb.3
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 07:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jwDiBHAosBohHaAkBiPcb6Tc3RArgEKVoVHEwxH2t3A=;
        b=ZYEr3d9U8g8k/rZ7yxM65byVPiFEAxEZAyGz7bzfCZjizTU8/iFYTIcFSuCkGEYglA
         vuw7tkeHRRQV0uoWydr0h9FC2QA2cgmolb0XPkD7gsUfETKd2V5HIrSMNKGn/OL0Hr56
         ifwdfdigD3nkboN7CtpkhacxpnAKJneyL14lHdfpSoEQVwZRilWoIF5UvBCQpQWn72w5
         8XNJqAeZ7hyUJdAv04QXneUhMi+1yqy55rRtPCoSrjtzlvz7XHeeYdoMjRjlISn8GDxj
         jyr8gwQ7nucQnxrxKGQPf0sFj3KYCrip/d08cEfW8ynmGjWUpTfmF50uKpjphjB1IEzU
         /S3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jwDiBHAosBohHaAkBiPcb6Tc3RArgEKVoVHEwxH2t3A=;
        b=KxYoTyVnd9yl2xyAZExZeCYnRXzDhPrQQQuWOzo6dsV4y5NfJmlZPVIEih7gpfP6ka
         o9YmB/G9k4IOEVgKtAeLnGThTcR0Eof/rKEcVkjy3OpG+VXlwSotVlvFI+9SDv/TIEnL
         cpjJpX4wfHS0Xhtx/AEaIEbKxXXL3DUFvlcLrPUKb5rfLfF/Ky5A1qAZwuKIulu/9nWM
         tGVJD+PV/3xP/TMeihZpeW8h8j0Lcaiq4raSwlpR0ch4/nLq1zO+tzEDImfGsfS+e63N
         iON2OW4t7tbGEbOZ/6euvWnWUJ2+cTE3f0oMsZLiHwSEEg6iM77FsQ6MEpPoMceMMOkV
         UN9g==
X-Gm-Message-State: AOAM531oX6CQCVPVj4RwUfYp57iyd0dSWVb4IkFev8W7Y2b+BRw595iV
        y7yMrSjs/q/Jc9PdcT1wiNjVFw==
X-Google-Smtp-Source: ABdhPJyyp1LZu0w1xkPrmNjuR2S2whtXB9TfU7vm0uQICQ4fbS7xGqw6xutZXsz8ljwW8E3LM4lz/A==
X-Received: by 2002:a17:90b:341:: with SMTP id fh1mr90507pjb.6.1634652734404;
        Tue, 19 Oct 2021 07:12:14 -0700 (PDT)
Received: from n210-191-019.byted.org ([49.7.45.229])
        by smtp.googlemail.com with ESMTPSA id h22sm16221220pfc.116.2021.10.19.07.12.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Oct 2021 07:12:14 -0700 (PDT)
From:   Li Yu <liyu.yukiteru@bytedance.com>
To:     pbonzini@redhat.com
Cc:     liyu.yukiteru@bytedance.com,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Warn on nx_huge_pages for possible problems
Date:   Tue, 19 Oct 2021 22:11:01 +0800
Message-Id: <20211019141101.327397-1-liyu.yukiteru@bytedance.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <b2713829-1dad-de6b-5850-0c3a74e2f6f3@redhat.com>
References: <b2713829-1dad-de6b-5850-0c3a74e2f6f3@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add warning when `nx_huge_pages` is enabled by `auto` for hint that
huge pages may be splited by kernel.

Add warning when CVE-2018-12207 may arise but `nx_huge_pages` is
disabled for hint that malicious guest may cause a CPU lookup.

Signed-off-by: Li Yu <liyu.yukiteru@bytedance.com>
---
 arch/x86/kvm/mmu/mmu.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1a64ba5b9437..32026592e566 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6056,19 +6056,26 @@ static void __set_nx_huge_pages(bool val)
 	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
 }
 
+#define ITLB_MULTIHIT_NX_ON  "iTLB multi-hit CPU bug present and cpu mitigations enabled, huge pages may be splited by kernel for security. See CVE-2018-12207 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/multihit.html for details.\n"
+#define ITLB_MULTIHIT_NX_OFF "iTLB multi-hit CPU bug present and cpu mitigations enabled, malicious guest may cause a CPU lookup. See CVE-2018-12207 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/multihit.html for details.\n"
+
 static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 {
 	bool old_val = nx_huge_pages;
 	bool new_val;
 
 	/* In "auto" mode deploy workaround only if CPU has the bug. */
-	if (sysfs_streq(val, "off"))
+	if (sysfs_streq(val, "off")) {
 		new_val = 0;
-	else if (sysfs_streq(val, "force"))
+		if (get_nx_auto_mode() && new_val != old_val)
+			pr_warn(ITLB_MULTIHIT_NX_OFF);
+	} else if (sysfs_streq(val, "force"))
 		new_val = 1;
-	else if (sysfs_streq(val, "auto"))
+	else if (sysfs_streq(val, "auto")) {
 		new_val = get_nx_auto_mode();
-	else if (strtobool(val, &new_val) < 0)
+		if (new_val && new_val != old_val)
+			pr_warn(ITLB_MULTIHIT_NX_ON);
+	} else if (strtobool(val, &new_val) < 0)
 		return -EINVAL;
 
 	__set_nx_huge_pages(new_val);
@@ -6095,8 +6102,11 @@ int kvm_mmu_module_init(void)
 {
 	int ret = -ENOMEM;
 
-	if (nx_huge_pages == -1)
+	if (nx_huge_pages == -1) {
 		__set_nx_huge_pages(get_nx_auto_mode());
+		if (is_nx_huge_page_enabled())
+			pr_warn_once(ITLB_MULTIHIT_NX_ON);
+	}
 
 	/*
 	 * MMU roles use union aliasing which is, generally speaking, an
-- 
2.11.0

