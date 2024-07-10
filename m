Return-Path: <kvm+bounces-21334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B90992D7A5
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 19:43:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7954E1C21051
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 17:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 537AE198E82;
	Wed, 10 Jul 2024 17:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LjjDt8qn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8463198A04
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 17:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720633248; cv=none; b=GuCBFQwen36ljbzodNRM6jJFCOEbyf/jLJUmJ0CymQqo1b2zcNb4FrdhcvdFnPFp9lh+mzSRx9n5OQp5qozZ6Ox1XKaEpn5W8nh7JPpFNG2WJZqJz158MyEnp7JCVigxd93D8+yLdMUIcxblTgj3Gh3Eigf82IVAG1AAye6uohQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720633248; c=relaxed/simple;
	bh=SLCbLZ2fsRQrz81AqEZCVxE8qxBSDW1oBKuziDjLkvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fk1fdEOh9X7m9gQVSGUbBj65BfkhgFV981vEbRfuHLEbmpmvXMo+6cR2S8qUP90X5pIEH4bBc3MhsBLN0y1gEuIgK81AVX5DWbhNQRHc7erKPx6Uoe/FEwGF7WYtHGFBTUiyw7y9Z8MUH67pReJ/BIt+AoGVI4LS1d169Y067J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LjjDt8qn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720633245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q4vq3mIqkBL4D04jFljxIa+jGguUlOm2J3Ybvq/yOc4=;
	b=LjjDt8qn+iPrgNFFITNYZlxzYim53K5mnBCKhdUtYi12kMYQYq2XVinwJ+kCl6cLT+ixK1
	8oH4Eh51ppNqWEKPG3Pk3lnd30WJk9z1L2pYbH/rkH/trV7JMwsndKWZwMUjnVQ1GAa2TL
	Oha3eYMQAqI+YtUTVZKTohokTwQ+dzk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-228-vil4kTo-NxmxX9ap-yc73A-1; Wed,
 10 Jul 2024 13:40:40 -0400
X-MC-Unique: vil4kTo-NxmxX9ap-yc73A-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1F371955F44;
	Wed, 10 Jul 2024 17:40:38 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BBFE51955E85;
	Wed, 10 Jul 2024 17:40:37 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	seanjc@google.com,
	binbin.wu@linux.intel.com,
	xiaoyao.li@intel.com
Subject: [PATCH v5 6/7] KVM: x86: Implement kvm_arch_vcpu_pre_fault_memory()
Date: Wed, 10 Jul 2024 13:40:30 -0400
Message-ID: <20240710174031.312055-7-pbonzini@redhat.com>
In-Reply-To: <20240710174031.312055-1-pbonzini@redhat.com>
References: <20240710174031.312055-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Wire KVM_PRE_FAULT_MEMORY ioctl to __kvm_mmu_do_page_fault() to populate guest
memory.  It can be called right after KVM_CREATE_VCPU creates a vCPU,
since at that point kvm_mmu_create() and kvm_init_mmu() are called and
the vCPU is ready to invoke the KVM page fault handler.

The helper function kvm_mmu_map_tdp_page take care of the logic to
process RET_PF_* return values and convert them to success or errno.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Message-ID: <9b866a0ae7147f96571c439e75429a03dcb659b6.1712785629.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/Kconfig   |  1 +
 arch/x86/kvm/mmu/mmu.c | 73 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c     |  3 ++
 3 files changed, 77 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 80e5afde69f4..4287a8071a3a 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -44,6 +44,7 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
+	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_WERROR if WERROR
 	help
 	  Support hosting fully virtualized guest machines using hardware
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 152b30fa22ad..4e0e9963066f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4709,6 +4709,79 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
+static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
+			    u8 *level)
+{
+	int r;
+
+	/*
+	 * Restrict to TDP page fault, since that's the only case where the MMU
+	 * is indexed by GPA.
+	 */
+	if (vcpu->arch.mmu->page_fault != kvm_tdp_page_fault)
+		return -EOPNOTSUPP;
+
+	do {
+		if (signal_pending(current))
+			return -EINTR;
+		cond_resched();
+		r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
+	} while (r == RET_PF_RETRY);
+
+	if (r < 0)
+		return r;
+
+	switch (r) {
+	case RET_PF_FIXED:
+	case RET_PF_SPURIOUS:
+		return 0;
+
+	case RET_PF_EMULATE:
+		return -ENOENT;
+
+	case RET_PF_RETRY:
+	case RET_PF_CONTINUE:
+	case RET_PF_INVALID:
+	default:
+		WARN_ONCE(1, "could not fix page fault during prefault");
+		return -EIO;
+	}
+}
+
+long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
+				    struct kvm_pre_fault_memory *range)
+{
+	u64 error_code = PFERR_GUEST_FINAL_MASK;
+	u8 level = PG_LEVEL_4K;
+	u64 end;
+	int r;
+
+	/*
+	 * reload is efficient when called repeatedly, so we can do it on
+	 * every iteration.
+	 */
+	kvm_mmu_reload(vcpu);
+
+	if (kvm_arch_has_private_mem(vcpu->kvm) &&
+	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))
+		error_code |= PFERR_PRIVATE_ACCESS;
+
+	/*
+	 * Shadow paging uses GVA for kvm page fault, so restrict to
+	 * two-dimensional paging.
+	 */
+	r = kvm_tdp_map_page(vcpu, range->gpa, error_code, &level);
+	if (r < 0)
+		return r;
+
+	/*
+	 * If the mapping that covers range->gpa can use a huge page, it
+	 * may start below it or end after range->gpa + range->size.
+	 */
+	end = (range->gpa & KVM_HPAGE_MASK(level)) + KVM_HPAGE_SIZE(level);
+	return min(range->size, end - range->gpa);
+}
+
 static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ba0ad76f53bc..a6968eadd418 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4705,6 +4705,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MEMORY_FAULT_INFO:
 		r = 1;
 		break;
+	case KVM_CAP_PRE_FAULT_MEMORY:
+		r = tdp_enabled;
+		break;
 	case KVM_CAP_EXIT_HYPERCALL:
 		r = KVM_EXIT_HYPERCALL_VALID_MASK;
 		break;
-- 
2.43.0



