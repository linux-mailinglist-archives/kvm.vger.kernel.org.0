Return-Path: <kvm+bounces-49167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9810AD6329
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C05CB3AC0B6
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76BF02BE7D6;
	Wed, 11 Jun 2025 22:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cm36lAJb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564842D540C
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682054; cv=none; b=hN6MnxXDOEvrvkLpLEumqsRD1PQZMgv0ZYLd8zNnkLegZMFyswsN2Gtktxc92A/qr40EHnnak34NxQyHWoD/AcskoLyXVWjzZzms0WYjDvOB510o0PS0sXz/iFg8qPXZihNemAradI1RDyUJ1+5/2ThQbpefT87p/ySdXbs2qe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682054; c=relaxed/simple;
	bh=6xeI4a4E2L5iZluJbUpn5b0pKmI1OHAnWyrU152u9j8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rqd0lJp51z9H8hBrjM4aI8A/cnm09R4wsPjzG6T+exieFmAAPM01xF67QRzKn2o7SF2N5hxPUfs5EWCwQo1M+C3WVR27F5Q0Gkz/TPQ++njKyH1MpGCS7GsrIqYazn2m7caCm3GoZmMJlSqqGrTx+suHDmH3RZUTI5QehyhrSGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cm36lAJb; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138f5e8ff5so307088a91.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682052; x=1750286852; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mJpXUJytIbm3VAV6gPKHVB1w+/ruLJcvPcUst+w6WTg=;
        b=Cm36lAJbmUkRRTMot2MI6rRI0a3IyHtqRiuC1A3l63JuBXr7D1npj45nonQUFwBsVN
         xA3cOcjoE9UXkFTUGDYUy4SHA+H9VSKQ9ka8xh7Kkmjmi+KtjcmpRhC32C5cHC7ag5a8
         rqwkOl9TW40pYdtHi7D89BzZMYknX5Fm0g0t3+fcZ92CuP6dUMQGQoYpRdxrsTfG/2m6
         LtX6StVvsDBTIe76FViLg4WmSdxtvY7aui7NpTvPG3eCj4uBBhOEhlvpjqssOB0xypZL
         qXlx2yejohmXYVNbIqxt8tLtCvNB3s1LJzWMRj/HleziQXeqFdkPfyXMF0W7iYu+v99W
         sOqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682052; x=1750286852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mJpXUJytIbm3VAV6gPKHVB1w+/ruLJcvPcUst+w6WTg=;
        b=L8HELCf1hgCe+H70zx/mbxIRdeHF/bqX3g+ueXezlF5v2M5rcIZMLzhvcXuok5DfBt
         g+rWrF6kiHNb5eNDROAnrQ68/psXweWmYtYXA2eKbiKcgJpizk/+cMrTjHZLD/ide9sm
         4nufyj/FLgOIkrK/FuQMb+DB31r3JwVTWrrCrdyKtfSt05G9LT/wHRVYLSJfoB876MOD
         IxDnH3EL9xpBm0vCZeMe/cRJxZlvji6r7NqGgOXSQ7UjNFZ1PsfVsnQ5cM3S1SxBe8R3
         hTz/v+Jb+yZSfqrNbg5JUuIa/2LiTcHhU6bGjugba4846MwoSWlLQWGK9SQg5zNYQnGJ
         krdg==
X-Forwarded-Encrypted: i=1; AJvYcCWSq0alnCzaomlilEzOaZs+y/V9Qrs9DQ7SjQzmKzKS5MqfOEf2VGTxRMpLvTOyacgzXKg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsBYGlrIBFPRMiI5K+Q39aK0FHZJO/JTnJpE607MJ1KRdWHMj0
	a0MQgiR2mmyfjFvs3YULM0DKP11PDQai3JvLml0E+r6MnQ+4ErQYOwUPc3E3KvRQodgdv1W7fdK
	xjqSu6w==
X-Google-Smtp-Source: AGHT+IEOHSUY5e4l9pkIll+BMnplm+wj/Pa0wfxvBvvvlZSyn0/I6Q4pgQjupbgMtAUIFW7CStkaT9e8/ZQ=
X-Received: from pjf16.prod.google.com ([2002:a17:90b:3f10:b0:313:221f:6571])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:53c8:b0:311:c5d9:2c79
 with SMTP id 98e67ed59e1d1-313bfbf5074mr1496750a91.21.1749682051843; Wed, 11
 Jun 2025 15:47:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:24 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-23-seanjc@google.com>
Subject: [PATCH v3 21/62] iommu/amd: KVM: SVM: Use pi_desc_addr to derive ga_root_ptr
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

Use vcpu_data.pi_desc_addr instead of amd_iommu_pi_data.base to get the
GA root pointer.  KVM is the only source of amd_iommu_pi_data.base, and
KVM's one and only path for writing amd_iommu_pi_data.base computes the
exact same value for vcpu_data.pi_desc_addr and amd_iommu_pi_data.base,
and fills amd_iommu_pi_data.base if and only if vcpu_data.pi_desc_addr is
valid, i.e. amd_iommu_pi_data.base is fully redundant.

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c   | 7 +++++--
 drivers/iommu/amd/iommu.c | 2 +-
 include/linux/amd-iommu.h | 2 --
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3cf929ac117f..461300bc5608 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -893,8 +893,11 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 
 			enable_remapped_mode = false;
 
-			/* Try to enable guest_mode in IRTE */
-			pi.base = avic_get_backing_page_address(svm);
+			/*
+			 * Try to enable guest_mode in IRTE.  Note, the address
+			 * of the vCPU's AVIC backing page is passed to the
+			 * IOMMU via vcpu_info->pi_desc_addr.
+			 */
 			pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
 						     svm->vcpu.vcpu_id);
 			pi.is_guest_mode = true;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index f23635b062f0..512167f7aef4 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3888,7 +3888,7 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
 	pi_data->ir_data = ir_data;
 
 	if (pi_data->is_guest_mode) {
-		ir_data->ga_root_ptr = (pi_data->base >> 12);
+		ir_data->ga_root_ptr = (vcpu_pi_info->pi_desc_addr >> 12);
 		ir_data->ga_vector = vcpu_pi_info->vector;
 		ir_data->ga_tag = pi_data->ga_tag;
 		ret = amd_iommu_activate_guest_mode(ir_data);
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index 1f9b13d803c5..deeefc92a5cf 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -19,8 +19,6 @@ struct amd_iommu;
  */
 struct amd_iommu_pi_data {
 	u32 ga_tag;
-	u64 base;
-
 	bool is_guest_mode;
 	struct vcpu_data *vcpu_data;
 	void *ir_data;
-- 
2.50.0.rc1.591.g9c95f17f64-goog


