Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C51D61726B
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbiKBXZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbiKBXYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:24:09 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394DF10FC4
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:20:27 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l1-20020a170902f68100b00187117d8e44so243981plg.2
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eBGnpAB5YEmL+9R2z3ic0MP89PNczg3hngnKElf7iFc=;
        b=ojul5zX3wpuJJe7cqIIhk1dAIJjsIWSoVFD34OlEtsaEsfSCNKjjiF+HwG5lmnrY2I
         KreCXy41v7/9TFioIC3+xGBWkD7fmUCdz1gMvsLxqHHsu6RBAiMKgNs/d2SdW+bbhMRg
         NBqdiN1JSTgrtFjDcdWlEa2/xdW6ehlPIuAUy2mR2+Yl/4TziBYRxDfQKdxIrFQqWvPp
         0/D2KuiVfrvvfUsbgj/0BRs0z+I4snaV4Q8GQFYIGo/sG1wBZ4xUsO/CGVPbjBOgOZYg
         fVops+u1SYWw0XvvKmWhiG2a3pG2wZukc8aY+SxBVuiKXvQTkpr9CwptXPVgpDgkq3Oo
         0d2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eBGnpAB5YEmL+9R2z3ic0MP89PNczg3hngnKElf7iFc=;
        b=O0MIEU1zK+9uBy7GsaVYiBO88r5DXeG4/dURLC3XzPH3Hgu4wQ9WqQsOLOkjCNqwYK
         sdlZkRbK4sIsx9/kjIwOK6gDIoDf7u4FQS8tY6rVEAxOFXfES47P+U1/g5rnH3tqNH3i
         9c8jOOnsJlqxGuLWYTj4+q3t+p/gO3/3/xaiMlI4ESHvaybEyI50C1/NjThOqmuwEns3
         xVmLh8l1/UWeXgL4bzIiSYozIukyDYTnOhf4tWBJntc8FcDa3j1KWJK2IrxEEt72A7FR
         zPL02bZZUbo47DGvezIkYNXF/+EWGJPtmA8JUXz3CMwyx0cUFnaddI67ORQI/Zd2x4bV
         mCBQ==
X-Gm-Message-State: ACrzQf2jzTF+k5tKXYEzuNAn1YA+ie5ClA1gOOpQ0wfBwhSbC70PKM4j
        4nxNMqVSOyHoqdBp+ZG2PHXkmlXYgNE=
X-Google-Smtp-Source: AMsMyM6vXnUWEsRLX9fWIPNNelljS9Dalpkeg6q32F9Z4GJq3yxe6Bn6qth+fDauwaH6t2Cx5e1igxhHCN8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:7348:b0:213:2708:8dc3 with SMTP id
 j8-20020a17090a734800b0021327088dc3mr248527pjs.2.1667431226181; Wed, 02 Nov
 2022 16:20:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 23:19:09 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-43-seanjc@google.com>
Subject: [PATCH 42/44] KVM: Make hardware_enable_failed a local variable in
 the "enable all" path
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
        Vitaly Kuznetsov <vkuznets@redhat.com>
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
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Rework detecting hardware enabling errors to use a local variable in the
"enable all" path to track whether or not enabling was successful across
all CPUs.  Using a global variable complicates paths that enable hardware
only on the current CPU, e.g. kvm_resume() and kvm_online_cpu().

