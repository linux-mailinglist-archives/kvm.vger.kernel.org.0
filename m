Return-Path: <kvm+bounces-67437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 64755D057AC
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 19:24:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 249BD3069746
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 17:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3B362EB866;
	Thu,  8 Jan 2026 17:58:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF9262EC0B5;
	Thu,  8 Jan 2026 17:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767895134; cv=none; b=W22hjFRn2nVdXU2e1fJCVQNFyGqOClc60rX2xwptV28rCve151/90n4HqovOBqkPmYP75nn4uZJ3Q26Nh0gOUGls1N6PTlgTlBdf31cpPlYXp4NCTmJJAdJ0DsaWWD2ljaBPl8WJsUkuoxTXSuUzFCgGdJA0wN1xiWipIeaFNbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767895134; c=relaxed/simple;
	bh=hlxarAecpExGo1dewG2EIkt7Cjxd78kugJZMf8JgO2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oz+wzokxmv2ERJN0PQawhUZkeAwEcV4T80hvPOplAtK/X5ZdMV2HKt0LcphwS3Qyc4e6ehqrpOVyRl6Dg2l7jm4+tf0aW40VT4jy0549kUfVKcsgU5IdFSQBi88GOWte+S7d8vaArW9I97xcCUZ+sR1vG/2upEXt7mn61zNW7A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CBD51515;
	Thu,  8 Jan 2026 09:58:45 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B6F2F3F5A1;
	Thu,  8 Jan 2026 09:58:49 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	maz@kernel.org,
	will@kernel.org,
	oupton@kernel.org,
	aneesh.kumar@kernel.org,
	steven.price@arm.com,
	linux-kernel@vger.kernel.org,
	alexandru.elisei@arm.com,
	tabba@google.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v5 02/15] update_headers: arm64: Track psci.h for PSCI definitions
Date: Thu,  8 Jan 2026 17:57:40 +0000
Message-ID: <20260108175753.1292097-3-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260108175753.1292097-1-suzuki.poulose@arm.com>
References: <20260108175753.1292097-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Track UAPI psci.h for PSCI definitions

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 util/update_headers.sh | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/util/update_headers.sh b/util/update_headers.sh
index af75ca36..9fe782a2 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -37,13 +37,16 @@ done
 
 unset KVMTOOL_PATH
 
-copy_optional_arch () {
-	local src="$LINUX_ROOT/arch/$arch/include/uapi/$1"
+copy_arm64_headers () {
+	local uapi_asm_hdr="$LINUX_ROOT/arch/$arch/include/uapi/asm"
 
-	if [ -r "$src" ]
-	then
-		cp -- "$src" "$KVMTOOL_PATH/include/asm/"
-	fi
+	for f in sve_context.h psci.h
+	do
+		if [ -r "$uapi_asm_hdr/$f" ]
+		then
+			cp -- "$uapi_asm_hdr/$f" "$KVMTOOL_PATH/include/asm/"
+		fi
+	done
 }
 
 for arch in arm64 mips powerpc riscv x86
@@ -51,7 +54,7 @@ do
 	KVMTOOL_PATH=$arch
 
 	case $arch in
-		arm64) copy_optional_arch asm/sve_context.h ;;
+		arm64) copy_arm64_headers;;
 	esac
 	cp -- "$LINUX_ROOT/arch/$arch/include/uapi/asm/kvm.h" \
 		"$KVMTOOL_PATH/include/asm"
-- 
2.43.0


