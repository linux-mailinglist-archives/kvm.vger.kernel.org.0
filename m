Return-Path: <kvm+bounces-42903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13F02A7FD53
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 13:01:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C43C188C3AD
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 10:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4FCA26E175;
	Tue,  8 Apr 2025 10:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oWmp2flg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24AE2686A5;
	Tue,  8 Apr 2025 10:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109560; cv=none; b=dDO/SNy4a9GOersds91Y1/pWh3Fglro+ydWwcB3KE2JqORsR96FOR4kicJTUklN1N6ZGylOQatTI1tk2sFE0cf0aJyA2REizBWokUoVzfNgxFpO0fNRWiJSo3SSoVasoTYRpY24edkbFbgCmo09Wfoqx0DJ2bz5hL23iiKGzS9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109560; c=relaxed/simple;
	bh=Gk4HFp8XS6m0HdA7Gwl+LnZ7YLCugzXs9yfBTmhgsK0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HMx9fQl2UAYEu+gIm8evZj+m7yDUt38jG8wcvqAwPaAt3pA8L9c+j52Y7dikehCzG2XDMIGkZDfIrUdG4iFdQL0FsHo00RiSAkpiVWJzz9KcN1gP2JCfwFyh40y5IIyiOUN7F3o8r4IcCncbOFN1Z8OlZBAHOZtZlvPOnYmliR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oWmp2flg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCB3C4CEE5;
	Tue,  8 Apr 2025 10:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744109559;
	bh=Gk4HFp8XS6m0HdA7Gwl+LnZ7YLCugzXs9yfBTmhgsK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWmp2flgvk05JFGyAV1A39XUeYcuyiX9GxrwnbXtINY3JL2VC98+u8wTXwAEwQ5if
	 I5cFDg7i/yX7/bh01DKK2GyN6DWvfWuMjhNTNQSemY90kD7CYOnM1p8vMnXT8dRg1M
	 os4P0kGPBQUzU5QHwk5wA4Mosoxkv+J+AZu3Hc99C6BToKzWrnnSk1/0JCh5wgc0v4
	 pS+Jo0VaR70XNyh9odd9CharMSXWSntwqo6T01dcvKthUY3/gwxQwT/5gglgYeudFa
	 XK0I9JHbfWBr+65ZnEooan4NKVzgSXEqYSKCUdxVDBckJUYqklogylR7kvzZZGbzu0
	 2sj3ikSl9OLzg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u26ZJ-003QX2-Fz;
	Tue, 08 Apr 2025 11:52:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 02/17] KVM: arm64: nv: Allocate VNCR page when required
Date: Tue,  8 Apr 2025 11:52:10 +0100
Message-Id: <20250408105225.4002637-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250408105225.4002637-1-maz@kernel.org>
References: <20250408105225.4002637-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If running a NV guest on an ARMv8.4-NV capable system, let's
allocate an additional page that will be used by the hypervisor
to fulfill system register accesses.

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


