Return-Path: <kvm+bounces-49192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 393FCAD6358
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 01:02:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1A8A7A2CCF
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D8402EACEB;
	Wed, 11 Jun 2025 22:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j5Yi/Ji8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F312EA472
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682098; cv=none; b=NCusWAEDhuNAXgh86HLZcYfT7O8Sz52YDoh5YK6V0I9IxPuLpufcoD6HsJioScY/31LwcxHhKUEy2/2bCfg+sKRIwPfTioaXcqF3+n7W2xy0g33fonMCtebVScoIv18m+RxUlMCpa0dOKdBLswWR2EVCsf0whnVADdLewP9Wf5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682098; c=relaxed/simple;
	bh=sZKpR+29jrgmDW8zj3gsPXr7vmaepNsrgM7wJ6uDWQw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DqxXKAgSp3lkXbjNcjkXQAaCXYQyrQXmqNV/1iDZ+gXfKkQ4P+fW0gmJtwG9juXM6mdSxHWlrKdIB1QuLbKrpoi0kywFvLaHVI1+04Ubqo8+sHbwXDB8j3LBQk7xg23OELzCE649ZogvCuWGS1AxnwUmDJZNWoE/qP+deofP0WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j5Yi/Ji8; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b16b35ea570so251533a12.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682095; x=1750286895; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8FnMVkTP7732/rGDqsdkPg9eAdht5jy1QJRhPQZX9sI=;
        b=j5Yi/Ji8sfvr1Sbpj1maZ2HPjL0CincsbF7Q/jpP9Wj50sGDXz7L1EwpfDtiJsaF1R
         sGBtwPvCaARA8wTwtK47CRV1rQ210Pb4A3s8jyNhZOe8ErMa7zkXkpI6HEJnkbOzTk8t
         E4Tr2kydOrqdyn6OCB3p9b6iZ2fSDFrK08LRQURiPjTGQtZcvQLP8NNTjtQQB60kgShi
         qijWgTchP4dm0nTQvoh59mMH7k8I+FD9hx1mJH0LDuSOK+PGFbskIO9fsdlKO1hqt7wg
         pM+9GY2OvJR++ntKS4Ez4p53iOmdUSZmpboM3jXR7T+5Sas4/hwRdgAzy6VzkfY56ewz
         YIgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682095; x=1750286895;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8FnMVkTP7732/rGDqsdkPg9eAdht5jy1QJRhPQZX9sI=;
        b=KeOwe9XmpKYJqApe9CAbo9sr4Xvo/FJ2iWlWNKpjfynlFemddull97aODKMKn8Ajfy
         YFCx9PRfc7kAdpDVPZz6mfIZQFGlGXIyemN/RDR3xZwgaT0z5YZXrJ0V6IW5IekUulVg
         Tj1ERGrJKuSO9ssjIY/xBiDGD6UFlRR+HC7M+bg59sMln40wjzgRhwBTphU0jdJBYBCr
         u3Om3AIav3ZM1yl+s72V/FQeTngz5wnR7sPD55eatx5exQO1dtJkluMEpry1xfoMHhZ6
         Bc4RAMjjzQF7QJfKFvN6ptnnkBuxsPOJhBwTMj3XNg+5AjWWWODer9PFYANXlqcPS6H3
         mdXA==
X-Forwarded-Encrypted: i=1; AJvYcCXvADCchBqCnDumfEfJo6EL3Ar6ZzaxfcNJXivRvq/YGQV01CUeqqzQjcHYBv1Xp5BeRpo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiDgebvd/zsABQja8fAn3x7V+DShmtJuzf29E2N8GHbJSoSoxO
	2BZ4v5ANbxTB1m3SqqpSaHvdY81X1qO3EP3ygmzvcPS1fy1wACkvpzliN0ykzbtmHhswq35zAit
	m/Tw5CA==
X-Google-Smtp-Source: AGHT+IEkxrCdp03yXvohQUC5aX3+y16xZeqjkREhnIK0pQh5uO/LXqt4ZRF8KMwqJnvnYQVw6yQOWD1N5g8=
X-Received: from pgbfp15.prod.google.com ([2002:a05:6a02:2cef:b0:b2e:c392:14f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:32a4:b0:204:4573:d854
 with SMTP id adf61e73a8af0-21f9b6b34afmr672683637.9.1749682095254; Wed, 11
 Jun 2025 15:48:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:49 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-48-seanjc@google.com>
Subject: [PATCH v3 46/62] KVM: SVM: WARN if (de)activating guest mode in IOMMU fails
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

WARN if (de)activating "guest mode" for an IRTE entry fails as modifying
an IRTE should only fail if KVM is buggy, e.g. has stale metadata.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ab7fb8950cc0..6048cd90e731 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -724,10 +724,9 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	avic_handle_ldr_update(vcpu);
 }
 
-static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
+static void avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 {
 	int apic_id = kvm_cpu_get_apicid(vcpu->cpu);
-	int ret = 0;
 	unsigned long flags;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_kernel_irqfd *irqfd;
@@ -742,16 +741,15 @@ static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 		goto out;
 
 	list_for_each_entry(irqfd, &svm->ir_list, vcpu_list) {
+		void *data = irqfd->irq_bypass_data;
+
 		if (activate)
-			ret = amd_iommu_activate_guest_mode(irqfd->irq_bypass_data, apic_id);
+			WARN_ON_ONCE(amd_iommu_activate_guest_mode(data, apic_id));
 		else
-			ret = amd_iommu_deactivate_guest_mode(irqfd->irq_bypass_data);
-		if (ret)
-			break;
+			WARN_ON_ONCE(amd_iommu_deactivate_guest_mode(data));
 	}
 out:
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-	return ret;
 }
 
 static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
-- 
2.50.0.rc1.591.g9c95f17f64-goog


