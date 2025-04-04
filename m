Return-Path: <kvm+bounces-42738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8882AA7C40A
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:47:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5780E179792
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:47:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C04924290D;
	Fri,  4 Apr 2025 19:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sPslsL06"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DEB241103
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795679; cv=none; b=SnmQ0InEpe0YhsvKiooXrJocU+iNObWIKD71F0QfTUbraRTBdj0qafiJy+jy89hZai/sKHSWU+cV7Y9DfN3ZoY1zmcnVjbVXbHXyZRSPbBNzIIKghg8lWAJCNr7mxD3wXZbHjIHc8zyWFJThsPyUcePfTK5B9fjtk2/PtoUq+mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795679; c=relaxed/simple;
	bh=pUv+Xc96YlFs/6EQOBDk/1ZAyvlUymEt7XHqJtNT7IA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pbmu1m/tb4Cm+BuktYLn6oqn2TV9/KHElfdgin6kxooR+bNHGOtbqJIHwN/MkulVzDdERqCAIaWha3TNj+HHrQO8U3VTtiNxaGbaEKX6R2/YQESpjRmBbucy8e0XSB5n/SsY9/efZNr3feWYqUGv/KgXKRRhxBLVKLC6HEyObrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sPslsL06; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736bf7eb149so1784620b3a.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795677; x=1744400477; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2g+yUGZiG4yfMHeUUYgs9UInpjAc1fZElggf5I4uJ3E=;
        b=sPslsL06yXOu4BpH0Gqk5VC5Y9RqsAoPXwFRGOxfOGnFmr9vaAOv4ZEfF/ax5zgPXv
         PYiBqHqdKYv2ztvZTRp2/9hVd7Art7wXctEPySKHRMHteUrBM1cOPiZi03fJ/Jbay9EV
         uBFwphIicHq96xLpsSNiEVwHrT5DjyHZbkxnjSZ6dH7iNRcW78huTBZdIw/bOKy2cgvz
         t/reNhNpRX7vrm0ycQW4t9TeBo1HyTDaZjp/qj8TnlhVdg3PrWRqqxXRYx8tw6quyNmC
         HSqypZBjQBtM4HUcGRUrxxHrhEq22Wt5uQxxyqDVlVjnxJhSZb50onzkXDEvhjsK2wmC
         QhgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795677; x=1744400477;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2g+yUGZiG4yfMHeUUYgs9UInpjAc1fZElggf5I4uJ3E=;
        b=W0qF7b1ic71Jix/LddHCI+XDGYtu9S60n5gaQsA1u+o/alyH4PBdWeuu1lBrSmtwGj
         b1hPReloF1WqMcaNfcpz1iaxmLdVHSwI3hfalBcTpvVDd0+e1+FLeJCs40Zn2WYXLH6G
         eaQcBHRJBIMMkr2MN8iiIgpe5OZaRGoTAuBO8kEKLMcJqtHvUDDeEh8ktb/CeWJ93caU
         IwG+PR5p7i5+VD0CFN7BZ/fPhMqwIzPvDxrLYHaDSSjGC0I0EtyKG96YNy5GnQcIhhpz
         KruLf75ZeOt/sN6toqRjhd+8MVxg5aazhgX/utANDKR27AIHMJHsufeF4orWs0H0x6X9
         0TnA==
X-Gm-Message-State: AOJu0YxdfXzTg/pLtFxcq2t10Q6ZoBVT8IE5phlW+NuCMxs6s/spOQCR
	27Hht+EavEzDt9SSmYUoiazREKSGrrAJSMNgdV1vH97snmCQQnyZNaQk2587KbgdtnTNZpUdRrd
	gTQ==
X-Google-Smtp-Source: AGHT+IGWwBLEvimkzUQGQ+6a6AS7T1fRIlofnqD1LzuuuvVqr1b/zIjzTOQVerQA0BKJhk3Q69vR5NQVKu4=
X-Received: from pfbjw34.prod.google.com ([2002:a05:6a00:92a2:b0:730:5761:84af])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9c99:b0:1f5:769a:a4c0
 with SMTP id adf61e73a8af0-20113c71809mr1061441637.22.1743795677060; Fri, 04
 Apr 2025 12:41:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:39:07 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-53-seanjc@google.com>
Subject: [PATCH 52/67] KVM: SVM: WARN if updating IRTE GA fields in IOMMU fails
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

WARN if updating GA information for an IRTE entry fails as modifying an
IRTE should only fail if KVM is buggy, e.g. has stale metadata, and
because returning an error that is always ignored is pointless.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 5544e8e88926..a932eba1f42c 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -842,9 +842,8 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	return irq_set_vcpu_affinity(host_irq, NULL);
 }
 
-static inline int avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
+static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
 {
-	int ret = 0;
 	struct amd_svm_iommu_ir *ir;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -855,12 +854,10 @@ static inline int avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu
 	 * interrupt remapping table entry targeting this vcpu.
 	 */
 	if (list_empty(&svm->ir_list))
-		return 0;
+		return;
 
 	list_for_each_entry(ir, &svm->ir_list, node)
-		ret = amd_iommu_update_ga(cpu, ir->data);
-
-	return ret;
+		WARN_ON_ONCE(amd_iommu_update_ga(cpu, ir->data));
 }
 
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
-- 
2.49.0.504.g3bcea36a83-goog


