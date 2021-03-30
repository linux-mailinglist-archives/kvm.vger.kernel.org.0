Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F326934E04D
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 06:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhC3Emq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 00:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhC3EmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 00:42:23 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9043C061762
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 21:42:22 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id z1so5151515plg.14
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 21:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CIy5ACCF0ofpwh9zYe0S73BRRk0v0OISzt23gHBSsNA=;
        b=tx1gG07Ck0mnE68/XTiNe7DMvwTmOjF63Ee6rvYBpVtmUo1jx0zb+lJOqCOsnt1hXe
         bELVj5fbj0lz7PS2TONyKBpXYIg+feIwlb2VQCl1bb726ea+kHs6yTAp4a/TBF1k5cNh
         WQ7JT51oLru86QmE3Bug1CsPCNupA0AQxQOQpqcQ70fD/3FS6gFl8U/KXywKfbykWixr
         FLW0fgOQNvjlRhnIMpfTgmDUmGu+0C64hBYrbb0iuGPxZ/r0bhCzaVMdH0iuouV3fY5z
         CRrv0gWHJDdl+0FnWRe3z8iJedXnrjVHTw6g8/yhbA4D/qPiBYGRKtuMsiyj56DxIK4s
         rCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CIy5ACCF0ofpwh9zYe0S73BRRk0v0OISzt23gHBSsNA=;
        b=e2xR/EZFILezGMdzYGPzR4uPn+jHRCgz2Tw0wph5Z0zV5wdwJ+7VQ/IUomlshZQNdn
         LsCBb6dLpGqPRmS6sSJ0PJWf7P48+7pN8N36l3YZMPiIlKYV7vwLIB2vuAJXCMNZrZDq
         8Wld2f5Dz4wBluiVUTGDRcsmtR2otuNKh91SbvwZBqcuk7VChW8UeUs1I9bT4SEIKNm2
         3VPDVA8Cmb/Lhm9sN2x3SPnuVFmQyP25ihqKgfBSAMVNJmjZg5Mhrlfu6+wWPSEjpQtq
         rlBOzfwYWIEySvOWaiQLjcT1ACp6NACojNwgbTvYGQKw1YNZdy9fLODEj+9xCJfLqOKp
         wDDA==
X-Gm-Message-State: AOAM5315o/G5QkoywiMAvd5WJJsvkVw/kIS1iYDEYwxZcPfKCndc+Zy0
        X2AKJcVbX245qk8PMofnr+3mklkp4rk5
X-Google-Smtp-Source: ABdhPJwanaoy2S9Ezkf/flm++wEraYEBntfDjzkoZHgSRvzrtsWUrXoc50qrb0BGZ58rkL39rEm7UGOWdahi
X-Received: from vipinsh.kir.corp.google.com ([2620:0:1008:10:8048:6a12:bd4f:a453])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:6708:: with SMTP id
 n8mr2606697pjj.174.1617079342367; Mon, 29 Mar 2021 21:42:22 -0700 (PDT)
Date:   Mon, 29 Mar 2021 21:42:06 -0700
In-Reply-To: <20210330044206.2864329-1-vipinsh@google.com>
Message-Id: <20210330044206.2864329-4-vipinsh@google.com>
Mime-Version: 1.0
References: <20210330044206.2864329-1-vipinsh@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH v4 3/3] svm/sev: Register SEV and SEV-ES ASIDs to the misc controller
From:   Vipin Sharma <vipinsh@google.com>
To:     tj@kernel.org, mkoutny@suse.com, jacob.jun.pan@intel.com,
        rdunlap@infradead.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com
Cc:     corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, rientjes@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Secure Encrypted Virtualization (SEV) and Secure Encrypted
Virtualization - Encrypted State (SEV-ES) ASIDs are used to encrypt KVMs
on AMD platform. These ASIDs are available in the limited quantities on
a host.

Register their capacity and usage to the misc controller for tracking
via cgroups.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: David Rientjes <rientjes@google.com>
---
 arch/x86/kvm/svm/sev.c      | 70 +++++++++++++++++++++++++++++++------
 arch/x86/kvm/svm/svm.h      |  1 +
 include/linux/misc_cgroup.h |  6 ++++
 kernel/cgroup/misc.c        |  6 ++++
 4 files changed, 73 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 874ea309279f..214eefb20414 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -14,6 +14,7 @@
 #include <linux/psp-sev.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
 #include <asm/fpu/internal.h>
@@ -28,6 +29,21 @@
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
+#ifndef CONFIG_KVM_AMD_SEV
+/*
+ * When this config is not defined, SEV feature is not supported and APIs in
+ * this file are not used but this file still gets compiled into the KVM AMD
+ * module.
+ *
+ * We will not have MISC_CG_RES_SEV and MISC_CG_RES_SEV_ES entries in the enum
+ * misc_res_type {} defined in linux/misc_cgroup.h.
+ *
+ * Below macros allow compilation to succeed.
+ */
+#define MISC_CG_RES_SEV MISC_CG_RES_TYPES
+#define MISC_CG_RES_SEV_ES MISC_CG_RES_TYPES
+#endif
+
 static u8 sev_enc_bit;
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -89,8 +105,19 @@ static bool __sev_recycle_asids(int min_asid, int max_asid)
 
 static int sev_asid_new(struct kvm_sev_info *sev)
 {
-	int pos, min_asid, max_asid;
+	int pos, min_asid, max_asid, ret;
 	bool retry = true;
+	enum misc_res_type type;
+
+	type = sev->es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
+	WARN_ON(sev->misc_cg);
+	sev->misc_cg = get_current_misc_cg();
+	ret = misc_cg_try_charge(type, sev->misc_cg, 1);
+	if (ret) {
+		put_misc_cg(sev->misc_cg);
+		sev->misc_cg = NULL;
+		return ret;
+	}
 
 	mutex_lock(&sev_bitmap_lock);
 
@@ -108,7 +135,8 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 			goto again;
 		}
 		mutex_unlock(&sev_bitmap_lock);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto e_uncharge;
 	}
 
 	__set_bit(pos, sev_asid_bitmap);
