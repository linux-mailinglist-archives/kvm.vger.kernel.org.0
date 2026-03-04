Return-Path: <kvm+bounces-72626-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ANKZNGN7p2kshwAAu9opvQ
	(envelope-from <kvm+bounces-72626-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:22:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6044E1F8DBD
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:22:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6F4153014C77
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 00:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD652EDD78;
	Wed,  4 Mar 2026 00:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sdpjFRaD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CC72D5432
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 00:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772583749; cv=none; b=XK0gqR5fHk9hZ/P2/OkCt8q6smgLZPWfxg4Z0Xj+aOc/a2U2GM2I8AM6s67RiplYmNKt/bvWoI5gsQEbI65Nhte2Ld2kwCiN7cctOiOhUrWyzYMOmFv2qbJCEVn5U01Rr5PNiSejxZ4q2jHx9WaRok3EwyCr2iBLvX5qHUQV4dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772583749; c=relaxed/simple;
	bh=Ck6UOjQ5l9IPeUj0AuHo5TInOYDQijB57LOwr0XEFvg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DXWQbo7t85gEWHna5Iwa+ZtYSI8Qr+/I7mi3H2cCbbuBqtrhOXTWiwk4BmfibN3dC+ePYrLWqqBYIxj0JYFSZEvni2zxMbjg2TPdJaSm+9k0ZkdUXuGfWXxGb9Ai/8w2+4puv040UqmsBC0cCZ8lsysQHifLI2HXoUzrHACKjqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sdpjFRaD; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-bce224720d8so3547025a12.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 16:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772583748; x=1773188548; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MgLfV/AlTi0QspD6Lj2GwHa9tuqm7EnMjJUIM2Fpook=;
        b=sdpjFRaDiCgJ4VvI3tMHTr3RSuLAdLcAA8ppnyiTmS8AMVesQzx84jMWmEXlev+47Z
         FShlA15Z6gTfSdJfoRvvugRjazdc7kY4IY6SpQbCOFs59BnBhagek4jIJ4mSfZ4mT9kB
         SR8LgKMztSh4w1S0XdQpg3zsJgakjbRlxUUcrXXGYfexvu0E/cBTKJGze/ERAjuajMVP
         wVJnJuON1aFN0x0fcjS46Mfj9SIMuGQA/b+taxChN6pGqyy7SX/LcR723jd6DKWdIPmG
         dJtcWj0AuJlrHTJgDtobZWCUuI8k47p6/5LzRyNctCed1GLI0F0BsYo7cbxnZDmn131u
         /Eug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772583748; x=1773188548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MgLfV/AlTi0QspD6Lj2GwHa9tuqm7EnMjJUIM2Fpook=;
        b=wBsyR5u7kur9bb7o34sjLbyKsu4uNsYE/8rp7NE2XMp1NBNRjXX5M2y0QBgC0FfhcB
         m6qklS+FYbjO99w+tbOyLQjTHo5XrbGXRnTGqNZTbNQFkT86rBFx+RFp/r1qV5HWdvZZ
         K3pdPN6ITzbMlETp/WQsA7EMn2SY9zoojJspzLx0G0ZB5S7v+N8J621ZKXwp7PSjT8N1
         bJRQqpmBOyDNTWhdBbdA21DmqwrbCeXxivVv4EhJJhaGKN4UX58G2lMXHzvT7bpv29cT
         KIX+XFfscSpCpLBkXWbKoCd8jj8dW+PvdRKtqQ9dVTI3iQ4Jmi8qWtX077dcaCTB5uHN
         lhjA==
X-Gm-Message-State: AOJu0YwFACIY5iZFW0FYIZSamv/U07uLvdOZneYrFk/DNlahNvOxwiYd
	x3uI4PoXYNdrvB9zCOd2odSHUz8QBkOlXHwgILOcgL+ZTUH1JOga73C2sFjBEfuQtgCk9J30wHa
	2KIHcHg==
X-Received: from pltg3.prod.google.com ([2002:a17:902:6b43:b0:2a9:5a6e:3616])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e888:b0:2ae:48a0:33e3
 with SMTP id d9443c01a7336-2ae6ab782d2mr2333325ad.45.1772583747859; Tue, 03
 Mar 2026 16:22:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  3 Mar 2026 16:22:22 -0800
In-Reply-To: <20260304002223.1105129-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260304002223.1105129-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260304002223.1105129-2-seanjc@google.com>
Subject: [PATCH v5 1/2] KVM: nSVM: Raise #UD if unhandled VMMCALL isn't
 intercepted by L1
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6044E1F8DBD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72626-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Action: no action

From: Kevin Cheng <chengkev@google.com>

Explicitly synthesize a #UD for VMMCALL if L2 is active, L1 does NOT want
to intercept VMMCALL, nested_svm_l2_tlb_flush_enabled() is true, and the
hypercall is something other than one of the supported Hyper-V hypercalls.
When all of the above conditions are met, KVM will intercept VMMCALL but
never forward it to L1, i.e. will let L2 make hypercalls as if it were L1.

The TLFS says a whole lot of nothing about this scenario, so go with the
architectural behavior, which says that VMMCALL #UDs if it's not
intercepted.

Opportunistically do a 2-for-1 stub trade by stub-ifying the new API
instead of the helpers it uses.  The last remaining "single" stub will
soon be dropped as well.

Suggested-by: Sean Christopherson <seanjc@google.com>
Fixes: 3f4a812edf5c ("KVM: nSVM: hyper-v: Enable L2 TLB flush")
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Kevin Cheng <chengkev@google.com>
Link: https://patch.msgid.link/20260228033328.2285047-5-chengkev@google.com
[sean: rewrite changelog and comment, tag for stable, remove defunct stubs]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/hyperv.h     |  8 --------
 arch/x86/kvm/svm/hyperv.h | 11 +++++++++++
 arch/x86/kvm/svm/nested.c |  4 +---
 arch/x86/kvm/svm/svm.c    | 19 ++++++++++++++++++-
 4 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 6ce160ffa678..6301f79fcbae 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -305,14 +305,6 @@ static inline bool kvm_hv_has_stimer_pending(struct kvm_vcpu *vcpu)
 {
 	return false;
 }
-static inline bool kvm_hv_is_tlb_flush_hcall(struct kvm_vcpu *vcpu)
-{
-	return false;
-}
-static inline bool guest_hv_cpuid_has_l2_tlb_flush(struct kvm_vcpu *vcpu)
-{
-	return false;
-}
 static inline int kvm_hv_verify_vp_assist(struct kvm_vcpu *vcpu)
 {
 	return 0;
diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
index d3f8bfc05832..9af03970d40c 100644
--- a/arch/x86/kvm/svm/hyperv.h
+++ b/arch/x86/kvm/svm/hyperv.h
@@ -41,6 +41,13 @@ static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
 	return hv_vcpu->vp_assist_page.nested_control.features.directhypercall;
 }
 
+static inline bool nested_svm_is_l2_tlb_flush_hcall(struct kvm_vcpu *vcpu)
+{
+	return guest_hv_cpuid_has_l2_tlb_flush(vcpu) &&
+	       nested_svm_l2_tlb_flush_enabled(vcpu) &&
+	       kvm_hv_is_tlb_flush_hcall(vcpu);
+}
+
 void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
 #else /* CONFIG_KVM_HYPERV */
 static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu) {}
