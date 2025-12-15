Return-Path: <kvm+bounces-66009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0853DCBF8D9
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:32:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 573FB30275E6
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 19:28:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6130C332EA8;
	Mon, 15 Dec 2025 19:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Scz2GknJ"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0501212566
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826891; cv=none; b=ZPpBR34BtiZG9BDwddr/o7C2ylSIrCgd/VrjaM601WXoB4ZHJbkvythUrNfpPa3dBI8C38x6fUAmK0q6o2H49rIushHeCV5eTa+UbbaxCVUmZp02wLcCcMP6OVap+Gy5XikYj9HVsmxZl7fz9L9/2nL9FaxmzhZhj5i6CKFnslA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826891; c=relaxed/simple;
	bh=PCU7J39rp8nyOjifzmmlq8LO/BIuNXHhgP8FlSRrsXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/6PMmtEkoYJKTp5c8n4IRGx5P22qWdH+Bn+do6ZDSjDqovT27jT7+gRzaxa5Z5AJ6sy5+s/SwZE+Dnu8DgUu5VmpHHoDa5GejlXeVPW1z1+Owh94PQIdIMRdDF/enC0vhLrWBsVE9rVWi4CEb2guR8w5lN8tvZ10+nSYE38XXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Scz2GknJ; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765826883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IOGmAEGQWx3Ejj7aS+2SEZbs+ajT25m/ukb19Dgs5RI=;
	b=Scz2GknJheZU7LeS7Qf0gZ0KwDsQcYO/Ym4y9WiN+6tS4/Qzt+xpHD9aw+49RgHYblABTV
	aTRC8y6z9osni8apt8uEHfD6ETSKGtDLlCi6cbCdAC0TTihr2famJ7R6bHI042g5qNkl2X
	3SLEdYas4TE6Rb6lNVfLat9UNveHBvI=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v3 04/26] KVM: nSVM: Always inject a #GP if mapping VMCB12 fails on nested VMRUN
Date: Mon, 15 Dec 2025 19:26:59 +0000
Message-ID: <20251215192722.3654335-6-yosry.ahmed@linux.dev>
In-Reply-To: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

nested_svm_vmrun() currently only injects a #GP if kvm_vcpu_map() fails
with -EINVAL. But it could also fail with -EFAULT if creating a host
mapping failed. Inject a #GP in all cases, no reason to treat failure
modes differently.

Fixes: 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping guest memory")
CC: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 53b149dbc930..a5a367fd8bb1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -966,12 +966,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	}
 
 	vmcb12_gpa = svm->vmcb->save.rax;
-	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
-	if (ret == -EINVAL) {
+	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map)) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
-	} else if (ret) {
-		return kvm_skip_emulated_instruction(vcpu);
 	}
 
 	ret = kvm_skip_emulated_instruction(vcpu);
-- 
2.52.0.239.gd5f0c6e74e-goog


