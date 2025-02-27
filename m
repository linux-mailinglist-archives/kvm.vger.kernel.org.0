Return-Path: <kvm+bounces-39473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4643FA47177
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:44:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7D69166990
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66FBA1ACEBE;
	Thu, 27 Feb 2025 01:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BGxLyfmc"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35391A8F71
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619660; cv=none; b=nhhPi6u+FsCEjssU0o+CmH49vVeThIdqBUnP+iIABQ24uU9tJ6F8ZQvM/J557OnV5WrfX2kUzfIfBDVeCIgcNYhPAfcGWfCHwZ2y3RJwtGELlt8dtvfSO5QqVssUtZG1zXnWBSO0XuFQGgCYYcIl0DrgNt7Og8xZderpIePb1rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619660; c=relaxed/simple;
	bh=J9sI+M12HfqQ9qPGHnst3V7H6uKSmS7Ytv59xyDnWfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9xX5ePgIldeReZTnpeiRIPG/5bW1UE3HSMXEh9NVGbRUwdhnqXbtXUaSI/mLs7fhDe2gW36whnJKxDFcF4GoapdF03X9GsO6/AtCnpY6DPeARLJ+a/XxeobbszTisar7Axpe+442g/+vxhqa1Wy/ZZTPhWprfcAUONaqbwB7A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BGxLyfmc; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740619657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dwg1Ay80T2e92R/BjPVjDqxXeHZ5ZCL2VFstPzXptZo=;
	b=BGxLyfmcXyFurUAjrcpo/Q4xR1Hg84FflGotgy0EOHvfbhXUNXk89ijYTxBm7O/cvhQDwd
	1EqYhI1K64lVBeoV6MV43zC8GBzn26QrichlGYYGZf2RmxEqiUGA1oWntnT682+txKPxSL
	x9exdo3aW/5+dq9fl7lLIc7XjtkhiVA=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: x86@kernel.org,
	Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 3/6] x86/bugs: Remove the X86_FEATURE_USE_IBPB check in ib_prctl_set()
Date: Thu, 27 Feb 2025 01:27:09 +0000
Message-ID: <20250227012712.3193063-4-yosry.ahmed@linux.dev>
In-Reply-To: <20250227012712.3193063-1-yosry.ahmed@linux.dev>
References: <20250227012712.3193063-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If X86_FEATURE_USE_IBPB is not set, then both spectre_v2_user_ibpb and
spectre_v2_user_stibp are set to SPECTRE_V2_USER_NONE in
spectre_v2_user_select_mitigation(). Since ib_prctl_set() already checks
for this before performing the IBPB, the X86_FEATURE_USE_IBPB check is
redundant. Remove it.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 754150fc05784..1d7afc40f2272 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2272,7 +2272,7 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 		if (ctrl == PR_SPEC_FORCE_DISABLE)
 			task_set_spec_ib_force_disable(task);
 		task_update_spec_tif(task);
-		if (task == current && cpu_feature_enabled(X86_FEATURE_USE_IBPB))
+		if (task == current)
 			indirect_branch_prediction_barrier();
 		break;
 	default:
-- 
2.48.1.658.g4767266eb4-goog