@@ -48,6 +55,10 @@ static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
 {
 	return false;
 }
+static inline bool nested_svm_is_l2_tlb_flush_hcall(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
 static inline void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu) {}
 #endif /* CONFIG_KVM_HYPERV */
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 53ab6ce3cc26..750bf93c5341 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1674,9 +1674,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 	}
 	case SVM_EXIT_VMMCALL:
 		/* Hyper-V L2 TLB flush hypercall is handled by L0 */
-		if (guest_hv_cpuid_has_l2_tlb_flush(vcpu) &&
-		    nested_svm_l2_tlb_flush_enabled(vcpu) &&
-		    kvm_hv_is_tlb_flush_hcall(vcpu))
+		if (nested_svm_is_l2_tlb_flush_hcall(vcpu))
 			return NESTED_EXIT_HOST;
 		break;
 	default:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8f8bc863e214..38a2fad81ad8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -52,6 +52,7 @@
 #include "svm.h"
 #include "svm_ops.h"
 
+#include "hyperv.h"
 #include "kvm_onhyperv.h"
 #include "svm_onhyperv.h"
 
@@ -3228,6 +3229,22 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int vmmcall_interception(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Inject a #UD if L2 is active and the VMMCALL isn't a Hyper-V TLB
+	 * hypercall, as VMMCALL #UDs if it's not intercepted, and this path is
+	 * reachable if and only if L1 doesn't want to intercept VMMCALL or has
+	 * enabled L0 (KVM) handling of Hyper-V L2 TLB flush hypercalls.
+	 */
+	if (is_guest_mode(vcpu) && !nested_svm_is_l2_tlb_flush_hcall(vcpu)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
+	}
+
+	return kvm_emulate_hypercall(vcpu);
+}
+
 static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
@@ -3278,7 +3295,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
 	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
 	[SVM_EXIT_VMRUN]			= vmrun_interception,
-	[SVM_EXIT_VMMCALL]			= kvm_emulate_hypercall,
+	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
 	[SVM_EXIT_VMLOAD]			= vmload_interception,
 	[SVM_EXIT_VMSAVE]			= vmsave_interception,
 	[SVM_EXIT_STGI]				= stgi_interception,
-- 
2.53.0.473.g4a7958ca14-goog


