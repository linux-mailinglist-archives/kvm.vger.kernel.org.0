Return-Path: <kvm+bounces-45157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC459AA62DE
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 20:34:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C494717D5EA
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74994227E98;
	Thu,  1 May 2025 18:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="peZ9TEJe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E492225785
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 18:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746124414; cv=none; b=idY1VfEmyqDD1lwsKMPSCj57UxjXIWzU5IzBf1J/NiLSkGdW4oB/v276eiURZ7XERR1ynaStsPFbaJI9JoMyYQsrVpXBnSPLx7z0DkcaJeAqd4cSv4n2oXrrGGwmm18BI1xKb5h9UmSESDW9IEwfNruXReTzOTgo8zs18ytommI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746124414; c=relaxed/simple;
	bh=bvk1Mgd0YV3f9Hf+bxlCmj0W4bBWe/vEekA9LPMtQVc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U0+r4wTV/kA4JnOWeNgFbRayfDviIIP3yQiPq+nrhyn0KEgmWiZtNwuIa5y6yGHFLyL6pQNHyZtdPVWHXfLALOY64t9Aot5NhehJsOU+n1tz2pk7nr09gD5HCy6y1f4OoH4RH1RO+eT1VbfDAmmQs8csR17JzbAewzVN67E0m3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=peZ9TEJe; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736c7d0d35aso1637162b3a.1
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 11:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746124411; x=1746729211; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xlx4tV6h33iC87PZJPQATc9y7zJNlmmrmJf6elpZSAw=;
        b=peZ9TEJeXQLxUPyWEjuDPQ75bl+7+F52v4JsNypaq0fo0xjUDeSPSQhrU1YcSFArgE
         NURvnzsVPud4gtJp1PAO0diyU17uPKgiOSjZi9eh6RizOVyhj0jMKQ/uGvH/uvNGemQH
         jseQce/mgZOw6fYVmMw+VTTYq2W9ifrMTKH/ILIGj/4m5onsnBHgpaIPQNivJ7N8WZdu
         BW212Z6PJrfUjtLqCUlYvdUK0VSaqFQpXp0TcOlcJIymw1gaKykuk/OVizRwY7qeGFO6
         oz/TV6bGY6942VEFky4ZqI7Hu9BnKjA/59jQry2PZp8BDAvSvnea0OC0TG7HJNV3bVt5
         qaAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746124411; x=1746729211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xlx4tV6h33iC87PZJPQATc9y7zJNlmmrmJf6elpZSAw=;
        b=a6fd6e6ssOoEkZWVinDLXMncL5pvdjGd41hQkSjOt/Y5StEAluT9ze0aeS/uuCk8iZ
         ErssqwsXkgMO+JaDFu39YlLjWKq0v/Dbxz4PmrkFad1WaXWXhhtaybbNmxAsiG4hZQ9Z
         pDP2YZDE7fOe2S831HzjhIlA7OfznikVyO1bz5HbEDnpPXVEcB9CJj+nrJe3qoHlYDlp
         o22HzgEtI1SvOlUxrgc+4L64EHctW2t35z9ecj3ggIKPOsEYksgU2vAPbv4KYy1WOiVq
         RRkMuou6aJElJyGJNDE+UY9aS2++nIUc8bKZrzLg5TV0ZrxQ7KGExG1tNfUoF9kl7vR5
         kuGg==
X-Forwarded-Encrypted: i=1; AJvYcCWuTKEYVjrv8Pv5ItHib3h71DupaX6dbNnUmGxhBLz5BAXp5pXmKIVyR20NiRkiGEpCR4E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPgxrriqVl9xQdTyIogn/A9p7VcT1ERDDjZZhlhC5yC6LIXRHA
	DMtrFLt/ga45KulM6cPO3X6hZyPiutQTIwE66BjibNBuR93l78fkRGlaxFWz6Yg78MJBYU8geOL
	JJlI3BfLZRg==
X-Google-Smtp-Source: AGHT+IESw44bOvollCXHRWIMOqOhriygGcemnEccKJNHW6iOs3OJ4aCqVXw9VbGTtVmbRkfpoeS6ESpUu1c4rQ==
X-Received: from pfgt3.prod.google.com ([2002:a05:6a00:1383:b0:736:3cd5:ba36])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1312:b0:736:6043:69f9 with SMTP id d2e1a72fcca58-7404790137cmr5244369b3a.19.1746124410653;
 Thu, 01 May 2025 11:33:30 -0700 (PDT)
Date: Thu,  1 May 2025 11:33:04 -0700
In-Reply-To: <20250501183304.2433192-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <20250501183304.2433192-11-dmatlack@google.com>
Subject: [PATCH 10/10] KVM: selftests: Use u8 instead of uint8_t
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	David Hildenbrand <david@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	David Matlack <dmatlack@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Eric Auger <eric.auger@redhat.com>, James Houghton <jthoughton@google.com>, 
	Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Use u8 instead of uint8_t to make the KVM selftests code more concise
and more similar to the kernel (since selftests are primarily developed
by kernel developers).

This commit was generated with the following command:

  git ls-files tools/testing/selftests/kvm | xargs sed -i 's/uint8_t/u8/g'

Then by manually adjusting whitespace to make checkpatch.pl happy.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/arm64/debug-exceptions.c    | 16 ++---
 .../testing/selftests/kvm/arm64/set_id_regs.c |  6 +-
 .../selftests/kvm/arm64/vpmu_counter_access.c |  2 +-
 .../testing/selftests/kvm/coalesced_io_test.c |  2 +-
 tools/testing/selftests/kvm/get-reg-list.c    |  2 +-
 .../testing/selftests/kvm/include/kvm_util.h  | 14 ++---
 .../testing/selftests/kvm/include/test_util.h |  2 +-
 .../testing/selftests/kvm/include/x86/apic.h  |  6 +-
 .../selftests/kvm/include/x86/hyperv.h        | 10 ++--
 .../selftests/kvm/include/x86/processor.h     | 20 +++----
 tools/testing/selftests/kvm/include/x86/sev.h |  4 +-
 tools/testing/selftests/kvm/include/x86/vmx.h | 12 ++--
 .../selftests/kvm/lib/arm64/processor.c       |  8 +--
 .../testing/selftests/kvm/lib/guest_sprintf.c |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  2 +-
 .../selftests/kvm/lib/riscv/processor.c       |  6 +-
 .../selftests/kvm/lib/s390/processor.c        |  8 +--
 tools/testing/selftests/kvm/lib/sparsebit.c   |  2 +-
 .../testing/selftests/kvm/lib/x86/processor.c | 16 ++---
 tools/testing/selftests/kvm/lib/x86/sev.c     |  4 +-
 .../testing/selftests/kvm/memslot_perf_test.c |  2 +-
 tools/testing/selftests/kvm/mmu_stress_test.c |  2 +-
 tools/testing/selftests/kvm/s390/memop.c      | 28 ++++-----
 tools/testing/selftests/kvm/s390/resets.c     |  2 +-
 .../selftests/kvm/s390/shared_zeropage_test.c |  2 +-
 tools/testing/selftests/kvm/s390/tprot.c      | 12 ++--
 .../selftests/kvm/set_memory_region_test.c    |  2 +-
 tools/testing/selftests/kvm/steal_time.c      |  4 +-
 .../selftests/kvm/x86/fix_hypercall_test.c    | 12 ++--
 .../selftests/kvm/x86/flds_emulation.h        |  2 +-
 .../selftests/kvm/x86/hyperv_features.c       |  4 +-
 tools/testing/selftests/kvm/x86/kvm_pv_test.c |  2 +-
 .../selftests/kvm/x86/nested_emulation_test.c |  8 +--
 .../selftests/kvm/x86/platform_info_test.c    |  2 +-
 .../selftests/kvm/x86/pmu_counters_test.c     | 60 +++++++++----------
 .../selftests/kvm/x86/pmu_event_filter_test.c | 12 ++--
 .../kvm/x86/private_mem_conversions_test.c    | 24 ++++----
 tools/testing/selftests/kvm/x86/smm_test.c    |  2 +-
 tools/testing/selftests/kvm/x86/state_test.c  |  4 +-
 .../selftests/kvm/x86/userspace_io_test.c     |  4 +-
 .../kvm/x86/userspace_msr_exit_test.c         | 14 ++---
 .../selftests/kvm/x86/vmx_pmu_caps_test.c     |  2 +-
 .../selftests/kvm/x86/xen_shinfo_test.c       |  4 +-
 43 files changed, 177 insertions(+), 177 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/debug-exceptions.c b/tools/testing/selftests/kvm/arm64/debug-exceptions.c
index 8576e707b05e..4b5de274584e 100644
--- a/tools/testing/selftests/kvm/arm64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/arm64/debug-exceptions.c
@@ -102,7 +102,7 @@ GEN_DEBUG_WRITE_REG(dbgwvr)
 
 static void reset_debug_state(void)
 {
-	uint8_t brps, wrps, i;
+	u8 brps, wrps, i;
 	u64 dfr0;
 
 	asm volatile("msr daifset, #8");
@@ -149,7 +149,7 @@ static void enable_monitor_debug_exceptions(void)
 	isb();
 }
 
