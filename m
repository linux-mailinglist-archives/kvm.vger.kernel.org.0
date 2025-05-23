Return-Path: <kvm+bounces-47485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EBE2AC1955
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:11:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAA61A458AB
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:10:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E27EF28C5CF;
	Fri, 23 May 2025 01:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MVanIT1O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A761F28B4FD
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962072; cv=none; b=NZ4ok9O3Vte92wcrqfI7LSXSm5O8jT0S8ljyM7WBZwJR6f155MReVw/4YcUGDpA+qW9MYCX+m6T44zrUWsvbxn6/6qmgkixGLp2rMkT2fqSaqpVT+O6a9knKVRbdqqPEQNdCCaeNA7GGNCMtaLT2aXYwmif5EKhzUvXhIn8uNe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962072; c=relaxed/simple;
	bh=U0lXuztKsbQ6vOwPvXvlCRdfHq5pEEfqlrsbN4zSEW0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fWYPRz9bzOm9qHesW+KOlx5OnMC3EH5lV85PN+HR5trPabos58RF0+ZmNDAOQVLttX+QKiks6CL8p7VRey1yZfiTJEf4OeqtvjhtKsB4CUzxv4L0lW2I6MU7dEzaG4fVd32kt6mMUBnwWFPxyj3Qxuh4fhvbCnMkM9nHn2rfZyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MVanIT1O; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2320d1cb313so55568515ad.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962069; x=1748566869; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kq0Cy8cDTnLLgDeX9paVAv72AILfWzwvKgS57Jhig+k=;
        b=MVanIT1OoPcg09dBZnLcXW8De7OJ0LFWlYH8rZ4qfuVvFuybkdcwngH6gPaG/uXfI/
         WQkQ6PgcjGDQFxVSowHjupTbUM0MjccPDq5iZazVUufPUTzFKBAZ1s0M5zxnFYnBMxI4
         kvUQ8CiGMsaMtxcV7A82nRgGMhXvDrJCsshx/qcFcaMvCxYTYGni8V70/eiRaeHGGRcM
         NZUHYSNkY4UD3z5yNlidzEIwbg/EPjuYALj/t0gUay1rpRNxUFNvwp8VmQCpOyXx2SiI
         aU5NZFgu/8b86iT6DAhrWrhpdBV+YTtJC/YE2JP+7O7Itq0NlGsrlQAb7++rFEkuVPcv
         KlJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962069; x=1748566869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kq0Cy8cDTnLLgDeX9paVAv72AILfWzwvKgS57Jhig+k=;
        b=vLwyl+lV4COoYNnThIaAOhoL623ETJGpcAx77fw1JQh/nPP/PCmuc31Ho5h4XGi0WT
         4o7NIuwg/FXEHGjLKx3zHbyGfFuPOUnwpbx9db862RrpE7/K1NCpDesUUeNhG7XWckhs
         cixAUYJvnf6bmWkcPxnBQUaUDzMPgNrPkCQ9pseniEjEIq9iF3CjoUO84JtuEinUg4sd
         ZF5yYmvLot9PmioyTLPq4WC6/fS7J8IvSpWMGWYzPcqSI+vamec9aLtLV8cXBXJKt6Rc
         6F48uf0yVaUandiubhHgtD86NnC/F7ObDFjxL2QatoPSntrcYRqhO/z6/KizxswoZDpy
         RlPw==
X-Gm-Message-State: AOJu0YwcYC+UhOM1CFW9AinUDRJ4AXE7HbFGVk1VdOMhXkLswRp9P0wF
	LqbmU7bje5NgHNINIAu8bN5THVnKsuwP6KOQG8xuvahFUqSFy2I0IuMkcZ5YxMDtWGP5/DWhPka
	Z/GZIeA==
X-Google-Smtp-Source: AGHT+IFtGk6LcnmjIj0taAHjAXYUJ8hEzTCCNrk1y9BpY/2QgpzZNWMJPoqJgLycpc+0uJxQVWlfD9j1X1g=
X-Received: from pjbpb5.prod.google.com ([2002:a17:90b:3c05:b0:308:670e:aa2c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec8c:b0:30c:540b:9ac
 with SMTP id 98e67ed59e1d1-30e830ebd3fmr44143328a91.10.1747962069037; Thu, 22
 May 2025 18:01:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:40 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-36-seanjc@google.com>
Subject: [PATCH v2 35/59] KVM: SVM: Revert IRTE to legacy mode if IOMMU
 doesn't provide IR metadata
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Revert the IRTE back to remapping mode if the AMD IOMMU driver mucks up
and doesn't provide the necessary metadata.  Returning an error up the
stack without actually handling the error is useless and confusing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 97b747e82012..f1e9f0dd43e8 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -769,16 +769,13 @@ static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
 	spin_unlock_irqrestore(&to_svm(vcpu)->ir_list_lock, flags);
 }
 
-static int svm_ir_list_add(struct vcpu_svm *svm,
-			   struct kvm_kernel_irqfd *irqfd,
-			   struct amd_iommu_pi_data *pi)
+static void svm_ir_list_add(struct vcpu_svm *svm,
+			    struct kvm_kernel_irqfd *irqfd,
+			    struct amd_iommu_pi_data *pi)
 {
 	unsigned long flags;
 	u64 entry;
 
-	if (WARN_ON_ONCE(!pi->ir_data))
-		return -EINVAL;
-
 	irqfd->irq_bypass_data = pi->ir_data;
 
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
@@ -796,7 +793,6 @@ static int svm_ir_list_add(struct vcpu_svm *svm,
 
 	list_add(&irqfd->vcpu_list, &svm->ir_list);
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-	return 0;
 }
 
 int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
@@ -833,6 +829,16 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		if (ret)
 			return ret;
 
+		/*
+		 * Revert to legacy mode if the IOMMU didn't provide metadata
+		 * for the IRTE, which KVM needs to keep the IRTE up-to-date,
+		 * e.g. if the vCPU is migrated or AVIC is disabled.
+		 */
+		if (WARN_ON_ONCE(!pi_data.ir_data)) {
+			irq_set_vcpu_affinity(host_irq, NULL);
+			return -EIO;
+		}
+
 		/**
 		 * Here, we successfully setting up vcpu affinity in
 		 * IOMMU guest mode. Now, we need to store the posted
@@ -840,7 +846,8 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		 * we can reference to them directly when we update vcpu
 		 * scheduling information in IOMMU irte.
 		 */
-		return svm_ir_list_add(to_svm(vcpu), irqfd, &pi_data);
+		svm_ir_list_add(to_svm(vcpu), irqfd, &pi_data);
+		return 0;
 	}
 	return irq_set_vcpu_affinity(host_irq, NULL);
 }
-- 
2.49.0.1151.ga128411c76-goog


