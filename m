Return-Path: <kvm+bounces-38756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0643A3E226
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:20:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F11B707055
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:14:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4EF522A80A;
	Thu, 20 Feb 2025 17:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UgHMZ9Yl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AA722A4F1
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071219; cv=none; b=ZM5WSCLh2h9TG+ky8NI8KKHaQNTHH1iKVn8uQ/w/6sSZJhgZ1PgDTbM9tigtEebTm3j5pWJyTTP6/fzcU2f+pHKrKvpjm2RyForNyyQuxgFSVILQ8/SiHqAfTKHhwLi1wh+koRav+yHhJjhgKHf3Qkq0FGu1E6PQX4RTfzPUxWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071219; c=relaxed/simple;
	bh=zwW1fa4b2WOaXd0TSba/wk7mWtshg3WgjRIrZ7ypJmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AwSdnKDE7vjLFUvSMR3BmJGRYaGY3WEEyZRF1pb9Ri+iBAjnO2sNKGoAGfPiwc5PozFJv2lnCf9KInjfIPqO8PzFhvVidSqRImjUgipdLUkkRD2FFlstL/mhJFsjxxGnWDoQDGhmxYGlTXo2IexZxD7wv3UofFSuCSPKQ/RJTCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UgHMZ9Yl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740071217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9A7fliY0YRXdz2jG0qB4m1rYmz3YhV2HEkf3OmiphRo=;
	b=UgHMZ9YlJHXwO2VLXcxQ1wqduRhkBTuM4HrTQKYCp3Q5yRtptB0ha+syBZ6vqWfR56Gfc0
	r4RCYdg0gjzzOQuspCAjL6wqlBWOZsMEOZNgA/7fmUfKTip3IXR+WyH+EMZFfUU3F3Erf0
	SptreVDS9F9kovfAf92OUG9WTv3wvh8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-313-_gPyy4IXOjSlbdXdp0wBig-1; Thu,
 20 Feb 2025 12:06:52 -0500
X-MC-Unique: _gPyy4IXOjSlbdXdp0wBig-1
X-Mimecast-MFC-AGG-ID: _gPyy4IXOjSlbdXdp0wBig_1740071211
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08DB01800982;
	Thu, 20 Feb 2025 17:06:51 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E9F6C180087E;
	Thu, 20 Feb 2025 17:06:49 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Zhiming Hu <zhiming.hu@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 30/30] KVM: TDX: Register TDX host key IDs to cgroup misc controller
Date: Thu, 20 Feb 2025 12:06:04 -0500
Message-ID: <20250220170604.2279312-31-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-1-pbonzini@redhat.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

From: Zhiming Hu <zhiming.hu@intel.com>

TDX host key IDs (HKID) are limit resources in a machine, and the misc
cgroup lets the machine owner track their usage and limits the possibility
of abusing them outside the owner's control.

The cgroup v2 miscellaneous subsystem was introduced to control the
resource of AMD SEV & SEV-ES ASIDs.  Likewise introduce HKIDs as a misc
resource.

Signed-off-by: Zhiming Hu <zhiming.hu@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/kvm/vmx/tdx.c      | 14 ++++++++++++++
 arch/x86/kvm/vmx/tdx.h      |  1 +
 arch/x86/virt/vmx/tdx/tdx.c |  6 ++++++
 include/linux/misc_cgroup.h |  4 ++++
 kernel/cgroup/misc.c        |  4 ++++
 6 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 52a21075c0a6..7dd71ca3eb57 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -124,6 +124,7 @@ const char *tdx_dump_mce_info(struct mce *m);
 const struct tdx_sys_info *tdx_get_sysinfo(void);
 
 int tdx_guest_keyid_alloc(void);
