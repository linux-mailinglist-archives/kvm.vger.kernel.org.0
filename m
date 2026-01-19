Return-Path: <kvm+bounces-68523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A6585D3B37E
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 18:11:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5E66531B3C20
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 16:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F41BA3A1A42;
	Mon, 19 Jan 2026 16:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b="XMmufd0B"
X-Original-To: kvm@vger.kernel.org
Received: from mail.thorondor.fr (unknown [82.66.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1203803E2;
	Mon, 19 Jan 2026 16:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.66.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768840963; cv=none; b=FzXo149oNKByjU4EmIokp+2yIHUPhVH0rFEmfdMd5gatanCKiAQiWvK3rsUmIEYjB1gUpP45UAIm4QB6pO45lfNbLwPdV+6FMoS+77V3w8md+eVGhfOxCyB22jABJNQY1n1Rx67+2EBD0R2Man8g2QIjAx5PRmIYwXGjvJjk3wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768840963; c=relaxed/simple;
	bh=4rqFGZHNinZN6QODPORQOjo9IIVnqp2ut2fwotsVrZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljKgdIw/47fA3s7TxbDiYMkqNJ6wYeWAgv16nHtC8hGVApFvJjLaBnnY75ZBff/SgjNcc9f8aWE4g/5yRLHp3kqhNpTQp+oDdDqwipifDHWGCJN3fYmSvbECoZ8OYlu8a1o/nqoAW48PULhjMxJdoQmTwo0LWvvCmFzofgcBTqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr; spf=pass smtp.mailfrom=thorondor.fr; dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b=XMmufd0B; arc=none smtp.client-ip=82.66.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thorondor.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=thorondor.fr; s=mail;
	t=1768840954; bh=4rqFGZHNinZN6QODPORQOjo9IIVnqp2ut2fwotsVrZk=;
	h=From:To:Cc:Subject:In-Reply-To:References;
	b=XMmufd0B7pcLBHWEBNrfrnclK8o+Ndi39oMK1WGORpW+aj4EE1bhCTIysVjyUty1q
	 RsKP+zN0WgW6ErPR/KUYo6SPt1I1wr7irgtX2F1HXcWX03MHNSj7G9fR/3KlEau9VQ
	 MQ/MKXos/xMw9xGh0X2o/STqqb7x/Te4jjc90V6953ZbuKFpWkxi7QF6F9fbKmSoaB
	 B5f6WYE40+pu2pNxJj9jHmxE7QVocmCN0NTCp+Iqbn68RIemgagilxKsyVpcg+HnN/
	 037zDip9s8qOq3LuYeKP1RQ0wLpIsp+BM/weZQHE4ejKbF9K2hrVJQXfcFHrDlZoqf
	 nfZ0Tvs31GT4w==
From: Thomas Courrege <thomas.courrege@thorondor.fr>
To: ashish.kalra@amd.com,
	corbet@lwn.net,
	herbert@gondor.apana.org.au,
	john.allen@amd.com,
	nikunj@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	thomas.lendacky@amd.com
Cc: kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Thomas Courrege <thomas.courrege@thorondor.fr>
Subject: [PATCH v3 RESEND v3 1/1] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
Date: Mon, 19 Jan 2026 17:42:28 +0100
Message-ID: <20260119164228.2108498-2-thomas.courrege@thorondor.fr>
In-Reply-To: <20260119164228.2108498-1-thomas.courrege@thorondor.fr>
References: <20260119164228.2108498-1-thomas.courrege@thorondor.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for retrieving the SEV-SNP attestation report via the
SNP_HV_REPORT_REQ firmware command and expose it through a new KVM
ioctl for SNP guests.

Signed-off-by: Thomas Courrege <thomas.courrege@thorondor.fr>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    | 27 +++++++++
 arch/x86/include/uapi/asm/kvm.h               |  9 +++
 arch/x86/kvm/svm/sev.c                        | 60 +++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c                  |  1 +
 include/linux/psp-sev.h                       | 31 ++++++++++
 5 files changed, 128 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 1ddb6a86ce7f..083ed487764e 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -572,6 +572,33 @@ Returns: 0 on success, -negative on error
 See SNP_LAUNCH_FINISH in the SEV-SNP specification [snp-fw-abi]_ for further
 details on the input parameters in ``struct kvm_sev_snp_launch_finish``.
 
+21. KVM_SEV_SNP_HV_REPORT_REQ
+-----------------------------
+
+The KVM_SEV_SNP_HV_REPORT_REQ command requests the hypervisor-generated
+SNP attestation report. This report is produced by the PSP using the
+HV-SIGNED key selected by the caller.
+
+The ``key_sel`` field indicates which key the platform will use to sign the
+report:
+  * ``0``: If VLEK is installed, sign with VLEK. Otherwise, sign with VCEK.
+  * ``1``: Sign with VCEK.
+  * ``2``: Sign with VLEK.
+  * Other values are reserved.
+
+Parameters (in): struct kvm_sev_snp_hv_report_req
+
+Returns:  0 on success, -negative on error
+
+::
+        struct kvm_sev_snp_hv_report_req {
+                __u64 report_uaddr;
+                __u64 report_len;
+                __u8 key_sel;
+                __u8 pad0[7];
+                __u64 pad1[4];
+        };
+
 Device attribute API
 ====================
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7ceff6583652..464146bed784 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -743,6 +743,7 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_LAUNCH_START = 100,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
 	KVM_SEV_SNP_LAUNCH_FINISH,
+	KVM_SEV_SNP_HV_REPORT_REQ,
 
 	KVM_SEV_NR_MAX,
 };
@@ -871,6 +872,14 @@ struct kvm_sev_receive_update_data {
 	__u32 pad2;
 };
 
+struct kvm_sev_snp_hv_report_req {
+	__u64 report_uaddr;
+	__u64 report_len;
+	__u8 key_sel;
+	__u8 pad0[7];
+	__u64 pad1[4];
+};
+
 struct kvm_sev_snp_launch_start {
 	__u64 policy;
 	__u8 gosvw[16];
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..ba7a07d132ff 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2261,6 +2261,63 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return rc;
 }
 
+static int sev_snp_hv_report_request(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct sev_data_snp_msg_report_rsp *report_rsp = NULL;
+	struct sev_data_snp_hv_report_req data;
+	struct kvm_sev_snp_hv_report_req params;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
+	void __user *u_report;
+	void __user *u_params = u64_to_user_ptr(argp->data);
+	size_t rsp_size = sizeof(*report_rsp);
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+	if (copy_from_user(&params, u_params, sizeof(params)))
+		return -EFAULT;
+
+	if (params.report_len < rsp_size)
+		return -ENOSPC;
+
+	u_report = u64_to_user_ptr(params.report_uaddr);
+	if (!u_report)
+		return -EINVAL;
+
+	report_rsp = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!report_rsp)
+		return -ENOMEM;
+
+	data.len = sizeof(data);
+	data.key_sel = params.key_sel;
+	data.gctx_addr = __psp_pa(sev->snp_context);
+	data.hv_report_paddr = __psp_pa(report_rsp);
+
+	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_HV_REPORT_REQ, &data,
+				&argp->error);
+	if (ret)
+		goto e_free_rsp;
+
+	if (!report_rsp->status)
+		rsp_size += report_rsp->report_size;
+
+	if (params.report_len < rsp_size) {
+		rsp_size = sizeof(*report_rsp);
+		ret = -ENOSPC;
+	}
+
+	if (copy_to_user(u_report, report_rsp, rsp_size))
+		ret = -EFAULT;
+
+	params.report_len = sizeof(*report_rsp) + report_rsp->report_size;
+	if (copy_to_user(u_params, &params, sizeof(params)))
+		ret = -EFAULT;
+
+e_free_rsp:
+	snp_free_firmware_page(report_rsp);
+	return ret;
+}
+
 struct sev_gmem_populate_args {
 	__u8 type;
 	int sev_fd;
@@ -2672,6 +2729,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_FINISH:
 		r = snp_launch_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_HV_REPORT_REQ:
+		r = sev_snp_hv_report_request(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 956ea609d0cc..5dd7c3f0d50d 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -259,6 +259,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
 	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
 	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
+	case SEV_CMD_SNP_HV_REPORT_REQ:		return sizeof(struct sev_data_snp_hv_report_req);
 	default:				return sev_tio_cmd_buffer_len(cmd);
 	}
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 69ffa4b4d1fa..c651a400d124 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -124,6 +124,7 @@ enum sev_cmd {
 	SEV_CMD_SNP_GCTX_CREATE		= 0x093,
 	SEV_CMD_SNP_GUEST_REQUEST	= 0x094,
 	SEV_CMD_SNP_ACTIVATE_EX		= 0x095,
+	SEV_CMD_SNP_HV_REPORT_REQ	= 0x096,
 	SEV_CMD_SNP_LAUNCH_START	= 0x0A0,
 	SEV_CMD_SNP_LAUNCH_UPDATE	= 0x0A1,
 	SEV_CMD_SNP_LAUNCH_FINISH	= 0x0A2,
@@ -594,6 +595,36 @@ struct sev_data_attestation_report {
 	u32 len;				/* In/Out */
 } __packed;
 
+/**
+ * struct sev_data_snp_hv_report_req - SNP_HV_REPORT_REQ command params
+ *
+ * @len: length of the command buffer in bytes
+ * @key_sel: Selects which key to use for generating the signature.
+ * @gctx_addr: System physical address of guest context page
+ * @hv_report_paddr: System physical address where MSG_EXPORT_RSP will be written
+ */
+struct sev_data_snp_hv_report_req {
+	u32 len;		/* In */
+	u32 key_sel	:2,	/* In */
+	    rsvd	:30;
+	u64 gctx_addr;		/* In */
+	u64 hv_report_paddr;	/* In */
+} __packed;
+
+/**
+ * struct sev_data_snp_msg_export_rsp
+ *
+ * @status: Status : 0h: Success. 16h: Invalid parameters.
+ * @report_size: Size in bytes of the attestation report
+ * @report: attestation report
+ */
+struct sev_data_snp_msg_report_rsp {
+	u32 status;			/* Out */
+	u32 report_size;		/* Out */
+	u8 rsvd[24];
+	u8 report[];
+} __packed;
+
 /**
  * struct sev_data_snp_download_firmware - SNP_DOWNLOAD_FIRMWARE command params
  *
-- 
2.52.0


