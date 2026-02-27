Return-Path: <kvm+bounces-72122-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8DAwO7bvoGmOoAQAu9opvQ
	(envelope-from <kvm+bounces-72122-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 02:13:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 93E4C1B16EB
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 02:13:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 41A32301BDE9
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 01:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 687BC2D781B;
	Fri, 27 Feb 2026 01:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HmNwx6jw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808B028725A;
	Fri, 27 Feb 2026 01:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772154796; cv=none; b=EIQeR+LRG3JCKmXvq7Ph4bIUTTMxJmf+qRakLSFuj75x+4mzxwx+2hhkcms6OhV0Xh8nng9Bd3ZYMigoWPOhT4FOpqPngCl5A5Jnt59Cg7qwdh149223IA3y99FdToxvsYRfISwEXKa/c5aJ8P1xYZMm8RgN2Qn3rbeIuT7/3qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772154796; c=relaxed/simple;
	bh=66dQMMAJGFVFs7dbAT5HF7FT0rhfqMOXncNRGJZfeFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFgfvxsFuOKGyf8LpAw9txitG06UoHderwSbXBVQUVXptIVwNQYQBdTy5ru1Xp6mWi+SXAwB3Pm+NCL4K0M/SV/0gUI2/o86Hw2C796JArjtW+K7lYzxqRh00yOhYoYVyCsFIIGNJVZnQFLE7zv9pjbuM8496rmqpHNK7Q1d5Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HmNwx6jw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3341EC19425;
	Fri, 27 Feb 2026 01:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772154796;
	bh=66dQMMAJGFVFs7dbAT5HF7FT0rhfqMOXncNRGJZfeFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmNwx6jw8/yAfmJS8lUyj0JuKYoHk/dW4dQ5lro1rHbUlvFv6yJDT4qKTnteVMI6K
	 /Z91+nSkV2a3Mnbs8P5H3K3jU7tAGDJcRdNTQSYbdokE8e+djC0gvXZQjY8qYUvBkB
	 qJu/7SxAge5NDOGDIosQAbT1g+VEWgsMOu3FsUnpD5p20P3f8dZSwySUjWKTejUS0N
	 wpEI8T9QpFX4Q2XTpucyv4I3ZfLrYDJWLXIlJxH7yEdKgZufxUc5rhuVdFbmPzQGT6
	 H7wDUN+ZfhGNtQNWotVAOzBWcFdJTG2e1rwykNpGy/UdZSBXglko+dcP1dqYHgI+3K
	 KCVMU7N1xismA==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH 2/3] KVM: x86: Do not inject triple faults into an L2 with a pending run
Date: Fri, 27 Feb 2026 01:13:05 +0000
Message-ID: <20260227011306.3111731-3-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260227011306.3111731-1-yosry@kernel.org>
References: <20260227011306.3111731-1-yosry@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72122-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 93E4C1B16EB
X-Rspamd-Action: no action

If a triple fault is injected while the vCPU is in guest mode, but
before it actually ran, inject it into L1 instead of synthesizing a
SHUTDOWN VM-Exit to L1, as synthesizing a VM-Exit is not allowed before
completing the nested VM-Enter.

This could happen if KVM exits to userspace with nested_run_pending=1,
and userspace injects a triple fault with KVM_SET_VCPU_EVENTS, and
triggers WARN_ON_ONCE(vcpu->arch.nested_run_pending) in
__nested_vmx_vmexit().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/x86.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db3f393192d94..e39c5faf94230 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11914,6 +11914,19 @@ static int kvm_x86_vcpu_pre_run(struct kvm_vcpu *vcpu)
 	    !kvm_apic_init_sipi_allowed(vcpu))
 		return -EINVAL;
 
+	/*
+	 * If a triple fault was injected in guest mode (e.g. through
+	 * KVM_SET_VCPU_EVENTS), but before L2 actually ran, inject it into L1
+	 * instead of synthesizing a SHUTDOWN VM-Exit to L1, as synthesizing a
+	 * VM-Exit is not allowed before completing the nested VM-Enter.
+	 */
+	if (is_guest_mode(vcpu) && vcpu->arch.nested_run_pending &&
+	    kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu)) {
+		vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
+		vcpu->mmio_needed = 0;
+		return 0;
+	}
+
 	return kvm_x86_call(vcpu_pre_run)(vcpu);
 }
 
-- 
2.53.0.473.g4a7958ca14-goog


