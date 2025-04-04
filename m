Return-Path: <kvm+bounces-42747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BABD9A7C41B
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:49:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90DA03A59EC
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:49:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF572517AD;
	Fri,  4 Apr 2025 19:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=google.com header.i=@google.com header.b="jHI+gb6B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4E92505A5
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795694; cv=none; b=LcymPp5P1TLj6QsRZLLZn3cshGEYzx5XIIw+GEgnvcvt6pa4e67bJBZc/zDijfKBHimK32J+Zx7L3+kpfv6QGmM/JTa7w03XzGcVs7e0fltShJyKP3uZlnm1G3E7hC37WN3KY/DpglfYgdQd1M9ZeGZX3+WzK+yXW9EEAARUzxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795694; c=relaxed/simple;
	bh=R9sMWALkBgwfi6cvHRh8b/xeGw/exHZkwCm6FFV2BPA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EX8XWkVPDrQGswXMoD3/sxOJO3V7Z68aTXoQmN/xEl2J/e/MOvDNOg8ngxydWOWIXFyUZ2ypf02KlE1LZ6OzJDae6C6gfbjGrh7gUAJtxb+o0J/2nyjL7bTjLwNmPoKgYL3iYiNgQ6jxmsC7t0w0g0yBuwpCbi2jDNzMFAN+DnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=fail (0-bit key) header.d=google.com header.i=@google.com header.b=jHI+gb6B reason="key not found in DNS"; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7394792f83cso1891536b3a.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795692; x=1744400492; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yvqzDsLCWBVkAFBTdSkT6iL07PKtulllv44RSpoEpAk=;
        b=jHI+gb6BwmJk8l9Im1yWMUtUDSrH5crqtj26cdWM2Pz0dvWJftFdkXgclxceg7s0yA
         mqtKqSGqTax+JucmuJ75VWBGex520U1dvG44G7TfMqehzIqu5N5kytmF1z3rUWh9Q18G
         vSDKdIp4ozFMEBMztR1T1msaW8IXIAcLCw5MPnjFKUNiwMiULkb5lATUuOqsbFTdZpQL
         PB1XgNFMfNCVQx/BgCHpAPdOs2epoeJfq8J/401xT1Y1RJHr2CNUm9SBdDwB9YmlFuP+
         djfaQZBlPstNFreHZXvjVIgtwfjoVWLvplSS9yT18tcZpWkhEglmFBwXMBjSPMD5+RlG
         6+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795692; x=1744400492;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yvqzDsLCWBVkAFBTdSkT6iL07PKtulllv44RSpoEpAk=;
        b=DukN9/yggK5yqceEeA31KxkTP9MXCzkulNW1xe5YD8swHh2IdSkJzqGsp8dAnkPaJ6
         dI3WBsjQ0+b4Q6V1+hRNbmKatO5Q+v3sozF0wuNw+QAd/F+DkocWGmMLLIP85teNixTt
         cXnJDtP42DFF8y3YCMEvNOcJrf3a7nm7K3gBCElHva/38HbI7elnvHgkmLkXM5Ele0ej
         A+ckpYgIeT0jQP7zbkVeDc/nCprbi9uT/OShC8G04IxpDrOgPq3cxbN+PyCpPGa+8VCX
         eSslD8zVF96UoczofJD7E/3fxEMstYK7dPUqSx6uJCDxoJODIA/sETZ4SXUcp5aP899C
         RuNw==
X-Gm-Message-State: AOJu0Yw2Vo1D74rikaFqLwuzpHa7B3Np7SkMP+6WYLVsMnJ75RFl/fOa
	WtaCiMnlYzT+M/5VDOcaHGdMqIbu+3r8/so/DpQmxSYXdc3614Z1j7rN1GeJl9eP9hmajBIAXg7
	01w==
X-Google-Smtp-Source: AGHT+IE79fYw6sxc2mtR0ZTsjUgMLzDtlDBHKt8S//qI+fFV8JgTCb/EHs15a16b5eLDWcD9q+k3TdFqdb0=
X-Received: from pfbef12.prod.google.com ([2002:a05:6a00:2c8c:b0:730:796b:a54a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4653:b0:736:a540:c9ad
 with SMTP id d2e1a72fcca58-73b6b8f82e9mr712492b3a.20.1743795692201; Fri, 04
 Apr 2025 12:41:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:39:16 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-62-seanjc@google.com>
Subject: [PATCH 61/67] KVM: SVM: Fold avic_set_pi_irte_mode() into its sole caller
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Fold avic_set_pi_irte_mode() into avic_refresh_apicv_exec_ctrl() in
anticipation of moving the __avic_vcpu_{load,put}() calls into the
critical section, and because having a one-off helper with a name that's
easily confused with avic_pi_update_irte() is unnecessary.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 48 ++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index d567d62463ac..0425cc374a79 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -737,32 +737,6 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	avic_handle_ldr_update(vcpu);
 }
 
-static void avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
-{
-	int apic_id = kvm_cpu_get_apicid(vcpu->cpu);
-	unsigned long flags;
-	struct amd_svm_iommu_ir *ir;
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	/*
-	 * Here, we go through the per-vcpu ir_list to update all existing
-	 * interrupt remapping table entry targeting this vcpu.
-	 */
-	spin_lock_irqsave(&svm->ir_list_lock, flags);
-
-	if (list_empty(&svm->ir_list))
-		goto out;
-
-	list_for_each_entry(ir, &svm->ir_list, node) {
-		if (activate)
-			WARN_ON_ONCE(amd_iommu_activate_guest_mode(ir->data, apic_id));
-		else
-			WARN_ON_ONCE(amd_iommu_deactivate_guest_mode(ir->data));
-	}
-out:
-	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-}
-
 static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
 {
 	struct kvm_vcpu *vcpu = irqfd->irq_bypass_vcpu;
@@ -998,6 +972,10 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
 void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	bool activated = kvm_vcpu_apicv_active(vcpu);
+	int apic_id = kvm_cpu_get_apicid(vcpu->cpu);
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct amd_svm_iommu_ir *ir;
+	unsigned long flags;
 
 	if (!enable_apicv)
 		return;
@@ -1009,7 +987,23 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	else
 		avic_vcpu_put(vcpu);
 
-	avic_set_pi_irte_mode(vcpu, activated);
+	/*
+	 * Here, we go through the per-vcpu ir_list to update all existing
+	 * interrupt remapping table entry targeting this vcpu.
+	 */
+	spin_lock_irqsave(&svm->ir_list_lock, flags);
+
+	if (list_empty(&svm->ir_list))
+		goto out;
+
+	list_for_each_entry(ir, &svm->ir_list, node) {
+		if (activated)
+			WARN_ON_ONCE(amd_iommu_activate_guest_mode(ir->data, apic_id));
+		else
+			WARN_ON_ONCE(amd_iommu_deactivate_guest_mode(ir->data));
+	}
+out:
+	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
 
 void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
-- 
2.49.0.504.g3bcea36a83-goog


