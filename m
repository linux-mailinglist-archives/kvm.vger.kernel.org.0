Return-Path: <kvm+bounces-42736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82D44A7C408
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:46:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51625179263
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D2F423FC52;
	Fri,  4 Apr 2025 19:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M0VtUjTP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FFA23E357
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795675; cv=none; b=sR7fprKzDvOB3arKsTulGksJ34/lACJIEro5iDdYPwmRI4gs4KsEJs6ia5EFJVkwup/BDO2zUe+uP8bd33GzU3uXtY/Fzq60t+I/IPkLHvpseGMK78e7L34zUNZnUX0hUObJUMy6ZzY3eBXtZVY127HO2sOOdIOoEKw1kk5VCpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795675; c=relaxed/simple;
	bh=3h3/C9YU3IZR0FXEihfejCqK39egcENO1wsqs30Mu1Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Dc0DwNzRSrgIxxYlxpqF52Kv2xBYxYV92zQEUnfn8zb/nzwhbBFwfb3SrIJPRmBNHXOmZrbRkBYZpJhQejXO9brZgFtg7O/by9OAb9nwyYMO8zUEPEMd7nNpe0LmA5sA64lbdvFdxobS3Bw9Iv16pWz35NRm9HZWUGe3d3/Jy3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M0VtUjTP; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-227ed471999so21095975ad.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795673; x=1744400473; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uuRDDxMTWx+BF71z7vaA3qXiBqaodPZrLAgFj2n/0Bs=;
        b=M0VtUjTPI7gNh3IjWYvYrIqrSXc9rqvu1c+x1cbmUA1oo+ee2hW+5Ee6C888m8FVXa
         HDAJlSYpO19/MQkBlbj34mrDULte2hjVD4cEfOe85ZoSYumBBQZHRIhKiPTgWqzg6evz
         B4cDij71rXgL7TtxKc+ZQ905JGvTuMhLyTg/apf8QnqnMwX3Z4wZXfeNTnsPQQJ7aQW4
         zfZXVsAEjanIcRTC7NFupOY8XwnDYXC9tJQ8AZbAggzAvjqkqyjMDtjNG0xhMXXYSAFB
         Fv6zydlNZ0md++tgQ899M27F/NWL1KTkC22NXUpWSWdunTZEx54SPQtCBXlkYLxebcmX
         aydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795673; x=1744400473;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uuRDDxMTWx+BF71z7vaA3qXiBqaodPZrLAgFj2n/0Bs=;
        b=BzCvJlPtvm7QcCAtyRsfOyRP326ECwsYA4CNVmLla/GAD2veESBtoS+VokI4pCgesS
         PEBg2XCGYNUaVtTZ9uh0mCo9vOKB8c/ip30O8PLRg5VuNYzXRTVMrtXAFmjKK1kH+Rff
         9CZHzVEsf5boKwmr+tQX6EnnKiKufNCgR3FmPr5N5d7MD2ZZerBVDqLjzV/h7ObD5tTc
         LlD+4jqyFxxmRR7qwKMJGJqd6b9lUXpXVQCXNe+dNm6JJbw46ABYng2slzYyZ4QNeGGy
         3EwwpkJiAWa2sf6HI7uQkx9HRVrwaWtb8qCTGJdUQ4CM9nzU4CdPUZR+YarCPg+QKZGA
         7ojA==
X-Gm-Message-State: AOJu0Yw4GBbEBHOniPf/sPbd5UK+iEgtpRVK/tEjwqHsNyJ1MjUxtSNK
	1V72MueqUgf8Hf5HkkcDs6TcPbI67QSI/jRB5gLIS8W6GG3dvYeXkMB22iz7Uzpz9eIA53p6jgx
	Kow==
X-Google-Smtp-Source: AGHT+IFSp8K6EjfmJQcrgpgFBVLlZAq7RswmqqBmwpyX1fWpzhgHdhXeMKdwMt6K9nj4ZqJ5N5KBfrQfg5c=
X-Received: from pfbfd38.prod.google.com ([2002:a05:6a00:2ea6:b0:736:9c55:9272])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:230f:b0:223:517c:bfa1
 with SMTP id d9443c01a7336-22a8a0a3a59mr56780835ad.38.1743795673360; Fri, 04
 Apr 2025 12:41:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:39:05 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-51-seanjc@google.com>
Subject: [PATCH 50/67] KVM: SVM: WARN if (de)activating guest mode in IOMMU fails
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

WARN if (de)activating "guest mode" for an IRTE entry fails as modifying
an IRTE should only fail if KVM is buggy, e.g. has stale metadata.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 620772e07993..5f5022d12b1b 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -733,10 +733,9 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	avic_handle_ldr_update(vcpu);
 }
 
-static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
+static void avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 {
 	int apic_id = kvm_cpu_get_apicid(vcpu->cpu);
-	int ret = 0;
 	unsigned long flags;
 	struct amd_svm_iommu_ir *ir;
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -752,15 +751,12 @@ static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 
 	list_for_each_entry(ir, &svm->ir_list, node) {
 		if (activate)
-			ret = amd_iommu_activate_guest_mode(ir->data, apic_id);
+			WARN_ON_ONCE(amd_iommu_activate_guest_mode(ir->data, apic_id));
 		else
-			ret = amd_iommu_deactivate_guest_mode(ir->data);
-		if (ret)
-			break;
+			WARN_ON_ONCE(amd_iommu_deactivate_guest_mode(ir->data));
 	}
 out:
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-	return ret;
 }
 
 static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
-- 
2.49.0.504.g3bcea36a83-goog


