Return-Path: <kvm+bounces-69061-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wMQIIo35dWmwKAEAu9opvQ
	(envelope-from <kvm+bounces-69061-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 12:07:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CF88980268
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 12:07:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0D0033019BAD
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 11:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB84B319877;
	Sun, 25 Jan 2026 11:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b="LsIhEn4G"
X-Original-To: kvm@vger.kernel.org
Received: from mail.thorondor.fr (unknown [82.66.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FE1E55C;
	Sun, 25 Jan 2026 11:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.66.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769339222; cv=none; b=tWpt9ztRZ9cz9h9wt0qVJ6MuJwK0+Dg/M7GrUmNYUFB7K4glKHNd0HCdjsDxYgZlqM3PExKreuvKudvh/rhd5xA0T//lUuDcWJ7JNWc4fF7vk3kqfRV/YYWoHb+pFmZXCqHstq80jRZ/9p0ZEtuP3Ti7B0e/arDHE7DaJKyeBcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769339222; c=relaxed/simple;
	bh=hNYbYZde/EX3kkrznie2VHQIPWyYXPAvkCchlsCgE+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWGdPVTUPCuONV69+/swTl0CIcvncwG5JW+xsb8xZR9MWZOTnuBgnHrUN2VwPCu5AcgSoYY0pv+gtT/6nCOx3Ev9ubC8f3hJupJogA0SSgdOv7VojMe3EuZMX5gEm9qwJGIAhJHb228Jkfmk5MHLXaJb90SC9Y3otPmCGZ5TT5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr; spf=pass smtp.mailfrom=thorondor.fr; dkim=pass (2048-bit key) header.d=thorondor.fr header.i=@thorondor.fr header.b=LsIhEn4G; arc=none smtp.client-ip=82.66.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorondor.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thorondor.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=thorondor.fr; s=mail;
	t=1769339218; bh=hNYbYZde/EX3kkrznie2VHQIPWyYXPAvkCchlsCgE+k=;
	h=From:To:Cc:Subject:In-Reply-To:References;
	b=LsIhEn4GRZJS7Xhr+SSAnW9pfsMilj8CE+6QarTsd1oQAyftJguwmuA+wrj8Zvpo6
	 10CEMHue5lN43Dx/AwcGBIyE5Xgrb66NUopTe/wBNsw1l2WgSY44WvW/HV/QP18wCM
	 7UYdPBMRfDywIsum91cNhEXJGHOnK6/GEWlUyctCzcAMRYS5wSQo2DxaCnrHuiaBF0
	 Yyt4LNM853LeLH3jQXjcUkylqh6rkqlVDD9ivRMKwMPa3N4zV2tyoF0StiShODGxDp
	 uYdlnVWKfLHRqPx/aqy5maMfBa55GiMWLt2AQ1oxiB2vDQ4rwFCWH6r5FdkWmipaXB
	 hZXAv7EEJfIfQ==
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
Subject: [PATCH v5] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
Date: Sun, 25 Jan 2026 12:06:29 +0100
Message-ID: <20260125110629.43096-2-thomas.courrege@thorondor.fr>
In-Reply-To: <20260125110629.43096-1-thomas.courrege@thorondor.fr>
References: <20260125110629.43096-1-thomas.courrege@thorondor.fr>
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
	DMARC_POLICY_ALLOW(-0.50)[thorondor.fr,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[thorondor.fr:s=mail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69061-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.courrege@thorondor.fr,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[thorondor.fr:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CF88980268
X-Rspamd-Action: no action

Add support for retrieving the SEV-SNP attestation report via the
SNP_HV_REPORT_REQ firmware command and expose it through a new KVM
ioctl for SNP guests.

Signed-off-by: Thomas Courrege <thomas.courrege@thorondor.fr>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    | 28 +++++++++
 arch/x86/include/uapi/asm/kvm.h               |  9 +++
 arch/x86/kvm/svm/sev.c                        | 63 +++++++++++++++++++
 drivers/crypto/ccp/sev-dev.c                  |  1 +
 include/linux/psp-sev.h                       | 31 +++++++++
 5 files changed, 132 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 1ddb6a86ce7f..78b59c91f21c 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -572,6 +572,34 @@ Returns: 0 on success, -negative on error
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
index f59c65abe3cf..63026d254ab1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2261,6 +2261,66 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return rc;
 }
 
+static int sev_snp_hv_report_request(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
+	struct sev_data_snp_msg_report_rsp *report_rsp;
+	struct kvm_sev_snp_hv_report_req params;
+	struct sev_data_snp_hv_report_req data;
+	size_t rsp_size = sizeof(*report_rsp);
+	void __user *u_report;
+	void __user *u_params;
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	u_params = u64_to_user_ptr(argp->data);
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
+	data.rsvd = 0;
+
+	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_HV_REPORT_REQ, &data,
+			    &argp->error);
+	if (ret)
+		goto e_free_rsp;
+
+	if (!report_rsp->status) {
+		if (params.report_len < (rsp_size + report_rsp->report_size))
+			ret = -ENOSPC;
+		else
+			rsp_size += report_rsp->report_size;
+
+		params.report_len = sizeof(*report_rsp) + report_rsp->report_size;
+	}
+
+	if (copy_to_user(u_report, report_rsp, rsp_size))
+		ret = -EFAULT;
+
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
@@ -2672,6 +2732,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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

base-commit: e89f0e9a0a007e8c3afb8ecd739c0b3255422b00
-- 
2.52.0


