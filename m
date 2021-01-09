Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3DD2EFC6B
	for <lists+kvm@lfdr.de>; Sat,  9 Jan 2021 01:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbhAIAth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 19:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbhAIAtg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 19:49:36 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAFEC0617A4
        for <kvm@vger.kernel.org>; Fri,  8 Jan 2021 16:48:00 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id h18so9518136qtr.2
        for <kvm@vger.kernel.org>; Fri, 08 Jan 2021 16:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=GZIGOjVPda+c+O82UamW1h7IewucBItkY9B2sexVha8=;
        b=nDFk3WbLzXD2CBf61X7QA3DO3OSq5V59DWDGCi6i+KTqpxvu+JJDnXm3xHU+hr6Bz7
         xmHonSFW0NOY6zZ0SktkyIxYosOmBgSbl/Dr6AYd4lPimUvBH0Td6tMW8DMG31TkLHom
         VpfhFYL7V+SgXAC7JTaCjbbSkEdKeUP1dB/tf5vCInrJcPRkNI96DOrFb8/8Jla1CzGm
         UqSF530amN0qmVtPLEIW8GP8DnKTrfea+KCeyDlbtCykDakVgdLpVki40DgzRfjcw+r6
         yBSwX8nA8lx1SIq+Z2Sv4b5t8qHskOQUVQLzhqi7JydBbrPOKPCubmhhK/fizNOJsCo1
         ioIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=GZIGOjVPda+c+O82UamW1h7IewucBItkY9B2sexVha8=;
        b=FY24vk9+CZGk74IibmSP8aC5wSWvwfA15Xro5nZajyElO2MDgQ0qbK2FBlhzcoZHBu
         8AWWxl0vKngOMhRZSKUJInVsIkC6lswQSY8/nbLnjmXX/TagPKLE2eRL+VMnJuly7yFa
         H1tAhnabT0/2VVbuiXVl7ZCiburpnZ1WAdKZNZb9tQ5qwLfeXwS1r14vCsCc4Jc336YI
         AF5p4ycqF071P4R+OXYPeBx3Qznkm/EW6j3nKeUkMLunabguc7vUr22gbL7Rz4EUXJyG
         AABFgwPiDs5iY4CbJEHOMFKbmrIrXAKeVxTm4evpnLG59+zsRytZ7TagZRS0f5ZfOLD6
         WX5A==
X-Gm-Message-State: AOAM530yWmlofVTMoNOtwcVNx5lWDZNaNuNKtJdmPmgIB4khzsyUVx/y
        5SS+iNkzy+xU6ql8uhzl1EUgUhvHjYw=
X-Google-Smtp-Source: ABdhPJzlKxa6a6SGn1UvXiverv1gdWB35eyRHSNHFI7M+3xx/JUIzg/FiWxrsObSt1oY3EUAgGhHAv03Mn4=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a05:6214:370:: with SMTP id
 t16mr6428915qvu.22.1610153280070; Fri, 08 Jan 2021 16:48:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Jan 2021 16:47:11 -0800
In-Reply-To: <20210109004714.1341275-1-seanjc@google.com>
Message-Id: <20210109004714.1341275-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210109004714.1341275-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 10/13] KVM: SVM: Move SEV VMCB tracking allocation to sev.c
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

Move the allocation of the SEV VMCB array to sev.c to help pave the way
toward encapsulating SEV enabling wholly within sev.c.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 13 +++++++++++++
 arch/x86/kvm/svm/svm.c | 17 ++++++++---------
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3d25d24bcb48..8c34c467a09d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1323,6 +1323,19 @@ void sev_hardware_teardown(void)
 	sev_flush_asids();
 }
 
+int sev_cpu_init(struct svm_cpu_data *sd)
+{
+	if (!svm_sev_enabled())
+		return 0;
+
+	sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1, sizeof(void *),
+				      GFP_KERNEL | __GFP_ZERO);
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
index bb7b99743bea..89b95fb87a0c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -552,23 +552,22 @@ static void svm_cpu_uninit(int cpu)
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
-		sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1,
-					      sizeof(void *),
-					      GFP_KERNEL | __GFP_ZERO);
-		if (!sd->sev_vmcbs)
-			goto free_save_area;
-	}
+	ret = sev_cpu_init(sd);
+	if (ret)
+		goto free_save_area;
 
 	per_cpu(svm_data, cpu) = sd;
 
@@ -578,7 +577,7 @@ static int svm_cpu_init(int cpu)
 	__free_page(sd->save_area);
 free_cpu_data:
 	kfree(sd);
-	return -ENOMEM;
+	return ret;
 
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8e169835f52a..4eb4bab0ca3e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -583,6 +583,7 @@ int svm_unregister_enc_region(struct kvm *kvm,
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
+int sev_cpu_init(struct svm_cpu_data *sd);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
-- 
2.30.0.284.gd98b1dd5eaa7-goog

