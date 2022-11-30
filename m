Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B3063E44F
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiK3XJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiK3XJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:09:41 -0500
Received: from mail-oa1-x4a.google.com (mail-oa1-x4a.google.com [IPv6:2001:4860:4864:20::4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E555C0C2
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:09:40 -0800 (PST)
Received: by mail-oa1-x4a.google.com with SMTP id 586e51a60fabf-1425df74ab4so110722fac.10
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ol+f04sMmomAVy3XzqNXK+ShxWrn6gIN96B7OKl5yaM=;
        b=S5armvpc10OdJc+V4p2ZjsfPOSB2+gt+Iv6GXjLvIxarCpnvSzXAszP1ZRQLfxrpVn
         4VKntdMIRcH9d5x9XG1oGb5HbZFayk+JATeZBYQSlvM+DpwmfecZQ8AsDtvEHJv8Um6T
         UA3gJNgXD7v57R6+HWMBuEe+F5z07hORTUOLfSKyijFbwT8eHearvUCVMdt7/m5zjOT/
         RJHYTQwmhGaPhaOc8DfHyXLVsjojQiPBCzNQuFpX8g3cosCwY+5F+o1XrOjsJNDhsv4X
         dI+LD+RMI6RHxUg1kkU/xRepaC5EvnuL3x5vvCzRlD3QPj+jjInfZWGepttgPw2FHtVt
         S1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ol+f04sMmomAVy3XzqNXK+ShxWrn6gIN96B7OKl5yaM=;
        b=z3GYlOS/WEMFeamcljc9Qbt9gINp+b60b08aU1JNyrwp0/W9fcdyaxvOpeq1eCRkRh
         NuCAnJiKE4sPTqSHCgtCdYxcEFeQW9QX+6+yJ2tNXnwWsZzjZwq/o9jvIinkn1PTt6Uw
         Y8WyGkkm3lrwJ8eMNb+O3pPEeRDIcaZm+vmihwVDZaye/96hwfVaEujppxDkM7slGjm+
         +9crdLlOVER/tUCKPkv2If9XslKi/62eFUAaeI3hkMPrhBdL/v2/N5xwBYWiE7jX7kV4
         erqeIYzVME2647uonMlqhoEKkXhTaWo6lPWI0qBky152ief8Cfk5N5KGm1Ej6nKfLnnG
         tbQA==
X-Gm-Message-State: ANoB5pm2kl8HU3o0Tp9qlMHI54W3xNCa+WbGX1B4V8Evc7BJx73fK6jY
        8ZcQDdcSn0unCdNB7Rd6gi2gUABjLSc=
X-Google-Smtp-Source: AA0mqf5M2pMTumXNgDe8Hfk4OhWDWk4TI1AuNKSU3xW+oTTlboWhE7bh5wRjvWcn8RwiB3BV7R0iM4jxw2w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6870:bb1a:b0:143:74c2:f928 with SMTP id
 nw26-20020a056870bb1a00b0014374c2f928mr15086226oab.64.1669849778974; Wed, 30
 Nov 2022 15:09:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:08:45 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-2-seanjc@google.com>
Subject: [PATCH v2 01/50] KVM: Register /dev/kvm as the _very_ last thing
 during initialization
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Register /dev/kvm, i.e. expose KVM to userspace, only after all other
setup has completed.  Once /dev/kvm is exposed, userspace can start
invoking KVM ioctls, creating VMs, etc...  If userspace creates a VM
before KVM is done with its configuration, bad things may happen, e.g.
KVM will fail to properly migrate vCPU state if a VM is created before
KVM has registered preemption notifiers.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1782c4555d94..b60abb03606b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5919,12 +5919,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 
 	kvm_chardev_ops.owner = module;
 
-	r = misc_register(&kvm_dev);
-	if (r) {
-		pr_err("kvm: misc device register failed\n");
-		goto out_unreg;
-	}
-
 	register_syscore_ops(&kvm_syscore_ops);
 
 	kvm_preempt_ops.sched_in = kvm_sched_in;
@@ -5933,11 +5927,24 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	kvm_init_debug();
 
 	r = kvm_vfio_ops_init();
-	WARN_ON(r);
+	if (WARN_ON_ONCE(r))
+		goto err_vfio;
+
+	/*
+	 * Registration _must_ be the very last thing done, as this exposes
+	 * /dev/kvm to userspace, i.e. all infrastructure must be setup!
+	 */
+	r = misc_register(&kvm_dev);
+	if (r) {
+		pr_err("kvm: misc device register failed\n");
+		goto err_register;
+	}
 
 	return 0;
 
-out_unreg:
+err_register:
+	kvm_vfio_ops_exit();
+err_vfio:
 	kvm_async_pf_deinit();
 out_free_4:
 	for_each_possible_cpu(cpu)
@@ -5963,8 +5970,14 @@ void kvm_exit(void)
 {
 	int cpu;
 
-	debugfs_remove_recursive(kvm_debugfs_dir);
+	/*
+	 * Note, unregistering /dev/kvm doesn't strictly need to come first,
+	 * fops_get(), a.k.a. try_module_get(), prevents acquiring references
+	 * to KVM while the module is being stopped.
+	 */
 	misc_deregister(&kvm_dev);
+
+	debugfs_remove_recursive(kvm_debugfs_dir);
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
-- 
2.38.1.584.g0f3c55d4c2-goog

