Return-Path: <kvm+bounces-68127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A2B20D21FA8
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:17:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2E3A4302ADEE
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 000892D3727;
	Thu, 15 Jan 2026 01:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="b/x+bvtR"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E7828DB49
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439646; cv=none; b=KTfBLQ7VBSj0Q/mqleai+9Cnd1YIOv0tTkEsn8l5oJulHCOiN9Em/ZmnWsaSUn9Eg9/pjzH2wP4cKdKRx9CaEMX/kp6JpbGrhUZAcR0aSjHGp9h59ji9KLBR+WYK1ohxyx1wDedIewxmlBfq9Q9kWKlUBjCdGSIu4EZAqvMBRjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439646; c=relaxed/simple;
	bh=jkSq9tDVGErvaaS/R2yTML7mgZQQNgvOV0zJe0C58jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HIg+huiPCGnHb7x4vKpr2hlGVK6K35o8rJxpG1BqufqbRMBUbdFk99VgpvVfazscLa3XK5h27Ptl8QTWCA130OuC2MkiE+USrmmuyxSy5MGMZ+Phw1H3DJXHbiosbDtZgZdZ+NxuDLDx5iTSsLeZ7UHbUCPIAW6zRnygHsT1aVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=b/x+bvtR; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xj+u+1+YUYkkYowwQzLxZwwWgktF/al3hH8x6AlKW9w=;
	b=b/x+bvtRef+H97dL2rr4LyC6zt/4lQnPcs96RwgsNwi+IH3NgyPFebdDWf1li9qQbAcwYG
	SnEXMCjkqbur7+8AoTba1EH82g6qf6TGH3l7omvo3kDimKYs+5KIMfBV5QN+5bxM6iowDx
	mp0EvrfRGI+0KIQiW1I5ZIImDwMGQMA=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v4 16/26] KVM: nSVM: Add missing consistency check for nCR3 validity
Date: Thu, 15 Jan 2026 01:13:02 +0000
Message-ID: <20260115011312.3675857-17-yosry.ahmed@linux.dev>
In-Reply-To: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
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
index 0f2b42803cf6..eb4a633a668d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -351,6 +351,11 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
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
2.52.0.457.g6b5491de43-goog


