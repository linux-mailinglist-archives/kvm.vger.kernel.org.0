Return-Path: <kvm+bounces-71687-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KJOkJ1Aonmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71687-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:38:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DFA318D72E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:38:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C5EDC311D83F
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0077C363C5C;
	Tue, 24 Feb 2026 22:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DDr9rb51"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F85362157;
	Tue, 24 Feb 2026 22:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972466; cv=none; b=n5DEY73Dd5m+ofK0/JXzS4fSadqC+fA/Y/Zn+pcRymfFJZVvzavUTEIaRjAn07LQUqLcy8x+iXz26EoYMEOs0JoGcIa7R3bC8fOB6RTQFy1ajXYl7uC/FPVFC6q0nfG4Sk1yZec7aPDWNa6iqN4t1c2UkTO9EwizOtTJQhNJ8U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972466; c=relaxed/simple;
	bh=Tg11fWMN6z8tkZRwo0otGiUR8cVHWqjvqfkJjiotBuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VogpDjofZKv7e8bk9dYplMGEDKGZmyWwxLFLBJozDCno4VriwEtl+QLCV9lVI6J7AVShhJ57bH6++npSqOZ09pqlQzNrSX1gEio1oXiMwwIXwS5dfz2ESb0OUh96dMT6g77MMkguf3fcCe2fLHqYWTM4pSWpeaFQ4hV5/l0CklI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DDr9rb51; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F594C19424;
	Tue, 24 Feb 2026 22:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972465;
	bh=Tg11fWMN6z8tkZRwo0otGiUR8cVHWqjvqfkJjiotBuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDr9rb51kWMAIp6sOPf28/8PJ4GJbGpl8EjZ7oVuZdfS9YMmk/FEhVatdIktZDmLR
	 lnGLwKa00ku5FDNtqr9FCT6JFuFOpMOwPkg/oj//f+QNSFLVYG1CHMKpZBC0eyRYCx
	 sgJhQzXeWkJVeVagnbwkOWNaAfSf3xyb0FtnGFON8a64tmutzCy1f7A/gMIvNq4qV3
	 I0EB4202KfPNlkHxozWfX2dUp4m7TIcJpKGHj4B1FOFO2ErpuEbKXX1oz2fdq3Zhhi
	 qJKj9Q7PeRFThHDSRGccu+QsInFzxarUXCcU3mQvwx+xZJTZVyPkRy57RL/t22B3Qt
	 EP7utbARwp+Aw==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v6 11/31] KVM: nSVM: Call enter_guest_mode() before switching to VMCB02
Date: Tue, 24 Feb 2026 22:33:45 +0000
Message-ID: <20260224223405.3270433-12-yosry@kernel.org>
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
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71687-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3DFA318D72E
X-Rspamd-Action: no action

In preparation for moving more changes that rely on is_guest_mode()
before switching to VMCB02, move entering guest mode a bit earlier.

Nothing between the new callsite(s) and the old ones rely on
is_guest_mode(), so this should be safe.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 0592690e75164..5ba3f8de0a939 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -746,9 +746,6 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 
 	nested_svm_transition_tlb_flush(vcpu);
 
-	/* Enter Guest-Mode */
-	enter_guest_mode(vcpu);
-
 	/*
 	 * Filled at exit: exit_code, exit_info_1, exit_info_2, exit_int_info,
 	 * exit_int_info_err, next_rip, insn_len, insn_bytes.
@@ -949,6 +946,8 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 
 	WARN_ON(svm->vmcb == svm->nested.vmcb02.ptr);
 
+	enter_guest_mode(vcpu);
+
 	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
@@ -1900,6 +1899,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, save);
 	nested_copy_vmcb_control_to_cache(svm, ctl);
 
+	enter_guest_mode(vcpu);
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
 
-- 
2.53.0.414.gf7e9f6c205-goog


