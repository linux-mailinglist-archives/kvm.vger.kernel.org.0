Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E21B355F11
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 00:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344357AbhDFWu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 18:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344362AbhDFWuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 18:50:32 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC38C0613DC
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 15:50:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id t5so21699350ybc.18
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 15:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=E+tEX+0Keq6mEUZny7PGNfi9VWWcG1wSqQSbazqbJNw=;
        b=cr21xwVs3neHdR4cHfz97MMweJRQoNvKx8pkp5Zq/q6ySfbwkiZTsg/s7tceMXdOea
         F1LSILBTyEdWNHANoWluvfVFpcbCJYMne3S8+Bodm5Qhi8I5++jwsaLTJliqCh2j/XLy
         Nq1/HrIG/a9xH6GMf8P9PxLtcv7auW+eMljydMvcxdWLuBGjJz/xlLilF2xhnWNCtE5B
         ds89B3hXS6Ep1bWpE0MpWMkbFyIjPeNVMoSAr7SwJx+VNCaqZt7PPNaoHWiQYt1c3iF7
         OGXFPZyK0BnCn3M8TsAoMme7A6mK/ldrF2oCsd8Rr2XbJ6jpzA2XdJANwi9T8cJUD+mS
         lxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=E+tEX+0Keq6mEUZny7PGNfi9VWWcG1wSqQSbazqbJNw=;
        b=LR+squcOwgXKtFV0vDFOLWYJ6Q1D1gM+z1NR+DAPwqaBvkUgMAJ7llnWDctN+YDMSI
         8kwmtKd4zeD8zBGVV2a8wd5K7KKY+B+o1ruMX7yMUIThdAznVox+hlFepbUC/EDnmId2
         ciCB+75ih4yPDyGF9d9FKhb0RSCB8WIkVjaPCQS006cJDScBFAPv9koGiWOiyYS0cX/B
         lJQd7+vLSQZlvYOrTGPCTZe+9JAVKSeVHrZ6eVD29tSdhqoIKmkmLsW6SCX4wd3IXGgE
         mX+GWWkhi1+ciGLumb57wM8YTCLTn4k+X/XTaImzPKV0CKxpjq9Oe+lAExJsJOVLVFoh
         jvdA==
X-Gm-Message-State: AOAM5323crllKDbVa//g9IqQ2uSGSxV5hrPw6FQzSQ9IVdZjGhnEbWpC
        keHU9Z6JjrzW5V6Y1z+xdfoFaxUTv4o=
X-Google-Smtp-Source: ABdhPJwZ4qB3+J8/X6Al1I3ExKyMnJmu5X9FfJrLSycD89eha6Q0Ske+ByL0q666ov7j6tAMd7MhJfCUaeI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a1:90fb:182b:777c])
 (user=seanjc job=sendgmr) by 2002:a25:d211:: with SMTP id j17mr450284ybg.449.1617749422840;
 Tue, 06 Apr 2021 15:50:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Apr 2021 15:49:52 -0700
In-Reply-To: <20210406224952.4177376-1-seanjc@google.com>
Message-Id: <20210406224952.4177376-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210406224952.4177376-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 8/8] KVM: SVM: Allocate SEV command structures on local stack
From:   Sean Christopherson <seanjc@google.com>
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
        Borislav Petkov <bp@suse.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the local stack to "allocate" the structures used to communicate with
the PSP.  The largest struct used by KVM, sev_data_launch_secret, clocks
in at 52 bytes, well within the realm of reasonable stack usage.  The
smallest structs are a mere 4 bytes, i.e. the pointer for the allocation
is larger than the allocation itself.