-static void install_wp(uint8_t wpn, u64 addr)
+static void install_wp(u8 wpn, u64 addr)
 {
 	u32 wcr;
 
@@ -162,7 +162,7 @@ static void install_wp(uint8_t wpn, u64 addr)
 	enable_monitor_debug_exceptions();
 }
 
-static void install_hw_bp(uint8_t bpn, u64 addr)
+static void install_hw_bp(u8 bpn, u64 addr)
 {
 	u32 bcr;
 
@@ -174,7 +174,7 @@ static void install_hw_bp(uint8_t bpn, u64 addr)
 	enable_monitor_debug_exceptions();
 }
 
-static void install_wp_ctx(uint8_t addr_wp, uint8_t ctx_bp, u64 addr,
+static void install_wp_ctx(u8 addr_wp, u8 ctx_bp, u64 addr,
 			   u64 ctx)
 {
 	u32 wcr;
@@ -196,7 +196,7 @@ static void install_wp_ctx(uint8_t addr_wp, uint8_t ctx_bp, u64 addr,
 	enable_monitor_debug_exceptions();
 }
 
-void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, u64 addr,
+void install_hw_bp_ctx(u8 addr_bp, u8 ctx_bp, u64 addr,
 		       u64 ctx)
 {
 	u32 addr_bcr, ctx_bcr;
@@ -234,7 +234,7 @@ static void install_ss(void)
 
 static volatile char write_data;
 
-static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
+static void guest_code(u8 bpn, u8 wpn, u8 ctx_bpn)
 {
 	u64 ctx = 0xabcdef;	/* a random context number */
 
@@ -421,7 +421,7 @@ static int debug_version(u64 id_aa64dfr0)
 	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), id_aa64dfr0);
 }
 
-static void test_guest_debug_exceptions(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
+static void test_guest_debug_exceptions(u8 bpn, u8 wpn, u8 ctx_bpn)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -534,7 +534,7 @@ void test_single_step_from_userspace(int test_cnt)
  */
 void test_guest_debug_exceptions_all(u64 aa64dfr0)
 {
-	uint8_t brp_num, wrp_num, ctx_brp_num, normal_brp_num, ctx_brp_base;
+	u8 brp_num, wrp_num, ctx_brp_num, normal_brp_num, ctx_brp_base;
 	int b, w, c;
 
 	/* Number of breakpoints */
diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 77c197ef4f4a..20fcebe90741 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -30,7 +30,7 @@ struct reg_ftr_bits {
 	char *name;
 	bool sign;
 	enum ftr_type type;
-	uint8_t shift;
+	u8 shift;
 	u64 mask;
 	/*
 	 * For FTR_EXACT, safe_val is used as the exact safe value.
@@ -347,7 +347,7 @@ u64 get_invalid_value(const struct reg_ftr_bits *ftr_bits, u64 ftr)
 static u64 test_reg_set_success(struct kvm_vcpu *vcpu, u64 reg,
 				const struct reg_ftr_bits *ftr_bits)
 {
-	uint8_t shift = ftr_bits->shift;
+	u8 shift = ftr_bits->shift;
 	u64 mask = ftr_bits->mask;
 	u64 val, new_val, ftr;
 
@@ -370,7 +370,7 @@ static u64 test_reg_set_success(struct kvm_vcpu *vcpu, u64 reg,
 static void test_reg_set_fail(struct kvm_vcpu *vcpu, u64 reg,
 			      const struct reg_ftr_bits *ftr_bits)
 {
-	uint8_t shift = ftr_bits->shift;
+	u8 shift = ftr_bits->shift;
 	u64 mask = ftr_bits->mask;
 	u64 val, old_val, ftr;
 	int r;
diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index 986ff950a652..c2af221ca6ca 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -408,7 +408,7 @@ static void guest_code(u64 expected_pmcr_n)
 static void create_vpmu_vm(void *guest_code)
 {
 	struct kvm_vcpu_init init;
-	uint8_t pmuver, ec;
+	u8 pmuver, ec;
 	u64 dfr0, irq = 23;
 	struct kvm_device_attr irq_attr = {
 		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
diff --git a/tools/testing/selftests/kvm/coalesced_io_test.c b/tools/testing/selftests/kvm/coalesced_io_test.c
index f5ab412d2042..df4ed5e3877c 100644
--- a/tools/testing/selftests/kvm/coalesced_io_test.c
+++ b/tools/testing/selftests/kvm/coalesced_io_test.c
@@ -23,7 +23,7 @@ struct kvm_coalesced_io {
 	 * amount of #ifdeffery and complexity, without having to sacrifice
 	 * verbose error messages.
 	 */
-	uint8_t pio_port;
+	u8 pio_port;
 };
 
 static struct kvm_coalesced_io kvm_builtin_io_ring;
diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing/selftests/kvm/get-reg-list.c
index 91f05f78e824..9c791fdd7123 100644
--- a/tools/testing/selftests/kvm/get-reg-list.c
+++ b/tools/testing/selftests/kvm/get-reg-list.c
@@ -213,7 +213,7 @@ static void run_test(struct vcpu_reg_list *c)
 	 * since we don't know the capabilities of any new registers.
 	 */
 	for_each_present_blessed_reg(i) {
-		uint8_t addr[2048 / 8];
+		u8 addr[2048 / 8];
 		struct kvm_one_reg reg = {
 			.id = reg_list->reg[i],
 			.addr = (__u64)&addr,
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 271d7a434a4c..7edffa281c91 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -183,8 +183,8 @@ enum vm_guest_mode {
 
 struct vm_shape {
 	u32 type;
-	uint8_t  mode;
-	uint8_t  pad0;
+	u8  mode;
+	u8  pad0;
 	u16 pad1;
 };
 
@@ -432,7 +432,7 @@ void kvm_vm_release(struct kvm_vm *vmp);
 void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename);
 int kvm_memfd_alloc(size_t size, bool hugepages);
 
-void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
+void vm_dump(FILE *stream, struct kvm_vm *vm, u8 indent);
 
 static inline void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log)
 {
@@ -1016,10 +1016,10 @@ vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
 void assert_on_unhandled_exception(struct kvm_vcpu *vcpu);
 
 void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu,
-		    uint8_t indent);
+		    u8 indent);
 
 static inline void vcpu_dump(FILE *stream, struct kvm_vcpu *vcpu,
-			     uint8_t indent)
+			     u8 indent)
 {
 	vcpu_arch_dump(stream, vcpu, indent);
 }
@@ -1123,9 +1123,9 @@ static inline gpa_t addr_gva2gpa(struct kvm_vm *vm, gva_t gva)
  * Dumps to the FILE stream given by @stream, the contents of all the
  * virtual translation tables for the VM given by @vm.
  */
-void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
+void virt_arch_dump(FILE *stream, struct kvm_vm *vm, u8 indent);
 
-static inline void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
+static inline void virt_dump(FILE *stream, struct kvm_vm *vm, u8 indent)
 {
 	virt_arch_dump(stream, vm, indent);
 }
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 5608008cfe61..c7f6a3ee6793 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -100,7 +100,7 @@ struct guest_random_state new_guest_random_state(u32 seed);
 u32 guest_random_u32(struct guest_random_state *state);
 
 static inline bool __guest_random_bool(struct guest_random_state *state,
-				       uint8_t percent)
+				       u8 percent)
 {
 	return (guest_random_u32(state) % 100) < percent;
 }
diff --git a/tools/testing/selftests/kvm/include/x86/apic.h b/tools/testing/selftests/kvm/include/x86/apic.h
index 2d164405e7f2..f86bd22f4c16 100644
--- a/tools/testing/selftests/kvm/include/x86/apic.h
+++ b/tools/testing/selftests/kvm/include/x86/apic.h
@@ -92,14 +92,14 @@ static inline u64 x2apic_read_reg(unsigned int reg)
 	return rdmsr(APIC_BASE_MSR + (reg >> 4));
 }
 
