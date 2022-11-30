Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F4B63E4F6
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiK3XOI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiK3XNW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:13:22 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58969D83B
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:45 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id g193-20020a636bca000000b00476a2298bd1so79513pgc.12
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iVoLyoA1Jf8VqqoJmf3pdlSBlpAks9cKaEAPUbSavnk=;
        b=KFEbVt71pG5AUxDCyfw0ctGx35DFJbafRPhU+Tsnxdpd7vRYtW7qd4JlQA8MVnYiNC
         cehxbeOYiyyiJPn7E6s9CwRwaN1xtow5SzScaD2RYcq+Nji7jijt1yTDk319fd1969N1
         0hHslGzgEV2mSg/GwYL0ydrtXmpf4YvER4m6AGCZSc6XSJVF8zd1Bqg0re/J+o1/el+G
         WN9quj9LAzi40hpkUTToXYBkooCrdruUHtSZrN/FsssQRzRW6TIEwt4ZtDDYuI4zno40
         xa3TZK20zvk7wc69EFj168eYu3J57rDplzSJfGRZtrl5uO5EY7/ALANxFIBtzt/BGToa
         XEEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iVoLyoA1Jf8VqqoJmf3pdlSBlpAks9cKaEAPUbSavnk=;
        b=pijj3Rj+CBtHpjKAgYoiw6MCQVwUJDcArJGycD9B2keipl6gtf/dlg4pOFGzFAttrX
         Ip32PaSocQ03dc9pMWlMMrFpj3pqh05qI5ygvpecoA7iAdIcRTQQwH1CZZG08346gUug
         /sB8r9TeHzUj+8KHHlDA2hO213tYuTF9r25renALEuDSyxwRG9eUAkhcNUYXCe2MHxRK
         hmO4r9S9mHuLGHwXbg7J7P88Pqo+4njSj/RLuqypC0tWll27mZBmsJyDI1MIXitaB7VV
         vO+PC4P9ySfdpzPtLe2E6DJ/duVW1+Zk5RGC9Irc72D8BFQ2c0vwUArIO+pnln8VCE48
         dQ6g==
X-Gm-Message-State: ANoB5pkukJaqmi+SV6bsg/1lFAGnroNbc/ec1VggHST+2s1eiAfOAJr3
        laysZXaD+cG24q60VNkZants2YssHcY=
X-Google-Smtp-Source: AA0mqf5O0rusu3cm3dLUEYlhDw+Qxiq2LyoGZAlqfMmUzuZXBF2mSFTecgqLY6I58XZmsJ5ZtbkyHjCBrrY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:93a3:0:b0:575:c993:d318 with SMTP id
 x3-20020aa793a3000000b00575c993d318mr6951152pff.78.1669849827891; Wed, 30 Nov
 2022 15:10:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:09:13 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-30-seanjc@google.com>
Subject: [PATCH v2 29/50] KVM: Drop kvm_arch_{init,exit}() hooks
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
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop kvm_arch_init() and kvm_arch_exit() now that all implementations
are nops.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>	# s390
Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
Acked-by: Anup Patel <anup@brainfault.org>
---
 arch/arm64/kvm/arm.c                | 11 -----------
 arch/mips/kvm/mips.c                | 10 ----------
 arch/powerpc/include/asm/kvm_host.h |  1 -
 arch/powerpc/kvm/powerpc.c          |  5 -----
 arch/riscv/kvm/main.c               |  9 ---------
 arch/s390/kvm/kvm-s390.c            | 10 ----------
 arch/x86/kvm/x86.c                  | 10 ----------
 include/linux/kvm_host.h            |  3 ---
 virt/kvm/kvm_main.c                 | 19 ++-----------------
 9 files changed, 2 insertions(+), 76 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4d34abcfc9a9..936ef7d1ea94 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2289,17 +2289,6 @@ static __init int kvm_arm_init(void)
 	return err;
 }
