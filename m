Return-Path: <kvm+bounces-42070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 883F5A71F80
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:48:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8AF8189EB65
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F7A125D20A;
	Wed, 26 Mar 2025 19:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qfumM5F3"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3952586E7
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743018311; cv=none; b=PRCX9Olw6+oscNCLi5rUlBUAEHogI+4FAAep/Ac+8ClnwGZTyaEUkEdGNRLG8W2tXX4MG2ZEVvURgT3lAD6CXbYsffOORSjZwL4t2JeG3mO590D2Oxt3VSFZChqbLvBuqrfBtf4OXQ3WUDE0JH8+0UVWQCLPUYib4m5aSSAP64k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743018311; c=relaxed/simple;
	bh=3K6yLvIkonK1mZsFWuMCKFfVT/bOP7TUxS9pNzKsNJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyplXxxXJzmvGqF95oANVEakZX03ag3tqmiLhLnJJjekjsMFgxKLDNalC3KTTirnOGyz71zRlD6qPrNsUxLAq8GowxoTjsLL7rFc/Ko34dpwgNsXjBIsRz2yvrwKJL3zNoK9EZi3hduNXXqxXCcxJteXlXyyh7VUxleRkksaGZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qfumM5F3; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743018307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nzFYYv0ZerKKI50mE9D2vjgjMS3N0gQVxT4sNZcZOPU=;
	b=qfumM5F3ZtYhcofwQ2T6BQtxf+Bg7cW7WKkbv8V1zhV92yxPgvapRxUg1opVFnawIXF95r
	3asdpPvjvFWvjDF4qDDcNoz3BGmOIqej95SlSxfqvWNXIqmbKzs7VfXBEobLIwJ3Iv4u1T
	YIo3l/8lXAzAyH10dRqWv6m12PZ5Nr4=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [RFC PATCH 24/24] KVM: nSVM: Stop bombing the TLB on nested transitions
Date: Wed, 26 Mar 2025 19:44:23 +0000
Message-ID: <20250326194423.3717668-5-yosry.ahmed@linux.dev>
In-Reply-To: <20250326194423.3717668-1-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
 <20250326194423.3717668-1-yosry.ahmed@linux.dev>
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 0c887c91bd50d..1cc281a7b666c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -511,9 +511,6 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
 		svm->nested.last_asid = svm->nested.ctl.asid;
 		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 	}
-	/* TODO: optimize unconditional TLB flush/MMU sync */
-	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
-	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 }
 
 /* See nested_svm_entry_tlb_flush() */
@@ -525,9 +522,6 @@ static void nested_svm_exit_tlb_flush(struct kvm_vcpu *vcpu)
 
 	if (svm->nested.ctl.tlb_ctl == TLB_CONTROL_FLUSH_ALL_ASID)
 		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
-
-	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
-	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 }
 
 /*
-- 
2.49.0.395.g12beb8f557-goog