@@ -116,6 +144,11 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 	mutex_unlock(&sev_bitmap_lock);
 
 	return pos + 1;
+e_uncharge:
+	misc_cg_uncharge(type, sev->misc_cg, 1);
+	put_misc_cg(sev->misc_cg);
+	sev->misc_cg = NULL;
+	return ret;
 }
 
 static int sev_get_asid(struct kvm *kvm)
@@ -125,14 +158,15 @@ static int sev_get_asid(struct kvm *kvm)
 	return sev->asid;
 }
 
-static void sev_asid_free(int asid)
+static void sev_asid_free(struct kvm_sev_info *sev)
 {
 	struct svm_cpu_data *sd;
 	int cpu, pos;
+	enum misc_res_type type;
 
 	mutex_lock(&sev_bitmap_lock);
 
-	pos = asid - 1;
+	pos = sev->asid - 1;
 	__set_bit(pos, sev_reclaim_asid_bitmap);
 
 	for_each_possible_cpu(cpu) {
@@ -141,6 +175,11 @@ static void sev_asid_free(int asid)
 	}
 
 	mutex_unlock(&sev_bitmap_lock);
+
+	type = sev->es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
+	misc_cg_uncharge(type, sev->misc_cg, 1);
+	put_misc_cg(sev->misc_cg);
+	sev->misc_cg = NULL;
 }
 
 static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
@@ -188,19 +227,20 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	asid = sev_asid_new(sev);
 	if (asid < 0)
 		return ret;
+	sev->asid = asid;
 
 	ret = sev_platform_init(&argp->error);
 	if (ret)
 		goto e_free;
 
 	sev->active = true;
-	sev->asid = asid;
 	INIT_LIST_HEAD(&sev->regions_list);
 
 	return 0;
 
 e_free:
-	sev_asid_free(asid);
+	sev_asid_free(sev);
+	sev->asid = 0;
 	return ret;
 }
 
@@ -1315,12 +1355,12 @@ void sev_vm_destroy(struct kvm *kvm)
 	mutex_unlock(&kvm->lock);
 
 	sev_unbind_asid(kvm, sev->handle);
-	sev_asid_free(sev->asid);
+	sev_asid_free(sev);
 }
 
 void __init sev_hardware_setup(void)
 {
-	unsigned int eax, ebx, ecx, edx;
+	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
@@ -1352,7 +1392,11 @@ void __init sev_hardware_setup(void)
 	if (!sev_reclaim_asid_bitmap)
 		goto out;
 
-	pr_info("SEV supported: %u ASIDs\n", max_sev_asid - min_sev_asid + 1);
+	sev_asid_count = max_sev_asid - min_sev_asid + 1;
+	if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count))
+		goto out;
+
+	pr_info("SEV supported: %u ASIDs\n", sev_asid_count);
 	sev_supported = true;
 
 	/* SEV-ES support requested? */
@@ -1367,7 +1411,11 @@ void __init sev_hardware_setup(void)
 	if (min_sev_asid == 1)
 		goto out;
 
-	pr_info("SEV-ES supported: %u ASIDs\n", min_sev_asid - 1);
+	sev_es_asid_count = min_sev_asid - 1;
+	if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
+		goto out;
+
+	pr_info("SEV-ES supported: %u ASIDs\n", sev_es_asid_count);
 	sev_es_supported = true;
 
 out:
@@ -1382,6 +1430,8 @@ void sev_hardware_teardown(void)
 
 	bitmap_free(sev_asid_bitmap);
 	bitmap_free(sev_reclaim_asid_bitmap);
+	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
+	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
 
 	sev_flush_asids();
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 39e071fdab0c..9806aaebc37f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -65,6 +65,7 @@ struct kvm_sev_info {
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
+	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 };
 
 struct kvm_svm {
diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index 1195d36558b4..c5af592481c0 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -12,6 +12,12 @@
  * Types of misc cgroup entries supported by the host.
  */
 enum misc_res_type {
+#ifdef CONFIG_KVM_AMD_SEV
+	/* AMD SEV ASIDs resource */
+	MISC_CG_RES_SEV,
+	/* AMD SEV-ES ASIDs resource */
+	MISC_CG_RES_SEV_ES,
+#endif
 	MISC_CG_RES_TYPES
 };
 
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index 4352bc4a3bd5..ec02d963cad1 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -18,6 +18,12 @@
 
 /* Miscellaneous res name, keep it in sync with enum misc_res_type */
 static const char *const misc_res_name[] = {
+#ifdef CONFIG_KVM_AMD_SEV
+	/* AMD SEV ASIDs resource */
+	"sev",
+	/* AMD SEV-ES ASIDs resource */
+	"sev_es",
+#endif
 };
 
 /* Root misc cgroup */
-- 
2.31.0.291.g576ba9dcdaf-goog

