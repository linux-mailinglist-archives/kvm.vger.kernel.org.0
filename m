Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609284C0C23
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238387AbiBWF2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238447AbiBWF1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:27:19 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF6F6E286
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:29 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d306e372e5so163267937b3.5
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1Ak925Pk776XAKxLwtqmq+2ujMHKkPdWGXyWe6mB81I=;
        b=qruJowqTdMVz7fZkxeG4xVb20iJ53LrE4dT1CKYoVmqpJaSFmZqssZFPvLDlocajG+
         0ZNfohsXrp0SvmtgoKo+3GpbCl6Ek66LSSQDb5QhwDTmpTY3IZR68hTWLTakDK649FWd
         NcBzCkwDsR687gBw9hUAZO42EBgmkkjWUtK9c7iThbB5OJvWqulI+ZjA4At9vc3jDdQv
         V3RzFrXEtxS3BFQakXKK5JYagS7g37QYbi+N7FduEDd6mJWAl6cR1xbe48z+M34xGgJb
         +aIJO9WdvPWGVowL+cjeTIFBzTQnJ9oyaKZdWhvwquAx5l+fbfWtWxe31CFQ765daVDd
         WYtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1Ak925Pk776XAKxLwtqmq+2ujMHKkPdWGXyWe6mB81I=;
        b=OvgR4tD9gicEgXR0psvOqiNvEtYnXrjIGLw5yHVAjd/sUzRYGPnT4rM9YZl847ZCyj
         lHflg2bSnkOWcbn8B0k192V0JpHfOiC3hQJMpISjQQOEZvba81xFEHPPHbFFC6e9EwTj
         Vr9Vku3ybismzUwzDLzAAAitojauadAm/EOJuSfoQJlii2ngnwPmQz3roszSYkT0jGZj
         jkIaHbYVmI1dvUyNjazFAGKxsShJ7t9GsKVHGmqfPOAPCCe3wTZPZtfU720fd2+Nzf8b
         B3l0RcA6Pe1rjxtewLjhr1+75Tdkw1IWgsGyWDaYcaVLUaiVWACVU7xPgTfdwOV7aPOg
         ZcMQ==
X-Gm-Message-State: AOAM532OQDlj9hJQVNz4wB9Gr9/Vl2qJM5+Gy9hkiQ0GY+VYsCJetNK/
        BqEZThQnmyUunnkzmZRxNPK7zDb5wQ9S
X-Google-Smtp-Source: ABdhPJz+8yu7dLdPv2zaC0fb4RR9so3iE3HoEaEWayOmFqlvYUtwhO3rWaAyrQMIf9/n3UzRyvpRD4FVMxcA
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a25:bad2:0:b0:620:fe28:ff53 with SMTP id
 a18-20020a25bad2000000b00620fe28ff53mr26733639ybk.340.1645593921610; Tue, 22
 Feb 2022 21:25:21 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:19 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-44-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 43/47] mm: asi: Annotation of dynamic variables to be nonsensitive
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ofir Weisse <oweisse@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com, pjt@google.com,
        alexandre.chartre@oracle.com, rppt@linux.ibm.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, luto@kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ofir Weisse <oweisse@google.com>

The heart of ASI is to diffrentiate between sensitive and non-sensitive
data access. This commit marks certain dynamic allocations as not
sensitive.

Some dynamic variables are accessed frequently and therefore would cause
many ASI exits. The frequency of these accesses is monitored by tracing
asi_exits and analyzing the accessed addresses. Many of these variables
don't contain sensitive information and can therefore be mapped into the
global ASI region. This commit adds GFP_LOCAL/GLOBAL_NONSENSITIVE
attributes to these frequenmtly-accessed yet not sensitive variables.
The end result is a very significant reduction in ASI exits on real
benchmarks.

Signed-off-by: Ofir Weisse <oweisse@google.com>


---
 arch/x86/include/asm/kvm_host.h       |  3 ++-
 arch/x86/kernel/apic/x2apic_cluster.c |  2 +-
 arch/x86/kvm/cpuid.c                  |  4 ++-
 arch/x86/kvm/lapic.c                  |  9 ++++---
 arch/x86/kvm/mmu/mmu.c                |  7 ++++++
 arch/x86/kvm/vmx/vmx.c                |  6 +++--
 arch/x86/kvm/x86.c                    |  8 +++---
 fs/binfmt_elf.c                       |  2 +-
 fs/eventfd.c                          |  2 +-
 fs/eventpoll.c                        | 10 +++++---
 fs/exec.c                             |  2 ++
 fs/file.c                             |  3 ++-
 fs/timerfd.c                          |  2 +-
 include/linux/kvm_host.h              |  2 +-
 include/linux/kvm_types.h             |  3 +++
 kernel/cgroup/cgroup.c                |  4 +--
 kernel/events/core.c                  | 15 +++++++----
 kernel/exit.c                         |  2 ++
 kernel/fork.c                         | 36 +++++++++++++++++++++------
 kernel/rcu/srcutree.c                 |  3 ++-
 kernel/sched/core.c                   |  6 +++--
 kernel/sched/cpuacct.c                |  8 +++---
 kernel/sched/fair.c                   |  3 ++-
 kernel/sched/topology.c               | 14 +++++++----
 kernel/smp.c                          | 17 +++++++------
 kernel/trace/ring_buffer.c            |  5 ++--
 kernel/tracepoint.c                   |  2 +-
 lib/radix-tree.c                      |  6 ++---
 mm/memcontrol.c                       |  7 +++---
 mm/util.c                             |  3 ++-
 mm/vmalloc.c                          |  3 ++-
 net/core/skbuff.c                     |  2 +-
 net/core/sock.c                       |  2 +-
 virt/kvm/coalesced_mmio.c             |  2 +-
 virt/kvm/eventfd.c                    |  5 ++--
 virt/kvm/kvm_main.c                   | 12 ++++++---
 36 files changed, 148 insertions(+), 74 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b7292c4fece7..34a05add5e77 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1562,7 +1562,8 @@ static inline void kvm_ops_static_call_update(void)
 #define __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
