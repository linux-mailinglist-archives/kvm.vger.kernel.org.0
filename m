Return-Path: <kvm+bounces-71588-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id jDi6GDNRnWkoOgQAu9opvQ
	(envelope-from <kvm+bounces-71588-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:20:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D13A7182EC9
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:20:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 09058303479A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 07:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55F74364049;
	Tue, 24 Feb 2026 07:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FN94f1aq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDAC36405D
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 07:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771917516; cv=none; b=t0XCNLWVUcccyPLmi36gxGAxL5Y1Lbf07f3DUz2sYjk0y1tBsyZo2Ud6wSJmsgQYaxQdm9lY+3iXbYyMENYtLPwEkIJMjelmh2K+1ttqasfRNn9W9VlmrpaGkUkhCFun5hzkXJpVOKMonmSfmqSnm4VACUSR+m6dek56AZvGRCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771917516; c=relaxed/simple;
	bh=p+/JXIHe+Eju4TiZ6IHv5BpGFugMUeIkVHKHy0fA2/4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pApzvcgdW+Gl57bRokkos4BdZRrv/kGtmLb89UhGLQ0/RW9qxnqxolOn+/rvA50BFA4nXVXv4XWYTxJmYUZuGkERGMITjmBD9lihJ+PuWxGA0gHP5fBk6QRRm1umkqAmXMMl964rXT+IK8+AnFIXpMEvjLNE/cT/ZsDAMCfVJmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FN94f1aq; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-824a2df507eso22184246b3a.2
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 23:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771917510; x=1772522310; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UKYOfVtFaaNnohSAhtPG8hERqqL1dIuBDlAEuZIErIM=;
        b=FN94f1aqDrh8f2x5HgxOwYSPtcVlqHgqmWrF3lfL9fisIGtm4Oa8POouXrzCWhrV+c
         8V1GJvq7B6C/SsJesAAhdfV7LpEIbPQ4abM1yqSbb2jxGTICqd4nAiN+ZxMhHnZzSvOZ
         9+hid4fZaB7Rg3+bWk4pwGjV28Y26ITAXgrNSkJAPmwfeBgqnNjSqSW4VNGB5scx927+
         DgVRIOdd9JE0VvVgSZu0CG+b3gafBNP/7xAZlQMfwA4tx2cwPrnWDCAGW5Tom9SkpP/5
         z2UiRDQ16xugNO5dG3d1xObYkPmcRo+0CH5QK+xY+D8Iz9H3sZ991tDaR/8tBfN0qesy
         2D8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771917510; x=1772522310;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UKYOfVtFaaNnohSAhtPG8hERqqL1dIuBDlAEuZIErIM=;
        b=qKibS2HtAOFGD2FpS0b2OvRjnsdvId+LHsW5+sJAlMQTkTVjO4oZE5moqvkNf6X7fT
         eYwmdAJtbScxiguA9NtPC7tdAzt8/hxxm5CtxE9Rj7MzthwoUiOpPLkrR2vaV9xWk8WP
         Riz+DRzgkWmsvzhpEJRQY+sEVunSP+R7pzdOQGdkGpjqpjm2xr4EfOl9LwLtcBD6JATq
         17GIzyNu0JKmCtljL+P5H2LYI8A+hGkB9SHNePvQ23kr48PHRiOAbIDR1fK+jtD/PKfh
         tTGD3DIzeu8a/Wy88zhmy4eO2zag4hb0d66EOsizFvi26doMsi7cohm7i9FhAMf4rgql
         O7bA==
X-Gm-Message-State: AOJu0YxwDRFDB3czC67+5KGDkbNlQz24T5ed+QexkDDbNkQju5KOneQ7
	8lofyObgGTJ3YO/Amd/QSXJAwPp9MlDAU+BPT0jpFOcBi8+lsLsidp3YPQ7/boz/unnpr7rI9L8
	LWKuEqlr/Tyr2mw==
X-Received: from pfbbe20.prod.google.com ([2002:a05:6a00:1f14:b0:824:ce77:6430])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1813:b0:823:edd:20b9 with SMTP id d2e1a72fcca58-826daaa6ee3mr10406235b3a.61.1771917510282;
 Mon, 23 Feb 2026 23:18:30 -0800 (PST)
Date: Tue, 24 Feb 2026 07:18:21 +0000
In-Reply-To: <20260224071822.369326-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224071822.369326-1-chengkev@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260224071822.369326-4-chengkev@google.com>
Subject: [PATCH V2 3/4] KVM: VMX: Don't consult original exit qualification
 for nested EPT violation injection
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71588-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D13A7182EC9
X-Rspamd-Action: no action

Remove the OR of EPT_VIOLATION_GVA_IS_VALID and
EPT_VIOLATION_GVA_TRANSLATED from the hardware exit qualification when
injecting a synthesized EPT violation to L1. The hardware exit
qualification reflects the original VM exit, which may not be an EPT
violation at all, e.g. if KVM is emulating an I/O instruction and the
memory operand's translation through L1's EPT fails. In that case, bits
7-8 of the exit qualification have completely different semantics (or
are simply zero), and OR'ing them into the injected EPT violation
corrupts the GVA_IS_VALID/GVA_TRANSLATED information.

Even when the original exit is an EPT violation, the hardware bits may
not match the current fault. For example, if an EPT violation happened
while walking L2's page tables, it's possible that the EPT violation
injected by KVM into L1 is for the final address translation, if L1
already had the mappings for L2's page tables in its EPTs but KVM did
not have shadow EPTs for them.

Populate EPT_VIOLATION_GVA_IS_VALID and EPT_VIOLATION_GVA_TRANSLATED
directly in the page table walker at the kvm_translate_gpa() failure
sites, mirroring the existing PFERR_GUEST_PAGE_MASK and
PFERR_GUEST_FINAL_MASK population for NPT.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 16 +++++++++++++++-
 arch/x86/kvm/vmx/nested.c      |  3 ---
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f148c92b606ba..a084b5e50effc 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -386,8 +386,19 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 					     nested_access, &walker->fault);
 
 		if (unlikely(real_gpa == INVALID_GPA)) {
+			/*
+			 * Unconditionally set the NPF error_code bits and
+			 * EPT exit_qualification bits for nested page
+			 * faults.  The walker doesn't know whether L1 uses
+			 * NPT or EPT, and each injection handler consumes
+			 * only the field it cares about (error_code for
+			 * NPF, exit_qualification for EPT violations), so
+			 * setting both is harmless.
+			 */
 #if PTTYPE != PTTYPE_EPT
 			walker->fault.error_code |= PFERR_GUEST_PAGE_MASK;
+			walker->fault.exit_qualification |=
+				EPT_VIOLATION_GVA_IS_VALID;
 #endif
 			return 0;
 		}
