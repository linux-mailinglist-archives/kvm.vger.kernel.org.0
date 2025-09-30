Return-Path: <kvm+bounces-59139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81D9CBAC7DE
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 12:32:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3682E3ADEC8
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1632A2FB612;
	Tue, 30 Sep 2025 10:32:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A2532FABF6;
	Tue, 30 Sep 2025 10:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759228324; cv=none; b=UTnkiSNCh5G73EPvBjwfbsCuvfI6XOMi2YqIEt5XYjhMWTBy9L05fGeWGHA5GIj5bWJjkjhPPseCTyJ7RYUTetL5eIGfV2cE+xwPO4inMxPMcvIRPYk+lGguHpgCuAKieWc7oiuZ0Mo4DhjUOCIHntqKLNmvYHLHTdYhhiYgG+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759228324; c=relaxed/simple;
	bh=lGCj/I30CbuCNm/+7m1cqg9FKzT1BLzuNbppRX3g/5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/TEoVOnPMhs3h8lensxtH+3HPewpnqEvht8ccvCjJ6e398H7UPaKON2G2Lt2c1oEQKWm4/JmBkPXgbTocutM3H7reoVobNbgPL01yOXIn/GQD+DKFWgKI1hWSezZSp3CmsUGYFW3TygnInoGtBHkrJguOQDl1ee1/BEaQggEkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 692212103;
	Tue, 30 Sep 2025 03:31:54 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 16BEF3F66E;
	Tue, 30 Sep 2025 03:32:00 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	will@kernel.org,
	oliver.upton@linux.dev,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	aneesh.kumar@kernel.org,
	steven.price@arm.com,
	tabba@google.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH kvmtool v4 02/15] update_headers: arm64: Track psci.h for PSCI definitions
Date: Tue, 30 Sep 2025 11:31:16 +0100
Message-ID: <20250930103130.197534-3-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930103130.197534-1-suzuki.poulose@arm.com>
References: <20250930103130.197534-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Track UAPI psci.h for PSCI definitions

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


