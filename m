Return-Path: <kvm+bounces-55333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DFFDB301ED
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:23:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 362381C27F33
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 18:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE5FB3451D6;
	Thu, 21 Aug 2025 18:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aLHcGYUV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF4E2C21C3;
	Thu, 21 Aug 2025 18:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755800585; cv=none; b=aeifQBxr+Lb8PzbvYOUbH6vzvFnEyTQSFtpZ6L27PaRod6nzz6nsJQgvZDhQBGDMBJ4Q2mNUFSP5gI+pB8c3SLQMhHSPp2SpIp+Oy1FSvyljYMrjA3KhywPjPtHw1vzaAvmiAf+UxFFC57q88ru0sSBHr6/hePzoFGUOX0ZmAXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755800585; c=relaxed/simple;
	bh=5JJUhuDphwQRDsn4xnJY27gsjgfY8NFDiTRQ6+7yP0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0TKfONlPZyEul+Rmm6jyatMCwkQ87YkHZBvKah3Mz8p6bAj+bzKyo4ILPnsAXzaHNc2Q3CEfHuYRmyTUyoEwtqO2wS6cnZcg3aBXuIhJ6J7p93Wguf2vC7MYV9jyiX5MgHjxnT9e5xrCmaoQgWlyPtdIDz5phVn1kme+uvQ5PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aLHcGYUV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B600FC4CEEB;
	Thu, 21 Aug 2025 18:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755800584;
	bh=5JJUhuDphwQRDsn4xnJY27gsjgfY8NFDiTRQ6+7yP0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLHcGYUVh1Uws9fQU2a29hdWyOEz84qe0KdKj4feiGRolLAD/yUgGPn9GtGwY36cG
	 64Ql66g0W5cSloYO2+gKBW1HNyZWFSkwU+XDmn8tWacI/qCU4+dpXVcrhm04z3w4gB
	 qeVwJ67FsVS0y4zu9k1hHgBABUybTtHDdnPI/wI2m9p98Vs9pZi21yFSxP1uqRlu3h
	 foRVTGtewD17Ny5dMl+EPRNnRrHBIZ5e397FzMTZ+f0mVOnj3yymKs+3d+DTBhkLZY
	 qdAdfFMED1jK/zcWAI59NiukTv68zMgOHiwnIVDzAIvR+yz9zTM/4QubaP/bGt/4jy
	 vbEBSSE+BBkZQ==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH v4 3/7] KVM: SVM: Replace hard-coded value 0x1FF with the corresponding macro
Date: Thu, 21 Aug 2025 23:48:34 +0530
Message-ID: <2ea3769ddd3178dd7144e8364f8cffe68b37dd83.1755797611.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755797611.git.naveen@kernel.org>
References: <cover.1755797611.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The lower 9-bit field in EXITINFO2 represents an index into the AVIC
Physical/Logical APIC ID table for a AVIC_INCOMPLETE_IPI #VMEXIT. Since
the index into the Logical APIC ID table is just 8 bits, this field is
actually bound by the bit-width of the index into the AVIC Physical ID
table which is represented by AVIC_PHYSICAL_MAX_INDEX_MASK. So, use that
macro to mask EXITINFO2.Index instead of hard coding 0x1FF in
avic_incomplete_ipi_interception().

Co-developed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/kvm/svm/avic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4f00e31347c3..d00b8f34e8d3 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -500,7 +500,7 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 	u32 icrh = svm->vmcb->control.exit_info_1 >> 32;
 	u32 icrl = svm->vmcb->control.exit_info_1;
 	u32 id = svm->vmcb->control.exit_info_2 >> 32;
-	u32 index = svm->vmcb->control.exit_info_2 & 0x1FF;
+	u32 index = svm->vmcb->control.exit_info_2 & AVIC_PHYSICAL_MAX_INDEX_MASK;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	trace_kvm_avic_incomplete_ipi(vcpu->vcpu_id, icrh, icrl, id, index);
-- 
2.50.1


