Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E485232F7B3
	for <lists+kvm@lfdr.de>; Sat,  6 Mar 2021 03:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhCFCA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 21:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhCFB7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 20:59:44 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE1DC061760
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 17:59:43 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b127so4577048ybc.13
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 17:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=m5zu6dZTIYcYR66YPf0OYgk5GVdLD4L8koVwvit/KmE=;
        b=R5cpbSbNlA5o5FvKXYsU5KrvKUnJjS2E3uW/ohTrO2BIX6UTkLqME2XlTTFOUv+TPd
         Gs/v7eP3x81z8WyBs3QnUec8Iueufs1mz44izLeXGFNyeweKNJ5liSFsOeuBAZToD5y+
         vtDWv5sXs/xobScXrHm49IBCY/iNnD/hRSRsC5pmXFoygIAUpNaiuQMe3v9swafmleac
         oLqcLS2RqIn7MAJOMT4nt/aDGKn9r2+VL4DES4g2ZYKQhXSpZ0LlCwTjf5bg+XZk8m2p
         g01xhLunOf+Z1FQ5ALJQUTPGaP5Yt0ygnjHWwWiD4erHGQfPZatIazJc/A1GrTGsPNtg
         Iazw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=m5zu6dZTIYcYR66YPf0OYgk5GVdLD4L8koVwvit/KmE=;
        b=bci12H1U1BFSP5oGaR0sT6dARSnXifozqGFg2quOa9iKRmTnUBvtH7BcOVK+aU6ILA
         XHCt9N3vw7aShzLRASFemsLNWbbv0e0k+2wRlDEI6QCvDDhI7sE6AhOYz5EnlsDKqMok
         O9eVb1ZdQEjCbZj5+sgJZo5jELamMDn8SK1ZZ0VFv6DlNOzbDMPIfbR2xEz540iox1Pf
         xptcYUUGRjDZuukzvLAMup0JQWKVsyy8qGNtjLmQEm0WB/Oxu52NGJIjgxlcYUDJj2JF
         9Dd8+3VpHPzUHUKV+XWgx0jKERjC/qe0ewlOd5/8SHZe/T6A9uYzUyZpm3ulfZuL97iB
         xWJA==
X-Gm-Message-State: AOAM5301H5dYDW28d5zPcWftzm7pb8dxG+DBsiXhWmtfbD8sy01MTFJn
        CqkegEoySIJEnyI/eAtD9h6CYbAuA5A=
X-Google-Smtp-Source: ABdhPJwua8ZD9rmpU91xeZpkm5rktRwEN6Dy3Z9ZmZBLMz+z6tj+Xn6SVxBmXnMdbfG8E1xYCZBjjk/fLlk=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:fc04:f9df:1efb:bf0c])
 (user=seanjc job=sendgmr) by 2002:a25:d091:: with SMTP id h139mr16206778ybg.437.1614995983056;
 Fri, 05 Mar 2021 17:59:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 17:59:02 -0800
In-Reply-To: <20210306015905.186698-1-seanjc@google.com>
Message-Id: <20210306015905.186698-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210306015905.186698-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 11/14] KVM: SVM: Move SEV VMCB tracking allocation to sev.c
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the allocation of the SEV VMCB array to sev.c to help pave the way
toward encapsulating SEV enabling wholly within sev.c.

No functional change intended.

Reviewed by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 12 ++++++++++++
 arch/x86/kvm/svm/svm.c | 16 ++++++++--------
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 63d4f624c742..4685be80f551 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1406,6 +1406,18 @@ void sev_hardware_teardown(void)
 	sev_flush_asids();
 }
 
+int sev_cpu_init(struct svm_cpu_data *sd)
+{
+	if (!svm_sev_enabled())
+		return 0;
+
+	sd->sev_vmcbs = kcalloc(max_sev_asid + 1, sizeof(void *), GFP_KERNEL);
+	if (!sd->sev_vmcbs)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /*
  * Pages used by hardware to hold guest encrypted state must be flushed before
  * returning them to the system.
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0fa6c409b484..51cea470d0bb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -549,22 +549,22 @@ static void svm_cpu_uninit(int cpu)
 static int svm_cpu_init(int cpu)
 {
 	struct svm_cpu_data *sd;
+	int ret;
 
 	sd = kzalloc(sizeof(struct svm_cpu_data), GFP_KERNEL);
 	if (!sd)
 		return -ENOMEM;
 	sd->cpu = cpu;
 	sd->save_area = alloc_page(GFP_KERNEL);
-	if (!sd->save_area)
+	if (!sd->save_area) {
+		ret = -ENOMEM;
 		goto free_cpu_data;
+	}
 	clear_page(page_address(sd->save_area));
 
-	if (svm_sev_enabled()) {
-		sd->sev_vmcbs = kcalloc(max_sev_asid + 1, sizeof(void *),
-					GFP_KERNEL);
-		if (!sd->sev_vmcbs)
-			goto free_save_area;
-	}
+	ret = sev_cpu_init(sd);
+	if (ret)
+		goto free_save_area;
 
 	per_cpu(svm_data, cpu) = sd;
 
@@ -574,7 +574,7 @@ static int svm_cpu_init(int cpu)
 	__free_page(sd->save_area);
 free_cpu_data:
 	kfree(sd);
-	return -ENOMEM;
+	return ret;
 
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index aec70f6cd243..0953251232c8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -562,6 +562,7 @@ int svm_unregister_enc_region(struct kvm *kvm,
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
+int sev_cpu_init(struct svm_cpu_data *sd);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
-- 
2.30.1.766.gb4fecdf3b7-goog

