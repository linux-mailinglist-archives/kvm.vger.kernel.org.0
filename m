Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B692B32F7B5
	for <lists+kvm@lfdr.de>; Sat,  6 Mar 2021 03:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhCFCA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 21:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhCFB7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 20:59:46 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34506C06175F
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 17:59:46 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id v62so4573862ybb.15
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 17:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=UmwQQ/S7KcF1DBLXWAPSZiS9PiMxi8tI2OBIXEjWq68=;
        b=m7Fz8WwUmbR3fF5JyIInUPh79JvG/xSefO5l/jjX6PmWpjYc+1nzPz9SfVLn4s0CGW
         /nAp1QjG33onZ6tJElA3a4Wd5CwXnkW+GWYo/qBgU5pKppzDQdNapioeIRDSjqMMdPXN
         gAR4FVL/DKPT4vcfBnPTWymjjd7N7jGJsF6aj1LzX1Tz8kNK0knXjyxYxBzH4sn4GMKi
         7HThD4nKQm34Z8sTLK0MH4egPR1UbLf4+03ubEus+hFDIHestveHyuwE4/+HrdZ/HOxJ
         +ZMSWqKpRVVEv3zUHnC/oiokRNvGigOnBESg1n0tYGOqeLn7PhoZCfCav61SvtemfHwF
         Lspw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=UmwQQ/S7KcF1DBLXWAPSZiS9PiMxi8tI2OBIXEjWq68=;
        b=qIDyn0reSX42PTacKtyp8yhSLpoKrFriS4yYds0ZSLNa8HhA6dInI3cvebjntQzCTP
         /3RLGKa6WjAbUEY0S/35l4tjr9BzntUcY5MxEOI7mqe/xrS0fflNCg3r8+vrxJvLndz2
         UyMibvMOYOFZU4Eug/sCt4/A3yM0z/mLnSvhD+dmC3QWAaqI+ypHs0onQ4cEoklm0bJf
         Ft+FUld7vTh784EQFrTqDSv9uprstWhiUWSy5ftblcS/8kbqhSw2xodbpGdig95ZKdyx
         VcbtiIyhXsEXvDgVJHKEhL+hdrCIvgAJIsy0IttDaJY+iKJ3F42t0HO23XNFesYgXYoI
         hv1A==
X-Gm-Message-State: AOAM531B5GBt0Qu6fJb6Q/teWs9Cz7BvexZJew6Bo/6MY2xHxbJVKdnF
        L/38wx5OERjZi8wTsNFvntdKObxOGlg=
X-Google-Smtp-Source: ABdhPJyxAZtOQzcbN/L96f2uwopVXuYktoU72bCi7I50CrOJVbHyDYBZuQFEzxexN+SveYKNXkUYafl6o5o=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:fc04:f9df:1efb:bf0c])
 (user=seanjc job=sendgmr) by 2002:a25:d017:: with SMTP id h23mr18602507ybg.267.1614995985445;
 Fri, 05 Mar 2021 17:59:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 17:59:03 -0800
In-Reply-To: <20210306015905.186698-1-seanjc@google.com>
Message-Id: <20210306015905.186698-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210306015905.186698-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 12/14] KVM: SVM: Drop redundant svm_sev_enabled() helper
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

Replace calls to svm_sev_enabled() with direct checks on sev_enabled, or
in the case of svm_mem_enc_op, simply drop the call to svm_sev_enabled().
This effectively replaces checks against a valid max_sev_asid with checks
against sev_enabled.  sev_enabled is forced off by sev_hardware_setup()
if max_sev_asid is invalid, all call sites are guaranteed to run after
sev_hardware_setup(), and all of the checks care about SEV being fully
enabled (as opposed to intentionally handling the scenario where
max_sev_asid is valid but SEV enabling fails due to OOM).

Reviewed by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 6 +++---
 arch/x86/kvm/svm/svm.h | 5 -----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4685be80f551..9837fd753d88 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1128,7 +1128,7 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	struct kvm_sev_cmd sev_cmd;
 	int r;
 
-	if (!svm_sev_enabled() || !sev_enabled)
+	if (!sev_enabled)
 		return -ENOTTY;
 
 	if (!argp)
@@ -1397,7 +1397,7 @@ void __init sev_hardware_setup(void)
 
 void sev_hardware_teardown(void)
 {
-	if (!svm_sev_enabled())
+	if (!sev_enabled)
 		return;
 
 	bitmap_free(sev_asid_bitmap);
@@ -1408,7 +1408,7 @@ void sev_hardware_teardown(void)
 
 int sev_cpu_init(struct svm_cpu_data *sd)
 {
-	if (!svm_sev_enabled())
+	if (!sev_enabled)
 		return 0;
 
 	sd->sev_vmcbs = kcalloc(max_sev_asid + 1, sizeof(void *), GFP_KERNEL);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0953251232c8..8a52cbc2dee7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -548,11 +548,6 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 extern unsigned int max_sev_asid;
 
-static inline bool svm_sev_enabled(void)
-{
-	return IS_ENABLED(CONFIG_KVM_AMD_SEV) ? max_sev_asid : 0;
-}
-
 void sev_vm_destroy(struct kvm *kvm);
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp);
 int svm_register_enc_region(struct kvm *kvm,
-- 
2.30.1.766.gb4fecdf3b7-goog

