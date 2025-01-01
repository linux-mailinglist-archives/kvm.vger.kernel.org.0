Return-Path: <kvm+bounces-34442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13F5F9FF354
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:50:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC9D41881E78
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 07:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A59554F81;
	Wed,  1 Jan 2025 07:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bfi04Jlp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2F226289
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 07:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735717812; cv=none; b=h/5EdpQVp4h22Hj80SLYRT54NOlZ995f7rK/tMXuxbgNYXb5G/DztAMzbIwCzFhVpTMkvYBcc7DlTpqSasGcOXqSVLU9Ue/zZJqyiHS1pPtFrm4/aRiXXhJYsN7VCu+rTP9MNFQoCnfj3RcvHaHjUV786NBq0uZHKbQqfEza7N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735717812; c=relaxed/simple;
	bh=yfJrNLpML9Z2QSwY7arGLo8fAh4HnaKdAuwI5O/CGq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KSel/Im8ehNIYjFLS8QXlCam7JZz7rCenCF0bGUECVTtt2N9ByMtgu4V1Vr33bZnordif7dKp4vXQKFaftC58HThIRUZ2B9+CSynJOiQ+R99M+9coqPBcKYogA/Ifg7O6xYhVDZXhSeyeftQ9DVtFhkPTwfym1QtIMcQA5tvWIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bfi04Jlp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735717809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aa54d0I3StUigCEJE1bPzhJzHnPN3i+5WJ3szUUpRsU=;
	b=bfi04JlpEnTj9IoFX2FghZ/7tLzl1bBw1btEy9jQfIbJxtQdXn9UMLwm32vbnVC03k65wf
	MpKwVJ77gwTyPJovsY8IA2HSK/axK2Pvy2IZ5Stigx4TEQM58UBSud6q8T9uPd3ZaqAO+A
	btf2OZYDYWtsvF0xEHkYFbu/JOVFgFs=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-25-j1Kx5RUMOuun20banDbU-Q-1; Wed,
 01 Jan 2025 02:50:05 -0500
X-MC-Unique: j1Kx5RUMOuun20banDbU-Q-1
X-Mimecast-MFC-AGG-ID: j1Kx5RUMOuun20banDbU-Q
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 186E51956087;
	Wed,  1 Jan 2025 07:50:04 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2FF061956052;
	Wed,  1 Jan 2025 07:50:02 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH 01/13] x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID management
Date: Wed,  1 Jan 2025 02:49:47 -0500
Message-ID: <20250101074959.412696-2-pbonzini@redhat.com>
In-Reply-To: <20250101074959.412696-1-pbonzini@redhat.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Intel TDX protects guest VMs from malicious host and certain physical
attacks. Pre-TDX Intel hardware has support for a memory encryption
architecture called MK-TME, which repurposes several high bits of
physical address as "KeyID". TDX ends up with reserving a sub-range of
MK-TME KeyIDs as "TDX private KeyIDs".

Like MK-TME, these KeyIDs can be associated with an ephemeral key. For TDX
this association is done by the TDX module. It also has its own tracking
for which KeyIDs are in use. To do this ephemeral key setup and manipulate
the TDX module's internal tracking, KVM will use the following SEAMCALLs:
 TDH.MNG.KEY.CONFIG: Mark the KeyID as in use, and initialize its
                     ephemeral key.
 TDH.MNG.KEY.FREEID: Mark the KeyID as not in use.

These SEAMCALLs both operate on TDR structures, which are setup using the
previously added TDH.MNG.CREATE SEAMCALL. KVM's use of these operations
will go like:
 - tdx_guest_keyid_alloc()
 - Initialize TD and TDR page with TDH.MNG.CREATE (not yet-added), passing
   KeyID
 - TDH.MNG.KEY.CONFIG to initialize the key
 - TD runs, teardown is started
 - TDH.MNG.KEY.FREEID
 - tdx_guest_keyid_free()

Don't try to combine the tdx_guest_keyid_alloc() and TDH.MNG.KEY.CONFIG
operations because TDH.MNG.CREATE and some locking need to be done in the
middle. Don't combine TDH.MNG.KEY.FREEID and tdx_guest_keyid_free() so they
are symmetrical with the creation path.

