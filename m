Return-Path: <kvm+bounces-9061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51AA3859F87
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:21:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C8BC284110
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB3D28DAB;
	Mon, 19 Feb 2024 09:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dxjk0cVz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD2824B34;
	Mon, 19 Feb 2024 09:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708334425; cv=none; b=XuiEsbiEXrXvBqhafroa6apwNYjhJWOiYjRTz0zdqkVlQlpUbQJp91/qaY88TCZHznbSsJ7hbENQRKitBCcfhQ1V1VibaUDla6AWdSqhyLkgBSaXgmymNKeBXl9bXV4huJ/ziQZNLZ8ZPaXqrmNCPxh0FYWT5Hudm9xPA5OtiKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708334425; c=relaxed/simple;
	bh=63HmN5bCw4yV1qIue0vyjz/ZbDoxT4DvgQFZU7t3gk4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LinVRoqzdfl5Pn49BufVmyiV7EEIHrEWYQRdpryBzp00OfAs8YQPvi/CH3ot3JqkVRyj/F4w259Ir9Ii+EPZHA7jCDT1RGtbDN2lM0hyJEbFR7It+wASobmYzCKJJdD/eB9KA/sMcCDj17yTkT0ebxf4nv8CHVt6WE8sx+YIeSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dxjk0cVz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357C2C43390;
	Mon, 19 Feb 2024 09:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708334425;
	bh=63HmN5bCw4yV1qIue0vyjz/ZbDoxT4DvgQFZU7t3gk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dxjk0cVz0HulajUHnGT6D+sHWDAhmbx36//4etWG2bCziQ6290kACEQiJTZzpxlHk
	 bmXzKICBXa4BqZprEGfH1Dph4I9NwAFWV6KAqwwR196J+Hj85eVQp8aXJPC5kVV7CF
	 jaWnFBLhXcZdMW0+l8V8yRu5GmfJMqvzE5Trsu6j7fwlyjR+sQOHGHvhsmwzQk6mIf
	 cuZem1XUawDmLrO0q5PTqm5BbJE9hrHMCFVauTL7W2zijmMSM2pX90s78uir6Uge4X
	 4DWI4Y5p1ZwtMpPVBsLxvL1hkVS4ns+Fj3cHpRhlwVkobQrWVWsss3dQWaNqtboTmM
	 oc01fHe2QKIPw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rbzp1-004WBZ-B5;
	Mon, 19 Feb 2024 09:20:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 10/13] KVM: arm64: nv: Add kvm_has_pauth() helper
Date: Mon, 19 Feb 2024 09:20:11 +0000
Message-Id: <20240219092014.783809-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219092014.783809-1-maz@kernel.org>
References: <20240219092014.783809-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
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
index 75eb8e170515..a97b092b7064 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1334,4 +1334,19 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
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


