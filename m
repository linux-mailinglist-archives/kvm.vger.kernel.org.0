Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF883EDE9D
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 22:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhHPUZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 16:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbhHPUZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 16:25:28 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CD0C06179A
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 13:24:56 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s4-20020a259004000000b005947575ac53so3491477ybl.5
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 13:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ytVF9QeV+MabNTM9/rkDa+0RWrj8iBIydz2kXshJL00=;
        b=MMCS/5/YGI5geXZq2J1jLLt4Rr2E/2TX5tjz8gOWO9lYX2SX4ehLEGWEL0BCaiMiTp
         agNVxJJtqvBJqsZdRyUCH9xL+Rfm1Wgt2HIdnQxafkxtNdX5OzW9ELX1VQogolDw+fd0
         gIvB+lLgEI2cjdp8b+rYJpZwJUCx5ae4gVuC7AQUUmj3vpCUb4UKnaPEV9Y2RNn25Owb
         /AjWIrNM79gx2JDdilHM3oyRLrQYKhEvDvObLx/uOGTLnVaGjkG8A4nwex/jzuiCYmqm
         MOgG0JVtklTKjKOR4POYs4nxNuSbn3hZdj5DCTNApYKrx9cHamlBTvElapbzcVROu+AX
         +DRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ytVF9QeV+MabNTM9/rkDa+0RWrj8iBIydz2kXshJL00=;
        b=Vw5wmZjOOoh2Rhnw+qeIGEFjR/fKNLsIPv/qqGw43LA7uXBXarnAbd0M+GKJ9abmge
         w9zEqLoLdSzKQp/KVvQfxV5sVjq7WrYF68F5/a/arFGGZsWt27LPLa+og9Ul0EinafAn
         UPBwKadSze0qtSdXprxFfCmMCbnFGCi2k5LbRxSUF0BSWLIkslUM1weoveKkBklRz5Id
         DJ3T26Pj+GxIqjCClow5eqOF1tyksQDfQJtD/Y7SlCMGWv+UPsHMuKblFuLBLJXHSrE2
         IgpKREMjZRbWALvHCUeT4KY4LvSR77uPkYyHQQUMqjPq95y9mEx6dq6VuAhCX8TtKS/v
         bLIg==
X-Gm-Message-State: AOAM530cBgPBKBu0anE93Cy71U4ve0Tpyn745MGVjuZd2/ksQWcphGp6
        jZgn93uwtT0a04QmiRiZ3FbtKkWNF6Lv
X-Google-Smtp-Source: ABdhPJxRDg4XjAziDvXPV2YsT0AuxLyzM1Sc65DpyYo3GcMdJfwDr7nsBXBqr2yHD0PnwXA4/ipBmaPK8jv6
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a25:2155:: with SMTP id
 h82mr255114ybh.177.1629145495627; Mon, 16 Aug 2021 13:24:55 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 16 Aug 2021 20:24:41 +0000
In-Reply-To: <20210816202441.4098523-1-mizhang@google.com>
Message-Id: <20210816202441.4098523-4-mizhang@google.com>
Mime-Version: 1.0
References: <20210816202441.4098523-1-mizhang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 3/3] KVM: SVM: move sev_unbind_asid and DF_FLUSH logic into psp
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In KVM SEV code, sev_unbind_asid and sev_guest_df_flush needs to be
serialized because DEACTIVATE command in PSP may clear the WBINVD indicator
and cause DF_FLUSH to fail.

This is a PSP level detail that is not necessary to expose to KVM. So put
both functions as well as the RWSEM into the sev-dev.c.

Cc: Alper Gun <alpergun@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: David Rienjes <rientjes@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: Peter Gonda <pgonda@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vipin Sharma <vipinsh@google.com>

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/sev.c       | 35 +++--------------------------------
 drivers/crypto/ccp/sev-dev.c | 34 +++++++++++++++++++++++++++++++++-
 include/linux/psp-sev.h      | 19 ++++++++++++++++++-
 3 files changed, 54 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2a674acb22ce..ecf9da718d21 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -57,7 +57,6 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 #endif /* CONFIG_KVM_AMD_SEV */
 
 static u8 sev_enc_bit;
-static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
 unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
@@ -84,20 +83,9 @@ static int sev_flush_asids(int min_asid, int max_asid)
 	if (asid > max_asid)
 		return -EBUSY;
 
-	/*
-	 * DEACTIVATE will clear the WBINVD indicator causing DF_FLUSH to fail,
-	 * so it must be guarded.
-	 */
-	down_write(&sev_deactivate_lock);
-
-	wbinvd_on_all_cpus();
 	ret = sev_guest_df_flush(&error);
-
-	up_write(&sev_deactivate_lock);
-
 	if (ret)
 		pr_err("SEV: DF_FLUSH failed, ret=%d, error=%#x\n", ret, error);
