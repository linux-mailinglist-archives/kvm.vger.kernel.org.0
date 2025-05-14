Return-Path: <kvm+bounces-46474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EFBDAB68E2
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 12:35:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C5B37AB8CA
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 10:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4E99272E6E;
	Wed, 14 May 2025 10:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S6kyu/9e"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CFE270560;
	Wed, 14 May 2025 10:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747218907; cv=none; b=uleqBWwYKt65OEqms49rB8XS20GjSs32wKzvDHisJTDZtIgBv7U2ca/I321B+KsO/E/4k1bLCNLVg/92iARIlfeyIpxSXxIVRXM8zIbSy6HJS6VBrvv9CxehsutWLHQw/iX9twPRwvy0e+gZXPBPR5uqoBK8K+fl47v7fAhaHvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747218907; c=relaxed/simple;
	bh=RWdvA8WOM7cCQjeG9cNrTXHyD8HVqUWr7LlHkklZdVE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PfMNkfQMlN8JXgLS5eTLPwdoCgSbCMGlk3TOTOxEBQuj6TAUq2qtJAswqppYPNUyJhLuYDJKbMvVqpBLMufPC1yl+jEjLWdfaahEVhbW9nKDR5907+8FS2jvLQt1rwQ0TP2QJVOjg/6hm0hS8rwedbKka9+onTQody6ltAUd1wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S6kyu/9e; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90885C4CEF0;
	Wed, 14 May 2025 10:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747218906;
	bh=RWdvA8WOM7cCQjeG9cNrTXHyD8HVqUWr7LlHkklZdVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6kyu/9eu76HCQAvGaU5ENgYX11IvjPQjyDGYVh4eRLj6h9LLOLevMkLLF9Fd7udZ
	 axdtyopGmF/QXkLjDDJhycq6jdL8iQHoWTaEAp/rwmoQjFPBGjtdcKCI1bzloTASdE
	 r9xMIYhbU1jmdFxDjOW81TEK9E0RLGwyBuy1i7oXz4ZGj9vIKgLzymxC6/ycRtmhYy
	 Hj4xUQt0U0W3KDnM8mbcLpE9qTYbh9iqQ19gM3/LSnUBmAcSYMbqlJB4TB9ti3P2+U
	 Wq1zwz51EUfUA4q7ziw+CWR3V17jiy9zgmm38mCxu7hnC9DBoYBXEyI7ZM35TEwtI+
	 2nqojd5R/G0Ig==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uF9S4-00Eos3-HA;
	Wed, 14 May 2025 11:35:04 +0100
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
Subject: [PATCH v4 02/17] KVM: arm64: nv: Allocate VNCR page when required
Date: Wed, 14 May 2025 11:34:45 +0100
Message-Id: <20250514103501.2225951-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250514103501.2225951-1-maz@kernel.org>
References: <20250514103501.2225951-1-maz@kernel.org>
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
 arch/arm64/kvm/nested.c | 10 ++++++++++
 arch/arm64/kvm/reset.c  |  1 +
 2 files changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4a3fc11f7ecf3..0513f13672191 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -55,6 +55,13 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 	    !cpus_have_final_cap(ARM64_HAS_HCR_NV1))
 		return -EINVAL;
 
+	if (!vcpu->arch.ctxt.vncr_array)
+		vcpu->arch.ctxt.vncr_array = (u64 *)__get_free_page(GFP_KERNEL_ACCOUNT |
+								    __GFP_ZERO);
+
+	if (!vcpu->arch.ctxt.vncr_array)
+		return -ENOMEM;
+
 	/*
 	 * Let's treat memory allocation failures as benign: If we fail to
 	 * allocate anything, return an error and keep the allocated array
@@ -85,6 +92,9 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
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


