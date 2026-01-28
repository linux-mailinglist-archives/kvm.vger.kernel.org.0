Return-Path: <kvm+bounces-69303-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QGqiF+5neWmPwwEAu9opvQ
	(envelope-from <kvm+bounces-69303-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:35:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F32E29BF0C
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:35:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8A1ED3037D4E
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 01:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A68F723EA8D;
	Wed, 28 Jan 2026 01:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kn1lalxB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3EF2135B8
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 01:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564080; cv=none; b=EcwsrRs2mKFEYQKCehvjedOKz/0dqOr4ClTUYGTFVp1pFbGC/sXbyKBixuhDheNFrpjVkxbJVKzKk4tdlNNuyMXodcvvr5KDQBwIe2sDwf80xIHE6yP7lRXBj3OQHCITuWhY+UO8LWkysXPTCQI8DHZ1F4e6P7v+gmZoJk35yNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564080; c=relaxed/simple;
	bh=R13kez/KFVrfJYieeBKxhtp8/CpHkd4vcp7L1n+2ofo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VNpCTpgOEQcv2HgGKZUTrgY9uL3VsD2sSfqMHPASiH+tjLg32sjl9hcRZt4GI5jij8DyEm3uy5+ZvqBatyczwcE++Xy/BLrbm8reSQZbap/VB2v5JCq0xY3hhcbEUMVE6rd9N+eqh7J4Nt/bzKi4ZFPo3g+OHTuylx0vDRRSHpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kn1lalxB; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c3dfa080662so268108a12.1
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 17:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769564079; x=1770168879; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1VryWUi83hnS06/n+x/xjvRCvWKYQoklYztPIe61o0Y=;
        b=Kn1lalxBIeHpxC5M89NL6c9SRuRtCQnLaCPxwShwDwuhAaeosvogloLT9pd7DskWlk
         znTckx24+CT3bDLWZH50bBThpSI8h0uCYQK9M+R8nSYQRo4MZtdr1jkvPoNqn8FXMepu
         lNjrpS1btbxlKnelDW0TuE3Vt4mXDKnuQwBsId84p/uvWa0xfsNv86wskoWkSs4o9GJ+
         ti2BqcV9EcrS8YagHN5UJsxDijl700i1pmo4OGg5yXljgDqXwJYzf1riZsrWFs0kKoOl
         Jvj5SWYIiKqpxunIeqaSHq9dO0nFUpmfCaFuvd1aYBaoH/mcx6c1JChpu59w9TLxALTh
         PlXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769564079; x=1770168879;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1VryWUi83hnS06/n+x/xjvRCvWKYQoklYztPIe61o0Y=;
        b=UNMkFTHRuZW0MRpbHc3oQeWAvVpvM66Eb8SjCwszFzljin1vrf/nv2rKsawqx/pwa2
         H3b2D0yBcgwQ+aToqZfsezQZpcfVNwBQV5WdlG7ty7JmU/BaHUup4N1TCLRcfSI5VIPu
         x3z+ubur4jmGR8vvHHWm99P/JXBaaLDdLgzdHCO30Zm+YHEEC/6hR5ihBSGQkE+GTJCb
         tK/VCSzhdYvEhcJ7x8DV/Qe1NusPX6XfctpTGfoaPUK4/rqcj7W98Y9rzKptIz1Q5K+S
         7c2YfdnfTy1+vYifNCLucWs7VBU2m1cy/3QTfzMxwIe5NAdcRA9KSWXq+uLgIXsCgKCN
         zeZg==
X-Gm-Message-State: AOJu0YxgAqNSFnkpCXeGmQl9k0NXxhZT72A9cGoA6Gef4VJDNc+tADuz
	yuSKEOikvnXEcPmy2xbG0XPa20diDpEihrGcWlKHGqiv9R/bxFHVPxSomXMzqJ1Dmhc0zezSKkV
	q5CDm3g==
X-Received: from pgct8.prod.google.com ([2002:a05:6a02:5288:b0:c61:277a:16af])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:497:b0:38e:6774:382d
 with SMTP id adf61e73a8af0-38ec5cf9c32mr3498880637.8.1769564078792; Tue, 27
 Jan 2026 17:34:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Jan 2026 17:34:32 -0800
In-Reply-To: <20260128013432.3250805-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260128013432.3250805-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260128013432.3250805-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: x86: Emit IBPB on pCPU migration if IBPB is
 advertised to guest
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Jim Mattson <jmattson@google.com>, 
	David Kaplan <david.kaplan@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69303-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
X-Rspamd-Queue-Id: F32E29BF0C
X-Rspamd-Action: no action

Emit an Indirect Branch Prediction Barrier if a vCPU is migrated to a
different pCPU and IBPB support is advertised to the guest, to ensure any
IBPBs performed by the guest are effective across pCPUs.  Ideally, KVM
would only emit IBPB if the guest performed an IBPB since the vCPU last
ran on the "new" pCPU, but pCPU migration is a relatively rare/slow path,
and so the cost of tracking which pCPUs a vCPUs has run on, let alone
intercepting PRED_CMD writes, outweighs the potential benefits of
avoiding IBPBs on pCPU migration.

E.g. if a single vCPU is bouncing between pCPUs A and B, and the guest is
doing IBPBs on context switches to mitigate cross-task attacks, then the
following scenario can occur and needs to be mitigated by KVM:

 1. vCPU starts on pCPU A.  It runs a userspace task (task #1) which
    installs various branch predictions into pCPU A's BTB.
 2. The vCPU is migrated to pCPU B.
 3. The guest switches to userspace task #2 and emits an IBPB, on pCPU B.
 4. The vCPU is migrated back to pCPU A.  Userspace task (task #2) in the
    guest now consumes the potentially dangerous branch predictions
    installed in step 1 from task #1.

Reported-by: David Kaplan <david.kaplan@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5ae655702b4..9d1641c2d83c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5201,6 +5201,19 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 	}
 
+	/*
+	 * If the vCPU is migrated to a different pCPU than the one on which
+	 * the vCPU last ran, and IBPB is advertised to the vCPU, then flush
+	 * indirect branch predictors before the next VM-Enter to ensure the
+	 * vCPU doesn't consume prediction information from a previous run on
+	 * the "new" pCPU.
+	 */
+	if (unlikely(vcpu->arch.last_vmentry_cpu != cpu &&
+		     vcpu->arch.last_vmentry_cpu >= 0) &&
+	    (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
+	     guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_IBPB)))
+		vcpu->arch.need_ibpb = true;
+
 	if (unlikely(vcpu->cpu != cpu) || kvm_check_tsc_unstable()) {
 		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
 				rdtsc() - vcpu->arch.last_host_tsc;
-- 
2.52.0.457.g6b5491de43-goog