-	return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO |
+                         __GFP_GLOBAL_NONSENSITIVE);
 }
 
 #define __KVM_HAVE_ARCH_VM_FREE
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 655fe820a240..a1f6eb51ecb7 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -144,7 +144,7 @@ static int alloc_clustermask(unsigned int cpu, int node)
 	}
 
 	cluster_hotplug_mask = kzalloc_node(sizeof(*cluster_hotplug_mask),
-					    GFP_KERNEL, node);
+					    GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE, node);
 	if (!cluster_hotplug_mask)
 		return -ENOMEM;
 	cluster_hotplug_mask->node = node;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 07e9215e911d..dedabfdd292e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -310,7 +310,9 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 		if (IS_ERR(e))
 			return PTR_ERR(e);
 
-		e2 = kvmalloc_array(cpuid->nent, sizeof(*e2), GFP_KERNEL_ACCOUNT);
+		e2 = kvmalloc_array(cpuid->nent, sizeof(*e2),
+                                    GFP_KERNEL_ACCOUNT |
+                                    __GFP_LOCAL_NONSENSITIVE);
 		if (!e2) {
 			r = -ENOMEM;
 			goto out_free_cpuid;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 213bbdfab49e..3a550299f015 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -213,7 +213,7 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 
 	new = kvzalloc(sizeof(struct kvm_apic_map) +
 	                   sizeof(struct kvm_lapic *) * ((u64)max_id + 1),
-			   GFP_KERNEL_ACCOUNT);
+			   GFP_KERNEL_ACCOUNT | __GFP_LOCAL_NONSENSITIVE);
 
 	if (!new)
 		goto out;
@@ -993,7 +993,7 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 	*r = -1;
 
 	if (irq->shorthand == APIC_DEST_SELF) {
-		*r = kvm_apic_set_irq(src->vcpu, irq, dest_map);
+              *r = kvm_apic_set_irq(src->vcpu, irq, dest_map);
 		return true;
 	}
 
@@ -2455,13 +2455,14 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 
 	ASSERT(vcpu != NULL);
 
-	apic = kzalloc(sizeof(*apic), GFP_KERNEL_ACCOUNT);
+	apic = kzalloc(sizeof(*apic), GFP_KERNEL_ACCOUNT | __GFP_LOCAL_NONSENSITIVE);
 	if (!apic)
 		goto nomem;
 
 	vcpu->arch.apic = apic;
 
-	apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT
+                                             | __GFP_LOCAL_NONSENSITIVE);
 	if (!apic->regs) {
 		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
 		       vcpu->vcpu_id);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5785a0d02558..a2ada1104c2d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5630,6 +5630,13 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
 	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	if (static_cpu_has(X86_FEATURE_ASI) && mm_asi_enabled(current->mm))
+	        vcpu->arch.mmu_shadow_page_cache.gfp_asi =
+                                                      __GFP_LOCAL_NONSENSITIVE;
+        else
+	        vcpu->arch.mmu_shadow_page_cache.gfp_asi = 0;
+#endif
 
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e1ad82c25a78..6e1bb017b696 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2629,7 +2629,7 @@ void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 	free_vmcs(loaded_vmcs->vmcs);
 	loaded_vmcs->vmcs = NULL;
 	if (loaded_vmcs->msr_bitmap)
-		free_page((unsigned long)loaded_vmcs->msr_bitmap);
+                kfree(loaded_vmcs->msr_bitmap);
 	WARN_ON(loaded_vmcs->shadow_vmcs != NULL);
 }
 
