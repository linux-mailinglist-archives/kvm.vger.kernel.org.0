Return-Path: <kvm+bounces-49194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 401BFAD635E
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 01:02:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F227446088E
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B92A22EB5AB;
	Wed, 11 Jun 2025 22:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pJLghggt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685FC2EAD07
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682101; cv=none; b=REvsEBPdEkwb58EyC8TElq369h0yhsHOWqia3oz+4QRytZsQ7H2K6Fy3eUtX9dZOA5PZVCCfzmDQlnFmURbPPuTAHtX7aa5FkNi6aFGSOGTWdRQhQmgjU+CgNjEu5+mUB+puMQAXX//hc2btd0WIOP8SrW71AXwspfIx8M1fdZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682101; c=relaxed/simple;
	bh=CDdmw6dFL6wn+8FcljdzaGx8a8PnN2FcUrIylCf+kXA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CT4ql6ouLsn8K4YWzZQV1CUxIb3iEEn7+2sOUJfq0s3T/RJwGacp9hBVAmuUb5rnBx4XpjBgdNQkHE3++qGMzHW6OGT0NMK0EDHIf+28TYr9eVejwRCb58JhyPDUYT0utjI+unTek+ho0aCD7QaVkNkF8fLjLdwgk6/ChIA1UDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pJLghggt; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-742c03c0272so396951b3a.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682099; x=1750286899; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PBmMQxjdJ9cFQvfjWX4n11ei39HpxV6UN/bk9QZ1bLc=;
        b=pJLghggt9N6V2LnQJ1MLoVk9NZYRkigNTw6mej7Jqzm5EKpuqbo2EN6ZiaD/EAsXRV
         2JuEIg7Rbt6sQmm6NdLJLOY4b83owwASyM1Jc822cdyA0TBvxiyWJuV1rTRsZ5zClubg
         hsKOFchLgjDqoGWdHhVpOdvb7cQezdC60hkNUfSwRLA7nKVhev3mf4XaypVue0fzr27V
         Rw8DRezJyGJ8m9x33ZKYXytUpK+3G+5BMi6m4pd6KP0wW2s7ypl7OaTpoFHsT7VBq7qX
         8Znl228I6CqnqKVipa7hYqHJy5g/Lzgc+Atq7907DvXrvVHT+QYuuZq/sL51xVHzxzYG
         3vXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682099; x=1750286899;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PBmMQxjdJ9cFQvfjWX4n11ei39HpxV6UN/bk9QZ1bLc=;
        b=k/lnkKi3DRUWFDmFqv9iIC2n98x774VK0hjlDhJ0n9FNHMnMx17KcobnQhUogrMZ8Q
         V1xH6qzjmax6+wyna1lLnRbKfup8hG/9noLlbq2p4ucUqbaHOU6x+pBR0EaRebRmBNgA
         lKQJiHGntd7NSt5Lh7VhT1iSLIYFPUJgWxylvHzj5oAH+ogJjPHqnW/qACAEG9x5qyy8
         YJ32WoEwZ0QnY/TjUwHecVAXxOybveq7xyQ2xBIIwpKHRRCMp3nMmlrNhaUqKjV3wlId
         R3imw22gzAsr4WO7gIFrvWThHipXQsV0zDIfyBj1taPMeOFChs0ClMPgX9Msptd4pn9w
         rIpw==
X-Forwarded-Encrypted: i=1; AJvYcCUjU68jL2OMsSL3sPvSkAt1gGNJvS1Z5OPqEf1l2iQe6U1/0IAVWc8q5eFq7aa7JzBN7ms=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7wXcAN2sk37TVsSztqSMbytA+weJ1a/s3hNSrAFZXmN0ODxkv
	zTirR+vO/4bwkXEXl0qC5g234AzbGJSlndQ/kUDQ2erXPtwtUqNOSjTjKg0Mdp5Ni81URfoRjx4
	qohHJ1Q==
X-Google-Smtp-Source: AGHT+IEBM47Uz2X6xS0CCAIos8ahR8hfvX5maaZpinfB8zlXBAyKSgRG4LiJD4Zyz26rgc00CLciKxSYoFk=
X-Received: from pfbk13.prod.google.com ([2002:a05:6a00:b00d:b0:746:21fd:3f7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1387:b0:73e:30dc:bb9b
 with SMTP id d2e1a72fcca58-7486cb721aemr6046845b3a.2.1749682098847; Wed, 11
 Jun 2025 15:48:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:51 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-50-seanjc@google.com>
Subject: [PATCH v3 48/62] KVM: SVM: WARN if updating IRTE GA fields in IOMMU fails
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

WARN if updating GA information for an IRTE entry fails as modifying an
IRTE should only fail if KVM is buggy, e.g. has stale metadata, and
because returning an error that is always ignored is pointless.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 24e07f075646..d1f7b35c1b02 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -834,9 +834,8 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	return irq_set_vcpu_affinity(host_irq, NULL);
 }
 
-static inline int avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
+static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
 {
-	int ret = 0;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_kernel_irqfd *irqfd;
 
@@ -847,12 +846,10 @@ static inline int avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu
 	 * interrupt remapping table entry targeting this vcpu.
 	 */
 	if (list_empty(&svm->ir_list))
-		return 0;
+		return;
 
 	list_for_each_entry(irqfd, &svm->ir_list, vcpu_list)
-		ret = amd_iommu_update_ga(cpu, irqfd->irq_bypass_data);
-
-	return ret;
+		WARN_ON_ONCE(amd_iommu_update_ga(cpu, irqfd->irq_bypass_data));
 }
 
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
-- 
2.50.0.rc1.591.g9c95f17f64-goog


