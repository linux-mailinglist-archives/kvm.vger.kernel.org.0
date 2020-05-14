Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06EA01D38D2
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 20:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgENSGA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 14:06:00 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55248 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726444AbgENSF4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 14:05:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589479555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j0jX4S3xcP8FeurtghgmIUcBDnvQJ3FkSTFSnx7A6Wo=;
        b=I8bxNCzYHhKKutJKdQchAz083oEtl8iw3ZBKvsIJf3CPkZ/poGaD4FxvzSM2gqYVuroSEr
        DNe5nt15g8fAxJsYkoDeEdYB2+/jQZ7OiUd3Hoy36BQgq1+UNWwr/iBRHtvgUSloBspTAB
        Gk6NdB9FFP1Cj+vnKUR5mqPZKwOO8GM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-I0NGR2hFPLyIEK5uTeGS9Q-1; Thu, 14 May 2020 14:05:52 -0400
X-MC-Unique: I0NGR2hFPLyIEK5uTeGS9Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B70FE107ACCD;
        Thu, 14 May 2020 18:05:50 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.178])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB6705D9CA;
        Thu, 14 May 2020 18:05:47 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: [PATCH RFC 1/5] KVM: rename labels in kvm_init()
Date:   Thu, 14 May 2020 20:05:36 +0200
Message-Id: <20200514180540.52407-2-vkuznets@redhat.com>
In-Reply-To: <20200514180540.52407-1-vkuznets@redhat.com>
References: <20200514180540.52407-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Label names in kvm_init() are horrible, rename them to make it obvious
what we are going to do on the failure path.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 virt/kvm/kvm_main.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 33e1eee96f75..892ea0b9087e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4674,7 +4674,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 
 	r = kvm_arch_init(opaque);
 	if (r)
-		goto out_fail;
+		return r;
 
 	/*
 	 * kvm_arch_init makes sure there's at most one caller
@@ -4685,29 +4685,29 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	 */
 	r = kvm_irqfd_init();
 	if (r)
-		goto out_irqfd;
+		goto out_arch_exit;
 
 	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
 		r = -ENOMEM;
-		goto out_free_0;
+		goto out_irqfd_exit;
 	}
 
 	r = kvm_arch_hardware_setup(opaque);
 	if (r < 0)
-		goto out_free_1;
+		goto out_free_hardware_enabled;
 
 	c.ret = &r;
 	c.opaque = opaque;
 	for_each_online_cpu(cpu) {
 		smp_call_function_single(cpu, check_processor_compat, &c, 1);
 		if (r < 0)
-			goto out_free_2;
+			goto out_free_hardware_unsetup;
 	}
 
 	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
 				      kvm_starting_cpu, kvm_dying_cpu);
 	if (r)
-		goto out_free_2;
+		goto out_free_hardware_unsetup;
 	register_reboot_notifier(&kvm_reboot_notifier);
 
 	/* A kmem cache lets us meet the alignment requirements of fx_save. */
@@ -4721,12 +4721,12 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 					   NULL);
 	if (!kvm_vcpu_cache) {
 		r = -ENOMEM;
-		goto out_free_3;
+		goto out_free_cpuhp_unregister;
 	}
 
 	r = kvm_async_pf_init();
 	if (r)
-		goto out_free;
+		goto out_free_vcpu_cache;
 
 	kvm_chardev_ops.owner = module;
 	kvm_vm_fops.owner = module;
@@ -4735,7 +4735,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	r = misc_register(&kvm_dev);
 	if (r) {
 		pr_err("kvm: misc device register failed\n");
-		goto out_unreg;
+		goto out_async_pf_deinit;
 	}
 
 	register_syscore_ops(&kvm_syscore_ops);
@@ -4750,22 +4750,21 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 
 	return 0;
 
-out_unreg:
+out_async_pf_deinit:
 	kvm_async_pf_deinit();
-out_free:
+out_free_vcpu_cache:
 	kmem_cache_destroy(kvm_vcpu_cache);
-out_free_3:
+out_free_cpuhp_unregister:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
-out_free_2:
+out_free_hardware_unsetup:
 	kvm_arch_hardware_unsetup();
-out_free_1:
+out_free_hardware_enabled:
 	free_cpumask_var(cpus_hardware_enabled);
-out_free_0:
+out_irqfd_exit:
 	kvm_irqfd_exit();
-out_irqfd:
+out_arch_exit:
 	kvm_arch_exit();
-out_fail:
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_init);
-- 
2.25.4

