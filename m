Return-Path: <kvm+bounces-36572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B75CA1BCA0
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 20:11:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF92D160FA3
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 19:11:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20F82224AE9;
	Fri, 24 Jan 2025 19:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SPpG9wuk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1541D54D8
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 19:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737745878; cv=none; b=uJzkf05crLYZ22jYkvZC5lAwTrtBIJycvCDq2pGqvHOqW20L2CyaseNom217j8hRV4ou8gHIuGE/B2k20yAlj9QgVWx1oIP/A+r3ZA+RmYrUlEErf0CMMjN3DFIHBR05vSpozTywnQuIkgxndXaUChZvRAZwTyfdmi5ue0Sln/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737745878; c=relaxed/simple;
	bh=RH92absaKrUE4bK8EtgJ/YFwduM51bFN3OmBTnhDyMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S+XWvCT1JNMr/ViCW2sowfOpYirnYAJiQuDuzMVCvA6eVJgpqMf7qT4frwjZE9GFu7/cgbmT1lct06NB3AJ6VHyf1jdp09Jg5nfeYP/dGGUsRlCrcCfnUPRW4dGLaFrVy6Jge+yxvk0gYJbouhHquItsol/cznm2+702gnKmvj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SPpG9wuk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737745874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ofob11nRTehHhQisKN8w0H93BnkkEyEmB8UI4f7CYrE=;
	b=SPpG9wukS794nTe0PnJgXMXiTZCOyNPc6ChnABkm6+e5WN6P/ILnP6xZ46v7z57qLBxMS8
	fcj2AHcCtGPqKG7694MUZn4JPJ99/T+A6gsFrUYlJ9HV8cfvuz9PpHv16g7sCFJNQcNVUq
	hpoLr/TJTRfj48dkeDNO829Z1yJqpJc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-T0eB1zQrOEyrP1ugJ2J6dQ-1; Fri,
 24 Jan 2025 14:11:12 -0500
X-MC-Unique: T0eB1zQrOEyrP1ugJ2J6dQ-1
X-Mimecast-MFC-AGG-ID: T0eB1zQrOEyrP1ugJ2J6dQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AEA801955DD5;
	Fri, 24 Jan 2025 19:11:11 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1529719560A7;
	Fri, 24 Jan 2025 19:11:10 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com
Subject: [PATCH 1/2] KVM: x86: fix usage of kvm_lock in set_nx_huge_pages()
Date: Fri, 24 Jan 2025 14:11:08 -0500
Message-ID: <20250124191109.205955-2-pbonzini@redhat.com>
In-Reply-To: <20250124191109.205955-1-pbonzini@redhat.com>
References: <20250124191109.205955-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Protect the whole function with kvm_lock() so that all accesses to
nx_hugepage_mitigation_hard_disabled are under the lock; but drop it
when calling out to the MMU to avoid complex circular locking
situations such as the following:

__kvm_set_memory_region()
  lock(&kvm->slots_lock)
                           set_nx_huge_pages()
                             lock(kvm_lock)
                             lock(&kvm->slots_lock)
                                                     __kvmclock_cpufreq_notifier()
                                                       lock(cpu_hotplug_lock)
                                                       lock(kvm_lock)
                                                                                   lock(&kvm->srcu)
                                                                                   kvm_lapic_set_base()
                                                                                     static_branch_inc()
                                                                                       lock(cpu_hotplug_lock)
  sync(&kvm->srcu)

The deadlock is basically theoretical but anyway it is as follows:
- __kvm_set_memory_region() waits for kvm->srcu with kvm->slots_lock taken
- set_nx_huge_pages() waits for kvm->slots_lock with kvm_lock taken
- __kvmclock_cpufreq_notifier() waits for kvm_lock with cpu_hotplug_lock taken
- KVM_RUN waits for cpu_hotplug_lock with kvm->srcu taken
- therefore __kvm_set_memory_region() never completes synchronize_srcu(&kvm->srcu).

To break the deadlock, release kvm_lock while taking kvm->slots_lock, which
breaks the chain:

  lock(&kvm->slots_lock)
                           set_nx_huge_pages()
                             lock(kvm_lock)
                                                     __kvmclock_cpufreq_notifier()
                                                       lock(cpu_hotplug_lock)
                                                       lock(kvm_lock)
                                                                                   lock(&kvm->srcu)
                                                                                   kvm_lapic_set_base()
                                                                                     static_branch_inc()
                                                                                       lock(cpu_hotplug_lock)
                             unlock(kvm_lock)
                                                       unlock(kvm_lock)
                                                       unlock(cpu_hotplug_lock)
                                                                                       unlock(cpu_hotplug_lock)
                                                                                   unlock(&kvm->srcu)
                             lock(&kvm->slots_lock)
  sync(&kvm->srcu)
  unlock(&kvm->slots_lock)
                             unlock(&kvm->slots_lock)

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2401606db260..1d8b45e7bb94 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7114,6 +7114,7 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 	bool old_val = nx_huge_pages;
 	bool new_val;
 
+	guard(mutex)(&kvm_lock);
 	if (nx_hugepage_mitigation_hard_disabled)
 		return -EPERM;
 
@@ -7127,13 +7128,10 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 	} else if (sysfs_streq(val, "never")) {
 		new_val = 0;
 
-		mutex_lock(&kvm_lock);
 		if (!list_empty(&vm_list)) {
-			mutex_unlock(&kvm_lock);
 			return -EBUSY;
 		}
 		nx_hugepage_mitigation_hard_disabled = true;
-		mutex_unlock(&kvm_lock);
 	} else if (kstrtobool(val, &new_val) < 0) {
 		return -EINVAL;
 	}
@@ -7143,16 +7141,19 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 	if (new_val != old_val) {
 		struct kvm *kvm;
 
-		mutex_lock(&kvm_lock);
-
 		list_for_each_entry(kvm, &vm_list, vm_list) {
+			kvm_get_kvm(kvm);
+			mutex_unlock(&kvm_lock);
+
 			mutex_lock(&kvm->slots_lock);
 			kvm_mmu_zap_all_fast(kvm);
 			mutex_unlock(&kvm->slots_lock);
 
 			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
+
+			mutex_lock(&kvm_lock);
+			kvm_put_kvm(kvm);
 		}
-		mutex_unlock(&kvm_lock);
 	}
 
 	return 0;
-- 
2.43.5



