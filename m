Return-Path: <kvm+bounces-73163-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UMkbJZVCq2nJbgEAu9opvQ
	(envelope-from <kvm+bounces-73163-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 22:09:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F4050227BB0
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 22:09:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 37E863074573
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 21:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9F2481FBA;
	Fri,  6 Mar 2026 21:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SwOYsY6a"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C072481A9C;
	Fri,  6 Mar 2026 21:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772831351; cv=none; b=P+zMmlqQSjgzrozaGLTePnNPsW26JFFH22CFQLcCMhewTfAocXaH2DqeOjCut0OWhEeASYF2JsJDarye+A/yEAebU09l6B4kOk9jNJ8p2slKvXk4r7XvGRVaHlDwb0VZK1FpQfE01PeHrfKYIovDPG99NNGJW4kr45+8nSEl5+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772831351; c=relaxed/simple;
	bh=in1bbterwp8ZETaHG9kMMOIjehLDOJ5KlUVscZMC+Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTymk4WFgl+4Qt80CT/Z737MuFdA8I2/vy6Y8oHFDDe1ww6FkSyePFEQmMDW3iRGyGotPLApK2uPYDWWeYTXpcICq+tV/eRZ6r73c7bsrqZGf0YS59oIY9zlo7ek5YoWg8y48JqtfwX65JLcT7kIpvy9qxAcqTgqehDzlVdaFDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SwOYsY6a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01001C2BC9E;
	Fri,  6 Mar 2026 21:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772831351;
	bh=in1bbterwp8ZETaHG9kMMOIjehLDOJ5KlUVscZMC+Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwOYsY6aTse99kZTaCfTx7xyj2OALKnXCXCuvqOST1UxrvCtFuLce3CeH5FwTEJHd
	 VyTypysUvVwLzZ4261I5wH8FGkSsrPlyrPIjfpOZKw24adeeOMbfStkkAOuWQwmZ98
	 Ve/azw6lM73mNrQZrqu+/8qsug/UhK204wWn+BRa4ny1oOZRvexSDmISliQvMvfoiu
	 b+2tOOzUtNcwwrg/kZg7jQKfgMSPlfygCXmB3U7fCHFWNQcVQdqhzMD6OVm6nYaIbu
	 anT1YMA3Ny4zXK9hhDHWvMVFBRJRKo0ic5cSZXdAX0fYevsBsi3FhIrC8qG8oLqLoy
	 apKZ/sLsgWu7g==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v2 1/6] KVM: SVM: Use maxphyaddr in emulator RAX check for VMRUN/VMLOAD/VMSAVE
Date: Fri,  6 Mar 2026 21:08:55 +0000
Message-ID: <20260306210900.1933788-2-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260306210900.1933788-1-yosry@kernel.org>
References: <20260306210900.1933788-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F4050227BB0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73163-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.983];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Architecturally, VMRUN/VMLOAD/VMSAVE should generate a #GP if the
physical address in RAX is not supported. check_svme_pa() hardcodes this
to checking that bits 63-48 are not set. This is incorrect on HW
supporting 52 bits of physical address space, so use maxphyaddr instead.

Note that the host's maxphyaddr is used, not the guest, because the
emulator path for VMLOAD/VMSAVE is generally used when virtual
VMLOAD/VMSAVE is enabled AND a #NPF is generated. If a #NPF is not
generated, the CPU will inject a #GP based on the host's maxphyaddr.  So
this keeps the behavior consistent.

If KVM wants to consistently inject a #GP based on the guest's
maxphyaddr, it would need to disabled virtual VMLOAD/VMSAVE and
intercept all VMLOAD/VMSAVE instructions to do the check.

Also, emulating a smaller maxphyaddr for the guest than the host
generally doesn't work well, so it's not worth handling this.

Fixes: 01de8b09e606 ("KVM: SVM: Add intercept checks for SVM instructions")
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/emulate.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 6145dac4a605a..9ea2584dda912 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3887,8 +3887,7 @@ static int check_svme_pa(struct x86_emulate_ctxt *ctxt)
 {
 	u64 rax = reg_read(ctxt, VCPU_REGS_RAX);
 
-	/* Valid physical address? */
-	if (rax & 0xffff000000000000ULL)
+	if (rax & rsvd_bits(kvm_host.maxphyaddr, 63))
 		return emulate_gp(ctxt, 0);
 
 	return check_svme(ctxt);
-- 
2.53.0.473.g4a7958ca14-goog


