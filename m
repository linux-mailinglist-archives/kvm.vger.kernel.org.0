Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F55488FF7
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 07:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbiAJGFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 01:05:15 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:57473 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238891AbiAJGFL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 01:05:11 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=shirong@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0V1LvBNz_1641794698;
Received: from localhost.localdomain(mailfrom:shirong@linux.alibaba.com fp:SMTPD_---0V1LvBNz_1641794698)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 10 Jan 2022 14:05:07 +0800
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
Subject: [PATCH 2/3] KVM/SVM: move the implementation of sev_get_attestation_report to ccp driver
Date:   Mon, 10 Jan 2022 14:04:44 +0800
Message-Id: <20220110060445.549800-3-shirong@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220110060445.549800-1-shirong@linux.alibaba.com>
References: <20220110060445.549800-1-shirong@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The sev_get_attestation_report is called by qemu-kvm to get sev
attestation report. However, getting the sev attestation report
is a general function, the need for host program to get the sev
attestation report by interacting with /dev/sev device exists.

Considering this need, it is more reasonable to move the main
implementation of sev_get_attestation_report into sev_do_get_report
defined in the ccp driver. Any host program getting the guest
firmware handle can directly interact with the sev device based
on sev_do_get_report to get the sev attestation report.

In addition, after moving the general code of sev_get_attestation_report
to the ccp, move the check for sev fd in __sev_issue_cmd to the
sev_get_attestation_report function is necessary.

Signed-off-by: Shirong Hao <shirong@linux.alibaba.com>
---
 arch/x86/kvm/svm/sev.c       | 49 ++++---------------------------
 drivers/crypto/ccp/sev-dev.c | 56 ++++++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      |  7 +++++
 3 files changed, 69 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7656a2c5662a..016acc96c5dc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1066,10 +1066,8 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	void __user *report = (void __user *)(uintptr_t)argp->data;
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct sev_data_attestation_report data;
 	struct kvm_sev_attestation_report params;
-	void __user *p;
-	void *blob = NULL;
+	struct fd f;
 	int ret;
 
 	if (!sev_guest(kvm))
@@ -1078,48 +1076,13 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
 		return -EFAULT;
 
-	memset(&data, 0, sizeof(data));
-
-	/* User wants to query the blob length */
-	if (!params.len)
-		goto cmd;
-
-	p = (void __user *)(uintptr_t)params.uaddr;
-	if (p) {
-		if (params.len > SEV_FW_BLOB_MAX_SIZE)
-			return -EINVAL;
-
-		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
-		if (!blob)
-			return -ENOMEM;
-
-		data.address = __psp_pa(blob);
-		data.len = params.len;
-		memcpy(data.mnonce, params.mnonce, sizeof(params.mnonce));
-	}
-cmd:
-	data.handle = sev->handle;
-	ret = sev_issue_cmd(kvm, SEV_CMD_ATTESTATION_REPORT, &data, &argp->error);
-	/*
-	 * If we query the session length, FW responded with expected data.
-	 */
-	if (!params.len)
-		goto done;
-
-	if (ret)
-		goto e_free_blob;
+	f = fdget(sev->fd);
+	if (!f.file)
+		return -EBADF;
 
-	if (blob) {
-		if (copy_to_user(p, blob, params.len))
-			ret = -EFAULT;
-	}
+	ret = sev_do_get_report(report, &params, f.file, sev->handle, &argp->error);
 
-done:
-	params.len = data.len;
-	if (copy_to_user(report, &params, sizeof(params)))
-		ret = -EFAULT;
-e_free_blob:
-	kfree(blob);
+	fdput(f);
 	return ret;
 }
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e09925d86bf3..2f6b81742d28 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -22,6 +22,7 @@
 #include <linux/firmware.h>
 #include <linux/gfp.h>
 #include <linux/cpufeature.h>
+#include <linux/kvm.h>
 
 #include <asm/smp.h>
 
@@ -384,6 +385,61 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
 	return ret;
 }
 
+int sev_do_get_report(void __user *report, struct kvm_sev_attestation_report *input,
+		      struct file *filep, u32 handle, u32 *error)
+{
+	struct sev_data_attestation_report data;
+	void __user *p;
+	void *blob = NULL;
+	int ret;
+
+	memset(&data, 0, sizeof(data));
+
+	/* User wants to query the blob length */
+	if (!input->len)
+		goto cmd;
+
+	p = (void __user *)(uintptr_t)input->uaddr;
+	if (p) {
+		if (input->len > SEV_FW_BLOB_MAX_SIZE)
+			return -EINVAL;
+
+		blob = kmalloc(input->len, GFP_KERNEL_ACCOUNT);
+		if (!blob)
+			return -ENOMEM;
+
+		data.address = __psp_pa(blob);
+		data.len = input->len;
+		memcpy(data.mnonce, input->mnonce, sizeof(input->mnonce));
+	}
+cmd:
+	data.handle = handle;
+	ret = sev_issue_cmd_external_user(filep, SEV_CMD_ATTESTATION_REPORT, &data, error);
+
+	/*
+	 * If we query the session length, FW responded with expected data.
+	 */
+	if (!input->len)
+		goto done;
+
+	if (ret)
+		goto e_free_blob;
+
+	if (blob) {
+		if (copy_to_user(p, blob, input->len))
+			ret = -EFAULT;
+	}
+
+done:
+	input->len = data.len;
+	if (copy_to_user(report, input, sizeof(*input)))
+		ret = -EFAULT;
+e_free_blob:
+	kfree(blob);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sev_do_get_report);
+
 static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index d48a7192e881..0cbf39a7d116 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -541,6 +541,9 @@ int sev_platform_init(int *error);
  */
 int sev_platform_status(struct sev_user_data_status *status, int *error);
 
+int sev_do_get_report(void __user *report, struct kvm_sev_attestation_report *input,
+		      struct file *filep, u32 handle, u32 *error);
+
 /**
  * sev_issue_cmd_external_user - issue SEV command by other driver with a file
  * handle.
@@ -649,6 +652,10 @@ sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int
 
 static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_PTR(-EINVAL); }
 
+static inline int
+sev_do_get_report(void __user *report, struct kvm_sev_attestation_report *input,
+		  struct file *filep, u32 handle, u32 *error) { return -ENODEV; }
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.27.0

