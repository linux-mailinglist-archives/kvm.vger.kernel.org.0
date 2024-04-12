Return-Path: <kvm+bounces-14551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 092A28A34D3
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 19:35:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8047284BEE
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 17:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 414FE14E2D7;
	Fri, 12 Apr 2024 17:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NxpE5qYq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F295884A35
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 17:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712943338; cv=none; b=PcgPU9dmWpaeCzaxvYpKrobiRi/vD3NGgI8ZcYcc9S4VPCfnOAdAVX84coS7vmVv1Yi0VLhu4tk32aBeLNuXWUJ+MF4hpfkaV+OhlNg2/ZEspNBEeRsFZmAdJp0a9MZzHwNL0hGTWQEfNqjFn968R0Bdiujs+2OFN3iGTHSczKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712943338; c=relaxed/simple;
	bh=1B/zUTkP+xSjtPWcsP8oG3U9mKuxHuCkDO5ODjKdKFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GEGCkf9xrUtF9jAO22pYJ209Zb2HrZuQ+FifKfm1CwQMUGhjWWSNQ39K6h/LLhLyoHdJWHdac4Nuo5GaweEbWm2BKcY9lwthAuv3Jv0GjVN435NwQrsMBcLkTl9NC0kxnigsfJLo9+IPSGl5AmzE6YKiVYMFWMUaMaFK0rsMkfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NxpE5qYq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712943335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MMoankSPnsr51NzQw3GN0rThmSlkSJ5vluBsBS+Wb58=;
	b=NxpE5qYqo3oD7ZfeNFvU2RnHdPvNGxHvZOOSM2/sy5JmPyEzVGKOEYXQOOM6tfNyH5v8sr
	NUyxH8WKc+EW/y+AEyy4wGxMlTI+9XLdgimiGHx78bMU+FkXMKbx6rSdWngU29mBVD5P47
	PeqUBA8nkkqb1Bz4d+NIThXjzZLkrqo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-zw4_kvqcO7-rgx4dU9lCjQ-1; Fri, 12 Apr 2024 13:35:34 -0400
X-MC-Unique: zw4_kvqcO7-rgx4dU9lCjQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D718280021A;
	Fri, 12 Apr 2024 17:35:33 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B58A1492BC7;
	Fri, 12 Apr 2024 17:35:33 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 04/10] KVM: x86/mmu: Add Suppress VE bit to EPT shadow_mmio_mask/shadow_present_mask
Date: Fri, 12 Apr 2024 13:35:26 -0400
Message-ID: <20240412173532.3481264-5-pbonzini@redhat.com>
In-Reply-To: <20240412173532.3481264-1-pbonzini@redhat.com>
References: <20240412173532.3481264-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Isaku Yamahata <isaku.yamahata@intel.com>

To make use of the same value of shadow_mmio_mask and shadow_present_mask
for TDX and VMX, add Suppress-VE bit to shadow_mmio_mask and
shadow_present_mask so that they can be common for both VMX and TDX.

TDX will require shadow_mmio_mask and shadow_present_mask to include
VMX_SUPPRESS_VE for shared GPA so that EPT violation is triggered for
shared GPA.  For VMX, VMX_SUPPRESS_VE doesn't matter for MMIO because the
spte value is defined so as to cause EPT misconfig.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Message-Id: <97cc616b3563cd8277be91aaeb3e14bce23c3649.1705965635.git.isaku.yamahata@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/vmx.h | 1 +
 arch/x86/kvm/mmu/spte.c    | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 4dba17363008..ac6da0a5f5e6 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -514,6 +514,7 @@ enum vmcs_field {
 #define VMX_EPT_IPAT_BIT    			(1ull << 6)
 #define VMX_EPT_ACCESS_BIT			(1ull << 8)
 #define VMX_EPT_DIRTY_BIT			(1ull << 9)
+#define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
 #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
 						 VMX_EPT_WRITABLE_MASK |       \
 						 VMX_EPT_EXECUTABLE_MASK)
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 6c7ab3aa6aa7..d97c4725c0b7 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -413,7 +413,9 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
 	shadow_nx_mask		= 0ull;
 	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
-	shadow_present_mask	= has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
+	/* VMX_EPT_SUPPRESS_VE_BIT is needed for W or X violation. */
+	shadow_present_mask	=
+		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | VMX_EPT_SUPPRESS_VE_BIT;
 	/*
 	 * EPT overrides the host MTRRs, and so KVM must program the desired
 	 * memtype directly into the SPTEs.  Note, this mask is just the mask
@@ -430,7 +432,7 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	 * of an EPT paging-structure entry is 110b (write/execute).
 	 */
 	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE,
-				   VMX_EPT_RWX_MASK, 0);
+				   VMX_EPT_RWX_MASK | VMX_EPT_SUPPRESS_VE_BIT, 0);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_ept_masks);
 
-- 
2.43.0



