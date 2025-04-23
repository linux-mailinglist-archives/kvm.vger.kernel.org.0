Return-Path: <kvm+bounces-43950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66569A99119
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:26:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E26D016AC70
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD4728A40D;
	Wed, 23 Apr 2025 15:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="arOcgn0N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2DA28B4E7;
	Wed, 23 Apr 2025 15:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421316; cv=none; b=erz/lDc4FhAGQludoPH32AuHEF51QCdW9wI1kIvjv16DJ2wYCafSZSYOf1ahIjuiMbS9Do0ZarCMdKnC7kbsHZ0YDf0YR+E8x+inzn9mpALL4ScyMBE+R/42xeCi1SRVs1TIoeQrp2TnErhyNJRWSmfKh/STL7CR0CtXiS7uy6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421316; c=relaxed/simple;
	bh=6/qw7x7rUvZiYc598C5910i4e3fhEOu+d3OEt7ysQWM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c3WUWeg5p7iU1q8317sem0SlaDu2xeQfkXz///KK8Q4h3IbVHrfea91CKRw3fhPLZW/eGgdNCQYVk358CXbrtHpriwhCID+dV7lwWLojw1W5bNwaiMKonrKHJKdtPl54+r5ovp9gE90LEnxihuwV2Hsc1L1K4PhZaoWd7Yl/Q4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=arOcgn0N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1ACC4CEE8;
	Wed, 23 Apr 2025 15:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745421315;
	bh=6/qw7x7rUvZiYc598C5910i4e3fhEOu+d3OEt7ysQWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arOcgn0N/jQSStiK/4gmqbXRF1pIXbPVjd/1Btogls+jyYh9Kz8pWz8fGHzto2cI2
	 G/rBEUeprnb2lI8WFy1jACD3jz16d1W/QQZ7M/qQrqTdmAl0XsPGdw/hlH10VuW5Dl
	 4B3z1YzypsANOy25Y8S1LyfF7JfKCDNXJe6nL6Lo9nkcOs6L6gQVbNuFEyuBPygJ8u
	 6qC1oxM6/2GCuKXF+vwRu3c0s9ELwknQNOdjNBjfBq5lAHShg025xN5v5qmNbk/lPV
	 hsCRR/eZPAfpP0qO4mOfjGLMKtaoIYnkbuqX9lFHtAXHNPjDCPL1FSWhkbCG3/JMip
	 4uNeh/hKJEHEA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u7bof-0082xr-Fe;
	Wed, 23 Apr 2025 16:15:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 02/17] KVM: arm64: nv: Allocate VNCR page when required
Date: Wed, 23 Apr 2025 16:14:53 +0100
Message-Id: <20250423151508.2961768-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250423151508.2961768-1-maz@kernel.org>
References: <20250423151508.2961768-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If running a NV guest on an ARMv8.4-NV capable system, let's
allocate an additional page that will be used by the hypervisor
to fulfill system register accesses.

Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 9 +++++++++
 arch/arm64/kvm/reset.c  | 1 +
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4a3fc11f7ecf3..884b3e25795c4 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -55,6 +55,12 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 	    !cpus_have_final_cap(ARM64_HAS_HCR_NV1))
 		return -EINVAL;
 
+	if (!vcpu->arch.ctxt.vncr_array)
+		vcpu->arch.ctxt.vncr_array = (u64 *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+
+	if (!vcpu->arch.ctxt.vncr_array)
+		return -ENOMEM;
+
 	/*
 	 * Let's treat memory allocation failures as benign: If we fail to
 	 * allocate anything, return an error and keep the allocated array
@@ -85,6 +91,9 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 		for (int i = kvm->arch.nested_mmus_size; i < num_mmus; i++)
 			kvm_free_stage2_pgd(&kvm->arch.nested_mmus[i]);
 
+		free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
+		vcpu->arch.ctxt.vncr_array = NULL;
+
 		return ret;
 	}
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index f82fcc614e136..965e1429b9f6e 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -158,6 +158,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (sve_state)
 		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
 	kfree(sve_state);
+	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
 	kfree(vcpu->arch.ccsidr);
 }
 
-- 
2.39.2


