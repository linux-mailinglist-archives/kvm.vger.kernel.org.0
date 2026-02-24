Return-Path: <kvm+bounces-71710-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WE/7L2EsnmmkTwQAu9opvQ
	(envelope-from <kvm+bounces-71710-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:55:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DAC418DE43
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:55:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 51B22314AB08
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B94AB34EF12;
	Tue, 24 Feb 2026 22:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+sM/rec"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E476B34DB60;
	Tue, 24 Feb 2026 22:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771973428; cv=none; b=cduAmn20G4FSLhrTfSiKeZWVusN78dOVnbdE36VirG0rAAcTUye9VNtUvm3SGVugZYoXcAtzos6ZXNsMYyaNBvKuuoIHveL5yAvofUkwlYPdbzC6Zz3oplJlIpGqplTgD9ns3dZM8m7BBV6uwCAjy/n1+EYW0Fq4TC6BPYq63MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771973428; c=relaxed/simple;
	bh=ggf02o+1BEEp+mtG1llL7HH/O1Y6wBhPLia21wJcg6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tANS3lPOfJRIIxkJYWhDQb1LNohQ8G59dYjKZeaoVydEJS3qk4d/zRI/D74/9jm1+8NgwnsyND4HNpMFK0GXMKOr8jikZyyPXIgRUaCNKYj+7iqs9RkTPzRYOAGPE20JBk7jEBOuSvNuH+e28N6QxdSApkyzVR8ROoatj0fgG/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+sM/rec; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373CCC19423;
	Tue, 24 Feb 2026 22:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771973427;
	bh=ggf02o+1BEEp+mtG1llL7HH/O1Y6wBhPLia21wJcg6Y=;
	h=From:To:Cc:Subject:Date:From;
	b=T+sM/recuVnjx69He5RiMjDlxqWtkqs5/HdE8QmCblqDY1bbA+IFm9Yp6IYfbtOdB
	 H1oS2WL/uoCAgFp3JGIN97UDk+FvYjMDNWJzxUEAgpryCQwxNWKdIiGPTFuw8npTWb
	 F2tCQcApI6vttuQyf4VEIl0UU6s91Evi86RrysSlH2WjrvDR1g+fKD7OWNsyBNKPVf
	 P8o1DMFR+vMV7LbeNI7c/HNu1sJN5qtfg9S7K+9W2RpdDRwpWnn1e+i7tedz3TBplQ
	 MoovKkentXwRxnH5lLRnPMVW6EdzgcUbdUfhfqgOomdIK8pkBPKl8DXkvh6PJ0Lfrh
	 dDaOWelJx6ECw==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: nSVM: Ensure AVIC is inhibited when restoring a vCPU to guest mode
Date: Tue, 24 Feb 2026 22:50:17 +0000
Message-ID: <20260224225017.3303870-1-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
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
	TAGGED_FROM(0.00)[bounces-71710-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1DAC418DE43
X-Rspamd-Action: no action

On nested VMRUN, KVM ensures AVIC is inhibited by requesting
KVM_REQ_APICV_UPDATE, triggering a check of inhibit reasons, finding
APICV_INHIBIT_REASON_NESTED, and disabling AVIC.

However, when KVM_SET_NESTED_STATE is performed on a vCPU not in guest
mode with AVIC enabled, KVM_REQ_APICV_UPDATE is not requested, and AVIC
is not inhibited.

Request KVM_REQ_APICV_UPDATE in the KVM_SET_NESTED_STATE path if AVIC is
active, similar to the nested VMRUN path.

Fixes: f44509f849fe ("KVM: x86: SVM: allow AVIC to co-exist with a nested guest running")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---

After the dust settles from all the inflight changes touching this area,
we really need to reuse enter_svm_guest_mode() in svm_set_nested_state()
imo. There are a few differences that will need to be addressed:

1. nested_vmcb02_prepare_save() needs to be skipped.

2. nested_svm_copy_common_state() may need to be skipped (or honestly,
just folded into nested_vmcb02_prepare_save()?).

2. The CR3 value passed to nested_svm_load_cr3() needs to change.

3. Need to check if calling nested_svm_hv_update_vm_vp_ids() is
okay/needed (might be another bug actually).

I think mostly likely we'll pass a boolean arg to
enter_svm_guest_mode(), something like use_cached_save, and key 1 to 3
off of it. I don't like it (smells like from_vmrun), but it's the
simplest way to avoid bugs like this in the future.

---
 arch/x86/kvm/svm/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index de90b104a0dd5..82e512631e514 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1922,6 +1922,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	svm->nested.force_msr_bitmap_recalc = true;
 
+	if (kvm_vcpu_apicv_active(vcpu))
+		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+
 	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 	ret = 0;
 out_free:
-- 
2.53.0.414.gf7e9f6c205-goog


