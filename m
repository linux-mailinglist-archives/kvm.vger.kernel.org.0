Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D011F1C90
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 18:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgFHQAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 12:00:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40567 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730231AbgFHQAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 12:00:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591632040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YnXWU+VOYKQA/aDp0JdHDPTAh2f+1i7H5RxXYKlXZYw=;
        b=IjYPLawDkzuIVVTclwTOl2dysd3cm5t2crY4fXohqTGHp1kSJ6Yk/hBN6WGZ1srxkk965d
        WoRovhTVhTbwmpN1MO2plR3HCXy0WfbRTjIudWJcvRvVhxAcA3MSU22tp5x5xwsmNHwWAf
        h4KC6Qg+lLirwRKrNgAvt3CNyDB5vu8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-5oYXFxx1P_e9zbALYgt8Rg-1; Mon, 08 Jun 2020 12:00:35 -0400
X-MC-Unique: 5oYXFxx1P_e9zbALYgt8Rg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 354FA800053
        for <kvm@vger.kernel.org>; Mon,  8 Jun 2020 16:00:34 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9F005D9C9;
        Mon,  8 Jun 2020 16:00:33 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     cavery@redhat.com
Subject: [PATCH kvm-unit-tests] x86: always set up SMP
Date:   Mon,  8 Jun 2020 12:00:33 -0400
Message-Id: <20200608160033.392059-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently setup_vm cannot assume that it can invoke IPIs, and therefore
only initializes CR0/CR3/CR4 on the CPU it runs on.  In order to keep the
initialization code clean, let's just call smp_init (and therefore
setup_idt) unconditionally.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/access.c              | 2 --
 x86/apic.c                | 1 -
 x86/asyncpf.c             | 1 -
 x86/cmpxchg8b.c           | 1 -
 x86/cstart.S              | 6 +++---
 x86/cstart64.S            | 6 +++---
 x86/debug.c               | 1 -
 x86/emulator.c            | 1 -
 x86/eventinj.c            | 1 -
 x86/hypercall.c           | 1 -
 x86/hyperv_clock.c        | 1 -
 x86/hyperv_connections.c  | 1 -
 x86/hyperv_stimer.c       | 1 -
 x86/hyperv_synic.c        | 1 -
 x86/idt_test.c            | 1 -
 x86/intel-iommu.c         | 1 -
 x86/ioapic.c              | 1 -
 x86/kvmclock_test.c       | 2 --
 x86/memory.c              | 1 -
 x86/pcid.c                | 2 --
 x86/pmu.c                 | 1 -
 x86/rdpru.c               | 2 --
 x86/smptest.c             | 2 --
 x86/svm.c                 | 1 -
 x86/syscall.c             | 1 -
 x86/taskswitch2.c         | 1 -
 x86/tscdeadline_latency.c | 1 -
 x86/umip.c                | 1 -
 x86/vmexit.c              | 1 -
 x86/vmware_backdoors.c    | 1 -
 x86/vmx.c                 | 1 -
 x86/xsave.c               | 1 -
 32 files changed, 6 insertions(+), 41 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 068b4dc..ac879c3 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -1025,8 +1025,6 @@ int main(void)
 {
     int r;
 
-    setup_idt();
-
     printf("starting test\n\n");
     page_table_levels = 4;
     r = ac_test_run();
diff --git a/x86/apic.c b/x86/apic.c
index 2aacad6..a7681fe 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -648,7 +648,6 @@ static void test_pv_ipi(void)
 int main(void)
 {
     setup_vm();
-    smp_init();
 
     test_lapic_existence();
 
diff --git a/x86/asyncpf.c b/x86/asyncpf.c
index 80bbe45..305a923 100644
--- a/x86/asyncpf.c
+++ b/x86/asyncpf.c
@@ -90,7 +90,6 @@ int main(int ac, char **av)
 	int loop = 2;
 
 	setup_vm();
-	setup_idt();
 	printf("install handler\n");
 	handle_exception(14, pf_isr);
 	apf_reason = 0;
diff --git a/x86/cmpxchg8b.c b/x86/cmpxchg8b.c
index bbba2f9..a416f44 100644
--- a/x86/cmpxchg8b.c
+++ b/x86/cmpxchg8b.c
@@ -20,7 +20,6 @@ static void test_cmpxchg8b(u32 *mem)
 int main(void)
 {
 	setup_vm();
-	setup_idt();
 
 	test_cmpxchg8b(phys_to_virt(read_cr3()) + 4088);
 	return report_summary();
diff --git a/x86/cstart.S b/x86/cstart.S
index 8462da3..38ac19b 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -161,8 +161,9 @@ start32:
 	call load_tss
 	call mask_pic_interrupts
 	call enable_apic
-	call smp_init
+	call ap_init
 	call enable_x2apic
+	call smp_init
         push $__environ
         push $__argv
         push __argc
@@ -191,7 +192,7 @@ load_tss:
 	ltr %ax
 	ret
 
-smp_init:
+ap_init:
 	cld
 	lea sipi_entry, %esi
 	xor %edi, %edi
@@ -204,7 +205,6 @@ smp_init:
 1:	pause
 	cmpw %ax, cpu_online_count
 	jne 1b
-smp_init_done:
 	ret
 
 online_cpus:
diff --git a/x86/cstart64.S b/x86/cstart64.S
index cffbb07..1ecfbdb 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -257,8 +257,9 @@ start64:
 	mov %rax, __args(%rip)
 	call __setup_args
 
-	call smp_init
+	call ap_init
 	call enable_x2apic
+	call smp_init
 
 	mov __argc(%rip), %edi
 	lea __argv(%rip), %rsi
@@ -308,7 +309,7 @@ load_tss:
 	ltr %ax
 	ret
 
-smp_init:
+ap_init:
 	cld
 	lea sipi_entry, %rsi
 	xor %rdi, %rdi
@@ -321,7 +322,6 @@ smp_init:
 1:	pause
 	cmpw %ax, cpu_online_count
 	jne 1b
-smp_init_done:
 	ret
 
 cpu_online_count:	.word 1
diff --git a/x86/debug.c b/x86/debug.c
index 972762a..9798e62 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -76,7 +76,6 @@ int main(int ac, char **av)
 {
 	unsigned long start;
 
-	setup_idt();
 	handle_exception(DB_VECTOR, handle_db);
 	handle_exception(BP_VECTOR, handle_bp);
 
diff --git a/x86/emulator.c b/x86/emulator.c
index 2990550..98743d1 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -1027,7 +1027,6 @@ int main(void)
 	unsigned long t1, t2;
 
 	setup_vm();
-	setup_idt();
 	handle_exception(UD_VECTOR, record_no_fep);
 	asm(KVM_FEP "nop");
 	handle_exception(UD_VECTOR, 0);
diff --git a/x86/eventinj.c b/x86/eventinj.c
index aa7c233..46593c9 100644
--- a/x86/eventinj.c
+++ b/x86/eventinj.c
@@ -212,7 +212,6 @@ int main(void)
 	ulong *pt, *cr3, i;
 
 	setup_vm();
-	setup_idt();
 	setup_alt_stack();
 
 	handle_irq(32, tirq0);
diff --git a/x86/hypercall.c b/x86/hypercall.c
index 7fbbf30..28760e3 100644
--- a/x86/hypercall.c
+++ b/x86/hypercall.c
@@ -58,7 +58,6 @@ int main(int ac, char **av)
 
 #ifdef __x86_64__
 	setup_vm();
-	setup_idt();
 	setup_alt_stack();
 	set_intr_alt_stack(13, gp_tss);
 
diff --git a/x86/hyperv_clock.c b/x86/hyperv_clock.c
index 99775a9..b4cfc9f 100644
--- a/x86/hyperv_clock.c
+++ b/x86/hyperv_clock.c
@@ -151,7 +151,6 @@ int main(int ac, char **av)
 	uint64_t ref1, ref2;
 
 	setup_vm();
-	smp_init();
 
 	ncpus = cpu_count();
 	if (ncpus > MAX_CPU)
diff --git a/x86/hyperv_connections.c b/x86/hyperv_connections.c
index 55cc033..6e8ac32 100644
--- a/x86/hyperv_connections.c
+++ b/x86/hyperv_connections.c
@@ -272,7 +272,6 @@ int main(int ac, char **av)
 	}
 
 	setup_vm();
-	smp_init();
 	ncpus = cpu_count();
 	if (ncpus > MAX_CPUS)
 		report_abort("# cpus: %d > %d", ncpus, MAX_CPUS);
diff --git a/x86/hyperv_stimer.c b/x86/hyperv_stimer.c
index ddfc844..75a69a1 100644
--- a/x86/hyperv_stimer.c
+++ b/x86/hyperv_stimer.c
@@ -336,7 +336,6 @@ static void stimer_test_all(void)
     int ncpus;
 
     setup_vm();
-    smp_init();
     enable_apic();
 
     ncpus = cpu_count();
diff --git a/x86/hyperv_synic.c b/x86/hyperv_synic.c
index b6c7104..25121ca 100644
--- a/x86/hyperv_synic.c
+++ b/x86/hyperv_synic.c
@@ -147,7 +147,6 @@ int main(int ac, char **av)
         bool ok;
 
         setup_vm();
-        smp_init();
         enable_apic();
 
         ncpus = cpu_count();
diff --git a/x86/idt_test.c b/x86/idt_test.c
index 964f119..5d0fc79 100644
--- a/x86/idt_test.c
+++ b/x86/idt_test.c
@@ -30,7 +30,6 @@ int main(void)
     bool rflags_rf;
 
     printf("Starting IDT test\n");
-    setup_idt();
     r = test_gp(&rflags_rf);
     report(r == GP_VECTOR, "Testing #GP");
     report(rflags_rf, "Testing #GP rflags.rf");
diff --git a/x86/intel-iommu.c b/x86/intel-iommu.c
index 25feec0..4442fe1 100644
--- a/x86/intel-iommu.c
+++ b/x86/intel-iommu.c
@@ -133,7 +133,6 @@ static void vtd_test_ir(void)
 int main(int argc, char *argv[])
 {
 	setup_vm();
-	smp_init();
 
 	vtd_init();
 
diff --git a/x86/ioapic.c b/x86/ioapic.c
index f315e4b..b9f6dd2 100644
--- a/x86/ioapic.c
+++ b/x86/ioapic.c
@@ -471,7 +471,6 @@ static void update_cr3(void *cr3)
 int main(void)
 {
 	setup_vm();
-	smp_init();
 
 	on_cpus(update_cr3, (void *)read_cr3());
 	mask_pic_interrupts();
diff --git a/x86/kvmclock_test.c b/x86/kvmclock_test.c
index 48a7cdb..de4b5e1 100644
--- a/x86/kvmclock_test.c
+++ b/x86/kvmclock_test.c
@@ -115,8 +115,6 @@ int main(int ac, char **av)
         if (ac > 3)
                 threshold = atol(av[3]);
 
-        smp_init();
-
         ncpus = cpu_count();
         if (ncpus > MAX_CPU)
                 report_abort("number cpus exceeds %d", MAX_CPU);
diff --git a/x86/memory.c b/x86/memory.c
index 22c50c9..8f61020 100644
--- a/x86/memory.c
+++ b/x86/memory.c
@@ -27,7 +27,6 @@ int main(int ac, char **av)
 {
 	int expected;
 
-	setup_idt();
 	handle_exception(UD_VECTOR, handle_ud);
 
 	/* 3-byte instructions: */
diff --git a/x86/pcid.c b/x86/pcid.c
index ad9d30c..a8dc8cb 100644
--- a/x86/pcid.c
+++ b/x86/pcid.c
@@ -130,8 +130,6 @@ int main(int ac, char **av)
 {
     int pcid_enabled = 0, invpcid_enabled = 0;
 
-    setup_idt();
-
     if (this_cpu_has(X86_FEATURE_PCID))
         pcid_enabled = 1;
     if (this_cpu_has(X86_FEATURE_INVPCID))
diff --git a/x86/pmu.c b/x86/pmu.c
index acba20e..57a2b23 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -533,7 +533,6 @@ int main(int ac, char **av)
 	struct cpuid id = cpuid(10);
 
 	setup_vm();
-	setup_idt();
 	handle_irq(PC_VECTOR, cnt_overflow);
 	buf = malloc(N*64);
 
diff --git a/x86/rdpru.c b/x86/rdpru.c
index 127ba1c..5cb69cb 100644
--- a/x86/rdpru.c
+++ b/x86/rdpru.c
@@ -14,8 +14,6 @@ static int rdpru_checking(void)
 
 int main(int ac, char **av)
 {
-	setup_idt();
-
 	if (this_cpu_has(X86_FEATURE_RDPRU))
 		report_skip("RDPRU raises #UD");
 	else
diff --git a/x86/smptest.c b/x86/smptest.c
index 1b0ae3e..2989aa0 100644
--- a/x86/smptest.c
+++ b/x86/smptest.c
@@ -19,8 +19,6 @@ int main(void)
     int ncpus;
     int i;
 
-    smp_init();
-
     ncpus = cpu_count();
     printf("found %d cpus\n", ncpus);
     for (i = 0; i < ncpus; ++i)
diff --git a/x86/svm.c b/x86/svm.c
index 41685bf..f35c063 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -375,7 +375,6 @@ int main(int ac, char **av)
 	av++;
 
 	setup_vm();
-	smp_init();
 
 	if (!this_cpu_has(X86_FEATURE_SVM)) {
 		printf("SVM not availble\n");
diff --git a/x86/syscall.c b/x86/syscall.c
index b7e29d6..8cef860 100644
--- a/x86/syscall.c
+++ b/x86/syscall.c
@@ -100,7 +100,6 @@ static void test_syscall_tf(void)
 
 int main(int ac, char **av)
 {
-    setup_idt();
     test_syscall_lazy_load();
     test_syscall_tf();
 
diff --git a/x86/taskswitch2.c b/x86/taskswitch2.c
index 4dc6337..ed3f99a 100644
--- a/x86/taskswitch2.c
+++ b/x86/taskswitch2.c
@@ -283,7 +283,6 @@ static void test_conforming_switch(void)
 int main(void)
 {
 	setup_vm();
-	setup_idt();
 	setup_tss32();
 
 	test_gdt_task_gate();
diff --git a/x86/tscdeadline_latency.c b/x86/tscdeadline_latency.c
index 4e6ac18..a3bc4ea 100644
--- a/x86/tscdeadline_latency.c
+++ b/x86/tscdeadline_latency.c
@@ -105,7 +105,6 @@ int main(int argc, char **argv)
     int i, size;
 
     setup_vm();
-    smp_init();
 
     test_lapic_existence();
 
diff --git a/x86/umip.c b/x86/umip.c
index 7eee294..afb373d 100644
--- a/x86/umip.c
+++ b/x86/umip.c
@@ -172,7 +172,6 @@ int main(void)
 {
     extern unsigned char kernel_entry;
 
-    setup_idt();
     set_idt_entry(0x20, &kernel_entry, 3);
     handle_exception(13, gp_handler);
     set_iopl(3);
diff --git a/x86/vmexit.c b/x86/vmexit.c
index acdcbdc..47efb63 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -581,7 +581,6 @@ int main(int ac, char **av)
 	struct pci_dev pcidev;
 	int ret;
 
-	smp_init();
 	setup_vm();
 	handle_irq(IPI_TEST_VECTOR, self_ipi_isr);
 	nr_cpus = cpu_count();
diff --git a/x86/vmware_backdoors.c b/x86/vmware_backdoors.c
index f718f16..b4902a9 100644
--- a/x86/vmware_backdoors.c
+++ b/x86/vmware_backdoors.c
@@ -183,7 +183,6 @@ static void check_vmware_backdoors(void)
 int main(int ac, char **av)
 {
 	setup_vm();
-	setup_idt();
 
 	check_vmware_backdoors();
 
diff --git a/x86/vmx.c b/x86/vmx.c
index 3f496ae..fe7d5f1 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -2077,7 +2077,6 @@ int main(int argc, const char *argv[])
 	int i = 0;
 
 	setup_vm();
-	smp_init();
 	hypercall_field = 0;
 
 	/* We want xAPIC mode to test MMIO passthrough from L1 (us) to L2.  */
diff --git a/x86/xsave.c b/x86/xsave.c
index 93ba769..892bf56 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -151,7 +151,6 @@ static void test_no_xsave(void)
 
 int main(void)
 {
-    setup_idt();
     if (this_cpu_has(X86_FEATURE_XSAVE)) {
         printf("CPU has XSAVE feature\n");
         test_xsave();
-- 
2.26.2

