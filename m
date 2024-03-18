Return-Path: <kvm+bounces-12057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1C6E87F416
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:36:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9DAE1C21A47
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:36:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB8256086B;
	Mon, 18 Mar 2024 23:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e12RNqTm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA88F5FDC4
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 23:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710804844; cv=none; b=OJJA8xg4NK8q3567cZy2qGaIF+ldFVihzvxosCkaONQl57si16XZGPa1WLcrOTbCKsf4XZMLD3mSmjN4Zkw45q+bXJDjUIbS1N9d+6w6O9XLKFKLA7PbtlVLpcLdrYlvCC0+njHEpO/VWwsE5DlaUjbD6tB8jfpEbbHQIQ6sexM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710804844; c=relaxed/simple;
	bh=/h8SqmURALLDyuGUX7H2nBueG9nOdv0SX3aEOGmrKSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZKMTRUzXDkFOYaIPaKPnvQpSbdvZyWhOQGhxqvt7kDzhlXaDeKInPFRG0gm1a2OqnIDQiJ/xPLsAQ8FwYJMlTQ730l2L4D20DgpPYCHMIQ2KeSmW1QBYqWpQE5u6dpmx8V9giFUPJRm+6cC7AxN/XRIAU8R/FVwv8lYjgIO8rAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e12RNqTm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710804842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3akqZgNcQZFd1TqSeRZMm8OcjnakqT/fyGcLLrf83Kc=;
	b=e12RNqTmQ/YfiHgyGfTkNlnQCyWyiJmnQFDeoC1G0J7+VC+uddCV6SfN03jh216huwRSsA
	iXl//yR2hU5hAn/qRB55nGeiVL9xepQg4x/RwoBn46CpBcn6hTPIdNae/jVR+43tv61uH6
	Iwp+tElEPq2Uxje0Fm1sOOHOZeChcgM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-7FSHSY0bP1OxNxIsfqICHA-1; Mon, 18 Mar 2024 19:33:55 -0400
X-MC-Unique: 7FSHSY0bP1OxNxIsfqICHA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B45885A58C;
	Mon, 18 Mar 2024 23:33:55 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 44BF11121312;
	Mon, 18 Mar 2024 23:33:55 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	seanjc@google.com
Subject: [PATCH v4 08/15] KVM: x86: Add supported_vm_types to kvm_caps
Date: Mon, 18 Mar 2024 19:33:45 -0400
Message-ID: <20240318233352.2728327-9-pbonzini@redhat.com>
In-Reply-To: <20240318233352.2728327-1-pbonzini@redhat.com>
References: <20240318233352.2728327-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

This simplifies the implementation of KVM_CHECK_EXTENSION(KVM_CAP_VM_TYPES),
and also allows the vendor module to specify which VM types are supported.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 12 ++++++------
 arch/x86/kvm/x86.h |  2 ++
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 98b7979b4698..8c56bcf3feb7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -94,6 +94,7 @@
 
 struct kvm_caps kvm_caps __read_mostly = {
 	.supported_mce_cap = MCG_CTL_P | MCG_SER_P,
+	.supported_vm_types = BIT(KVM_X86_DEFAULT_VM),
 };
 EXPORT_SYMBOL_GPL(kvm_caps);
 
@@ -4629,9 +4630,7 @@ static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
 
 static bool kvm_is_vm_type_supported(unsigned long type)
 {
-	return type == KVM_X86_DEFAULT_VM ||
-	       (type == KVM_X86_SW_PROTECTED_VM &&
-		IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_mmu_enabled);
+	return type < 32 && (kvm_caps.supported_vm_types & BIT(type));
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
@@ -4832,9 +4831,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = kvm_caps.has_notify_vmexit;
 		break;
 	case KVM_CAP_VM_TYPES:
-		r = BIT(KVM_X86_DEFAULT_VM);
-		if (kvm_is_vm_type_supported(KVM_X86_SW_PROTECTED_VM))
-			r |= BIT(KVM_X86_SW_PROTECTED_VM);
+		r = kvm_caps.supported_vm_types;
 		break;
 	default:
 		break;
@@ -9829,6 +9826,9 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 
 	kvm_register_perf_callbacks(ops->handle_intel_pt_intr);
 
+	if (IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_mmu_enabled)
+		kvm_caps.supported_vm_types |= BIT(KVM_X86_SW_PROTECTED_VM);
+
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		kvm_caps.supported_xss = 0;
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a8b71803777b..d80a4c6b5a38 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -24,6 +24,8 @@ struct kvm_caps {
 	bool has_bus_lock_exit;
 	/* notify VM exit supported? */
 	bool has_notify_vmexit;
+	/* bit mask of VM types */
+	u32 supported_vm_types;
 
 	u64 supported_mce_cap;
 	u64 supported_xcr0;
-- 
2.43.0