-static inline uint8_t x2apic_write_reg_safe(unsigned int reg, u64 value)
+static inline u8 x2apic_write_reg_safe(unsigned int reg, u64 value)
 {
 	return wrmsr_safe(APIC_BASE_MSR + (reg >> 4), value);
 }
 
 static inline void x2apic_write_reg(unsigned int reg, u64 value)
 {
-	uint8_t fault = x2apic_write_reg_safe(reg, value);
+	u8 fault = x2apic_write_reg_safe(reg, value);
 
 	__GUEST_ASSERT(!fault, "Unexpected fault 0x%x on WRMSR(%x) = %lx\n",
 		       fault, APIC_BASE_MSR + (reg >> 4), value);
@@ -107,7 +107,7 @@ static inline void x2apic_write_reg(unsigned int reg, u64 value)
 
 static inline void x2apic_write_reg_fault(unsigned int reg, u64 value)
 {
-	uint8_t fault = x2apic_write_reg_safe(reg, value);
+	u8 fault = x2apic_write_reg_safe(reg, value);
 
 	__GUEST_ASSERT(fault == GP_VECTOR,
 		       "Wanted #GP on WRMSR(%x) = %lx, got 0x%x\n",
diff --git a/tools/testing/selftests/kvm/include/x86/hyperv.h b/tools/testing/selftests/kvm/include/x86/hyperv.h
index 2add2123e37b..78003f5a22f3 100644
--- a/tools/testing/selftests/kvm/include/x86/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86/hyperv.h
@@ -254,12 +254,12 @@
  * Issue a Hyper-V hypercall. Returns exception vector raised or 0, 'hv_status'
  * is set to the hypercall status (if no exception occurred).
  */
-static inline uint8_t __hyperv_hypercall(u64 control, gva_t input_address,
-					 gva_t output_address,
-					 u64 *hv_status)
+static inline u8 __hyperv_hypercall(u64 control, gva_t input_address,
+				    gva_t output_address,
+				    u64 *hv_status)
 {
 	u64 error_code;
-	uint8_t vector;
+	u8 vector;
 
 	/* Note both the hypercall and the "asm safe" clobber r9-r11. */
 	asm volatile("mov %[output_address], %%r8\n\t"
@@ -278,7 +278,7 @@ static inline void hyperv_hypercall(u64 control, gva_t input_address,
 				    gva_t output_address)
 {
 	u64 hv_status;
-	uint8_t vector;
+	u8 vector;
 
 	vector = __hyperv_hypercall(control, input_address, output_address, &hv_status);
 
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 302836e276e0..5598ea6b86df 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -694,7 +694,7 @@ static inline bool this_cpu_is_amd(void)
 }
 
 static inline u32 __this_cpu_has(u32 function, u32 index,
-				 uint8_t reg, uint8_t lo, uint8_t hi)
+				 u8 reg, u8 lo, u8 hi)
 {
 	u32 gprs[4];
 
@@ -1074,7 +1074,7 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
 			     struct kvm_x86_cpu_property property,
 			     u32 value);
-void vcpu_set_cpuid_maxphyaddr(struct kvm_vcpu *vcpu, uint8_t maxphyaddr);
+void vcpu_set_cpuid_maxphyaddr(struct kvm_vcpu *vcpu, u8 maxphyaddr);
 
 void vcpu_clear_cpuid_entry(struct kvm_vcpu *vcpu, u32 function);
 
@@ -1227,7 +1227,7 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 #define kvm_asm_safe(insn, inputs...)					\
 ({									\
 	u64 ign_error_code;					\
-	uint8_t vector;							\
+	u8 vector;							\
 									\
 	asm volatile(KVM_ASM_SAFE(insn)					\
 		     : KVM_ASM_SAFE_OUTPUTS(vector, ign_error_code)	\
@@ -1238,7 +1238,7 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 
 #define kvm_asm_safe_ec(insn, error_code, inputs...)			\
 ({									\
-	uint8_t vector;							\
+	u8 vector;							\
 									\
 	asm volatile(KVM_ASM_SAFE(insn)					\
 		     : KVM_ASM_SAFE_OUTPUTS(vector, error_code)		\
@@ -1250,7 +1250,7 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 #define kvm_asm_safe_fep(insn, inputs...)				\
 ({									\
 	u64 ign_error_code;					\
-	uint8_t vector;							\
+	u8 vector;							\
 									\
 	asm volatile(KVM_ASM_SAFE_FEP(insn)				\
 		     : KVM_ASM_SAFE_OUTPUTS(vector, ign_error_code)	\
@@ -1261,7 +1261,7 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 
 #define kvm_asm_safe_ec_fep(insn, error_code, inputs...)		\
 ({									\
-	uint8_t vector;							\
+	u8 vector;							\
 									\
 	asm volatile(KVM_ASM_SAFE_FEP(insn)				\
 		     : KVM_ASM_SAFE_OUTPUTS(vector, error_code)		\
@@ -1271,10 +1271,10 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 })
 
 #define BUILD_READ_U64_SAFE_HELPER(insn, _fep, _FEP)			\
-static inline uint8_t insn##_safe ##_fep(u32 idx, u64 *val)	\
+static inline u8 insn##_safe ##_fep(u32 idx, u64 *val)	\
 {									\
 	u64 error_code;						\
-	uint8_t vector;							\
+	u8 vector;							\
 	u32 a, d;							\
 									\
 	asm volatile(KVM_ASM_SAFE##_FEP(#insn)				\
@@ -1299,12 +1299,12 @@ BUILD_READ_U64_SAFE_HELPERS(rdmsr)
 BUILD_READ_U64_SAFE_HELPERS(rdpmc)
 BUILD_READ_U64_SAFE_HELPERS(xgetbv)
 
-static inline uint8_t wrmsr_safe(u32 msr, u64 val)
+static inline u8 wrmsr_safe(u32 msr, u64 val)
 {
 	return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
 }
 
-static inline uint8_t xsetbv_safe(u32 index, u64 value)
+static inline u8 xsetbv_safe(u32 index, u64 value)
 {
 	u32 eax = value;
 	u32 edx = value >> 32;
diff --git a/tools/testing/selftests/kvm/include/x86/sev.h b/tools/testing/selftests/kvm/include/x86/sev.h
index fa056d2e1c7e..0eead22b248a 100644
--- a/tools/testing/selftests/kvm/include/x86/sev.h
+++ b/tools/testing/selftests/kvm/include/x86/sev.h
@@ -28,12 +28,12 @@ enum sev_guest_state {
 #define GHCB_MSR_TERM_REQ	0x100
 
 void sev_vm_launch(struct kvm_vm *vm, u32 policy);
-void sev_vm_launch_measure(struct kvm_vm *vm, uint8_t *measurement);
+void sev_vm_launch_measure(struct kvm_vm *vm, u8 *measurement);
 void sev_vm_launch_finish(struct kvm_vm *vm);
 
 struct kvm_vm *vm_sev_create_with_one_vcpu(u32 type, void *guest_code,
 					   struct kvm_vcpu **cpu);
-void vm_sev_launch(struct kvm_vm *vm, u32 policy, uint8_t *measurement);
+void vm_sev_launch(struct kvm_vm *vm, u32 policy, u8 *measurement);
 
 kvm_static_assert(SEV_RET_SUCCESS == 0);
 
diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index e1772fb66811..52bd89390b33 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -294,7 +294,7 @@ struct vmx_msr_entry {
 
 static inline int vmxon(u64 phys)
 {
-	uint8_t ret;
+	u8 ret;
 
 	__asm__ __volatile__ ("vmxon %[pa]; setna %[ret]"
 		: [ret]"=rm"(ret)
@@ -311,7 +311,7 @@ static inline void vmxoff(void)
 
 static inline int vmclear(u64 vmcs_pa)
 {
-	uint8_t ret;
+	u8 ret;
 
 	__asm__ __volatile__ ("vmclear %[pa]; setna %[ret]"
 		: [ret]"=rm"(ret)
@@ -323,7 +323,7 @@ static inline int vmclear(u64 vmcs_pa)
 
 static inline int vmptrld(u64 vmcs_pa)
 {
-	uint8_t ret;
+	u8 ret;
 
 	if (enable_evmcs)
 		return -1;
@@ -339,7 +339,7 @@ static inline int vmptrld(u64 vmcs_pa)
 static inline int vmptrst(u64 *value)
 {
 	u64 tmp;
-	uint8_t ret;
+	u8 ret;
 
 	if (enable_evmcs)
 		return evmcs_vmptrst(value);
@@ -450,7 +450,7 @@ static inline void vmcall(void)
 static inline int vmread(u64 encoding, u64 *value)
 {
 	u64 tmp;
-	uint8_t ret;
+	u8 ret;
 
 	if (enable_evmcs)
 		return evmcs_vmread(encoding, value);
@@ -477,7 +477,7 @@ static inline u64 vmreadz(u64 encoding)
 
 static inline int vmwrite(u64 encoding, u64 value)
 {
-	uint8_t ret;
+	u8 ret;
 
 	if (enable_evmcs)
 		return evmcs_vmwrite(encoding, value);
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 01c8ee96b8ec..8369119421e1 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -128,7 +128,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 static void _virt_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr,
 			 u64 flags)
 {
-	uint8_t attr_idx = flags & (PTE_ATTRINDX_MASK >> PTE_ATTRINDX_SHIFT);
+	u8 attr_idx = flags & (PTE_ATTRINDX_MASK >> PTE_ATTRINDX_SHIFT);
 	u64 pg_attr;
 	u64 *ptep;
 
@@ -230,7 +230,7 @@ gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 	return pte_addr(vm, *ptep) + (gva & (vm->page_size - 1));
 }
 
-static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, u64 page, int level)
+static void pte_dump(FILE *stream, struct kvm_vm *vm, u8 indent, u64 page, int level)
 {
 #ifdef DEBUG
 	static const char * const type[] = { "", "pud", "pmd", "pte" };
@@ -249,7 +249,7 @@ static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, u64 page,
 #endif
 }
 
-void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
+void virt_arch_dump(FILE *stream, struct kvm_vm *vm, u8 indent)
 {
 	int level = 4 - (vm->pgtable_levels - 1);
 	u64 pgd, *ptep;
@@ -364,7 +364,7 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TPIDR_EL1), vcpu->id);
 }
 
-void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
+void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, u8 indent)
 {
 	u64 pstate, pc;
 
diff --git a/tools/testing/selftests/kvm/lib/guest_sprintf.c b/tools/testing/selftests/kvm/lib/guest_sprintf.c
index 0f6d5c3e060c..e5fbc39a9312 100644
--- a/tools/testing/selftests/kvm/lib/guest_sprintf.c
+++ b/tools/testing/selftests/kvm/lib/guest_sprintf.c
@@ -216,7 +216,7 @@ int guest_vsnprintf(char *buf, int n, const char *fmt, va_list args)
 				while (--field_width > 0)
 					APPEND_BUFFER_SAFE(str, end, ' ');
 			APPEND_BUFFER_SAFE(str, end,
-					    (uint8_t)va_arg(args, int));
+					    (u8)va_arg(args, int));
 			while (--field_width > 0)
 				APPEND_BUFFER_SAFE(str, end, ' ');
 			continue;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ade04f83485e..45c998b5be22 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1935,7 +1935,7 @@ void kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing)
  * Dumps the current state of the VM given by vm, to the FILE stream
  * given by stream.
  */
-void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
+void vm_dump(FILE *stream, struct kvm_vm *vm, u8 indent)
 {
 	int ctr;
 	struct userspace_mem_region *region;
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 19db0671a390..645c9630a981 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -152,7 +152,7 @@ gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 	exit(1);
 }
 
-static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent,
+static void pte_dump(FILE *stream, struct kvm_vm *vm, u8 indent,
 		     u64 page, int level)
 {
 #ifdef DEBUG
@@ -174,7 +174,7 @@ static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent,
 #endif
 }
 
-void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
+void virt_arch_dump(FILE *stream, struct kvm_vm *vm, u8 indent)
 {
 	int level = vm->pgtable_levels - 1;
 	u64 pgd, *ptep;
@@ -217,7 +217,7 @@ void riscv_vcpu_mmu_setup(struct kvm_vcpu *vcpu)
 	vcpu_set_reg(vcpu, RISCV_GENERAL_CSR_REG(satp), satp);
 }
 
-void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
+void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, u8 indent)
 {
 	struct kvm_riscv_core core;
 
diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
index 5445a54b44bb..4cc212396885 100644
--- a/tools/testing/selftests/kvm/lib/s390/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390/processor.c
@@ -111,7 +111,7 @@ gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 	return (entry[idx] & ~0xffful) + (gva & 0xffful);
 }
 
-static void virt_dump_ptes(FILE *stream, struct kvm_vm *vm, uint8_t indent,
+static void virt_dump_ptes(FILE *stream, struct kvm_vm *vm, u8 indent,
 			   u64 ptea_start)
 {
 	u64 *pte, ptea;
@@ -125,7 +125,7 @@ static void virt_dump_ptes(FILE *stream, struct kvm_vm *vm, uint8_t indent,
 	}
 }
 
-static void virt_dump_region(FILE *stream, struct kvm_vm *vm, uint8_t indent,
+static void virt_dump_region(FILE *stream, struct kvm_vm *vm, u8 indent,
 			     u64 reg_tab_addr)
 {
 	u64 addr, *entry;
@@ -147,7 +147,7 @@ static void virt_dump_region(FILE *stream, struct kvm_vm *vm, uint8_t indent,
 	}
 }
 
-void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
+void virt_arch_dump(FILE *stream, struct kvm_vm *vm, u8 indent)
 {
 	if (!vm->pgd_created)
 		return;
@@ -212,7 +212,7 @@ void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
 	va_end(ap);
 }
 
-void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
+void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, u8 indent)
 {
 	fprintf(stream, "%*spstate: psw: 0x%.16llx:0x%.16llx\n",
 		indent, "", vcpu->run->psw_mask, vcpu->run->psw_addr);
diff --git a/tools/testing/selftests/kvm/lib/sparsebit.c b/tools/testing/selftests/kvm/lib/sparsebit.c
index 2789d34436e6..7572a5033c37 100644
--- a/tools/testing/selftests/kvm/lib/sparsebit.c
+++ b/tools/testing/selftests/kvm/lib/sparsebit.c
@@ -2074,7 +2074,7 @@ int main(void)
 {
 	s = sparsebit_alloc();
 	for (;;) {
-		uint8_t op = get8() & 0xf;
+		u8 op = get8() & 0xf;
 		u64 first = get64();
 		u64 last = get64();
 
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 7258f9f8f0bf..dfbc1c7199c4 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -23,7 +23,7 @@ bool host_cpu_is_intel;
 bool is_forced_emulation_enabled;
 u64 guest_tsc_khz;
 
-static void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent)
+static void regs_dump(FILE *stream, struct kvm_regs *regs, u8 indent)
 {
 	fprintf(stream, "%*srax: 0x%.16llx rbx: 0x%.16llx "
 		"rcx: 0x%.16llx rdx: 0x%.16llx\n",
@@ -47,7 +47,7 @@ static void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent)
 }
 
 static void segment_dump(FILE *stream, struct kvm_segment *segment,
-			 uint8_t indent)
+			 u8 indent)
 {
 	fprintf(stream, "%*sbase: 0x%.16llx limit: 0x%.8x "
 		"selector: 0x%.4x type: 0x%.2x\n",
@@ -64,7 +64,7 @@ static void segment_dump(FILE *stream, struct kvm_segment *segment,
 }
 
 static void dtable_dump(FILE *stream, struct kvm_dtable *dtable,
-			uint8_t indent)
+			u8 indent)
 {
 	fprintf(stream, "%*sbase: 0x%.16llx limit: 0x%.4x "
 		"padding: 0x%.4x 0x%.4x 0x%.4x\n",
@@ -72,7 +72,7 @@ static void dtable_dump(FILE *stream, struct kvm_dtable *dtable,
 		dtable->padding[0], dtable->padding[1], dtable->padding[2]);
 }
 
-static void sregs_dump(FILE *stream, struct kvm_sregs *sregs, uint8_t indent)
+static void sregs_dump(FILE *stream, struct kvm_sregs *sregs, u8 indent)
 {
 	unsigned int i;
 
@@ -318,7 +318,7 @@ u64 *vm_get_page_table_entry(struct kvm_vm *vm, u64 vaddr)
 	return __vm_get_page_table_entry(vm, vaddr, &level);
 }
 
-void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
+void virt_arch_dump(FILE *stream, struct kvm_vm *vm, u8 indent)
 {
 	u64 *pml4e, *pml4e_start;
 	u64 *pdpe, *pdpe_start;
@@ -747,7 +747,7 @@ const struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 
 static u32 __kvm_cpu_has(const struct kvm_cpuid2 *cpuid,
 			 u32 function, u32 index,
-			 uint8_t reg, uint8_t lo, uint8_t hi)
+			 u8 reg, u8 lo, u8 hi)
 {
 	const struct kvm_cpuid_entry2 *entry;
 	int i;
@@ -965,7 +965,7 @@ void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
 	va_end(ap);
 }
 
-void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
+void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, u8 indent)
 {
 	struct kvm_regs regs;
 	struct kvm_sregs sregs;
@@ -1215,7 +1215,7 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 {
 	const unsigned long num_ht_pages = 12 << (30 - vm->page_shift); /* 12 GiB */
 	unsigned long ht_gfn, max_gfn, max_pfn;
-	uint8_t maxphyaddr, guest_maxphyaddr;
+	u8 maxphyaddr, guest_maxphyaddr;
 
 	/*
 	 * Use "guest MAXPHYADDR" from KVM if it's available.  Guest MAXPHYADDR
diff --git a/tools/testing/selftests/kvm/lib/x86/sev.c b/tools/testing/selftests/kvm/lib/x86/sev.c
index dba0aa744561..572245abcdd8 100644
--- a/tools/testing/selftests/kvm/lib/x86/sev.c
+++ b/tools/testing/selftests/kvm/lib/x86/sev.c
@@ -84,7 +84,7 @@ void sev_vm_launch(struct kvm_vm *vm, u32 policy)
 	vm->arch.is_pt_protected = true;
 }
 
-void sev_vm_launch_measure(struct kvm_vm *vm, uint8_t *measurement)
+void sev_vm_launch_measure(struct kvm_vm *vm, u8 *measurement)
 {
 	struct kvm_sev_launch_measure launch_measure;
 	struct kvm_sev_guest_status guest_status;
@@ -128,7 +128,7 @@ struct kvm_vm *vm_sev_create_with_one_vcpu(u32 type, void *guest_code,
 	return vm;
 }
 
-void vm_sev_launch(struct kvm_vm *vm, u32 policy, uint8_t *measurement)
+void vm_sev_launch(struct kvm_vm *vm, u32 policy, u8 *measurement)
 {
 	sev_vm_launch(vm, policy);
 
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 29b2bb605ee6..0d369dbde88f 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -216,7 +216,7 @@ static void *vm_gpa2hva(struct vm_data *data, u64 gpa, u64 *rempages)
 	}
 
 	base = data->hva_slots[slot];
-	return (uint8_t *)base + slotoffs * guest_page_size + pgoffs;
+	return (u8 *)base + slotoffs * guest_page_size + pgoffs;
 }
 
 static u64 vm_slot2gpa(struct vm_data *data, u32 slot)
diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 4c3b96dcab21..af8e97d36764 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -346,7 +346,7 @@ int main(int argc, char *argv[])
 
 	/* Pre-fault the memory to avoid taking mmap_sem on guest page faults. */
 	for (i = 0; i < slot_size; i += vm->page_size)
-		((uint8_t *)mem)[i] = 0xaa;
+		((u8 *)mem)[i] = 0xaa;
 
 	gpa = 0;
 	for (slot = first_slot; slot < max_slots; slot++) {
diff --git a/tools/testing/selftests/kvm/s390/memop.c b/tools/testing/selftests/kvm/s390/memop.c
index 2283ad346746..4f63ff79ee46 100644
--- a/tools/testing/selftests/kvm/s390/memop.c
+++ b/tools/testing/selftests/kvm/s390/memop.c
@@ -48,13 +48,13 @@ struct mop_desc {
 	void *buf;
 	u32 sida_offset;
 	void *old;
-	uint8_t old_value[16];
+	u8 old_value[16];
 	bool *cmpxchg_success;
-	uint8_t ar;
-	uint8_t key;
+	u8 ar;
+	u8 key;
 };
 
-const uint8_t NO_KEY = 0xff;
+const u8 NO_KEY = 0xff;
 
 static struct kvm_s390_mem_op ksmo_from_desc(struct mop_desc *desc)
 {
@@ -230,8 +230,8 @@ static void memop_ioctl(struct test_info info, struct kvm_s390_mem_op *ksmo,
 #define CR0_FETCH_PROTECTION_OVERRIDE	(1UL << (63 - 38))
 #define CR0_STORAGE_PROTECTION_OVERRIDE	(1UL << (63 - 39))
 
-static uint8_t __aligned(PAGE_SIZE) mem1[65536];
-static uint8_t __aligned(PAGE_SIZE) mem2[65536];
+static u8 __aligned(PAGE_SIZE) mem1[65536];
+static u8 __aligned(PAGE_SIZE) mem2[65536];
 
 struct test_default {
 	struct kvm_vm *kvm_vm;
@@ -296,7 +296,7 @@ static void prepare_mem12(void)
 	TEST_ASSERT(!memcmp(p1, p2, size), "Memory contents do not match!")
 
 static void default_write_read(struct test_info copy_cpu, struct test_info mop_cpu,
-			       enum mop_target mop_target, u32 size, uint8_t key)
+			       enum mop_target mop_target, u32 size, u8 key)
 {
 	prepare_mem12();
 	CHECK_N_DO(MOP, mop_cpu, mop_target, WRITE, mem1, size,
@@ -308,7 +308,7 @@ static void default_write_read(struct test_info copy_cpu, struct test_info mop_c
 }
 
 static void default_read(struct test_info copy_cpu, struct test_info mop_cpu,
-			 enum mop_target mop_target, u32 size, uint8_t key)
+			 enum mop_target mop_target, u32 size, u8 key)
 {
 	prepare_mem12();
 	CHECK_N_DO(MOP, mop_cpu, mop_target, WRITE, mem1, size, GADDR_V(mem1));
@@ -318,12 +318,12 @@ static void default_read(struct test_info copy_cpu, struct test_info mop_cpu,
 	ASSERT_MEM_EQ(mem1, mem2, size);
 }
 
-static void default_cmpxchg(struct test_default *test, uint8_t key)
+static void default_cmpxchg(struct test_default *test, u8 key)
 {
 	for (int size = 1; size <= 16; size *= 2) {
 		for (int offset = 0; offset < 16; offset += size) {
-			uint8_t __aligned(16) new[16] = {};
-			uint8_t __aligned(16) old[16];
+			u8 __aligned(16) new[16] = {};
+			u8 __aligned(16) old[16];
 			bool succ;
 
 			prepare_mem12();
@@ -400,7 +400,7 @@ static void test_copy_access_register(void)
 	kvm_vm_free(t.kvm_vm);
 }
 
-static void set_storage_key_range(void *addr, size_t len, uint8_t key)
+static void set_storage_key_range(void *addr, size_t len, u8 key)
 {
 	uintptr_t _addr, abs, i;
 	int not_mapped = 0;
@@ -483,7 +483,7 @@ static __uint128_t cut_to_size(int size, __uint128_t val)
 {
 	switch (size) {
 	case 1:
-		return (uint8_t)val;
+		return (u8)val;
 	case 2:
 		return (u16)val;
 	case 4:
@@ -553,7 +553,7 @@ static __uint128_t permutate_bits(bool guest, int i, int size, __uint128_t old)
 	if (swap) {
 		int i, j;
 		__uint128_t new;
-		uint8_t byte0, byte1;
+		u8 byte0, byte1;
 
 		rand = rand * 3 + 1;
 		i = rand % size;
diff --git a/tools/testing/selftests/kvm/s390/resets.c b/tools/testing/selftests/kvm/s390/resets.c
index 7a81d07500bd..e3c7a2f148f9 100644
--- a/tools/testing/selftests/kvm/s390/resets.c
+++ b/tools/testing/selftests/kvm/s390/resets.c
@@ -20,7 +20,7 @@
 
 struct kvm_s390_irq buf[ARBITRARY_NON_ZERO_VCPU_ID + LOCAL_IRQS];
 
-static uint8_t regs_null[512];
+static u8 regs_null[512];
 
 static void guest_code_initial(void)
 {
diff --git a/tools/testing/selftests/kvm/s390/shared_zeropage_test.c b/tools/testing/selftests/kvm/s390/shared_zeropage_test.c
index bba0d9a6dcc8..a9e5a01200b8 100644
--- a/tools/testing/selftests/kvm/s390/shared_zeropage_test.c
+++ b/tools/testing/selftests/kvm/s390/shared_zeropage_test.c
@@ -13,7 +13,7 @@
 #include "kselftest.h"
 #include "ucall_common.h"
 
-static void set_storage_key(void *addr, uint8_t skey)
+static void set_storage_key(void *addr, u8 skey)
 {
 	asm volatile("sske %0,%1" : : "d" (skey), "a" (addr));
 }
diff --git a/tools/testing/selftests/kvm/s390/tprot.c b/tools/testing/selftests/kvm/s390/tprot.c
index ffd5d139082a..4c5d524915d1 100644
--- a/tools/testing/selftests/kvm/s390/tprot.c
+++ b/tools/testing/selftests/kvm/s390/tprot.c
@@ -14,12 +14,12 @@
 #define CR0_FETCH_PROTECTION_OVERRIDE	(1UL << (63 - 38))
 #define CR0_STORAGE_PROTECTION_OVERRIDE	(1UL << (63 - 39))
 
-static __aligned(PAGE_SIZE) uint8_t pages[2][PAGE_SIZE];
-static uint8_t *const page_store_prot = pages[0];
-static uint8_t *const page_fetch_prot = pages[1];
+static __aligned(PAGE_SIZE) u8 pages[2][PAGE_SIZE];
+static u8 *const page_store_prot = pages[0];
+static u8 *const page_fetch_prot = pages[1];
 
 /* Nonzero return value indicates that address not mapped */
-static int set_storage_key(void *addr, uint8_t key)
+static int set_storage_key(void *addr, u8 key)
 {
 	int not_mapped = 0;
 
@@ -44,7 +44,7 @@ enum permission {
 	TRANSL_UNAVAIL = 3,
 };
 
-static enum permission test_protection(void *addr, uint8_t key)
+static enum permission test_protection(void *addr, u8 key)
 {
 	u64 mask;
 
@@ -72,7 +72,7 @@ enum stage {
 struct test {
 	enum stage stage;
 	void *addr;
-	uint8_t key;
+	u8 key;
 	enum permission expected;
 } tests[] = {
 	/*
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 730f94cb1e86..58855e5e0b29 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -564,7 +564,7 @@ static void guest_code_mmio_during_vectoring(void)
 	set_idt(&idt_desc);
 
 	/* Generate a #GP by dereferencing a non-canonical address */
-	*((uint8_t *)NONCANONICAL) = 0x1;
+	*((u8 *)NONCANONICAL) = 0x1;
 
 	GUEST_ASSERT(0);
 }
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 369d6290dcdc..5bd587098c90 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -216,8 +216,8 @@ struct sta_struct {
 	u32 sequence;
 	u32 flags;
 	u64 steal;
-	uint8_t preempted;
-	uint8_t pad[47];
+	u8 preempted;
+	u8 pad[47];
 } __packed;
 
 static void sta_set_shmem(gpa_t gpa, unsigned long flags)
diff --git a/tools/testing/selftests/kvm/x86/fix_hypercall_test.c b/tools/testing/selftests/kvm/x86/fix_hypercall_test.c
index a2c8202cb80e..5ab8bd042397 100644
--- a/tools/testing/selftests/kvm/x86/fix_hypercall_test.c
+++ b/tools/testing/selftests/kvm/x86/fix_hypercall_test.c
@@ -26,11 +26,11 @@ static void guest_ud_handler(struct ex_regs *regs)
 	regs->rip += HYPERCALL_INSN_SIZE;
 }
 
-static const uint8_t vmx_vmcall[HYPERCALL_INSN_SIZE]  = { 0x0f, 0x01, 0xc1 };
-static const uint8_t svm_vmmcall[HYPERCALL_INSN_SIZE] = { 0x0f, 0x01, 0xd9 };
+static const u8 vmx_vmcall[HYPERCALL_INSN_SIZE]  = { 0x0f, 0x01, 0xc1 };
+static const u8 svm_vmmcall[HYPERCALL_INSN_SIZE] = { 0x0f, 0x01, 0xd9 };
 
-extern uint8_t hypercall_insn[HYPERCALL_INSN_SIZE];
-static u64 do_sched_yield(uint8_t apic_id)
+extern u8 hypercall_insn[HYPERCALL_INSN_SIZE];
+static u64 do_sched_yield(u8 apic_id)
 {
 	u64 ret;
 
@@ -45,8 +45,8 @@ static u64 do_sched_yield(uint8_t apic_id)
 
 static void guest_main(void)
 {
-	const uint8_t *native_hypercall_insn;
-	const uint8_t *other_hypercall_insn;
+	const u8 *native_hypercall_insn;
+	const u8 *other_hypercall_insn;
 	u64 ret;
 
 	if (host_cpu_is_intel) {
diff --git a/tools/testing/selftests/kvm/x86/flds_emulation.h b/tools/testing/selftests/kvm/x86/flds_emulation.h
index c7e4f08765fb..fd6b6c67199a 100644
--- a/tools/testing/selftests/kvm/x86/flds_emulation.h
+++ b/tools/testing/selftests/kvm/x86/flds_emulation.h
@@ -21,7 +21,7 @@ static inline void handle_flds_emulation_failure_exit(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
 	struct kvm_regs regs;
-	uint8_t *insn_bytes;
+	u8 *insn_bytes;
 	u64 flags;
 
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_INTERNAL_ERROR);
diff --git a/tools/testing/selftests/kvm/x86/hyperv_features.c b/tools/testing/selftests/kvm/x86/hyperv_features.c
index 31e568150c98..47759619a879 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_features.c
@@ -41,7 +41,7 @@ static bool is_write_only_msr(u32 msr)
 
 static void guest_msr(struct msr_data *msr)
 {
-	uint8_t vector = 0;
+	u8 vector = 0;
 	u64 msr_val = 0;
 
 	GUEST_ASSERT(msr->idx);
@@ -85,7 +85,7 @@ static void guest_msr(struct msr_data *msr)
 static void guest_hcall(gpa_t pgs_gpa, struct hcall_data *hcall)
 {
 	u64 res, input, output;
-	uint8_t vector;
+	u8 vector;
 
 	GUEST_ASSERT_NE(hcall->control, 0);
 
diff --git a/tools/testing/selftests/kvm/x86/kvm_pv_test.c b/tools/testing/selftests/kvm/x86/kvm_pv_test.c
index babf0f95165a..8ed5fa635021 100644
--- a/tools/testing/selftests/kvm/x86/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86/kvm_pv_test.c
@@ -41,7 +41,7 @@ static struct msr_data msrs_to_test[] = {
 static void test_msr(struct msr_data *msr)
 {
 	u64 ignored;
-	uint8_t vector;
+	u8 vector;
 
 	PR_MSR(msr);
 
diff --git a/tools/testing/selftests/kvm/x86/nested_emulation_test.c b/tools/testing/selftests/kvm/x86/nested_emulation_test.c
index 42fd24567e26..fb7dcbe53ac7 100644
--- a/tools/testing/selftests/kvm/x86/nested_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_emulation_test.c
@@ -13,7 +13,7 @@ enum {
 
 struct emulated_instruction {
 	const char name[32];
-	uint8_t opcode[15];
+	u8 opcode[15];
 	u32 exit_reason[NR_VIRTUALIZATION_FLAVORS];
 };
 
@@ -32,9 +32,9 @@ static struct emulated_instruction instructions[] = {
 	},
 };
 
-static uint8_t kvm_fep[] = { 0x0f, 0x0b, 0x6b, 0x76, 0x6d };	/* ud2 ; .ascii "kvm" */
-static uint8_t l2_guest_code[sizeof(kvm_fep) + 15];
-static uint8_t *l2_instruction = &l2_guest_code[sizeof(kvm_fep)];
+static u8 kvm_fep[] = { 0x0f, 0x0b, 0x6b, 0x76, 0x6d };	/* ud2 ; .ascii "kvm" */
+static u8 l2_guest_code[sizeof(kvm_fep) + 15];
+static u8 *l2_instruction = &l2_guest_code[sizeof(kvm_fep)];
 
 static u32 get_instruction_length(struct emulated_instruction *insn)
 {
diff --git a/tools/testing/selftests/kvm/x86/platform_info_test.c b/tools/testing/selftests/kvm/x86/platform_info_test.c
index 86d1ab0db1e8..80bb07e6531c 100644
--- a/tools/testing/selftests/kvm/x86/platform_info_test.c
+++ b/tools/testing/selftests/kvm/x86/platform_info_test.c
@@ -24,7 +24,7 @@
 static void guest_code(void)
 {
 	u64 msr_platform_info;
-	uint8_t vector;
+	u8 vector;
 
 	GUEST_SYNC(true);
 	msr_platform_info = rdmsr(MSR_PLATFORM_INFO);
diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index 16a2093b14eb..f7b1c15be748 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -32,7 +32,7 @@
 /* Track which architectural events are supported by hardware. */
 static u32 hardware_pmu_arch_events;
 
-static uint8_t kvm_pmu_version;
+static u8 kvm_pmu_version;
 static bool kvm_has_perf_caps;
 
 #define X86_PMU_FEATURE_NULL						\
@@ -57,7 +57,7 @@ struct kvm_intel_pmu_event {
  * kvm_x86_pmu_feature use syntax that's only valid in function scope, and the
  * compiler often thinks the feature definitions aren't compile-time constants.
  */
-static struct kvm_intel_pmu_event intel_event_to_feature(uint8_t idx)
+static struct kvm_intel_pmu_event intel_event_to_feature(u8 idx)
 {
 	const struct kvm_intel_pmu_event __intel_event_to_feature[] = {
 		[INTEL_ARCH_CPU_CYCLES_INDEX]		 = { X86_PMU_FEATURE_CPU_CYCLES, X86_PMU_FEATURE_CPU_CYCLES_FIXED },
@@ -84,7 +84,7 @@ static struct kvm_intel_pmu_event intel_event_to_feature(uint8_t idx)
 
 static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 						  void *guest_code,
-						  uint8_t pmu_version,
+						  u8 pmu_version,
 						  u64 perf_capabilities)
 {
 	struct kvm_vm *vm;
@@ -127,7 +127,7 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
 	} while (uc.cmd != UCALL_DONE);
 }
 
-static uint8_t guest_get_pmu_version(void)
+static u8 guest_get_pmu_version(void)
 {
 	/*
 	 * Return the effective PMU version, i.e. the minimum between what KVM
@@ -136,7 +136,7 @@ static uint8_t guest_get_pmu_version(void)
 	 * supported by KVM to verify KVM doesn't freak out and do something
 	 * bizarre with an architecturally valid, but unsupported, version.
 	 */
-	return min_t(uint8_t, kvm_pmu_version, this_cpu_property(X86_PROPERTY_PMU_VERSION));
+	return min_t(u8, kvm_pmu_version, this_cpu_property(X86_PROPERTY_PMU_VERSION));
 }
 
 /*
@@ -148,7 +148,7 @@ static uint8_t guest_get_pmu_version(void)
  * Sanity check that in all cases, the event doesn't count when it's disabled,
  * and that KVM correctly emulates the write of an arbitrary value.
  */
-static void guest_assert_event_count(uint8_t idx, u32 pmc, u32 pmc_msr)
+static void guest_assert_event_count(u8 idx, u32 pmc, u32 pmc_msr)
 {
 	u64 count;
 
@@ -237,7 +237,7 @@ do {										\
 	guest_assert_event_count(_idx, _pmc, _pmc_msr);				\
 } while (0)
 
-static void __guest_test_arch_event(uint8_t idx, u32 pmc, u32 pmc_msr,
+static void __guest_test_arch_event(u8 idx, u32 pmc, u32 pmc_msr,
 				    u32 ctrl_msr, u64 ctrl_msr_value)
 {
 	GUEST_TEST_EVENT(idx, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, "");
@@ -246,7 +246,7 @@ static void __guest_test_arch_event(uint8_t idx, u32 pmc, u32 pmc_msr,
 		GUEST_TEST_EVENT(idx, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, KVM_FEP);
 }
 
-static void guest_test_arch_event(uint8_t idx)
+static void guest_test_arch_event(u8 idx)
 {
 	u32 nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
 	u32 pmu_version = guest_get_pmu_version();
@@ -302,7 +302,7 @@ static void guest_test_arch_event(uint8_t idx)
 
 static void guest_test_arch_events(void)
 {
-	uint8_t i;
+	u8 i;
 
 	for (i = 0; i < NR_INTEL_ARCH_EVENTS; i++)
 		guest_test_arch_event(i);
@@ -310,8 +310,8 @@ static void guest_test_arch_events(void)
 	GUEST_DONE();
 }
 
-static void test_arch_events(uint8_t pmu_version, u64 perf_capabilities,
-			     uint8_t length, uint8_t unavailable_mask)
+static void test_arch_events(u8 pmu_version, u64 perf_capabilities,
+			     u8 length, u8 unavailable_mask)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -355,7 +355,7 @@ __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
 static void guest_test_rdpmc(u32 rdpmc_idx, bool expect_success,
 			     u64 expected_val)
 {
-	uint8_t vector;
+	u8 vector;
 	u64 val;
 
 	vector = rdpmc_safe(rdpmc_idx, &val);
@@ -372,11 +372,11 @@ static void guest_test_rdpmc(u32 rdpmc_idx, bool expect_success,
 		GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
 }
 
-static void guest_rd_wr_counters(u32 base_msr, uint8_t nr_possible_counters,
-				 uint8_t nr_counters, u32 or_mask)
+static void guest_rd_wr_counters(u32 base_msr, u8 nr_possible_counters,
+				 u8 nr_counters, u32 or_mask)
 {
 	const bool pmu_has_fast_mode = !guest_get_pmu_version();
-	uint8_t i;
+	u8 i;
 
 	for (i = 0; i < nr_possible_counters; i++) {
 		/*
@@ -401,7 +401,7 @@ static void guest_rd_wr_counters(u32 base_msr, uint8_t nr_possible_counters,
 		const bool expect_gp = !expect_success && msr != MSR_P6_PERFCTR0 &&
 				       msr != MSR_P6_PERFCTR1;
 		u32 rdpmc_idx;
-		uint8_t vector;
+		u8 vector;
 		u64 val;
 
 		vector = wrmsr_safe(msr, test_val);
@@ -440,8 +440,8 @@ static void guest_rd_wr_counters(u32 base_msr, uint8_t nr_possible_counters,
 
 static void guest_test_gp_counters(void)
 {
-	uint8_t pmu_version = guest_get_pmu_version();
-	uint8_t nr_gp_counters = 0;
+	u8 pmu_version = guest_get_pmu_version();
+	u8 nr_gp_counters = 0;
 	u32 base_msr;
 
 	if (pmu_version)
@@ -474,8 +474,8 @@ static void guest_test_gp_counters(void)
 	GUEST_DONE();
 }
 
-static void test_gp_counters(uint8_t pmu_version, u64 perf_capabilities,
-			     uint8_t nr_gp_counters)
+static void test_gp_counters(u8 pmu_version, u64 perf_capabilities,
+			     u8 nr_gp_counters)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -494,8 +494,8 @@ static void test_gp_counters(uint8_t pmu_version, u64 perf_capabilities,
 static void guest_test_fixed_counters(void)
 {
 	u64 supported_bitmask = 0;
-	uint8_t nr_fixed_counters = 0;
-	uint8_t i;
+	u8 nr_fixed_counters = 0;
+	u8 i;
 
 	/* Fixed counters require Architectural vPMU Version 2+. */
 	if (guest_get_pmu_version() >= 2)
@@ -512,7 +512,7 @@ static void guest_test_fixed_counters(void)
 			     nr_fixed_counters, supported_bitmask);
 
 	for (i = 0; i < MAX_NR_FIXED_COUNTERS; i++) {
-		uint8_t vector;
+		u8 vector;
 		u64 val;
 
 		if (i >= nr_fixed_counters && !(supported_bitmask & BIT_ULL(i))) {
@@ -540,8 +540,8 @@ static void guest_test_fixed_counters(void)
 	GUEST_DONE();
 }
 
-static void test_fixed_counters(uint8_t pmu_version, u64 perf_capabilities,
-				uint8_t nr_fixed_counters,
+static void test_fixed_counters(u8 pmu_version, u64 perf_capabilities,
+				u8 nr_fixed_counters,
 				u32 supported_bitmask)
 {
 	struct kvm_vcpu *vcpu;
@@ -562,11 +562,11 @@ static void test_fixed_counters(uint8_t pmu_version, u64 perf_capabilities,
 
 static void test_intel_counters(void)
 {
-	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
-	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
-	uint8_t pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
+	u8 nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+	u8 nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
+	u8 pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
 	unsigned int i;
-	uint8_t v, j;
+	u8 v, j;
 	u32 k;
 
 	const u64 perf_caps[] = {
@@ -579,7 +579,7 @@ static void test_intel_counters(void)
 	 * Intel, i.e. is the last version that is guaranteed to be backwards
 	 * compatible with KVM's existing behavior.
 	 */
-	uint8_t max_pmu_version = max_t(typeof(pmu_version), pmu_version, 5);
+	u8 max_pmu_version = max_t(typeof(pmu_version), pmu_version, 5);
 
 	/*
 	 * Detect the existence of events that aren't supported by selftests.
diff --git a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
index d140fd6b951e..df8d3f2c05f8 100644
--- a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
@@ -682,7 +682,7 @@ static int set_pmu_single_event_filter(struct kvm_vcpu *vcpu, u64 event,
 
 static void test_filter_ioctl(struct kvm_vcpu *vcpu)
 {
-	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+	u8 nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
 	struct __kvm_pmu_event_filter f;
 	u64 e = ~0ul;
 	int r;
@@ -726,7 +726,7 @@ static void test_filter_ioctl(struct kvm_vcpu *vcpu)
 	TEST_ASSERT(!r, "Masking non-existent fixed counters should be allowed");
 }
 
-static void intel_run_fixed_counter_guest_code(uint8_t idx)
+static void intel_run_fixed_counter_guest_code(u8 idx)
 {
 	for (;;) {
 		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
@@ -767,8 +767,8 @@ static u64 test_set_gp_and_fixed_event_filter(struct kvm_vcpu *vcpu,
 	return run_vcpu_to_sync(vcpu);
 }
 
-static void __test_fixed_counter_bitmap(struct kvm_vcpu *vcpu, uint8_t idx,
-					uint8_t nr_fixed_counters)
+static void __test_fixed_counter_bitmap(struct kvm_vcpu *vcpu, u8 idx,
+					u8 nr_fixed_counters)
 {
 	unsigned int i;
 	u32 bitmap;
@@ -812,10 +812,10 @@ static void __test_fixed_counter_bitmap(struct kvm_vcpu *vcpu, uint8_t idx,
 
 static void test_fixed_counter_bitmap(void)
 {
-	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+	u8 nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
-	uint8_t idx;
+	u8 idx;
 
 	/*
 	 * Check that pmu_event_filter works as expected when it's applied to
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 73f540894f06..c412c6ae8356 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -29,7 +29,7 @@
 /* Horrific macro so that the line info is captured accurately :-( */
 #define memcmp_g(gpa, pattern,  size)								\
 do {												\
-	uint8_t *mem = (uint8_t *)gpa;								\
+	u8 *mem = (u8 *)gpa;								\
 	size_t i;										\
 												\
 	for (i = 0; i < size; i++)								\
@@ -38,7 +38,7 @@ do {												\
 			       pattern, i, gpa + i, mem[i]);					\
 } while (0)
 
-static void memcmp_h(uint8_t *mem, u64 gpa, uint8_t pattern, size_t size)
+static void memcmp_h(u8 *mem, u64 gpa, u8 pattern, size_t size)
 {
 	size_t i;
 
@@ -71,12 +71,12 @@ enum ucall_syncs {
 };
 
 static void guest_sync_shared(u64 gpa, u64 size,
-			      uint8_t current_pattern, uint8_t new_pattern)
+			      u8 current_pattern, u8 new_pattern)
 {
 	GUEST_SYNC5(SYNC_SHARED, gpa, size, current_pattern, new_pattern);
 }
 
-static void guest_sync_private(u64 gpa, u64 size, uint8_t pattern)
+static void guest_sync_private(u64 gpa, u64 size, u8 pattern)
 {
 	GUEST_SYNC4(SYNC_PRIVATE, gpa, size, pattern);
 }
@@ -121,8 +121,8 @@ struct {
 
 static void guest_test_explicit_conversion(u64 base_gpa, bool do_fallocate)
 {
-	const uint8_t def_p = 0xaa;
-	const uint8_t init_p = 0xcc;
+	const u8 def_p = 0xaa;
+	const u8 init_p = 0xcc;
 	u64 j;
 	int i;
 
@@ -136,10 +136,10 @@ static void guest_test_explicit_conversion(u64 base_gpa, bool do_fallocate)
 	for (i = 0; i < ARRAY_SIZE(test_ranges); i++) {
 		u64 gpa = base_gpa + test_ranges[i].offset;
 		u64 size = test_ranges[i].size;
-		uint8_t p1 = 0x11;
-		uint8_t p2 = 0x22;
-		uint8_t p3 = 0x33;
-		uint8_t p4 = 0x44;
+		u8 p1 = 0x11;
+		u8 p2 = 0x22;
+		u8 p3 = 0x33;
+		u8 p4 = 0x44;
 
 		/*
 		 * Set the test region to pattern one to differentiate it from
@@ -229,7 +229,7 @@ static void guest_punch_hole(u64 gpa, u64 size)
  */
 static void guest_test_punch_hole(u64 base_gpa, bool precise)
 {
-	const uint8_t init_p = 0xcc;
+	const u8 init_p = 0xcc;
 	int i;
 
 	/*
@@ -347,7 +347,7 @@ static void *__test_mem_conversions(void *__vcpu)
 
 			for (i = 0; i < size; i += vm->page_size) {
 				size_t nr_bytes = min_t(size_t, vm->page_size, size - i);
-				uint8_t *hva = addr_gpa2hva(vm, gpa + i);
+				u8 *hva = addr_gpa2hva(vm, gpa + i);
 
 				/* In all cases, the host should observe the shared data. */
 				memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
diff --git a/tools/testing/selftests/kvm/x86/smm_test.c b/tools/testing/selftests/kvm/x86/smm_test.c
index 32f2cdea4c4f..dd9d7944145e 100644
--- a/tools/testing/selftests/kvm/x86/smm_test.c
+++ b/tools/testing/selftests/kvm/x86/smm_test.c
@@ -36,7 +36,7 @@
  * independent subset of asm here.
  * SMI handler always report back fixed stage SMRAM_STAGE.
  */
-uint8_t smi_handler[] = {
+u8 smi_handler[] = {
 	0xb0, SMRAM_STAGE,    /* mov $SMRAM_STAGE, %al */
 	0xe4, SYNC_PORT,      /* in $SYNC_PORT, %al */
 	0x0f, 0xaa,           /* rsm */
diff --git a/tools/testing/selftests/kvm/x86/state_test.c b/tools/testing/selftests/kvm/x86/state_test.c
index 151eead91baf..b4b3678c719a 100644
--- a/tools/testing/selftests/kvm/x86/state_test.c
+++ b/tools/testing/selftests/kvm/x86/state_test.c
@@ -141,7 +141,7 @@ static void __attribute__((__flatten__)) guest_code(void *arg)
 
 	if (this_cpu_has(X86_FEATURE_XSAVE)) {
 		u64 supported_xcr0 = this_cpu_supported_xcr0();
-		uint8_t buffer[4096];
+		u8 buffer[4096];
 
 		memset(buffer, 0xcc, sizeof(buffer));
 
@@ -296,7 +296,7 @@ int main(int argc, char *argv[])
 		 * supported features, even if something goes awry in saving
 		 * the original snapshot.
 		 */
-		xstate_bv = (void *)&((uint8_t *)state->xsave->region)[512];
+		xstate_bv = (void *)&((u8 *)state->xsave->region)[512];
 		saved_xstate_bv = *xstate_bv;
 
 		vcpuN = __vm_vcpu_add(vm, vcpu->id + 1);
diff --git a/tools/testing/selftests/kvm/x86/userspace_io_test.c b/tools/testing/selftests/kvm/x86/userspace_io_test.c
index 9481cbcf284f..e0272ba73502 100644
--- a/tools/testing/selftests/kvm/x86/userspace_io_test.c
+++ b/tools/testing/selftests/kvm/x86/userspace_io_test.c
@@ -10,7 +10,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-static void guest_ins_port80(uint8_t *buffer, unsigned int count)
+static void guest_ins_port80(u8 *buffer, unsigned int count)
 {
 	unsigned long end;
 
@@ -26,7 +26,7 @@ static void guest_ins_port80(uint8_t *buffer, unsigned int count)
 
 static void guest_code(void)
 {
-	uint8_t buffer[8192];
+	u8 buffer[8192];
 	int i;
 
 	/*
diff --git a/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
index e87e2e8d9c38..920f775fe5eb 100644
--- a/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
@@ -23,21 +23,21 @@ struct kvm_msr_filter filter_allow = {
 			.nmsrs = 1,
 			/* Test an MSR the kernel knows about. */
 			.base = MSR_IA32_XSS,
-			.bitmap = (uint8_t*)&deny_bits,
+			.bitmap = (u8 *)&deny_bits,
 		}, {
 			.flags = KVM_MSR_FILTER_READ |
 				 KVM_MSR_FILTER_WRITE,
 			.nmsrs = 1,
 			/* Test an MSR the kernel doesn't know about. */
 			.base = MSR_IA32_FLUSH_CMD,
-			.bitmap = (uint8_t*)&deny_bits,
+			.bitmap = (u8 *)&deny_bits,
 		}, {
 			.flags = KVM_MSR_FILTER_READ |
 				 KVM_MSR_FILTER_WRITE,
 			.nmsrs = 1,
 			/* Test a fabricated MSR that no one knows about. */
 			.base = MSR_NON_EXISTENT,
-			.bitmap = (uint8_t*)&deny_bits,
+			.bitmap = (u8 *)&deny_bits,
 		},
 	},
 };
@@ -49,7 +49,7 @@ struct kvm_msr_filter filter_fs = {
 			.flags = KVM_MSR_FILTER_READ,
 			.nmsrs = 1,
 			.base = MSR_FS_BASE,
-			.bitmap = (uint8_t*)&deny_bits,
+			.bitmap = (u8 *)&deny_bits,
 		},
 	},
 };
@@ -61,7 +61,7 @@ struct kvm_msr_filter filter_gs = {
 			.flags = KVM_MSR_FILTER_READ,
 			.nmsrs = 1,
 			.base = MSR_GS_BASE,
-			.bitmap = (uint8_t*)&deny_bits,
+			.bitmap = (u8 *)&deny_bits,
 		},
 	},
 };
@@ -77,7 +77,7 @@ static u8 bitmap_c0000000[KVM_MSR_FILTER_MAX_BITMAP_SIZE];
 static u8 bitmap_c0000000_read[KVM_MSR_FILTER_MAX_BITMAP_SIZE];
 static u8 bitmap_deadbeef[1] = { 0x1 };
 
-static void deny_msr(uint8_t *bitmap, u32 msr)
+static void deny_msr(u8 *bitmap, u32 msr)
 {
 	u32 idx = msr & (KVM_MSR_FILTER_MAX_BITMAP_SIZE - 1);
 
@@ -724,7 +724,7 @@ static void run_msr_filter_flag_test(struct kvm_vm *vm)
 				.flags = KVM_MSR_FILTER_READ,
 				.nmsrs = 1,
 				.base = 0,
-				.bitmap = (uint8_t *)&deny_bits,
+				.bitmap = (u8 *)&deny_bits,
 			},
 		},
 	};
diff --git a/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
index 0563bd20621b..d5f1eee6fa2e 100644
--- a/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
@@ -53,7 +53,7 @@ static const union perf_capabilities format_caps = {
 
 static void guest_test_perf_capabilities_gp(u64 val)
 {
-	uint8_t vector = wrmsr_safe(MSR_IA32_PERF_CAPABILITIES, val);
+	u8 vector = wrmsr_safe(MSR_IA32_PERF_CAPABILITIES, val);
 
 	__GUEST_ASSERT(vector == GP_VECTOR,
 		       "Expected #GP for value '0x%lx', got vector '0x%x'",
diff --git a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
index 974a6c5d3080..11ff5ee0782e 100644
--- a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
@@ -133,8 +133,8 @@ struct arch_vcpu_info {
 };
 
 struct vcpu_info {
-	uint8_t evtchn_upcall_pending;
-	uint8_t evtchn_upcall_mask;
+	u8 evtchn_upcall_pending;
+	u8 evtchn_upcall_mask;
 	unsigned long evtchn_pending_sel;
 	struct arch_vcpu_info arch;
 	struct pvclock_vcpu_time_info time;
-- 
2.49.0.906.g1f30a19c02-goog


