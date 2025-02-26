Return-Path: <kvm+bounces-39328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C635BA46958
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:18:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D53AB3AC140
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A9012356C5;
	Wed, 26 Feb 2025 18:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bJxzKYDn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E11A23AE93
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593723; cv=none; b=hu55TcUuXuSIas1Pm9STb4GZdT0J3VUe9PyGXRL6tDfGzgmkljBkmXwpB1T9W8KabpaBdI2URpCuWDw5BUrw2D0TH2qyCinA2bN9WrwLHwf9xVX/Py2R4Q5ivCyDBH7WAVajl49BKWQqh7Vb4wCqNy4Wl8r1D+vTzA2dLGaRglU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593723; c=relaxed/simple;
	bh=MM+E2DhB6mP93V6kH9H0BWPQOci1r/gsNuB+UaxbiAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=um9a3gol/BF4En8zsHlq+QRVRluA4K1B/qBkCJioRT6C5pr4DntyqtzR1ZbSnOUbsxo/4RMIiG3D/dklMw7GOPLA1WIhCJ6UB4XX5SSha9cjz/Yx5m5nUtvq4GAOzIbAtgtGs9qXLRRbUSQxT9QpbUS/Uz4Cg1REvI2kh7aDNfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bJxzKYDn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740593720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jxlx/bW94Y2mBtTLd29pOhhWxpKoOzPdJnxQh04qFFg=;
	b=bJxzKYDnzFe8bSDWKZF6HB1l5mzeqcL8DPQ0h1lhbeYuXq0RRqY1Bze5jvgzQUymEAsxsq
	2rCOlMvGRydWmqbx+CM6pL9rxf45HlMAX28/84liEPKKatjqaqcvVrLblfyPrqFszfS1PH
	h7IADeovgXBlWwFr0bMlkAMrGYA42gY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-253-WT_XOfaQONKk05g9LTjn6A-1; Wed,
 26 Feb 2025 13:15:15 -0500
X-MC-Unique: WT_XOfaQONKk05g9LTjn6A-1
X-Mimecast-MFC-AGG-ID: WT_XOfaQONKk05g9LTjn6A_1740593714
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94D421903091;
	Wed, 26 Feb 2025 18:15:14 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 84C8F1955BD4;
	Wed, 26 Feb 2025 18:15:13 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 12/33] x86/virt/tdx: Add tdx_guest_keyid_alloc/free() to alloc and free TDX guest KeyID
Date: Wed, 26 Feb 2025 13:14:31 -0500
Message-ID: <20250226181453.2311849-13-pbonzini@redhat.com>
In-Reply-To: <20250226181453.2311849-1-pbonzini@redhat.com>
References: <20250226181453.2311849-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

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
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  |  3 +++
 arch/x86/virt/vmx/tdx/tdx.c | 17 +++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 53cdb4896856..26e29a7ba6f8 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -121,6 +121,9 @@ int tdx_cpu_enable(void);
 int tdx_enable(void);
 const char *tdx_dump_mce_info(struct mce *m);
 
+int tdx_guest_keyid_alloc(void);
+void tdx_guest_keyid_free(unsigned int keyid);
+
 struct tdx_td {
 	/* TD root structure: */
 	struct page *tdr_page;
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 578ad468634b..0122051af6b3 100644
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
@@ -1459,6 +1462,20 @@ void __init tdx_init(void)
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
 	return page_to_phys(td->tdr_page);
-- 
2.43.5



