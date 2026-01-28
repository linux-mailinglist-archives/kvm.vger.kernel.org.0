Return-Path: <kvm+bounces-69302-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CBdIB9VneWmPwwEAu9opvQ
	(envelope-from <kvm+bounces-69302-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:35:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 538359BEEC
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:35:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B8EAB302A6DE
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 01:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1089A238178;
	Wed, 28 Jan 2026 01:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UAcSfLNG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D495D22652D
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 01:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564079; cv=none; b=AlItzn4d6/yAKVjlukR5sMI7zcPTt6G/MdwYoYjaEkXqw/mgNkZ0RbP0okPgfKdp/5NmmDA+Smd2OPNBDRRzvg0ilZMTHEuJGNpGUVabMngLP7m+zSBgAKQufLB95O4rqchJpd09cMxeh5cLLzZ9p0IWEpdksqWsfS8mhWX+TJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564079; c=relaxed/simple;
	bh=80qQLVQ5jJzLtpnLzVFm9M9H2UbAiPmAYz+2rzEoNUo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qcfrU3tEMmX0Qg6EfDuvpWra/peC1I4pvcSmgaSvdAIquL7oQCbKhbB80k28EXxw/V0pzpxv6KLYDZZVVFAaIh4hSn8h9RDScDMAeE0v17QXiNL81uLzhVL1CC+rlg54O5LSJN3GyNW6Utx8UX0R+oCvLm3EJmqHCq78kaZ/v2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UAcSfLNG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-352c79abf36so5270673a91.2
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 17:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769564077; x=1770168877; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BUVUKuSQV+U+8gsuswu6Brp9Cg3f+EwR6/8UYrViixw=;
        b=UAcSfLNGiwZhcqxv0RkRsZvSz/t3tvroGAMaBprXVOWTk0qhO0qnAhRy47ygpf6k3m
         HpzAJdD5kLyN9Gr/Wovwg/6j8p4qUhZjcDRkRzPj+J3G/0WJGg99anneF6lVx5i8wKZp
         pLF9BEEAi8LqO7wsN7f4HHij0nnc33MA+SdeQU7vuUZPOhykIv6zRaEWp0UPZV8eiteG
         /XHQYIwrdwis/QQDJop3WI3bwx/vO8BW6ikjH08cekyPJ5uWjfGrRS6wJFLn4In1zOc/
         oXoHB+U/VYp2bsUjQG0+QVs5iJmN43ZaNa/EFs+KDHPc/Ir+O1xngDkrvM15QKvbmdZL
         r3cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769564077; x=1770168877;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BUVUKuSQV+U+8gsuswu6Brp9Cg3f+EwR6/8UYrViixw=;
        b=bzvDU4J/EeRxCNmRS7avGpIUI2nUybRgoSc3xGiyG1oRie6x5kBzK2JFfZb65oT98z
         M0gCnM32y2ccbTNAS1Zq2YGuENjQ575Jq8wSEM0UcALDyCEin2dezRBsAMuOLibl07j4
         iN/MsuFPKB52DqLhApuTEwO/icdAFNs82KgFwS3JZj3Jcg9u/RDJmitCO+VICgv2HOOZ
         M7/GnxRJlInDcHP1HZEOHopUI3kxOYnD42oet8DL/rycrvBh7PnDHLknSv5YMRvRChk2
         Y8PdeLdxEQQ1YF6S60mBtqvRR9yPGcXFc/oM9eGbvBmg0TuamWxJzBo8gMGjHSfl26ik
         NheA==
X-Gm-Message-State: AOJu0YxwMaTsutJXZfLyQKkA2YnRlMqhopRRZHWR6f3C+AmGI/e6EeTQ
	kPRR1Orgamh6QEc/R5lgofk6BWDuaNEs2A2xozWXc/k6veKkdQoJnzGxcNGiipoib8cKR17SY2S
	SQ5OQLA==
X-Received: from pja13.prod.google.com ([2002:a17:90b:548d:b0:352:ba50:2819])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:270e:b0:34a:b459:bd10
 with SMTP id 98e67ed59e1d1-353fed7104bmr3202540a91.24.1769564077205; Tue, 27
 Jan 2026 17:34:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Jan 2026 17:34:31 -0800
In-Reply-To: <20260128013432.3250805-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260128013432.3250805-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260128013432.3250805-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: x86: Defer IBPBs for vCPU and nested transitions
 until core run loop
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Jim Mattson <jmattson@google.com>, 
	David Kaplan <david.kaplan@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69302-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 538359BEEC
X-Rspamd-Action: no action

When emitting an Indirect Branch Prediction Barrier to isolate different
guest security domains (different vCPUs or L1 vs. L2 in the same vCPU),
defer the IBPB until VM-Enter is imminent to avoid redundant and/or
unnecessary IBPBs.  E.g. if a vCPU is loaded on a CPU without ever doing
VM-Enter, then _KVM_ isn't responsible for doing an IBPB as KVM's job is
purely to mitigate guests<=>guest attacks; guest=>host attacks are covered
by IBRS.

Cc: stable@vger.kernel.org
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Jim Mattson <jmattson@google.com>
Cc: David Kaplan <david.kaplan@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 7 ++++++-
 arch/x86/kvm/x86.h              | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e441f270f354..76bbc80a2d1d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -826,6 +826,7 @@ struct kvm_vcpu_arch {
 	u64 smbase;
 	u64 smi_count;
 	bool at_instruction_boundary;
+	bool need_ibpb;
 	bool tpr_access_reporting;
 	bool xfd_no_write_intercept;
 	u64 microcode_version;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8acfdfc583a1..e5ae655702b4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5187,7 +5187,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		 * is handled on the nested VM-Exit path.
 		 */
 		if (static_branch_likely(&switch_vcpu_ibpb))
-			indirect_branch_prediction_barrier();
+			vcpu->arch.need_ibpb = true;
 		per_cpu(last_vcpu, cpu) = vcpu;
 	}
 
@@ -11315,6 +11315,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 	}
 
+	if (unlikely(vcpu->arch.need_ibpb)) {
+		indirect_branch_prediction_barrier();
+		vcpu->arch.need_ibpb = false;
+	}
+
 	fpregs_assert_state_consistent();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		switch_fpu_return();
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 70e81f008030..6708142d051d 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -169,7 +169,7 @@ static inline void kvm_nested_vmexit_handle_ibrs(struct kvm_vcpu *vcpu)
 
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
 	    guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_IBRS))
-		indirect_branch_prediction_barrier();
+		vcpu->arch.need_ibpb = true;
 }
 
 /*
-- 
2.52.0.457.g6b5491de43-goog


