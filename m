Return-Path: <kvm+bounces-15237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 732CD8AACD8
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:31:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C626282727
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F74381204;
	Fri, 19 Apr 2024 10:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="slKkS3pA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5E57F7CE;
	Fri, 19 Apr 2024 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713522593; cv=none; b=qvcuNXlTzohBtemT32w0db3ZXhyRjgxT8nHv8YvXLtq9thC58udJpjBnsKBvuK/YXFgp9epmXGgvaEM+o+3oF/bivxh/hKBasALAVyR4BhTPYC6cwn9X/Dw/T3V6LjiV4ztUs0DzDa/FV9RWOCfoo/YZpwk/BfN+FZbYJQ5/I4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713522593; c=relaxed/simple;
	bh=Dg+Z7zG4VBF0sGpOvyZhMnvQ2Jf+rhquslT9NGMAOik=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PoB773U9pevj+N5bC+b20LLppUjaJBKvXSZl6eB3LbzM9BGa/dLTvnefSYzD/8Lczvunc6rPxFRG3VppfMPMBwoBKTgVhOakGnyFw40EBviz9HIwEOta5j0trppM2rM1nDY1ejXdZbd+Py8dY05kA64UMNWN6Xmrj1XTLYjMC4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=slKkS3pA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B53DC32783;
	Fri, 19 Apr 2024 10:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713522593;
	bh=Dg+Z7zG4VBF0sGpOvyZhMnvQ2Jf+rhquslT9NGMAOik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slKkS3pAX2xzK1+VjPrqoDAeYLJp4NHm9HxcI7GC/8htf4d3sGcyAIJs9iXudt7gQ
	 v5FvzU/ommGyYo5pFO6OEE2mEB4+BHrFRtKNs3k0gyg+zVCGsPO8y/uJ2xFTpSmMzF
	 EQJEgtCfpzVJPXkVEr6Mcqy0e38gz+EMroHnkDsW9h3G2CLD47UzxQbt+U6YMnE6zM
	 gjNj1bODCrQBpz/SUZeeXiFDhnSr7zZgESNBUHaWC59TZEthIgwuB1tEJ+UxkYFPOs
	 ryKEktzAWMruRX7oDx8WY63FBqDEaO7TBQ2iM3W5EGJpfXuKTey9h7ArJVAczjuV9b
	 gBj22R7G2zS9w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rxlV9-00636W-DP;
	Fri, 19 Apr 2024 11:29:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v4 11/15] KVM: arm64: nv: Add kvm_has_pauth() helper
Date: Fri, 19 Apr 2024 11:29:31 +0100
Message-Id: <20240419102935.1935571-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240419102935.1935571-1-maz@kernel.org>
References: <20240419102935.1935571-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, tabba@google.com, smostafa@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Pointer Authentication comes in many flavors, and a faithful emulation
relies on correctly handling the flavour implemented by the HW.

For this, provide a new kvm_has_pauth() that checks whether we
expose to the guest a particular level of support. This checks
across all 3 possible authentication algorithms (Q5, Q3 and IMPDEF).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5566191d646a..ed4d82017b87 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1336,4 +1336,19 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
 	(get_idreg_field((kvm), id, fld) >= expand_field_sign(id, fld, min) && \
 	 get_idreg_field((kvm), id, fld) <= expand_field_sign(id, fld, max))
 
+/* Check for a given level of PAuth support */
+#define kvm_has_pauth(k, l)						\
+	({								\
+		bool pa, pi, pa3;					\
+									\
+		pa  = kvm_has_feat((k), ID_AA64ISAR1_EL1, APA, l);	\
+		pa &= kvm_has_feat((k), ID_AA64ISAR1_EL1, GPA, IMP);	\
+		pi  = kvm_has_feat((k), ID_AA64ISAR1_EL1, API, l);	\
+		pi &= kvm_has_feat((k), ID_AA64ISAR1_EL1, GPI, IMP);	\
+		pa3  = kvm_has_feat((k), ID_AA64ISAR2_EL1, APA3, l);	\
+		pa3 &= kvm_has_feat((k), ID_AA64ISAR2_EL1, GPA3, IMP);	\
+									\
+		(pa + pi + pa3) == 1;					\
+	})
+
 #endif /* __ARM64_KVM_HOST_H__ */
-- 
2.39.2


