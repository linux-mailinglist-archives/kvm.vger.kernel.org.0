Return-Path: <kvm+bounces-71498-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eKp7Am6CnGnIIgQAu9opvQ
	(envelope-from <kvm+bounces-71498-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:38:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 652CA179EE4
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:38:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 741C330CE47F
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF1F9322749;
	Mon, 23 Feb 2026 16:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uc0hknJa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C4B31B81C;
	Mon, 23 Feb 2026 16:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771864286; cv=none; b=n0g7a6rr44XLcsliriCZaokw8eUfBNLZfMLTdZDD3BwNXBcbDmC15/lqTm/1eNhU7t8y1o/fF5/KjXV6dYNILfUiPYw4YfQ6e1MLKt+orYutB0WHrSgQQlqM4KehGu0iJz+TLqMKbUuNpP3hwTyy38skx5Rq49Bzz5hhMKoltLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771864286; c=relaxed/simple;
	bh=juj+8vO04jk/GoYa7dMPuG3nxfJTzUwEpk16BlfnOXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3c8W9IMmch6RozVIzRrU3JFY5FLvYqcJEuZz+CV/Gsn9meA/ppUjnEDFhyXK4eik2hCRXs42oR8O2QeaBIgBgoQQNzD39yPECr3ij05EX6fQVimtzLHamdBeety5Ti1i7EE+5xrs3I4/pcqQaCxBT4waGUQRdiTJ8HSiCg5eGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uc0hknJa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721A8C2BCB0;
	Mon, 23 Feb 2026 16:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771864285;
	bh=juj+8vO04jk/GoYa7dMPuG3nxfJTzUwEpk16BlfnOXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uc0hknJa/1TEhARErGWn/5YMJoqNsrFXQXWyshL8P1YFOeOh3NS/tlQeZQ6isR0Th
	 FedOCce3Znexb52j2gXDaiqFB7wzLYJ4pRCNdg11JYHFoTkeXveNSB+k0dKyv3/gKC
	 /fLs3R2ljsha1kChKQO9iTTr+1+uueH8k0DAgZkcmJSGZYfQJDQactbuT5zmhX2Q9k
	 PZhT6k5yWcRGu+upK8iJIcM9oFncuG1W4eBXy8fWr+UGrxDpNCHgnCWjATLqwzOebl
	 eE773GNC1491TZS0676tdS2lkmr5BY6VhmD7i78ZYk8ScQ16ROmmKNXZPrvehcBUiZ
	 cRy2rnJhdVFbg==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 4/4] selftests/kvm: smoke test support for RAPL_DIS
Date: Mon, 23 Feb 2026 09:29:00 -0700
Message-ID: <20260223162900.772669-5-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260223162900.772669-1-tycho@kernel.org>
References: <20260223162900.772669-1-tycho@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71498-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tycho@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 652CA179EE4
X-Rspamd-Action: no action

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

If the hardware supports the RAPL_DIS policy bit and the ccp has been
loaded with the RAPL_DIS bit set, make sure a VM can
actually start using it.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 tools/testing/selftests/kvm/include/x86/sev.h |  1 +
 .../selftests/kvm/x86/sev_smoke_test.c        | 24 ++++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86/sev.h b/tools/testing/selftests/kvm/include/x86/sev.h
index fd11f4222ec2..e9a566ff6df1 100644
--- a/tools/testing/selftests/kvm/include/x86/sev.h
+++ b/tools/testing/selftests/kvm/include/x86/sev.h
@@ -28,6 +28,7 @@ enum sev_guest_state {
 #define SNP_POLICY_SMT		(1ULL << 16)
 #define SNP_POLICY_RSVD_MBO	(1ULL << 17)
 #define SNP_POLICY_DBG		(1ULL << 19)
+#define SNP_POLICY_RAPL_DIS	(1ULL << 23)
 
 #define GHCB_MSR_TERM_REQ	0x100
 
diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index c7fda9fc324b..e4cf5b99b19a 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -248,6 +248,18 @@ static bool sev_es_allowed(void)
 	return supported;
 }
 
+static u64 supported_policy_mask(void)
+{
+	int kvm_fd = open_kvm_dev_path_or_exit();
+	u64 policy_mask = 0;
+
+	kvm_device_attr_get(kvm_fd, KVM_X86_GRP_SEV,
+			    KVM_X86_SNP_POLICY_BITS,
+			    &policy_mask);
+	close(kvm_fd);
+	return policy_mask;
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));
@@ -257,8 +269,18 @@ int main(int argc, char *argv[])
 	if (sev_es_allowed())
 		test_sev_smoke(guest_sev_es_code, KVM_X86_SEV_ES_VM, SEV_POLICY_ES);
 
-	if (kvm_cpu_has(X86_FEATURE_SEV_SNP))
+	if (kvm_cpu_has(X86_FEATURE_SEV_SNP)) {
+		int supported_policy = supported_policy_mask();
+
 		test_sev_smoke(guest_snp_code, KVM_X86_SNP_VM, snp_default_policy());
 
+		if (supported_policy & SNP_POLICY_RAPL_DIS &&
+		    kvm_get_module_param_bool("ccp", "rapl_disable")) {
+			uint32_t policy = snp_default_policy() | SNP_POLICY_RAPL_DIS;
+
+			test_sev_smoke(guest_snp_code, KVM_X86_SNP_VM, policy);
+		}
+	}
+
 	return 0;
 }
-- 
2.53.0