@@ -2648,7 +2648,9 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 
 	if (cpu_has_vmx_msr_bitmap()) {
 		loaded_vmcs->msr_bitmap = (unsigned long *)
-				__get_free_page(GFP_KERNEL_ACCOUNT);
+				kzalloc(PAGE_SIZE,
+                                        GFP_KERNEL_ACCOUNT |
+                                        __GFP_LOCAL_NONSENSITIVE );
 		if (!loaded_vmcs->msr_bitmap)
 			goto out_vmcs;
 		memset(loaded_vmcs->msr_bitmap, 0xff, PAGE_SIZE);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 451872d178e5..dd862edc1b5a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -329,7 +329,8 @@ static struct kmem_cache *kvm_alloc_emulator_cache(void)
 
 	return kmem_cache_create_usercopy("x86_emulator", size,
 					  __alignof__(struct x86_emulate_ctxt),
-					  SLAB_ACCOUNT, useroffset,
+					  SLAB_ACCOUNT|SLAB_LOCAL_NONSENSITIVE,
+                                          useroffset,
 					  size - useroffset, NULL);
 }
 
@@ -10969,7 +10970,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	r = -ENOMEM;
 
-	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_LOCAL_NONSENSITIVE);
 	if (!page)
 		goto fail_free_lapic;
 	vcpu->arch.pio_data = page_address(page);
@@ -11718,7 +11719,8 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 
 		lpages = __kvm_mmu_slot_lpages(slot, npages, level);
 