Now that the PSP driver plays nice with vmalloc pointers, putting the
data on a virtually mapped stack (CONFIG_VMAP_STACK=y) will not cause
explosions.

Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 262 +++++++++++++++--------------------------
 1 file changed, 96 insertions(+), 166 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5457138c7347..316fd39c7aef 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -150,35 +150,22 @@ static void sev_asid_free(int asid)
 
 static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 {
-	struct sev_data_decommission *decommission;
-	struct sev_data_deactivate *data;
+	struct sev_data_decommission decommission;
+	struct sev_data_deactivate deactivate;
 
 	if (!handle)
 		return;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return;
-
-	/* deactivate handle */
-	data->handle = handle;
+	deactivate.handle = handle;
 
 	/* Guard DEACTIVATE against WBINVD/DF_FLUSH used in ASID recycling */
 	down_read(&sev_deactivate_lock);
-	sev_guest_deactivate(data, NULL);
+	sev_guest_deactivate(&deactivate, NULL);
 	up_read(&sev_deactivate_lock);
 
-	kfree(data);
-
-	decommission = kzalloc(sizeof(*decommission), GFP_KERNEL);
-	if (!decommission)
-		return;
-
 	/* decommission handle */
-	decommission->handle = handle;
-	sev_guest_decommission(decommission, NULL);
-
-	kfree(decommission);
+	decommission.handle = handle;
+	sev_guest_decommission(&decommission, NULL);
 }
 
 static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
@@ -216,19 +203,14 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
 {
-	struct sev_data_activate *data;
+	struct sev_data_activate activate;
 	int asid = sev_get_asid(kvm);
 	int ret;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
-	if (!data)
-		return -ENOMEM;
-
 	/* activate ASID on the given handle */
-	data->handle = handle;
-	data->asid   = asid;
-	ret = sev_guest_activate(data, error);
-	kfree(data);
+	activate.handle = handle;
+	activate.asid   = asid;
+	ret = sev_guest_activate(&activate, error);
 
 	return ret;
 }
@@ -258,7 +240,7 @@ static int sev_issue_cmd(struct kvm *kvm, int id, void *data, int *error)
 static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct sev_data_launch_start *start;
+	struct sev_data_launch_start start;
 	struct kvm_sev_launch_start params;
 	void *dh_blob, *session_blob;
 	int *error = &argp->error;
@@ -270,20 +252,16 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
 		return -EFAULT;
 
-	start = kzalloc(sizeof(*start), GFP_KERNEL_ACCOUNT);
-	if (!start)
-		return -ENOMEM;
+	memset(&start, 0, sizeof(start));
 
 	dh_blob = NULL;
 	if (params.dh_uaddr) {
 		dh_blob = psp_copy_user_blob(params.dh_uaddr, params.dh_len);
-		if (IS_ERR(dh_blob)) {
-			ret = PTR_ERR(dh_blob);
-			goto e_free;
-		}
+		if (IS_ERR(dh_blob))
+			return PTR_ERR(dh_blob);
 
-		start->dh_cert_address = __sme_set(__pa(dh_blob));
-		start->dh_cert_len = params.dh_len;
+		start.dh_cert_address = __sme_set(__pa(dh_blob));
+		start.dh_cert_len = params.dh_len;
 	}
 
 	session_blob = NULL;
@@ -294,40 +272,38 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 			goto e_free_dh;
 		}
 
-		start->session_address = __sme_set(__pa(session_blob));
-		start->session_len = params.session_len;
+		start.session_address = __sme_set(__pa(session_blob));
+		start.session_len = params.session_len;
 	}
 
-	start->handle = params.handle;
-	start->policy = params.policy;
+	start.handle = params.handle;
+	start.policy = params.policy;
 
 	/* create memory encryption context */
-	ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_LAUNCH_START, start, error);
+	ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_LAUNCH_START, &start, error);
 	if (ret)
 		goto e_free_session;
 
 	/* Bind ASID to this guest */
-	ret = sev_bind_asid(kvm, start->handle, error);
+	ret = sev_bind_asid(kvm, start.handle, error);
 	if (ret)
 		goto e_free_session;
 
 	/* return handle to userspace */
-	params.handle = start->handle;
+	params.handle = start.handle;
 	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params, sizeof(params))) {
-		sev_unbind_asid(kvm, start->handle);
+		sev_unbind_asid(kvm, start.handle);
 		ret = -EFAULT;
 		goto e_free_session;
 	}
 
-	sev->handle = start->handle;
+	sev->handle = start.handle;
 	sev->fd = argp->sev_fd;
 
 e_free_session:
 	kfree(session_blob);
 e_free_dh:
 	kfree(dh_blob);
