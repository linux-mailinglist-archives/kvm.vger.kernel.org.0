Return-Path: <kvm+bounces-42713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 85307A7C46F
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:02:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E55C1B6318B
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 20:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1662D22ACFB;
	Fri,  4 Apr 2025 19:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vUX8LCPH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A7922B598
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795636; cv=none; b=HDLuoUfZH/RrMbeDwb4Z6+BIHCiGpbSJBBjY4/svo3Qp9QnZioijQKm0l4zosU6nLs20oiDXLD0gaZgWKLlllCVormUUjNhAILjdISG6OP3U8coI78MR4oj3400fdDhRUrUVOBNvG9x/pZjBFx7aHGBCs8dCWluLfIFdWGueWhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795636; c=relaxed/simple;
	bh=V0MGfeZG66UFt76kNvNPvs2l8e+FatrRv8SBCWV6kxk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ev2GSlruZn0um+GF6soQg8w1OXKepN9q3Gjui97h8FE5am215wZ8OcckcwtB0Q1MilYKrw23YWA7Zk39kwjBd6vQATrSmTH3fp2KsxTkAdmmUbltX4LD/ouXq+u/BOYym7dUAcuBusG1F9dGoVkC5r0ac90bT0l2t2J9NTpTIDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vUX8LCPH; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736b431ee0dso1963728b3a.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795634; x=1744400434; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+TG2faHkEqaXMPy8//eGevjiJYlH47y/jdqu1B7aYBw=;
        b=vUX8LCPH0zzXLht1JUdfQ0tfqBOjbxCqaSyHRzKmD/ZJ10Hy71rpHif8tMNKpKR+wC
         PH9LeBVUkW8UruhC8vMKY0wFCs6WpolNmtl1ybe5eaBF2GI38adlmn32E3PCZ6997a0v
         rRUnec/AROksMFveNBRhUhMXyWn1UVp35s0Qldhc+zEnCN83nx0CiKb0lXuWT/u9T6lt
         w6GxeFjtLazdlsgWtkOqzkL1EUXLEbVa7jl5C7msDO/swYWOUvFAl98v6zGvFitUlZ+/
         Qa+NesKlHA4354c+jnvTqQ2uPmRkqzGRXcDNrzqJo3WMhPysjyuxVbjWBivUP/Ywrf9l
         7zcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795634; x=1744400434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+TG2faHkEqaXMPy8//eGevjiJYlH47y/jdqu1B7aYBw=;
        b=lzwJXrgCLtjpIT3c3Hk81S62tTqwW82n9dbx0093N+FIvQEkLOOEhsiYR30o5VBqUt
         7RN32BN9S5avzG+nN9eOObUQ2jzSUPpbKmMxhZ7Wkj8adjFPHh7IP05vKx9utYGnrD9X
         R5gTJKhPseEjhokBOwBkQGnPboDRwMBafBmDvVhqHbOaLEcWe+ibknor9/cDo41ocBzA
         FSU5vnjKtTFOLsiX3dm4u5F9OSCEK33PwFGq8lS3EFXYH/2AbzT3wHOo7WJdMTAJeao0
         f3IBVXxoD9Xp3kgYDO5GMsDeIks77E+9rRTM6jeZ6o+LcI6KsRU1CaSDzGPVMSW3lLGV
         9OSQ==
X-Gm-Message-State: AOJu0YzEcYsmwLlycS+3L+WXbYs/ECU8bUA7ZQC1AsB2BBeORozHxRtx
	uWaeUEq8zNeVZ6OwveVXXPH0Is54nX7Tvvzuo4FNWhxElWjtu7ZvMPeGy70b2OD9z8sfr1BI93E
	R8w==
X-Google-Smtp-Source: AGHT+IGLDYZyajkylbmX0c1w0MumABkRavq1xwq7nD0DOCpebCVgFI0dxpSvqG/AK8qTMUuH0twfv9e2Cs0=
X-Received: from pfxa13.prod.google.com ([2002:a05:6a00:1d0d:b0:736:a68b:88f8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1397:b0:736:51ab:7ae1
 with SMTP id d2e1a72fcca58-739e4be4210mr5216803b3a.16.1743795633653; Fri, 04
 Apr 2025 12:40:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:42 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-28-seanjc@google.com>
Subject: [PATCH 27/67] iommu/amd: KVM: SVM: Pass NULL @vcpu_info to indicate
 "not guest mode"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Pass NULL to amd_ir_set_vcpu_affinity() to communicate "don't post to a
vCPU" now that there's no need to communicate information back to KVM
about the previous vCPU (KVM does its own tracking).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c   | 15 +++------------
 drivers/iommu/amd/iommu.c | 10 +++++++---
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 7f0f6a9cd2e8..9c789c288314 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -936,19 +936,10 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		}
 	}
 
-	if (enable_remapped_mode) {
-		/* Use legacy mode in IRTE */
-		struct amd_iommu_pi_data pi;
-
-		/**
-		 * Here, pi is used to:
-		 * - Tell IOMMU to use legacy mode for this interrupt.
-		 */
-		pi.is_guest_mode = false;
-		ret = irq_set_vcpu_affinity(host_irq, &pi);
-	} else {
+	if (enable_remapped_mode)
+		ret = irq_set_vcpu_affinity(host_irq, NULL);
+	else
 		ret = 0;
-	}
 out:
 	srcu_read_unlock(&kvm->irq_srcu, idx);
 	return ret;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 3c40bc9980b7..08c4fa31da5d 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3835,7 +3835,6 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
 {
 	int ret;
 	struct amd_iommu_pi_data *pi_data = vcpu_info;
-	struct vcpu_data *vcpu_pi_info = pi_data->vcpu_data;
 	struct amd_ir_data *ir_data = data->chip_data;
 	struct irq_2_irte *irte_info = &ir_data->irq_2_irte;
 	struct iommu_dev_data *dev_data;
@@ -3856,9 +3855,14 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
 		return -EINVAL;
 
 	ir_data->cfg = irqd_cfg(data);
-	pi_data->ir_data = ir_data;
 
-	if (pi_data->is_guest_mode) {
+	if (pi_data) {
+		struct vcpu_data *vcpu_pi_info = pi_data->vcpu_data;
+
+		pi_data->ir_data = ir_data;
+
+		WARN_ON_ONCE(!pi_data->is_guest_mode);
+
 		ir_data->ga_root_ptr = (vcpu_pi_info->pi_desc_addr >> 12);
 		ir_data->ga_vector = vcpu_pi_info->vector;
 		ir_data->ga_tag = pi_data->ga_tag;
-- 
2.49.0.504.g3bcea36a83-goog