-
 	return ret;
 }
 
@@ -198,23 +186,6 @@ static void sev_asid_free(struct kvm_sev_info *sev)
 	sev->misc_cg = NULL;
 }
 
-static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
-{
-	struct sev_data_deactivate deactivate;
-
-	if (!handle)
-		return;
-
-	deactivate.handle = handle;
-
-	/* Guard DEACTIVATE against WBINVD/DF_FLUSH used in ASID recycling */
-	down_read(&sev_deactivate_lock);
-	sev_guest_deactivate(&deactivate, NULL);
-	up_read(&sev_deactivate_lock);
-
-	sev_guest_decommission(handle, NULL);
-}
-
 static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -329,7 +300,7 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	/* return handle to userspace */
 	params.handle = start.handle;
 	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params, sizeof(params))) {
-		sev_unbind_asid(kvm, start.handle);
+		sev_guest_unbind_asid(start.handle);
 		ret = -EFAULT;
 		goto e_free_session;
 	}
@@ -1378,7 +1349,7 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_to_user((void __user *)(uintptr_t)argp->data,
 			 &params, sizeof(struct kvm_sev_receive_start))) {
 		ret = -EFAULT;
-		sev_unbind_asid(kvm, start.handle);
+		sev_guest_unbind_asid(start.handle);
 		goto e_free_session;
 	}
 
@@ -1789,7 +1760,7 @@ void sev_vm_destroy(struct kvm *kvm)
 
 	mutex_unlock(&kvm->lock);
 
-	sev_unbind_asid(kvm, sev->handle);
+	sev_guest_unbind_asid(sev->handle);
 	sev_asid_free(sev);
 }
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index ef58f007030e..7d53cd954f80 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -33,6 +33,7 @@
 #define SEV_FW_NAME_SIZE	64
 
 static DEFINE_MUTEX(sev_cmd_mutex);
+static DECLARE_RWSEM(sev_deactivate_lock);
 static struct sev_misc_dev *misc_dev;
 
 static int psp_cmd_timeout = 100;
@@ -932,10 +933,41 @@ EXPORT_SYMBOL_GPL(sev_guest_decommission);
 
 int sev_guest_df_flush(int *error)
 {
-	return sev_do_cmd(SEV_CMD_DF_FLUSH, NULL, error);
+	int ret;
+	/*
+	 * DEACTIVATE will clear the WBINVD indicator causing DF_FLUSH to fail,
+	 * so it must be guarded.
+	 */
+	down_write(&sev_deactivate_lock);
+
+	wbinvd_on_all_cpus();
+
+	ret = sev_do_cmd(SEV_CMD_DF_FLUSH, NULL, error);
+
+	up_write(&sev_deactivate_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(sev_guest_df_flush);
 
+void sev_guest_unbind_asid(unsigned int handle)
+{
+	struct sev_data_deactivate deactivate;
+
+	if (!handle)
+		return;
+
+	deactivate.handle = handle;
+
+	/* Guard DEACTIVATE against WBINVD/DF_FLUSH used in ASID recycling */
+	down_read(&sev_deactivate_lock);
+	sev_guest_deactivate(&deactivate, NULL);
+	up_read(&sev_deactivate_lock);
+
+	sev_guest_decommission(handle, NULL);
+}
+EXPORT_SYMBOL_GPL(sev_guest_unbind_asid);
+
 static void sev_exit(struct kref *ref)
 {
 	misc_deregister(&misc_dev->misc);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index be50446ff3f1..09447bce9665 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -580,6 +580,20 @@ int sev_issue_cmd_external_user(struct file *filep, unsigned int id,
  */
 int sev_guest_deactivate(struct sev_data_deactivate *data, int *error);
 
+/**
+ * sev_guest_unbind_asid - perform SEV DEACTIVATE command with lock held
+ *
+ * @handle: handle of the VM to deactivate
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int sev_guest_unbind_asid(unsigned int handle);
+
 /**
  * sev_guest_activate - perform SEV ACTIVATE command
  *
@@ -612,7 +626,7 @@ int sev_guest_activate(struct sev_data_activate *data, int *error);
 int sev_guest_bind_asid(int asid, unsigned int handle, int *error);
 
 /**
- * sev_guest_df_flush - perform SEV DF_FLUSH command
+ * sev_guest_df_flush - perform SEV DF_FLUSH command with lock held
  *
  * @sev_ret: sev command return code
  *
@@ -656,6 +670,9 @@ sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { return -ENO
 static inline int
 sev_guest_decommission(unsigned int handle, int *error) { return -ENODEV; }
 
+static inline int
+sev_guest_unbind_asid(unsigned int handle) { return -ENODEV; }
+
 static inline int
 sev_guest_activate(struct sev_data_activate *data, int *error) { return -ENODEV; }
 
-- 
2.33.0.rc1.237.g0d66db33f3-goog