-e_free:
-	kfree(start);
 	return ret;
 }
 
@@ -446,7 +422,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct kvm_sev_launch_update_data params;
-	struct sev_data_launch_update_data *data;
+	struct sev_data_launch_update_data data;
 	struct page **inpages;
 	int ret;
 
@@ -456,20 +432,14 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
 		return -EFAULT;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
-	if (!data)
-		return -ENOMEM;
-
 	vaddr = params.uaddr;
 	size = params.len;
 	vaddr_end = vaddr + size;
 
 	/* Lock the user memory. */
 	inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
-	if (IS_ERR(inpages)) {
-		ret = PTR_ERR(inpages);
-		goto e_free;
-	}
+	if (IS_ERR(inpages))
+		return PTR_ERR(inpages);
 
 	/*
 	 * Flush (on non-coherent CPUs) before LAUNCH_UPDATE encrypts pages in
@@ -477,6 +447,9 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	 */
 	sev_clflush_pages(inpages, npages);
 
+	data.reserved = 0;
+	data.handle = sev->handle;
+
 	for (i = 0; vaddr < vaddr_end; vaddr = next_vaddr, i += pages) {
 		int offset, len;
 
@@ -491,10 +464,9 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 		len = min_t(size_t, ((pages * PAGE_SIZE) - offset), size);
 
-		data->handle = sev->handle;
-		data->len = len;
-		data->address = __sme_page_pa(inpages[i]) + offset;
-		ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_DATA, data, &argp->error);
+		data.len = len;
+		data.address = __sme_page_pa(inpages[i]) + offset;
+		ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_DATA, &data, &argp->error);
 		if (ret)
 			goto e_unpin;
 
@@ -510,8 +482,6 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	}
 	/* unlock the user pages */
 	sev_unpin_memory(kvm, inpages, npages);
-e_free:
-	kfree(data);
 	return ret;
 }
 
@@ -563,16 +533,14 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct sev_data_launch_update_vmsa *vmsa;
+	struct sev_data_launch_update_vmsa vmsa;
 	struct kvm_vcpu *vcpu;
 	int i, ret;
 
 	if (!sev_es_guest(kvm))
 		return -ENOTTY;
 
-	vmsa = kzalloc(sizeof(*vmsa), GFP_KERNEL);
-	if (!vmsa)
-		return -ENOMEM;
+	vmsa.reserved = 0;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		struct vcpu_svm *svm = to_svm(vcpu);
@@ -580,7 +548,7 @@ static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		/* Perform some pre-encryption checks against the VMSA */
 		ret = sev_es_sync_vmsa(svm);
 		if (ret)
-			goto e_free;
+			return ret;
 
 		/*
 		 * The LAUNCH_UPDATE_VMSA command will perform in-place
@@ -590,27 +558,25 @@ static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		 */
 		clflush_cache_range(svm->vmsa, PAGE_SIZE);
 
-		vmsa->handle = sev->handle;
-		vmsa->address = __sme_pa(svm->vmsa);
-		vmsa->len = PAGE_SIZE;
-		ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, vmsa,
+		vmsa.handle = sev->handle;
+		vmsa.address = __sme_pa(svm->vmsa);
+		vmsa.len = PAGE_SIZE;
+		ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa,
 				    &argp->error);
 		if (ret)
-			goto e_free;
+			return ret;
 
 		svm->vcpu.arch.guest_state_protected = true;
 	}
 
-e_free:
-	kfree(vmsa);
-	return ret;
+	return 0;
 }
 
 static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	void __user *measure = (void __user *)(uintptr_t)argp->data;
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct sev_data_launch_measure *data;
+	struct sev_data_launch_measure data;
 	struct kvm_sev_launch_measure params;
 	void __user *p = NULL;
 	void *blob = NULL;
@@ -622,9 +588,7 @@ static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, measure, sizeof(params)))
 		return -EFAULT;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
-	if (!data)
-		return -ENOMEM;
+	memset(&data, 0, sizeof(data));
 
 	/* User wants to query the blob length */
 	if (!params.len)
