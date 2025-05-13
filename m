Return-Path: <kvm+bounces-46296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A5AF5AB4CA1
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 09:23:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0527B1B4114E
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 07:23:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 525EE1F17EB;
	Tue, 13 May 2025 07:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cQ8uamRv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D971F0E2E
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 07:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747120990; cv=none; b=QNegrmBhsTadLAenlX1ThfjXaMODjS7SEiGZ0s7rCDw9SwoqdOGaU0n+3N3wbjKLCbLCRqbZ7YpOKJyHqmIPjpfWccBx8k9pz41DUy/gFYaNl5oLwBxthRhVkLAMzV1YQjrEXBg2wpup1cbJm0bzn8pOnhzBgCKrt04QeoQ/q8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747120990; c=relaxed/simple;
	bh=eGnYDbhBUisymaSoZMIhyXW5ObY7LnOpLPnRVnrDrgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CO4sDSWZFkcywGSpAalRG9fwjbyGJ8U7iqbznPbcrrVlxsTG3zpDOvGIYFmVdYH7vX/at8ADghzql/LkjZkgYtTJqJhLyYXQYsii4QMHhhuzWqLSp0WmxszmzpvqmKeRRk4hUVzsDgjLDhQV45E9g9jAeYdQA19uKDgnjP8OOvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cQ8uamRv; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747120989; x=1778656989;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eGnYDbhBUisymaSoZMIhyXW5ObY7LnOpLPnRVnrDrgs=;
  b=cQ8uamRv+wz61xkDGwBs0FkBGRJ6jp6ni8483FolQIhsZLSB7BIemN/l
   KgeCbsbrWYNFXb2NjTD5pvQURYBeEmCxVhorD35yelbNJ9Ietk2Cgdgx5
   wmYgDvg7Bu7X5/N0WmEUagn64BFqQ7qLa99CNwgQb/jeq44OOgS9S+TC0
   +ahZRvXZPJAG4YheVBmoDuCh1h/dlbiFA9btXZyfRpZQK2DDk/CXxoqGU
   XNSfZP5m8JJ/46A3p3Uev+PT3jMeQZMh3/jh/ngmetU3rgI8rQaGL77fo
   8JDWVT9q5gKxpJymJJ7iAnOWaCKsZ/KRlNbBOd0lzJkXPPBzuRwEHXgow
   A==;
X-CSE-ConnectionGUID: k5ycCrBsToyIWQvdrPGi6Q==
X-CSE-MsgGUID: l0FM7vhPRgyDp+9WsbmP5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="48941017"
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="48941017"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:04 -0700
X-CSE-ConnectionGUID: FaPKYe4EQNKsik/PsxLeEQ==
X-CSE-MsgGUID: jOhB4xgJTbenmzgaufgwww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="142740616"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:03 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	Chao Gao <chao.gao@intel.com>
Subject: [kvm-unit-tests PATCH v1 6/8] x86: cet: Drop unnecessary casting
Date: Tue, 13 May 2025 00:22:48 -0700
Message-ID: <20250513072250.568180-7-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250513072250.568180-1-chao.gao@intel.com>
References: <20250513072250.568180-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cet_shstk_func() and cet_ibt_func() have the same type as usermode_func.
So, remove the unnecessary casting.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 x86/cet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 5b7d311b..9802e2e6 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -91,13 +91,13 @@ int main(int ac, char **av)
 	write_cr4(read_cr4() | X86_CR4_CET);
 
 	printf("Unit test for CET user mode...\n");
-	run_in_user((usermode_func)cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
+	run_in_user(cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(rvc && exception_error_code() == 1, "Shadow-stack protection test.");
 
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
-	run_in_user((usermode_func)cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
+	run_in_user(cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(rvc && exception_error_code() == 3, "Indirect-branch tracking test.");
 
 	write_cr4(read_cr4() & ~X86_CR4_CET);
-- 
2.47.1


