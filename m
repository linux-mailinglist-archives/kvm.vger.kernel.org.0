Return-Path: <kvm+bounces-23977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAAF19502B1
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:44:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D9BD283210
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2423419A29A;
	Tue, 13 Aug 2024 10:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LIPkOg8P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D860193094;
	Tue, 13 Aug 2024 10:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723545850; cv=none; b=DvVchgzTXLukov3826Yahrw/db6f50LEA7rc2qbkvIOrs+5rPBxajMdh1hIJvYFbk8ooV2Ibf9eVa1nQISeFm3Cl560Y6JkzZ1ukZ1X8PPPLQawe8dTKLyL1DcrfYaSvcrxe8fIO7tEKF8wqUMMZcKqpcn7ANBs9HeGqo5RXqsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723545850; c=relaxed/simple;
	bh=jKPPLmUGCI7QL8VJUkJaCfnGktj77nkngQUnHwRBvJc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AzXtWlq64hgx1K4yW30qEpFcJBsGwXg+wa1QseaN3aiFW3WYVsQGFA69nP7SyI+nDqAxszU9dXUglbGNaK/HSXWZiLTAiaPu0iOzQvi/CLFR7mxZvGwk0XUeC2LS8WPuv9C45m8inws+kTJLZpTa4ZSAKlXaM7WGUkOtjmRlClg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LIPkOg8P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BD0C4AF10;
	Tue, 13 Aug 2024 10:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723545849;
	bh=jKPPLmUGCI7QL8VJUkJaCfnGktj77nkngQUnHwRBvJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIPkOg8PdfZ7zPwPUEGeKjCR4PtHwu402D0/7hZiyiPXZIlWZ5AfJbJfjj7xB/u6R
	 m1I0EVFWkhbx8vSvTHA+asAXtPkNymp3Dvcm1R4rjarZEyNFDfpQMdmQaLTeadNF1L
	 T9DSR3ubPd6XoGc2M1OAFIxn6wTc9vL4yD4cwn5Wr7S4mX3qUy4dYf15Mt/lwDgICZ
	 Z3y6NUfQTfMlxMhDWKCBrAND5eKJXG5bT0LNnA6nNyckGpNTgeAN8CcHVJIewzM5NL
	 9xWG4NIkZh40kgo3F+MYteVAUU1fiqbKB4akGmh1siAD8QmWZXRqLmrF2OmHJUrolf
	 zcAbq5NQuiQ/w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdp0a-003JD1-57;
	Tue, 13 Aug 2024 11:44:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 2/8] KVM: arm64: Add predicate for FPMR support in a VM
Date: Tue, 13 Aug 2024 11:43:54 +0100
Message-Id: <20240813104400.1956132-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813104400.1956132-1-maz@kernel.org>
References: <20240813104400.1956132-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As we are about to check for the advertisement of FPMR support to
a guest in a number of places, add a predicate that will gate most
of the support code for FPMR.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e244e3176b56..e5cf8af54dd6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1475,4 +1475,8 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 		(pa + pi + pa3) == 1;					\
 	})
 
+#define kvm_has_fpmr(k)					\
+	(system_supports_fpmr() &&			\
+	 kvm_has_feat((k), ID_AA64PFR2_EL1, FPMR, IMP))
+
 #endif /* __ARM64_KVM_HOST_H__ */
-- 
2.39.2


