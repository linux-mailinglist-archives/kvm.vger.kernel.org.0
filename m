Return-Path: <kvm+bounces-39377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DEA4A46B95
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:59:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86DEA3B029C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CD6C26F456;
	Wed, 26 Feb 2025 19:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZqkJlbY6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5702571AE
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599758; cv=none; b=DjjIqj5VvIQQkfavZmCtyTBdZpaudJ8CxtxmonY1/N/2DWRGiBS4VFJ8METzAKtIPK6kHff0P5iBilED/sC440Y9pIhVQWKqXDiuFprgYAE7/+HCtprRMsPAXN6HWFXQ/vIOSyqTepf49EJdAfURxzi2lwiVzUNWU0LqTw2B+uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599758; c=relaxed/simple;
	bh=Yki3UJ9zSdwpkr3EkzCQOa7ss5qvR3z0MFZ/2cGS7kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lWCjUs4ZtIY01F8iSZufuEU56Lc1B5HxQQSaSxtydtz4eO9ypX5owVkddBQxbTjjwfqvs8f2Yoe9sAC0Eu6yvfiZq7fdjRsrI6gXJQDrMrCy8KKSzr251gROetE1gMGqa3hiiQlEccLac1cjgdgB7Vd3tYT3bhNKenM2dAkDQcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZqkJlbY6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740599755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jsgg1Hgbf9dcIZ2WKNC1cvRkgqrc8iVO38FPcZEHBYY=;
	b=ZqkJlbY6GEYaoGmfDXwyznm+GGtoTQ8XLdO9138+DPQYEkxP/EATK5CfaGQEVKAhIBeWy/
	RQKcAoP3lbugSkU4u7173CCsXQha3sEDlXARSo5cf2qbqqBuRCd3/SA0Wus2ea5hfhMr6z
	Glm4FX1AEv1TOtKsKZ6Dprg2Wi3agvc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-65-ZEdkVaMTPjWAxlqeN5N09A-1; Wed,
 26 Feb 2025 14:55:54 -0500
X-MC-Unique: ZEdkVaMTPjWAxlqeN5N09A-1
X-Mimecast-MFC-AGG-ID: ZEdkVaMTPjWAxlqeN5N09A_1740599753
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0AFDF19560AF;
	Wed, 26 Feb 2025 19:55:53 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 17A5D300018D;
	Wed, 26 Feb 2025 19:55:51 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 16/29] KVM: TDX: Set per-VM shadow_mmio_value to 0
Date: Wed, 26 Feb 2025 14:55:16 -0500
Message-ID: <20250226195529.2314580-17-pbonzini@redhat.com>
In-Reply-To: <20250226195529.2314580-1-pbonzini@redhat.com>
References: <20250226195529.2314580-1-pbonzini@redhat.com>
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

Set per-VM shadow_mmio_value to 0 for TDX.

With enable_mmio_caching on, KVM installs MMIO SPTEs for TDs. To correctly
configure MMIO SPTEs, TDX requires the per-VM shadow_mmio_value to be set
to 0. This is necessary to override the default value of the suppress VE
bit in the SPTE, which is 1, and to ensure value 0 in RWX bits.

For MMIO SPTE, the spte value changes as follows:
1. initial value (suppress VE bit is set)
2. Guest issues MMIO and triggers EPT violation
3. KVM updates SPTE value to MMIO value (suppress VE bit is cleared)
4. Guest MMIO resumes.  It triggers VE exception in guest TD
5. Guest VE handler issues TDG.VP.VMCALL<MMIO>
6. KVM handles MMIO
7. Guest VE handler resumes its execution after MMIO instruction

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20241112073743.22214-1-yan.y.zhao@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/spte.c |  2 --
 arch/x86/kvm/vmx/tdx.c  | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index c42ac5d1f027..e819d16655b6 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -96,8 +96,6 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
 	u64 spte = generation_mmio_spte_mask(gen);
 	u64 gpa = gfn << PAGE_SHIFT;
 
-	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value);
-
 	access &= shadow_mmio_access_mask;
 	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
 	spte |= gpa | shadow_nonpresent_or_rsvd_mask;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a44a50db9199..f42772a5492b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -8,6 +8,7 @@
 #include "x86_ops.h"
 #include "lapic.h"
 #include "tdx.h"
+#include "mmu/spte.h"
 
 #pragma GCC poison to_vmx
 
@@ -410,6 +411,19 @@ int tdx_vm_init(struct kvm *kvm)
 	kvm->arch.has_protected_state = true;
 	kvm->arch.has_private_mem = true;
 
+	/*
+	 * Because guest TD is protected, VMM can't parse the instruction in TD.
+	 * Instead, guest uses MMIO hypercall.  For unmodified device driver,
+	 * #VE needs to be injected for MMIO and #VE handler in TD converts MMIO
+	 * instruction into MMIO hypercall.
+	 *
+	 * SPTE value for MMIO needs to be setup so that #VE is injected into
+	 * TD instead of triggering EPT MISCONFIG.
+	 * - RWX=0 so that EPT violation is triggered.
+	 * - suppress #VE bit is cleared to inject #VE.
+	 */
+	kvm_mmu_set_mmio_spte_value(kvm, 0);
+
 	/*
 	 * TDX has its own limit of maximum vCPUs it can support for all
 	 * TDX guests in addition to KVM_MAX_VCPUS.  TDX module reports
-- 
2.43.5



