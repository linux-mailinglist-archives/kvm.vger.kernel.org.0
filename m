Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8BB412AE3
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 04:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241710AbhIUCC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 22:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238117AbhIUB5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 21:57:06 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F65CC06B67C
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:26 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id n19-20020ac81e13000000b0029f679691eeso199388204qtl.20
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=V4gYi0TTIcL9PO81BBz2SfHWERFnKGqZgSsduom9Vy4=;
        b=fj+ZKUq090Lg18RcXbI0BNLZBuoYwaOPE8nbhI2hFpZj/fx+vhFHviqt0CGNmAbecw
         mVi8RyoMjYBVibTmbMtIUJ92d+MkQkZw57a1VZapNnnesvEq+1F+B9XYEqXIpKHejw3Q
         HT9H4po5u/0IWv+vUVNqpSR+V6aS+8bPKfRcfvSCVJUoQ6FJqtXAG7ZMqOVMgCvyGPvM
         XtULIdBZCEIWyXP2Iw1zBj6MYwoyYUOESVi+et/508aKJAa8mnLNe0WdVABCdjpx1iTU
         PsECijMK7T4B9S8bzPtuM3k1JvuDNAUa+1xGu7JhNCuyQXnUcWMUbzIpkF1S2ipyi7Xb
         OZKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=V4gYi0TTIcL9PO81BBz2SfHWERFnKGqZgSsduom9Vy4=;
        b=nfRi8MWbZR+v2FSeN3pSIcguTS/5xhND65SaFnOJ13JuLL4MjZx9c41pXnB/v70LBi
         cu44zc9oDG0LCO0Zo1miBiPk8Co468J1EKC+U4oWyYebieR5hL8VDcsSMi35zyNZtGO7
         x+jfSZ+6aY9x3fjJ/4Nh9UjqfcwtlQVUuWA2g1XGMnPIiTunTDc9CCTS96v0R9PhdMCt
         CbdWRnciesA+v4knvrVvrTaLdqrKj4C/5uoBBPh/KGsVVPNhdJ6KohJ3mBSxu2wWilFv
         jNozKxZmCapSRjMpJCPRHyhIzJ0dK0sSDz8xmVDEtKrDG915luuubvLTPjrZePiRPmow
         9cNA==
X-Gm-Message-State: AOAM5328I8nmM8ANfdyLR4y7sLqc0dSjuc3ngxjZnO6TwJ8+rmG+XlLT
        YhGGOpEg16uouvlHy9G9SsIdlqmnFpQ=
X-Google-Smtp-Source: ABdhPJyeFixbXPhvqafDv+PeB1G0P7Cn7fCErjew3IAz4pJRTBhzKf13g4EpLOuVByUkOiAtgXrkx2TxgTU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e430:8766:b902:5ee3])
 (user=seanjc job=sendgmr) by 2002:a25:c504:: with SMTP id v4mr35945979ybe.308.1632182605667;
 Mon, 20 Sep 2021 17:03:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 20 Sep 2021 17:03:02 -0700
In-Reply-To: <20210921000303.400537-1-seanjc@google.com>
Message-Id: <20210921000303.400537-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210921000303.400537-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 09/10] KVM: SVM: Move RESET emulation to svm_vcpu_reset()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move RESET emulation for SVM vCPUs to svm_vcpu_reset(), and drop an extra
init_vmcb() from svm_create_vcpu() in the process.  Hopefully KVM will
someday expose a dedicated RESET ioctl(), and in the meantime separating
"create" from "RESET" is a nice cleanup.

Keep the call to svm_switch_vmcb() so that misuse of svm->vmcb at worst
breaks the guest, e.g. premature accesses doesn't cause a NULL pointer
dereference.

Cc: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c |  6 +++---
 arch/x86/kvm/svm/svm.c | 29 +++++++++++++++++------------
 arch/x86/kvm/svm/svm.h |  2 +-
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75e0b21ad07c..4cf40021dde4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2599,11 +2599,11 @@ void sev_es_init_vmcb(struct vcpu_svm *svm)
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
 }
 
-void sev_es_create_vcpu(struct vcpu_svm *svm)
+void sev_es_vcpu_reset(struct vcpu_svm *svm)
 {
 	/*
-	 * Set the GHCB MSR value as per the GHCB specification when creating
-	 * a vCPU for an SEV-ES guest.
+	 * Set the GHCB MSR value as per the GHCB specification when emulating
+	 * vCPU RESET for an SEV-ES guest.
 	 */
 	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
 					    GHCB_VERSION_MIN,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1a70e11f0487..bb79ae8e8bcd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1303,6 +1303,19 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 
 }
 
+static void __svm_vcpu_reset(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
+
+	svm_init_osvw(vcpu);
+	vcpu->arch.microcode_version = 0x01000065;
+
+	if (sev_es_guest(vcpu->kvm))
+		sev_es_vcpu_reset(svm);
+}
+
 static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1311,6 +1324,9 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	svm->virt_spec_ctrl = 0;
 
 	init_vmcb(vcpu);
+
+	if (!init_event)
+		__svm_vcpu_reset(vcpu);
 }
 
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
@@ -1370,24 +1386,13 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	svm->vmcb01.ptr = page_address(vmcb01_page);
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
+	svm_switch_vmcb(svm, &svm->vmcb01);
 
 	if (vmsa_page)
 		svm->vmsa = page_address(vmsa_page);
 
 	svm->guest_state_loaded = false;
 
-	svm_switch_vmcb(svm, &svm->vmcb01);
-	init_vmcb(vcpu);
-
-	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
-
-	svm_init_osvw(vcpu);
-	vcpu->arch.microcode_version = 0x01000065;
-
-	if (sev_es_guest(vcpu->kvm))
-		/* Perform SEV-ES specific VMCB creation updates */
-		sev_es_create_vcpu(svm);
-
 	return 0;
 
 error_free_vmsa_page:
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 524d943f3efc..001698919148 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -561,7 +561,7 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_es_init_vmcb(struct vcpu_svm *svm);
-void sev_es_create_vcpu(struct vcpu_svm *svm);
+void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
-- 
2.33.0.464.g1972c5931b-goog

