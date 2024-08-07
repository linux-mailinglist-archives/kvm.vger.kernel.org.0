Return-Path: <kvm+bounces-23529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B01A294A73D
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 13:52:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AF05283378
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 11:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB47F1E4EE9;
	Wed,  7 Aug 2024 11:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="agSZyOKc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF58B1C7B86;
	Wed,  7 Aug 2024 11:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723031511; cv=none; b=OTvQPmUMu5VNlp5kKQVc/F7lV/uE7RcGK8EcrRoIvWKlyqZxGlx/3qDRxTZh47GskPuzoK31d+pFWgKX+oc+K6WfCMwYGXWjGe+k8Tg+yBXlDpivQ7bPS6Ab7MKiMcQTdyZGmQ0mGej8ZIIEgmr/MKKRax3boqiWurkI013KVyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723031511; c=relaxed/simple;
	bh=0m7JnrkgG8nQO7XbNNaCOgZXNbyj6GhrwVnJsEiGC2I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RkD1uJEJ6TK/UluZdaYg4lQWEdk+oLy0B7M8YkW7KhGknXTQS+yW0tSGx5oyxco8Nc8WRKl1VZZDVrc7EM+KnjWIC4t6klHXpvpG6ujaVKU8Qdfc38iwDfqzlwYP/GrjXxp5BIL9827kmZaK9niZtui4ewuXp1kHKrvb6QSLyXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=agSZyOKc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA0AC32782;
	Wed,  7 Aug 2024 11:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723031510;
	bh=0m7JnrkgG8nQO7XbNNaCOgZXNbyj6GhrwVnJsEiGC2I=;
	h=From:To:Cc:Subject:Date:From;
	b=agSZyOKcHB9lccsU/EJqj+NTAGRLb2Gd4xgncPwdamdGX4xVSnmMOu+wLYvgtX2Sm
	 twiuzrVkEVv8k/fFa+OdG2DfKlCNSu/CsE2NpUFYcyuHkVZXeqXZ7PU7JJWTEvLGJj
	 pdDrSUmHoISgnsUwwnWCkewiFJNIjdb2oLgxd0YICbgk9PL6HIdiAuIsbryHvVpdAD
	 saBWNAuToe6mqu1umhLY2xXA/vOyqce9OhPUsHZ65iTyJqdOQ9Pg2ZGP1c4qRLp2cX
	 jI3kpaK5MpeaohLbyY9dbJUx7OcPcMIol0jbM+puRkU02ctv++OiifDy57uoiKIvvQ
	 mzfkmu3yqXuqw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sbfCm-001h7T-AX;
	Wed, 07 Aug 2024 12:51:48 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Arnd Bergmann <arnd@linaro.org>
Subject: [PATCH] KVM: arm64: Enforce dependency on an ARMv8.4-aware toolchain
Date: Wed,  7 Aug 2024 12:51:44 +0100
Message-Id: <20240807115144.3237260-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, viresh.kumar@linaro.org, arnd@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

With the NV support of TLBI-range operations, KVM makes use of
instructions that are only supported by binutils versions >= 2.30.

This breaks the build for very old toolchains.

Make KVM support conditional on having ARMv8.4 support in the
assembler, side-stepping the issue.

Fixes: 5d476ca57d7d ("KVM: arm64: nv: Add handling of range-based TLBI operations")
Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
Suggested-by: Arnd Bergmann <arnd@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 58f09370d17e..8304eb342be9 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -19,6 +19,7 @@ if VIRTUALIZATION
 
 menuconfig KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
+	depends on AS_HAS_ARMV8_4
 	select KVM_COMMON
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_MMU_NOTIFIER
-- 
2.39.2


