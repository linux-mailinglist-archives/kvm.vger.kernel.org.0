Return-Path: <kvm+bounces-68029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 584D8D1E9CC
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 13:00:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 552663081E75
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 11:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32A8539527B;
	Wed, 14 Jan 2026 11:59:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 330FE396B6E
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 11:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768391946; cv=none; b=BIWii8RJQQaXyYKI0PdzVA/qVCg/RVYZOFDfv7Juh/oXoAPikfMyjUIyCYJa2ElEKYFiFpJSQshmaCeWceP4QCpOYppZlL2vxiIauTrsAWR2Y9ipZtInPJnJkzkMaZLXHQpFEHQ7cAiyKt9Nj0OdbGm/Z8MkvMZhv0Y+3AsOMU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768391946; c=relaxed/simple;
	bh=nlQMdrVSThnvwhQez/Y6PB7bSS/q3NpHDOMKF+TcAAU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gDDqyc8k5mNFHLjogU5gHeWvulWGfx0Pj4OdY+LG3ntFbZso1j3geF/Uk9t9iLlOouwNDAo8lmlHneESgevAA3DPajrKWg/Nc2OFhZlT0BegBVqbf+UlTLKeoIIFZa6/aoHjfOJCxgdOXs8j8tTYEteJn5fVkv4i4f59xqtLwrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C491B1515;
	Wed, 14 Jan 2026 03:58:54 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 45D563F632;
	Wed, 14 Jan 2026 03:59:00 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v5 11/11] arm64: add EL2 environment variable
Date: Wed, 14 Jan 2026 11:57:03 +0000
Message-Id: <20260114115703.926685-12-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260114115703.926685-1-joey.gouly@arm.com>
References: <20260114115703.926685-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This variable when set to y/Y/1 will cause QEMU/kvmtool to start at EL2.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/run | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arm/run b/arm/run
index 858333fc..266ed1cf 100755
--- a/arm/run
+++ b/arm/run
@@ -59,6 +59,10 @@ function arch_run_qemu()
 		M+=",highmem=off"
 	fi
 
+	if [ "$EL2" == "1" ] || [ "$EL2" = "Y" ] || [ "$EL2" = "y" ]; then
+		M+=",virtualization=on"
+	fi
+
 	if ! $qemu $M -device '?' | grep -q virtconsole; then
 		echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
 		exit 2
@@ -116,6 +120,9 @@ function arch_run_kvmtool()
 	fi
 
 	command="$(timeout_cmd) $kvmtool run"
+	if [ "$EL2" == "1" ] || [ "$EL2" = "Y" ] || [ "$EL2" = "y" ]; then
+		command+=" --nested"
+	fi
 	if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
 		run_test_status $command --kernel "$@" --aarch32
 	else
-- 
2.25.1