+u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
 
 struct tdx_td {
@@ -179,6 +180,7 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
 static inline int tdx_enable(void)  { return -ENODEV; }
+static u32 tdx_get_nr_guest_keyids(void) { return 0; }
 static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
 static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1c88f577ec2b..a2355eed8f5a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/cpu.h>
 #include <asm/cpufeature.h>
+#include <linux/misc_cgroup.h>
 #include <asm/tdx.h>
 #include "capabilities.h"
 #include "mmu.h"
@@ -143,6 +144,9 @@ static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
 	tdx_guest_keyid_free(kvm_tdx->hkid);
 	kvm_tdx->hkid = -1;
 	atomic_dec(&nr_configured_hkid);
+	misc_cg_uncharge(MISC_CG_RES_TDX, kvm_tdx->misc_cg, 1);
+	put_misc_cg(kvm_tdx->misc_cg);
+	kvm_tdx->misc_cg = NULL;
 }
 
 static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
@@ -684,6 +688,10 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 	if (ret < 0)
 		return ret;
 	kvm_tdx->hkid = ret;
+	kvm_tdx->misc_cg = get_current_misc_cg();
+	ret = misc_cg_try_charge(MISC_CG_RES_TDX, kvm_tdx->misc_cg, 1);
+	if (ret)
+		goto free_hkid;
 
 	ret = -ENOMEM;
 
@@ -1465,6 +1473,11 @@ static int __init __tdx_bringup(void)
 		goto get_sysinfo_err;
 	}
 
+	if (misc_cg_set_capacity(MISC_CG_RES_TDX, tdx_get_nr_guest_keyids())) {
+		r = -EINVAL;
+		goto get_sysinfo_err;
+	}
+
 	/*
 	 * Leave hardware virtualization enabled after TDX is enabled
 	 * successfully.  TDX CPU hotplug depends on this.
@@ -1481,6 +1494,7 @@ static int __init __tdx_bringup(void)
 void tdx_cleanup(void)
 {
 	if (enable_tdx) {
+		misc_cg_set_capacity(MISC_CG_RES_TDX, 0);
 		__do_tdx_cleanup();
 		kvm_disable_virtualization();
 	}
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index c3bde94c19dc..5fea072b4f56 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -21,6 +21,7 @@ enum kvm_tdx_state {
 struct kvm_tdx {
 	struct kvm kvm;
 
+	struct misc_cg *misc_cg;
 	int hkid;
 	enum kvm_tdx_state state;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 9f0c482c1a03..3a272e9ff2ca 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1476,6 +1476,12 @@ const struct tdx_sys_info *tdx_get_sysinfo(void)
 }
 EXPORT_SYMBOL_GPL(tdx_get_sysinfo);
 
+u32 tdx_get_nr_guest_keyids(void)
+{
+	return tdx_nr_guest_keyids;
+}
+EXPORT_SYMBOL_GPL(tdx_get_nr_guest_keyids);
+
 int tdx_guest_keyid_alloc(void)
 {
 	return ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start,
diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index 49eef10c8e59..8c0e4f4d71be 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -17,6 +17,10 @@ enum misc_res_type {
 	MISC_CG_RES_SEV,
 	/** @MISC_CG_RES_SEV_ES: AMD SEV-ES ASIDs resource */
 	MISC_CG_RES_SEV_ES,
+#endif
+#ifdef CONFIG_INTEL_TDX_HOST
+	/* Intel TDX HKIDs resource */
+	MISC_CG_RES_TDX,
 #endif
 	/** @MISC_CG_RES_TYPES: count of enum misc_res_type constants */
 	MISC_CG_RES_TYPES
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index 0e26068995a6..264aad22c967 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -24,6 +24,10 @@ static const char *const misc_res_name[] = {
 	/* AMD SEV-ES ASIDs resource */
 	"sev_es",
 #endif
+#ifdef CONFIG_INTEL_TDX_HOST
+	/* Intel TDX HKIDs resource */
+	"tdx",
+#endif
 };
 
 /* Root misc cgroup */
-- 
2.43.5