@@ -449,6 +460,9 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	if (real_gpa == INVALID_GPA) {
 #if PTTYPE != PTTYPE_EPT
 		walker->fault.error_code |= PFERR_GUEST_FINAL_MASK;
+		walker->fault.exit_qualification |=
+			EPT_VIOLATION_GVA_IS_VALID |
+			EPT_VIOLATION_GVA_TRANSLATED;
 #endif
 		return 0;
 	}
@@ -496,7 +510,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	 * [2:0] - Derive from the access bits. The exit_qualification might be
 	 *         out of date if it is serving an EPT misconfiguration.
 	 * [5:3] - Calculated by the page walk of the guest EPT page tables
-	 * [7:8] - Derived from [7:8] of real exit_qualification
+	 * [7:8] - Set at the kvm_translate_gpa() call sites above
 	 *
 	 * The other bits are set to 0.
 	 */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 248635da67661..6a167b1d51595 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -444,9 +444,6 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 			exit_qualification = 0;
 		} else {
 			exit_qualification = fault->exit_qualification;
-			exit_qualification |= vmx_get_exit_qual(vcpu) &
-					      (EPT_VIOLATION_GVA_IS_VALID |
-					       EPT_VIOLATION_GVA_TRANSLATED);
 			vm_exit_reason = EXIT_REASON_EPT_VIOLATION;
 		}
 
-- 
2.53.0.414.gf7e9f6c205-goog


