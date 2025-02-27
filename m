Return-Path: <kvm+bounces-39471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A2C4DA4717B
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:45:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13C8118950E6
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 610ED1A83F4;
	Thu, 27 Feb 2025 01:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bkqPAXfp"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F8E199223
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619657; cv=none; b=DPK8BnWKKoeFgxlmDUe/brRtwXfEgg8o3xrCv5rdl5LhpN+ydjie53rOCyeIZyI6z6HB8kCn2H8RGOSJUDSXcs6oZbbIU7iYO2Aidqtq6/oiZOvs6bYU5n6aq76i9GJplVUVA7poKba9CD6pxSgE+H7SoNDR6UZLi05m00Me7gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619657; c=relaxed/simple;
	bh=nRTvcm/STflAUNTshhDiW2xSDILXeIC73ZVPtltoxMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxYiQiSOVhKJUNWoqV1Ukprpp5aSJQLKFTOSuHWVXNd7MHOLa/H1d5Lgrka706NHJIkarQUMZY9QVuxyh6vRxd0GWkKg+p4gwI7UUpi6CE95494twxIr0WJ6A4C87C3UMmU1heJmk5YON2szXWo8tXAIAILmTVE2TID0LFMC1bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bkqPAXfp; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740619653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=quLOmbx6xPKhUW5STb4KYNYxrnHTcaUOYh+FWYsnrjE=;
	b=bkqPAXfpaMrYDMS9JlsW5hexwxCPpXA86swIkN4cxvMKz8PJ+UsXYo8vepb2IsnLH1m6wY
	1a39wC7lW+Q4KwCWvGYiweV+oBMOjHyPASe5o9CJIAnPMeDFML4MZiXvcMR/HnBUqkB2Ms
	XQJISAEAK+wSi6YVzE3QjoEdmbTVOlM=
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
Subject: [PATCH v2 2/6] x86/mm: Remove X86_FEATURE_USE_IBPB checks in cond_mitigation()
Date: Thu, 27 Feb 2025 01:27:08 +0000
Message-ID: <20250227012712.3193063-3-yosry.ahmed@linux.dev>
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

The check is performed when either switch_mm_cond_ibpb or
switch_mm_always_ibpb is set. In both cases, X86_FEATURE_USE_IBPB is
always set. Remove the redundant check.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
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
2.48.1.658.g4767266eb4-goog


