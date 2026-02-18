Return-Path: <kvm+bounces-71203-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KPkvDuwNlWkfKgIAu9opvQ
	(envelope-from <kvm+bounces-71203-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 01:55:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9660C1526AE
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 01:55:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 053023033501
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 00:54:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65DA7286D72;
	Wed, 18 Feb 2026 00:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wu3TMOck"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F29247280
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 00:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771376085; cv=none; b=e9AMEIX7PFZjk34j8rcvKNdbQHajGUeB29i0T6tnbXazB6xsiTMa73GwgYgrVHzQYVILU6uTCcFRJa+oNsgnGVrbutu2c4fBZ1MbUXl17AOWjn3mIsJdBAg5ENjFsYauCHN/qAd+dU3KDDy5K9witWbtm4LcGnBEwFxWHBxZ1N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771376085; c=relaxed/simple;
	bh=BJq+bnODq7PPJfYiXocsUdd7noDnh5Qk/6IbZnX9Jto=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=OzuRyCKNS/YqCRRvlAFOUMq69D7iZmenHyo/m8lPZF6dtX1hwKLpLE+0kLuvkIYKg1fKWVs3naAmSakl5eh2MnRTAA4YX2olotlY2L9jCl6vFboemD7056s8eZDzN3nB01q0E02ttKZvBf0Esy+l/UzmXj3ita4cShOktYNKzNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wu3TMOck; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35842aa350fso15674638a91.0
        for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 16:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771376083; x=1771980883; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZEhXLZTAt6f3yc+91oPu+TmXvKGxerYCl9HuHZGGdxc=;
        b=Wu3TMOckqbXn3r53IKmOIZbbAhhk/kKCvH3sDdiu16unQISvWNnLdnl9DX4KcY3xgp
         YUu8lo4UBLqT76Ca+nfDRgIcKvKkJ1a2L4fWUiPhH/9MpgM95qZ1an2rQdhMBmEUiv9/
         icz8SwkKGyFNF1Jl1rBmMXTGrU1N03ry6kuhag0v1MRb6PRjDmygbzVflGiOvZJZ0umi
         Pp/tbeXse/jT/wLm/DMK7iw+cTZ9GCYLbvdxgMJ28UrcsdIfIVZxPQ/yDSL2SohJIsmP
         sbg6jcLLftpSiJlKMur6QTyZqjgYtMZJaHKZ2nHn+LUs36WhVDoOgUY1uOmuXIfZkMfI
         0bNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771376083; x=1771980883;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZEhXLZTAt6f3yc+91oPu+TmXvKGxerYCl9HuHZGGdxc=;
        b=ZLzOS9QgWetnp1lsxK9l5KZ18DNGyWYwTn1RxKbSbsyh3B4EOMF+6hFWB9PzpjoGT7
         48GSsGUokrxdDfOajdo6cbzBgONmthczW2oLMwHIbx/dTm4cuGhuT0K+sQezDs9ONeNg
         3p+XnP/kH4NKvX2FaG8OSOHZWpNQQFyilInCzEPfzuOBHMKRFbMzHnu4ddSiUP/xbgqR
         v5P9prvjSnGL5gWJE8WwVuVmfrJm+18eM4Rme36b99lHyiyfP+Xp+ka/LRULnfzH6Ig0
         stF/ThHI6uz76eIRnHVNMGNcRHAggii/4lKAkGVmmh/Zr50Je7BfMyj/bZ7kes7trcph
         923A==
X-Gm-Message-State: AOJu0YzDKCU+FT8dedTnxB4ibDt1hdEXmEMgKgm791mhbPczMU6pPrqz
	0eeSTBp0HD7cPz0LW1VeeZtDH1JuafneLyajaOjozdwzjfqLQNW7nMhugb/Qpyj5zUYCIarIbNB
	/Y+7BSQ==
X-Received: from pjbhk3.prod.google.com ([2002:a17:90b:2243:b0:352:f162:7d9f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:270e:b0:352:c762:8c2e
 with SMTP id 98e67ed59e1d1-356a777f11emr13842807a91.13.1771376082740; Tue, 17
 Feb 2026 16:54:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 17 Feb 2026 16:54:38 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
Message-ID: <20260218005438.2619063-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Defer non-architectural deliver of exception
 payload to userspace read
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71203-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 9660C1526AE
X-Rspamd-Action: no action

When attempting to play nice with userspace that hasn't enabled
KVM_CAP_EXCEPTION_PAYLOAD, defer KVM's non-architectural delivery of the
payload until userspace actually reads relevant vCPU state, and more
importantly, force delivery of the payload in *all* paths where userspace
saves relevant vCPU state, not just KVM_GET_VCPU_EVENTS.

Ignoring userspace save/restore for the moment, delivering the payload
before the exception is injected is wrong regardless of whether L1 or L2
is running.  To make matters even more confusing, the flaw *currently*
being papered over by the !is_guest_mode() check isn't even the same bug
that commit da998b46d244 ("kvm: x86: Defer setting of CR2 until #PF
delivery") was trying to avoid.

At the time of commit da998b46d244, KVM didn't correctly handle exception
intercepts, as KVM would wait until VM-Entry into L2 was imminent to check
if the queued exception should morph to a nested VM-Exit.  I.e. KVM would
deliver the payload to L2 and then synthesize a VM-Exit into L1.  But the
payload was only the most blatant issue, e.g. waiting to check exception
intercepts would also lead to KVM incorrectly escalating a
should-be-intercepted #PF into a #DF.

That underlying bug was eventually fixed by commit 7709aba8f716 ("KVM: x86:
Morph pending exceptions to pending VM-Exits at queue time"), but in the
interim, commit a06230b62b89 ("KVM: x86: Deliver exception payload on
KVM_GET_VCPU_EVENTS") came along and subtly added another dependency on
the !is_guest_mode() check.

While not recorded in the changelog, the motivation for deferring the
!exception_payload_enabled delivery was to fix a flaw where a synthesized
MTF (Monitor Trap Flag) VM-Exit would drop a pending #DB and clobber DR6.
On a VM-Exit, VMX CPUs save pending #DB information into the VMCS, which
is emulated by KVM in nested_vmx_update_pending_dbg() by grabbing the
payload from the queue/pending exception.  I.e. prematurely delivering the
payload would cause the pending #DB to not be recorded in the VMCS, and of
course, clobber L2's DR6 as seen by L1.

Jumping back to save+restore, the quirked behavior of forcing delivery of
the payload only works if userspace does KVM_GET_VCPU_EVENTS *before*
CR2 or DR6 is saved, i.e. before KVM_GET_SREGS{,2} and KVM_GET_DEBUGREGS.
E.g. if userspace does KVM_GET_SREGS before KVM_GET_VCPU_EVENTS, then the
CR2 saved by userspace won't contain the payload for the exception save by
KVM_GET_VCPU_EVENTS.

Deliberately deliver the payload in the store_regs() path, as it's the
least awful option even though userspace may not be doing save+restore.
Because if userspace _is_ doing save restore, it could elide KVM_GET_SREGS
knowing that SREGS were already saved when the vCPU exited.

Link: https://lore.kernel.org/all/20200207103608.110305-1-oupton@google.com
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 62 +++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db3f393192d9..365ce3ea4a32 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -864,9 +864,6 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
 		vcpu->arch.exception.error_code = error_code;
 		vcpu->arch.exception.has_payload = has_payload;
 		vcpu->arch.exception.payload = payload;
-		if (!is_guest_mode(vcpu))
-			kvm_deliver_exception_payload(vcpu,
-						      &vcpu->arch.exception);
 		return;
 	}
 
@@ -5532,18 +5529,8 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
-					       struct kvm_vcpu_events *events)
+static struct kvm_queued_exception *kvm_get_exception_to_save(struct kvm_vcpu *vcpu)
 {
-	struct kvm_queued_exception *ex;
-
-	process_nmi(vcpu);
-
-#ifdef CONFIG_KVM_SMM
-	if (kvm_check_request(KVM_REQ_SMI, vcpu))
-		process_smi(vcpu);
-#endif
-
 	/*
 	 * KVM's ABI only allows for one exception to be migrated.  Luckily,
 	 * the only time there can be two queued exceptions is if there's a
@@ -5554,21 +5541,46 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	if (vcpu->arch.exception_vmexit.pending &&
 	    !vcpu->arch.exception.pending &&
 	    !vcpu->arch.exception.injected)
-		ex = &vcpu->arch.exception_vmexit;
-	else
-		ex = &vcpu->arch.exception;
+		return &vcpu->arch.exception_vmexit;
+
+	return &vcpu->arch.exception;
+}
+
+static void kvm_handle_exception_payload_quirk(struct kvm_vcpu *vcpu)
+{
+	struct kvm_queued_exception *ex = kvm_get_exception_to_save(vcpu);
 
 	/*
-	 * In guest mode, payload delivery should be deferred if the exception
-	 * will be intercepted by L1, e.g. KVM should not modifying CR2 if L1
-	 * intercepts #PF, ditto for DR6 and #DBs.  If the per-VM capability,
-	 * KVM_CAP_EXCEPTION_PAYLOAD, is not set, userspace may or may not
-	 * propagate the payload and so it cannot be safely deferred.  Deliver
-	 * the payload if the capability hasn't been requested.
+	 * If KVM_CAP_EXCEPTION_PAYLOAD is disabled, then (prematurely) deliver
+	 * the pending exception payload when userspace saves *any* vCPU state
+	 * that interacts with exception payloads to avoid breaking userspace.
+	 *
+	 * Architecturally, KVM must not deliver an exception payload until the
+	 * exception is actually injected, e.g. to avoid losing pending #DB
+	 * information (which VMX tracks in the VMCS), and to avoid clobbering
+	 * state if the exception is never injected for whatever reason.  But
+	 * if KVM_CAP_EXCEPTION_PAYLOAD isn't enabled, then userspace may or
+	 * may not propagate the payload across save+restore, and so KVM can't
+	 * safely defer delivery of the payload.
 	 */
 	if (!vcpu->kvm->arch.exception_payload_enabled &&
 	    ex->pending && ex->has_payload)
 		kvm_deliver_exception_payload(vcpu, ex);
+}
+
+static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
+					       struct kvm_vcpu_events *events)
+{
+	struct kvm_queued_exception *ex = kvm_get_exception_to_save(vcpu);
+
+	process_nmi(vcpu);
+
+#ifdef CONFIG_KVM_SMM
+	if (kvm_check_request(KVM_REQ_SMI, vcpu))
+		process_smi(vcpu);
+#endif
+
+	kvm_handle_exception_payload_quirk(vcpu);
 
 	memset(events, 0, sizeof(*events));
 
@@ -5747,6 +5759,8 @@ static int kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
 	    vcpu->arch.guest_state_protected)
 		return -EINVAL;
 
+	kvm_handle_exception_payload_quirk(vcpu);
+
 	memset(dbgregs, 0, sizeof(*dbgregs));
 
 	BUILD_BUG_ON(ARRAY_SIZE(vcpu->arch.db) != ARRAY_SIZE(dbgregs->db));
@@ -12137,6 +12151,8 @@ static void __get_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	if (vcpu->arch.guest_state_protected)
 		goto skip_protected_regs;
 
+	kvm_handle_exception_payload_quirk(vcpu);
+
 	kvm_get_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
 	kvm_get_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
 	kvm_get_segment(vcpu, &sregs->es, VCPU_SREG_ES);

base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
-- 
2.53.0.335.g19a08e0c02-goog


