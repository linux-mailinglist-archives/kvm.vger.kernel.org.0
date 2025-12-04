Return-Path: <kvm+bounces-65290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BEE4CA4039
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 15:29:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0097131371C5
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 14:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDF9342527;
	Thu,  4 Dec 2025 14:24:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D777330AD0B
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 14:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764858248; cv=none; b=h8gzcLrDYfhWmWBWrLS08ho/rR/ZhBnc63iDevEKlfJtfmxfeMfMkkZL5TxWespLLioq9UUXRTLTeZb6E4w44khNd5Shp320JI/1v31DCmUdEzs2YSftRoSIQMWgSS/JVzBVo1mB388/vIaVO+WGoTf8yxtRKlG2znyFQn65JxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764858248; c=relaxed/simple;
	bh=TfJbhWoRlrKrWJhom61uk26xhvmwVHx5fZFC3v4Uhfo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V6bmOW6IsxmubTMqg9NwKItYxxNX/QnSmB24GlwpCK42duP3cwTPIaYhNxllmqI75uur74FSzLiPwikb8u6CDzpELp5+hwOf6JWVMhKFSpQzrr50DyCytiJgtOQY2H2ZCBVhgwnf1PntP5vWC6x6LgahcxNDdz0Mzfkl5/FhpPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22244339;
	Thu,  4 Dec 2025 06:23:58 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A05D3F73B;
	Thu,  4 Dec 2025 06:24:03 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v4 11/11] arm64: add EL2 environment variable
Date: Thu,  4 Dec 2025 14:23:38 +0000
Message-Id: <20251204142338.132483-12-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251204142338.132483-1-joey.gouly@arm.com>
References: <20251204142338.132483-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This variable when set to y/Y will cause QEMU/kvmtool to start at EL2.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/run | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arm/run b/arm/run
index 858333fc..dd641772 100755
--- a/arm/run
+++ b/arm/run
@@ -59,6 +59,10 @@ function arch_run_qemu()
 		M+=",highmem=off"
 	fi
 
+	if [ "$EL2" = "Y" ] || [ "$EL2" = "y" ]; then
+		M+=",virtualization=on"
+	fi
+
 	if ! $qemu $M -device '?' | grep -q virtconsole; then
 		echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
 		exit 2
@@ -116,6 +120,9 @@ function arch_run_kvmtool()
 	fi
 
 	command="$(timeout_cmd) $kvmtool run"
+	if [ "$EL2" = "Y" ] || [ "$EL2" = "y" ]; then
+		command+=" --nested"
+	fi
 	if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
 		run_test_status $command --kernel "$@" --aarch32
 	else
-- 
2.25.1


