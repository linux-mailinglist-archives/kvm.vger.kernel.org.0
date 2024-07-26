Return-Path: <kvm+bounces-22336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51D3593D89D
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:52:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 748A61C20DCB
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 18:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC0D355892;
	Fri, 26 Jul 2024 18:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ItBUkJfa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0763032A
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 18:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722019927; cv=none; b=dbGNO2VLXt7Jwe5gTUKDzYN6MS8bQqneR+qsdevyMuW8lF2iMcdwL/hWsE5WGFbK1StHK1+B3Drj83CRdnRRnHESBrKwGWX//tdwotceSGHxarUSdHYvK9+8kq72CCjBmspTb9Ekt61nZOvDhuF9sI3DhfsDQNaaLnIvPzc3/Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722019927; c=relaxed/simple;
	bh=O26rJ7Gcfv4ARMLR28jWxqFOljVbUnxyI2aeb/KHyHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O/8FG7PqYXv8ZBlcOMJPMNotJFlB0/n6/Of4IZ/vatZn0Dtc6VewwbSf/0ogrHBrxsnLK/4KQKTDRCIDdpD8lLKqlQ3UmYRgTJu15qszulbMXL1R095QIA2lrBI8SAL2I7aM3G7ofc51+WKhfLTVXpxPgtRAggs9A1YBVBTAbjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ItBUkJfa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722019924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nzd3Ramz8UsVExhcniTAeg+8/OlVGantjS5vCPA9244=;
	b=ItBUkJfah1i9WtgxHQ5z2U6QIgEqaJWi7DIfYtUz6uX7iaNdBTGYnawHefIVPV0rX/q86T
	YeNZJDsQ66BZQrcIntplYeksHqkI2o7+G0/43/dVfomRRrYEyHZFsO0J6sNWC0EhMzOsSA
	+d3YCyrJTxBmI09octibXscEjFUQBpQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-12-8IdCqyXBOUWxMALqfQablw-1; Fri,
 26 Jul 2024 14:52:00 -0400
X-MC-Unique: 8IdCqyXBOUWxMALqfQablw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFFD419560AD;
	Fri, 26 Jul 2024 18:51:59 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0048E3000194;
	Fri, 26 Jul 2024 18:51:58 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com
Subject: [PATCH v2 01/14] KVM: x86: disallow pre-fault for SNP VMs before initialization
Date: Fri, 26 Jul 2024 14:51:44 -0400
Message-ID: <20240726185157.72821-2-pbonzini@redhat.com>
In-Reply-To: <20240726185157.72821-1-pbonzini@redhat.com>
References: <20240726185157.72821-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

KVM_PRE_FAULT_MEMORY for an SNP guest can race with
sev_gmem_post_populate() in bad ways. The following sequence for
instance can potentially trigger an RMP fault:

  thread A, sev_gmem_post_populate: called
  thread B, sev_gmem_prepare: places below 'pfn' in a private state in RMP
  thread A, sev_gmem_post_populate: *vaddr = kmap_local_pfn(pfn + i);
  thread A, sev_gmem_post_populate: copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE);
  RMP #PF

Fix this by only allowing KVM_PRE_FAULT_MEMORY to run after a guest's
initial private memory contents have been finalized via
KVM_SEV_SNP_LAUNCH_FINISH.

Beyond fixing this issue, it just sort of makes sense to enforce this,
since the KVM_PRE_FAULT_MEMORY documentation states:

  "KVM maps memory as if the vCPU generated a stage-2 read page fault"

which sort of implies we should be acting on the same guest state that a
vCPU would see post-launch after the initial guest memory is all set up.

Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst  | 6 ++++++
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu/mmu.c          | 3 +++
 arch/x86/kvm/svm/sev.c          | 8 ++++++++
 arch/x86/kvm/svm/svm.c          | 1 +
 arch/x86/kvm/x86.c              | 3 +++
 6 files changed, 22 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ec1cd8aa1d56..7b512286f8d2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6402,6 +6402,12 @@ for the current vCPU state.  KVM maps memory as if the vCPU generated a
 stage-2 read page fault, e.g. faults in memory as needed, but doesn't break
 CoW.  However, KVM does not mark any newly created stage-2 PTE as Accessed.
 
+In the case of confidential VM types where there is an initial set up of
+private guest memory before the guest is 'finalized'/measured, this ioctl
+should only be issued after completing all the necessary setup to put the
+guest into a 'finalized' state so that the above semantics can be reliably
+ensured.
+
 In some cases, multiple vCPUs might share the page tables.  In this
 case, the ioctl can be called in parallel.
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 950a03e0181e..94e7b5a4fafe 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1305,6 +1305,7 @@ struct kvm_arch {
 	u8 vm_type;
 	bool has_private_mem;
 	bool has_protected_state;
+	bool pre_fault_allowed;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct list_head active_mmu_pages;
 	struct list_head zapped_obsolete_pages;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 901be9e420a4..26ef5b6ac3c1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4743,6 +4743,9 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 	u64 end;
 	int r;
 
+	if (!vcpu->kvm->arch.pre_fault_allowed)
+		return -EOPNOTSUPP;
+
 	/*
 	 * reload is efficient when called repeatedly, so we can do it on
 	 * every iteration.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a16c873b3232..6589091e8ce0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2549,6 +2549,14 @@ static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	data->gctx_paddr = __psp_pa(sev->snp_context);
 	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_LAUNCH_FINISH, data, &argp->error);
 
+	/*
+	 * Now that there will be no more SNP_LAUNCH_UPDATE ioctls, private pages
+	 * can be given to the guest simply by marking the RMP entry as private.
+	 * This can happen on first access and also with KVM_PRE_FAULT_MEMORY.
+	 */
+	if (!ret)
+		kvm->arch.pre_fault_allowed = true;
+
 	kfree(id_auth);
 
 e_free_id_block:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c115d26844f7..d6f252555ab3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4949,6 +4949,7 @@ static int svm_vm_init(struct kvm *kvm)
 		to_kvm_sev_info(kvm)->need_init = true;
 
 		kvm->arch.has_private_mem = (type == KVM_X86_SNP_VM);
+		kvm->arch.pre_fault_allowed = !kvm->arch.has_private_mem;
 	}
 
 	if (!pause_filter_count || !pause_filter_thresh)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af6c8cf6a37a..52778689cef4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12646,6 +12646,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.vm_type = type;
 	kvm->arch.has_private_mem =
 		(type == KVM_X86_SW_PROTECTED_VM);
+	/* Decided by the vendor code for other VM types.  */
+	kvm->arch.pre_fault_allowed =
+		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
 
 	ret = kvm_page_track_init(kvm);
 	if (ret)
-- 
2.43.0



