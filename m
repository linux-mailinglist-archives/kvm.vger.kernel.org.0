Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B63A3EDE99
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 22:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhHPUZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 16:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbhHPUZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 16:25:25 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6182DC0613CF
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 13:24:53 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 70-20020a370b49000000b003d2f5f0dcc6so4900901qkl.9
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 13:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=lAON/zCvnCQ9WkXsqWr7UdkpKpH6eowrQHHqKFOX8Ms=;
        b=ewJdYFg1tzZ1wizJlezLTaTYBT4aAtZdQcBb2uJlih9sqNHaFRZ8A3YzyMU+5ErrSC
         BcswvvEckSbQ2DChlC7FHMBSvlYETZGJi+e7GPs4mW6HvhG2+WW75B/VSvqxRfzqyMEI
         nwSScBipyqbyL7jwK2J+zIsprKJll7Qs1ha7ksb3Q5zZjLkp8e5+8m+btH9lgbBXbgXh
         b3bNhsiu8Z/gj2s0edL63ITQTAVqvoOdfD3KmZL7oo5zbX/hEyOttPr7vKgknPyAjSWX
         /1tE5NgbMZ4KoN/UpuUFzMc4owiAcgRCQDjk40X732mmggVhT6yh3lK51F1DEZb1vVLx
         hbIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=lAON/zCvnCQ9WkXsqWr7UdkpKpH6eowrQHHqKFOX8Ms=;
        b=sHJDHarKomW6SncpUo0QQ4sEOXdbAdPAD//Qx1xERDmCdEALII9asfCROZsWTBiDRt
         og8IJhYZiv1TVblLKM8S0T44cOPlPolF4yTtRlFsoHjPkb1Ed+VcyLB8sJIRm35GIfir
         wZ0qKrSYDOzI+RFwW0GcW2WiilTvGCHCpdoMUBW2Cv5lU3qzEkX6qRFck5qjCi4lRjwg
         hb3q6eIu2DmetUsjZ62ayctC+jy7iJLqWHkbSnCo6MzSExR+lWtt483h9AMcQUQfkM6R
         I7sGmU7RXjjKuGEP1cpYMZ9vVKMUL5j4MJc+AGhWv5Af/igWi1LSzfrtVQKgtVpk/Ose
         At1w==
X-Gm-Message-State: AOAM530x9KSbf3dWQMJmPnc3M04NQLEWRp1+ZjawVMJrphX4B7SXParX
        HDdQBqrxYI3GqF2m/ebszHc5VCNA9tvp
X-Google-Smtp-Source: ABdhPJwsPia8EyVr5Q9u/4hdukkWSxdyMw6btsqaOSIt+v09BBRasZ6Wx6zQVBgvGvlkSBUrpKSgogEo8y4t
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6214:1382:: with SMTP id
 g2mr610477qvz.14.1629145492552; Mon, 16 Aug 2021 13:24:52 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 16 Aug 2021 20:24:39 +0000
In-Reply-To: <20210816202441.4098523-1-mizhang@google.com>
Message-Id: <20210816202441.4098523-2-mizhang@google.com>
Mime-Version: 1.0
References: <20210816202441.4098523-1-mizhang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 1/3] KVM: SVM: move sev_decommission to psp driver
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

ccp/sev-dev.c is part of the software layer in psp that allows KVM to
manage SEV/ES/SNP enabled VMs. Among the APIs exposed in sev-dev, many of
them requires caller (KVM) to understand psp specific data structures. This
often ends up with the fact that KVM has to create its own 'wrapper' API to
make it easy to use. The following is the pattern:

kvm_func(unsigned int handle)
{
	psp_data_structure data;

	data.handle = handle;
	psp_func(&data, NULL);
}

psp_func(psp_data_structure *data, int *error)
{
	sev_do_cmd(data, error);
}

struct psp_data_structure {
	u32 handle;
};

sev_decommission is one example following the above pattern. Since KVM is
the only user for this API and 'handle' is the only data that is meaningful
to KVM, simplify the interface by putting the code from kvm function
sev_decommission into the psp function sev_guest_decomssion.

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

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/sev.c       | 15 ++-------------
 drivers/crypto/ccp/sev-dev.c |  8 +++++++-
 include/linux/psp-sev.h      |  7 ++++---
 3 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75e0b21ad07c..6a1faf28d973 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -198,17 +198,6 @@ static void sev_asid_free(struct kvm_sev_info *sev)
 	sev->misc_cg = NULL;
 }
 
-static void sev_decommission(unsigned int handle)
-{
-	struct sev_data_decommission decommission;
-
-	if (!handle)
-		return;
-
-	decommission.handle = handle;
-	sev_guest_decommission(&decommission, NULL);
-}
-
 static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 {
 	struct sev_data_deactivate deactivate;
@@ -223,7 +212,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 	sev_guest_deactivate(&deactivate, NULL);
 	up_read(&sev_deactivate_lock);
 
-	sev_decommission(handle);
+	sev_guest_decommission(handle, NULL);
 }
 
 static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
@@ -349,7 +338,7 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	/* Bind ASID to this guest */
 	ret = sev_bind_asid(kvm, start.handle, error);
 	if (ret) {
-		sev_decommission(start.handle);
+		sev_guest_decommission(start.handle, NULL);
 		goto e_free_session;
 	}
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 91808402e0bf..ab9c2c49d612 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -903,8 +903,14 @@ int sev_guest_activate(struct sev_data_activate *data, int *error)
 }
 EXPORT_SYMBOL_GPL(sev_guest_activate);
 
-int sev_guest_decommission(struct sev_data_decommission *data, int *error)
+int sev_guest_decommission(unsigned int handle, int *error)
 {
+	struct sev_data_decommission decommission;
+
+	if (!handle)
+		return -EINVAL;
+
+	decommission.handle = handle;
 	return sev_do_cmd(SEV_CMD_DECOMMISSION, data, error);
 }
 EXPORT_SYMBOL_GPL(sev_guest_decommission);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index d48a7192e881..6c0f2f451c89 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -612,17 +612,18 @@ int sev_guest_df_flush(int *error);
 /**
  * sev_guest_decommission - perform SEV DECOMMISSION command
  *
- * @decommission: sev_data_decommission structure to be processed
+ * @handle: sev_data_decommission structure to be processed
  * @sev_ret: sev command return code
  *
  * Returns:
  * 0 if the sev successfully processed the command
+ * -%EINVAL    if handle is NULL
  * -%ENODEV    if the sev device is not available
  * -%ENOTSUPP  if the sev does not support SEV
  * -%ETIMEDOUT if the sev command timed out
  * -%EIO       if the sev returned a non-zero return code
  */
-int sev_guest_decommission(struct sev_data_decommission *data, int *error);
+int sev_guest_decommission(unsigned int handle, int *error);
 
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 
@@ -637,7 +638,7 @@ static inline int
 sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { return -ENODEV; }
 
 static inline int
-sev_guest_decommission(struct sev_data_decommission *data, int *error) { return -ENODEV; }
+sev_guest_decommission(unsigned int handle, int *error) { return -ENODEV; }
 
 static inline int
 sev_guest_activate(struct sev_data_activate *data, int *error) { return -ENODEV; }
-- 
2.33.0.rc1.237.g0d66db33f3-goog

