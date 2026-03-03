Return-Path: <kvm+bounces-72576-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QICMIag0p2k9fwAAu9opvQ
	(envelope-from <kvm+bounces-72576-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:21:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CBCD1F5E6B
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:21:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0EDD431AA0BF
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:16:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B61389100;
	Tue,  3 Mar 2026 19:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AGp0y7xq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154C33890E8;
	Tue,  3 Mar 2026 19:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772565351; cv=none; b=EgD9D6lPAZLwsVky+M9RMxc23lBJB6JIRva0xbeKKJsHlGfzmNKb9nJJFIA1xr+iKlidpwLJQXapjxE74oUkEIBNIoz+9tnohHbfk4WzHbInyXapPr53kS6ULT0Q2kUDXLd4YodpCL8Ujwe94nqt7m8EtYjnB7QcVRuxdmqQ6s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772565351; c=relaxed/simple;
	bh=h+RZPHkDN7k2bCi8/CQHjPnj5cNqgA18MTBWMKUgzrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8B2JPtnWaxyBaF+rXgwLsvtZh3XDW7LUTHkMaN9OqFDRks0pCxv73bL9DrAwD/kz8mCnpxd5YrvmK+i/T5XSEddPPZf3TuDvP2b3Xo9rTgns+LiAag5bjlWDt6aSa5k6IbWO6YgPx790I8wwIkFMlqVvEykJhw2bcpZSqlGbXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AGp0y7xq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3DBC4AF09;
	Tue,  3 Mar 2026 19:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772565351;
	bh=h+RZPHkDN7k2bCi8/CQHjPnj5cNqgA18MTBWMKUgzrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGp0y7xqmKtbR6KPfudBrXxzAEYolr8mefnGTNoNDJUU/KtcG9CitE8zmRaotLrge
	 N0Xc+DdVXEhPq4kILBlPdcsOPRhWw/0m2VcJqDfdDvJgMXrlyd67ShFSyNRv5/DtA6
	 DhHQstOLwUOOcPIF0GZgFVMWw/qpNjGLiAvKavSAhJ7rnFJYJY7b8ik3M3vPFLJ7sw
	 6xCSUwf5V/oXz5SAo6SU+HhERGP3l3FODqoZ9GU6hYFHcP98fIcRQxnmWm9bf0YV2O
	 vAoubkIM63IJCVnJs0UFiCoZ9bH2vdETeRidTP8URPcdBr4bvXTy4Oz8PYfgG8LG9T
	 newJMMV9Ab+GA==
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
Subject: [PATCH 3/5] crypto/ccp: export firmware supported vm types
Date: Tue,  3 Mar 2026 12:15:07 -0700
Message-ID: <20260303191509.1565629-4-tycho@kernel.org>
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
X-Rspamd-Queue-Id: 0CBCD1F5E6B
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
	TAGGED_FROM(0.00)[bounces-72576-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,amd.com:url]
X-Rspamd-Action: no action

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

In some configurations, the firmware does not support all VM types. Do an
SNP_VERIFY_MITIGATION to determine if the mitigation for CVE-2025-48514 is
active, and if so, turn off the SEV_ES bit.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 83 ++++++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      |  9 ++++
 2 files changed, 92 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9eba3fe1a27f..79610617a38d 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2930,3 +2930,86 @@ void sev_pci_exit(void)
 
 	sev_firmware_shutdown(sev);
 }
+
+static int snp_verify_mitigation(struct sev_device *sev, u64 vector, u64 *verified)
+{
+	struct sev_data_snp_verify_mitigation data = {0};
+	struct snp_verify_mitigation_dst *dst;
+	struct page *p;
+	int rc, error = 0;
+
+	if (!sev->snp_plat_status.feature_info ||
+	    !(sev->snp_feat_info_0.ecx & SNP_VERIFY_MITIGATION_SUPPORTED)) {
+		return -EOPNOTSUPP;
+	}
+
+	p = __snp_alloc_firmware_pages(GFP_KERNEL, 0, true);
+	if (!p)
+		return -ENOMEM;
+	dst = page_address(p);
+
+	data.length = sizeof(data);
+	data.subcommand = SNP_MIT_SUBCMD_REQ_VERIFY;
+	data.vector = vector;
+	data.dst_paddr_en = 1;
+	data.dst_paddr = __psp_pa(dst);
+
+	rc = sev_do_cmd(SEV_CMD_SNP_VERIFY_MITIGATION, &data, &error);
+	if (rc < 0) {
+		if (error)
+			dev_err(sev->dev, "VERIFY_MITIGATION error %d\n", error);
+		goto reclaim_pages;
+	}
+
+	rc = -EIO;
+	if (dst->mit_failure_status) {
+		dev_err(sev->dev, "VERIFY_MITIGATION failure status %d\n", dst->mit_failure_status);
+		goto reclaim_pages;
+	}
+
+	*verified = dst->mit_verified_vector;
+	rc = 0;
+
+reclaim_pages:
+	__snp_free_firmware_pages(p, 0, true);
+	return rc;
+}
+
+int sev_firmware_supported_vm_types(void)
+{
+	int rc, supported_vm_types = 0;
+	struct sev_device *sev;
+	u64 verified = 0;
+
+	if (!psp_master || !psp_master->sev_data)
+		return supported_vm_types;
+	sev = psp_master->sev_data;
+
+	supported_vm_types |= BIT(KVM_X86_SEV_VM);
+	supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
+
+	if (!sev->snp_initialized)
+		return supported_vm_types;
+
+	supported_vm_types |= BIT(KVM_X86_SNP_VM);
+
+	rc = snp_verify_mitigation(sev, SNP_MIT_VEC_CVE_2025_48514, &verified);
+	if (rc < 0) {
+		/*
+		 * Older firmware that doesn't support VERIFY_MITIGATION won't
+		 * have the mitigation for this CVE, so all types are supported.
+		 */
+		if (rc == -EOPNOTSUPP)
+			return supported_vm_types;
+		dev_err(sev->dev, "Unable to determine supported vm types: %d\n", rc);
+		return supported_vm_types;
+	}
+
+	/* This mitigation disables SEV-ES guests when present */
+	if (verified & SNP_MIT_VEC_CVE_2025_48514)
+		supported_vm_types &= ~BIT(KVM_X86_SEV_ES_VM);
+
+	return supported_vm_types;
+
+}
+EXPORT_SYMBOL_FOR_MODULES(sev_firmware_supported_vm_types, "kvm-amd");
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 2b4b56632b4e..07ce49b31ba2 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -611,6 +611,12 @@ struct sev_data_snp_verify_mitigation {
 #define SNP_MIT_SUBCMD_REQ_STATUS	0x0
 #define SNP_MIT_SUBCMD_REQ_VERIFY	0x1
 
+/*
+ * For CVE-2025-48514 defined in AMD-SB-3023
+ * https://www.amd.com/en/resources/product-security/bulletin/amd-sb-3023.html
+ */
+#define SNP_MIT_VEC_CVE_2025_48514		BIT(3)
+
 /**
  * struct snp_verify_mitigation_dst - mitigation result vectors
  *
@@ -1092,6 +1098,7 @@ void snp_free_firmware_page(void *addr);
 void sev_platform_shutdown(void);
 bool sev_is_snp_ciphertext_hiding_supported(void);
 u64 sev_get_snp_policy_bits(void);
+int sev_firmware_supported_vm_types(void);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -1135,6 +1142,8 @@ static inline void sev_platform_shutdown(void) { }
 
 static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
 
+static inline int sev_firmware_supported_vm_types(void) { return 0; }
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.53.0


