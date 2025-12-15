Return-Path: <kvm+bounces-66022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ADBDCBFA44
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:02:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE49230402FC
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6393133C19A;
	Mon, 15 Dec 2025 19:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o3VscDYC"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72A833373E
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826968; cv=none; b=V2YRqK2MUPWHJdCOOYjfB3OhDnep9Zx7DcJcjODPAfSYzxbAq2iZLzP34Zwaj4u4JMItp9gO4OcCqvARiPPHFebZjI+ZHRJZyKumXBZoM4s8eyNMweVNHAr15Q+fPeHIvSyzvXNqsv8+Fb5VkEYGq0E6ARApg5jjabnLaLi1x7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826968; c=relaxed/simple;
	bh=4NbnNfCf1/tcRqf+4TJRTzokeV3gxQr5c/Wbiqk022E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J/1NUAm7zNXjYatZYoeV6IChFtr+43llqA415ZB+KmKB1iyuAIKYbHOnVpoJOkeb81u3a5EjbVVXJNtuYzn47Cj6cQmO8mQF4S82Kxq90yd2IUknvvsPhbesx8k71VVRBQhS8ebasQU34NcVBva2+AqbwSc+2vlnYVe8h17yNKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o3VscDYC; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765826960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l95wxMnabNwq6xKbcnqzLAZvao3c2bB3Xkeyz44AZUg=;
	b=o3VscDYCLSOXZZwF/rD7m2DFTQqPJaAhGQozET9cIWI/19N0i8b9zdW4j4SkzE4KSLz7oG
	oeAIxmUeCi3wl5la4AJq6VlkbazpRi6+iV1RKXsjZuChUpZ3+AJI8F8Ddp9JZtP2BgkVlS
	q7opDHj811BOFV52IG4xwOzBMO8RBKA=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v3 16/26] KVM: nSVM: Add missing consistency check for nCR3 validity
Date: Mon, 15 Dec 2025 19:27:11 +0000
Message-ID: <20251215192722.3654335-18-yosry.ahmed@linux.dev>
In-Reply-To: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From the APM Volume #2, 15.25.4 (24593—Rev. 3.42—March 2024):

	When VMRUN is executed with nested paging enabled
	(NP_ENABLE = 1), the following conditions are considered illegal
	state combinations, in addition to those mentioned in
	“Canonicalization and Consistency Checks”:
	• Any MBZ bit of nCR3 is set.
	• Any G_PAT.PA field has an unsupported type encoding or any
	reserved field in G_PAT has a nonzero value.

Add the consistency check for nCR3 being a legal GPA with no MBZ bits
set. The G_PAT.PA check was proposed separately [*].

[*]https://lore.kernel.org/kvm/20251107201151.3303170-6-jmattson@google.com/

Fixes: 4b16184c1cca ("KVM: SVM: Initialize Nested Nested MMU context on VMRUN")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 24b10188fb91..cac61d65efc7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -335,6 +335,11 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 	if (CC(control->asid == 0))
 		return false;
 
+	if (nested_npt_enabled(to_svm(vcpu))) {
+		if (CC(!kvm_vcpu_is_legal_gpa(vcpu, control->nested_cr3)))
+			return false;
+	}
+
 	if (CC(!nested_svm_check_bitmap_pa(vcpu, control->msrpm_base_pa,
 					   MSRPM_SIZE)))
 		return false;
-- 
2.52.0.239.gd5f0c6e74e-goog


