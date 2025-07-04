Return-Path: <kvm+bounces-51603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ABC8AF967A
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 17:13:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2366C7B0F76
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 15:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CD3928EA53;
	Fri,  4 Jul 2025 15:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R+WNHkJS"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F53410942
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 15:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751641994; cv=none; b=T6Xcey4KVQIdzc5KOqlkj69NPQSYx0n4I9AHhWYjJRizWhCpbhlhQ0tRtCthtt7P5rr4zpIZ5lPiH+W6L1SM0TMySeDXMX2zQnChL4VY9YYqhb/cRXnncHDsuH7M4a2/rUU9LmGSoAttGEmBpcBDDaoQaqxm1sTNmkb4ZQWp2Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751641994; c=relaxed/simple;
	bh=g599v1Dcqt9/YyHI5c+otr8SMBzkW7z85VopKOyuj3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikJLyvwD4ZURlG2YKLa7tsLtZrSZX0ZzzgHZeG+Y8tXG+iTzIE07AZVASYhjix75kN2L7xo2EdUHbkx3OStrezH8XIgNCviNu/feqD2JUvmZlP2YOj9IDQb7zMQTexUULfkN1/NnX6kLZHtBCJkluqO3q2XTtbEove2vVG0fHvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R+WNHkJS; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751641980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u5RM3fpQJZXdHe1/0rYAD9Peic3dkiF/gyGbQFCCa/4=;
	b=R+WNHkJSXCrelO4rIytF8Z1YLvjTGlqMZXSIDvORoUjQXB0dzUARrf/YmM2qvOQ/hXBwIS
	bBIrKFP47oJZaRs/7IEhs8PuNwRTol1vy/LK93zJzFsLPNiPVNa9HcYO6o9s80p1usZQkr
	87KwiLiOSSNn+NsvWk6vckJ8NTsFuEk=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Cc: alexandru.elisei@arm.com,
	cleger@rivosinc.com,
	jesse@rivosinc.com,
	jamestiotio@gmail.com,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH 1/2] arm/arm64: Ensure proper host arch with kvmtool
Date: Fri,  4 Jul 2025 17:12:56 +0200
Message-ID: <20250704151254.100351-5-andrew.jones@linux.dev>
In-Reply-To: <20250704151254.100351-4-andrew.jones@linux.dev>
References: <20250704151254.100351-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When running on non-arm (e.g. an x86 machine) if the framework is
configured to use kvmtool then, unlike with QEMU, it can't work.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/run | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arm/run b/arm/run
index 9ee795ae424c..858333fce465 100755
--- a/arm/run
+++ b/arm/run
@@ -97,6 +97,11 @@ function arch_run_kvmtool()
 {
 	local command
 
+	if [ "$HOST" != "arm" ] && [ "$HOST" != "aarch64" ]; then
+		echo "kvmtool requires KVM but the host ('$HOST') is not arm" >&2
+		exit 2
+	fi
+
 	kvmtool=$(search_kvmtool_binary) ||
 		exit $?
 
-- 
2.49.0


