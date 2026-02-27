Return-Path: <kvm+bounces-72178-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WGAfLWTOoWn3wQQAu9opvQ
	(envelope-from <kvm+bounces-72178-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:03:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2684E1BB28C
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:03:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5C27D317D95D
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 16:59:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29DDA35A391;
	Fri, 27 Feb 2026 16:59:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1B8D3563C2
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 16:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211583; cv=none; b=PD59soeTjUtWdEYmN9xVrb3pOM81C/UBCChSRDlIP7gaoI2BKg7IyY7Q6jUGP+NAm50S7MmHNYabh8PxosgIKaXZ49EFsri36kMcOXxarU19t5VHz3xLIHcIanz5wfzKztYv+7ZRYagUzA0AglMSAEYDyA65EAK/MnTuth8f31c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211583; c=relaxed/simple;
	bh=FRFtvEI1yi35Friv27LJBigEAlIfLQnMGtresBTad30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJgnU/2NwdrENSwlnD+9KEytiroE4A7PP+Doe+ic5JveJqndrYYFffSvrf2j1Ylw1Gi4Q2S3FP+qYrDy28PPTRli5g9e7D4ejFttmjO4+c75hy0YI1IHQlZaivYRfQ1LIrOvM34Y4lUV7GI8Vl9rumqKQKbawFV7eeNPq4xXr1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E0AD61516;
	Fri, 27 Feb 2026 08:59:34 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F31DF3F73B;
	Fri, 27 Feb 2026 08:59:39 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	will@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v6 02/17] util/update_headers: Clean up header copying
Date: Fri, 27 Feb 2026 16:56:09 +0000
Message-ID: <20260227165624.1519865-3-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227165624.1519865-1-suzuki.poulose@arm.com>
References: <20260227165624.1519865-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72178-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[suzuki.poulose@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.969];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:mid,arm.com:email]
X-Rspamd-Queue-Id: 2684E1BB28C
X-Rspamd-Action: no action

We copy two kinds of headers. Generic Linux UAPI headers and the ASM UAPI headers
for arch specific targets. Introduce helper functions for each and centralise
the copy process

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 util/update_headers.sh | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/util/update_headers.sh b/util/update_headers.sh
index 105bfc1d..8a5d3d2d 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -28,18 +28,19 @@ then
 	exit 1
 fi
 
-cp -- "$LINUX_ROOT/include/uapi/linux/kvm.h" include/linux
-cp -- "$LINUX_ROOT/include/uap/linux/const.h" include/linux
+copy_uapi_linux_header () {
+	cp -- "$LINUX_ROOT/include/uapi/linux/$1" include/linux
+}
 
-for header in $VIRTIO_LIST
+for header in kvm.h const.h $VIRTIO_LIST
 do
-	cp -- "$LINUX_ROOT/include/uapi/linux/$header" include/linux
+	copy_uapi_linux_header $header
 done
 
 unset KVMTOOL_PATH
 
-copy_optional_arch () {
-	local src="$LINUX_ROOT/arch/$arch/include/uapi/$1"
+copy_uapi_asm_header () {
+	local src="$LINUX_ROOT/arch/$arch/include/uapi/asm/$1"
 
 	if [ -r "$src" ]
 	then
@@ -52,8 +53,9 @@ do
 	KVMTOOL_PATH=$arch
 
 	case $arch in
-		arm64) copy_optional_arch asm/sve_context.h ;;
+		arm64)
+			copy_uapi_asm_header sve_context.h
+			;;
 	esac
-	cp -- "$LINUX_ROOT/arch/$arch/include/uapi/asm/kvm.h" \
-		"$KVMTOOL_PATH/include/asm"
+	copy_uapi_asm_header kvm.h
 done
-- 
2.43.0


