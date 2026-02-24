Return-Path: <kvm+bounces-71679-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wIUtKFIonmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71679-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:38:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 02F8318D736
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:38:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9AAC13132DF1
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4643350A3D;
	Tue, 24 Feb 2026 22:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mle5tSWp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DB834DB44;
	Tue, 24 Feb 2026 22:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972462; cv=none; b=i9oI84Md4XNthoNlxfS/T8fYYGp3EW0iecMs3po4vMlaugF9GsVUqg5dlLsp5xsjYHlOBuhX3fanuTgWodY3AKRUBABmYiJAfW+h63sn+4/9lQ0N28Q2sPBRndt9vTan++mu6aLeuY1YiRxwL2jJvEAfwJSEAWDf6xKsirCZQUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972462; c=relaxed/simple;
	bh=TQeKGqoqKxkagIjzDzM1UTz/dPro9Gug3QNtz5J/bNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJJ9OBOLtuwQabRHfHcPutAM7nzmV+bFjTGhk+fH8Y1ylc9lty6YozaxxmupdSliww2OVke3W1vd9pIY0+Q3bYurlkRO3YYuz1KU2ObvrgnivbTfWoBNP8vvN0ACzULNd4+DmgGlPNZJ+60kfQSFXdbsDuINMx0iplyeCJyGlTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mle5tSWp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A6DC19424;
	Tue, 24 Feb 2026 22:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972462;
	bh=TQeKGqoqKxkagIjzDzM1UTz/dPro9Gug3QNtz5J/bNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mle5tSWp7zF1prFhF7Bb6gPlj3gmrNqrfM0FdCUXk7Q3yAp2ZZPojLIVJYxpEBMat
	 nRxpmFTtkyx3kyPWXBd+tskcBMLtRO6uhqnOKOt6zC9hrsbndJVIwZTAQ7Z1CYUI4R
	 AnO/ouNzavm9FLZbgDiHrtua83pUf8Y8YFB8zaTpJZX4O8nccmYR/y4BnmAIN+1Nqt
	 XiSRanGMFmqzSmtq9GW97qe6+D41fv4z9Z9ce4akzfZHV5OZ3Rm/dkFU69eNJVDZ7A
	 LCcACrO92NyyrNGhq+6/94BMJsMQYHJLeMHuXrXfn27Tp4h3gATARuq5icnLgu8DUo
	 WHisPIcDB7CJQ==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org,
	Jim Mattson <jmattson@google.com>
Subject: [PATCH v6 03/31] KVM: SVM: Add missing save/restore handling of LBR MSRs
Date: Tue, 24 Feb 2026 22:33:37 +0000
Message-ID: <20260224223405.3270433-4-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
In-Reply-To: <20260224223405.3270433-1-yosry@kernel.org>
References: <20260224223405.3270433-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71679-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 02F8318D736
X-Rspamd-Action: no action

MSR_IA32_DEBUGCTLMSR and LBR MSRs are currently not enumerated by
KVM_GET_MSR_INDEX_LIST, and LBR MSRs cannot be set with KVM_SET_MSRS. So
save/restore is completely broken.

Fix it by adding the MSRs to msrs_to_save_base, and allowing writes to
LBR MSRs from userspace only (as they are read-only MSRs). Additionally,
to correctly restore L1's LBRs while L2 is running, make sure the LBRs
are copied from the captured VMCB01 save area in svm_copy_vmrun_state().

Fixes: 24e09cbf480a ("KVM: SVM: enable LBR virtualization")
Cc: stable@vger.kernel.org
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c |  3 +++
 arch/x86/kvm/svm/svm.c    | 24 ++++++++++++++++++++++++
 arch/x86/kvm/x86.c        |  3 +++
 3 files changed, 30 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f7d5db0af69ac..52d8536845927 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1100,6 +1100,9 @@ void svm_copy_vmrun_state(struct vmcb_save_area *to_save,
 		to_save->isst_addr = from_save->isst_addr;
 		to_save->ssp = from_save->ssp;
 	}
+
+	if (lbrv)
+		svm_copy_lbrs(to_save, from_save);
 }
 
 void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f52e588317fcf..cb53174583a26 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3071,6 +3071,30 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
 		svm_update_lbrv(vcpu);
 		break;
+	case MSR_IA32_LASTBRANCHFROMIP:
+		if (!msr->host_initiated)
+			return 1;
+		svm->vmcb->save.br_from = data;
+		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
+		break;
+	case MSR_IA32_LASTBRANCHTOIP:
+		if (!msr->host_initiated)
+			return 1;
+		svm->vmcb->save.br_to = data;
+		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
+		break;
+	case MSR_IA32_LASTINTFROMIP:
+		if (!msr->host_initiated)
+			return 1;
+		svm->vmcb->save.last_excp_from = data;
+		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
+		break;
+	case MSR_IA32_LASTINTTOIP:
+		if (!msr->host_initiated)
+			return 1;
+		svm->vmcb->save.last_excp_to = data;
+		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
+		break;
 	case MSR_VM_HSAVE_PA:
 		/*
 		 * Old kernels did not validate the value written to
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db3f393192d94..416899b5dbe4d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -351,6 +351,9 @@ static const u32 msrs_to_save_base[] = {
 	MSR_IA32_U_CET, MSR_IA32_S_CET,
 	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
 	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB,
+	MSR_IA32_DEBUGCTLMSR,
+	MSR_IA32_LASTBRANCHFROMIP, MSR_IA32_LASTBRANCHTOIP,
+	MSR_IA32_LASTINTFROMIP, MSR_IA32_LASTINTTOIP,
 };
 
 static const u32 msrs_to_save_pmu[] = {
-- 
2.53.0.414.gf7e9f6c205-goog


