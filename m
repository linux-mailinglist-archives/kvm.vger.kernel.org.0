Return-Path: <kvm+bounces-38607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE4FFA3CC09
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 23:09:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACCD83BAAFA
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 22:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6799925A2C3;
	Wed, 19 Feb 2025 22:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HqeY1Asg"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A0D25A2A4
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 22:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740002926; cv=none; b=WXJpc3t3SdmO1ZVTUDrRM7ysRl0G/XJQPTItY0rn4nHtBK3Omjtzo1e6pGsNVenrq4c5qnIEhvdTZqT045mOyXmDcXk4pIieXoWGyKAFKH20sXqmc+K65ezjyKLMVvszH4BKoERpytYnMC8+xtCiUnrjdj8PxtpI9iRSmUbAfF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740002926; c=relaxed/simple;
	bh=eRr1Dmq8O02AXPN/fkzwMA0sWBd5Pt33yaY5NPBM6tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OoGR3qjF6KX+8pgZOXCw/wn3UPDdJzTfD67MFgX62NayBS5DHumrU+XNS4ruPntAnTMHVNgG2u0qBNqx5X68sjGc351x+W+OOfMtY1JUmHGOjJuF6TpL+o9dbwhXbleo6ChcmhiHYOmTTzqruG20MDr8pnp7Dv7WIg/+Csa9Goo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HqeY1Asg; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740002923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+v/2kXpvCQAou9vsL9jw3ye8Vh42VkQiI85C+TXQhX0=;
	b=HqeY1AsgDlJKsCzqVfrixzaYMyYcmClcdW8nRk6x1ZhGnG52EbY6YwLWBSrYYQN9ZSjEAW
	1gJW0tC37t4A3VPn/RWRiQUsrXY2YI/oxS/CxH2SJLtUg2POGvE3cG/lHIj3KWDuytXSCD
	h49EQAfKV2DiLlVWBZigVjLYqmkFERE=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] x86/mm: Remove X86_FEATURE_USE_IBPB checks in cond_mitigation()
Date: Wed, 19 Feb 2025 22:08:22 +0000
Message-ID: <20250219220826.2453186-3-yosry.ahmed@linux.dev>
In-Reply-To: <20250219220826.2453186-1-yosry.ahmed@linux.dev>
References: <20250219220826.2453186-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The check is performed when either switch_mm_cond_ibpb or
switch_mm_always_ibpb is set. In both cases, X86_FEATURE_USE_IBPB is
always set. Remove the redundant check.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/mm/tlb.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index be0c1a509869c..e860fc8edfae4 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -437,8 +437,7 @@ static void cond_mitigation(struct task_struct *next)
 		 * both have the IBPB bit set.
 		 */
 		if (next_mm != prev_mm &&
-		    (next_mm | prev_mm) & LAST_USER_MM_IBPB &&
-		    cpu_feature_enabled(X86_FEATURE_USE_IBPB))
+		    (next_mm | prev_mm) & LAST_USER_MM_IBPB)
 			indirect_branch_prediction_barrier();
 	}
 
@@ -448,8 +447,7 @@ static void cond_mitigation(struct task_struct *next)
 		 * different context than the user space task which ran
 		 * last on this CPU.
 		 */
-		if ((prev_mm & ~LAST_USER_MM_SPEC_MASK) != (unsigned long)next->mm &&
-		    cpu_feature_enabled(X86_FEATURE_USE_IBPB))
+		if ((prev_mm & ~LAST_USER_MM_SPEC_MASK) != (unsigned long)next->mm)
 			indirect_branch_prediction_barrier();
 	}
 
-- 
2.48.1.601.g30ceb7b040-goog