So implement tdh_mng_key_config() and tdh_mng_key_freeid() as separate
functions than tdx_guest_keyid_alloc() and tdx_guest_keyid_free().

The TDX module provides SEAMCALLs to hand pages to the TDX module for
storing TDX controlled state. SEAMCALLs that operate on this state are
directed to the appropriate TD VM using references to the pages originally
provided for managing the TD's state. So the host kernel needs to track
these pages, both as an ID for specifying which TD to operate on, and to
allow them to be eventually reclaimed. The TD VM associated pages are
called TDR (Trust Domain Root) and TDCS (Trust Domain Control Structure).

Introduce "struct tdx_td" for holding references to pages provided to the
TDX module for this TD VM associated state. Don't plan for any TD
associated state that is controlled by KVM to live in this struct. Only
expect it to hold data for concepts specific to the TDX architecture, for
which there can't already be preexisting storage for in KVM.

Add both the TDR page and an array of TDCS pages, even though the SEAMCALL
wrappers will only need to know about the TDR pages for directing the
SEAMCALLs to the right TD. Adding the TDCS pages to this struct will let
all of the TD VM associated pages handed to the TDX module be tracked in
one location. For a type to specify physical pages, use KVM's hpa_t type.
Do this for KVM's benefit This is the common type used to hold physical
addresses in KVM, so will make interoperability easier.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
Message-ID: <20241203010317.827803-2-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  | 12 ++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 25 +++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 16 +++++++++-------
 3 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index eba178996d84..5045ab1c3d5b 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -116,6 +116,18 @@ static inline u64 sc_retry(sc_func_t func, u64 fn,
 int tdx_cpu_enable(void);
 int tdx_enable(void);
 const char *tdx_dump_mce_info(struct mce *m);
+
+struct tdx_td {
+	/* TD root structure: */
+	struct page *tdr_page;
+
+	int tdcs_nr_pages;
+	/* TD control structure: */
+	struct page **tdcs_pages;
+};
+
+u64 tdh_mng_key_config(struct tdx_td *td);
+u64 tdh_mng_key_freeid(struct tdx_td *td);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 7fdb37387886..55842d5b9474 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1456,3 +1456,28 @@ void __init tdx_init(void)
 
 	check_tdx_erratum();
 }
+
+static inline u64 tdx_tdr_pa(struct tdx_td *td)
+{
+	return page_to_pfn(td->tdr_page) << PAGE_SHIFT;
+}
+
+u64 tdh_mng_key_config(struct tdx_td *td)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdr_pa(td),
+	};
+
+	return seamcall(TDH_MNG_KEY_CONFIG, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mng_key_config);
+
+u64 tdh_mng_key_freeid(struct tdx_td *td)
+{
+	struct tdx_module_args args = {
+		.rcx = tdx_tdr_pa(td),
+	};
+
+	return seamcall(TDH_MNG_KEY_FREEID, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mng_key_freeid);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 4e3d533cdd61..5579317f67ab 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -15,13 +15,15 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
-#define TDH_PHYMEM_PAGE_RDMD	24
-#define TDH_SYS_KEY_CONFIG	31
-#define TDH_SYS_INIT		33
-#define TDH_SYS_RD		34
-#define TDH_SYS_LP_INIT		35
-#define TDH_SYS_TDMR_INIT	36
-#define TDH_SYS_CONFIG		45
+#define TDH_MNG_KEY_CONFIG		8
+#define TDH_MNG_KEY_FREEID		20
+#define TDH_PHYMEM_PAGE_RDMD		24
+#define TDH_SYS_KEY_CONFIG		31
+#define TDH_SYS_INIT			33
+#define TDH_SYS_RD			34
+#define TDH_SYS_LP_INIT			35
+#define TDH_SYS_TDMR_INIT		36
+#define TDH_SYS_CONFIG			45
 
 /* TDX page types */
 #define	PT_NDA		0x0
-- 
2.43.5



