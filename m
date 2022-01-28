Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA1849F01E
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345331AbiA1AyS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345067AbiA1Axy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:54 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA03C0613EF
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:47 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id o194-20020a62cdcb000000b004c9d2b4bfd8so2480723pfg.7
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=IKra2yE5BUeML4Gu42Nb19pN2PZRnep0CqEh3hnPyCQ=;
        b=LS+zwtEG7jphpNmJTFioDe3rVdx52JF+7cYcEhl8MFTXS8rdNDCDJ+BQCRz46pVvRp
         WK/hypcY5HIeFZF0LdTgixQNf0ffr0Le3Ik2OVDvC2kG/3D6zNVpqVtUXuled5y9jWhC
         ecQsoX/O4/sIYxilV9Woz+aqdcoeo8f2wPZYXWnt5o3VxLcqmIyzvakIx1BjAwxl3Qvl
         WqBSyL9eIuUkNhifeKyBNsajAA310/NecdUXtkSQMlHvoq1jzNXtGzf9cSebsB2enoEK
         SGHFkrrAtGt+u4ztwnDewZdsaephD/Jhou5rrYEzkyn7tGI7cAVYwCNnje39fPZkEidO
         wptg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=IKra2yE5BUeML4Gu42Nb19pN2PZRnep0CqEh3hnPyCQ=;
        b=ezU8TKU8ZHM4b+jc1QuxK4pYmIx5V/xAuh52cELDQnMgAAufqiHBHIn51zz7GoqGQE
         boUK6BxcNZCIL8P51Vb/7wVj/Biakz0YmkQtJg7ZKOcmfNoZDLHx7yIktT7EQMtbQMfi
         7/RJAPRD15yGh+BnUDAPnPEtQSHrEt4V14JX92CcRCULLQSMr6SQXR7M3PfHq2s3jvSi
         qF1sbqZf9X0Uz7mdeD6+jzZv2SM3+9nrXBoVdt37eHX3EKWCj2Fe119Wnhr5nLO9NsiA
         uyBX4TVSK/VptOXqV98X9Xoh75VL213AcyAbTMHBc/O0r94Izfq+JnxboeL/7jqcz+rl
         pjAw==
X-Gm-Message-State: AOAM531M6C0dSAe5WhLgEQS+59eOjmIjfow7tcM2XzjbNChRLb6kOuCh
        tSQvENiW4ZxujlilelZvPhA0pjbQgrA=
X-Google-Smtp-Source: ABdhPJxNhbEs851OGykz4C3A1h6jM1Ik83dhmCFQEm2x2LtdiGSbJXPIkAD9JRHU4RZIEFg3eJQsGklBQAg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:94a9:: with SMTP id a9mr5452769pfl.78.1643331227310;
 Thu, 27 Jan 2022 16:53:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:52:06 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-21-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 20/22] KVM: SVM: Rename SEV implemenations to conform to
 kvm_x86_ops hooks
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename svm_vm_copy_asid_from() and svm_vm_migrate_from() to conform to
the names used by kvm_x86_ops, and opportunistically use "sev" instead of
"svm" to more precisely identify the role of the hooks.

svm_vm_copy_asid_from() in particular was poorly named as the function
does much more than simply copy the ASID.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 14 +++++++-------
 arch/x86/kvm/svm/svm.c | 14 +++++++-------
 arch/x86/kvm/svm/svm.h | 14 +++++++-------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7f346ddcae0a..4662e5fd7559 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1681,7 +1681,7 @@ static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
 	return 0;
 }
 
-int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
+int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 {
 	struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
 	struct kvm_sev_info *src_sev, *cg_cleanup_sev;
@@ -1761,7 +1761,7 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 	return ret;
 }
 
-int svm_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
+int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
 	int r;
@@ -1858,8 +1858,8 @@ int svm_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	return r;
 }
 
-int svm_register_enc_region(struct kvm *kvm,
-			    struct kvm_enc_region *range)
+int sev_mem_enc_register_region(struct kvm *kvm,
+				struct kvm_enc_region *range)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct enc_region *region;
@@ -1932,8 +1932,8 @@ static void __unregister_enc_region_locked(struct kvm *kvm,
 	kfree(region);
 }
 
-int svm_unregister_enc_region(struct kvm *kvm,
-			      struct kvm_enc_region *range)
+int sev_mem_enc_unregister_region(struct kvm *kvm,
+				  struct kvm_enc_region *range)
 {
 	struct enc_region *region;
 	int ret;
@@ -1972,7 +1972,7 @@ int svm_unregister_enc_region(struct kvm *kvm,
 	return ret;
 }
 
-int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
+int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 {
 	struct file *source_kvm_file;
 	struct kvm *source_kvm;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4b9041e931a8..a075c6458a27 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1574,7 +1574,7 @@ static void svm_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 	vmcb_mark_dirty(svm->vmcb, VMCB_DT);
 }
 
-static void svm_post_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
+static void sev_post_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -4497,7 +4497,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_cpl = svm_get_cpl,
 	.get_cs_db_l_bits = svm_get_cs_db_l_bits,
 	.set_cr0 = svm_set_cr0,
-	.post_set_cr3 = svm_post_set_cr3,
+	.post_set_cr3 = sev_post_set_cr3,
 	.is_valid_cr4 = svm_is_valid_cr4,
 	.set_cr4 = svm_set_cr4,
 	.set_efer = svm_set_efer,
@@ -4581,12 +4581,12 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.leave_smm = svm_leave_smm,
 	.enable_smi_window = svm_enable_smi_window,
 
-	.mem_enc_ioctl = svm_mem_enc_ioctl,
-	.mem_enc_register_region = svm_register_enc_region,
-	.mem_enc_unregister_region = svm_unregister_enc_region,
+	.mem_enc_ioctl = sev_mem_enc_ioctl,
+	.mem_enc_register_region = sev_mem_enc_register_region,
+	.mem_enc_unregister_region = sev_mem_enc_unregister_region,
 
-	.vm_copy_enc_context_from = svm_vm_copy_asid_from,
-	.vm_move_enc_context_from = svm_vm_migrate_from,
+	.vm_copy_enc_context_from = sev_vm_copy_enc_context_from,
+	.vm_move_enc_context_from = sev_vm_move_enc_context_from,
 
 	.can_emulate_instruction = svm_can_emulate_instruction,
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7cf81e029f9c..67c17509c4c0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -598,13 +598,13 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
 extern unsigned int max_sev_asid;
 
 void sev_vm_destroy(struct kvm *kvm);
-int svm_mem_enc_ioctl(struct kvm *kvm, void __user *argp);
-int svm_register_enc_region(struct kvm *kvm,
-			    struct kvm_enc_region *range);
-int svm_unregister_enc_region(struct kvm *kvm,
-			      struct kvm_enc_region *range);
-int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd);
-int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd);
+int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp);
+int sev_mem_enc_register_region(struct kvm *kvm,
+				struct kvm_enc_region *range);
+int sev_mem_enc_unregister_region(struct kvm *kvm,
+				  struct kvm_enc_region *range);
+int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd);
+int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd);
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_set_cpu_caps(void);
 void __init sev_hardware_setup(void);
-- 
2.35.0.rc0.227.g00780c9af4-goog

