Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51A7D4CD80
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 14:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731724AbfFTMNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 08:13:38 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34603 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfFTMNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 08:13:38 -0400
Received: by mail-wr1-f66.google.com with SMTP id k11so2819487wrl.1;
        Thu, 20 Jun 2019 05:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=b6QfbK+zg+CntQ2YnFA9EsYYsbhSbAKbyatBLLsVS6o=;
        b=E3VyLGyXBRciniccq2xfnnDJ3KEBTKwNxEIMDG8aeHSgCgrA4l/llxQuU9bNLgJ4IU
         yBXGW13NFJS0AXY5AxC1J8UHqWdwXuqSK2EE0yj6CG23qHonx/8WatFfAJLzMjWuOGjb
         O01hXtoIH8HBiEJ071hcaelr/8phQA6qymOmggqs5BRxSGPDhoOt8UwBf9pm99jnKMh5
         LPq7FoEG0F8vsrHTr0+t8uZhENtc+IQH1EKdXgYywN865fOETmu0IEv/ez+L8z4hgIDv
         np9aaSgdBDPuGJ0UmFmCBxT+nr9/cOk+QeNpUsa8ZTCsIAsVyfBvIgJ5ug7k7wlSvKFI
         SYHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=b6QfbK+zg+CntQ2YnFA9EsYYsbhSbAKbyatBLLsVS6o=;
        b=l/EeKOMcsZz7Tx1ixy7YrStqsb6aAgNNDqPtpFEJEvHqxXUh5K8G2QdXGskoNmDH5G
         SJivsnyY+l4fGInCOiBZAzk8N9evJPtuDIg9IMxIQ8F5DjLwX2g7teF5l7cI7Q/qi2Xj
         bf+cIqaS/Al+CYGdMOiDynvhc6uTkRXRdbe/Z3aEtMefSx7G6/hejiJJJmfwKevVqJKM
         h7BBurB+Q8QNnEj3sobCx+CBnp1lLf7ROniwKa6sx3g2V50qcu032nuF2MbzSNUcyoE5
         IQogq4UBDTxvDRKCb+7/hBIScX+fd9FNvgIZ8CYHwJx/RDFCCnXCkCIVyoT0YzvTXtC1
         DoMg==
X-Gm-Message-State: APjAAAWt8YolQIoLOboLnOWi2d7S52L/AKpsTNBOnAdC4AsnPBSYJVar
        xfBKaqK+nh0ltK1u3o5Ti5ysDYIH
X-Google-Smtp-Source: APXvYqz8eIsNCFktOotZ5v5T4ToB/P2JaF1GzsBr9KUGro69jplOWK8feo66DzLVbIhqZJaoccIdAw==
X-Received: by 2002:adf:ed41:: with SMTP id u1mr44066764wro.162.1561032815742;
        Thu, 20 Jun 2019 05:13:35 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id j4sm16720548wrx.57.2019.06.20.05.13.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 05:13:35 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: svm: add nrips module parameter
Date:   Thu, 20 Jun 2019 14:13:33 +0200
Message-Id: <1561032813-16698-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow testing code for old processors that lack the next RIP save
feature, by disabling usage of the next_rip field.

Nested hypervisors however get the feature unconditionally.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 735b8c01895e..fe046c13f03b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -367,6 +367,10 @@ struct amd_svm_iommu_ir {
 module_param(avic, int, S_IRUGO);
 #endif
 
+/* enable/disable Next RIP Save */
+static int nrips = true;
+module_param(nrips, int, 0444);
+
 /* enable/disable Virtual VMLOAD VMSAVE */
 static int vls = true;
 module_param(vls, int, 0444);
@@ -773,7 +777,7 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (svm->vmcb->control.next_rip != 0) {
+	if (nrips && svm->vmcb->control.next_rip != 0) {
 		WARN_ON_ONCE(!static_cpu_has(X86_FEATURE_NRIPS));
 		svm->next_rip = svm->vmcb->control.next_rip;
 	}
@@ -810,7 +814,7 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 
 	kvm_deliver_exception_payload(&svm->vcpu);
 
-	if (nr == BP_VECTOR && !static_cpu_has(X86_FEATURE_NRIPS)) {
+	if (nr == BP_VECTOR && !nrips) {
 		unsigned long rip, old_rip = kvm_rip_read(&svm->vcpu);
 
 		/*
@@ -1367,6 +1371,11 @@ static __init int svm_hardware_setup(void)
 	} else
 		kvm_disable_tdp();
 
+	if (nrips) {
+		if (!boot_cpu_has(X86_FEATURE_NRIPS))
+			nrips = false;
+	}
+
 	if (avic) {
 		if (!npt_enabled ||
 		    !boot_cpu_has(X86_FEATURE_AVIC) ||
@@ -3938,7 +3947,7 @@ static int rdpmc_interception(struct vcpu_svm *svm)
 {
 	int err;
 
-	if (!static_cpu_has(X86_FEATURE_NRIPS))
+	if (!nrips)
 		return emulate_on_interception(svm);
 
 	err = kvm_rdpmc(&svm->vcpu);
-- 
1.8.3.1

