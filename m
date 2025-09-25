Return-Path: <kvm+bounces-58776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98E06B9FFE7
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 16:28:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 984864C790A
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 14:26:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 734632C15AC;
	Thu, 25 Sep 2025 14:25:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A1792D23A4
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758810324; cv=none; b=ocWazkZt0EcGHPL+JlcvuOVc7Ta1AsXO20s1LQzhAKTNskbKKvYc0fQEIYqd48ieXFAuPmqKquLPqHb3mV7M8LAAPdPFD812M0RfLB8J2nkti203ccHEoA6ypQb7tNDBE8ahSZqcPbfz5tvpqWTKSSr6/y9O21Vi7AAKrYbJQKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758810324; c=relaxed/simple;
	bh=A9jLbSqY15I9mE6Eiis2TaQufr1DSCVgPVJbTstp0dI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FsnQFLh4czU87ZMqzozjuhKzhOh6d3ebFF+WuL7Gd9gbNp3IJPXGLot/2Bxr4XHKwvUbGKLsdszWiFz4jQgGY25rRAnmW87LDgYyN8/20ZDtEmEZjhpMuJcizhp6nLsdEXxuarRkuqQY2A72r7NgZAiJKZRKia88o3gMFWp+s9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4AE091692;
	Thu, 25 Sep 2025 07:25:15 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DA603F694;
	Thu, 25 Sep 2025 07:25:21 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v3 10/10] arm64: add EL2 environment variable
Date: Thu, 25 Sep 2025 15:19:58 +0100
Message-Id: <20250925141958.468311-11-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250925141958.468311-1-joey.gouly@arm.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This variable when set to 1 will cause QEMU/kvmtool to start at EL2.
---
 arm/run | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arm/run b/arm/run
index 858333fc..2a9c0de0 100755
--- a/arm/run
+++ b/arm/run
@@ -59,6 +59,10 @@ function arch_run_qemu()
 		M+=",highmem=off"
 	fi
 
+	if [ "$EL2" = "1" ]; then
+		M+=",virtualization=on"
+	fi
+
 	if ! $qemu $M -device '?' | grep -q virtconsole; then
 		echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
 		exit 2
@@ -116,6 +120,9 @@ function arch_run_kvmtool()
 	fi
 
 	command="$(timeout_cmd) $kvmtool run"
+	if [ "$EL2" = "1" ]; then
+		command+=" --nested"
+	fi
 	if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
 		run_test_status $command --kernel "$@" --aarch32
 	else
-- 
2.25.1


