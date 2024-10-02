Return-Path: <kvm+bounces-27823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5618C98E454
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 22:43:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08DDF1F2243B
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 20:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0145217312;
	Wed,  2 Oct 2024 20:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBCXhiNp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A38216A21;
	Wed,  2 Oct 2024 20:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727901781; cv=none; b=eXT79aNEkQyQIlCdlW2LzeesvJynxeacVaXX5f/7OJLULNUlGBo9FoJLD5Z/tsoiTN5BQCtG9IngoeDjIrmjjYUlxVZio8HAMTIMKKTYvvHA6n3kxTCubwPnhyrm9TiTU7Dc9p/GgmSxryTl1BytylgLXT8Jo6n6EthhVgDKxB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727901781; c=relaxed/simple;
	bh=hC26vYYWeZ8nbA3U9wUcvs+XGS5LYjab0kDJfyv/e5g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kjcC+1Jp4xhfcM4kO/chWTgPodyH0DmaZTpkcR1XAhSBfzLnFzn4ysVcuSg7IxtM0w7EgPb+8/kXswcQ0XdyPhvu1t7kdmzeMAzqc3JApN4QO7puJUtyt9fICnpHFOgc9qbK3Lzs8c2N/63aZgA4HkNEQB+qRalDb5tfy5QRxXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kBCXhiNp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D1BC4CEC2;
	Wed,  2 Oct 2024 20:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727901781;
	bh=hC26vYYWeZ8nbA3U9wUcvs+XGS5LYjab0kDJfyv/e5g=;
	h=From:To:Cc:Subject:Date:From;
	b=kBCXhiNpgjYnKdpobYDehSvGiXqYnvh4Ng2+gv2bo2hd1b2c1USIt4ucSFN4Na/bR
	 y1BWWsOIWuBRZnmAAWFo0ioHZhFbRINg3YUSyTix2AKQ3DRg+1i77WAeqDVQubzqwj
	 4pA98DQGsrVrXvlpt4IOovXCmNbuvK702J6Z/x7Y/yoOLItY2jFslgl/1/zsv3EZNK
	 B9TiwbWC4vxnZ3x4t/rw36zq2QwZSlnOp/vftuesbMsZX41QYKt+PBlPX26PgbHWj4
	 30fY3AToF+o5jJRWalXv1v3loKiqZWebMIdFf0HvnOpsxh8JGk+q5FmoT4xvqh9c7C
	 +tghXEieno/1A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sw6BX-00HA0m-Dx;
	Wed, 02 Oct 2024 21:42:59 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Fix kvm_has_feat*() handling of negative features
Date: Wed,  2 Oct 2024 21:42:39 +0100
Message-Id: <20241002204239.2051637-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Oliver reports that the kvm_has_feat() helper is not behaviing as
expected for negative feature. On investigation, the main issue
seems to be caused by the following construct:

 	(id##_##fld##_SIGNED ?					\
	 get_idreg_field_signed(kvm, id, fld) :			\
	 get_idreg_field_unsigned(kvm, id, fld))

where one side of the expression evaluates as something signed,
and the other as something unsigned. In retrospect, this is totally
braindead, as the compiler converts this into an unsigned expression.
When compared to something that is 0, the test is simply elided.

Epic fail. Similar issue exists in the expand_field_sign() macro.

The correct way to handle this is to chose between signed and unsigned
comparisons, so that both sides of the ternary expression are of the
same type (bool).

In order to keep the code readable (sort of), we introduce new
comparison primitives taking an operator as a parameter, and
rewrite the kvm_has_feat*() helpers in terms of these primitives.

Fixes: c62d7a23b947 ("KVM: arm64: Add feature checking helpers")
Reported-by: Oliver Upton <oliver.upton@linux.dev>
Tested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/include/asm/kvm_host.h | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index aab1e59aa91e..e9e9b57782e4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1490,11 +1490,6 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 		sign_extend64(__val, id##_##fld##_WIDTH - 1);		\
 	})
 
-#define expand_field_sign(id, fld, val)					\
-	(id##_##fld##_SIGNED ?						\
-	 __expand_field_sign_signed(id, fld, val) :			\
-	 __expand_field_sign_unsigned(id, fld, val))
-
 #define get_idreg_field_unsigned(kvm, id, fld)				\
 	({								\
 		u64 __val = kvm_read_vm_id_reg((kvm), SYS_##id);	\
@@ -1510,20 +1505,26 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define get_idreg_field_enum(kvm, id, fld)				\
 	get_idreg_field_unsigned(kvm, id, fld)
 
-#define get_idreg_field(kvm, id, fld)					\
+#define kvm_cmp_feat_signed(kvm, id, fld, op, limit)			\
+	(get_idreg_field_signed((kvm), id, fld) op __expand_field_sign_signed(id, fld, limit))
+
+#define kvm_cmp_feat_unsigned(kvm, id, fld, op, limit)			\
+	(get_idreg_field_unsigned((kvm), id, fld) op __expand_field_sign_unsigned(id, fld, limit))
+
+#define kvm_cmp_feat(kvm, id, fld, op, limit)				\
 	(id##_##fld##_SIGNED ?						\
-	 get_idreg_field_signed(kvm, id, fld) :				\
-	 get_idreg_field_unsigned(kvm, id, fld))
+	 kvm_cmp_feat_signed(kvm, id, fld, op, limit) :			\
+	 kvm_cmp_feat_unsigned(kvm, id, fld, op, limit))
 
 #define kvm_has_feat(kvm, id, fld, limit)				\
-	(get_idreg_field((kvm), id, fld) >= expand_field_sign(id, fld, limit))
+	kvm_cmp_feat(kvm, id, fld, >=, limit)
 
 #define kvm_has_feat_enum(kvm, id, fld, val)				\
-	(get_idreg_field_unsigned((kvm), id, fld) == __expand_field_sign_unsigned(id, fld, val))
+	kvm_cmp_feat_unsigned(kvm, id, fld, ==, val)
 
 #define kvm_has_feat_range(kvm, id, fld, min, max)			\
-	(get_idreg_field((kvm), id, fld) >= expand_field_sign(id, fld, min) && \
-	 get_idreg_field((kvm), id, fld) <= expand_field_sign(id, fld, max))
+	(kvm_cmp_feat(kvm, id, fld, >=, min) &&				\
+	kvm_cmp_feat(kvm, id, fld, <=, max))
 
 /* Check for a given level of PAuth support */
 #define kvm_has_pauth(k, l)						\
-- 
2.39.2


