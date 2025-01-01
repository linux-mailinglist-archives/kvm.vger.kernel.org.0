Return-Path: <kvm+bounces-34454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C82079FF36C
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:53:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DDAD162113
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 07:53:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 157181946C3;
	Wed,  1 Jan 2025 07:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QR21TmBO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBAB1917FF
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 07:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735717830; cv=none; b=RUHH7Ut5fuTS9h3pQ/BTlesYHx42SA3Q+4RsT8rbNgJqWAJhWxkWY/r4T9fv2cHtlCKowgMaygH3zJ9K60F3aTDlIulnIP0p7jwJglsoZ7k/WZ5ENEwO/R4wjObgXzIcYkspsB94QJGU6Hgdgpc/3Zmrd4oEfncNUKrexitn7ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735717830; c=relaxed/simple;
	bh=tYlSf1SsuLcLwky67J5c6AeKI70b5LULrgllYdczmWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eYIRTLLavJs3afa+Bpvuj6hhz9N3uBbcyaghEoQCyhssTufdLnvXJtLtqDdeZGG8TM00JL8xhncqpBPwbPFw4BAFm8liTWqhSvdejCNKiHJx96xbOsAXwWLT42Qtg0KgNYzMfL7eFqFWdFNHrP2ajBnRe4USw2VzO9Fcz6NdDeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QR21TmBO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735717827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k2hEn+0E9ZYn2ngcgJQ4FeYzlIjXogbxp04qFSrhTPM=;
	b=QR21TmBO3tx2Zc52rZt9MZSHJh/l+NTTM28XNu/Bg6+dA1cXvUon38Yc6QnldMjeRJRJbK
	bcS7jQrWJEkziysOXNZBOVVsMRsIVeVN6u0nB/pe7tVJM/8cJwJOg4UoAnDeIF5GnRE/eK
	6GpXSpxj3emmbfgZ6qloCcTI31ENRM4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-542-w5gD12BiMTOdfZ6zAtFZ2g-1; Wed,
 01 Jan 2025 02:50:24 -0500
X-MC-Unique: w5gD12BiMTOdfZ6zAtFZ2g-1
X-Mimecast-MFC-AGG-ID: w5gD12BiMTOdfZ6zAtFZ2g
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D42A919560AF;
	Wed,  1 Jan 2025 07:50:22 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C43BD3000197;
	Wed,  1 Jan 2025 07:50:21 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 13/13] x86/virt/tdx: Add tdx_guest_keyid_alloc/free() to alloc and free TDX guest KeyID
Date: Wed,  1 Jan 2025 02:49:59 -0500
Message-ID: <20250101074959.412696-14-pbonzini@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Isaku Yamahata <isaku.yamahata@intel.com>

Intel TDX protects guest VMs from malicious host and certain physical
attacks. Pre-TDX Intel hardware has support for a memory encryption
architecture called MK-TME, which repurposes several high bits of
physical address as "KeyID". The BIOS reserves a sub-range of MK-TME
KeyIDs as "TDX private KeyIDs".

Each TDX guest must be assigned with a unique TDX KeyID when it is
created. The kernel reserves the first TDX private KeyID for
crypto-protection of specific TDX module data which has a lifecycle that
exceeds the KeyID reserved for the TD's use. The rest of the KeyIDs are
left for TDX guests to use.

Create a small KeyID allocator. Export
tdx_guest_keyid_alloc()/tdx_guest_keyid_free() to allocate and free TDX
guest KeyID for KVM to use.

Don't provide the stub functions when CONFIG_INTEL_TDX_HOST=n since they
are not supposed to be called in this case.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <20241030190039.77971-5-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  3 +++
 arch/x86/virt/vmx/tdx/tdx.c | 17 +++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 6981a3d75eb2..c2fe56a3c7fa 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -117,6 +117,9 @@ int tdx_cpu_enable(void);
 int tdx_enable(void);
 const char *tdx_dump_mce_info(struct mce *m);
 
+int tdx_guest_keyid_alloc(void);
+void tdx_guest_keyid_free(unsigned int keyid);
+
 struct tdx_td {
 	/* TD root structure: */
 	struct page *tdr_page;
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 84fe5bc79434..1a5912a8b5c5 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -28,6 +28,7 @@
 #include <linux/log2.h>
 #include <linux/acpi.h>
 #include <linux/suspend.h>
+#include <linux/idr.h>
 #include <asm/page.h>
 #include <asm/special_insns.h>
 #include <asm/msr-index.h>
@@ -43,6 +44,8 @@ static u32 tdx_global_keyid __ro_after_init;
 static u32 tdx_guest_keyid_start __ro_after_init;
 static u32 tdx_nr_guest_keyids __ro_after_init;
 
+static DEFINE_IDA(tdx_guest_keyid_pool);
+
 static DEFINE_PER_CPU(bool, tdx_lp_initialized);
 
 static struct tdmr_info_list tdx_tdmr_list;
@@ -1458,6 +1461,20 @@ void __init tdx_init(void)
 	check_tdx_erratum();
 }
 
+int tdx_guest_keyid_alloc(void)
+{
+	return ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start,
+			       tdx_guest_keyid_start + tdx_nr_guest_keyids - 1,
+			       GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(tdx_guest_keyid_alloc);
+
+void tdx_guest_keyid_free(unsigned int keyid)
+{
+	ida_free(&tdx_guest_keyid_pool, keyid);
+}
+EXPORT_SYMBOL_GPL(tdx_guest_keyid_free);
+
 static inline u64 tdx_tdr_pa(struct tdx_td *td)
 {
 	return page_to_pfn(td->tdr_page) << PAGE_SHIFT;
-- 
2.43.5