-		linfo = kvcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
+		linfo = kvcalloc(lpages, sizeof(*linfo),
+				 GFP_KERNEL_ACCOUNT | __GFP_LOCAL_NONSENSITIVE);
 		if (!linfo)
 			goto out_free;
 
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index f8c7f26f1fbb..b0550951da59 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -477,7 +477,7 @@ static struct elf_phdr *load_elf_phdrs(const struct elfhdr *elf_ex,
 	if (size == 0 || size > 65536 || size > ELF_MIN_ALIGN)
 		goto out;
 
-	elf_phdata = kmalloc(size, GFP_KERNEL);
+	elf_phdata = kmalloc(size, GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (!elf_phdata)
 		goto out;
 
diff --git a/fs/eventfd.c b/fs/eventfd.c
index 3627dd7d25db..c748433e52af 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -415,7 +415,7 @@ static int do_eventfd(unsigned int count, int flags)
 	if (flags & ~EFD_FLAGS_SET)
 		return -EINVAL;
 
-	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (!ctx)
 		return -ENOMEM;
 
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 06f4c5ae1451..b28826c9f079 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1239,7 +1239,7 @@ static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
 	if (unlikely(!epi))	// an earlier allocation has failed
 		return;
 
-	pwq = kmem_cache_alloc(pwq_cache, GFP_KERNEL);
+	pwq = kmem_cache_alloc(pwq_cache, GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (unlikely(!pwq)) {
 		epq->epi = NULL;
 		return;
@@ -1453,7 +1453,8 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
 		return -ENOSPC;
 	percpu_counter_inc(&ep->user->epoll_watches);
 
-	if (!(epi = kmem_cache_zalloc(epi_cache, GFP_KERNEL))) {
+	if (!(epi = kmem_cache_zalloc(epi_cache,
+                                      GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE))) {
 		percpu_counter_dec(&ep->user->epoll_watches);
 		return -ENOMEM;
 	}
@@ -2373,11 +2374,12 @@ static int __init eventpoll_init(void)
 
 	/* Allocates slab cache used to allocate "struct epitem" items */
 	epi_cache = kmem_cache_create("eventpoll_epi", sizeof(struct epitem),
-			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT, NULL);
+			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT|SLAB_GLOBAL_NONSENSITIVE, NULL);
 
 	/* Allocates slab cache used to allocate "struct eppoll_entry" */
 	pwq_cache = kmem_cache_create("eventpoll_pwq",
-		sizeof(struct eppoll_entry), 0, SLAB_PANIC|SLAB_ACCOUNT, NULL);
+		sizeof(struct eppoll_entry), 0,
+                SLAB_PANIC|SLAB_ACCOUNT|SLAB_GLOBAL_NONSENSITIVE, NULL);
 
 	ephead_cache = kmem_cache_create("ep_head",
 		sizeof(struct epitems_head), 0, SLAB_PANIC|SLAB_ACCOUNT, NULL);
diff --git a/fs/exec.c b/fs/exec.c
index 537d92c41105..76f3b433e80d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1238,6 +1238,8 @@ int begin_new_exec(struct linux_binprm * bprm)
 	struct task_struct *me = current;
 	int retval;
 
+        /* TODO: (oweisse) unmap the stack from ASI */
+
 	/* Once we are committed compute the creds */
 	retval = bprm_creds_from_file(bprm);
 	if (retval)
diff --git a/fs/file.c b/fs/file.c
index 97d212a9b814..85bfa5d70323 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -117,7 +117,8 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	if (!fdt)
 		goto out;
 	fdt->max_fds = nr;
-	data = kvmalloc_array(nr, sizeof(struct file *), GFP_KERNEL_ACCOUNT);
+	data = kvmalloc_array(nr, sizeof(struct file *),
+                              GFP_KERNEL_ACCOUNT | __GFP_LOCAL_NONSENSITIVE);
 	if (!data)
 		goto out_fdt;
 	fdt->fd = data;
diff --git a/fs/timerfd.c b/fs/timerfd.c
index e9c96a0c79f1..385fbb29837d 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -425,7 +425,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 	    !capable(CAP_WAKE_ALARM))
 		return -EPERM;
 
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (!ctx)
 		return -ENOMEM;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f31f7442eced..dfbb26d7a185 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1085,7 +1085,7 @@ int kvm_arch_create_vm_debugfs(struct kvm *kvm);
  */
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
-	return kzalloc(sizeof(struct kvm), GFP_KERNEL);
+	return kzalloc(sizeof(struct kvm), GFP_KERNEL | __GFP_LOCAL_NONSENSITIVE);
 }
 #endif
 
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 234eab059839..a5a810db85ca 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -64,6 +64,9 @@ struct gfn_to_hva_cache {
 struct kvm_mmu_memory_cache {
 	int nobjs;
 	gfp_t gfp_zero;
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	gfp_t gfp_asi;
+#endif
 	struct kmem_cache *kmem_cache;
 	void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
 };
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 729495e17363..79692dafd2be 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1221,7 +1221,7 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	if (cset)
 		return cset;
 
-	cset = kzalloc(sizeof(*cset), GFP_KERNEL);
+	cset = kzalloc(sizeof(*cset), GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (!cset)
 		return NULL;
 
@@ -5348,7 +5348,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent, const char *name,
 
 	/* allocate the cgroup and its ID, 0 is reserved for the root */
 	cgrp = kzalloc(struct_size(cgrp, ancestor_ids, (level + 1)),
-		       GFP_KERNEL);
+		       GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (!cgrp)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1914cc538cab..64eeb2c67d92 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4586,7 +4586,8 @@ alloc_perf_context(struct pmu *pmu, struct task_struct *task)
 {
 	struct perf_event_context *ctx;
 
-	ctx = kzalloc(sizeof(struct perf_event_context), GFP_KERNEL);
+	ctx = kzalloc(sizeof(struct perf_event_context),
+                      GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (!ctx)
 		return NULL;
 
@@ -11062,7 +11063,8 @@ int perf_pmu_register(struct pmu *pmu, const char *name, int type)
 
 	mutex_lock(&pmus_lock);
 	ret = -ENOMEM;
-	pmu->pmu_disable_count = alloc_percpu(int);
+	pmu->pmu_disable_count = alloc_percpu_gfp(int,
+                                        GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (!pmu->pmu_disable_count)
 		goto unlock;
 
@@ -11112,7 +11114,8 @@ int perf_pmu_register(struct pmu *pmu, const char *name, int type)
 		goto got_cpu_context;
 
 	ret = -ENOMEM;
-	pmu->pmu_cpu_context = alloc_percpu(struct perf_cpu_context);
+	pmu->pmu_cpu_context = alloc_percpu_gfp(struct perf_cpu_context,
+                                                GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (!pmu->pmu_cpu_context)
 		goto free_dev;
 
@@ -11493,7 +11496,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	}
 
 	node = (cpu >= 0) ? cpu_to_node(cpu) : -1;
-	event = kmem_cache_alloc_node(perf_event_cache, GFP_KERNEL | __GFP_ZERO,
+	event = kmem_cache_alloc_node(perf_event_cache,
+                                      GFP_KERNEL | __GFP_ZERO | __GFP_GLOBAL_NONSENSITIVE,
 				      node);
 	if (!event)
 		return ERR_PTR(-ENOMEM);
@@ -13378,7 +13382,8 @@ void __init perf_event_init(void)
 	ret = init_hw_breakpoint();
 	WARN(ret, "hw_breakpoint initialization failed with: %d", ret);
 
-	perf_event_cache = KMEM_CACHE(perf_event, SLAB_PANIC);
+	perf_event_cache = KMEM_CACHE(perf_event,
+                                      SLAB_PANIC | SLAB_GLOBAL_NONSENSITIVE);
 
 	/*
 	 * Build time assertion that we keep the data_head at the intended
diff --git a/kernel/exit.c b/kernel/exit.c
index f702a6a63686..ab2749cf6887 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -768,6 +768,8 @@ void __noreturn do_exit(long code)
 	profile_task_exit(tsk);
 	kcov_task_exit(tsk);
 
+        /* TODO: (oweisse) unmap the stack from ASI */
+
 	coredump_task_exit(tsk);
 	ptrace_event(PTRACE_EVENT_EXIT, code);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index d7f55de00947..cb147a72372d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -168,6 +168,8 @@ static struct kmem_cache *task_struct_cachep;
 
 static inline struct task_struct *alloc_task_struct_node(int node)
 {
+        /* TODO: Figure how to allocate this propperly to ASI process map. This
+         * should be mapped in a __GFP_LOCAL_NONSENSITIVE slab. */
 	return kmem_cache_alloc_node(task_struct_cachep, GFP_KERNEL, node);
 }
 
@@ -214,6 +216,7 @@ static int free_vm_stack_cache(unsigned int cpu)
 
 static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
 {
+  /* TODO: (oweisse) Add annotation to map the stack into ASI */
 #ifdef CONFIG_VMAP_STACK
 	void *stack;
 	int i;
@@ -242,9 +245,13 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
 	 * so memcg accounting is performed manually on assigning/releasing
 	 * stacks to tasks. Drop __GFP_ACCOUNT.
 	 */
+        /* ASI: We intentionally don't pass VM_LOCAL_NONSENSITIVE nor
+         * __GFP_LOCAL_NONSENSITIVE since we don't have an mm yet. Later on we'll
+         * map the stack into the mm asi map. That being said, we do care about
+         * the stack weing allocaed below VMALLOC_LOCAL_NONSENSITIVE_END */
 	stack = __vmalloc_node_range(THREAD_SIZE, THREAD_ALIGN,
-				     VMALLOC_START, VMALLOC_END,
-				     THREADINFO_GFP & ~__GFP_ACCOUNT,
+				     VMALLOC_START, VMALLOC_LOCAL_NONSENSITIVE_END,
+				     (THREADINFO_GFP & (~__GFP_ACCOUNT)),
 				     PAGE_KERNEL,
 				     0, node, __builtin_return_address(0));
 
@@ -346,7 +353,8 @@ struct vm_area_struct *vm_area_alloc(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
 
-	vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
+	vma = kmem_cache_alloc(vm_area_cachep,
+                               GFP_KERNEL);
 	if (vma)
 		vma_init(vma, mm);
 	return vma;
@@ -683,6 +691,8 @@ static void check_mm(struct mm_struct *mm)
 #endif
 }
 
+/* TODO: (oweisse) ASI: we need to allocate mm such that it will only be visible
+ * within itself. */
 #define allocate_mm()	(kmem_cache_alloc(mm_cachep, GFP_KERNEL))
 #define free_mm(mm)	(kmem_cache_free(mm_cachep, (mm)))
 
@@ -823,9 +833,12 @@ void __init fork_init(void)
 
 	/* create a slab on which task_structs can be allocated */
 	task_struct_whitelist(&useroffset, &usersize);
+        /* TODO: (oweisse) for the time being this cache is shared among all tasks. We
+         * mark it SLAB_NONSENSITIVE so task_struct can be accessed withing ASI.
+         * A final secure solution should have this memory LOCAL, not GLOBAL.*/
 	task_struct_cachep = kmem_cache_create_usercopy("task_struct",
 			arch_task_struct_size, align,
-			SLAB_PANIC|SLAB_ACCOUNT,
+			SLAB_PANIC|SLAB_ACCOUNT|SLAB_GLOBAL_NONSENSITIVE,
 			useroffset, usersize, NULL);
 #endif
 
@@ -1601,6 +1614,7 @@ static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
 		refcount_inc(&current->sighand->count);
 		return 0;
 	}
+        /* TODO: (oweisse) ASI replace with proper ASI allcation. */
 	sig = kmem_cache_alloc(sighand_cachep, GFP_KERNEL);
 	RCU_INIT_POINTER(tsk->sighand, sig);
 	if (!sig)
@@ -1649,6 +1663,8 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	if (clone_flags & CLONE_THREAD)
 		return 0;
 
+        /* TODO: (oweisse) figure out how to properly allocate this in ASI for local
+         * process */
 	sig = kmem_cache_zalloc(signal_cachep, GFP_KERNEL);
 	tsk->signal = sig;
 	if (!sig)
@@ -2923,7 +2939,8 @@ void __init proc_caches_init(void)
 			SLAB_ACCOUNT, sighand_ctor);
 	signal_cachep = kmem_cache_create("signal_cache",
 			sizeof(struct signal_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT|
+                        SLAB_GLOBAL_NONSENSITIVE,
 			NULL);
 	files_cachep = kmem_cache_create("files_cache",
 			sizeof(struct files_struct), 0,
@@ -2941,13 +2958,18 @@ void __init proc_caches_init(void)
 	 */
 	mm_size = sizeof(struct mm_struct) + cpumask_size();
 
+        /* TODO: (oweisse) ASI replace with proper ASI allcation. */
 	mm_cachep = kmem_cache_create_usercopy("mm_struct",
 			mm_size, ARCH_MIN_MMSTRUCT_ALIGN,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT
+                        |SLAB_GLOBAL_NONSENSITIVE,
 			offsetof(struct mm_struct, saved_auxv),
 			sizeof_field(struct mm_struct, saved_auxv),
 			NULL);
-	vm_area_cachep = KMEM_CACHE(vm_area_struct, SLAB_PANIC|SLAB_ACCOUNT);
+
+        /* TODO: (oweisse) ASI replace with proper ASI allcation. */
+	vm_area_cachep = KMEM_CACHE(vm_area_struct,
+                                    SLAB_PANIC|SLAB_ACCOUNT|SLAB_LOCAL_NONSENSITIVE);
 	mmap_init();
 	nsproxy_cache_init();
 }
diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
index 6833d8887181..553221503803 100644
--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -171,7 +171,8 @@ static int init_srcu_struct_fields(struct srcu_struct *ssp, bool is_static)
 	atomic_set(&ssp->srcu_barrier_cpu_cnt, 0);
 	INIT_DELAYED_WORK(&ssp->work, process_srcu);
 	if (!is_static)
-		ssp->sda = alloc_percpu(struct srcu_data);
+		ssp->sda = alloc_percpu_gfp(struct srcu_data,
+					GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (!ssp->sda)
 		return -ENOMEM;
 	init_srcu_struct_nodes(ssp);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7c96f0001c7f..7515f0612f5c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9329,7 +9329,8 @@ void __init sched_init(void)
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_CGROUP_SCHED
-	task_group_cache = KMEM_CACHE(task_group, 0);
+        /* TODO: (oweisse) add SLAB_NONSENSITIVE */
+	task_group_cache = KMEM_CACHE(task_group, SLAB_GLOBAL_NONSENSITIVE);
 
 	list_add(&root_task_group.list, &task_groups);
 	INIT_LIST_HEAD(&root_task_group.children);
@@ -9741,7 +9742,8 @@ struct task_group *sched_create_group(struct task_group *parent)
 {
 	struct task_group *tg;
 
-	tg = kmem_cache_alloc(task_group_cache, GFP_KERNEL | __GFP_ZERO);
+	tg = kmem_cache_alloc(task_group_cache,
+                              GFP_KERNEL | __GFP_ZERO | __GFP_GLOBAL_NONSENSITIVE);
 	if (!tg)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 6e3da149125c..e8b0b29b4d37 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -64,15 +64,17 @@ cpuacct_css_alloc(struct cgroup_subsys_state *parent_css)
 	if (!parent_css)
 		return &root_cpuacct.css;
 
-	ca = kzalloc(sizeof(*ca), GFP_KERNEL);
+	ca = kzalloc(sizeof(*ca), GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (!ca)
 		goto out;
 
-	ca->cpuusage = alloc_percpu(struct cpuacct_usage);
+	ca->cpuusage = alloc_percpu_gfp(struct cpuacct_usage,
+                                        GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (!ca->cpuusage)
 		goto out_free_ca;
 
-	ca->cpustat = alloc_percpu(struct kernel_cpustat);
+	ca->cpustat = alloc_percpu_gfp(struct kernel_cpustat,
+                                   GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (!ca->cpustat)
 		goto out_free_cpuusage;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index dc9b6133b059..97d70f1eb2c5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11486,7 +11486,8 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 
 	for_each_possible_cpu(i) {
 		cfs_rq = kzalloc_node(sizeof(struct cfs_rq),
-				      GFP_KERNEL, cpu_to_node(i));
+				      GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE,
+                                      cpu_to_node(i));
 		if (!cfs_rq)
 			goto err;
 
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 1dcea6a6133e..2ad96c78306c 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -569,7 +569,7 @@ static struct root_domain *alloc_rootdomain(void)
 {
 	struct root_domain *rd;
 
-	rd = kzalloc(sizeof(*rd), GFP_KERNEL);
+	rd = kzalloc(sizeof(*rd), GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (!rd)
 		return NULL;
 
@@ -2044,21 +2044,24 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 			struct sched_group_capacity *sgc;
 
 			sd = kzalloc_node(sizeof(struct sched_domain) + cpumask_size(),
-					GFP_KERNEL, cpu_to_node(j));
+					GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE,
+                                        cpu_to_node(j));
 			if (!sd)
 				return -ENOMEM;
 
 			*per_cpu_ptr(sdd->sd, j) = sd;
 
 			sds = kzalloc_node(sizeof(struct sched_domain_shared),
-					GFP_KERNEL, cpu_to_node(j));
+					GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE,
+                                        cpu_to_node(j));
 			if (!sds)
 				return -ENOMEM;
 
 			*per_cpu_ptr(sdd->sds, j) = sds;
 
 			sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
-					GFP_KERNEL, cpu_to_node(j));
+					GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE,
+                                        cpu_to_node(j));
 			if (!sg)
 				return -ENOMEM;
 
@@ -2067,7 +2070,8 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 			*per_cpu_ptr(sdd->sg, j) = sg;
 
 			sgc = kzalloc_node(sizeof(struct sched_group_capacity) + cpumask_size(),
-					GFP_KERNEL, cpu_to_node(j));
+					GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE,
+                                        cpu_to_node(j));
 			if (!sgc)
 				return -ENOMEM;
 
diff --git a/kernel/smp.c b/kernel/smp.c
index 3c1b328f0a09..db9ab5a58e2c 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -103,15 +103,18 @@ int smpcfd_prepare_cpu(unsigned int cpu)
 {
 	struct call_function_data *cfd = &per_cpu(cfd_data, cpu);
 
-	if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
+	if (!zalloc_cpumask_var_node(&cfd->cpumask,
+				     GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE,
 				     cpu_to_node(cpu)))
 		return -ENOMEM;
-	if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
+	if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi,
+				     GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE,
 				     cpu_to_node(cpu))) {
 		free_cpumask_var(cfd->cpumask);
 		return -ENOMEM;
 	}
-	cfd->pcpu = alloc_percpu(struct cfd_percpu);
+	cfd->pcpu = alloc_percpu_gfp(struct cfd_percpu,
+				     GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (!cfd->pcpu) {
 		free_cpumask_var(cfd->cpumask);
 		free_cpumask_var(cfd->cpumask_ipi);
@@ -179,10 +182,10 @@ static int __init csdlock_debug(char *str)
 }
 early_param("csdlock_debug", csdlock_debug);
 
-static DEFINE_PER_CPU(call_single_data_t *, cur_csd);
-static DEFINE_PER_CPU(smp_call_func_t, cur_csd_func);
-static DEFINE_PER_CPU(void *, cur_csd_info);
-static DEFINE_PER_CPU(struct cfd_seq_local, cfd_seq_local);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(call_single_data_t *, cur_csd);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(smp_call_func_t, cur_csd_func);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(void *, cur_csd_info);
+static DEFINE_PER_CPU_ASI_NOT_SENSITIVE(struct cfd_seq_local, cfd_seq_local);
 
 #define CSD_LOCK_TIMEOUT (5ULL * NSEC_PER_SEC)
 static atomic_t csd_bug_count = ATOMIC_INIT(0);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2699e9e562b1..9ad7d4569d4b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1539,7 +1539,8 @@ static int __rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	 * gracefully without invoking oom-killer and the system is not
 	 * destabilized.
 	 */
-	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL;
+        /* TODO(oweisse): this is a hack to enable ASI tracing. */
+	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_GLOBAL_NONSENSITIVE;
 
 	/*
 	 * If a user thread allocates too much, and si_mem_available()
@@ -1718,7 +1719,7 @@ struct trace_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 
 	/* keep it in its own cache line */
 	buffer = kzalloc(ALIGN(sizeof(*buffer), cache_line_size()),
-			 GFP_KERNEL);
+			 GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (!buffer)
 		return NULL;
 
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 64ea283f2f86..0ae6c38ee121 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -107,7 +107,7 @@ static void tp_stub_func(void)
 static inline void *allocate_probes(int count)
 {
 	struct tp_probes *p  = kmalloc(struct_size(p, probes, count),
-				       GFP_KERNEL);
+				       GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	return p == NULL ? NULL : p->probes;
 }
 
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index b3afafe46fff..c7d3342a7b30 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -248,8 +248,7 @@ radix_tree_node_alloc(gfp_t gfp_mask, struct radix_tree_node *parent,
 		 * cache first for the new node to get accounted to the memory
 		 * cgroup.
 		 */
-		ret = kmem_cache_alloc(radix_tree_node_cachep,
-				       gfp_mask | __GFP_NOWARN);
+		ret = kmem_cache_alloc(radix_tree_node_cachep, gfp_mask | __GFP_NOWARN);
 		if (ret)
 			goto out;
 
@@ -1597,9 +1596,10 @@ void __init radix_tree_init(void)
 	BUILD_BUG_ON(RADIX_TREE_MAX_TAGS + __GFP_BITS_SHIFT > 32);
 	BUILD_BUG_ON(ROOT_IS_IDR & ~GFP_ZONEMASK);
 	BUILD_BUG_ON(XA_CHUNK_SIZE > 255);
+        /*TODO: (oweisse) ASI add SLAB_NONSENSITIVE */
 	radix_tree_node_cachep = kmem_cache_create("radix_tree_node",
 			sizeof(struct radix_tree_node), 0,
-			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT,
+			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT | SLAB_GLOBAL_NONSENSITIVE,
 			radix_tree_node_ctor);
 	ret = cpuhp_setup_state_nocalls(CPUHP_RADIX_DEAD, "lib/radix:dead",
 					NULL, radix_tree_cpu_dead);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a66d6b222ecf..fbc42e96b157 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5143,20 +5143,21 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 	size = sizeof(struct mem_cgroup);
 	size += nr_node_ids * sizeof(struct mem_cgroup_per_node *);
 
-	memcg = kzalloc(size, GFP_KERNEL);
+	memcg = kzalloc(size, GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (!memcg)
 		return ERR_PTR(error);
 
 	memcg->id.id = idr_alloc(&mem_cgroup_idr, NULL,
 				 1, MEM_CGROUP_ID_MAX,
-				 GFP_KERNEL);
+				 GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
 	if (memcg->id.id < 0) {
 		error = memcg->id.id;
 		goto fail;
 	}
 
 	memcg->vmstats_percpu = alloc_percpu_gfp(struct memcg_vmstats_percpu,
-						 GFP_KERNEL_ACCOUNT);
+						 GFP_KERNEL_ACCOUNT |
+                                                 __GFP_GLOBAL_NONSENSITIVE);
 	if (!memcg->vmstats_percpu)
 		goto fail;
 
diff --git a/mm/util.c b/mm/util.c
index 741ba32a43ac..0a49e15a0765 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -196,7 +196,8 @@ void *vmemdup_user(const void __user *src, size_t len)
 {
 	void *p;
 
-	p = kvmalloc(len, GFP_USER);
+        /* TODO(oweisse): is this secure? */
+	p = kvmalloc(len, GFP_USER | __GFP_LOCAL_NONSENSITIVE);
 	if (!p)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a89866a926f6..659560f286b0 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3309,7 +3309,8 @@ EXPORT_SYMBOL(vzalloc);
 void *vmalloc_user(unsigned long size)
 {
 	return __vmalloc_node_range(size, SHMLBA,  VMALLOC_START, VMALLOC_END,
-				    GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL,
+				    GFP_KERNEL | __GFP_ZERO
+                                    | __GFP_LOCAL_NONSENSITIVE, PAGE_KERNEL,
 				    VM_USERMAP, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 909db87d7383..ce8c331386fb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -404,7 +404,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 		? skbuff_fclone_cache : skbuff_head_cache;
 
 	if (sk_memalloc_socks() && (flags & SKB_ALLOC_RX))
-		gfp_mask |= __GFP_MEMALLOC;
+		gfp_mask |= __GFP_MEMALLOC | __GFP_GLOBAL_NONSENSITIVE;
 
 	/* Get the HEAD */
 	if ((flags & (SKB_ALLOC_FCLONE | SKB_ALLOC_NAPI)) == SKB_ALLOC_NAPI &&
diff --git a/net/core/sock.c b/net/core/sock.c
index 41e91d0f7061..6f6e0bd5ebf1 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2704,7 +2704,7 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
 		/* Avoid direct reclaim but allow kswapd to wake */
 		pfrag->page = alloc_pages((gfp & ~__GFP_DIRECT_RECLAIM) |
 					  __GFP_COMP | __GFP_NOWARN |
-					  __GFP_NORETRY,
+					  __GFP_NORETRY | __GFP_GLOBAL_NONSENSITIVE,
 					  SKB_FRAG_PAGE_ORDER);
 		if (likely(pfrag->page)) {
 			pfrag->size = PAGE_SIZE << SKB_FRAG_PAGE_ORDER;
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 0be80c213f7f..5b87476566c4 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -111,7 +111,7 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 {
 	struct page *page;
 
-	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_LOCAL_NONSENSITIVE);
 	if (!page)
 		return -ENOMEM;
 
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2ad013b8bde9..40acb841135c 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -306,7 +306,8 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	if (!kvm_arch_irqfd_allowed(kvm, args))
 		return -EINVAL;
 
-	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL_ACCOUNT);
+	irqfd = kzalloc(sizeof(*irqfd),
+                        GFP_KERNEL_ACCOUNT | __GFP_GLOBAL_NONSENSITIVE);
 	if (!irqfd)
 		return -ENOMEM;
 
@@ -813,7 +814,7 @@ static int kvm_assign_ioeventfd_idx(struct kvm *kvm,
 	if (IS_ERR(eventfd))
 		return PTR_ERR(eventfd);
 
-	p = kzalloc(sizeof(*p), GFP_KERNEL_ACCOUNT);
+	p = kzalloc(sizeof(*p), GFP_KERNEL_ACCOUNT | __GFP_GLOBAL_NONSENSITIVE);
 	if (!p) {
 		ret = -ENOMEM;
 		goto fail;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8d2d76de5bd0..587a75428da8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -370,6 +370,9 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 					       gfp_t gfp_flags)
 {
 	gfp_flags |= mc->gfp_zero;
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	gfp_flags |= mc->gfp_asi;
+#endif
 
 	if (mc->kmem_cache)
 		return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
@@ -863,7 +866,8 @@ static struct kvm_memslots *kvm_alloc_memslots(void)
 	int i;
 	struct kvm_memslots *slots;
 
-	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
+	slots = kvzalloc(sizeof(struct kvm_memslots),
+                         GFP_KERNEL_ACCOUNT | __GFP_LOCAL_NONSENSITIVE);
 	if (!slots)
 		return NULL;
 
@@ -1529,7 +1533,7 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
 	else
 		new_size = kvm_memslots_size(old->used_slots);
 
-	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
+	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT | __GFP_LOCAL_NONSENSITIVE);
 	if (likely(slots))
 		kvm_copy_memslots(slots, old);
 
@@ -3565,7 +3569,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	}
 
 	BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
-	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_LOCAL_NONSENSITIVE);
 	if (!page) {
 		r = -ENOMEM;
 		goto vcpu_free;
@@ -4959,7 +4963,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 		return -ENOSPC;
 
 	new_bus = kmalloc(struct_size(bus, range, bus->dev_count + 1),
-			  GFP_KERNEL_ACCOUNT);
+			  GFP_KERNEL_ACCOUNT | __GFP_LOCAL_NONSENSITIVE);
 	if (!new_bus)
 		return -ENOMEM;
 
-- 
2.35.1.473.g83b2b277ed-goog

