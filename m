Return-Path: <kvm+bounces-39973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2024A4D367
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 07:07:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BC4316C89C
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA5071F4E34;
	Tue,  4 Mar 2025 06:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AGp97W5P"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB251F416B
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 06:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741068419; cv=none; b=D/6w7//HKAhtYDw7pI1xnxVZN49e6QIsWrUg7yXTfJ1er2xAvzZKTgjCoY3SN/xuGDABUff9787gA6NhGjPHg8aRSGFynIHeSuC5ACstnaZfIsvzHuefi8A9wj2/9jPZ4JI3pMEjXT+TYTxNv1JTutUhsCpJKxDkxdnMsk6QuXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741068419; c=relaxed/simple;
	bh=zvgqYsvXfHBAbcwouYdhkWdgIpLZPjfAPKvtaSIXKwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ngjCNVamXWibiRNE1FSDVDYVzsrU26V/6Y3HjMsh0v2IDq4sJQ8Dt1igI+xOsC9wVa8PzYvteQvLeRWP8tyc8tJHQsawx2f+X7ECKVc3b2q2/htA0gkojHBo6+/4SU9zQzmRQdOnhTUP1U2ubIJ4wJjxoAbJJfsBaHQRzs7/WK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AGp97W5P; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741068416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=meP3mPi7wbZh3Prgz68X3gfGckV8RM5QhsxHPX6Pr9A=;
	b=AGp97W5PtYdCfzT3ZctTR68JWWTsqAQFw/hNgyYtLiX1cPcm/aTNjiSF0606NLKxiVTesW
	i1H1A8AOzuBbSxuhxJSlmy76E2cyVBs0W5HWsvou+d5vF7/2VZZXRQRdKbOTBbE++LF7Jn
	MIrm0HlbzGObE6+IKi7T0pOTaWTSIXs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-216-kBPcdYSTOk2T7jMM02yEqQ-1; Tue,
 04 Mar 2025 01:06:52 -0500
X-MC-Unique: kBPcdYSTOk2T7jMM02yEqQ-1
X-Mimecast-MFC-AGG-ID: kBPcdYSTOk2T7jMM02yEqQ_1741068411
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 661291918165;
	Tue,  4 Mar 2025 06:06:51 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8633F19560A3;
	Tue,  4 Mar 2025 06:06:50 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	seanjc@google.com,
	yan.y.zhao@intel.com
Subject: [PATCH v3 2/6] KVM: x86: Allow vendor code to disable quirks
Date: Tue,  4 Mar 2025 01:06:43 -0500
Message-ID: <20250304060647.2903469-3-pbonzini@redhat.com>
In-Reply-To: <20250304060647.2903469-1-pbonzini@redhat.com>
References: <20250304060647.2903469-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

In some cases, the handling of quirks is split between platform-specific
code and generic code, or it is done entirely in generic code, but the
relevant bug does not trigger on some platforms; for example,
this will be the case for "ignore guest PAT".  Allow unaffected vendor
modules to disable handling of a quirk for all VMs via a new entry in
kvm_caps.

Such quirks remain available in KVM_CAP_DISABLE_QUIRKS2, because that API
tells userspace that KVM *knows* that some of its past behavior was bogus
or just undesirable.  In other words, it's plausible for userspace to
refuse to run if a quirk is not listed by KVM_CAP_DISABLE_QUIRKS2, so
preserve that and make it part of the API.

As an example, mark KVM_X86_QUIRK_CD_NW_CLEARED as auto-disabled on
Intel systems.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 3 +++
 arch/x86/kvm/svm/svm.c          | 1 +
 arch/x86/kvm/x86.c              | 2 ++
 arch/x86/kvm/x86.h              | 1 +
 4 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7ebbedc566ff..a4f213d235dd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2420,6 +2420,9 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 	 KVM_X86_QUIRK_SLOT_ZAP_ALL |		\
 	 KVM_X86_QUIRK_STUFF_FEATURE_MSRS)
 
+#define KVM_X86_CONDITIONAL_QUIRKS		\
+	 KVM_X86_QUIRK_CD_NW_CLEARED
+
 /*
  * KVM previously used a u32 field in kvm_run to indicate the hypercall was
  * initiated from long mode. KVM now sets bit 0 to indicate long mode, but the
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ebaa5a41db07..51cfef44b58d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5426,6 +5426,7 @@ static __init int svm_hardware_setup(void)
 	 */
 	allow_smaller_maxphyaddr = !npt_enabled;
 
+	kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_CD_NW_CLEARED;
 	return 0;
 
 err:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 35d03fcdb8e9..5abea6c73a38 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9775,6 +9775,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
 	}
+	kvm_caps.inapplicable_quirks = KVM_X86_CONDITIONAL_QUIRKS;
 
 	rdmsrl_safe(MSR_EFER, &kvm_host.efer);
 
@@ -12754,6 +12755,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.apic_bus_cycle_ns = APIC_BUS_CYCLE_NS_DEFAULT;
 	kvm->arch.guest_can_read_msr_platform_info = true;
 	kvm->arch.enable_pmu = enable_pmu;
+	kvm->arch.disabled_quirks = kvm_caps.inapplicable_quirks;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 8ce6da98b5a2..221778792c3c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -34,6 +34,7 @@ struct kvm_caps {
 	u64 supported_xcr0;
 	u64 supported_xss;
 	u64 supported_perf_cap;
+	u64 inapplicable_quirks;
 };
 
 struct kvm_host_values {
-- 
2.43.5



