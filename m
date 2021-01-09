Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98B32EFC61
	for <lists+kvm@lfdr.de>; Sat,  9 Jan 2021 01:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbhAIAtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 19:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbhAIAtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 19:49:14 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5921DC0617A6
        for <kvm@vger.kernel.org>; Fri,  8 Jan 2021 16:48:03 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id e25so10635032qka.3
        for <kvm@vger.kernel.org>; Fri, 08 Jan 2021 16:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=jYzoDTNoVvtxiYfXr7ZVMmi5PaPZLOefqEPk2ReBEho=;
        b=rYTHs6VtOzbi6t9kEubz4Bd+X+LSpeh5CRREL9KKvWx45B0x4J0JqtXf703AejLdtZ
         oZd0vk11Abhc/dNaTO6AwGRfWUzPa+15qfOmKU3HE7R5rmTdbuOlJEndJ9HeBFcLKLCx
         d5OdbCJAuc7xXDH1++YnlhT/Wjk3cDchoMS3Yqhfprh7iobuflp11tBHw1a+E+j06SE2
         fdJP6K2FCEV09r1EqKSirOXpb2Bt+orJYtoE1AIdrGg+cmynp9ZM2KT0aShabNNamBGE
         lAryM1BjRSsxC9owM+IXltC9RJRskBjuF6PV4Mwyh532wHel/6LvgcsYD3s6n6ldH7L3
         YFqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=jYzoDTNoVvtxiYfXr7ZVMmi5PaPZLOefqEPk2ReBEho=;
        b=cZcIE4eRp67Zqxwzci33huUPG81Ch9l5uJmYCJgyVZZplH7tVANrmX5wzaCUdArayD
         zoP80ffK23qzMMP/TZVWOfkCy78v7HTyUYz0MGDnXj6MRFD7lHEBpbVy+zTgH7Tw8OlM
         c5wP1sNaAvXHYidGkUWzM2jNpXLwMyAE3km2TsS41rzciGiPJLeaE9o4bLe9l6RwbHuS
         NJoN9kvYUor0oXtVLM1ZYHxiKMBK4Imn2hmO+52mpKMDN5R0pGLq/SYEv3zDJ4A6Cauj
         RlSflbZqVG4uH5bGJP+sFhseblF7jpCDsks3WGrJIPHICjg0Z6L1WNrnP0fYjPhf/av3
         nIaQ==
X-Gm-Message-State: AOAM532a0jszXNy/DJrXZ/ihETI/modnsBOn0uSbmv/rxQUUrpTXpOoU
        GwnjnC++d/VAabrZNqkGi+M5dp8mVvc=
X-Google-Smtp-Source: ABdhPJxpQ3wLhaubUoaRGswmZy7bijjJZZ0cyMCOzgTd51mh8LwTMxQc3nOKUrHHjQDFkTl1m85lzfclaVs=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a0c:fa11:: with SMTP id q17mr6347369qvn.55.1610153282514;
 Fri, 08 Jan 2021 16:48:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Jan 2021 16:47:12 -0800
In-Reply-To: <20210109004714.1341275-1-seanjc@google.com>
Message-Id: <20210109004714.1341275-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210109004714.1341275-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 11/13] KVM: SVM: Drop redundant svm_sev_enabled() helper
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
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>,
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 6 +++---
 arch/x86/kvm/svm/svm.h | 5 -----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 8c34c467a09d..1b9174a49b65 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1052,7 +1052,7 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	struct kvm_sev_cmd sev_cmd;
 	int r;
 
-	if (!svm_sev_enabled() || !sev_enabled)
+	if (!sev_enabled)
 		return -ENOTTY;
 
 	if (!argp)
@@ -1314,7 +1314,7 @@ void __init sev_hardware_setup(void)
 
 void sev_hardware_teardown(void)
 {
-	if (!svm_sev_enabled())
+	if (!sev_enabled)
 		return;
 
 	bitmap_free(sev_asid_bitmap);
@@ -1325,7 +1325,7 @@ void sev_hardware_teardown(void)
 
 int sev_cpu_init(struct svm_cpu_data *sd)
 {
-	if (!svm_sev_enabled())
+	if (!sev_enabled)
 		return 0;
 
 	sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1, sizeof(void *),
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4eb4bab0ca3e..8cb4395b58a0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -569,11 +569,6 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
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
2.30.0.284.gd98b1dd5eaa7-goog

