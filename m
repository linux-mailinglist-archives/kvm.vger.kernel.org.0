Return-Path: <kvm+bounces-37389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 96EC6A298FB
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:27:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9D2A7A06B6
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11395216E2C;
	Wed,  5 Feb 2025 18:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z3bcQSIp"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753111FF1AA
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 18:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738779903; cv=none; b=pxint9CMXKVGZstbNxzGQ+rPJubS6R4FiDvhz9rA7+fQ8xbJqQUNtgVWuMicAP0I5AqG74+mTbAsvZEO+qWssdGt782Ue2k4lt63/za7fQB5CS7b2+rkPuHoH8creyEGBEcGRGgc0st/yLK8V/qO68Od0js0TQHSThk/hUl23gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738779903; c=relaxed/simple;
	bh=GLqD8wX6QjQPstH23m8VLQ2kgBKnCTTz2dgc/Mx61XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uod3CoGIY8qWt5QpF18OmS1/UhKZON2ZGmkszeZIp+x32tZQb5kiLf9UHUapu0DM8jVWhV/JdUUpABT0tmnx4dH2SHNR2K9AWDBv4EtsMUzoHS28PJPeEBDKX705Qhjt2VNFnDvlf10bpZHy/8UM2bx/QuluRfySM7rTtMsJRxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z3bcQSIp; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738779895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rbKihAM6jCwO3XM7OJjQoAQ3a9+Wagzk7/DSH7vKMpY=;
	b=Z3bcQSIpN96MbgruJpGdJKmlI6571SNyo4X4lRZC/X6mHDOcKxBJyQa0EtkzO2WwUc3f90
	DbjomJnbR1TNFqRlu3a47u2u+B0i+mAKtpVxz0HOJaicZu4F6HFYY5AubNymNK5Cv/5nLY
	8kzvWm8U8B/bAEXLPS9kFllXyioXxxk=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 13/13] KVM: nSVM: Stop bombing the TLB on nested transitions
Date: Wed,  5 Feb 2025 18:24:02 +0000
Message-ID: <20250205182402.2147495-14-yosry.ahmed@linux.dev>
In-Reply-To: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Now that nested TLB flushes are properly tracked with a well-maintained
separate ASID for L2 and proper handling of L1's TLB flush requests,
drop the unconditional flushes and syncs on nested transitions.

On a Milan machine, an L1 and L2 guests were booted, both with a single
vCPU, and pinned to a single physical CPU to maximize TLB collisions. In
this setup, the cpuid_rate microbenchmark [1] showed the following
changes with this patch:

+--------+--------+-------------------+----------------------+
| L0     | L1     | cpuid_rate (base) | cpuid_rate (patched) |
+========+========+===================+======================+
| NPT    | NPT    | 256621            | 301113 (+17.3%)      |
| NPT    | Shadow | 180017            | 203347 (+12.96%)     |
| Shadow | Shadow | 177006            | 189150 (+6.86%)      |
+--------+--------+-------------------+----------------------+

[1]https://lore.kernel.org/kvm/20231109180646.2963718-1-khorenko@virtuozzo.com/

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 8e40ff21f7353..45a187d4c23d1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -512,9 +512,6 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
 		svm->nested.last_asid = svm->nested.ctl.asid;
 		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 	}
-	/* TODO: optimize unconditional TLB flush/MMU sync */
-	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
-	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 }
 
 static void nested_svm_exit_tlb_flush(struct kvm_vcpu *vcpu)
@@ -530,10 +527,6 @@ static void nested_svm_exit_tlb_flush(struct kvm_vcpu *vcpu)
 	 */
 	if (svm->nested.ctl.tlb_ctl == TLB_CONTROL_FLUSH_ALL_ASID)
 		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
-
-	/* TODO: optimize unconditional TLB flush/MMU sync */
-	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
-	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 }
 
 /*
-- 
2.48.1.362.g079036d154-goog


