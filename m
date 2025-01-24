Return-Path: <kvm+bounces-36553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61891A1BAB9
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 17:39:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 228033A0FA6
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 16:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9A941AAA09;
	Fri, 24 Jan 2025 16:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CEsvFJQ8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7591A00EC
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 16:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737736773; cv=none; b=ksVaHEFIshDXC/6G8RJ+Kh+7y0e+d1mf+gPtzJ4PKTmRvbsbz3KFjw1oGVgnIEFUTF1kXKPQVKkaJryoHng0qsay+SgJTqoMwyfJvfFvyQKp5k999s/QeXzZzsqmD5LhHLb/fhHcQxAYrt3LHjRJN0SvUfhB0qwE9Fv8LiZBOI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737736773; c=relaxed/simple;
	bh=fKUGWnRo5vMXwEdo4cuhGuaCAcylpvkrScVneRRhFOk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SAX3EJVT8A6uo4QvVY3L/dXogYTspWD1JHsyPTDbAGDw4DffPbsdznxLDicL+H51w57+cmotRjW4b6v4sZm8noNjwzc+UR+4v31GG8EPgTXDBjCZL0uyMilfws6JoOyfzrGaAMhzJAUft3KMzKnjaoDXt/yLuc1wvR8znJO/Jow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CEsvFJQ8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737736770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jAsGeGFgg6GQS89Ct8sHy40GnK2j33JaffVJnKtn/jw=;
	b=CEsvFJQ8hH5XagTBlus2g2hhzOVfPKmoAZA6B1mdROJLhQybuIccBv4CAmrvTRNDit19NB
	prfYTSb65SSHd8+8A7pOVXD+BhGhkaJn/zoY2B1t3wwdwgbvLYLTJ+E3MFH2HjzlJexIp5
	lSZQmivcXcK4/tJjOGG7kKrio18hxU8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-16-wGq_K2NzOOaG8RFM-0iWIA-1; Fri,
 24 Jan 2025 11:39:21 -0500
X-MC-Unique: wGq_K2NzOOaG8RFM-0iWIA-1
X-Mimecast-MFC-AGG-ID: wGq_K2NzOOaG8RFM-0iWIA
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F09A1A2F4DC;
	Fri, 24 Jan 2025 16:00:41 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AD0A51800348;
	Fri, 24 Jan 2025 16:00:40 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kbusch@kernel.org
Subject: [PATCH] KVM: remove kvm_arch_post_init_vm
Date: Fri, 24 Jan 2025 11:00:39 -0500
Message-ID: <20250124160039.95808-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

The only statement in a kvm_arch_post_init_vm implementation
can be moved into the x86 kvm_arch_init_vm.  Do so and remove all
traces from architecture-independent code.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c       |  7 +------
 include/linux/kvm_host.h |  1 -
 virt/kvm/kvm_main.c      | 15 ---------------
 3 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6d4a6734b2d6..8e77e61d4fbd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12741,6 +12741,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 			     "does not run without ignore_msrs=1, please report it to kvm@vger.kernel.org.\n");
 	}
 
+	once_init(&kvm->arch.nx_once);
 	return 0;
 
 out_uninit_mmu:
@@ -12750,12 +12751,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return ret;
 }
 
-int kvm_arch_post_init_vm(struct kvm *kvm)
-{
-	once_init(&kvm->arch.nx_once);
-	return 0;
-}
-
 static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 {
 	vcpu_load(vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3cb9a32a6330..f34f4cfaa513 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1615,7 +1615,6 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu);
-int kvm_arch_post_init_vm(struct kvm *kvm);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 void kvm_arch_create_vm_debugfs(struct kvm *kvm);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index faf10671eed2..add042839823 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1070,15 +1070,6 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 	return ret;
 }
 
-/*
- * Called after the VM is otherwise initialized, but just before adding it to
- * the vm_list.
- */
-int __weak kvm_arch_post_init_vm(struct kvm *kvm)
-{
-	return 0;
-}
-
 /*
  * Called just after removing the VM from the vm_list, but before doing any
  * other destruction.
@@ -1199,10 +1190,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_debugfs;
 
-	r = kvm_arch_post_init_vm(kvm);
-	if (r)
-		goto out_err;
-
 	mutex_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	mutex_unlock(&kvm_lock);
@@ -1212,8 +1199,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 
 	return kvm;
 
-out_err:
-	kvm_destroy_vm_debugfs(kvm);
 out_err_no_debugfs:
 	kvm_coalesced_mmio_free(kvm);
 out_no_coalesced_mmio:
-- 
2.43.5


