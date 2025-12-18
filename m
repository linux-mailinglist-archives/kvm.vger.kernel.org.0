Return-Path: <kvm+bounces-66271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3107BCCC2D0
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 15:07:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 02D993047461
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 14:06:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4939434CFB6;
	Thu, 18 Dec 2025 14:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="tJPFdvL5"
X-Original-To: kvm@vger.kernel.org
Received: from out28-97.mail.aliyun.com (out28-97.mail.aliyun.com [115.124.28.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886BC349B0D;
	Thu, 18 Dec 2025 14:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766066801; cv=none; b=hmznC+q7L0W7Ntx0sadsvrlPoZmhzoVNX+gosPSE69QF/UFshyjEioRlE0CjzWlr2rcHT0q2kadTf1m93rXFG/pE2Skwjh8Nsw2I+tp3ECTN8GtYEqQJrp33uH6rSPwJul84RWDR63zFjdKyJPj2i3M690XGZ8GcxeIqr3zddG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766066801; c=relaxed/simple;
	bh=Lz4tUE8I3RA2w3B1SwUrddlbtllDhQGDdBmoIIjuP2o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mSMXREMAaap+EoSYTfdjmiLfjt7dDg5LaGLgNoZFToVpHzFJRAGKMH+umxwpCo6EDyu+i9MyR1ryffndmVZD4rxuJzWZKo9OqMwNCFJvTtuur4lbZp3ZEqlAKcz5/zUMkw+KTBiJqjYykj2tKO2kTeYLJ48876XKMIJB6vUEdH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=tJPFdvL5; arc=none smtp.client-ip=115.124.28.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1766066788; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=msS+hfWmRvmoDkryeJAbAJ641aMX4QZHGIKrKvHKroA=;
	b=tJPFdvL5LrNF9BpQ4+uvgvcs8pp+1ed0GDXwgZ8R6NktgfX1AaKAzSFbv5kLx4FXeU5wjJCne/ebeIntzUjWxtwS3xzvugn4TRd1hMJIVEAjyufZ7t5CLNmlIjoAVXslpCsq/EY4rAdQUfVusvbRBoJHeczSG91TxPav6oMvDxY=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.fniMiRB_1766066464 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 18 Dec 2025 22:01:05 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: kvm@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/9] KVM: x86: Move kvm_set_rflags() up before kvm_vcpu_do_singlestep()
Date: Thu, 18 Dec 2025 22:00:41 +0800
Message-Id: <30964c504cb4683f53093f5f37c2081825db35dc.1766066076.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1766066076.git.houwenlong.hwl@antgroup.com>
References: <cover.1766066076.git.houwenlong.hwl@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The single-step trap #DB should be injected after the instruction
completes, as 'ctxt->tf' already records the old value of
'X86_EFLAGS_TF'.  Therefore, it's okay to move kvm_set_rflags() up
before kvm_vcpu_do_single_step() to align it more closely with hardware
behavior.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 44c2886589d7..7352c2114bab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9593,10 +9593,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			if (ctxt->is_branch)
 				kvm_pmu_branch_retired(vcpu);
 			kvm_rip_write(vcpu, ctxt->eip);
+			__kvm_set_rflags(vcpu, ctxt->eflags);
 			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
 				r = kvm_vcpu_do_singlestep(vcpu);
 			kvm_x86_call(update_emulated_instruction)(vcpu);
-			__kvm_set_rflags(vcpu, ctxt->eflags);
 		}
 
 		/*
-- 
2.31.1


