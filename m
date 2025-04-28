Return-Path: <kvm+bounces-44567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E980DA9F023
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 14:01:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 982E35A197D
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 12:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 378722676FD;
	Mon, 28 Apr 2025 11:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VrbAB3JU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539EC2676CF
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 11:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745841483; cv=none; b=OZkmWmnhdBYaH95Nizy3hfkQs25zkXFRbj4sFngbclMcWfA5rKHN0auwCcuc+17+9x0+JtYnBC/pSUHSEOHR3PEBStpeR6RmjBMnKPlDQrdlVis/NTwBCD9iKpZQTu2tH/kJtldLIzNjBN9BdjtFAgDb94Jconj3Zmp/rggpJjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745841483; c=relaxed/simple;
	bh=oL9rfbEgU13D4OBb0eEMhZXu9az9PBZkHKOVgo0RIAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPuJX9680PFKem1MibXQX7kkWoQkXS7TSPFyYV3GXGWElWHrpqUN1IUGmOwK50Wg14Ae61SfiYBXRH0MJIaffHz0xcHSRq8nMgIOWrygRUeOGaCEqHnuAF1Js6gyq2Cu9iV/8W7zV2M1LIsqUnYx3x6cX/TeSk+lUrqr5ZOOvXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VrbAB3JU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA5FC4CEE4;
	Mon, 28 Apr 2025 11:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745841482;
	bh=oL9rfbEgU13D4OBb0eEMhZXu9az9PBZkHKOVgo0RIAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VrbAB3JUOEdZaDI79p73EPwgzx7QHWOy81orpTfosdd0hFVNb1rHTUnc7Q4IBlXaG
	 Si54ET2xuSOC7H6hHan4LEa8OXVjYn5izRlqcXTKIQB+INuSCt2EWhBQA4X7eFuxyE
	 icynasQl5Nx3bbvr9b5fklDWgAU4c3yfANI39Lkdsb/51Ok0FtjC/++SuIdyMUFAgA
	 GXm5CBlcrDVJHNp+xF2zpEkRfgr1Ns0+ydgsQUZhKVlawpiT8tS1BBg9XMWbTCpFvW
	 mBnuCcd9GKnyxGrvNKrEUEta84w/qI903THpVRQWB/a9Wfew1WK7D536g+EJ/RVrME
	 ElV1M9IiISulw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v3 3/3] cpu: vmexit: Handle KVM_EXIT_UNKNOWN exit reason correctly
Date: Mon, 28 Apr 2025 17:27:45 +0530
Message-ID: <20250428115745.70832-4-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250428115745.70832-1-aneesh.kumar@kernel.org>
References: <20250428115745.70832-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The return value for kernel VM exit handlers is confusing and has led to
errors in different kernel exit handlers. A return value of 0 indicates
a return to the VMM, whereas a return value of 1 indicates resuming
execution in the guest. Some handlers mistakenly return 0 to force a
return to the guest.

This worked in kvmtool because the exit_reason defaulted to
0 (KVM_EXIT_UNKNOWN), and kvmtool did not error out on an unknown exit
reason. However, forcing a VMM exit with error on KVM_EXIT_UNKNOWN
exit_reson would help catch these bugs early.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kvm-cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kvm-cpu.c b/kvm-cpu.c
index 7abbdcebf075..a76dfee561ec 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -190,7 +190,7 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
 
 		switch (cpu->kvm_run->exit_reason) {
 		case KVM_EXIT_UNKNOWN:
-			break;
+			goto panic_kvm;
 		case KVM_EXIT_DEBUG:
 			kvm_cpu__show_registers(cpu);
 			kvm_cpu__show_code(cpu);
-- 
2.43.0


