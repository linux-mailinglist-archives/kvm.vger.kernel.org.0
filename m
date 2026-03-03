Return-Path: <kvm+bounces-72574-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kJS/DFU0p2k9fwAAu9opvQ
	(envelope-from <kvm+bounces-72574-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:19:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B9B81F5DFB
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:19:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B0AC830AF5A1
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FC434949E1;
	Tue,  3 Mar 2026 19:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PR0p3cqr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2B937269C;
	Tue,  3 Mar 2026 19:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772565346; cv=none; b=PUkbJblF01n2vWtHjOH8S6AjaUnlcoyA0kG4y5NWbzTmh61xm7/nPQD7Sp6OVWTMg/3kdjZaXV7hboH6eNZB1/gda7xVCx2Yl9i84ZPwDUO1ckyglGoliigEDSZCZCT24sVdIQ1G5mPj4uf6wpoS/fsR6RKg91cTv0bbGwMvfZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772565346; c=relaxed/simple;
	bh=2LwWEStgOMpN1MCabVmn8AN8B0Vf8KplhNGDz2nMxr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJohaut1Xyl76go2rpqrH5qslis5wmLuYIpttJn2jTTPGcTaN0P6r2H2Zy5pFiMEo/Ftu2rvOxESkyut6Yh0K3DoW3XzbkxwnRJzCWGPNDprgbXPoiqFiaYnc8Bq9Rbv14TI+beQnVyzXv5seaPDd5LtSgGMjNe9givWnRXdgi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PR0p3cqr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0ECC2BC87;
	Tue,  3 Mar 2026 19:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772565346;
	bh=2LwWEStgOMpN1MCabVmn8AN8B0Vf8KplhNGDz2nMxr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PR0p3cqrs8H4syyLUz9TAnt44RBhpcUahDlqSfBAaF/npZH9RoXbxByWgbBurVVAO
	 Uknz2s4SERnt8TxpsquEYv1HLzngNu/6Ift+TIVCBL1xEO2Y7QbG8KFYPAWPXpkgqX
	 +5YRj9Nj78PuxXAc+4qooVr6zln7rgl3TGkq/Fv1sMdjWnTXdrKDYImZqH9YwnYHZl
	 /da/ZSatmZLjSHOis43TUiBObU8Cco/Yxh2MqsOygzeChXRzbXpXB33hcnlUgNnWeZ
	 6HaoWT4AhN1YN0AAQUcFh8wZNzF9Kvi86nl71N5I1vjmiGpccVatbRxGUm03Z/Hqvb
	 uvOA1r+qYQHEA==
From: Tycho Andersen <tycho@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Shuah Khan <shuah@kernel.org>
Cc: Kim Phillips <kim.phillips@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 1/5] kvm/sev: don't expose unusable VM types
Date: Tue,  3 Mar 2026 12:15:05 -0700
Message-ID: <20260303191509.1565629-2-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260303191509.1565629-1-tycho@kernel.org>
References: <20260303191509.1565629-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8B9B81F5DFB
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
	TAGGED_FROM(0.00)[bounces-72574-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tycho@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

Commit 0aa6b90ef9d7 ("KVM: SVM: Add support for allowing zero SEV ASIDs")
made it possible to make it impossible to use SEV VMs by not allocating
them any ASIDs.

Commit 6c7c620585c6 ("KVM: SEV: Add SEV-SNP CipherTextHiding support") did
the same thing for SEV-ES.

Do not export KVM_X86_SEV(_ES)_VM as exported types if in either of these
situations, so that userspace can use them to determine what is actually
supported by the current kernel configuration.

Also move the buildup to a local variable so it is easier to add additional
masking in future patches.

Link: https://lore.kernel.org/all/aZyLIWtffvEnmtYh@google.com/
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3f9c1aa39a0a..f941d48626d3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2957,18 +2957,26 @@ void sev_vm_destroy(struct kvm *kvm)
 
 void __init sev_set_cpu_caps(void)
 {
+	int supported_vm_types = 0;
+
 	if (sev_enabled) {
 		kvm_cpu_cap_set(X86_FEATURE_SEV);
-		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_VM);
+
+		if (min_sev_asid <= max_sev_asid)
+			supported_vm_types |= BIT(KVM_X86_SEV_VM);
 	}
 	if (sev_es_enabled) {
 		kvm_cpu_cap_set(X86_FEATURE_SEV_ES);
-		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
+
+		if (min_sev_es_asid <= max_sev_es_asid)
+			supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
 	}
 	if (sev_snp_enabled) {
 		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
-		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
+		supported_vm_types |= BIT(KVM_X86_SNP_VM);
 	}
+
+	kvm_caps.supported_vm_types |= supported_vm_types;
 }
 
 static bool is_sev_snp_initialized(void)
-- 
2.53.0