@@ -632,23 +596,20 @@ static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	p = (void __user *)(uintptr_t)params.uaddr;
 	if (p) {
-		if (params.len > SEV_FW_BLOB_MAX_SIZE) {
-			ret = -EINVAL;
-			goto e_free;
-		}
+		if (params.len > SEV_FW_BLOB_MAX_SIZE)
+			return -EINVAL;
 
-		ret = -ENOMEM;
 		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
-			goto e_free;
+			return -ENOMEM;
 
-		data->address = __psp_pa(blob);
-		data->len = params.len;
+		data.address = __psp_pa(blob);
+		data.len = params.len;
 	}
 
 cmd:
-	data->handle = sev->handle;
-	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_MEASURE, data, &argp->error);
+	data.handle = sev->handle;
+	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_MEASURE, &data, &argp->error);
 
 	/*
 	 * If we query the session length, FW responded with expected data.
@@ -665,63 +626,50 @@ static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	}
 
 done:
-	params.len = data->len;
+	params.len = data.len;
 	if (copy_to_user(measure, &params, sizeof(params)))
 		ret = -EFAULT;
 e_free_blob:
 	kfree(blob);
-e_free:
-	kfree(data);
 	return ret;
 }
 
 static int sev_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct sev_data_launch_finish *data;
-	int ret;
+	struct sev_data_launch_finish data;
 
 	if (!sev_guest(kvm))
 		return -ENOTTY;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
-	if (!data)
-		return -ENOMEM;
-
-	data->handle = sev->handle;
-	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_FINISH, data, &argp->error);
-
-	kfree(data);
-	return ret;
+	data.handle = sev->handle;
+	return sev_issue_cmd(kvm, SEV_CMD_LAUNCH_FINISH, &data, &argp->error);
 }
 
 static int sev_guest_status(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct kvm_sev_guest_status params;
-	struct sev_data_guest_status *data;
+	struct sev_data_guest_status data;
 	int ret;
 
 	if (!sev_guest(kvm))
 		return -ENOTTY;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
-	if (!data)
-		return -ENOMEM;
+	memset(&data, 0, sizeof(data));
 
-	data->handle = sev->handle;
-	ret = sev_issue_cmd(kvm, SEV_CMD_GUEST_STATUS, data, &argp->error);
+	data.handle = sev->handle;
+	ret = sev_issue_cmd(kvm, SEV_CMD_GUEST_STATUS, &data, &argp->error);
 	if (ret)
-		goto e_free;
+		return ret;
 
-	params.policy = data->policy;
-	params.state = data->state;
-	params.handle = data->handle;
+	params.policy = data.policy;
+	params.state = data.state;
+	params.handle = data.handle;
 
 	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params, sizeof(params)))
 		ret = -EFAULT;
-e_free:
-	kfree(data);
+
 	return ret;
 }
 
@@ -730,23 +678,17 @@ static int __sev_issue_dbg_cmd(struct kvm *kvm, unsigned long src,
 			       int *error, bool enc)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct sev_data_dbg *data;
-	int ret;
+	struct sev_data_dbg data;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
-	if (!data)
-		return -ENOMEM;
+	data.reserved = 0;
+	data.handle = sev->handle;
+	data.dst_addr = dst;
+	data.src_addr = src;
+	data.len = size;
 
-	data->handle = sev->handle;
-	data->dst_addr = dst;
-	data->src_addr = src;
-	data->len = size;
-
-	ret = sev_issue_cmd(kvm,
-			    enc ? SEV_CMD_DBG_ENCRYPT : SEV_CMD_DBG_DECRYPT,
-			    data, error);
-	kfree(data);
-	return ret;
+	return sev_issue_cmd(kvm,
+			     enc ? SEV_CMD_DBG_ENCRYPT : SEV_CMD_DBG_DECRYPT,
+			     &data, error);
 }
 
 static int __sev_dbg_decrypt(struct kvm *kvm, unsigned long src_paddr,
@@ -966,7 +908,7 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct sev_data_launch_secret *data;
+	struct sev_data_launch_secret data;
 	struct kvm_sev_launch_secret params;
 	struct page **pages;
 	void *blob, *hdr;
@@ -998,41 +940,36 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_unpin_memory;
 	}
 
-	ret = -ENOMEM;
-	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
-	if (!data)
-		goto e_unpin_memory;
+	memset(&data, 0, sizeof(data));
 
 	offset = params.guest_uaddr & (PAGE_SIZE - 1);
-	data->guest_address = __sme_page_pa(pages[0]) + offset;
-	data->guest_len = params.guest_len;
+	data.guest_address = __sme_page_pa(pages[0]) + offset;
+	data.guest_len = params.guest_len;
 
 	blob = psp_copy_user_blob(params.trans_uaddr, params.trans_len);
 	if (IS_ERR(blob)) {
 		ret = PTR_ERR(blob);
-		goto e_free;
+		goto e_unpin_memory;
 	}
 
-	data->trans_address = __psp_pa(blob);
-	data->trans_len = params.trans_len;
+	data.trans_address = __psp_pa(blob);
+	data.trans_len = params.trans_len;
 
 	hdr = psp_copy_user_blob(params.hdr_uaddr, params.hdr_len);
 	if (IS_ERR(hdr)) {
 		ret = PTR_ERR(hdr);
 		goto e_free_blob;
 	}
-	data->hdr_address = __psp_pa(hdr);
-	data->hdr_len = params.hdr_len;
+	data.hdr_address = __psp_pa(hdr);
+	data.hdr_len = params.hdr_len;
 
-	data->handle = sev->handle;
-	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_SECRET, data, &argp->error);
+	data.handle = sev->handle;
+	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_SECRET, &data, &argp->error);
 
 	kfree(hdr);
 
 e_free_blob:
 	kfree(blob);
-e_free:
-	kfree(data);
 e_unpin_memory:
 	/* content of memory is updated, mark pages dirty */
 	for (i = 0; i < n; i++) {
@@ -1047,7 +984,7 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	void __user *report = (void __user *)(uintptr_t)argp->data;
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	struct sev_data_attestation_report *data;
+	struct sev_data_attestation_report data;
 	struct kvm_sev_attestation_report params;
 	void __user *p;
 	void *blob = NULL;
@@ -1059,9 +996,7 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
 		return -EFAULT;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
-	if (!data)
-		return -ENOMEM;
+	memset(&data, 0, sizeof(data));
 
 	/* User wants to query the blob length */
 	if (!params.len)
@@ -1069,23 +1004,20 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	p = (void __user *)(uintptr_t)params.uaddr;
 	if (p) {
-		if (params.len > SEV_FW_BLOB_MAX_SIZE) {
-			ret = -EINVAL;
-			goto e_free;
-		}
+		if (params.len > SEV_FW_BLOB_MAX_SIZE)
+			return -EINVAL;
 
-		ret = -ENOMEM;
 		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
-			goto e_free;
+			return -ENOMEM;
 
-		data->address = __psp_pa(blob);
-		data->len = params.len;
-		memcpy(data->mnonce, params.mnonce, sizeof(params.mnonce));
+		data.address = __psp_pa(blob);
+		data.len = params.len;
+		memcpy(data.mnonce, params.mnonce, sizeof(params.mnonce));
 	}
 cmd:
-	data->handle = sev->handle;
-	ret = sev_issue_cmd(kvm, SEV_CMD_ATTESTATION_REPORT, data, &argp->error);
+	data.handle = sev->handle;
+	ret = sev_issue_cmd(kvm, SEV_CMD_ATTESTATION_REPORT, &data, &argp->error);
 	/*
 	 * If we query the session length, FW responded with expected data.
 	 */
@@ -1101,13 +1033,11 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	}
 
 done:
-	params.len = data->len;
+	params.len = data.len;
 	if (copy_to_user(report, &params, sizeof(params)))
 		ret = -EFAULT;
 e_free_blob:
 	kfree(blob);
-e_free:
-	kfree(data);
 	return ret;
 }
 
-- 
2.31.0.208.g409f899ff0-goog

