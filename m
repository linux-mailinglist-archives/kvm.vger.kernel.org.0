Return-Path: <kvm+bounces-72579-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QO49OUY0p2k9fwAAu9opvQ
	(envelope-from <kvm+bounces-72579-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:19:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 340D41F5DE4
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:19:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E929B3049ACD
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08DB38425B;
	Tue,  3 Mar 2026 19:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zs4O+trg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15A5384231;
	Tue,  3 Mar 2026 19:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772565356; cv=none; b=jBe+fqBlgdu7vOE7DcbmF52MEdBndmIANcJngcZPDQzNUT4jTVeeHSN3X/W7w2ZbEBoNy3yeU+WSpS5humkuIaUnFvo7GLn9sbSBiETea952wLtvPBjgUmOAjF3ypMNcmwqBrQ5I5DDG+ELiwV7sBNvJXpXSzoLnlZSd16wTVRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772565356; c=relaxed/simple;
	bh=tgcMP1DjiSuWdQdTXNizhC+/un3ZdmwWd5CjtmNWK04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjB0Rb/Jt5DZtAJUwuDT5IuZvTdNUrTnUA9blxoTV+FvLmc3HvAKjlWSBij2Eh2zOJaE/0EB5rBLPG/CY2jGe6S7JH3ulKShIWz6MgsVqe29g4Wl7Hq+bZeDKHLmJNFZGbOI7Uk3SJpMDfyG/Sp7oiIwHQ0J5NrFXmRaRTCUtFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zs4O+trg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EF6C2BCB0;
	Tue,  3 Mar 2026 19:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772565355;
	bh=tgcMP1DjiSuWdQdTXNizhC+/un3ZdmwWd5CjtmNWK04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zs4O+trggAO5+VjU3bcSHqykfHaMlyCqdUz0t73lLf9fwJPz1P4BCRJSm69JxTKoZ
	 T4HmVXGvhklGqZGsH/mzdXFwZNNONIyy9wP86jEPs5W/XQfnPR7O7i3QwsP+2uyjlV
	 1dtrxai1mgldJh+oCfw8PaO8EcIAGfqhyHRqoD1EXUZ19P8K+HM5VJVaim8zrWCSvq
	 uR4y6B961iZf4HGl3Zygib4nL17QQyl1pde4XLO4e0O7sb2dl+tRlEIoO/tsIxLBon
	 TqH7J51oND/UuWR6ohmGBd0Puh4Dhx7epJ+ry/XT4LJBarTnEov7oUk+0bT7eW2p16
	 FKd1pH6H3gokQ==
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
Subject: [PATCH 5/5] selftests/kvm: teach sev_*_test about revoking VM types
Date: Tue,  3 Mar 2026 12:15:09 -0700
Message-ID: <20260303191509.1565629-6-tycho@kernel.org>
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
X-Rspamd-Queue-Id: 340D41F5DE4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72579-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tycho@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

Instead of using CPUID, use the VM type bit to determine support, since
those now reflect the correct status of support by the kernel and firmware
configurations.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 tools/testing/selftests/kvm/x86/sev_init2_tests.c  | 14 ++++++--------
 .../testing/selftests/kvm/x86/sev_migrate_tests.c  |  2 +-
 tools/testing/selftests/kvm/x86/sev_smoke_test.c   |  4 ++--
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/sev_init2_tests.c b/tools/testing/selftests/kvm/x86/sev_init2_tests.c
index b238615196ad..97bd036b4f1c 100644
--- a/tools/testing/selftests/kvm/x86/sev_init2_tests.c
+++ b/tools/testing/selftests/kvm/x86/sev_init2_tests.c
@@ -136,16 +136,14 @@ int main(int argc, char *argv[])
 		    kvm_check_cap(KVM_CAP_VM_TYPES), 1 << KVM_X86_SEV_VM);
 
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SEV_VM));
-	have_sev_es = kvm_cpu_has(X86_FEATURE_SEV_ES);
+	have_sev_es = kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SEV_ES_VM);
 
-	TEST_ASSERT(have_sev_es == !!(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SEV_ES_VM)),
-		    "sev-es: KVM_CAP_VM_TYPES (%x) does not match cpuid (checking %x)",
-		    kvm_check_cap(KVM_CAP_VM_TYPES), 1 << KVM_X86_SEV_ES_VM);
+	TEST_ASSERT(!have_sev_es || kvm_cpu_has(X86_FEATURE_SEV_ES),
+		    "sev-es: SEV_ES_VM supported without SEV_ES in CPUID");
 
-	have_snp = kvm_cpu_has(X86_FEATURE_SEV_SNP);
-	TEST_ASSERT(have_snp == !!(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SNP_VM)),
-		    "sev-snp: KVM_CAP_VM_TYPES (%x) indicates SNP support (bit %d), but CPUID does not",
-		    kvm_check_cap(KVM_CAP_VM_TYPES), KVM_X86_SNP_VM);
+	have_snp = kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SNP_VM);
+	TEST_ASSERT(!have_snp || kvm_cpu_has(X86_FEATURE_SEV_SNP),
+		    "sev-snp: SNP_VM supported without SEV_SNP in CPUID");
 
 	test_vm_types();
 
diff --git a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
index 0a6dfba3905b..3f2c3b00e3bc 100644
--- a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
@@ -376,7 +376,7 @@ int main(int argc, char *argv[])
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));
 
-	have_sev_es = kvm_cpu_has(X86_FEATURE_SEV_ES);
+	have_sev_es = kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SEV_ES_VM);
 
 	if (kvm_has_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM)) {
 		test_sev_migrate_from(/* es= */ false);
diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index 86ad1c7d068f..16ec940de5ac 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -219,10 +219,10 @@ int main(int argc, char *argv[])
 
 	test_sev_smoke(guest_sev_code, KVM_X86_SEV_VM, 0);
 
-	if (kvm_cpu_has(X86_FEATURE_SEV_ES))
+	if (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SEV_ES_VM))
 		test_sev_smoke(guest_sev_es_code, KVM_X86_SEV_ES_VM, SEV_POLICY_ES);
 
-	if (kvm_cpu_has(X86_FEATURE_SEV_SNP))
+	if (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SNP_VM))
 		test_sev_smoke(guest_snp_code, KVM_X86_SNP_VM, snp_default_policy());
 
 	return 0;
-- 
2.53.0