=20
-int kvm_arch_init(void *opaque)
-{
-	return 0;
-}
-
-/* NOP: Compiling as a module not supported */
-void kvm_arch_exit(void)
-{
-
-}
-
 static int __init early_kvm_mode_cfg(char *arg)
 {
 	if (!arg)
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index ae7a24342fdf..3cade648827a 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1010,16 +1010,6 @@ long kvm_arch_vm_ioctl(struct file *filp, unsigned i=
nt ioctl, unsigned long arg)
 	return r;
 }
=20
-int kvm_arch_init(void *opaque)
-{
-	return 0;
-}
-
-void kvm_arch_exit(void)
-{
-
-}
-
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs)
 {
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm=
/kvm_host.h
index 5d2c3a487e73..0a80e80c7b9e 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -881,7 +881,6 @@ static inline void kvm_arch_sync_events(struct kvm *kvm=
) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
-static inline void kvm_arch_exit(void) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
=20
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index d44b85ba8cef..01d0f9935e6c 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -2539,11 +2539,6 @@ void kvmppc_init_lpid(unsigned long nr_lpids_param)
 }
 EXPORT_SYMBOL_GPL(kvmppc_init_lpid);
=20
-int kvm_arch_init(void *opaque)
-{
-	return 0;
-}
-
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ppc_instr);
=20
 void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *de=
bugfs_dentry)
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index cb063b8a9a0f..4710a6751687 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -65,15 +65,6 @@ void kvm_arch_hardware_disable(void)
 	csr_write(CSR_HIDELEG, 0);
 }
=20
-int kvm_arch_init(void *opaque)
-{
-	return 0;
-}
-
-void kvm_arch_exit(void)
-{
-}
-
 static int __init riscv_kvm_init(void)
 {
 	const char *str;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 66d162723d21..25b08b956888 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -541,16 +541,6 @@ static void __kvm_s390_exit(void)
 	debug_unregister(kvm_s390_dbf_uv);
 }
=20
-int kvm_arch_init(void *opaque)
-{
-	return 0;
-}
-
-void kvm_arch_exit(void)
-{
-
-}
-
 /* Section: device related */
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 45184ca89317..66f16458aa97 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9277,16 +9277,6 @@ static inline void kvm_ops_update(struct kvm_x86_ini=
t_ops *ops)
 	kvm_pmu_ops_update(ops->pmu_ops);
 }
=20
-int kvm_arch_init(void *opaque)
-{
-	return 0;
-}
-
-void kvm_arch_exit(void)
-{
-
-}
-
 static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 {
 	u64 host_pat;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f2e0e78d2d92..7dde28333e7c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1439,9 +1439,6 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vc=
pu *vcpu,
 					struct kvm_guest_debug *dbg);
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu);
=20
-int kvm_arch_init(void *opaque);
-void kvm_arch_exit(void);
-
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
=20
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0e62887e8ce1..a4a10a0b322f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5852,20 +5852,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsig=
ned vcpu_align,
 	int r;
 	int cpu;
=20
-	/*
-	 * FIXME: Get rid of kvm_arch_init(), vendor code should call arch code
-	 * directly.  Note, kvm_arch_init() _must_ be called before anything
-	 * else as x86 relies on checks buried in kvm_arch_init() to guard
-	 * against multiple calls to kvm_init().
-	 */
-	r =3D kvm_arch_init(opaque);
-	if (r)
-		return r;
-
-	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
-		r =3D -ENOMEM;
-		goto err_hw_enabled;
-	}
+	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL))
+		return -ENOMEM;
=20
 	c.ret =3D &r;
 	c.opaque =3D opaque;
@@ -5953,8 +5941,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsign=
ed vcpu_align,
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
 out_free_2:
 	free_cpumask_var(cpus_hardware_enabled);
-err_hw_enabled:
-	kvm_arch_exit();
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_init);
@@ -5982,7 +5968,6 @@ void kvm_exit(void)
 	on_each_cpu(hardware_disable_nolock, NULL, 1);
 	kvm_irqfd_exit();
 	free_cpumask_var(cpus_hardware_enabled);
-	kvm_arch_exit();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
=20
--=20
2.38.1.584.g0f3c55d4c2-goog

