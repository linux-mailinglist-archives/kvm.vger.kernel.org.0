Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378F744B8FE
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 23:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbhKIWy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 17:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344501AbhKIWxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 17:53:35 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54833C110F39
        for <kvm@vger.kernel.org>; Tue,  9 Nov 2021 14:23:55 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id x14-20020a627c0e000000b0049473df362dso693757pfc.12
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 14:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=L4jXlRrxPcFEy9Wrc/UQKAdtud2lPJJqmRXigpk/f7k=;
        b=YuAnFKXV72MV4PR1zyfuZKIGUo4IMn3A5ATFCTnFuyQLiEAOkgrf4jvVVSEZ/q4tvx
         OG+SwuIUqH7+KhK72orsQquMbSOS1twyt8TdSssYOd3YENMFQiN2ssP9V8aOM9DpKOZR
         AcccZmb33EQFNUwlfiaXFad3bywXqi9vmfCtbd/KpvFbymSB8APMD/vq+n0LoSa0pWyH
         t8LieFeQl2uddcdmqutVQxmcRyrBiTI29wq5mygUTHNZxUC+ckMShFXQ+ZxPYD85fUYx
         yuMCubfUecbOLQQha44HFtmElOtPq4iNH06LfwGf4iNEW3S/fNhPWgV9pi110weFlvIQ
         e3eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=L4jXlRrxPcFEy9Wrc/UQKAdtud2lPJJqmRXigpk/f7k=;
        b=oPhNcTIwtdKXvTcnZ2yDu9E65JILAs3iMkI9AckgekPiiUb5fJNPBBmvtDESMcBpl6
         7QXHrDMhZayEA8RvYnC2CBbaOZowlwNyIj8SLP0Zr1nTiHSEgXDOlTDTvsBZqEES4vWY
         v0ZiEFLoATxwItqIimPUZBEqDv2CHibEmwubstpsJQxe/B3RFuG9pSxIoAtLLMOvE/zp
         z5YseNbOtSuoyw++zZCn2QJoYfhs08fXEIB0ag3v2rDoxUP+456mXIJs/srVwOTcKRqO
         +HlzVrywPUoUia6VW/A0TON9m92NQKJgbkbPXKAzKfz3UZBIGbG+My3v+eZmVbzNQ0sO
         EFJw==
X-Gm-Message-State: AOAM532pWB30fRvUnGTLeJAVug5w/rs87wzI2gUsisylQQuDNynqRKhp
        kzqPoxaGau2JBIJ5VeLBkCoMpjFRMI4=
X-Google-Smtp-Source: ABdhPJyZZ5Zfp0zoksrsKP+Pd/8x4ZwCiC16K67k3TkZcWniDwjp1+1x5o2Tgfuy3fTSD/bWYaSa3yMMOrE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e74a:b0:142:114c:1f1e with SMTP id
 p10-20020a170902e74a00b00142114c1f1emr10856330plf.78.1636496634820; Tue, 09
 Nov 2021 14:23:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  9 Nov 2021 22:23:49 +0000
In-Reply-To: <20211109222350.2266045-1-seanjc@google.com>
Message-Id: <20211109222350.2266045-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211109222350.2266045-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 1/2] KVM: SEV: Return appropriate error codes if SEV-ES
 scratch setup fails
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return appropriate error codes if setting up the GHCB scratch area for an
SEV-ES guest fails.  In particular, returning -EINVAL instead of -ENOMEM
when allocating the kernel buffer could be confusing as userspace would
likely suspect a guest issue.

Fixes: 8f423a80d299 ("KVM: SVM: Support MMIO for an SEV-ES guest")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3e2769855e51..ea8069c9b5cb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2299,7 +2299,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 }
 
 #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
-static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
+static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct ghcb *ghcb = svm->ghcb;
@@ -2310,14 +2310,14 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	scratch_gpa_beg = ghcb_get_sw_scratch(ghcb);
 	if (!scratch_gpa_beg) {
 		pr_err("vmgexit: scratch gpa not provided\n");
-		return false;
+		return -EINVAL;
 	}
 
 	scratch_gpa_end = scratch_gpa_beg + len;
 	if (scratch_gpa_end < scratch_gpa_beg) {
 		pr_err("vmgexit: scratch length (%#llx) not valid for scratch address (%#llx)\n",
 		       len, scratch_gpa_beg);
-		return false;
+		return -EINVAL;
 	}
 
 	if ((scratch_gpa_beg & PAGE_MASK) == control->ghcb_gpa) {
@@ -2335,7 +2335,7 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 		    scratch_gpa_end > ghcb_scratch_end) {
 			pr_err("vmgexit: scratch area is outside of GHCB shared buffer area (%#llx - %#llx)\n",
 			       scratch_gpa_beg, scratch_gpa_end);
-			return false;
+			return -EINVAL;
 		}
 
 		scratch_va = (void *)svm->ghcb;
@@ -2348,18 +2348,18 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 		if (len > GHCB_SCRATCH_AREA_LIMIT) {
 			pr_err("vmgexit: scratch area exceeds KVM limits (%#llx requested, %#llx limit)\n",
 			       len, GHCB_SCRATCH_AREA_LIMIT);
-			return false;
+			return -EINVAL;
 		}
 		scratch_va = kzalloc(len, GFP_KERNEL_ACCOUNT);
 		if (!scratch_va)
-			return false;
+			return -ENOMEM;
 
 		if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, len)) {
 			/* Unable to copy scratch area from guest */
 			pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
 
 			kfree(scratch_va);
-			return false;
+			return -EFAULT;
 		}
 
 		/*
@@ -2375,7 +2375,7 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	svm->ghcb_sa = scratch_va;
 	svm->ghcb_sa_len = len;
 
-	return true;
+	return 0;
 }
 
 static void set_ghcb_msr_bits(struct vcpu_svm *svm, u64 value, u64 mask,
@@ -2514,10 +2514,10 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	ghcb_set_sw_exit_info_1(ghcb, 0);
 	ghcb_set_sw_exit_info_2(ghcb, 0);
 
-	ret = -EINVAL;
 	switch (exit_code) {
 	case SVM_VMGEXIT_MMIO_READ:
-		if (!setup_vmgexit_scratch(svm, true, control->exit_info_2))
+		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);
+		if (ret)
 			break;
 
 		ret = kvm_sev_es_mmio_read(vcpu,
@@ -2526,7 +2526,8 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 					   svm->ghcb_sa);
 		break;
 	case SVM_VMGEXIT_MMIO_WRITE:
-		if (!setup_vmgexit_scratch(svm, false, control->exit_info_2))
+		ret = setup_vmgexit_scratch(svm, false, control->exit_info_2);
+		if (ret)
 			break;
 
 		ret = kvm_sev_es_mmio_write(vcpu,
@@ -2569,6 +2570,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
 			    control->exit_info_1, control->exit_info_2);
+		ret = -EINVAL;
 		break;
 	default:
 		ret = svm_invoke_exit_handler(vcpu, exit_code);
@@ -2579,8 +2581,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 {
-	if (!setup_vmgexit_scratch(svm, in, svm->vmcb->control.exit_info_2))
-		return -EINVAL;
+	int r;
+
+	r = setup_vmgexit_scratch(svm, in, svm->vmcb->control.exit_info_2);
+	if (r)
+		return r;
 
 	return kvm_sev_es_string_io(&svm->vcpu, size, port,
 				    svm->ghcb_sa, svm->ghcb_sa_len / size, in);
-- 
2.34.0.rc0.344.g81b53c2807-goog

