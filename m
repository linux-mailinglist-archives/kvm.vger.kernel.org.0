Return-Path: <kvm+bounces-15215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D07A68AAB0F
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 11:00:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 466EF1F21C6E
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 09:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9329A7E579;
	Fri, 19 Apr 2024 08:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X+/h6Z63"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB5E76056
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 08:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713517176; cv=none; b=WWjiyiw9BEnu9BuFJkPoKyyCKO3rv8zuZkKHorvK1igFFnzophgWeGdizO4zKXQrOgSl8E8yEki04Z2VaA4QT5Qrmk+eXZ4AxfeZvyzZtMr+JPxjxX8V6mB61W6rL3Xto5VdG8CbfoF4COZPeF5Jn8G/1rUDM9PCxtYi228QVPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713517176; c=relaxed/simple;
	bh=p0m1HZy9UGhgenBFAgKeYWbF5X6HK5fP4nR7XaO2UKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X8loFUAzN7eWPuZ3mBNRoZoN2orZTi2nqo6pMHi/8uUVWqGVCiX/bs5LPcrehgYG/XgHOwiew5skScZc1FVVzvUl+ZUXZ/6lElkVvYlLvdA4ildBENsGmfm8sbqyhsGnkGv3cHdxh0FbSmCBOQFEbpndI5zSCKfmxm5/V9KyjmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X+/h6Z63; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713517174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nBDAnD8rwFNbWbPY9L0LNNm2QshByyJ5ytYISZegYXU=;
	b=X+/h6Z637HO9JDWcI3Rt6g5IknT8b11Gr9hoUh2HrzoxLdvlAj4bNhoLBc5k9lUZerlpap
	gJV/Ftmd6injvR56tt1uXbz5yJbJamtAhD7nPkuw8MghsdY5hdD8dH7OmDwLRQ8fSQpNrO
	0sLZKhYm3KoWwR9B+oovAdcFC8/P3CY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-155-YpT6iWRLNxe--xzwEC86Ng-1; Fri,
 19 Apr 2024 04:59:30 -0400
X-MC-Unique: YpT6iWRLNxe--xzwEC86Ng-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4B702812FE9;
	Fri, 19 Apr 2024 08:59:29 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7389F20368A4;
	Fri, 19 Apr 2024 08:59:29 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 5/6] KVM: x86: Implement kvm_arch_vcpu_pre_fault_memory()
Date: Fri, 19 Apr 2024 04:59:26 -0400
Message-ID: <20240419085927.3648704-6-pbonzini@redhat.com>
In-Reply-To: <20240419085927.3648704-1-pbonzini@redhat.com>
References: <20240419085927.3648704-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

From: Isaku Yamahata <isaku.yamahata@intel.com>

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
 arch/x86/kvm/mmu/mmu.c | 72 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c     |  3 ++
 3 files changed, 76 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 7632fe6e4db9..54c155432793 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -44,6 +44,7 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
+	select KVM_GENERIC_PRE_FAULT_MEMORY
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 10e90788b263..a045b23964c0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4647,6 +4647,78 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
+static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
+		     u8 *level)
+{
+	int r;
+
+	/* Restrict to TDP page fault. */
+	if (vcpu->arch.mmu->page_fault != kvm_tdp_page_fault)
+		return -EOPNOTSUPP;
+
+retry:
+	r = __kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
+	if (r < 0)
+		return r;
+
+	switch (r) {
+	case RET_PF_RETRY:
+		if (signal_pending(current))
+			return -EINTR;
+		cond_resched();
+		goto retry;
+
+	case RET_PF_FIXED:
+	case RET_PF_SPURIOUS:
+		break;
+
+	case RET_PF_EMULATE:
+		return -ENOENT;
+
+	case RET_PF_CONTINUE:
+	case RET_PF_INVALID:
+	default:
+		WARN_ON_ONCE(r);
+		return -EIO;
+	}
+
+	return 0;
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
index 83b8260443a3..619ad713254e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4715,6 +4715,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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