Opportunistically add a WARN if hardware enabling fails during
kvm_resume(), KVM is all kinds of hosed if CPU0 fails to enable hardware.
The WARN is largely futile in the current code, as KVM BUG()s on spurious
faults on VMX instructions, e.g. attempting to run a vCPU on CPU if
hardware enabling fails will explode.

  ------------[ cut here ]------------
  kernel BUG at arch/x86/kvm/x86.c:508!
  invalid opcode: 0000 [#1] SMP
  CPU: 3 PID: 1009 Comm: CPU 4/KVM Not tainted 6.1.0-rc1+ #11
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:kvm_spurious_fault+0xa/0x10
  Call Trace:
   vmx_vcpu_load_vmcs+0x192/0x230 [kvm_intel]
   vmx_vcpu_load+0x16/0x60 [kvm_intel]
   kvm_arch_vcpu_load+0x32/0x1f0
   vcpu_load+0x2f/0x40
   kvm_arch_vcpu_ioctl_run+0x19/0x9d0
   kvm_vcpu_ioctl+0x271/0x660
   __x64_sys_ioctl+0x80/0xb0
   do_syscall_64+0x2b/0x50
   entry_SYSCALL_64_after_hwframe+0x46/0xb0

But, the WARN may provide a breadcrumb to understand what went awry, and
someday KVM may fix one or both of those bugs, e.g. by finding a way to
eat spurious faults no matter the context (easier said than done due to
side effects of certain operations, e.g. Intel's VMCLEAR).

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[sean: rebase, WARN on failure in kvm_resume()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 31949a89fe25..a18296ee731b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -104,7 +104,6 @@ LIST_HEAD(vm_list);
 
 static DEFINE_PER_CPU(bool, hardware_enabled);
 static int kvm_usage_count;
-static atomic_t hardware_enable_failed;
 
 static struct kmem_cache *kvm_vcpu_cache;
 
@@ -5006,19 +5005,25 @@ static struct miscdevice kvm_dev = {
 	&kvm_chardev_ops,
 };
 
-static void hardware_enable_nolock(void *junk)
+static int __hardware_enable_nolock(void)
 {
 	if (__this_cpu_read(hardware_enabled))
-		return;
+		return 0;
 
 	if (kvm_arch_hardware_enable()) {
-		atomic_inc(&hardware_enable_failed);
 		pr_info("kvm: enabling virtualization on CPU%d failed\n",
 			raw_smp_processor_id());
-		return;
+		return -EIO;
 	}
 
 	__this_cpu_write(hardware_enabled, true);
+	return 0;
+}
+
+static void hardware_enable_nolock(void *failed)
+{
+	if (__hardware_enable_nolock())
+		atomic_inc(failed);
 }
 
 static int kvm_online_cpu(unsigned int cpu)
@@ -5033,16 +5038,9 @@ static int kvm_online_cpu(unsigned int cpu)
 	 * errors when scheduled to this CPU.
 	 */
 	if (kvm_usage_count) {
-		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
-
 		local_irq_save(flags);
-		hardware_enable_nolock(NULL);
+		ret = __hardware_enable_nolock();
 		local_irq_restore(flags);
-
-		if (atomic_read(&hardware_enable_failed)) {
-			atomic_set(&hardware_enable_failed, 0);
-			ret = -EIO;
-		}
 	}
 	mutex_unlock(&kvm_lock);
 	return ret;
@@ -5094,6 +5092,7 @@ static void hardware_disable_all(void)
 
 static int hardware_enable_all(void)
 {
+	atomic_t failed = ATOMIC_INIT(0);
 	int r = 0;
 
 	/*
@@ -5109,10 +5108,9 @@ static int hardware_enable_all(void)
 
 	kvm_usage_count++;
 	if (kvm_usage_count == 1) {
-		atomic_set(&hardware_enable_failed, 0);
-		on_each_cpu(hardware_enable_nolock, NULL, 1);
+		on_each_cpu(hardware_enable_nolock, &failed, 1);
 
-		if (atomic_read(&hardware_enable_failed)) {
+		if (atomic_read(&failed)) {
 			hardware_disable_all_nolock();
 			r = -EBUSY;
 		}
@@ -5744,7 +5742,7 @@ static void kvm_resume(void)
 	lockdep_assert_irqs_disabled();
 
 	if (kvm_usage_count)
-		hardware_enable_nolock(NULL);
+		WARN_ON_ONCE(__hardware_enable_nolock());
 }
 
 static struct syscore_ops kvm_syscore_ops = {
-- 
2.38.1.431.g37b22c650d-goog

