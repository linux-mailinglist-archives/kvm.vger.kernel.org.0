Return-Path: <kvm+bounces-16853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EE64A8BE7B1
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 17:45:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 078B4B23EF0
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 15:45:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F10216C84F;
	Tue,  7 May 2024 15:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bkCuAjeY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D39216ABF7
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 15:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715096707; cv=none; b=jqghYRWQkxTELKyi/adroP7/MUXpdlIROuMqk7ZOayz3Vu/jKybAyKgLzpPdDts5WrdRtuKtWS9O8ua5FrIKlckDVlREVRl87JK67xO/63HZiKjyqDY9IUlTVMJl/eTa+X9I+9hSeNQ5uw9a+pDTmOfj9NXdZvMVJ1cewMrV2P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715096707; c=relaxed/simple;
	bh=4HXBDWMcQ63we0cEK0lxOWQf5yGqFZt0BPuAapREAcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z9iPnECk6oeWKq+cpVUsFccLc1SNXPNja1Sr3bPil1ibfatov8Mu22ut5N3Wvm3rZ3i3qfNz1b33ki2OXoGPYwHnAJZyHDAkvmFRLc/zhoQERxs/lU9N+t795R3JuzVC6x/bRSOoSep6sv1WKOE8Lbtym6yMRIKtcudVrObDtRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bkCuAjeY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715096705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iRVZJpf95iM8a2spygqO8CfFJRsMsampTCJH+nL0n8M=;
	b=bkCuAjeYN/Dh7iv2sY6HVDBGEOY9mjLb1CI7JEw86Gn1Ka1ac7nXNWMKeS3sgZf+ISiwlX
	ecLLUBmAZSOq/g41iarvLfeb/FMzjRxSikv44aunpCoARf9kmMKoagRb4vzsXLrS8C6xoJ
	RMTpHAp4KDgFf0hsXH3nXcSWEA9wPiM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-tkMVwKYXMVOVqBQaGEr4rw-1; Tue, 07 May 2024 11:45:01 -0400
X-MC-Unique: tkMVwKYXMVOVqBQaGEr4rw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B174101A553;
	Tue,  7 May 2024 15:45:01 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4A30BC159AE;
	Tue,  7 May 2024 15:45:01 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 4/7] KVM: x86/mmu: Add Suppress VE bit to EPT shadow_mmio_mask/shadow_present_mask
Date: Tue,  7 May 2024 11:44:56 -0400
Message-ID: <20240507154459.3950778-5-pbonzini@redhat.com>
In-Reply-To: <20240507154459.3950778-1-pbonzini@redhat.com>
References: <20240507154459.3950778-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

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
index 768aaeddf5fa..0a0e83859c27 100644
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



