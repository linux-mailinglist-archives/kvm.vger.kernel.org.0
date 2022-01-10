Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA88A488FF9
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 07:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238891AbiAJGFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 01:05:23 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:42379 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238912AbiAJGFQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 01:05:16 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=shirong@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0V1LvBNz_1641794698;
Received: from localhost.localdomain(mailfrom:shirong@linux.alibaba.com fp:SMTPD_---0V1LvBNz_1641794698)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 10 Jan 2022 14:05:11 +0800
From:   Shirong Hao <shirong@linux.alibaba.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.co, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        brijesh.singh@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        srutherford@google.com, ashish.kalra@amd.com, natet@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, zhang.jia@linux.alibaba.com,
        Shirong Hao <shirong@linux.alibaba.com>
Subject: [PATCH 3/3] crypto: ccp: Implement SEV_GET_REPORT ioctl command
Date:   Mon, 10 Jan 2022 14:04:45 +0800
Message-Id: <20220110060445.549800-4-shirong@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220110060445.549800-1-shirong@linux.alibaba.com>
References: <20220110060445.549800-1-shirong@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SEV_GET_REPORT command can be used by host service with guest
firmware handle to query the attestation report.

Signed-off-by: Shirong Hao <shirong@linux.alibaba.com>
---
 drivers/crypto/ccp/sev-dev.c | 20 +++++++++++++++++++-
 include/uapi/linux/psp-sev.h | 17 +++++++++++++++++
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2f6b81742d28..2e479b88aa29 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -414,7 +414,10 @@ int sev_do_get_report(void __user *report, struct kvm_sev_attestation_report *in
 	}
 cmd:
 	data.handle = handle;
-	ret = sev_issue_cmd_external_user(filep, SEV_CMD_ATTESTATION_REPORT, &data, error);
+	if (!filep)
+		ret = __sev_do_cmd_locked(SEV_CMD_ATTESTATION_REPORT, &data, error);
+	else
+		ret = sev_issue_cmd_external_user(filep, SEV_CMD_ATTESTATION_REPORT, &data, error);
 
 	/*
 	 * If we query the session length, FW responded with expected data.
@@ -440,6 +443,18 @@ int sev_do_get_report(void __user *report, struct kvm_sev_attestation_report *in
 }
 EXPORT_SYMBOL_GPL(sev_do_get_report);
 
+static int sev_ioctl_do_get_report(struct sev_issue_cmd *argp)
+{
+	void __user *report = (void __user *)(uintptr_t)argp->data;
+	struct sev_user_data_attestation_report input;
+
+	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
+		return -EFAULT;
+
+	return sev_do_get_report(report, (struct kvm_sev_attestation_report *)&input,
+				 NULL, input.handle, &argp->error);
+}
+
 static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -926,6 +941,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SEV_GET_ID2:
 		ret = sev_ioctl_do_get_id2(&input);
 		break;
+	case SEV_GET_REPORT:
+		ret = sev_ioctl_do_get_report(&input);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 91b4c63d5cbf..c7d70fc0ac1e 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -28,6 +28,7 @@ enum {
 	SEV_PEK_CERT_IMPORT,
 	SEV_GET_ID,	/* This command is deprecated, use SEV_GET_ID2 */
 	SEV_GET_ID2,
+	SEV_GET_REPORT,
 
 	SEV_MAX,
 };
@@ -147,6 +148,22 @@ struct sev_user_data_get_id2 {
 	__u32 length;				/* In/Out */
 } __packed;
 
+/**
+ * struct sev_user_data_attestation_report - ATTESTATION command parameters
+ *
+ * @mnonce: mnonce to compute HMAC
+ * @uaddr: physical address containing the attestation report
+ * @len: length of attestation report
+ * @handle: handle of the VM to process
+ */
+
+struct sev_user_data_attestation_report {
+	__u8 mnonce[16];			/* In */
+	__u64 uaddr;				/* In */
+	__u32 len;				/* In/Out */
+	__u32 handle;				/* In */
+};
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
-- 
2.27.0

