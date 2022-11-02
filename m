Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CFC617213
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiKBXUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiKBXUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:20:08 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5732720
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:19:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f126-20020a255184000000b006cb2aebd124so362535ybb.11
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hS5bVpzKUqQDTwIOc5biqhWk5bOmOk+1edZQlwf3ubM=;
        b=szPHLkhFGnRo6kaiXnFdGUAqKFDyeLG3Vql25w1uL10gFIqtapkpUXMYdCQdli+eqs
         cbcj9hSkNeNK0P7+t1BZFEIlTNuiaIp2mlW4xEBL0WtOOQIpQ9D+xxA8r7FTE3/hx8Ou
         8DfXEw5LuqLAgTGoPS8P3pICN4y6IJD/Snp87sY45+PuVlEkpSraOhTndfuv/3GEK8T+
         hn9gmRaXJDkisGpZk2f61kkZWmIpTFHWF2nSKiSU6rb6VwxKCNie2hpdgPJEzJyQa//E
         mMEwJkz2TFE7q1HlBlgTUEk3XIDzTUi+TWq+4KEAGQJ1QDIj47GdP3s/hYuMvyLPXFzC
         fAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hS5bVpzKUqQDTwIOc5biqhWk5bOmOk+1edZQlwf3ubM=;
        b=38NHat0p7Rsz32ml71ocywT7c5Xpkmn1ieT0L8ytAT3BC+2M1KEQzfHZEW9Y2jp4JH
         XGEO3GnqgLxc7+zFoRjNqUmJiLZUGW0HrxKIfcKkbRnlL2Rj5O/1AFVQwTssBjn4+TmN
         GyAafNGQ0rZ3wVwQfaRgVtYReJG8YJtmaYChUTRiFK++aRDkRNJuS5jplQPf/fSW5Y87
         CKxTa9ZLi1Sbu8v/F97jbTzCeTsUhHieX9bUwfNTySbMXC7PPv+Bm1ptXuoO6KZG+IpY
         SBOrKwAZ80n9JXUn4K26V1JIEjYFudri2x1DmSsxz4+gNtsuK6lQgH4qfIS83kuxrFxc
         MRBQ==
X-Gm-Message-State: ACrzQf1gwhnt2lO1813Ike/Sive8PMJBvz/QuJWhm58q5BaoM6JKWm8L
        6ZGBaw9Ax/et/ivBiK3zXLehDZzAVmw=
X-Google-Smtp-Source: AMsMyM6MvFlyMTvm+NnPM3j23SDoVaNqu/thK/yXLmfsQfDpd3rV6P8bhnZdIFBO5cOKecs1QOCuujh9sYY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:705:b0:6ca:a3b0:e7f with SMTP id
 k5-20020a056902070500b006caa3b00e7fmr26597392ybt.373.1667431174399; Wed, 02
 Nov 2022 16:19:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 23:18:39 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-13-seanjc@google.com>
Subject: [PATCH 12/44] KVM: VMX: Do _all_ initialization before exposing
 /dev/kvm to userspace
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Call kvm_init() only after _all_ setup is complete, as kvm_init() exposes
/dev/kvm to userspace and thus allows userspace to create VMs (and call
other ioctls).  E.g. KVM will encounter a NULL pointer when attempting to
add a vCPU to the per-CPU loaded_vmcss_on_cpu list if userspace is able to
create a VM before vmx_init() configures said list.

 BUG: kernel NULL pointer dereference, address: 0000000000000008
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD 0 P4D 0
 Oops: 0002 [#1] SMP
 CPU: 6 PID: 1143 Comm: stable Not tainted 6.0.0-rc7+ #988
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
 RIP: 0010:vmx_vcpu_load_vmcs+0x68/0x230 [kvm_intel]
  <TASK>
  vmx_vcpu_load+0x16/0x60 [kvm_intel]
  kvm_arch_vcpu_load+0x32/0x1f0 [kvm]
  vcpu_load+0x2f/0x40 [kvm]
  kvm_arch_vcpu_create+0x231/0x310 [kvm]
  kvm_vm_ioctl+0x79f/0xe10 [kvm]
  ? handle_mm_fault+0xb1/0x220
  __x64_sys_ioctl+0x80/0xb0
  do_syscall_64+0x2b/0x50
  entry_SYSCALL_64_after_hwframe+0x46/0xb0
 RIP: 0033:0x7f5a6b05743b
  </TASK>
 Modules linked in: vhost_net vhost vhost_iotlb tap kvm_intel(+) kvm irqbypass

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 118d9b29b339..6adb60485839 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8493,21 +8493,25 @@ static void vmx_cleanup_l1d_flush(void)
 	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
 }
 
-static void vmx_exit(void)
+static void __vmx_exit(void)
 {
+	allow_smaller_maxphyaddr = false;
+
 #ifdef CONFIG_KEXEC_CORE
 	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
 	synchronize_rcu();
 #endif
-
-	kvm_exit();
-	kvm_x86_vendor_exit();
-
-	hv_cleanup_evmcs();
-
 	vmx_cleanup_l1d_flush();
+}
 
-	allow_smaller_maxphyaddr = false;
+static void vmx_exit(void)
+{
+	kvm_exit();
+	kvm_x86_vendor_exit();
+
+	__vmx_exit();
+
+	hv_cleanup_evmcs();
 }
 module_exit(vmx_exit);
 
@@ -8521,11 +8525,6 @@ static int __init vmx_init(void)
 	if (r)
 		goto err_x86_init;
 
-	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
-		     __alignof__(struct vcpu_vmx), THIS_MODULE);
-	if (r)
-		goto err_kvm_init;
-
 	/*
 	 * Must be called after common x86 init so enable_ept is properly set
 	 * up. Hand the parameter mitigation value in which was stored in
@@ -8559,11 +8558,20 @@ static int __init vmx_init(void)
 	if (!enable_ept)
 		allow_smaller_maxphyaddr = true;
 
+	/*
+	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
+	 * exposed to userspace!
+	 */
+	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
+		     __alignof__(struct vcpu_vmx), THIS_MODULE);
+	if (r)
+		goto err_kvm_init;
+
 	return 0;
 
-err_l1d_flush:
-	vmx_exit();
 err_kvm_init:
+	__vmx_exit();
+err_l1d_flush:
 	kvm_x86_vendor_exit();
 err_x86_init:
 	hv_cleanup_evmcs();
-- 
2.38.1.431.g37b22c650d-goog

