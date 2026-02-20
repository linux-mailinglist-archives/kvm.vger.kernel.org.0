Return-Path: <kvm+bounces-71382-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6P8LDPqul2nO5QIAu9opvQ
	(envelope-from <kvm+bounces-71382-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 01:46:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B017163F9D
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 01:46:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9A123308EBC8
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 00:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75CDD2C3266;
	Fri, 20 Feb 2026 00:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z+Ix0bdS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A649257ACF
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 00:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771548185; cv=none; b=tdbGNYTuuk2ZvRx+X3MLAzzlTTrWaMHwbgKTzPE99ZnKb0SEhPba2U9CndlpIN6Tu4eDokIYZMhALy+ZIhZAL//tUzEFHesw2IuALCiaJpWW0H4x/QoLk7GyMfbNvUeNcDv/EFmH05x3aAZQNS/EanOlISgoNWg61pSsLwpDckM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771548185; c=relaxed/simple;
	bh=Y47Xb4dw5xO8HZfU+CJIW1PqWuVsOo2PAdP6R7vBUVI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p3OXD0MBZ35G1sNwSe9fjbOGUOoOflegKABXHjH33hw25zuHUPmp6EhuEq3Ty5gZtHqWE8YC4dUAikZEDTn1jwqxiR2Euwo3mZCCykqJ7zpV/aPb6A2eDtpMYHWZ/L6AGzQ50/DkH86XwQcp5o/C9l8fq4lRU9xUUurkuHQUSmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z+Ix0bdS; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ab0b2e804cso17964855ad.3
        for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 16:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771548165; x=1772152965; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xso2tWNxR0OTsk2+fhRNaN+ralRXdVVdnxkm5VKh1IY=;
        b=z+Ix0bdSHyM0I3DPirMKhweTG8BVUQC6wJsYfFS/OxzsesagcboZI2CAmgJ773iwor
         ZNsneOrbsB/4/fF6UHqyK+jH24Hz6a3AGdEn0Tnr3Jn1aIAVWJ2tclTmapBYnsDvYf5p
         JvLT6tSZxOoXxCDntK5BagqtMWBWF5RprOw+wSh+0L2XL5ncS3t7Zitku9+WdWjViZv/
         8K8HR4DRy5paNj5P6GG7Szg0EBZ2wqo7lMZ/zq+eOI2Cv8uQFc8+PWaGVrc9ungm5rHx
         HKjN10wsrZKCeFZ08Zhz7QX843cLaRWNAl4V5Sa9Y5arc9jgq+hOpLq/DVx6a6eZYtI5
         V1BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771548165; x=1772152965;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xso2tWNxR0OTsk2+fhRNaN+ralRXdVVdnxkm5VKh1IY=;
        b=vGUVvZvCPXzYa0wlygBH/55ka4Cjixqo61jpusIM3tylWXoTqdae4KByds/n3Vj/+u
         0nFm4K2hbHl8OMfIjUTdeFKkGjH0sjq7WEOsU7kSHMn+bqqicBK9c1lnRnMzsTyG/Dmu
         zIpFNdugRcFNT73VXycSkM0HKNXBEuI4ZzxxTqastObLqmA8owio/IaDrno11xL2HPi7
         Qljr9iNArbC+3bnMcdC730vpSjzvACPjSNrmni1lMcSFhIKPSom5fsKUPo5uppAwL36x
         fcrv2erOvn//hdqE7f94G8EfuyFom5drrnxG/FUk8HrlaWEtb/YKi+JBjnPvpSkDAV5L
         kd+w==
X-Forwarded-Encrypted: i=1; AJvYcCUyZw+6OKv+SgKe24WpzRiAjuhGXqAp73FtFVCtveX4wBW9se3EoTvfycdLMT3ykiL8FWk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkOYwEPD6JMP6qK3HriNA0YihrHVEqyTBg5GopQb38glzBhfY8
	eJInpcUtHQS2uUXUvtRFW2lUKaH3Tkq9LfpOAa4XL53gYeTm7VI9hRrmWD1bZo6TzuWz4IIBPpq
	6J8UT7uipP7kKBg==
X-Received: from plbmv15.prod.google.com ([2002:a17:903:b8f:b0:2a0:9841:e599])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f792:b0:2a8:7814:47c9 with SMTP id d9443c01a7336-2ad5b0e11a2mr45475795ad.36.1771548164385;
 Thu, 19 Feb 2026 16:42:44 -0800 (PST)
Date: Fri, 20 Feb 2026 00:42:19 +0000
In-Reply-To: <20260220004223.4168331-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260220004223.4168331-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260220004223.4168331-7-dmatlack@google.com>
Subject: [PATCH v2 06/10] KVM: selftests: Use u32 instead of uint32_t
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Bibo Mao <maobibo@loongson.cn>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Colin Ian King <colin.i.king@gmail.com>, 
	David Hildenbrand <david@kernel.org>, David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Lisa Wang <wyihan@google.com>, loongarch@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Nutty Liu <nutty.liu@hotmail.com>, 
	Oliver Upton <oupton@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Rahul Kumar <rk0006818@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Wu Fei <wu.fei9@sanechips.com.cn>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71382-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[42];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[google.com,eecs.berkeley.edu,ghiti.fr,ventanamicro.com,brainfault.org,linux.dev,loongson.cn,linux.ibm.com,gmail.com,kernel.org,arm.com,lists.linux.dev,lists.infradead.org,vger.kernel.org,redhat.com,hotmail.com,dabbelt.com,amd.com,sanechips.com.cn,huawei.com];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,checkpatch.pl:url]
X-Rspamd-Queue-Id: 3B017163F9D
X-Rspamd-Action: no action

Use u32 instead of uint32_t to make the KVM selftests code more concise
and more similar to the kernel (since selftests are primarily developed
by kernel developers).

This commit was generated with the following command:

  git ls-files tools/testing/selftests/kvm | xargs sed -i 's/uint32_t/u32/g'

Then by manually adjusting whitespace to make checkpatch.pl happy.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/arch_timer.c      |   6 +-
 .../testing/selftests/kvm/arm64/arch_timer.c  |   6 +-
 .../kvm/arm64/arch_timer_edge_cases.c         |  26 ++--
 .../selftests/kvm/arm64/debug-exceptions.c    |  12 +-
 .../testing/selftests/kvm/arm64/hypercalls.c  |   6 +-
 .../selftests/kvm/arm64/page_fault_test.c     |   6 +-
 tools/testing/selftests/kvm/arm64/psci_test.c |   2 +-
 .../testing/selftests/kvm/arm64/set_id_regs.c |   6 +-
 .../selftests/kvm/arm64/smccc_filter.c        |  10 +-
 tools/testing/selftests/kvm/arm64/vgic_init.c |  30 ++---
 tools/testing/selftests/kvm/arm64/vgic_irq.c  |  91 ++++++-------
 .../testing/selftests/kvm/coalesced_io_test.c |  22 +--
 .../selftests/kvm/dirty_log_perf_test.c       |   2 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |  36 ++---
 .../testing/selftests/kvm/guest_print_test.c  |   6 +-
 .../selftests/kvm/hardware_disable_test.c     |   6 +-
 .../selftests/kvm/include/arm64/arch_timer.h  |  10 +-
 .../testing/selftests/kvm/include/arm64/gic.h |   2 +-
 .../selftests/kvm/include/arm64/processor.h   |  10 +-
 .../selftests/kvm/include/arm64/vgic.h        |  16 +--
 .../testing/selftests/kvm/include/kvm_util.h  | 125 +++++++++---------
 .../testing/selftests/kvm/include/memstress.h |  10 +-
 .../selftests/kvm/include/riscv/arch_timer.h  |   2 +-
 .../testing/selftests/kvm/include/test_util.h |  20 +--
 .../selftests/kvm/include/timer_test.h        |  12 +-
 .../testing/selftests/kvm/include/x86/apic.h  |  10 +-
 .../testing/selftests/kvm/include/x86/evmcs.h |   2 +-
 .../selftests/kvm/include/x86/processor.h     | 100 +++++++-------
 tools/testing/selftests/kvm/include/x86/sev.h |   4 +-
 tools/testing/selftests/kvm/include/x86/vmx.h |   6 +-
 .../selftests/kvm/kvm_page_table_test.c       |   2 +-
 tools/testing/selftests/kvm/lib/arm64/gic.c   |   2 +-
 .../selftests/kvm/lib/arm64/gic_private.h     |  22 +--
 .../testing/selftests/kvm/lib/arm64/gic_v3.c  |  80 +++++------
 .../selftests/kvm/lib/arm64/processor.c       |  22 +--
 tools/testing/selftests/kvm/lib/arm64/vgic.c  |  22 +--
 tools/testing/selftests/kvm/lib/guest_modes.c |   2 +-
 .../testing/selftests/kvm/lib/guest_sprintf.c |   6 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  78 +++++------
 .../selftests/kvm/lib/loongarch/processor.c   |   6 +-
 tools/testing/selftests/kvm/lib/memstress.c   |   4 +-
 .../selftests/kvm/lib/riscv/processor.c       |   6 +-
 .../selftests/kvm/lib/s390/processor.c        |   2 +-
 tools/testing/selftests/kvm/lib/sparsebit.c   |   4 +-
 tools/testing/selftests/kvm/lib/test_util.c   |  14 +-
 .../testing/selftests/kvm/lib/x86/processor.c |  24 ++--
 tools/testing/selftests/kvm/lib/x86/sev.c     |   4 +-
 tools/testing/selftests/kvm/lib/x86/vmx.c     |  10 +-
 .../selftests/kvm/loongarch/arch_timer.c      |  20 +--
 .../testing/selftests/kvm/memslot_perf_test.c |  50 +++----
 .../selftests/kvm/pre_fault_memory_test.c     |   2 +-
 .../testing/selftests/kvm/riscv/arch_timer.c  |   6 +-
 tools/testing/selftests/kvm/s390/memop.c      |  18 +--
 .../selftests/kvm/set_memory_region_test.c    |   8 +-
 tools/testing/selftests/kvm/steal_time.c      |  32 ++---
 tools/testing/selftests/kvm/x86/amx_test.c    |   4 +-
 .../selftests/kvm/x86/aperfmperf_test.c       |   2 +-
 .../selftests/kvm/x86/apic_bus_clock_test.c   |  12 +-
 tools/testing/selftests/kvm/x86/debug_regs.c  |   2 +-
 .../testing/selftests/kvm/x86/fastops_test.c  |   4 +-
 .../selftests/kvm/x86/feature_msrs_test.c     |   8 +-
 .../testing/selftests/kvm/x86/hyperv_evmcs.c  |   2 +-
 .../selftests/kvm/x86/hyperv_features.c       |   4 +-
 .../selftests/kvm/x86/hyperv_svm_test.c       |   2 +-
 tools/testing/selftests/kvm/x86/kvm_pv_test.c |   2 +-
 .../selftests/kvm/x86/nested_emulation_test.c |  10 +-
 .../kvm/x86/nested_exceptions_test.c          |   4 +-
 .../kvm/x86/nested_tsc_adjust_test.c          |   2 +-
 .../kvm/x86/nested_tsc_scaling_test.c         |   2 +-
 .../selftests/kvm/x86/pmu_counters_test.c     |  36 ++---
 .../selftests/kvm/x86/pmu_event_filter_test.c |  20 +--
 .../kvm/x86/private_mem_conversions_test.c    |   8 +-
 .../kvm/x86/private_mem_kvm_exits_test.c      |   8 +-
 .../selftests/kvm/x86/set_boot_cpu_id.c       |   6 +-
 .../selftests/kvm/x86/sev_init2_tests.c       |   4 +-
 .../selftests/kvm/x86/sev_smoke_test.c        |   8 +-
 .../selftests/kvm/x86/ucna_injection_test.c   |   2 +-
 .../kvm/x86/userspace_msr_exit_test.c         |  28 ++--
 .../selftests/kvm/x86/vmx_apic_access_test.c  |   2 +-
 .../kvm/x86/vmx_apicv_updates_test.c          |   2 +-
 .../testing/selftests/kvm/x86/vmx_msrs_test.c |   8 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        |  16 +--
 .../selftests/kvm/x86/xapic_state_test.c      |   4 +-
 .../selftests/kvm/x86/xapic_tpr_test.c        |   6 +-
 .../selftests/kvm/x86/xen_shinfo_test.c       |   6 +-
 85 files changed, 635 insertions(+), 637 deletions(-)

diff --git a/tools/testing/selftests/kvm/arch_timer.c b/tools/testing/selftests/kvm/arch_timer.c
index cf8fb67104f1..90c475a61b22 100644
--- a/tools/testing/selftests/kvm/arch_timer.c
+++ b/tools/testing/selftests/kvm/arch_timer.c
@@ -78,9 +78,9 @@ static void *test_vcpu_run(void *arg)
 	return NULL;
 }
 
-static uint32_t test_get_pcpu(void)
+static u32 test_get_pcpu(void)
 {
-	uint32_t pcpu;
+	u32 pcpu;
 	unsigned int nproc_conf;
 	cpu_set_t online_cpuset;
 
@@ -98,7 +98,7 @@ static uint32_t test_get_pcpu(void)
 static int test_migrate_vcpu(unsigned int vcpu_idx)
 {
 	int ret;
-	uint32_t new_pcpu = test_get_pcpu();
+	u32 new_pcpu = test_get_pcpu();
 
 	pr_debug("Migrating vCPU: %u to pCPU: %u\n", vcpu_idx, new_pcpu);
 
diff --git a/tools/testing/selftests/kvm/arm64/arch_timer.c b/tools/testing/selftests/kvm/arm64/arch_timer.c
index 3e5f32bd2352..5fa5c0ec2b3e 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer.c
@@ -105,7 +105,7 @@ static void guest_validate_irq(unsigned int intid,
 static void guest_irq_handler(struct ex_regs *regs)
 {
 	unsigned int intid = gic_get_and_ack_irq();
-	uint32_t cpu = guest_get_vcpuid();
+	u32 cpu = guest_get_vcpuid();
 	struct test_vcpu_shared_data *shared_data = &vcpu_shared_data[cpu];
 
 	guest_validate_irq(intid, shared_data);
@@ -116,7 +116,7 @@ static void guest_irq_handler(struct ex_regs *regs)
 static void guest_run_stage(struct test_vcpu_shared_data *shared_data,
 				enum guest_stage stage)
 {
-	uint32_t irq_iter, config_iter;
+	u32 irq_iter, config_iter;
 
 	shared_data->guest_stage = stage;
 	shared_data->nr_iter = 0;
@@ -140,7 +140,7 @@ static void guest_run_stage(struct test_vcpu_shared_data *shared_data,
 
 static void guest_code(void)
 {
-	uint32_t cpu = guest_get_vcpuid();
+	u32 cpu = guest_get_vcpuid();
 	struct test_vcpu_shared_data *shared_data = &vcpu_shared_data[cpu];
 
 	local_irq_disable();
diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
index 7aed5dd2a347..f8b183f13864 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
@@ -29,19 +29,19 @@ static const int32_t TVAL_MAX = INT32_MAX;
 static const int32_t TVAL_MIN = INT32_MIN;
 
 /* After how much time we say there is no IRQ. */
-static const uint32_t TIMEOUT_NO_IRQ_US = 50000;
+static const u32 TIMEOUT_NO_IRQ_US = 50000;
 
 /* Counter value to use as the starting one for most tests. Set to CVAL_MAX/2 */
 static u64 DEF_CNT;
 
 /* Number of runs. */
-static const uint32_t NR_TEST_ITERS_DEF = 5;
+static const u32 NR_TEST_ITERS_DEF = 5;
 
 /* Default wait test time in ms. */
-static const uint32_t WAIT_TEST_MS = 10;
+static const u32 WAIT_TEST_MS = 10;
 
 /* Default "long" wait test time in ms. */
-static const uint32_t LONG_WAIT_TEST_MS = 100;
+static const u32 LONG_WAIT_TEST_MS = 100;
 
 /* Shared with IRQ handler. */
 struct test_vcpu_shared_data {
@@ -115,7 +115,7 @@ enum timer_view {
 	TIMER_TVAL,
 };
 
-static void assert_irqs_handled(uint32_t n)
+static void assert_irqs_handled(u32 n)
 {
 	int h = atomic_read(&shared_data.handled);
 
@@ -147,7 +147,7 @@ static void guest_irq_handler(struct ex_regs *regs)
 	unsigned int intid = gic_get_and_ack_irq();
 	enum arch_timer timer;
 	u64 cnt, cval;
-	uint32_t ctl;
+	u32 ctl;
 	bool timer_condition, istatus;
 
 	if (intid == IAR_SPURIOUS) {
@@ -179,7 +179,7 @@ static void guest_irq_handler(struct ex_regs *regs)
 }
 
 static void set_cval_irq(enum arch_timer timer, u64 cval_cycles,
-			 uint32_t ctl)
+			 u32 ctl)
 {
 	atomic_set(&shared_data.handled, 0);
 	atomic_set(&shared_data.spurious, 0);
@@ -188,7 +188,7 @@ static void set_cval_irq(enum arch_timer timer, u64 cval_cycles,
 }
 
 static void set_tval_irq(enum arch_timer timer, u64 tval_cycles,
-			 uint32_t ctl)
+			 u32 ctl)
 {
 	atomic_set(&shared_data.handled, 0);
 	atomic_set(&shared_data.spurious, 0);
@@ -196,7 +196,7 @@ static void set_tval_irq(enum arch_timer timer, u64 tval_cycles,
 	timer_set_ctl(timer, ctl);
 }
 
-static void set_xval_irq(enum arch_timer timer, u64 xval, uint32_t ctl,
+static void set_xval_irq(enum arch_timer timer, u64 xval, u32 ctl,
 			 enum timer_view tv)
 {
 	switch (tv) {
@@ -845,11 +845,11 @@ static void guest_code(enum arch_timer timer)
 
 static cpu_set_t default_cpuset;
 
-static uint32_t next_pcpu(void)
+static u32 next_pcpu(void)
 {
-	uint32_t max = get_nprocs();
-	uint32_t cur = sched_getcpu();
-	uint32_t next = cur;
+	u32 max = get_nprocs();
+	u32 cur = sched_getcpu();
+	u32 next = cur;
 	cpu_set_t cpuset = default_cpuset;
 
 	TEST_ASSERT(max > 1, "Need at least two physical cpus");
diff --git a/tools/testing/selftests/kvm/arm64/debug-exceptions.c b/tools/testing/selftests/kvm/arm64/debug-exceptions.c
index c19f143bed25..5931915ea00a 100644
--- a/tools/testing/selftests/kvm/arm64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/arm64/debug-exceptions.c
@@ -151,7 +151,7 @@ static void enable_monitor_debug_exceptions(void)
 
 static void install_wp(uint8_t wpn, u64 addr)
 {
-	uint32_t wcr;
+	u32 wcr;
 
 	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
 	write_dbgwcr(wpn, wcr);
@@ -164,7 +164,7 @@ static void install_wp(uint8_t wpn, u64 addr)
 
 static void install_hw_bp(uint8_t bpn, u64 addr)
 {
-	uint32_t bcr;
+	u32 bcr;
 
 	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
 	write_dbgbcr(bpn, bcr);
@@ -177,7 +177,7 @@ static void install_hw_bp(uint8_t bpn, u64 addr)
 static void install_wp_ctx(uint8_t addr_wp, uint8_t ctx_bp, u64 addr,
 			   u64 ctx)
 {
-	uint32_t wcr;
+	u32 wcr;
 	u64 ctx_bcr;
 
 	/* Setup a context-aware breakpoint for Linked Context ID Match */
@@ -188,7 +188,7 @@ static void install_wp_ctx(uint8_t addr_wp, uint8_t ctx_bp, u64 addr,
 
 	/* Setup a linked watchpoint (linked to the context-aware breakpoint) */
 	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E |
-	      DBGWCR_WT_LINK | ((uint32_t)ctx_bp << DBGWCR_LBN_SHIFT);
+	      DBGWCR_WT_LINK | ((u32)ctx_bp << DBGWCR_LBN_SHIFT);
 	write_dbgwcr(addr_wp, wcr);
 	write_dbgwvr(addr_wp, addr);
 	isb();
@@ -199,7 +199,7 @@ static void install_wp_ctx(uint8_t addr_wp, uint8_t ctx_bp, u64 addr,
 void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, u64 addr,
 		       u64 ctx)
 {
-	uint32_t addr_bcr, ctx_bcr;
+	u32 addr_bcr, ctx_bcr;
 
 	/* Setup a context-aware breakpoint for Linked Context ID Match */
 	ctx_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
@@ -213,7 +213,7 @@ void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, u64 addr,
 	 */
 	addr_bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E |
 		   DBGBCR_BT_ADDR_LINK_CTX |
-		   ((uint32_t)ctx_bp << DBGBCR_LBN_SHIFT);
+		   ((u32)ctx_bp << DBGBCR_LBN_SHIFT);
 	write_dbgbcr(addr_bp, addr_bcr);
 	write_dbgbvr(addr_bp, addr);
 	isb();
diff --git a/tools/testing/selftests/kvm/arm64/hypercalls.c b/tools/testing/selftests/kvm/arm64/hypercalls.c
index 4f24105baaf3..5d96cdf382c4 100644
--- a/tools/testing/selftests/kvm/arm64/hypercalls.c
+++ b/tools/testing/selftests/kvm/arm64/hypercalls.c
@@ -59,7 +59,7 @@ enum test_stage {
 static int stage = TEST_STAGE_REG_IFACE;
 
 struct test_hvc_info {
-	uint32_t func_id;
+	u32 func_id;
 	u64 arg1;
 };
 
@@ -152,8 +152,8 @@ static void guest_code(void)
 }
 
 struct st_time {
-	uint32_t rev;
-	uint32_t attr;
+	u32 rev;
+	u32 attr;
 	u64 st_time;
 };
 
diff --git a/tools/testing/selftests/kvm/arm64/page_fault_test.c b/tools/testing/selftests/kvm/arm64/page_fault_test.c
index 5d629ea95c4d..cb52ac8aa0a5 100644
--- a/tools/testing/selftests/kvm/arm64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/arm64/page_fault_test.c
@@ -59,8 +59,8 @@ struct test_desc {
 	void (*iabt_handler)(struct ex_regs *regs);
 	void (*mmio_handler)(struct kvm_vm *vm, struct kvm_run *run);
 	void (*fail_vcpu_run_handler)(int ret);
-	uint32_t pt_memslot_flags;
-	uint32_t data_memslot_flags;
+	u32 pt_memslot_flags;
+	u32 data_memslot_flags;
 	bool skip;
 	struct event_cnt expected_events;
 };
@@ -510,7 +510,7 @@ void fail_vcpu_run_mmio_no_syndrome_handler(int ret)
 	events.fail_vcpu_runs += 1;
 }
 
-typedef uint32_t aarch64_insn_t;
+typedef u32 aarch64_insn_t;
 extern aarch64_insn_t __exec_test[2];
 
 noinline void __return_0x77(void)
diff --git a/tools/testing/selftests/kvm/arm64/psci_test.c b/tools/testing/selftests/kvm/arm64/psci_test.c
index 0a67dc3136d4..e775faf20868 100644
--- a/tools/testing/selftests/kvm/arm64/psci_test.c
+++ b/tools/testing/selftests/kvm/arm64/psci_test.c
@@ -61,7 +61,7 @@ static u64 psci_system_off2(u64 type, u64 cookie)
 	return res.a0;
 }
 
-static u64 psci_features(uint32_t func_id)
+static u64 psci_features(u32 func_id)
 {
 	struct arm_smccc_res res;
 
diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 19f4a612137f..f489118f9f0c 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -40,7 +40,7 @@ struct reg_ftr_bits {
 };
 
 struct test_feature_reg {
-	uint32_t reg;
+	u32 reg;
 	const struct reg_ftr_bits *ftr_bits;
 };
 
@@ -448,7 +448,7 @@ static void test_vm_ftr_id_regs(struct kvm_vcpu *vcpu, bool aarch64_only)
 
 	for (int i = 0; i < ARRAY_SIZE(test_regs); i++) {
 		const struct reg_ftr_bits *ftr_bits = test_regs[i].ftr_bits;
-		uint32_t reg_id = test_regs[i].reg;
+		u32 reg_id = test_regs[i].reg;
 		u64 reg = KVM_ARM64_SYS_REG(reg_id);
 		int idx;
 
@@ -734,7 +734,7 @@ static void test_vcpu_non_ftr_id_regs(struct kvm_vcpu *vcpu)
 	ksft_test_result_pass("%s\n", __func__);
 }
 
-static void test_assert_id_reg_unchanged(struct kvm_vcpu *vcpu, uint32_t encoding)
+static void test_assert_id_reg_unchanged(struct kvm_vcpu *vcpu, u32 encoding)
 {
 	size_t idx = encoding_to_range_idx(encoding);
 	u64 observed;
diff --git a/tools/testing/selftests/kvm/arm64/smccc_filter.c b/tools/testing/selftests/kvm/arm64/smccc_filter.c
index 1763b9d45400..21e41880261b 100644
--- a/tools/testing/selftests/kvm/arm64/smccc_filter.c
+++ b/tools/testing/selftests/kvm/arm64/smccc_filter.c
@@ -37,7 +37,7 @@ static bool test_runs_at_el2(void)
 	for (conduit = test_runs_at_el2() ? SMC_INSN : HVC_INSN;	\
 	     conduit <= SMC_INSN; conduit++)
 
-static void guest_main(uint32_t func_id, enum smccc_conduit conduit)
+static void guest_main(u32 func_id, enum smccc_conduit conduit)
 {
 	struct arm_smccc_res res;
 
@@ -49,7 +49,7 @@ static void guest_main(uint32_t func_id, enum smccc_conduit conduit)
 	GUEST_SYNC(res.a0);
 }
 
-static int __set_smccc_filter(struct kvm_vm *vm, uint32_t start, uint32_t nr_functions,
+static int __set_smccc_filter(struct kvm_vm *vm, u32 start, u32 nr_functions,
 			      enum kvm_smccc_filter_action action)
 {
 	struct kvm_smccc_filter filter = {
@@ -62,7 +62,7 @@ static int __set_smccc_filter(struct kvm_vm *vm, uint32_t start, uint32_t nr_fun
 				     KVM_ARM_VM_SMCCC_FILTER, &filter);
 }
 
-static void set_smccc_filter(struct kvm_vm *vm, uint32_t start, uint32_t nr_functions,
+static void set_smccc_filter(struct kvm_vm *vm, u32 start, u32 nr_functions,
 			     enum kvm_smccc_filter_action action)
 {
 	int ret = __set_smccc_filter(vm, start, nr_functions, action);
@@ -112,7 +112,7 @@ static void test_filter_reserved_range(void)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm = setup_vm(&vcpu);
-	uint32_t smc64_fn;
+	u32 smc64_fn;
 	int r;
 
 	r = __set_smccc_filter(vm, ARM_SMCCC_ARCH_WORKAROUND_1,
@@ -217,7 +217,7 @@ static void test_filter_denied(void)
 	}
 }
 
-static void expect_call_fwd_to_user(struct kvm_vcpu *vcpu, uint32_t func_id,
+static void expect_call_fwd_to_user(struct kvm_vcpu *vcpu, u32 func_id,
 				    enum smccc_conduit conduit)
 {
 	struct kvm_run *run = vcpu->run;
diff --git a/tools/testing/selftests/kvm/arm64/vgic_init.c b/tools/testing/selftests/kvm/arm64/vgic_init.c
index 0d8ddb371b89..47e34b43afb2 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_init.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_init.c
@@ -27,7 +27,7 @@
 struct vm_gic {
 	struct kvm_vm *vm;
 	int gic_fd;
-	uint32_t gic_dev_type;
+	u32 gic_dev_type;
 };
 
 static u64 max_phys_size;
@@ -39,17 +39,17 @@ static u64 max_phys_size;
 static void v3_redist_reg_get_errno(int gicv3_fd, int vcpu, int offset,
 				    int want, const char *msg)
 {
-	uint32_t ignored_val;
+	u32 ignored_val;
 	int ret = __kvm_device_attr_get(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_REDIST_REGS,
 					REG_OFFSET(vcpu, offset), &ignored_val);
 
 	TEST_ASSERT(ret && errno == want, "%s; want errno = %d", msg, want);
 }
 
-static void v3_redist_reg_get(int gicv3_fd, int vcpu, int offset, uint32_t want,
+static void v3_redist_reg_get(int gicv3_fd, int vcpu, int offset, u32 want,
 			      const char *msg)
 {
-	uint32_t val;
+	u32 val;
 
 	kvm_device_attr_get(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_REDIST_REGS,
 			    REG_OFFSET(vcpu, offset), &val);
@@ -71,8 +71,8 @@ static int run_vcpu(struct kvm_vcpu *vcpu)
 	return __vcpu_run(vcpu) ? -errno : 0;
 }
 
-static struct vm_gic vm_gic_create_with_vcpus(uint32_t gic_dev_type,
-					      uint32_t nr_vcpus,
+static struct vm_gic vm_gic_create_with_vcpus(u32 gic_dev_type,
+					      u32 nr_vcpus,
 					      struct kvm_vcpu *vcpus[])
 {
 	struct vm_gic v;
@@ -84,7 +84,7 @@ static struct vm_gic vm_gic_create_with_vcpus(uint32_t gic_dev_type,
 	return v;
 }
 
-static struct vm_gic vm_gic_create_barebones(uint32_t gic_dev_type)
+static struct vm_gic vm_gic_create_barebones(u32 gic_dev_type)
 {
 	struct vm_gic v;
 
@@ -332,7 +332,7 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
  * VGIC KVM device is created and initialized before the secondary CPUs
  * get created
  */
-static void test_vgic_then_vcpus(uint32_t gic_dev_type)
+static void test_vgic_then_vcpus(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct vm_gic v;
@@ -353,7 +353,7 @@ static void test_vgic_then_vcpus(uint32_t gic_dev_type)
 }
 
 /* All the VCPUs are created before the VGIC KVM device gets initialized */
-static void test_vcpus_then_vgic(uint32_t gic_dev_type)
+static void test_vcpus_then_vgic(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct vm_gic v;
@@ -518,7 +518,7 @@ static void test_v3_typer_accesses(void)
 }
 
 static struct vm_gic vm_gic_v3_create_with_vcpuids(int nr_vcpus,
-						   uint32_t vcpuids[])
+						   u32 vcpuids[])
 {
 	struct vm_gic v;
 	int i;
@@ -544,7 +544,7 @@ static struct vm_gic vm_gic_v3_create_with_vcpuids(int nr_vcpus,
  */
 static void test_v3_last_bit_redist_regions(void)
 {
-	uint32_t vcpuids[] = { 0, 3, 5, 4, 1, 2 };
+	u32 vcpuids[] = { 0, 3, 5, 4, 1, 2 };
 	struct vm_gic v;
 	u64 addr;
 
@@ -578,7 +578,7 @@ static void test_v3_last_bit_redist_regions(void)
 /* Test last bit with legacy region */
 static void test_v3_last_bit_single_rdist(void)
 {
-	uint32_t vcpuids[] = { 0, 3, 5, 4, 1, 2 };
+	u32 vcpuids[] = { 0, 3, 5, 4, 1, 2 };
 	struct vm_gic v;
 	u64 addr;
 
@@ -717,11 +717,11 @@ static void test_v3_nassgicap(void)
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
  */
-int test_kvm_device(uint32_t gic_dev_type)
+int test_kvm_device(u32 gic_dev_type)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct vm_gic v;
-	uint32_t other;
+	u32 other;
 	int ret;
 
 	v.vm = vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
@@ -968,7 +968,7 @@ static void test_v3_sysregs(void)
 	kvm_vm_free(vm);
 }
 
-void run_tests(uint32_t gic_dev_type)
+void run_tests(u32 gic_dev_type)
 {
 	test_vcpus_then_vgic(gic_dev_type);
 	test_vgic_then_vcpus(gic_dev_type);
diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index 196dcaefc530..f49391ce6911 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -24,12 +24,12 @@
  * function.
  */
 struct test_args {
-	uint32_t nr_irqs; /* number of KVM supported IRQs. */
+	u32 nr_irqs; /* number of KVM supported IRQs. */
 	bool eoi_split; /* 1 is eoir+dir, 0 is eoir only */
 	bool level_sensitive; /* 1 is level, 0 is edge */
 	int kvm_max_routes; /* output of KVM_CAP_IRQ_ROUTING */
 	bool kvm_supports_irqfd; /* output of KVM_CAP_IRQFD */
-	uint32_t shared_data;
+	u32 shared_data;
 };
 
 /*
@@ -64,15 +64,15 @@ typedef enum {
 
 struct kvm_inject_args {
 	kvm_inject_cmd cmd;
-	uint32_t first_intid;
-	uint32_t num;
+	u32 first_intid;
+	u32 num;
 	int level;
 	bool expect_failure;
 };
 
 /* Used on the guest side to perform the hypercall. */
-static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t first_intid,
-		uint32_t num, int level, bool expect_failure);
+static void kvm_inject_call(kvm_inject_cmd cmd, u32 first_intid,
+			    u32 num, int level, bool expect_failure);
 
 /* Used on the host side to get the hypercall info. */
 static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
@@ -134,7 +134,7 @@ static struct kvm_inject_desc set_active_fns[] = {
 
 /* Shared between the guest main thread and the IRQ handlers. */
 volatile u64 irq_handled;
-volatile uint32_t irqnr_received[MAX_SPI + 1];
+volatile u32 irqnr_received[MAX_SPI + 1];
 
 static void reset_stats(void)
 {
@@ -159,11 +159,11 @@ static void gic_write_ap1r0(u64 val)
 	isb();
 }
 
-static void guest_set_irq_line(uint32_t intid, uint32_t level);
+static void guest_set_irq_line(u32 intid, u32 level);
 
 static void guest_irq_generic_handler(bool eoi_split, bool level_sensitive)
 {
-	uint32_t intid = gic_get_and_ack_irq();
+	u32 intid = gic_get_and_ack_irq();
 
 	if (intid == IAR_SPURIOUS)
 		return;
@@ -189,8 +189,8 @@ static void guest_irq_generic_handler(bool eoi_split, bool level_sensitive)
 	GUEST_ASSERT(!gic_irq_get_pending(intid));
 }
 
-static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t first_intid,
-		uint32_t num, int level, bool expect_failure)
+static void kvm_inject_call(kvm_inject_cmd cmd, u32 first_intid,
+			    u32 num, int level, bool expect_failure)
 {
 	struct kvm_inject_args args = {
 		.cmd = cmd,
@@ -204,7 +204,7 @@ static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t first_intid,
 
 #define GUEST_ASSERT_IAR_EMPTY()						\
 do { 										\
-	uint32_t _intid;							\
+	u32 _intid;							\
 	_intid = gic_get_and_ack_irq();						\
 	GUEST_ASSERT(_intid == IAR_SPURIOUS);					\
 } while (0)
@@ -237,13 +237,13 @@ static void reset_priorities(struct test_args *args)
 		gic_set_priority(i, IRQ_DEFAULT_PRIO_REG);
 }
 
-static void guest_set_irq_line(uint32_t intid, uint32_t level)
+static void guest_set_irq_line(u32 intid, u32 level)
 {
 	kvm_inject_call(KVM_SET_IRQ_LINE, intid, 1, level, false);
 }
 
 static void test_inject_fail(struct test_args *args,
-		uint32_t intid, kvm_inject_cmd cmd)
+			     u32 intid, kvm_inject_cmd cmd)
 {
 	reset_stats();
 
@@ -255,10 +255,10 @@ static void test_inject_fail(struct test_args *args,
 }
 
 static void guest_inject(struct test_args *args,
-		uint32_t first_intid, uint32_t num,
-		kvm_inject_cmd cmd)
+			 u32 first_intid, u32 num,
+			 kvm_inject_cmd cmd)
 {
-	uint32_t i;
+	u32 i;
 
 	reset_stats();
 
@@ -292,10 +292,10 @@ static void guest_inject(struct test_args *args,
  * deactivated yet.
  */
 static void guest_restore_active(struct test_args *args,
-		uint32_t first_intid, uint32_t num,
-		kvm_inject_cmd cmd)
+				 u32 first_intid, u32 num,
+				 kvm_inject_cmd cmd)
 {
-	uint32_t prio, intid, ap1r;
+	u32 prio, intid, ap1r;
 	int i;
 
 	/*
@@ -342,9 +342,9 @@ static void guest_restore_active(struct test_args *args,
  * This function should only be used in test_inject_preemption (with IRQs
  * masked).
  */
-static uint32_t wait_for_and_activate_irq(void)
+static u32 wait_for_and_activate_irq(void)
 {
-	uint32_t intid;
+	u32 intid;
 
 	do {
 		asm volatile("wfi" : : : "memory");
@@ -360,11 +360,11 @@ static uint32_t wait_for_and_activate_irq(void)
  * interrupts for the whole test.
  */
 static void test_inject_preemption(struct test_args *args,
-				   uint32_t first_intid, int num,
+				   u32 first_intid, int num,
 				   const unsigned long *exclude,
 				   kvm_inject_cmd cmd)
 {
-	uint32_t intid, prio, step = KVM_PRIO_STEPS;
+	u32 intid, prio, step = KVM_PRIO_STEPS;
 	int i;
 
 	/* Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
@@ -379,7 +379,7 @@ static void test_inject_preemption(struct test_args *args,
 	local_irq_disable();
 
 	for (i = 0; i < num; i++) {
-		uint32_t tmp;
+		u32 tmp;
 		intid = i + first_intid;
 
 		if (exclude && test_bit(i, exclude))
@@ -431,7 +431,7 @@ static void test_inject_preemption(struct test_args *args,
 
 static void test_injection(struct test_args *args, struct kvm_inject_desc *f)
 {
-	uint32_t nr_irqs = args->nr_irqs;
+	u32 nr_irqs = args->nr_irqs;
 
 	if (f->sgi) {
 		guest_inject(args, MIN_SGI, 1, f->cmd);
@@ -451,7 +451,7 @@ static void test_injection(struct test_args *args, struct kvm_inject_desc *f)
 static void test_injection_failure(struct test_args *args,
 		struct kvm_inject_desc *f)
 {
-	uint32_t bad_intid[] = { args->nr_irqs, 1020, 1024, 1120, 5120, ~0U, };
+	u32 bad_intid[] = { args->nr_irqs, 1020, 1024, 1120, 5120, ~0U, };
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(bad_intid); i++)
@@ -490,7 +490,7 @@ static void test_restore_active(struct test_args *args, struct kvm_inject_desc *
 
 static void guest_code(struct test_args *args)
 {
-	uint32_t i, nr_irqs = args->nr_irqs;
+	u32 i, nr_irqs = args->nr_irqs;
 	bool level_sensitive = args->level_sensitive;
 	struct kvm_inject_desc *f, *inject_fns;
 
@@ -529,8 +529,8 @@ static void guest_code(struct test_args *args)
 	GUEST_DONE();
 }
 
-static void kvm_irq_line_check(struct kvm_vm *vm, uint32_t intid, int level,
-			struct test_args *test_args, bool expect_failure)
+static void kvm_irq_line_check(struct kvm_vm *vm, u32 intid, int level,
+			       struct test_args *test_args, bool expect_failure)
 {
 	int ret;
 
@@ -548,8 +548,8 @@ static void kvm_irq_line_check(struct kvm_vm *vm, uint32_t intid, int level,
 	}
 }
 
-void kvm_irq_set_level_info_check(int gic_fd, uint32_t intid, int level,
-			bool expect_failure)
+void kvm_irq_set_level_info_check(int gic_fd, u32 intid, int level,
+				  bool expect_failure)
 {
 	if (!expect_failure) {
 		kvm_irq_set_level_info(gic_fd, intid, level);
@@ -573,8 +573,9 @@ void kvm_irq_set_level_info_check(int gic_fd, uint32_t intid, int level,
 }
 
 static void kvm_set_gsi_routing_irqchip_check(struct kvm_vm *vm,
-		uint32_t intid, uint32_t num, uint32_t kvm_max_routes,
-		bool expect_failure)
+					      u32 intid, u32 num,
+					      u32 kvm_max_routes,
+					      bool expect_failure)
 {
 	struct kvm_irq_routing *routing;
 	int ret;
@@ -602,7 +603,7 @@ static void kvm_set_gsi_routing_irqchip_check(struct kvm_vm *vm,
 	}
 }
 
-static void kvm_irq_write_ispendr_check(int gic_fd, uint32_t intid,
+static void kvm_irq_write_ispendr_check(int gic_fd, u32 intid,
 					struct kvm_vcpu *vcpu,
 					bool expect_failure)
 {
@@ -618,8 +619,8 @@ static void kvm_irq_write_ispendr_check(int gic_fd, uint32_t intid,
 }
 
 static void kvm_routing_and_irqfd_check(struct kvm_vm *vm,
-		uint32_t intid, uint32_t num, uint32_t kvm_max_routes,
-		bool expect_failure)
+					u32 intid, u32 num, u32 kvm_max_routes,
+					bool expect_failure)
 {
 	int fd[MAX_SPI];
 	u64 val;
@@ -673,13 +674,13 @@ static void run_guest_cmd(struct kvm_vcpu *vcpu, int gic_fd,
 			  struct test_args *test_args)
 {
 	kvm_inject_cmd cmd = inject_args->cmd;
-	uint32_t intid = inject_args->first_intid;
-	uint32_t num = inject_args->num;
+	u32 intid = inject_args->first_intid;
+	u32 num = inject_args->num;
 	int level = inject_args->level;
 	bool expect_failure = inject_args->expect_failure;
 	struct kvm_vm *vm = vcpu->vm;
 	u64 tmp;
-	uint32_t i;
+	u32 i;
 
 	/* handles the valid case: intid=0xffffffff num=1 */
 	assert(intid < UINT_MAX - num || num == 1);
@@ -745,7 +746,7 @@ static void print_args(struct test_args *args)
 			args->eoi_split);
 }
 
-static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
+static void test_vgic(u32 nr_irqs, bool level_sensitive, bool eoi_split)
 {
 	struct ucall uc;
 	int gic_fd;
@@ -810,7 +811,7 @@ static void guest_code_asym_dir(struct test_args *args, int cpuid)
 	gic_set_priority_mask(CPU_PRIO_MASK);
 
 	if (cpuid == 0) {
-		uint32_t intid;
+		u32 intid;
 
 		local_irq_disable();
 
@@ -848,7 +849,7 @@ static void guest_code_asym_dir(struct test_args *args, int cpuid)
 
 static void guest_code_group_en(struct test_args *args, int cpuid)
 {
-	uint32_t intid;
+	u32 intid;
 
 	gic_init(GIC_V3, 2);
 
@@ -896,7 +897,7 @@ static void guest_code_group_en(struct test_args *args, int cpuid)
 
 static void guest_code_timer_spi(struct test_args *args, int cpuid)
 {
-	uint32_t intid;
+	u32 intid;
 	u64 val;
 
 	gic_init(GIC_V3, 2);
@@ -1033,7 +1034,7 @@ static void help(const char *name)
 
 int main(int argc, char **argv)
 {
-	uint32_t nr_irqs = 64;
+	u32 nr_irqs = 64;
 	bool default_args = true;
 	bool level_sensitive = false;
 	int opt;
diff --git a/tools/testing/selftests/kvm/coalesced_io_test.c b/tools/testing/selftests/kvm/coalesced_io_test.c
index ed6a66020b1e..f5ab412d2042 100644
--- a/tools/testing/selftests/kvm/coalesced_io_test.c
+++ b/tools/testing/selftests/kvm/coalesced_io_test.c
@@ -14,7 +14,7 @@
 
 struct kvm_coalesced_io {
 	struct kvm_coalesced_mmio_ring *ring;
-	uint32_t ring_size;
+	u32 ring_size;
 	u64 mmio_gpa;
 	u64 *mmio;
 
@@ -70,13 +70,13 @@ static void guest_code(struct kvm_coalesced_io *io)
 
 static void vcpu_run_and_verify_io_exit(struct kvm_vcpu *vcpu,
 					struct kvm_coalesced_io *io,
-					uint32_t ring_start,
-					uint32_t expected_exit)
+					u32 ring_start,
+					u32 expected_exit)
 {
 	const bool want_pio = expected_exit == KVM_EXIT_IO;
 	struct kvm_coalesced_mmio_ring *ring = io->ring;
 	struct kvm_run *run = vcpu->run;
-	uint32_t pio_value;
+	u32 pio_value;
 
 	WRITE_ONCE(ring->first, ring_start);
 	WRITE_ONCE(ring->last, ring_start);
@@ -88,7 +88,7 @@ static void vcpu_run_and_verify_io_exit(struct kvm_vcpu *vcpu,
 	 * data_offset is garbage, e.g. an MMIO gpa.
 	 */
 	if (run->exit_reason == KVM_EXIT_IO)
-		pio_value = *(uint32_t *)((void *)run + run->io.data_offset);
+		pio_value = *(u32 *)((void *)run + run->io.data_offset);
 	else
 		pio_value = 0;
 
@@ -111,8 +111,8 @@ static void vcpu_run_and_verify_io_exit(struct kvm_vcpu *vcpu,
 
 static void vcpu_run_and_verify_coalesced_io(struct kvm_vcpu *vcpu,
 					     struct kvm_coalesced_io *io,
-					     uint32_t ring_start,
-					     uint32_t expected_exit)
+					     u32 ring_start,
+					     u32 expected_exit)
 {
 	struct kvm_coalesced_mmio_ring *ring = io->ring;
 	int i;
@@ -124,18 +124,18 @@ static void vcpu_run_and_verify_coalesced_io(struct kvm_vcpu *vcpu,
 		    ring->first, ring->last, io->ring_size, ring_start);
 
 	for (i = 0; i < io->ring_size - 1; i++) {
-		uint32_t idx = (ring->first + i) % io->ring_size;
+		u32 idx = (ring->first + i) % io->ring_size;
 		struct kvm_coalesced_mmio *entry = &ring->coalesced_mmio[idx];
 
 #ifdef __x86_64__
 		if (i & 1)
 			TEST_ASSERT(entry->phys_addr == io->pio_port &&
 				    entry->len == 4 && entry->pio &&
-				    *(uint32_t *)entry->data == io->pio_port + i,
+				    *(u32 *)entry->data == io->pio_port + i,
 				    "Wanted 4-byte port I/O 0x%x = 0x%x in entry %u, got %u-byte %s 0x%llx = 0x%x",
 				    io->pio_port, io->pio_port + i, i,
 				    entry->len, entry->pio ? "PIO" : "MMIO",
-				    entry->phys_addr, *(uint32_t *)entry->data);
+				    entry->phys_addr, *(u32 *)entry->data);
 		else
 #endif
 			TEST_ASSERT(entry->phys_addr == io->mmio_gpa &&
@@ -148,7 +148,7 @@ static void vcpu_run_and_verify_coalesced_io(struct kvm_vcpu *vcpu,
 }
 
 static void test_coalesced_io(struct kvm_vcpu *vcpu,
-			      struct kvm_coalesced_io *io, uint32_t ring_start)
+			      struct kvm_coalesced_io *io, u32 ring_start)
 {
 	struct kvm_coalesced_mmio_ring *ring = io->ring;
 
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 7d170694e9c1..ef779fa91827 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -97,7 +97,7 @@ struct test_params {
 	bool partition_vcpu_memory_access;
 	enum vm_mem_backing_src_type backing_src;
 	int slots;
-	uint32_t write_percent;
+	u32 write_percent;
 	bool random_access;
 };
 
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index dae9af043b13..2538c7f2c261 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -236,7 +236,7 @@ static enum log_mode_t host_log_mode_option = LOG_MODE_ALL;
 /* Logging mode for current run */
 static enum log_mode_t host_log_mode;
 static pthread_t vcpu_thread;
-static uint32_t test_dirty_ring_count = TEST_DIRTY_RING_COUNT;
+static u32 test_dirty_ring_count = TEST_DIRTY_RING_COUNT;
 
 static bool clear_log_supported(void)
 {
@@ -255,15 +255,15 @@ static void clear_log_create_vm_done(struct kvm_vm *vm)
 }
 
 static void dirty_log_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
-					  void *bitmap, uint32_t num_pages,
-					  uint32_t *unused)
+					  void *bitmap, u32 num_pages,
+					  u32 *unused)
 {
 	kvm_vm_get_dirty_log(vcpu->vm, slot, bitmap);
 }
 
 static void clear_log_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
-					  void *bitmap, uint32_t num_pages,
-					  uint32_t *unused)
+					  void *bitmap, u32 num_pages,
+					  u32 *unused)
 {
 	kvm_vm_get_dirty_log(vcpu->vm, slot, bitmap);
 	kvm_vm_clear_dirty_log(vcpu->vm, slot, bitmap, 0, num_pages);
@@ -298,7 +298,7 @@ static bool dirty_ring_supported(void)
 static void dirty_ring_create_vm_done(struct kvm_vm *vm)
 {
 	u64 pages;
-	uint32_t limit;
+	u32 limit;
 
 	/*
 	 * We rely on vcpu exit due to full dirty ring state. Adjust
@@ -333,12 +333,12 @@ static inline void dirty_gfn_set_collected(struct kvm_dirty_gfn *gfn)
 	smp_store_release(&gfn->flags, KVM_DIRTY_GFN_F_RESET);
 }
 
-static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
-				       int slot, void *bitmap,
-				       uint32_t num_pages, uint32_t *fetch_index)
+static u32 dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
+				  int slot, void *bitmap,
+				  u32 num_pages, u32 *fetch_index)
 {
 	struct kvm_dirty_gfn *cur;
-	uint32_t count = 0;
+	u32 count = 0;
 
 	while (true) {
 		cur = &dirty_gfns[*fetch_index % test_dirty_ring_count];
@@ -359,10 +359,10 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 }
 
 static void dirty_ring_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
-					   void *bitmap, uint32_t num_pages,
-					   uint32_t *ring_buf_idx)
+					   void *bitmap, u32 num_pages,
+					   u32 *ring_buf_idx)
 {
-	uint32_t count, cleared;
+	u32 count, cleared;
 
 	/* Only have one vcpu */
 	count = dirty_ring_collect_one(vcpu_map_dirty_ring(vcpu),
@@ -404,8 +404,8 @@ struct log_mode {
 	void (*create_vm_done)(struct kvm_vm *vm);
 	/* Hook to collect the dirty pages into the bitmap provided */
 	void (*collect_dirty_pages) (struct kvm_vcpu *vcpu, int slot,
-				     void *bitmap, uint32_t num_pages,
-				     uint32_t *ring_buf_idx);
+				     void *bitmap, u32 num_pages,
+				     u32 *ring_buf_idx);
 	/* Hook to call when after each vcpu run */
 	void (*after_vcpu_run)(struct kvm_vcpu *vcpu);
 } log_modes[LOG_MODE_NUM] = {
@@ -459,8 +459,8 @@ static void log_mode_create_vm_done(struct kvm_vm *vm)
 }
 
 static void log_mode_collect_dirty_pages(struct kvm_vcpu *vcpu, int slot,
-					 void *bitmap, uint32_t num_pages,
-					 uint32_t *ring_buf_idx)
+					 void *bitmap, u32 num_pages,
+					 u32 *ring_buf_idx)
 {
 	struct log_mode *mode = &log_modes[host_log_mode];
 
@@ -601,7 +601,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	unsigned long *bmap[2];
-	uint32_t ring_buf_idx = 0;
+	u32 ring_buf_idx = 0;
 	int sem_val;
 
 	if (!log_mode_supported()) {
diff --git a/tools/testing/selftests/kvm/guest_print_test.c b/tools/testing/selftests/kvm/guest_print_test.c
index b059abcf1a5b..79d3fc326e91 100644
--- a/tools/testing/selftests/kvm/guest_print_test.c
+++ b/tools/testing/selftests/kvm/guest_print_test.c
@@ -29,9 +29,9 @@ TYPE(test_type_i64,  I64,  "%ld",   s64)		\
 TYPE(test_type_u64,  U64u, "%lu",   u64)		\
 TYPE(test_type_x64,  U64x, "0x%lx", u64)		\
 TYPE(test_type_X64,  U64X, "0x%lX", u64)		\
-TYPE(test_type_u32,  U32u, "%u",    uint32_t)		\
-TYPE(test_type_x32,  U32x, "0x%x",  uint32_t)		\
-TYPE(test_type_X32,  U32X, "0x%X",  uint32_t)		\
+TYPE(test_type_u32,  U32u, "%u",    u32)		\
+TYPE(test_type_x32,  U32x, "0x%x",  u32)		\
+TYPE(test_type_X32,  U32X, "0x%X",  u32)		\
 TYPE(test_type_int,  INT,  "%d",    int)		\
 TYPE(test_type_char, CHAR, "%c",    char)		\
 TYPE(test_type_str,  STR,  "'%s'",  const char *)	\
diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index 94bd6ed24cf3..3147f5c97e94 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -80,7 +80,7 @@ static inline void check_join(pthread_t thread, void **retval)
 	TEST_ASSERT(r == 0, "%s: failed to join thread", __func__);
 }
 
-static void run_test(uint32_t run)
+static void run_test(u32 run)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -88,7 +88,7 @@ static void run_test(uint32_t run)
 	pthread_t threads[VCPU_NUM];
 	pthread_t throw_away;
 	void *b;
-	uint32_t i, j;
+	u32 i, j;
 
 	CPU_ZERO(&cpu_set);
 	for (i = 0; i < VCPU_NUM; i++)
@@ -149,7 +149,7 @@ void wait_for_child_setup(pid_t pid)
 
 int main(int argc, char **argv)
 {
-	uint32_t i;
+	u32 i;
 	int s, r;
 	pid_t pid;
 
diff --git a/tools/testing/selftests/kvm/include/arm64/arch_timer.h b/tools/testing/selftests/kvm/include/arm64/arch_timer.h
index 290b65e58d3c..4fe0e0d07584 100644
--- a/tools/testing/selftests/kvm/include/arm64/arch_timer.h
+++ b/tools/testing/selftests/kvm/include/arm64/arch_timer.h
@@ -26,7 +26,7 @@ enum arch_timer {
 #define cycles_to_usec(cycles) \
 	((u64)(cycles) * 1000000 / timer_get_cntfrq())
 
-static inline uint32_t timer_get_cntfrq(void)
+static inline u32 timer_get_cntfrq(void)
 {
 	return read_sysreg(cntfrq_el0);
 }
@@ -111,7 +111,7 @@ static inline int32_t timer_get_tval(enum arch_timer timer)
 	return 0;
 }
 
-static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
+static inline void timer_set_ctl(enum arch_timer timer, u32 ctl)
 {
 	switch (timer) {
 	case VIRTUAL:
@@ -127,7 +127,7 @@ static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
 	isb();
 }
 
-static inline uint32_t timer_get_ctl(enum arch_timer timer)
+static inline u32 timer_get_ctl(enum arch_timer timer)
 {
 	switch (timer) {
 	case VIRTUAL:
@@ -142,7 +142,7 @@ static inline uint32_t timer_get_ctl(enum arch_timer timer)
 	return 0;
 }
 
-static inline void timer_set_next_cval_ms(enum arch_timer timer, uint32_t msec)
+static inline void timer_set_next_cval_ms(enum arch_timer timer, u32 msec)
 {
 	u64 now_ct = timer_get_cntct(timer);
 	u64 next_ct = now_ct + msec_to_cycles(msec);
@@ -150,7 +150,7 @@ static inline void timer_set_next_cval_ms(enum arch_timer timer, uint32_t msec)
 	timer_set_cval(timer, next_ct);
 }
 
-static inline void timer_set_next_tval_ms(enum arch_timer timer, uint32_t msec)
+static inline void timer_set_next_tval_ms(enum arch_timer timer, u32 msec)
 {
 	timer_set_tval(timer, msec_to_cycles(msec));
 }
diff --git a/tools/testing/selftests/kvm/include/arm64/gic.h b/tools/testing/selftests/kvm/include/arm64/gic.h
index c36a4eafeb5a..615745093c98 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic.h
@@ -49,7 +49,7 @@ void gic_set_dir(unsigned int intid);
  */
 void gic_set_eoi_split(bool split);
 void gic_set_priority_mask(u64 mask);
-void gic_set_priority(uint32_t intid, uint32_t prio);
+void gic_set_priority(u32 intid, u32 prio);
 void gic_irq_set_active(unsigned int intid);
 void gic_irq_clear_active(unsigned int intid);
 bool gic_irq_get_active(unsigned int intid);
diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index 618d112cb08a..b8a902ba8573 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -128,7 +128,7 @@
 #define PTE_ADDR_51_50_LPA2_SHIFT	8
 
 void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init);
-struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, u32 vcpu_id,
 				  struct kvm_vcpu_init *init, void *guest_code);
 
 struct ex_regs {
@@ -167,8 +167,8 @@ enum {
 			   (v) == VECTOR_SYNC_LOWER_64    || \
 			   (v) == VECTOR_SYNC_LOWER_32)
 
-void aarch64_get_supported_page_sizes(uint32_t ipa, uint32_t *ipa4k,
-					uint32_t *ipa16k, uint32_t *ipa64k);
+void aarch64_get_supported_page_sizes(u32 ipa, u32 *ipa4k,
+				      u32 *ipa16k, u32 *ipa64k);
 
 void vm_init_descriptor_tables(struct kvm_vm *vm);
 void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu);
@@ -287,7 +287,7 @@ struct arm_smccc_res {
  * @res: pointer to write the return values from registers x0-x3
  *
  */
-void smccc_hvc(uint32_t function_id, u64 arg0, u64 arg1,
+void smccc_hvc(u32 function_id, u64 arg0, u64 arg1,
 	       u64 arg2, u64 arg3, u64 arg4, u64 arg5,
 	       u64 arg6, struct arm_smccc_res *res);
 
@@ -298,7 +298,7 @@ void smccc_hvc(uint32_t function_id, u64 arg0, u64 arg1,
  * @res: pointer to write the return values from registers x0-x3
  *
  */
-void smccc_smc(uint32_t function_id, u64 arg0, u64 arg1,
+void smccc_smc(u32 function_id, u64 arg0, u64 arg1,
 	       u64 arg2, u64 arg3, u64 arg4, u64 arg5,
 	       u64 arg6, struct arm_smccc_res *res);
 
diff --git a/tools/testing/selftests/kvm/include/arm64/vgic.h b/tools/testing/selftests/kvm/include/arm64/vgic.h
index 2fde1fd8f96a..1f8b04373987 100644
--- a/tools/testing/selftests/kvm/include/arm64/vgic.h
+++ b/tools/testing/selftests/kvm/include/arm64/vgic.h
@@ -17,21 +17,21 @@
 	index)
 
 bool kvm_supports_vgic_v3(void);
-int __vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs);
+int __vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, u32 nr_irqs);
 void __vgic_v3_init(int fd);
-int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs);
+int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, u32 nr_irqs);
 
 #define VGIC_MAX_RESERVED	1023
 
-void kvm_irq_set_level_info(int gic_fd, uint32_t intid, int level);
-int _kvm_irq_set_level_info(int gic_fd, uint32_t intid, int level);
+void kvm_irq_set_level_info(int gic_fd, u32 intid, int level);
+int _kvm_irq_set_level_info(int gic_fd, u32 intid, int level);
 
-void kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level);
-int _kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level);
+void kvm_arm_irq_line(struct kvm_vm *vm, u32 intid, int level);
+int _kvm_arm_irq_line(struct kvm_vm *vm, u32 intid, int level);
 
 /* The vcpu arg only applies to private interrupts. */
-void kvm_irq_write_ispendr(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu);
-void kvm_irq_write_isactiver(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu);
+void kvm_irq_write_ispendr(int gic_fd, u32 intid, struct kvm_vcpu *vcpu);
+void kvm_irq_write_isactiver(int gic_fd, u32 intid, struct kvm_vcpu *vcpu);
 
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
 
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index e03fa4d1dbbf..e928673dafd2 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -58,7 +58,7 @@ struct kvm_binary_stats {
 
 struct kvm_vcpu {
 	struct list_head list;
-	uint32_t id;
+	u32 id;
 	int fd;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
@@ -70,8 +70,8 @@ struct kvm_vcpu {
 #endif
 	struct kvm_binary_stats stats;
 	struct kvm_dirty_gfn *dirty_gfns;
-	uint32_t fetch_index;
-	uint32_t dirty_gfns_count;
+	u32 fetch_index;
+	u32 dirty_gfns_count;
 };
 
 struct userspace_mem_regions {
@@ -113,7 +113,7 @@ struct kvm_vm {
 	bool has_irqchip;
 	gpa_t ucall_mmio_addr;
 	gva_t handlers;
-	uint32_t dirty_ring_size;
+	u32 dirty_ring_size;
 	u64 gpa_tag_mask;
 
 	/*
@@ -132,7 +132,7 @@ struct kvm_vm {
 	 * allocators, e.g., lib/elf uses the memslots[MEM_REGION_CODE]
 	 * memslot.
 	 */
-	uint32_t memslots[NR_MEM_REGIONS];
+	u32 memslots[NR_MEM_REGIONS];
 };
 
 struct vcpu_reg_sublist {
@@ -164,7 +164,7 @@ struct vcpu_reg_list {
 		else
 
 struct userspace_mem_region *
-memslot2region(struct kvm_vm *vm, uint32_t memslot);
+memslot2region(struct kvm_vm *vm, u32 memslot);
 
 static inline struct userspace_mem_region *vm_get_mem_region(struct kvm_vm *vm,
 							     enum kvm_mem_region_type type)
@@ -213,7 +213,7 @@ enum vm_guest_mode {
 };
 
 struct vm_shape {
-	uint32_t type;
+	u32 type;
 	uint8_t  mode;
 	uint8_t  pad0;
 	uint16_t pad1;
@@ -404,14 +404,14 @@ static inline int vm_check_cap(struct kvm_vm *vm, long cap)
 	return ret;
 }
 
-static inline int __vm_enable_cap(struct kvm_vm *vm, uint32_t cap, u64 arg0)
+static inline int __vm_enable_cap(struct kvm_vm *vm, u32 cap, u64 arg0)
 {
 	struct kvm_enable_cap enable_cap = { .cap = cap, .args = { arg0 } };
 
 	return __vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
 }
 
-static inline void vm_enable_cap(struct kvm_vm *vm, uint32_t cap, u64 arg0)
+static inline void vm_enable_cap(struct kvm_vm *vm, u32 cap, u64 arg0)
 {
 	struct kvm_enable_cap enable_cap = { .cap = cap, .args = { arg0 } };
 
@@ -466,8 +466,8 @@ static inline void vm_guest_mem_allocate(struct kvm_vm *vm, u64 gpa,
 	vm_guest_mem_fallocate(vm, gpa, size, false);
 }
 
-void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
-const char *vm_guest_mode_string(uint32_t i);
+void vm_enable_dirty_ring(struct kvm_vm *vm, u32 ring_size);
+const char *vm_guest_mode_string(u32 i);
 
 void kvm_vm_free(struct kvm_vm *vmp);
 void kvm_vm_restart(struct kvm_vm *vmp);
@@ -485,7 +485,7 @@ static inline void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log)
 }
 
 static inline void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
-					  u64 first_page, uint32_t num_pages)
+					  u64 first_page, u32 num_pages)
 {
 	struct kvm_clear_dirty_log args = {
 		.dirty_bitmap = log,
@@ -497,7 +497,7 @@ static inline void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log
 	vm_ioctl(vm, KVM_CLEAR_DIRTY_LOG, &args);
 }
 
-static inline uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm)
+static inline u32 kvm_vm_reset_dirty_ring(struct kvm_vm *vm)
 {
 	return __vm_ioctl(vm, KVM_RESET_DIRTY_RINGS, NULL);
 }
@@ -536,8 +536,8 @@ static inline int vm_get_stats_fd(struct kvm_vm *vm)
 	return fd;
 }
 
-static inline int __kvm_irqfd(struct kvm_vm *vm, uint32_t gsi, int eventfd,
-			      uint32_t flags)
+static inline int __kvm_irqfd(struct kvm_vm *vm, u32 gsi, int eventfd,
+			      u32 flags)
 {
 	struct kvm_irqfd irqfd = {
 		.fd = eventfd,
@@ -549,20 +549,19 @@ static inline int __kvm_irqfd(struct kvm_vm *vm, uint32_t gsi, int eventfd,
 	return __vm_ioctl(vm, KVM_IRQFD, &irqfd);
 }
 
-static inline void kvm_irqfd(struct kvm_vm *vm, uint32_t gsi, int eventfd,
-			      uint32_t flags)
+static inline void kvm_irqfd(struct kvm_vm *vm, u32 gsi, int eventfd, u32 flags)
 {
 	int ret = __kvm_irqfd(vm, gsi, eventfd, flags);
 
 	TEST_ASSERT_VM_VCPU_IOCTL(!ret, KVM_IRQFD, ret, vm);
 }
 
-static inline void kvm_assign_irqfd(struct kvm_vm *vm, uint32_t gsi, int eventfd)
+static inline void kvm_assign_irqfd(struct kvm_vm *vm, u32 gsi, int eventfd)
 {
 	kvm_irqfd(vm, gsi, eventfd, 0);
 }
 
-static inline void kvm_deassign_irqfd(struct kvm_vm *vm, uint32_t gsi, int eventfd)
+static inline void kvm_deassign_irqfd(struct kvm_vm *vm, u32 gsi, int eventfd)
 {
 	kvm_irqfd(vm, gsi, eventfd, KVM_IRQFD_FLAG_DEASSIGN);
 }
@@ -685,23 +684,23 @@ static inline int vm_create_guest_memfd(struct kvm_vm *vm, u64 size,
 	return fd;
 }
 
-void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+void vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
 			       u64 gpa, u64 size, void *hva);
-int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+int __vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
 				u64 gpa, u64 size, void *hva);
-void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 				u64 gpa, u64 size, void *hva,
-				uint32_t guest_memfd, u64 guest_memfd_offset);
-int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+				u32 guest_memfd, u64 guest_memfd_offset);
+int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 				 u64 gpa, u64 size, void *hva,
-				 uint32_t guest_memfd, u64 guest_memfd_offset);
+				 u32 guest_memfd, u64 guest_memfd_offset);
 
 void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 enum vm_mem_backing_src_type src_type,
-				 u64 gpa, uint32_t slot, u64 npages,
-				 uint32_t flags);
+				 u64 gpa, u32 slot, u64 npages,
+				 u32 flags);
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
-		u64 gpa, uint32_t slot, u64 npages, uint32_t flags,
+		u64 gpa, u32 slot, u64 npages, u32 flags,
 		int guest_memfd_fd, u64 guest_memfd_offset);
 
 #ifndef vm_arch_has_protected_memory
@@ -711,11 +710,11 @@ static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
 }
 #endif
 
-void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
-void vm_mem_region_reload(struct kvm_vm *vm, uint32_t slot);
-void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, u64 new_gpa);
-void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
-struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
+void vm_mem_region_set_flags(struct kvm_vm *vm, u32 slot, u32 flags);
+void vm_mem_region_reload(struct kvm_vm *vm, u32 slot);
+void vm_mem_region_move(struct kvm_vm *vm, u32 slot, u64 new_gpa);
+void vm_mem_region_delete(struct kvm_vm *vm, u32 slot);
+struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, u32 vcpu_id);
 void vm_populate_vaddr_bitmap(struct kvm_vm *vm);
 gva_t gva_unused_gap(struct kvm_vm *vm, size_t sz, gva_t vaddr_min);
 gva_t gva_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min);
@@ -756,7 +755,7 @@ static inline int __vcpu_run(struct kvm_vcpu *vcpu)
 void vcpu_run_complete_io(struct kvm_vcpu *vcpu);
 struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vcpu *vcpu);
 
-static inline void vcpu_enable_cap(struct kvm_vcpu *vcpu, uint32_t cap,
+static inline void vcpu_enable_cap(struct kvm_vcpu *vcpu, u32 cap,
 				   u64 arg0)
 {
 	struct kvm_enable_cap enable_cap = { .cap = cap, .args = { arg0 } };
@@ -884,18 +883,18 @@ static inline int vcpu_get_stats_fd(struct kvm_vcpu *vcpu)
 	return fd;
 }
 
-int __kvm_has_device_attr(int dev_fd, uint32_t group, u64 attr);
+int __kvm_has_device_attr(int dev_fd, u32 group, u64 attr);
 
-static inline void kvm_has_device_attr(int dev_fd, uint32_t group, u64 attr)
+static inline void kvm_has_device_attr(int dev_fd, u32 group, u64 attr)
 {
 	int ret = __kvm_has_device_attr(dev_fd, group, attr);
 
 	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
 }
 
-int __kvm_device_attr_get(int dev_fd, uint32_t group, u64 attr, void *val);
+int __kvm_device_attr_get(int dev_fd, u32 group, u64 attr, void *val);
 
-static inline void kvm_device_attr_get(int dev_fd, uint32_t group,
+static inline void kvm_device_attr_get(int dev_fd, u32 group,
 				       u64 attr, void *val)
 {
 	int ret = __kvm_device_attr_get(dev_fd, group, attr, val);
@@ -903,9 +902,9 @@ static inline void kvm_device_attr_get(int dev_fd, uint32_t group,
 	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_GET_DEVICE_ATTR, ret));
 }
 
-int __kvm_device_attr_set(int dev_fd, uint32_t group, u64 attr, void *val);
+int __kvm_device_attr_set(int dev_fd, u32 group, u64 attr, void *val);
 
-static inline void kvm_device_attr_set(int dev_fd, uint32_t group,
+static inline void kvm_device_attr_set(int dev_fd, u32 group,
 				       u64 attr, void *val)
 {
 	int ret = __kvm_device_attr_set(dev_fd, group, attr, val);
@@ -913,37 +912,37 @@ static inline void kvm_device_attr_set(int dev_fd, uint32_t group,
 	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
 }
 
-static inline int __vcpu_has_device_attr(struct kvm_vcpu *vcpu, uint32_t group,
+static inline int __vcpu_has_device_attr(struct kvm_vcpu *vcpu, u32 group,
 					 u64 attr)
 {
 	return __kvm_has_device_attr(vcpu->fd, group, attr);
 }
 
-static inline void vcpu_has_device_attr(struct kvm_vcpu *vcpu, uint32_t group,
+static inline void vcpu_has_device_attr(struct kvm_vcpu *vcpu, u32 group,
 					u64 attr)
 {
 	kvm_has_device_attr(vcpu->fd, group, attr);
 }
 
-static inline int __vcpu_device_attr_get(struct kvm_vcpu *vcpu, uint32_t group,
+static inline int __vcpu_device_attr_get(struct kvm_vcpu *vcpu, u32 group,
 					 u64 attr, void *val)
 {
 	return __kvm_device_attr_get(vcpu->fd, group, attr, val);
 }
 
-static inline void vcpu_device_attr_get(struct kvm_vcpu *vcpu, uint32_t group,
+static inline void vcpu_device_attr_get(struct kvm_vcpu *vcpu, u32 group,
 					u64 attr, void *val)
 {
 	kvm_device_attr_get(vcpu->fd, group, attr, val);
 }
 
-static inline int __vcpu_device_attr_set(struct kvm_vcpu *vcpu, uint32_t group,
+static inline int __vcpu_device_attr_set(struct kvm_vcpu *vcpu, u32 group,
 					 u64 attr, void *val)
 {
 	return __kvm_device_attr_set(vcpu->fd, group, attr, val);
 }
 
-static inline void vcpu_device_attr_set(struct kvm_vcpu *vcpu, uint32_t group,
+static inline void vcpu_device_attr_set(struct kvm_vcpu *vcpu, u32 group,
 					u64 attr, void *val)
 {
 	kvm_device_attr_set(vcpu->fd, group, attr, val);
@@ -981,27 +980,27 @@ void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu);
  */
 void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...);
 
-void kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level);
-int _kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level);
+void kvm_irq_line(struct kvm_vm *vm, u32 irq, int level);
+int _kvm_irq_line(struct kvm_vm *vm, u32 irq, int level);
 
 #define KVM_MAX_IRQ_ROUTES		4096
 
 struct kvm_irq_routing *kvm_gsi_routing_create(void);
 void kvm_gsi_routing_irqchip_add(struct kvm_irq_routing *routing,
-		uint32_t gsi, uint32_t pin);
+		u32 gsi, u32 pin);
 int _kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing);
 void kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing);
 
 const char *exit_reason_str(unsigned int exit_reason);
 
-gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t paddr_min, uint32_t memslot);
+gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t paddr_min, u32 memslot);
 gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			   gpa_t paddr_min, uint32_t memslot,
+			   gpa_t paddr_min, u32 memslot,
 			   bool protected);
 gpa_t vm_alloc_page_table(struct kvm_vm *vm);
 
 static inline gpa_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-				       gpa_t paddr_min, uint32_t memslot)
+				       gpa_t paddr_min, u32 memslot)
 {
 	/*
 	 * By default, allocate memory as protected for VMs that support
@@ -1019,7 +1018,7 @@ static inline gpa_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
  * calculate the amount of memory needed for per-vCPU data, e.g. stacks.
  */
 struct kvm_vm *____vm_create(struct vm_shape shape);
-struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
+struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
 			   u64 nr_extra_pages);
 
 static inline struct kvm_vm *vm_create_barebones(void)
@@ -1037,16 +1036,16 @@ static inline struct kvm_vm *vm_create_barebones_type(unsigned long type)
 	return ____vm_create(shape);
 }
 
-static inline struct kvm_vm *vm_create(uint32_t nr_runnable_vcpus)
+static inline struct kvm_vm *vm_create(u32 nr_runnable_vcpus)
 {
 	return __vm_create(VM_SHAPE_DEFAULT, nr_runnable_vcpus, 0);
 }
 
-struct kvm_vm *__vm_create_with_vcpus(struct vm_shape shape, uint32_t nr_vcpus,
+struct kvm_vm *__vm_create_with_vcpus(struct vm_shape shape, u32 nr_vcpus,
 				      u64 extra_mem_pages,
 				      void *guest_code, struct kvm_vcpu *vcpus[]);
 
-static inline struct kvm_vm *vm_create_with_vcpus(uint32_t nr_vcpus,
+static inline struct kvm_vm *vm_create_with_vcpus(u32 nr_vcpus,
 						  void *guest_code,
 						  struct kvm_vcpu *vcpus[])
 {
@@ -1087,7 +1086,7 @@ static inline struct kvm_vm *vm_create_shape_with_one_vcpu(struct vm_shape shape
 
 struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
 
-void kvm_set_files_rlimit(uint32_t nr_vcpus);
+void kvm_set_files_rlimit(u32 nr_vcpus);
 
 int __pin_task_to_cpu(pthread_t task, int cpu);
 
@@ -1118,7 +1117,7 @@ static inline int pin_self_to_any_cpu(void)
 }
 
 void kvm_print_vcpu_pinning_help(void);
-void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
+void kvm_parse_vcpu_pinning(const char *pcpus_string, u32 vcpu_to_pcpu[],
 			    int nr_vcpus);
 
 unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
@@ -1178,10 +1177,10 @@ static inline void vcpu_dump(FILE *stream, struct kvm_vcpu *vcpu,
  *   vm - Virtual Machine
  *   vcpu_id - The id of the VCPU to add to the VM.
  */
-struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id);
 void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code);
 
-static inline struct kvm_vcpu *vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+static inline struct kvm_vcpu *vm_vcpu_add(struct kvm_vm *vm, u32 vcpu_id,
 					   void *guest_code)
 {
 	struct kvm_vcpu *vcpu = vm_arch_vcpu_add(vm, vcpu_id);
@@ -1192,10 +1191,10 @@ static inline struct kvm_vcpu *vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 }
 
 /* Re-create a vCPU after restarting a VM, e.g. for state save/restore tests. */
-struct kvm_vcpu *vm_arch_vcpu_recreate(struct kvm_vm *vm, uint32_t vcpu_id);
+struct kvm_vcpu *vm_arch_vcpu_recreate(struct kvm_vm *vm, u32 vcpu_id);
 
 static inline struct kvm_vcpu *vm_vcpu_recreate(struct kvm_vm *vm,
-						uint32_t vcpu_id)
+						u32 vcpu_id)
 {
 	return vm_arch_vcpu_recreate(vm, vcpu_id);
 }
@@ -1302,7 +1301,7 @@ void kvm_arch_vm_release(struct kvm_vm *vm);
 
 bool vm_is_gpa_protected(struct kvm_vm *vm, gpa_t paddr);
 
-uint32_t guest_get_vcpuid(void);
+u32 guest_get_vcpuid(void);
 
 bool kvm_arch_has_default_irqchip(void);
 
diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
index 71296909302c..e3e4b4d6a27a 100644
--- a/tools/testing/selftests/kvm/include/memstress.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -35,8 +35,8 @@ struct memstress_args {
 	u64 gpa;
 	u64 size;
 	u64 guest_page_size;
-	uint32_t random_seed;
-	uint32_t write_percent;
+	u32 random_seed;
+	u32 write_percent;
 
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
 	bool nested;
@@ -45,7 +45,7 @@ struct memstress_args {
 	/* True if all vCPUs are pinned to pCPUs */
 	bool pin_vcpus;
 	/* The vCPU=>pCPU pinning map. Only valid if pin_vcpus is true. */
-	uint32_t vcpu_to_pcpu[KVM_MAX_VCPUS];
+	u32 vcpu_to_pcpu[KVM_MAX_VCPUS];
 
  	/* Test is done, stop running vCPUs. */
  	bool stop_vcpus;
@@ -61,12 +61,12 @@ struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 				   bool partition_vcpu_memory_access);
 void memstress_destroy_vm(struct kvm_vm *vm);
 
-void memstress_set_write_percent(struct kvm_vm *vm, uint32_t write_percent);
+void memstress_set_write_percent(struct kvm_vm *vm, u32 write_percent);
 void memstress_set_random_access(struct kvm_vm *vm, bool random_access);
 
 void memstress_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct memstress_vcpu_args *));
 void memstress_join_vcpu_threads(int vcpus);
-void memstress_guest_code(uint32_t vcpu_id);
+void memstress_guest_code(u32 vcpu_id);
 
 u64 memstress_nested_pages(int nr_vcpus);
 void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[]);
diff --git a/tools/testing/selftests/kvm/include/riscv/arch_timer.h b/tools/testing/selftests/kvm/include/riscv/arch_timer.h
index 66ed7e36a7cb..28ffc014da2a 100644
--- a/tools/testing/selftests/kvm/include/riscv/arch_timer.h
+++ b/tools/testing/selftests/kvm/include/riscv/arch_timer.h
@@ -47,7 +47,7 @@ static inline void timer_irq_disable(void)
 	csr_clear(CSR_SIE, IE_TIE);
 }
 
-static inline void timer_set_next_cmp_ms(uint32_t msec)
+static inline void timer_set_next_cmp_ms(u32 msec)
 {
 	u64 now_ct = timer_get_cycles();
 	u64 next_ct = now_ct + msec_to_cycles(msec);
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index d7489db738bf..fb24347c6e6c 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -109,14 +109,14 @@ struct timespec timespec_elapsed(struct timespec start);
 struct timespec timespec_div(struct timespec ts, int divisor);
 
 struct guest_random_state {
-	uint32_t seed;
+	u32 seed;
 };
 
-extern uint32_t guest_random_seed;
+extern u32 guest_random_seed;
 extern struct guest_random_state guest_rng;
 
-struct guest_random_state new_guest_random_state(uint32_t seed);
-uint32_t guest_random_u32(struct guest_random_state *state);
+struct guest_random_state new_guest_random_state(u32 seed);
+u32 guest_random_u32(struct guest_random_state *state);
 
 static inline bool __guest_random_bool(struct guest_random_state *state,
 				       uint8_t percent)
@@ -160,7 +160,7 @@ enum vm_mem_backing_src_type {
 
 struct vm_mem_backing_src_alias {
 	const char *name;
-	uint32_t flag;
+	u32 flag;
 };
 
 #define MIN_RUN_DELAY_NS	200000UL
@@ -168,9 +168,9 @@ struct vm_mem_backing_src_alias {
 bool thp_configured(void);
 size_t get_trans_hugepagesz(void);
 size_t get_def_hugetlb_pagesz(void);
-const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(uint32_t i);
-size_t get_backing_src_pagesz(uint32_t i);
-bool is_backing_src_hugetlb(uint32_t i);
+const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(u32 i);
+size_t get_backing_src_pagesz(u32 i);
+bool is_backing_src_hugetlb(u32 i);
 void backing_src_help(const char *flag);
 enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name);
 long get_run_delay(void);
@@ -217,7 +217,7 @@ static inline void *align_ptr_up(void *x, size_t size)
 
 int atoi_paranoid(const char *num_str);
 
-static inline uint32_t atoi_positive(const char *name, const char *num_str)
+static inline u32 atoi_positive(const char *name, const char *num_str)
 {
 	int num = atoi_paranoid(num_str);
 
@@ -225,7 +225,7 @@ static inline uint32_t atoi_positive(const char *name, const char *num_str)
 	return num;
 }
 
-static inline uint32_t atoi_non_negative(const char *name, const char *num_str)
+static inline u32 atoi_non_negative(const char *name, const char *num_str)
 {
 	int num = atoi_paranoid(num_str);
 
diff --git a/tools/testing/selftests/kvm/include/timer_test.h b/tools/testing/selftests/kvm/include/timer_test.h
index 9501c6c825e2..b7d5d2c84701 100644
--- a/tools/testing/selftests/kvm/include/timer_test.h
+++ b/tools/testing/selftests/kvm/include/timer_test.h
@@ -18,11 +18,11 @@
 
 /* Timer test cmdline parameters */
 struct test_args {
-	uint32_t nr_vcpus;
-	uint32_t nr_iter;
-	uint32_t timer_period_ms;
-	uint32_t migration_freq_ms;
-	uint32_t timer_err_margin_us;
+	u32 nr_vcpus;
+	u32 nr_iter;
+	u32 timer_period_ms;
+	u32 migration_freq_ms;
+	u32 timer_err_margin_us;
 	/* Members of struct kvm_arm_counter_offset */
 	u64 counter_offset;
 	u64 reserved;
@@ -30,7 +30,7 @@ struct test_args {
 
 /* Shared variables between host and guest */
 struct test_vcpu_shared_data {
-	uint32_t nr_iter;
+	u32 nr_iter;
 	int guest_stage;
 	u64 xcnt;
 };
diff --git a/tools/testing/selftests/kvm/include/x86/apic.h b/tools/testing/selftests/kvm/include/x86/apic.h
index 05573dedabd3..74eaa3bd335d 100644
--- a/tools/testing/selftests/kvm/include/x86/apic.h
+++ b/tools/testing/selftests/kvm/include/x86/apic.h
@@ -79,19 +79,19 @@ void apic_disable(void);
 void xapic_enable(void);
 void x2apic_enable(void);
 
-static inline uint32_t get_bsp_flag(void)
+static inline u32 get_bsp_flag(void)
 {
 	return rdmsr(MSR_IA32_APICBASE) & MSR_IA32_APICBASE_BSP;
 }
 
-static inline uint32_t xapic_read_reg(unsigned int reg)
+static inline u32 xapic_read_reg(unsigned int reg)
 {
-	return ((volatile uint32_t *)APIC_DEFAULT_GPA)[reg >> 2];
+	return ((volatile u32 *)APIC_DEFAULT_GPA)[reg >> 2];
 }
 
-static inline void xapic_write_reg(unsigned int reg, uint32_t val)
+static inline void xapic_write_reg(unsigned int reg, u32 val)
 {
-	((volatile uint32_t *)APIC_DEFAULT_GPA)[reg >> 2] = val;
+	((volatile u32 *)APIC_DEFAULT_GPA)[reg >> 2] = val;
 }
 
 static inline u64 x2apic_read_reg(unsigned int reg)
diff --git a/tools/testing/selftests/kvm/include/x86/evmcs.h b/tools/testing/selftests/kvm/include/x86/evmcs.h
index 5ec5cca6f9e4..3b0f96b881f9 100644
--- a/tools/testing/selftests/kvm/include/x86/evmcs.h
+++ b/tools/testing/selftests/kvm/include/x86/evmcs.h
@@ -11,7 +11,7 @@
 #include "vmx.h"
 
 #define u16 uint16_t
-#define u32 uint32_t
+#define u32 u32
 #define u64 u64
 
 #define EVMCS_VERSION 1
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 269564c19052..71c43a66be78 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -401,8 +401,8 @@ struct desc64 {
 	uint16_t base0;
 	unsigned base1:8, type:4, s:1, dpl:2, p:1;
 	unsigned limit1:4, avl:1, l:1, db:1, g:1, base2:8;
-	uint32_t base3;
-	uint32_t zero1;
+	u32 base3;
+	u32 zero1;
 } __attribute__((packed));
 
 struct desc_ptr {
@@ -435,7 +435,7 @@ static inline u64 get_desc64_base(const struct desc64 *desc)
 
 static inline u64 rdtsc(void)
 {
-	uint32_t eax, edx;
+	u32 eax, edx;
 	u64 tsc_val;
 	/*
 	 * The lfence is to wait (on Intel CPUs) until all previous
@@ -448,27 +448,27 @@ static inline u64 rdtsc(void)
 	return tsc_val;
 }
 
-static inline u64 rdtscp(uint32_t *aux)
+static inline u64 rdtscp(u32 *aux)
 {
-	uint32_t eax, edx;
+	u32 eax, edx;
 
 	__asm__ __volatile__("rdtscp" : "=a"(eax), "=d"(edx), "=c"(*aux));
 	return ((u64)edx) << 32 | eax;
 }
 
-static inline u64 rdmsr(uint32_t msr)
+static inline u64 rdmsr(u32 msr)
 {
-	uint32_t a, d;
+	u32 a, d;
 
 	__asm__ __volatile__("rdmsr" : "=a"(a), "=d"(d) : "c"(msr) : "memory");
 
 	return a | ((u64)d << 32);
 }
 
-static inline void wrmsr(uint32_t msr, u64 value)
+static inline void wrmsr(u32 msr, u64 value)
 {
-	uint32_t a = value;
-	uint32_t d = value >> 32;
+	u32 a = value;
+	u32 d = value >> 32;
 
 	__asm__ __volatile__("wrmsr" :: "a"(a), "d"(d), "c"(msr) : "memory");
 }
@@ -626,14 +626,14 @@ static inline struct desc_ptr get_idt(void)
 	return idt;
 }
 
-static inline void outl(uint16_t port, uint32_t value)
+static inline void outl(uint16_t port, u32 value)
 {
 	__asm__ __volatile__("outl %%eax, %%dx" : : "d"(port), "a"(value));
 }
 
-static inline void __cpuid(uint32_t function, uint32_t index,
-			   uint32_t *eax, uint32_t *ebx,
-			   uint32_t *ecx, uint32_t *edx)
+static inline void __cpuid(u32 function, u32 index,
+			   u32 *eax, u32 *ebx,
+			   u32 *ecx, u32 *edx)
 {
 	*eax = function;
 	*ecx = index;
@@ -647,35 +647,35 @@ static inline void __cpuid(uint32_t function, uint32_t index,
 	    : "memory");
 }
 
-static inline void cpuid(uint32_t function,
-			 uint32_t *eax, uint32_t *ebx,
-			 uint32_t *ecx, uint32_t *edx)
+static inline void cpuid(u32 function,
+			 u32 *eax, u32 *ebx,
+			 u32 *ecx, u32 *edx)
 {
 	return __cpuid(function, 0, eax, ebx, ecx, edx);
 }
 
-static inline uint32_t this_cpu_fms(void)
+static inline u32 this_cpu_fms(void)
 {
-	uint32_t eax, ebx, ecx, edx;
+	u32 eax, ebx, ecx, edx;
 
 	cpuid(1, &eax, &ebx, &ecx, &edx);
 	return eax;
 }
 
-static inline uint32_t this_cpu_family(void)
+static inline u32 this_cpu_family(void)
 {
 	return x86_family(this_cpu_fms());
 }
 
-static inline uint32_t this_cpu_model(void)
+static inline u32 this_cpu_model(void)
 {
 	return x86_model(this_cpu_fms());
 }
 
 static inline bool this_cpu_vendor_string_is(const char *vendor)
 {
-	const uint32_t *chunk = (const uint32_t *)vendor;
-	uint32_t eax, ebx, ecx, edx;
+	const u32 *chunk = (const u32 *)vendor;
+	u32 eax, ebx, ecx, edx;
 
 	cpuid(0, &eax, &ebx, &ecx, &edx);
 	return (ebx == chunk[0] && edx == chunk[1] && ecx == chunk[2]);
@@ -694,10 +694,10 @@ static inline bool this_cpu_is_amd(void)
 	return this_cpu_vendor_string_is("AuthenticAMD");
 }
 
-static inline uint32_t __this_cpu_has(uint32_t function, uint32_t index,
-				      uint8_t reg, uint8_t lo, uint8_t hi)
+static inline u32 __this_cpu_has(u32 function, u32 index,
+				 uint8_t reg, uint8_t lo, uint8_t hi)
 {
-	uint32_t gprs[4];
+	u32 gprs[4];
 
 	__cpuid(function, index,
 		&gprs[KVM_CPUID_EAX], &gprs[KVM_CPUID_EBX],
@@ -712,7 +712,7 @@ static inline bool this_cpu_has(struct kvm_x86_cpu_feature feature)
 			      feature.reg, feature.bit, feature.bit);
 }
 
-static inline uint32_t this_cpu_property(struct kvm_x86_cpu_property property)
+static inline u32 this_cpu_property(struct kvm_x86_cpu_property property)
 {
 	return __this_cpu_has(property.function, property.index,
 			      property.reg, property.lo_bit, property.hi_bit);
@@ -720,7 +720,7 @@ static inline uint32_t this_cpu_property(struct kvm_x86_cpu_property property)
 
 static __always_inline bool this_cpu_has_p(struct kvm_x86_cpu_property property)
 {
-	uint32_t max_leaf;
+	u32 max_leaf;
 
 	switch (property.function & 0xc0000000) {
 	case 0:
@@ -740,7 +740,7 @@ static __always_inline bool this_cpu_has_p(struct kvm_x86_cpu_property property)
 
 static inline bool this_pmu_has(struct kvm_x86_pmu_feature feature)
 {
-	uint32_t nr_bits;
+	u32 nr_bits;
 
 	if (feature.f.reg == KVM_CPUID_EBX) {
 		nr_bits = this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
@@ -868,7 +868,7 @@ void kvm_x86_state_cleanup(struct kvm_x86_state *state);
 
 const struct kvm_msr_list *kvm_get_msr_index_list(void);
 const struct kvm_msr_list *kvm_get_feature_msr_index_list(void);
-bool kvm_msr_is_in_save_restore_list(uint32_t msr_index);
+bool kvm_msr_is_in_save_restore_list(u32 msr_index);
 u64 kvm_get_feature_msr(u64 msr_index);
 
 static inline void vcpu_msrs_get(struct kvm_vcpu *vcpu,
@@ -924,20 +924,20 @@ static inline void vcpu_xcrs_set(struct kvm_vcpu *vcpu, struct kvm_xcrs *xcrs)
 }
 
 const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
-					       uint32_t function, uint32_t index);
+					       u32 function, u32 index);
 const struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
 
-static inline uint32_t kvm_cpu_fms(void)
+static inline u32 kvm_cpu_fms(void)
 {
 	return get_cpuid_entry(kvm_get_supported_cpuid(), 0x1, 0)->eax;
 }
 
-static inline uint32_t kvm_cpu_family(void)
+static inline u32 kvm_cpu_family(void)
 {
 	return x86_family(kvm_cpu_fms());
 }
 
-static inline uint32_t kvm_cpu_model(void)
+static inline u32 kvm_cpu_model(void)
 {
 	return x86_model(kvm_cpu_fms());
 }
@@ -950,17 +950,17 @@ static inline bool kvm_cpu_has(struct kvm_x86_cpu_feature feature)
 	return kvm_cpuid_has(kvm_get_supported_cpuid(), feature);
 }
 
-uint32_t kvm_cpuid_property(const struct kvm_cpuid2 *cpuid,
-			    struct kvm_x86_cpu_property property);
+u32 kvm_cpuid_property(const struct kvm_cpuid2 *cpuid,
+		       struct kvm_x86_cpu_property property);
 
-static inline uint32_t kvm_cpu_property(struct kvm_x86_cpu_property property)
+static inline u32 kvm_cpu_property(struct kvm_x86_cpu_property property)
 {
 	return kvm_cpuid_property(kvm_get_supported_cpuid(), property);
 }
 
 static __always_inline bool kvm_cpu_has_p(struct kvm_x86_cpu_property property)
 {
-	uint32_t max_leaf;
+	u32 max_leaf;
 
 	switch (property.function & 0xc0000000) {
 	case 0:
@@ -980,7 +980,7 @@ static __always_inline bool kvm_cpu_has_p(struct kvm_x86_cpu_property property)
 
 static inline bool kvm_pmu_has(struct kvm_x86_pmu_feature feature)
 {
-	uint32_t nr_bits;
+	u32 nr_bits;
 
 	if (feature.f.reg == KVM_CPUID_EBX) {
 		nr_bits = kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
@@ -1032,8 +1032,8 @@ static inline void vcpu_get_cpuid(struct kvm_vcpu *vcpu)
 }
 
 static inline struct kvm_cpuid_entry2 *__vcpu_get_cpuid_entry(struct kvm_vcpu *vcpu,
-							      uint32_t function,
-							      uint32_t index)
+							      u32 function,
+							      u32 index)
 {
 	TEST_ASSERT(vcpu->cpuid, "Must do vcpu_init_cpuid() first (or equivalent)");
 
@@ -1044,7 +1044,7 @@ static inline struct kvm_cpuid_entry2 *__vcpu_get_cpuid_entry(struct kvm_vcpu *v
 }
 
 static inline struct kvm_cpuid_entry2 *vcpu_get_cpuid_entry(struct kvm_vcpu *vcpu,
-							    uint32_t function)
+							    u32 function)
 {
 	return __vcpu_get_cpuid_entry(vcpu, function, 0);
 }
@@ -1074,10 +1074,10 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 
 void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
 			     struct kvm_x86_cpu_property property,
-			     uint32_t value);
+			     u32 value);
 void vcpu_set_cpuid_maxphyaddr(struct kvm_vcpu *vcpu, uint8_t maxphyaddr);
 
-void vcpu_clear_cpuid_entry(struct kvm_vcpu *vcpu, uint32_t function);
+void vcpu_clear_cpuid_entry(struct kvm_vcpu *vcpu, u32 function);
 
 static inline bool vcpu_cpuid_has(struct kvm_vcpu *vcpu,
 				  struct kvm_x86_cpu_feature feature)
@@ -1131,7 +1131,7 @@ do {										\
  * is changing, etc.  This is NOT an exhaustive list!  The intent is to filter
  * out MSRs that are not durable _and_ that a selftest wants to write.
  */
-static inline bool is_durable_msr(uint32_t msr)
+static inline bool is_durable_msr(u32 msr)
 {
 	return msr != MSR_IA32_TSC;
 }
@@ -1173,7 +1173,7 @@ struct idt_entry {
 	uint16_t dpl : 2;
 	uint16_t p : 1;
 	uint16_t offset1;
-	uint32_t offset2; uint32_t reserved;
+	u32 offset2; u32 reserved;
 };
 
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
@@ -1277,11 +1277,11 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 })
 
 #define BUILD_READ_U64_SAFE_HELPER(insn, _fep, _FEP)			\
-static inline uint8_t insn##_safe ##_fep(uint32_t idx, u64 *val)	\
+static inline uint8_t insn##_safe ##_fep(u32 idx, u64 *val)	\
 {									\
 	u64 error_code;						\
 	uint8_t vector;							\
-	uint32_t a, d;							\
+	u32 a, d;							\
 									\
 	asm volatile(KVM_ASM_SAFE##_FEP(#insn)				\
 		     : "=a"(a), "=d"(d),				\
@@ -1305,12 +1305,12 @@ BUILD_READ_U64_SAFE_HELPERS(rdmsr)
 BUILD_READ_U64_SAFE_HELPERS(rdpmc)
 BUILD_READ_U64_SAFE_HELPERS(xgetbv)
 
-static inline uint8_t wrmsr_safe(uint32_t msr, u64 val)
+static inline uint8_t wrmsr_safe(u32 msr, u64 val)
 {
 	return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
 }
 
-static inline uint8_t xsetbv_safe(uint32_t index, u64 value)
+static inline uint8_t xsetbv_safe(u32 index, u64 value)
 {
 	u32 eax = value;
 	u32 edx = value >> 32;
diff --git a/tools/testing/selftests/kvm/include/x86/sev.h b/tools/testing/selftests/kvm/include/x86/sev.h
index f65e3361c7c0..4f91c1179416 100644
--- a/tools/testing/selftests/kvm/include/x86/sev.h
+++ b/tools/testing/selftests/kvm/include/x86/sev.h
@@ -46,14 +46,14 @@ static inline bool is_sev_vm(struct kvm_vm *vm)
 	return is_sev_es_vm(vm) || vm->type == KVM_X86_SEV_VM;
 }
 
-void sev_vm_launch(struct kvm_vm *vm, uint32_t policy);
+void sev_vm_launch(struct kvm_vm *vm, u32 policy);
 void sev_vm_launch_measure(struct kvm_vm *vm, uint8_t *measurement);
 void sev_vm_launch_finish(struct kvm_vm *vm);
 void snp_vm_launch_start(struct kvm_vm *vm, u64 policy);
 void snp_vm_launch_update(struct kvm_vm *vm);
 void snp_vm_launch_finish(struct kvm_vm *vm);
 
-struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t type, void *guest_code,
+struct kvm_vm *vm_sev_create_with_one_vcpu(u32 type, void *guest_code,
 					   struct kvm_vcpu **cpu);
 void vm_sev_launch(struct kvm_vm *vm, u64 policy, uint8_t *measurement);
 
diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 5e9810fb9d20..6cd6bb7efbc2 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -285,8 +285,8 @@ enum vmcs_field {
 };
 
 struct vmx_msr_entry {
-	uint32_t index;
-	uint32_t reserved;
+	u32 index;
+	u32 reserved;
 	u64 value;
 } __attribute__ ((aligned(16)));
 
@@ -490,7 +490,7 @@ static inline int vmwrite(u64 encoding, u64 value)
 	return ret;
 }
 
-static inline uint32_t vmcs_revision(void)
+static inline u32 vmcs_revision(void)
 {
 	return rdmsr(MSR_IA32_VMX_BASIC);
 }
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index dcd213733604..da3d9e8a0735 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -63,7 +63,7 @@ struct test_args {
 static enum test_stage guest_test_stage;
 
 /* Host variables */
-static uint32_t nr_vcpus = 1;
+static u32 nr_vcpus = 1;
 static struct test_args test_args;
 static enum test_stage *current_stage;
 static bool host_quit;
diff --git a/tools/testing/selftests/kvm/lib/arm64/gic.c b/tools/testing/selftests/kvm/lib/arm64/gic.c
index 3b0aa4eff557..011dfe1dfcb3 100644
--- a/tools/testing/selftests/kvm/lib/arm64/gic.c
+++ b/tools/testing/selftests/kvm/lib/arm64/gic.c
@@ -50,7 +50,7 @@ static void gic_dist_init(enum gic_type type, unsigned int nr_cpus)
 
 void gic_init(enum gic_type type, unsigned int nr_cpus)
 {
-	uint32_t cpu = guest_get_vcpuid();
+	u32 cpu = guest_get_vcpuid();
 
 	GUEST_ASSERT(type < GIC_TYPE_MAX);
 	GUEST_ASSERT(nr_cpus);
diff --git a/tools/testing/selftests/kvm/lib/arm64/gic_private.h b/tools/testing/selftests/kvm/lib/arm64/gic_private.h
index 4ccc72533b35..6d393f5c5685 100644
--- a/tools/testing/selftests/kvm/lib/arm64/gic_private.h
+++ b/tools/testing/selftests/kvm/lib/arm64/gic_private.h
@@ -13,19 +13,19 @@ struct gic_common_ops {
 	void (*gic_irq_enable)(unsigned int intid);
 	void (*gic_irq_disable)(unsigned int intid);
 	u64 (*gic_read_iar)(void);
-	void (*gic_write_eoir)(uint32_t irq);
-	void (*gic_write_dir)(uint32_t irq);
+	void (*gic_write_eoir)(u32 irq);
+	void (*gic_write_dir)(u32 irq);
 	void (*gic_set_eoi_split)(bool split);
 	void (*gic_set_priority_mask)(u64 mask);
-	void (*gic_set_priority)(uint32_t intid, uint32_t prio);
-	void (*gic_irq_set_active)(uint32_t intid);
-	void (*gic_irq_clear_active)(uint32_t intid);
-	bool (*gic_irq_get_active)(uint32_t intid);
-	void (*gic_irq_set_pending)(uint32_t intid);
-	void (*gic_irq_clear_pending)(uint32_t intid);
-	bool (*gic_irq_get_pending)(uint32_t intid);
-	void (*gic_irq_set_config)(uint32_t intid, bool is_edge);
-	void (*gic_irq_set_group)(uint32_t intid, bool group);
+	void (*gic_set_priority)(u32 intid, u32 prio);
+	void (*gic_irq_set_active)(u32 intid);
+	void (*gic_irq_clear_active)(u32 intid);
+	bool (*gic_irq_get_active)(u32 intid);
+	void (*gic_irq_set_pending)(u32 intid);
+	void (*gic_irq_clear_pending)(u32 intid);
+	bool (*gic_irq_get_pending)(u32 intid);
+	void (*gic_irq_set_config)(u32 intid, bool is_edge);
+	void (*gic_irq_set_group)(u32 intid, bool group);
 };
 
 extern const struct gic_common_ops gicv3_ops;
diff --git a/tools/testing/selftests/kvm/lib/arm64/gic_v3.c b/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
index cdd29245c84e..a99a53accfe9 100644
--- a/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
@@ -50,13 +50,13 @@ static void gicv3_gicd_wait_for_rwp(void)
 	}
 }
 
-static inline volatile void *gicr_base_cpu(uint32_t cpu)
+static inline volatile void *gicr_base_cpu(u32 cpu)
 {
 	/* Align all the redistributors sequentially */
 	return GICR_BASE_GVA + cpu * SZ_64K * 2;
 }
 
-static void gicv3_gicr_wait_for_rwp(uint32_t cpu)
+static void gicv3_gicr_wait_for_rwp(u32 cpu)
 {
 	unsigned int count = 100000; /* 1s */
 
@@ -66,7 +66,7 @@ static void gicv3_gicr_wait_for_rwp(uint32_t cpu)
 	}
 }
 
-static void gicv3_wait_for_rwp(uint32_t cpu_or_dist)
+static void gicv3_wait_for_rwp(u32 cpu_or_dist)
 {
 	if (cpu_or_dist & DIST_BIT)
 		gicv3_gicd_wait_for_rwp();
@@ -99,13 +99,13 @@ static u64 gicv3_read_iar(void)
 	return irqstat;
 }
 
-static void gicv3_write_eoir(uint32_t irq)
+static void gicv3_write_eoir(u32 irq)
 {
 	write_sysreg_s(irq, SYS_ICC_EOIR1_EL1);
 	isb();
 }
 
-static void gicv3_write_dir(uint32_t irq)
+static void gicv3_write_dir(u32 irq)
 {
 	write_sysreg_s(irq, SYS_ICC_DIR_EL1);
 	isb();
@@ -118,7 +118,7 @@ static void gicv3_set_priority_mask(u64 mask)
 
 static void gicv3_set_eoi_split(bool split)
 {
-	uint32_t val;
+	u32 val;
 
 	/*
 	 * All other fields are read-only, so no need to read CTLR first. In
@@ -129,29 +129,29 @@ static void gicv3_set_eoi_split(bool split)
 	isb();
 }
 
-uint32_t gicv3_reg_readl(uint32_t cpu_or_dist, u64 offset)
+u32 gicv3_reg_readl(u32 cpu_or_dist, u64 offset)
 {
 	volatile void *base = cpu_or_dist & DIST_BIT ? GICD_BASE_GVA
 			: sgi_base_from_redist(gicr_base_cpu(cpu_or_dist));
 	return readl(base + offset);
 }
 
-void gicv3_reg_writel(uint32_t cpu_or_dist, u64 offset, uint32_t reg_val)
+void gicv3_reg_writel(u32 cpu_or_dist, u64 offset, u32 reg_val)
 {
 	volatile void *base = cpu_or_dist & DIST_BIT ? GICD_BASE_GVA
 			: sgi_base_from_redist(gicr_base_cpu(cpu_or_dist));
 	writel(reg_val, base + offset);
 }
 
-uint32_t gicv3_getl_fields(uint32_t cpu_or_dist, u64 offset, uint32_t mask)
+u32 gicv3_getl_fields(u32 cpu_or_dist, u64 offset, u32 mask)
 {
 	return gicv3_reg_readl(cpu_or_dist, offset) & mask;
 }
 
-void gicv3_setl_fields(uint32_t cpu_or_dist, u64 offset,
-		       uint32_t mask, uint32_t reg_val)
+void gicv3_setl_fields(u32 cpu_or_dist, u64 offset,
+		       u32 mask, u32 reg_val)
 {
-	uint32_t tmp = gicv3_reg_readl(cpu_or_dist, offset) & ~mask;
+	u32 tmp = gicv3_reg_readl(cpu_or_dist, offset) & ~mask;
 
 	tmp |= (reg_val & mask);
 	gicv3_reg_writel(cpu_or_dist, offset, tmp);
@@ -165,14 +165,14 @@ void gicv3_setl_fields(uint32_t cpu_or_dist, u64 offset,
  * map that doesn't implement it; like GICR_WAKER's offset of 0x0014 being
  * marked as "Reserved" in the Distributor map.
  */
-static void gicv3_access_reg(uint32_t intid, u64 offset,
-			     uint32_t reg_bits, uint32_t bits_per_field,
-			     bool write, uint32_t *val)
+static void gicv3_access_reg(u32 intid, u64 offset,
+			     u32 reg_bits, u32 bits_per_field,
+			     bool write, u32 *val)
 {
-	uint32_t cpu = guest_get_vcpuid();
+	u32 cpu = guest_get_vcpuid();
 	enum gicv3_intid_range intid_range = get_intid_range(intid);
-	uint32_t fields_per_reg, index, mask, shift;
-	uint32_t cpu_or_dist;
+	u32 fields_per_reg, index, mask, shift;
+	u32 cpu_or_dist;
 
 	GUEST_ASSERT(bits_per_field <= reg_bits);
 	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
@@ -197,32 +197,32 @@ static void gicv3_access_reg(uint32_t intid, u64 offset,
 	*val = gicv3_getl_fields(cpu_or_dist, offset, mask) >> shift;
 }
 
-static void gicv3_write_reg(uint32_t intid, u64 offset,
-			    uint32_t reg_bits, uint32_t bits_per_field, uint32_t val)
+static void gicv3_write_reg(u32 intid, u64 offset,
+			    u32 reg_bits, u32 bits_per_field, u32 val)
 {
 	gicv3_access_reg(intid, offset, reg_bits,
 			bits_per_field, true, &val);
 }
 
-static uint32_t gicv3_read_reg(uint32_t intid, u64 offset,
-			       uint32_t reg_bits, uint32_t bits_per_field)
+static u32 gicv3_read_reg(u32 intid, u64 offset,
+			  u32 reg_bits, u32 bits_per_field)
 {
-	uint32_t val;
+	u32 val;
 
 	gicv3_access_reg(intid, offset, reg_bits,
 			bits_per_field, false, &val);
 	return val;
 }
 
-static void gicv3_set_priority(uint32_t intid, uint32_t prio)
+static void gicv3_set_priority(u32 intid, u32 prio)
 {
 	gicv3_write_reg(intid, GICD_IPRIORITYR, 32, 8, prio);
 }
 
 /* Sets the intid to be level-sensitive or edge-triggered. */
-static void gicv3_irq_set_config(uint32_t intid, bool is_edge)
+static void gicv3_irq_set_config(u32 intid, bool is_edge)
 {
-	uint32_t val;
+	u32 val;
 
 	/* N/A for private interrupts. */
 	GUEST_ASSERT(get_intid_range(intid) == SPI_RANGE);
@@ -230,57 +230,57 @@ static void gicv3_irq_set_config(uint32_t intid, bool is_edge)
 	gicv3_write_reg(intid, GICD_ICFGR, 32, 2, val);
 }
 
-static void gicv3_irq_enable(uint32_t intid)
+static void gicv3_irq_enable(u32 intid)
 {
 	bool is_spi = get_intid_range(intid) == SPI_RANGE;
-	uint32_t cpu = guest_get_vcpuid();
+	u32 cpu = guest_get_vcpuid();
 
 	gicv3_write_reg(intid, GICD_ISENABLER, 32, 1, 1);
 	gicv3_wait_for_rwp(is_spi ? DIST_BIT : cpu);
 }
 
-static void gicv3_irq_disable(uint32_t intid)
+static void gicv3_irq_disable(u32 intid)
 {
 	bool is_spi = get_intid_range(intid) == SPI_RANGE;
-	uint32_t cpu = guest_get_vcpuid();
+	u32 cpu = guest_get_vcpuid();
 
 	gicv3_write_reg(intid, GICD_ICENABLER, 32, 1, 1);
 	gicv3_wait_for_rwp(is_spi ? DIST_BIT : cpu);
 }
 
-static void gicv3_irq_set_active(uint32_t intid)
+static void gicv3_irq_set_active(u32 intid)
 {
 	gicv3_write_reg(intid, GICD_ISACTIVER, 32, 1, 1);
 }
 
-static void gicv3_irq_clear_active(uint32_t intid)
+static void gicv3_irq_clear_active(u32 intid)
 {
 	gicv3_write_reg(intid, GICD_ICACTIVER, 32, 1, 1);
 }
 
-static bool gicv3_irq_get_active(uint32_t intid)
+static bool gicv3_irq_get_active(u32 intid)
 {
 	return gicv3_read_reg(intid, GICD_ISACTIVER, 32, 1);
 }
 
-static void gicv3_irq_set_pending(uint32_t intid)
+static void gicv3_irq_set_pending(u32 intid)
 {
 	gicv3_write_reg(intid, GICD_ISPENDR, 32, 1, 1);
 }
 
-static void gicv3_irq_clear_pending(uint32_t intid)
+static void gicv3_irq_clear_pending(u32 intid)
 {
 	gicv3_write_reg(intid, GICD_ICPENDR, 32, 1, 1);
 }
 
-static bool gicv3_irq_get_pending(uint32_t intid)
+static bool gicv3_irq_get_pending(u32 intid)
 {
 	return gicv3_read_reg(intid, GICD_ISPENDR, 32, 1);
 }
 
 static void gicv3_enable_redist(volatile void *redist_base)
 {
-	uint32_t val = readl(redist_base + GICR_WAKER);
+	u32 val = readl(redist_base + GICR_WAKER);
 	unsigned int count = 100000; /* 1s */
 
 	val &= ~GICR_WAKER_ProcessorSleep;
@@ -293,10 +293,10 @@ static void gicv3_enable_redist(volatile void *redist_base)
 	}
 }
 
-static void gicv3_set_group(uint32_t intid, bool grp)
+static void gicv3_set_group(u32 intid, bool grp)
 {
-	uint32_t cpu_or_dist;
-	uint32_t val;
+	u32 cpu_or_dist;
+	u32 val;
 
 	cpu_or_dist = (get_intid_range(intid) == SPI_RANGE) ? DIST_BIT : guest_get_vcpuid();
 	val = gicv3_reg_readl(cpu_or_dist, GICD_IGROUPR + (intid / 32) * 4);
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index bc63588ce3c6..8042a960ddeb 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -413,7 +413,7 @@ void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
 	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (u64)guest_code);
 }
 
-static struct kvm_vcpu *__aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+static struct kvm_vcpu *__aarch64_vcpu_add(struct kvm_vm *vm, u32 vcpu_id,
 					   struct kvm_vcpu_init *init)
 {
 	size_t stack_size;
@@ -432,7 +432,7 @@ static struct kvm_vcpu *__aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	return vcpu;
 }
 
-struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, u32 vcpu_id,
 				  struct kvm_vcpu_init *init, void *guest_code)
 {
 	struct kvm_vcpu *vcpu = __aarch64_vcpu_add(vm, vcpu_id, init);
@@ -442,7 +442,7 @@ struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	return vcpu;
 }
 
-struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 {
 	return __aarch64_vcpu_add(vm, vcpu_id, NULL);
 }
@@ -563,13 +563,13 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 	handlers->exception_handlers[vector][0] = handler;
 }
 
-uint32_t guest_get_vcpuid(void)
+u32 guest_get_vcpuid(void)
 {
 	return read_sysreg(tpidr_el1);
 }
 
-static uint32_t max_ipa_for_page_size(uint32_t vm_ipa, uint32_t gran,
-				uint32_t not_sup_val, uint32_t ipa52_min_val)
+static u32 max_ipa_for_page_size(u32 vm_ipa, u32 gran,
+				 u32 not_sup_val, u32 ipa52_min_val)
 {
 	if (gran == not_sup_val)
 		return 0;
@@ -579,13 +579,13 @@ static uint32_t max_ipa_for_page_size(uint32_t vm_ipa, uint32_t gran,
 		return min(vm_ipa, 48U);
 }
 
-void aarch64_get_supported_page_sizes(uint32_t ipa, uint32_t *ipa4k,
-					uint32_t *ipa16k, uint32_t *ipa64k)
+void aarch64_get_supported_page_sizes(u32 ipa, u32 *ipa4k,
+				      u32 *ipa16k, u32 *ipa64k)
 {
 	struct kvm_vcpu_init preferred_init;
 	int kvm_fd, vm_fd, vcpu_fd, err;
 	u64 val;
-	uint32_t gran;
+	u32 gran;
 	struct kvm_one_reg reg = {
 		.id	= KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1),
 		.addr	= (u64)&val,
@@ -646,7 +646,7 @@ void aarch64_get_supported_page_sizes(uint32_t ipa, uint32_t *ipa4k,
 		     : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7")
 
 
-void smccc_hvc(uint32_t function_id, u64 arg0, u64 arg1,
+void smccc_hvc(u32 function_id, u64 arg0, u64 arg1,
 	       u64 arg2, u64 arg3, u64 arg4, u64 arg5,
 	       u64 arg6, struct arm_smccc_res *res)
 {
@@ -654,7 +654,7 @@ void smccc_hvc(uint32_t function_id, u64 arg0, u64 arg1,
 		     arg6, res);
 }
 
-void smccc_smc(uint32_t function_id, u64 arg0, u64 arg1,
+void smccc_smc(u32 function_id, u64 arg0, u64 arg1,
 	       u64 arg2, u64 arg3, u64 arg4, u64 arg5,
 	       u64 arg6, struct arm_smccc_res *res)
 {
diff --git a/tools/testing/selftests/kvm/lib/arm64/vgic.c b/tools/testing/selftests/kvm/lib/arm64/vgic.c
index 166637d6abf5..4ecebf3146a2 100644
--- a/tools/testing/selftests/kvm/lib/arm64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/arm64/vgic.c
@@ -41,7 +41,7 @@ bool kvm_supports_vgic_v3(void)
  * redistributor regions of the guest. Since it depends on the number of
  * vCPUs for the VM, it must be called after all the vCPUs have been created.
  */
-int __vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs)
+int __vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, u32 nr_irqs)
 {
 	int gic_fd;
 	u64 attr;
@@ -77,7 +77,7 @@ void __vgic_v3_init(int fd)
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 }
 
-int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs)
+int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, u32 nr_irqs)
 {
 	unsigned int nr_vcpus_created = 0;
 	struct list_head *iter;
@@ -104,7 +104,7 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs)
 }
 
 /* should only work for level sensitive interrupts */
-int _kvm_irq_set_level_info(int gic_fd, uint32_t intid, int level)
+int _kvm_irq_set_level_info(int gic_fd, u32 intid, int level)
 {
 	u64 attr = 32 * (intid / 32);
 	u64 index = intid % 32;
@@ -122,16 +122,16 @@ int _kvm_irq_set_level_info(int gic_fd, uint32_t intid, int level)
 	return ret;
 }
 
-void kvm_irq_set_level_info(int gic_fd, uint32_t intid, int level)
+void kvm_irq_set_level_info(int gic_fd, u32 intid, int level)
 {
 	int ret = _kvm_irq_set_level_info(gic_fd, intid, level);
 
 	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO, ret));
 }
 
-int _kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level)
+int _kvm_arm_irq_line(struct kvm_vm *vm, u32 intid, int level)
 {
-	uint32_t irq = intid & KVM_ARM_IRQ_NUM_MASK;
+	u32 irq = intid & KVM_ARM_IRQ_NUM_MASK;
 
 	TEST_ASSERT(!INTID_IS_SGI(intid), "KVM_IRQ_LINE's interface itself "
 		"doesn't allow injecting SGIs. There's no mask for it.");
@@ -144,14 +144,14 @@ int _kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level)
 	return _kvm_irq_line(vm, irq, level);
 }
 
-void kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level)
+void kvm_arm_irq_line(struct kvm_vm *vm, u32 intid, int level)
 {
 	int ret = _kvm_arm_irq_line(vm, intid, level);
 
 	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_IRQ_LINE, ret));
 }
 
-static void vgic_poke_irq(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu,
+static void vgic_poke_irq(int gic_fd, u32 intid, struct kvm_vcpu *vcpu,
 			  u64 reg_off)
 {
 	u64 reg = intid / 32;
@@ -160,7 +160,7 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu,
 	u64 val;
 	bool intid_is_private = INTID_IS_SGI(intid) || INTID_IS_PPI(intid);
 
-	uint32_t group = intid_is_private ? KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
+	u32 group = intid_is_private ? KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
 					  : KVM_DEV_ARM_VGIC_GRP_DIST_REGS;
 
 	if (intid_is_private) {
@@ -183,12 +183,12 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu,
 	kvm_device_attr_set(gic_fd, group, attr, &val);
 }
 
-void kvm_irq_write_ispendr(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu)
+void kvm_irq_write_ispendr(int gic_fd, u32 intid, struct kvm_vcpu *vcpu)
 {
 	vgic_poke_irq(gic_fd, intid, vcpu, GICD_ISPENDR);
 }
 
-void kvm_irq_write_isactiver(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu)
+void kvm_irq_write_isactiver(int gic_fd, u32 intid, struct kvm_vcpu *vcpu)
 {
 	vgic_poke_irq(gic_fd, intid, vcpu, GICD_ISACTIVER);
 }
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index ce3099630397..7a96c43b5704 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -20,7 +20,7 @@ void guest_modes_append_default(void)
 #ifdef __aarch64__
 	{
 		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
-		uint32_t ipa4k, ipa16k, ipa64k;
+		u32 ipa4k, ipa16k, ipa64k;
 		int i;
 
 		aarch64_get_supported_page_sizes(limit, &ipa4k, &ipa16k, &ipa64k);
diff --git a/tools/testing/selftests/kvm/lib/guest_sprintf.c b/tools/testing/selftests/kvm/lib/guest_sprintf.c
index a3a44657e72d..551ad6c658aa 100644
--- a/tools/testing/selftests/kvm/lib/guest_sprintf.c
+++ b/tools/testing/selftests/kvm/lib/guest_sprintf.c
@@ -35,8 +35,8 @@ static int skip_atoi(const char **s)
 ({							\
 	int __res;					\
 							\
-	__res = ((u64)n) % (uint32_t) base;		\
-	n = ((u64)n) / (uint32_t) base;			\
+	__res = ((u64)n) % (u32)base;			\
+	n = ((u64)n) / (u32)base;			\
 	__res;						\
 })
 
@@ -292,7 +292,7 @@ int guest_vsnprintf(char *buf, int n, const char *fmt, va_list args)
 		} else if (flags & SIGN)
 			num = va_arg(args, int);
 		else
-			num = va_arg(args, uint32_t);
+			num = va_arg(args, u32);
 		str = number(str, end, num, base, field_width, precision, flags);
 	}
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 6b071c57aa6c..baeed5f55356 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -20,9 +20,9 @@
 
 #define KVM_UTIL_MIN_PFN	2
 
-uint32_t guest_random_seed;
+u32 guest_random_seed;
 struct guest_random_state guest_rng;
-static uint32_t last_guest_seed;
+static u32 last_guest_seed;
 
 static size_t vcpu_mmap_sz(void);
 
@@ -165,7 +165,7 @@ unsigned int kvm_check_cap(long cap)
 	return (unsigned int)ret;
 }
 
-void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
+void vm_enable_dirty_ring(struct kvm_vm *vm, u32 ring_size)
 {
 	if (vm_check_cap(vm, KVM_CAP_DIRTY_LOG_RING_ACQ_REL))
 		vm_enable_cap(vm, KVM_CAP_DIRTY_LOG_RING_ACQ_REL, ring_size);
@@ -189,7 +189,7 @@ static void vm_open(struct kvm_vm *vm)
 		vm->stats.fd = -1;
 }
 
-const char *vm_guest_mode_string(uint32_t i)
+const char *vm_guest_mode_string(u32 i)
 {
 	static const char * const strings[] = {
 		[VM_MODE_P52V48_4K]	= "PA-bits:52,  VA-bits:48,  4K pages",
@@ -397,7 +397,7 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 }
 
 static u64 vm_nr_pages_required(enum vm_guest_mode mode,
-				uint32_t nr_runnable_vcpus,
+				u32 nr_runnable_vcpus,
 				u64 extra_mem_pages)
 {
 	u64 page_size = vm_guest_mode_params[mode].page_size;
@@ -435,7 +435,7 @@ static u64 vm_nr_pages_required(enum vm_guest_mode mode,
 	return vm_adjust_num_guest_pages(mode, nr_pages);
 }
 
-void kvm_set_files_rlimit(uint32_t nr_vcpus)
+void kvm_set_files_rlimit(u32 nr_vcpus)
 {
 	/*
 	 * Each vCPU will open two file descriptors: the vCPU itself and the
@@ -476,7 +476,7 @@ static bool is_guest_memfd_required(struct vm_shape shape)
 #endif
 }
 
-struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
+struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
 			   u64 nr_extra_pages)
 {
 	u64 nr_pages = vm_nr_pages_required(shape.mode, nr_runnable_vcpus,
@@ -546,7 +546,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
  * extra_mem_pages is only used to calculate the maximum page table size,
  * no real memory allocation for non-slot0 memory in this function.
  */
-struct kvm_vm *__vm_create_with_vcpus(struct vm_shape shape, uint32_t nr_vcpus,
+struct kvm_vm *__vm_create_with_vcpus(struct vm_shape shape, u32 nr_vcpus,
 				      u64 extra_mem_pages,
 				      void *guest_code, struct kvm_vcpu *vcpus[])
 {
@@ -614,7 +614,7 @@ void kvm_vm_restart(struct kvm_vm *vmp)
 }
 
 __weak struct kvm_vcpu *vm_arch_vcpu_recreate(struct kvm_vm *vm,
-					      uint32_t vcpu_id)
+					      u32 vcpu_id)
 {
 	return __vm_vcpu_add(vm, vcpu_id);
 }
@@ -636,9 +636,9 @@ int __pin_task_to_cpu(pthread_t task, int cpu)
 	return pthread_setaffinity_np(task, sizeof(cpuset), &cpuset);
 }
 
-static uint32_t parse_pcpu(const char *cpu_str, const cpu_set_t *allowed_mask)
+static u32 parse_pcpu(const char *cpu_str, const cpu_set_t *allowed_mask)
 {
-	uint32_t pcpu = atoi_non_negative("CPU number", cpu_str);
+	u32 pcpu = atoi_non_negative("CPU number", cpu_str);
 
 	TEST_ASSERT(CPU_ISSET(pcpu, allowed_mask),
 		    "Not allowed to run on pCPU '%d', check cgroups?", pcpu);
@@ -662,7 +662,7 @@ void kvm_print_vcpu_pinning_help(void)
 	       "     (default: no pinning)\n", name, name);
 }
 
-void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
+void kvm_parse_vcpu_pinning(const char *pcpus_string, u32 vcpu_to_pcpu[],
 			    int nr_vcpus)
 {
 	cpu_set_t allowed_mask;
@@ -918,7 +918,7 @@ static void vm_userspace_mem_region_hva_insert(struct rb_root *hva_tree,
 }
 
 
-int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+int __vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
 				u64 gpa, u64 size, void *hva)
 {
 	struct kvm_userspace_memory_region region = {
@@ -932,7 +932,7 @@ int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags
 	return ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION, &region);
 }
 
-void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+void vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
 			       u64 gpa, u64 size, void *hva)
 {
 	int ret = __vm_set_user_memory_region(vm, slot, flags, gpa, size, hva);
@@ -945,9 +945,9 @@ void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 	__TEST_REQUIRE(kvm_has_cap(KVM_CAP_USER_MEMORY2),	\
 		       "KVM selftests now require KVM_SET_USER_MEMORY_REGION2 (introduced in v6.8)")
 
-int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 				 u64 gpa, u64 size, void *hva,
-				 uint32_t guest_memfd, u64 guest_memfd_offset)
+				 u32 guest_memfd, u64 guest_memfd_offset)
 {
 	struct kvm_userspace_memory_region2 region = {
 		.slot = slot,
@@ -964,9 +964,9 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flag
 	return ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION2, &region);
 }
 
-void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 				u64 gpa, u64 size, void *hva,
-				uint32_t guest_memfd, u64 guest_memfd_offset)
+				u32 guest_memfd, u64 guest_memfd_offset)
 {
 	int ret = __vm_set_user_memory_region2(vm, slot, flags, gpa, size, hva,
 					       guest_memfd, guest_memfd_offset);
@@ -978,7 +978,7 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags
 
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
-		u64 gpa, uint32_t slot, u64 npages, uint32_t flags,
+		u64 gpa, u32 slot, u64 npages, u32 flags,
 		int guest_memfd, u64 guest_memfd_offset)
 {
 	int ret;
@@ -1092,7 +1092,7 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	if (flags & KVM_MEM_GUEST_MEMFD) {
 		if (guest_memfd < 0) {
-			uint32_t guest_memfd_flags = 0;
+			u32 guest_memfd_flags = 0;
 			TEST_ASSERT(!guest_memfd_offset,
 				    "Offset must be zero when creating new guest_memfd");
 			guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
@@ -1148,8 +1148,8 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 enum vm_mem_backing_src_type src_type,
-				 u64 gpa, uint32_t slot, u64 npages,
-				 uint32_t flags)
+				 u64 gpa, u32 slot, u64 npages,
+				 u32 flags)
 {
 	vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0);
 }
@@ -1170,7 +1170,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
  *   memory slot ID).
  */
 struct userspace_mem_region *
-memslot2region(struct kvm_vm *vm, uint32_t memslot)
+memslot2region(struct kvm_vm *vm, u32 memslot)
 {
 	struct userspace_mem_region *region;
 
@@ -1201,7 +1201,7 @@ memslot2region(struct kvm_vm *vm, uint32_t memslot)
  * Sets the flags of the memory region specified by the value of slot,
  * to the values given by flags.
  */
-void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags)
+void vm_mem_region_set_flags(struct kvm_vm *vm, u32 slot, u32 flags)
 {
 	int ret;
 	struct userspace_mem_region *region;
@@ -1217,7 +1217,7 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags)
 		ret, errno, slot, flags);
 }
 
-void vm_mem_region_reload(struct kvm_vm *vm, uint32_t slot)
+void vm_mem_region_reload(struct kvm_vm *vm, u32 slot)
 {
 	struct userspace_mem_region *region = memslot2region(vm, slot);
 	struct kvm_userspace_memory_region2 tmp = region->region;
@@ -1241,7 +1241,7 @@ void vm_mem_region_reload(struct kvm_vm *vm, uint32_t slot)
  *
  * Change the gpa of a memory region.
  */
-void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, u64 new_gpa)
+void vm_mem_region_move(struct kvm_vm *vm, u32 slot, u64 new_gpa)
 {
 	struct userspace_mem_region *region;
 	int ret;
@@ -1270,7 +1270,7 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, u64 new_gpa)
  *
  * Delete a memory region.
  */
-void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot)
+void vm_mem_region_delete(struct kvm_vm *vm, u32 slot)
 {
 	struct userspace_mem_region *region = memslot2region(vm, slot);
 
@@ -1324,7 +1324,7 @@ static size_t vcpu_mmap_sz(void)
 	return ret;
 }
 
-static bool vcpu_exists(struct kvm_vm *vm, uint32_t vcpu_id)
+static bool vcpu_exists(struct kvm_vm *vm, u32 vcpu_id)
 {
 	struct kvm_vcpu *vcpu;
 
@@ -1340,7 +1340,7 @@ static bool vcpu_exists(struct kvm_vm *vm, uint32_t vcpu_id)
  * Adds a virtual CPU to the VM specified by vm with the ID given by vcpu_id.
  * No additional vCPU setup is done.  Returns the vCPU.
  */
-struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
+struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 {
 	struct kvm_vcpu *vcpu;
 
@@ -1787,8 +1787,8 @@ struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vcpu *vcpu)
 
 void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu)
 {
-	uint32_t page_size = getpagesize();
-	uint32_t size = vcpu->vm->dirty_ring_size;
+	u32 page_size = getpagesize();
+	u32 size = vcpu->vm->dirty_ring_size;
 
 	TEST_ASSERT(size > 0, "Should enable dirty ring first");
 
@@ -1817,7 +1817,7 @@ void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu)
  * Device Ioctl
  */
 
-int __kvm_has_device_attr(int dev_fd, uint32_t group, u64 attr)
+int __kvm_has_device_attr(int dev_fd, u32 group, u64 attr)
 {
 	struct kvm_device_attr attribute = {
 		.group = group,
@@ -1852,7 +1852,7 @@ int __kvm_create_device(struct kvm_vm *vm, u64 type)
 	return err ? : create_dev.fd;
 }
 
-int __kvm_device_attr_get(int dev_fd, uint32_t group, u64 attr, void *val)
+int __kvm_device_attr_get(int dev_fd, u32 group, u64 attr, void *val)
 {
 	struct kvm_device_attr kvmattr = {
 		.group = group,
@@ -1864,7 +1864,7 @@ int __kvm_device_attr_get(int dev_fd, uint32_t group, u64 attr, void *val)
 	return __kvm_ioctl(dev_fd, KVM_GET_DEVICE_ATTR, &kvmattr);
 }
 
-int __kvm_device_attr_set(int dev_fd, uint32_t group, u64 attr, void *val)
+int __kvm_device_attr_set(int dev_fd, u32 group, u64 attr, void *val)
 {
 	struct kvm_device_attr kvmattr = {
 		.group = group,
@@ -1880,7 +1880,7 @@ int __kvm_device_attr_set(int dev_fd, uint32_t group, u64 attr, void *val)
  * IRQ related functions.
  */
 
-int _kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level)
+int _kvm_irq_line(struct kvm_vm *vm, u32 irq, int level)
 {
 	struct kvm_irq_level irq_level = {
 		.irq    = irq,
@@ -1890,7 +1890,7 @@ int _kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level)
 	return __vm_ioctl(vm, KVM_IRQ_LINE, &irq_level);
 }
 
-void kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level)
+void kvm_irq_line(struct kvm_vm *vm, u32 irq, int level)
 {
 	int ret = _kvm_irq_line(vm, irq, level);
 
@@ -1912,7 +1912,7 @@ struct kvm_irq_routing *kvm_gsi_routing_create(void)
 }
 
 void kvm_gsi_routing_irqchip_add(struct kvm_irq_routing *routing,
-		uint32_t gsi, uint32_t pin)
+		u32 gsi, u32 pin)
 {
 	int i;
 
@@ -2098,7 +2098,7 @@ const char *exit_reason_str(unsigned int exit_reason)
  * not enough pages are available at or above paddr_min.
  */
 gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			   gpa_t paddr_min, uint32_t memslot,
+			   gpa_t paddr_min, u32 memslot,
 			   bool protected)
 {
 	struct userspace_mem_region *region;
@@ -2143,7 +2143,7 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 	return base * vm->page_size;
 }
 
-gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t paddr_min, uint32_t memslot)
+gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t paddr_min, u32 memslot)
 {
 	return vm_phy_pages_alloc(vm, 1, paddr_min, memslot);
 }
diff --git a/tools/testing/selftests/kvm/lib/loongarch/processor.c b/tools/testing/selftests/kvm/lib/loongarch/processor.c
index adc678a1930d..3b81d6a2a740 100644
--- a/tools/testing/selftests/kvm/lib/loongarch/processor.c
+++ b/tools/testing/selftests/kvm/lib/loongarch/processor.c
@@ -117,7 +117,7 @@ gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 
 void virt_arch_pg_map(struct kvm_vm *vm, u64 vaddr, u64 paddr)
 {
-	uint32_t prot_bits;
+	u32 prot_bits;
 	u64 *ptep;
 
 	TEST_ASSERT((vaddr % vm->page_size) == 0,
@@ -223,7 +223,7 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector, handler_fn hand
 	handlers->exception_handlers[vector] = handler;
 }
 
-uint32_t guest_get_vcpuid(void)
+u32 guest_get_vcpuid(void)
 {
 	return csr_read(LOONGARCH_CSR_CPUID);
 }
@@ -358,7 +358,7 @@ static void loongarch_vcpu_setup(struct kvm_vcpu *vcpu)
 	loongarch_set_csr(vcpu, LOONGARCH_CSR_TMID,  vcpu->id);
 }
 
-struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 {
 	size_t stack_size;
 	u64 stack_vaddr;
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index 9774549c6565..b84b292d03cd 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -44,7 +44,7 @@ static struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
  * Continuously write to the first 8 bytes of each page in the
  * specified region.
  */
-void memstress_guest_code(uint32_t vcpu_idx)
+void memstress_guest_code(u32 vcpu_idx)
 {
 	struct memstress_args *args = &memstress_args;
 	struct memstress_vcpu_args *vcpu_args = &args->vcpu_args[vcpu_idx];
@@ -236,7 +236,7 @@ void memstress_destroy_vm(struct kvm_vm *vm)
 	kvm_vm_free(vm);
 }
 
-void memstress_set_write_percent(struct kvm_vm *vm, uint32_t write_percent)
+void memstress_set_write_percent(struct kvm_vm *vm, u32 write_percent)
 {
 	memstress_args.write_percent = write_percent;
 	sync_global_to_guest(vm, memstress_args.write_percent);
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 6c7829cc79f8..5fb3e8517722 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -45,7 +45,7 @@ static u64 pte_index_mask[] = {
 	PGTBL_L3_INDEX_MASK,
 };
 
-static uint32_t pte_index_shift[] = {
+static u32 pte_index_shift[] = {
 	PGTBL_L0_INDEX_SHIFT,
 	PGTBL_L1_INDEX_SHIFT,
 	PGTBL_L2_INDEX_SHIFT,
@@ -311,7 +311,7 @@ void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
 	vcpu_set_reg(vcpu, RISCV_CORE_REG(regs.pc), (unsigned long)guest_code);
 }
 
-struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 {
 	int r;
 	size_t stack_size;
@@ -470,7 +470,7 @@ void vm_install_interrupt_handler(struct kvm_vm *vm, exception_handler_fn handle
 	handlers->exception_handlers[1][0] = handler;
 }
 
-uint32_t guest_get_vcpuid(void)
+u32 guest_get_vcpuid(void)
 {
 	return csr_read(CSR_SSCRATCH);
 }
diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
index 3b86ff32bbfe..4fa7a6659965 100644
--- a/tools/testing/selftests/kvm/lib/s390/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390/processor.c
@@ -160,7 +160,7 @@ void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
 	vcpu->run->psw_addr = (uintptr_t)guest_code;
 }
 
-struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 {
 	size_t stack_size =  DEFAULT_STACK_PGS * getpagesize();
 	u64 stack_vaddr;
diff --git a/tools/testing/selftests/kvm/lib/sparsebit.c b/tools/testing/selftests/kvm/lib/sparsebit.c
index 8a472dcb3d5e..7e7734088f2f 100644
--- a/tools/testing/selftests/kvm/lib/sparsebit.c
+++ b/tools/testing/selftests/kvm/lib/sparsebit.c
@@ -80,7 +80,7 @@
  *   typedef u64 sparsebit_num_t;
  *
  *   sparsebit_idx_t idx;
- *   uint32_t mask;
+ *   u32 mask;
  *   sparsebit_num_t num_after;
  *
  * The idx member contains the bit index of the first bit described by this
@@ -162,7 +162,7 @@
 
 #define DUMP_LINE_MAX 100 /* Does not include indent amount */
 
-typedef uint32_t mask_t;
+typedef u32 mask_t;
 #define MASK_BITS (sizeof(mask_t) * CHAR_BIT)
 
 struct node {
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index f5b460c445be..bab1bd2b775b 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -30,15 +30,15 @@ void __attribute__((used)) expect_sigbus_handler(int signum)
  * Park-Miller LCG using standard constants.
  */
 
-struct guest_random_state new_guest_random_state(uint32_t seed)
+struct guest_random_state new_guest_random_state(u32 seed)
 {
 	struct guest_random_state s = {.seed = seed};
 	return s;
 }
 
-uint32_t guest_random_u32(struct guest_random_state *state)
+u32 guest_random_u32(struct guest_random_state *state)
 {
-	state->seed = (u64)state->seed * 48271 % ((uint32_t)(1 << 31) - 1);
+	state->seed = (u64)state->seed * 48271 % ((u32)(1 << 31) - 1);
 	return state->seed;
 }
 
@@ -225,7 +225,7 @@ size_t get_def_hugetlb_pagesz(void)
 #define ANON_FLAGS	(MAP_PRIVATE | MAP_ANONYMOUS)
 #define ANON_HUGE_FLAGS	(ANON_FLAGS | MAP_HUGETLB)
 
-const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(uint32_t i)
+const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(u32 i)
 {
 	static const struct vm_mem_backing_src_alias aliases[] = {
 		[VM_MEM_SRC_ANONYMOUS] = {
@@ -317,9 +317,9 @@ const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(uint32_t i)
 
 #define MAP_HUGE_PAGE_SIZE(x) (1ULL << ((x >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK))
 
-size_t get_backing_src_pagesz(uint32_t i)
+size_t get_backing_src_pagesz(u32 i)
 {
-	uint32_t flag = vm_mem_backing_src_alias(i)->flag;
+	u32 flag = vm_mem_backing_src_alias(i)->flag;
 
 	switch (i) {
 	case VM_MEM_SRC_ANONYMOUS:
@@ -335,7 +335,7 @@ size_t get_backing_src_pagesz(uint32_t i)
 	}
 }
 
-bool is_backing_src_hugetlb(uint32_t i)
+bool is_backing_src_hugetlb(u32 i)
 {
 	return !!(vm_mem_backing_src_alias(i)->flag & MAP_HUGETLB);
 }
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index d4c6d9e24b7e..65523a2740b7 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -522,7 +522,7 @@ void tdp_map(struct kvm_vm *vm, u64 nested_paddr, u64 paddr,
  */
 void tdp_identity_map_default_memslots(struct kvm_vm *vm)
 {
-	uint32_t s, memslot = 0;
+	u32 s, memslot = 0;
 	sparsebit_idx_t i, last;
 	struct userspace_mem_region *region = memslot2region(vm, memslot);
 
@@ -816,7 +816,7 @@ void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
 	vcpu_regs_set(vcpu, &regs);
 }
 
-struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, u32 vcpu_id)
 {
 	struct kvm_mp_state mp_state;
 	struct kvm_regs regs;
@@ -867,7 +867,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	return vcpu;
 }
 
-struct kvm_vcpu *vm_arch_vcpu_recreate(struct kvm_vm *vm, uint32_t vcpu_id)
+struct kvm_vcpu *vm_arch_vcpu_recreate(struct kvm_vm *vm, u32 vcpu_id)
 {
 	struct kvm_vcpu *vcpu = __vm_vcpu_add(vm, vcpu_id);
 
@@ -902,9 +902,9 @@ const struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 	return kvm_supported_cpuid;
 }
 
-static uint32_t __kvm_cpu_has(const struct kvm_cpuid2 *cpuid,
-			      uint32_t function, uint32_t index,
-			      uint8_t reg, uint8_t lo, uint8_t hi)
+static u32 __kvm_cpu_has(const struct kvm_cpuid2 *cpuid,
+			 u32 function, u32 index,
+			 uint8_t reg, uint8_t lo, uint8_t hi)
 {
 	const struct kvm_cpuid_entry2 *entry;
 	int i;
@@ -931,8 +931,8 @@ bool kvm_cpuid_has(const struct kvm_cpuid2 *cpuid,
 			     feature.reg, feature.bit, feature.bit);
 }
 
-uint32_t kvm_cpuid_property(const struct kvm_cpuid2 *cpuid,
-			    struct kvm_x86_cpu_property property)
+u32 kvm_cpuid_property(const struct kvm_cpuid2 *cpuid,
+		       struct kvm_x86_cpu_property property)
 {
 	return __kvm_cpu_has(cpuid, property.function, property.index,
 			     property.reg, property.lo_bit, property.hi_bit);
@@ -1014,7 +1014,7 @@ void vcpu_init_cpuid(struct kvm_vcpu *vcpu, const struct kvm_cpuid2 *cpuid)
 
 void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
 			     struct kvm_x86_cpu_property property,
-			     uint32_t value)
+			     u32 value)
 {
 	struct kvm_cpuid_entry2 *entry;
 
@@ -1029,7 +1029,7 @@ void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
 	TEST_ASSERT_EQ(kvm_cpuid_property(vcpu->cpuid, property), value);
 }
 
-void vcpu_clear_cpuid_entry(struct kvm_vcpu *vcpu, uint32_t function)
+void vcpu_clear_cpuid_entry(struct kvm_vcpu *vcpu, u32 function)
 {
 	struct kvm_cpuid_entry2 *entry = vcpu_get_cpuid_entry(vcpu, function);
 
@@ -1191,7 +1191,7 @@ const struct kvm_msr_list *kvm_get_feature_msr_index_list(void)
 	return list;
 }
 
-bool kvm_msr_is_in_save_restore_list(uint32_t msr_index)
+bool kvm_msr_is_in_save_restore_list(u32 msr_index)
 {
 	const struct kvm_msr_list *list = kvm_get_msr_index_list();
 	int i;
@@ -1322,7 +1322,7 @@ void kvm_init_vm_address_properties(struct kvm_vm *vm)
 }
 
 const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
-					       uint32_t function, uint32_t index)
+					       u32 function, u32 index)
 {
 	int i;
 
diff --git a/tools/testing/selftests/kvm/lib/x86/sev.c b/tools/testing/selftests/kvm/lib/x86/sev.c
index 555198348159..d82f677b7c5e 100644
--- a/tools/testing/selftests/kvm/lib/x86/sev.c
+++ b/tools/testing/selftests/kvm/lib/x86/sev.c
@@ -79,7 +79,7 @@ void snp_vm_init(struct kvm_vm *vm)
 	vm_sev_ioctl(vm, KVM_SEV_INIT2, &init);
 }
 
-void sev_vm_launch(struct kvm_vm *vm, uint32_t policy)
+void sev_vm_launch(struct kvm_vm *vm, u32 policy)
 {
 	struct kvm_sev_launch_start launch_start = {
 		.policy = policy,
@@ -158,7 +158,7 @@ void snp_vm_launch_finish(struct kvm_vm *vm)
 	vm_sev_ioctl(vm, KVM_SEV_SNP_LAUNCH_FINISH, &launch_finish);
 }
 
-struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t type, void *guest_code,
+struct kvm_vm *vm_sev_create_with_one_vcpu(u32 type, void *guest_code,
 					   struct kvm_vcpu **cpu)
 {
 	struct vm_shape shape = {
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 6a132f69bccd..068937005417 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -160,7 +160,7 @@ bool prepare_for_vmx_operation(struct vmx_pages *vmx)
 		wrmsr(MSR_IA32_FEAT_CTL, feature_control | required);
 
 	/* Enter VMX root operation. */
-	*(uint32_t *)(vmx->vmxon) = vmcs_revision();
+	*(u32 *)(vmx->vmxon) = vmcs_revision();
 	if (vmxon(vmx->vmxon_gpa))
 		return false;
 
@@ -170,7 +170,7 @@ bool prepare_for_vmx_operation(struct vmx_pages *vmx)
 bool load_vmcs(struct vmx_pages *vmx)
 {
 	/* Load a VMCS. */
-	*(uint32_t *)(vmx->vmcs) = vmcs_revision();
+	*(u32 *)(vmx->vmcs) = vmcs_revision();
 	if (vmclear(vmx->vmcs_gpa))
 		return false;
 
@@ -178,7 +178,7 @@ bool load_vmcs(struct vmx_pages *vmx)
 		return false;
 
 	/* Setup shadow VMCS, do not load it yet. */
-	*(uint32_t *)(vmx->shadow_vmcs) = vmcs_revision() | 0x80000000ul;
+	*(u32 *)(vmx->shadow_vmcs) = vmcs_revision() | 0x80000000ul;
 	if (vmclear(vmx->shadow_vmcs_gpa))
 		return false;
 
@@ -200,7 +200,7 @@ bool ept_1g_pages_supported(void)
  */
 static inline void init_vmcs_control_fields(struct vmx_pages *vmx)
 {
-	uint32_t sec_exec_ctl = 0;
+	u32 sec_exec_ctl = 0;
 
 	vmwrite(VIRTUAL_PROCESSOR_ID, 0);
 	vmwrite(POSTED_INTR_NV, 0);
@@ -259,7 +259,7 @@ static inline void init_vmcs_control_fields(struct vmx_pages *vmx)
  */
 static inline void init_vmcs_host_state(void)
 {
-	uint32_t exit_controls = vmreadz(VM_EXIT_CONTROLS);
+	u32 exit_controls = vmreadz(VM_EXIT_CONTROLS);
 
 	vmwrite(HOST_ES_SELECTOR, get_es());
 	vmwrite(HOST_CS_SELECTOR, get_cs());
diff --git a/tools/testing/selftests/kvm/loongarch/arch_timer.c b/tools/testing/selftests/kvm/loongarch/arch_timer.c
index f80e36962879..a7279ded8518 100644
--- a/tools/testing/selftests/kvm/loongarch/arch_timer.c
+++ b/tools/testing/selftests/kvm/loongarch/arch_timer.c
@@ -27,7 +27,7 @@ static void do_idle(void)
 static void guest_irq_handler(struct ex_regs *regs)
 {
 	unsigned int intid;
-	uint32_t cpu = guest_get_vcpuid();
+	u32 cpu = guest_get_vcpuid();
 	u64 xcnt, val, cfg, xcnt_diff_us;
 	struct test_vcpu_shared_data *shared_data = &vcpu_shared_data[cpu];
 
@@ -62,9 +62,9 @@ static void guest_irq_handler(struct ex_regs *regs)
 	WRITE_ONCE(shared_data->nr_iter, shared_data->nr_iter + 1);
 }
 
-static void guest_test_period_timer(uint32_t cpu)
+static void guest_test_period_timer(u32 cpu)
 {
-	uint32_t irq_iter, config_iter;
+	u32 irq_iter, config_iter;
 	u64 us;
 	struct test_vcpu_shared_data *shared_data = &vcpu_shared_data[cpu];
 
@@ -86,9 +86,9 @@ static void guest_test_period_timer(uint32_t cpu)
 			irq_iter);
 }
 
-static void guest_test_oneshot_timer(uint32_t cpu)
+static void guest_test_oneshot_timer(u32 cpu)
 {
-	uint32_t irq_iter, config_iter;
+	u32 irq_iter, config_iter;
 	u64 us;
 	struct test_vcpu_shared_data *shared_data = &vcpu_shared_data[cpu];
 
@@ -112,9 +112,9 @@ static void guest_test_oneshot_timer(uint32_t cpu)
 	}
 }
 
-static void guest_test_emulate_timer(uint32_t cpu)
+static void guest_test_emulate_timer(u32 cpu)
 {
-	uint32_t config_iter;
+	u32 config_iter;
 	u64 xcnt_diff_us, us;
 	struct test_vcpu_shared_data *shared_data = &vcpu_shared_data[cpu];
 
@@ -136,9 +136,9 @@ static void guest_test_emulate_timer(uint32_t cpu)
 	local_irq_enable();
 }
 
-static void guest_time_count_test(uint32_t cpu)
+static void guest_time_count_test(u32 cpu)
 {
-	uint32_t config_iter;
+	u32 config_iter;
 	unsigned long start, end, prev, us;
 
 	/* Assuming that test case starts to run in 1 second */
@@ -165,7 +165,7 @@ static void guest_time_count_test(uint32_t cpu)
 
 static void guest_code(void)
 {
-	uint32_t cpu = guest_get_vcpuid();
+	u32 cpu = guest_get_vcpuid();
 
 	/* must run at first */
 	guest_time_count_test(cpu);
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index bf62b522d32e..c2b36a4ac638 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -85,7 +85,7 @@ struct vm_data {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
 	pthread_t vcpu_thread;
-	uint32_t nslots;
+	u32 nslots;
 	u64 npages;
 	u64 pages_per_slot;
 	void **hva_slots;
@@ -95,7 +95,7 @@ struct vm_data {
 };
 
 struct sync_area {
-	uint32_t    guest_page_size;
+	u32    guest_page_size;
 	atomic_bool start_flag;
 	atomic_bool exit_flag;
 	atomic_bool sync_flag;
@@ -189,9 +189,9 @@ static void wait_for_vcpu(void)
 static void *vm_gpa2hva(struct vm_data *data, u64 gpa, u64 *rempages)
 {
 	u64 gpage, pgoffs;
-	uint32_t slot, slotoffs;
+	u32 slot, slotoffs;
 	void *base;
-	uint32_t guest_page_size = data->vm->page_size;
+	u32 guest_page_size = data->vm->page_size;
 
 	TEST_ASSERT(gpa >= MEM_GPA, "Too low gpa to translate");
 	TEST_ASSERT(gpa < MEM_GPA + data->npages * guest_page_size,
@@ -220,9 +220,9 @@ static void *vm_gpa2hva(struct vm_data *data, u64 gpa, u64 *rempages)
 	return (uint8_t *)base + slotoffs * guest_page_size + pgoffs;
 }
 
-static u64 vm_slot2gpa(struct vm_data *data, uint32_t slot)
+static u64 vm_slot2gpa(struct vm_data *data, u32 slot)
 {
-	uint32_t guest_page_size = data->vm->page_size;
+	u32 guest_page_size = data->vm->page_size;
 
 	TEST_ASSERT(slot < data->nslots, "Too high slot number");
 
@@ -243,7 +243,7 @@ static struct vm_data *alloc_vm(void)
 	return data;
 }
 
-static bool check_slot_pages(uint32_t host_page_size, uint32_t guest_page_size,
+static bool check_slot_pages(u32 host_page_size, u32 guest_page_size,
 			     u64 pages_per_slot, u64 rempages)
 {
 	if (!pages_per_slot)
@@ -259,9 +259,9 @@ static bool check_slot_pages(uint32_t host_page_size, uint32_t guest_page_size,
 }
 
 
-static u64 get_max_slots(struct vm_data *data, uint32_t host_page_size)
+static u64 get_max_slots(struct vm_data *data, u32 host_page_size)
 {
-	uint32_t guest_page_size = data->vm->page_size;
+	u32 guest_page_size = data->vm->page_size;
 	u64 mempages, pages_per_slot, rempages;
 	u64 slots;
 
@@ -287,7 +287,7 @@ static bool prepare_vm(struct vm_data *data, int nslots, u64 *maxslots,
 {
 	u64 mempages, rempages;
 	u64 guest_addr;
-	uint32_t slot, host_page_size, guest_page_size;
+	u32 slot, host_page_size, guest_page_size;
 	struct timespec tstart;
 	struct sync_area *sync;
 
@@ -448,7 +448,7 @@ static bool guest_perform_sync(void)
 static void guest_code_test_memslot_move(void)
 {
 	struct sync_area *sync = (typeof(sync))MEM_SYNC_GPA;
-	uint32_t page_size = (typeof(page_size))READ_ONCE(sync->guest_page_size);
+	u32 page_size = (typeof(page_size))READ_ONCE(sync->guest_page_size);
 	uintptr_t base = (typeof(base))READ_ONCE(sync->move_area_ptr);
 
 	GUEST_SYNC(0);
@@ -477,7 +477,7 @@ static void guest_code_test_memslot_move(void)
 static void guest_code_test_memslot_map(void)
 {
 	struct sync_area *sync = (typeof(sync))MEM_SYNC_GPA;
-	uint32_t page_size = (typeof(page_size))READ_ONCE(sync->guest_page_size);
+	u32 page_size = (typeof(page_size))READ_ONCE(sync->guest_page_size);
 
 	GUEST_SYNC(0);
 
@@ -544,7 +544,7 @@ static void guest_code_test_memslot_unmap(void)
 static void guest_code_test_memslot_rw(void)
 {
 	struct sync_area *sync = (typeof(sync))MEM_SYNC_GPA;
-	uint32_t page_size = (typeof(page_size))READ_ONCE(sync->guest_page_size);
+	u32 page_size = (typeof(page_size))READ_ONCE(sync->guest_page_size);
 
 	GUEST_SYNC(0);
 
@@ -579,7 +579,7 @@ static bool test_memslot_move_prepare(struct vm_data *data,
 				      struct sync_area *sync,
 				      u64 *maxslots, bool isactive)
 {
-	uint32_t guest_page_size = data->vm->page_size;
+	u32 guest_page_size = data->vm->page_size;
 	u64 movesrcgpa, movetestgpa;
 
 #ifdef __x86_64__
@@ -639,7 +639,7 @@ static void test_memslot_do_unmap(struct vm_data *data,
 				  u64 offsp, u64 count)
 {
 	u64 gpa, ctr;
-	uint32_t guest_page_size = data->vm->page_size;
+	u32 guest_page_size = data->vm->page_size;
 
 	for (gpa = MEM_TEST_GPA + offsp * guest_page_size, ctr = 0; ctr < count; ) {
 		u64 npages;
@@ -665,7 +665,7 @@ static void test_memslot_map_unmap_check(struct vm_data *data,
 {
 	u64 gpa;
 	u64 *val;
-	uint32_t guest_page_size = data->vm->page_size;
+	u32 guest_page_size = data->vm->page_size;
 
 	if (!map_unmap_verify)
 		return;
@@ -680,7 +680,7 @@ static void test_memslot_map_unmap_check(struct vm_data *data,
 
 static void test_memslot_map_loop(struct vm_data *data, struct sync_area *sync)
 {
-	uint32_t guest_page_size = data->vm->page_size;
+	u32 guest_page_size = data->vm->page_size;
 	u64 guest_pages = MEM_TEST_MAP_SIZE / guest_page_size;
 
 	/*
@@ -720,7 +720,7 @@ static void test_memslot_unmap_loop_common(struct vm_data *data,
 					   struct sync_area *sync,
 					   u64 chunk)
 {
-	uint32_t guest_page_size = data->vm->page_size;
+	u32 guest_page_size = data->vm->page_size;
 	u64 guest_pages = MEM_TEST_UNMAP_SIZE / guest_page_size;
 	u64 ctr;
 
@@ -746,8 +746,8 @@ static void test_memslot_unmap_loop_common(struct vm_data *data,
 static void test_memslot_unmap_loop(struct vm_data *data,
 				    struct sync_area *sync)
 {
-	uint32_t host_page_size = getpagesize();
-	uint32_t guest_page_size = data->vm->page_size;
+	u32 host_page_size = getpagesize();
+	u32 guest_page_size = data->vm->page_size;
 	u64 guest_chunk_pages = guest_page_size >= host_page_size ?
 					1 : host_page_size / guest_page_size;
 
@@ -757,7 +757,7 @@ static void test_memslot_unmap_loop(struct vm_data *data,
 static void test_memslot_unmap_loop_chunked(struct vm_data *data,
 					    struct sync_area *sync)
 {
-	uint32_t guest_page_size = data->vm->page_size;
+	u32 guest_page_size = data->vm->page_size;
 	u64 guest_chunk_pages = MEM_TEST_UNMAP_CHUNK_SIZE / guest_page_size;
 
 	test_memslot_unmap_loop_common(data, sync, guest_chunk_pages);
@@ -766,7 +766,7 @@ static void test_memslot_unmap_loop_chunked(struct vm_data *data,
 static void test_memslot_rw_loop(struct vm_data *data, struct sync_area *sync)
 {
 	u64 gptr;
-	uint32_t guest_page_size = data->vm->page_size;
+	u32 guest_page_size = data->vm->page_size;
 
 	for (gptr = MEM_TEST_GPA + guest_page_size / 2;
 	     gptr < MEM_TEST_GPA + MEM_TEST_SIZE; gptr += guest_page_size)
@@ -924,8 +924,8 @@ static void help(char *name, struct test_args *targs)
 
 static bool check_memory_sizes(void)
 {
-	uint32_t host_page_size = getpagesize();
-	uint32_t guest_page_size = vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
+	u32 host_page_size = getpagesize();
+	u32 guest_page_size = vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
 
 	if (host_page_size > SZ_64K || guest_page_size > SZ_64K) {
 		pr_info("Unsupported page size on host (0x%x) or guest (0x%x)\n",
@@ -961,7 +961,7 @@ static bool check_memory_sizes(void)
 static bool parse_args(int argc, char *argv[],
 		       struct test_args *targs)
 {
-	uint32_t max_mem_slots;
+	u32 max_mem_slots;
 	int opt;
 
 	while ((opt = getopt(argc, argv, "hvdqs:f:e:l:r:")) != -1) {
diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index ca34b7e64395..d63ee33925ad 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -34,7 +34,7 @@ static void guest_code(u64 base_gva)
 struct slot_worker_data {
 	struct kvm_vm *vm;
 	u64 gpa;
-	uint32_t flags;
+	u32 flags;
 	bool worker_ready;
 	bool prefault_ready;
 	bool recreate_slot;
diff --git a/tools/testing/selftests/kvm/riscv/arch_timer.c b/tools/testing/selftests/kvm/riscv/arch_timer.c
index 99d87e6eb5aa..d67c918ee310 100644
--- a/tools/testing/selftests/kvm/riscv/arch_timer.c
+++ b/tools/testing/selftests/kvm/riscv/arch_timer.c
@@ -19,7 +19,7 @@ static void guest_irq_handler(struct pt_regs *regs)
 {
 	u64 xcnt, xcnt_diff_us, cmp;
 	unsigned int intid = regs->cause & ~CAUSE_IRQ_FLAG;
-	uint32_t cpu = guest_get_vcpuid();
+	u32 cpu = guest_get_vcpuid();
 	struct test_vcpu_shared_data *shared_data = &vcpu_shared_data[cpu];
 
 	timer_irq_disable();
@@ -40,7 +40,7 @@ static void guest_irq_handler(struct pt_regs *regs)
 
 static void guest_run(struct test_vcpu_shared_data *shared_data)
 {
-	uint32_t irq_iter, config_iter;
+	u32 irq_iter, config_iter;
 
 	shared_data->nr_iter = 0;
 	shared_data->guest_stage = 0;
@@ -66,7 +66,7 @@ static void guest_run(struct test_vcpu_shared_data *shared_data)
 
 static void guest_code(void)
 {
-	uint32_t cpu = guest_get_vcpuid();
+	u32 cpu = guest_get_vcpuid();
 	struct test_vcpu_shared_data *shared_data = &vcpu_shared_data[cpu];
 
 	timer_irq_disable();
diff --git a/tools/testing/selftests/kvm/s390/memop.c b/tools/testing/selftests/kvm/s390/memop.c
index a6f90821835e..fc640f3c5176 100644
--- a/tools/testing/selftests/kvm/s390/memop.c
+++ b/tools/testing/selftests/kvm/s390/memop.c
@@ -42,11 +42,11 @@ struct mop_desc {
 	unsigned int _set_flags : 1;
 	unsigned int _sida_offset : 1;
 	unsigned int _ar : 1;
-	uint32_t size;
+	u32 size;
 	enum mop_target target;
 	enum mop_access_mode mode;
 	void *buf;
-	uint32_t sida_offset;
+	u32 sida_offset;
 	void *old;
 	uint8_t old_value[16];
 	bool *cmpxchg_success;
@@ -296,7 +296,7 @@ static void prepare_mem12(void)
 	TEST_ASSERT(!memcmp(p1, p2, size), "Memory contents do not match!")
 
 static void default_write_read(struct test_info copy_cpu, struct test_info mop_cpu,
-			       enum mop_target mop_target, uint32_t size, uint8_t key)
+			       enum mop_target mop_target, u32 size, uint8_t key)
 {
 	prepare_mem12();
 	CHECK_N_DO(MOP, mop_cpu, mop_target, WRITE, mem1, size,
@@ -308,7 +308,7 @@ static void default_write_read(struct test_info copy_cpu, struct test_info mop_c
 }
 
 static void default_read(struct test_info copy_cpu, struct test_info mop_cpu,
-			 enum mop_target mop_target, uint32_t size, uint8_t key)
+			 enum mop_target mop_target, u32 size, uint8_t key)
 {
 	prepare_mem12();
 	CHECK_N_DO(MOP, mop_cpu, mop_target, WRITE, mem1, size, GADDR_V(mem1));
@@ -487,7 +487,7 @@ static __uint128_t cut_to_size(int size, __uint128_t val)
 	case 2:
 		return (uint16_t)val;
 	case 4:
-		return (uint32_t)val;
+		return (u32)val;
 	case 8:
 		return (u64)val;
 	case 16:
@@ -585,15 +585,15 @@ static bool _cmpxchg(int size, void *target, __uint128_t *old_addr, __uint128_t
 
 	switch (size) {
 	case 4: {
-			uint32_t old = *old_addr;
+			u32 old = *old_addr;
 
 			asm volatile ("cs %[old],%[new],%[address]"
 			    : [old] "+d" (old),
-			      [address] "+Q" (*(uint32_t *)(target))
-			    : [new] "d" ((uint32_t)new)
+			      [address] "+Q" (*(u32 *)(target))
+			    : [new] "d" ((u32)new)
 			    : "cc"
 			);
-			ret = old == (uint32_t)*old_addr;
+			ret = old == (u32)*old_addr;
 			*old_addr = old;
 			return ret;
 		}
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index da0df43363ff..010359bd4712 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -345,8 +345,8 @@ static void test_zero_memory_regions(void)
 
 static void test_invalid_memory_region_flags(void)
 {
-	uint32_t supported_flags = KVM_MEM_LOG_DIRTY_PAGES;
-	const uint32_t v2_only_flags = KVM_MEM_GUEST_MEMFD;
+	u32 supported_flags = KVM_MEM_LOG_DIRTY_PAGES;
+	const u32 v2_only_flags = KVM_MEM_GUEST_MEMFD;
 	struct kvm_vm *vm;
 	int r, i;
 
@@ -410,8 +410,8 @@ static void test_add_max_memory_regions(void)
 {
 	int ret;
 	struct kvm_vm *vm;
-	uint32_t max_mem_slots;
-	uint32_t slot;
+	u32 max_mem_slots;
+	u32 slot;
 	void *mem, *mem_aligned, *mem_extra;
 	size_t alignment;
 
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 0777ef2b5399..9a4c23c6ba96 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -42,7 +42,7 @@ static void check_status(struct kvm_steal_time *st)
 static void guest_code(int cpu)
 {
 	struct kvm_steal_time *st = st_gva[cpu];
-	uint32_t version;
+	u32 version;
 
 	GUEST_ASSERT_EQ(rdmsr(MSR_KVM_STEAL_TIME), ((u64)st_gva[cpu] | KVM_MSR_ENABLED));
 
@@ -67,7 +67,7 @@ static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
 	return kvm_cpu_has(X86_FEATURE_KVM_STEAL_TIME);
 }
 
-static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
+static void steal_time_init(struct kvm_vcpu *vcpu, u32 i)
 {
 	int ret;
 
@@ -82,7 +82,7 @@ static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
 	vcpu_set_msr(vcpu, MSR_KVM_STEAL_TIME, (ulong)st_gva[i] | KVM_MSR_ENABLED);
 }
 
-static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
+static void steal_time_dump(struct kvm_vm *vm, u32 vcpu_idx)
 {
 	struct kvm_steal_time *st = addr_gva2hva(vm, (ulong)st_gva[vcpu_idx]);
 
@@ -109,12 +109,12 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 #define PV_TIME_ST		0xc5000021
 
 struct st_time {
-	uint32_t rev;
-	uint32_t attr;
+	u32 rev;
+	u32 attr;
 	u64 st_time;
 };
 
-static s64 smccc(uint32_t func, u64 arg)
+static s64 smccc(u32 func, u64 arg)
 {
 	struct arm_smccc_res res;
 
@@ -166,7 +166,7 @@ static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
 	return !__vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &dev);
 }
 
-static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
+static void steal_time_init(struct kvm_vcpu *vcpu, u32 i)
 {
 	struct kvm_vm *vm = vcpu->vm;
 	u64 st_ipa;
@@ -195,7 +195,7 @@ static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
 	TEST_ASSERT(ret == -1 && errno == EEXIST, "Set IPA twice without EEXIST");
 }
 
-static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
+static void steal_time_dump(struct kvm_vm *vm, u32 vcpu_idx)
 {
 	struct st_time *st = addr_gva2hva(vm, (ulong)st_gva[vcpu_idx]);
 
@@ -213,8 +213,8 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 static gpa_t st_gpa[NR_VCPUS];
 
 struct sta_struct {
-	uint32_t sequence;
-	uint32_t flags;
+	u32 sequence;
+	u32 flags;
 	u64 steal;
 	uint8_t preempted;
 	uint8_t pad[47];
@@ -243,7 +243,7 @@ static void check_status(struct sta_struct *st)
 static void guest_code(int cpu)
 {
 	struct sta_struct *st = st_gva[cpu];
-	uint32_t sequence;
+	u32 sequence;
 	long out_val = 0;
 	bool probe;
 
@@ -276,7 +276,7 @@ static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
 	return enabled;
 }
 
-static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
+static void steal_time_init(struct kvm_vcpu *vcpu, u32 i)
 {
 	/* ST_GPA_BASE is identity mapped */
 	st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
@@ -285,7 +285,7 @@ static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
 	sync_global_to_guest(vcpu->vm, st_gpa[i]);
 }
 
-static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
+static void steal_time_dump(struct kvm_vm *vm, u32 vcpu_idx)
 {
 	struct sta_struct *st = addr_gva2hva(vm, (ulong)st_gva[vcpu_idx]);
 	int i;
@@ -324,7 +324,7 @@ static void check_status(struct kvm_steal_time *st)
 
 static void guest_code(int cpu)
 {
-	uint32_t version;
+	u32 version;
 	struct kvm_steal_time *st = st_gva[cpu];
 
 	memset(st, 0, sizeof(*st));
@@ -364,7 +364,7 @@ static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
 	return val & BIT(KVM_FEATURE_STEAL_TIME);
 }
 
-static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
+static void steal_time_init(struct kvm_vcpu *vcpu, u32 i)
 {
 	int err;
 	u64 st_gpa;
@@ -387,7 +387,7 @@ static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
 	TEST_ASSERT(err == 0, "Fail to set PV stealtime GPA");
 }
 
-static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
+static void steal_time_dump(struct kvm_vm *vm, u32 vcpu_idx)
 {
 	struct kvm_steal_time *st = addr_gva2hva(vm, (ulong)st_gva[vcpu_idx]);
 
diff --git a/tools/testing/selftests/kvm/x86/amx_test.c b/tools/testing/selftests/kvm/x86/amx_test.c
index 5ac1c0d26f70..fce087b09b58 100644
--- a/tools/testing/selftests/kvm/x86/amx_test.c
+++ b/tools/testing/selftests/kvm/x86/amx_test.c
@@ -82,8 +82,8 @@ static inline void __tilerelease(void)
 
 static inline void __xsavec(struct xstate *xstate, u64 rfbm)
 {
-	uint32_t rfbm_lo = rfbm;
-	uint32_t rfbm_hi = rfbm >> 32;
+	u32 rfbm_lo = rfbm;
+	u32 rfbm_hi = rfbm >> 32;
 
 	asm volatile("xsavec (%%rdi)"
 		     : : "D" (xstate), "a" (rfbm_lo), "d" (rfbm_hi)
diff --git a/tools/testing/selftests/kvm/x86/aperfmperf_test.c b/tools/testing/selftests/kvm/x86/aperfmperf_test.c
index d3f21f2f5d28..620809cf35da 100644
--- a/tools/testing/selftests/kvm/x86/aperfmperf_test.c
+++ b/tools/testing/selftests/kvm/x86/aperfmperf_test.c
@@ -35,7 +35,7 @@ static int open_dev_msr(int cpu)
 	return open_path_or_exit(path, O_RDONLY);
 }
 
-static u64 read_dev_msr(int msr_fd, uint32_t msr)
+static u64 read_dev_msr(int msr_fd, u32 msr)
 {
 	u64 data;
 	ssize_t rc;
diff --git a/tools/testing/selftests/kvm/x86/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86/apic_bus_clock_test.c
index 81f76c7d5621..404f0028e110 100644
--- a/tools/testing/selftests/kvm/x86/apic_bus_clock_test.c
+++ b/tools/testing/selftests/kvm/x86/apic_bus_clock_test.c
@@ -19,8 +19,8 @@
  * timer frequency.
  */
 static const struct {
-	const uint32_t tdcr;
-	const uint32_t divide_count;
+	const u32 tdcr;
+	const u32 divide_count;
 } tdcrs[] = {
 	{0x0, 2},
 	{0x1, 4},
@@ -42,12 +42,12 @@ static void apic_enable(void)
 		xapic_enable();
 }
 
-static uint32_t apic_read_reg(unsigned int reg)
+static u32 apic_read_reg(unsigned int reg)
 {
 	return is_x2apic ? x2apic_read_reg(reg) : xapic_read_reg(reg);
 }
 
-static void apic_write_reg(unsigned int reg, uint32_t val)
+static void apic_write_reg(unsigned int reg, u32 val)
 {
 	if (is_x2apic)
 		x2apic_write_reg(reg, val);
@@ -58,9 +58,9 @@ static void apic_write_reg(unsigned int reg, uint32_t val)
 static void apic_guest_code(u64 apic_hz, u64 delay_ms)
 {
 	u64 tsc_hz = guest_tsc_khz * 1000;
-	const uint32_t tmict = ~0u;
+	const u32 tmict = ~0u;
 	u64 tsc0, tsc1, freq;
-	uint32_t tmcct;
+	u32 tmcct;
 	int i;
 
 	apic_enable();
diff --git a/tools/testing/selftests/kvm/x86/debug_regs.c b/tools/testing/selftests/kvm/x86/debug_regs.c
index 542a0eac0f32..0dfaf03cd0a0 100644
--- a/tools/testing/selftests/kvm/x86/debug_regs.c
+++ b/tools/testing/selftests/kvm/x86/debug_regs.c
@@ -16,7 +16,7 @@
 #define IRQ_VECTOR 0xAA
 
 /* For testing data access debug BP */
-uint32_t guest_value;
+u32 guest_value;
 
 extern unsigned char sw_bp, hw_bp, write_data, ss_start, bd_start;
 
diff --git a/tools/testing/selftests/kvm/x86/fastops_test.c b/tools/testing/selftests/kvm/x86/fastops_test.c
index 51416328cc69..a634bc281546 100644
--- a/tools/testing/selftests/kvm/x86/fastops_test.c
+++ b/tools/testing/selftests/kvm/x86/fastops_test.c
@@ -15,7 +15,7 @@
 	"pop %[flags]\n\t"
 
 #define flags_constraint(flags_val) [flags]"=r"(flags_val)
-#define bt_constraint(__bt_val) [bt_val]"rm"((uint32_t)__bt_val)
+#define bt_constraint(__bt_val) [bt_val]"rm"((u32)__bt_val)
 
 #define guest_execute_fastop_1(FEP, insn, __val, __flags)				\
 ({											\
@@ -187,7 +187,7 @@ static void guest_code(void)
 {
 	guest_test_fastops(uint8_t, "b");
 	guest_test_fastops(uint16_t, "w");
-	guest_test_fastops(uint32_t, "l");
+	guest_test_fastops(u32, "l");
 	guest_test_fastops(u64, "q");
 
 	GUEST_DONE();
diff --git a/tools/testing/selftests/kvm/x86/feature_msrs_test.c b/tools/testing/selftests/kvm/x86/feature_msrs_test.c
index a0e54af60544..158550701771 100644
--- a/tools/testing/selftests/kvm/x86/feature_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/feature_msrs_test.c
@@ -12,7 +12,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-static bool is_kvm_controlled_msr(uint32_t msr)
+static bool is_kvm_controlled_msr(u32 msr)
 {
 	return msr == MSR_IA32_VMX_CR0_FIXED1 || msr == MSR_IA32_VMX_CR4_FIXED1;
 }
@@ -21,7 +21,7 @@ static bool is_kvm_controlled_msr(uint32_t msr)
  * For VMX MSRs with a "true" variant, KVM requires userspace to set the "true"
  * MSR, and doesn't allow setting the hidden version.
  */
-static bool is_hidden_vmx_msr(uint32_t msr)
+static bool is_hidden_vmx_msr(u32 msr)
 {
 	switch (msr) {
 	case MSR_IA32_VMX_PINBASED_CTLS:
@@ -34,12 +34,12 @@ static bool is_hidden_vmx_msr(uint32_t msr)
 	}
 }
 
-static bool is_quirked_msr(uint32_t msr)
+static bool is_quirked_msr(u32 msr)
 {
 	return msr != MSR_AMD64_DE_CFG;
 }
 
-static void test_feature_msr(uint32_t msr)
+static void test_feature_msr(u32 msr)
 {
 	const u64 supported_mask = kvm_get_feature_msr(msr);
 	u64 reset_value = is_quirked_msr(msr) ? supported_mask : 0;
diff --git a/tools/testing/selftests/kvm/x86/hyperv_evmcs.c b/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
index 9fa91b0f168a..9b4b46a0322e 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
@@ -30,7 +30,7 @@ static void guest_nmi_handler(struct ex_regs *regs)
 {
 }
 
-static inline void rdmsr_from_l2(uint32_t msr)
+static inline void rdmsr_from_l2(u32 msr)
 {
 	/* Currently, L1 doesn't preserve GPRs during vmexits. */
 	__asm__ __volatile__ ("rdmsr" : : "c"(msr) :
diff --git a/tools/testing/selftests/kvm/x86/hyperv_features.c b/tools/testing/selftests/kvm/x86/hyperv_features.c
index b5dc6df55775..856c8efcce38 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_features.c
@@ -22,7 +22,7 @@
 	KVM_X86_CPU_FEATURE(HYPERV_CPUID_ENLIGHTMENT_INFO, 0, EBX, 0)
 
 struct msr_data {
-	uint32_t idx;
+	u32 idx;
 	bool fault_expected;
 	bool write;
 	u64 write_val;
@@ -34,7 +34,7 @@ struct hcall_data {
 	bool ud_expected;
 };
 
-static bool is_write_only_msr(uint32_t msr)
+static bool is_write_only_msr(u32 msr)
 {
 	return msr == HV_X64_MSR_EOI;
 }
diff --git a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
index b7f35424c838..36fedadd7b6c 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
@@ -21,7 +21,7 @@
 #define L2_GUEST_STACK_SIZE 256
 
 /* Exit to L1 from L2 with RDMSR instruction */
-static inline void rdmsr_from_l2(uint32_t msr)
+static inline void rdmsr_from_l2(u32 msr)
 {
 	/* Currently, L1 doesn't preserve GPRs during vmexits. */
 	__asm__ __volatile__ ("rdmsr" : : "c"(msr) :
diff --git a/tools/testing/selftests/kvm/x86/kvm_pv_test.c b/tools/testing/selftests/kvm/x86/kvm_pv_test.c
index e49ae65f8171..babf0f95165a 100644
--- a/tools/testing/selftests/kvm/x86/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86/kvm_pv_test.c
@@ -13,7 +13,7 @@
 #include "processor.h"
 
 struct msr_data {
-	uint32_t idx;
+	u32 idx;
 	const char *name;
 };
 
diff --git a/tools/testing/selftests/kvm/x86/nested_emulation_test.c b/tools/testing/selftests/kvm/x86/nested_emulation_test.c
index d398add21e4c..42fd24567e26 100644
--- a/tools/testing/selftests/kvm/x86/nested_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_emulation_test.c
@@ -14,7 +14,7 @@ enum {
 struct emulated_instruction {
 	const char name[32];
 	uint8_t opcode[15];
-	uint32_t exit_reason[NR_VIRTUALIZATION_FLAVORS];
+	u32 exit_reason[NR_VIRTUALIZATION_FLAVORS];
 };
 
 static struct emulated_instruction instructions[] = {
@@ -36,9 +36,9 @@ static uint8_t kvm_fep[] = { 0x0f, 0x0b, 0x6b, 0x76, 0x6d };	/* ud2 ; .ascii "kv
 static uint8_t l2_guest_code[sizeof(kvm_fep) + 15];
 static uint8_t *l2_instruction = &l2_guest_code[sizeof(kvm_fep)];
 
-static uint32_t get_instruction_length(struct emulated_instruction *insn)
+static u32 get_instruction_length(struct emulated_instruction *insn)
 {
-	uint32_t i;
+	u32 i;
 
 	for (i = 0; i < ARRAY_SIZE(insn->opcode) && insn->opcode[i]; i++)
 		;
@@ -81,8 +81,8 @@ static void guest_code(void *test_data)
 
 	for (i = 0; i < ARRAY_SIZE(instructions); i++) {
 		struct emulated_instruction *insn = &instructions[i];
-		uint32_t insn_len = get_instruction_length(insn);
-		uint32_t exit_insn_len;
+		u32 insn_len = get_instruction_length(insn);
+		u32 exit_insn_len;
 		u32 exit_reason;
 
 		/*
diff --git a/tools/testing/selftests/kvm/x86/nested_exceptions_test.c b/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
index 646cfb0022b3..186e980aa8ee 100644
--- a/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
@@ -72,7 +72,7 @@ static void l2_ss_injected_tf_test(void)
 }
 
 static void svm_run_l2(struct svm_test_data *svm, void *l2_code, int vector,
-		       uint32_t error_code)
+		       u32 error_code)
 {
 	struct vmcb *vmcb = svm->vmcb;
 	struct vmcb_control_area *ctrl = &vmcb->control;
@@ -111,7 +111,7 @@ static void l1_svm_code(struct svm_test_data *svm)
 	GUEST_DONE();
 }
 
-static void vmx_run_l2(void *l2_code, int vector, uint32_t error_code)
+static void vmx_run_l2(void *l2_code, int vector, u32 error_code)
 {
 	GUEST_ASSERT(!vmwrite(GUEST_RIP, (u64)l2_code));
 
diff --git a/tools/testing/selftests/kvm/x86/nested_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86/nested_tsc_adjust_test.c
index a18b0cfd42e2..f0e4adac4751 100644
--- a/tools/testing/selftests/kvm/x86/nested_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_tsc_adjust_test.c
@@ -88,7 +88,7 @@ static void l1_guest_code(void *data)
 	 */
 	if (this_cpu_has(X86_FEATURE_VMX)) {
 		struct vmx_pages *vmx_pages = data;
-		uint32_t control;
+		u32 control;
 
 		GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
 		GUEST_ASSERT(load_vmcs(vmx_pages));
diff --git a/tools/testing/selftests/kvm/x86/nested_tsc_scaling_test.c b/tools/testing/selftests/kvm/x86/nested_tsc_scaling_test.c
index b37b0fef7fde..190e93af20a1 100644
--- a/tools/testing/selftests/kvm/x86/nested_tsc_scaling_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_tsc_scaling_test.c
@@ -106,7 +106,7 @@ static void l1_svm_code(struct svm_test_data *svm)
 static void l1_vmx_code(struct vmx_pages *vmx_pages)
 {
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
-	uint32_t control;
+	u32 control;
 
 	/* check that L1's frequency looks alright before launching L2 */
 	check_tsc_freq(UCHECK_L1);
diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index 16fabcf1eabd..2a12c2d42697 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -30,7 +30,7 @@
 #define NUM_INSNS_RETIRED		(NUM_LOOPS * NUM_INSNS_PER_LOOP + NUM_EXTRA_INSNS)
 
 /* Track which architectural events are supported by hardware. */
-static uint32_t hardware_pmu_arch_events;
+static u32 hardware_pmu_arch_events;
 
 static uint8_t kvm_pmu_version;
 static bool kvm_has_perf_caps;
@@ -153,7 +153,7 @@ static uint8_t guest_get_pmu_version(void)
  * Sanity check that in all cases, the event doesn't count when it's disabled,
  * and that KVM correctly emulates the write of an arbitrary value.
  */
-static void guest_assert_event_count(uint8_t idx, uint32_t pmc, uint32_t pmc_msr)
+static void guest_assert_event_count(uint8_t idx, u32 pmc, u32 pmc_msr)
 {
 	u64 count;
 
@@ -236,7 +236,7 @@ do {										\
 			     FEP "xor %%eax, %%eax\n\t"				\
 			     FEP "xor %%edx, %%edx\n\t"				\
 			     "wrmsr\n\t"					\
-			     :: "a"((uint32_t)_value), "d"(_value >> 32),	\
+			     :: "a"((u32)_value), "d"(_value >> 32),	\
 				"c"(_msr), "D"(_msr), [m]"m"(kvm_pmu_version)	\
 	);									\
 } while (0)
@@ -255,8 +255,8 @@ do {										\
 	guest_assert_event_count(_idx, _pmc, _pmc_msr);				\
 } while (0)
 
-static void __guest_test_arch_event(uint8_t idx, uint32_t pmc, uint32_t pmc_msr,
-				    uint32_t ctrl_msr, u64 ctrl_msr_value)
+static void __guest_test_arch_event(uint8_t idx, u32 pmc, u32 pmc_msr,
+				    u32 ctrl_msr, u64 ctrl_msr_value)
 {
 	GUEST_TEST_EVENT(idx, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, "");
 
@@ -266,12 +266,12 @@ static void __guest_test_arch_event(uint8_t idx, uint32_t pmc, uint32_t pmc_msr,
 
 static void guest_test_arch_event(uint8_t idx)
 {
-	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
-	uint32_t pmu_version = guest_get_pmu_version();
+	u32 nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
+	u32 pmu_version = guest_get_pmu_version();
 	/* PERF_GLOBAL_CTRL exists only for Architectural PMU Version 2+. */
 	bool guest_has_perf_global_ctrl = pmu_version >= 2;
 	struct kvm_x86_pmu_feature gp_event, fixed_event;
-	uint32_t base_pmc_msr;
+	u32 base_pmc_msr;
 	unsigned int i;
 
 	/* The host side shouldn't invoke this without a guest PMU. */
@@ -329,7 +329,7 @@ static void guest_test_arch_events(void)
 }
 
 static void test_arch_events(uint8_t pmu_version, u64 perf_capabilities,
-			     uint8_t length, uint32_t unavailable_mask)
+			     uint8_t length, u32 unavailable_mask)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -373,7 +373,7 @@ __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
 		       "Expected " #insn "(0x%x) to yield 0x%lx, got 0x%lx",	\
 		       msr, expected, val);
 
-static void guest_test_rdpmc(uint32_t rdpmc_idx, bool expect_success,
+static void guest_test_rdpmc(u32 rdpmc_idx, bool expect_success,
 			     u64 expected_val)
 {
 	uint8_t vector;
@@ -393,8 +393,8 @@ static void guest_test_rdpmc(uint32_t rdpmc_idx, bool expect_success,
 		GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
 }
 
-static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
-				 uint8_t nr_counters, uint32_t or_mask)
+static void guest_rd_wr_counters(u32 base_msr, uint8_t nr_possible_counters,
+				 uint8_t nr_counters, u32 or_mask)
 {
 	const bool pmu_has_fast_mode = !guest_get_pmu_version();
 	uint8_t i;
@@ -405,7 +405,7 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		 * width of the counters.
 		 */
 		const u64 test_val = 0xffff;
-		const uint32_t msr = base_msr + i;
+		const u32 msr = base_msr + i;
 
 		/*
 		 * Fixed counters are supported if the counter is less than the
@@ -421,7 +421,7 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		const u64 expected_val = expect_success ? test_val : 0;
 		const bool expect_gp = !expect_success && msr != MSR_P6_PERFCTR0 &&
 				       msr != MSR_P6_PERFCTR1;
-		uint32_t rdpmc_idx;
+		u32 rdpmc_idx;
 		uint8_t vector;
 		u64 val;
 
@@ -463,7 +463,7 @@ static void guest_test_gp_counters(void)
 {
 	uint8_t pmu_version = guest_get_pmu_version();
 	uint8_t nr_gp_counters = 0;
-	uint32_t base_msr;
+	u32 base_msr;
 
 	if (pmu_version)
 		nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
@@ -563,7 +563,7 @@ static void guest_test_fixed_counters(void)
 
 static void test_fixed_counters(uint8_t pmu_version, u64 perf_capabilities,
 				uint8_t nr_fixed_counters,
-				uint32_t supported_bitmask)
+				u32 supported_bitmask)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -588,7 +588,7 @@ static void test_intel_counters(void)
 	uint8_t pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
 	unsigned int i;
 	uint8_t v, j;
-	uint32_t k;
+	u32 k;
 
 	const u64 perf_caps[] = {
 		0,
@@ -602,7 +602,7 @@ static void test_intel_counters(void)
 	 * as alternating bit sequencues, e.g. to detect if KVM is checking the
 	 * wrong bit(s).
 	 */
-	const uint32_t unavailable_masks[] = {
+	const u32 unavailable_masks[] = {
 		0x0,
 		0xffffffffu,
 		0xaaaaaaaau,
diff --git a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
index 93c7aa456043..0a02a7be9d82 100644
--- a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
@@ -75,7 +75,7 @@ static void guest_gp_handler(struct ex_regs *regs)
  *
  * Return on success. GUEST_SYNC(0) on error.
  */
-static void check_msr(uint32_t msr, u64 bits_to_flip)
+static void check_msr(u32 msr, u64 bits_to_flip)
 {
 	u64 v = rdmsr(msr) ^ bits_to_flip;
 
@@ -89,7 +89,7 @@ static void check_msr(uint32_t msr, u64 bits_to_flip)
 		GUEST_SYNC(-EIO);
 }
 
-static void run_and_measure_loop(uint32_t msr_base)
+static void run_and_measure_loop(u32 msr_base)
 {
 	const u64 branches_retired = rdmsr(msr_base + 0);
 	const u64 insn_retired = rdmsr(msr_base + 1);
@@ -377,7 +377,7 @@ static bool use_amd_pmu(void)
 
 static bool supports_event_mem_inst_retired(void)
 {
-	uint32_t eax, ebx, ecx, edx;
+	u32 eax, ebx, ecx, edx;
 
 	cpuid(1, &eax, &ebx, &ecx, &edx);
 	if (x86_family(eax) == 0x6) {
@@ -414,7 +414,7 @@ static bool supports_event_mem_inst_retired(void)
 #define EXCLUDE_MASKED_ENTRY(event_select, mask, match) \
 	KVM_PMU_ENCODE_MASKED_ENTRY(event_select, mask, match, true)
 
-static void masked_events_guest_test(uint32_t msr_base)
+static void masked_events_guest_test(u32 msr_base)
 {
 	/*
 	 * The actual value of the counters don't determine the outcome of
@@ -498,7 +498,7 @@ struct masked_events_test {
 	u64 amd_events[MAX_TEST_EVENTS];
 	u64 amd_event_end;
 	const char *msg;
-	uint32_t flags;
+	u32 flags;
 };
 
 /*
@@ -668,7 +668,7 @@ static int set_pmu_event_filter(struct kvm_vcpu *vcpu,
 }
 
 static int set_pmu_single_event_filter(struct kvm_vcpu *vcpu, u64 event,
-				       uint32_t flags, uint32_t action)
+				       u32 flags, u32 action)
 {
 	struct __kvm_pmu_event_filter f = {
 		.nevents = 1,
@@ -745,7 +745,7 @@ static void intel_run_fixed_counter_guest_code(uint8_t idx)
 }
 
 static u64 test_with_fixed_counter_filter(struct kvm_vcpu *vcpu,
-					  uint32_t action, uint32_t bitmap)
+					  u32 action, u32 bitmap)
 {
 	struct __kvm_pmu_event_filter f = {
 		.action = action,
@@ -757,8 +757,8 @@ static u64 test_with_fixed_counter_filter(struct kvm_vcpu *vcpu,
 }
 
 static u64 test_set_gp_and_fixed_event_filter(struct kvm_vcpu *vcpu,
-					      uint32_t action,
-					      uint32_t bitmap)
+					      u32 action,
+					      u32 bitmap)
 {
 	struct __kvm_pmu_event_filter f = base_event_filter;
 
@@ -773,7 +773,7 @@ static void __test_fixed_counter_bitmap(struct kvm_vcpu *vcpu, uint8_t idx,
 					uint8_t nr_fixed_counters)
 {
 	unsigned int i;
-	uint32_t bitmap;
+	u32 bitmap;
 	u64 count;
 
 	TEST_ASSERT(nr_fixed_counters < sizeof(bitmap) * 8,
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 2e3a68837d0e..0bf86d822ee0 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -366,8 +366,8 @@ static void *__test_mem_conversions(void *__vcpu)
 	}
 }
 
-static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t nr_vcpus,
-				 uint32_t nr_memslots)
+static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_vcpus,
+				 u32 nr_memslots)
 {
 	/*
 	 * Allocate enough memory so that each vCPU's chunk of memory can be
@@ -450,8 +450,8 @@ static void usage(const char *cmd)
 int main(int argc, char *argv[])
 {
 	enum vm_mem_backing_src_type src_type = DEFAULT_VM_MEM_SRC;
-	uint32_t nr_memslots = 1;
-	uint32_t nr_vcpus = 1;
+	u32 nr_memslots = 1;
+	u32 nr_vcpus = 1;
 	int opt;
 
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
diff --git a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
index 925040f394de..10db9fe6d906 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
@@ -27,7 +27,7 @@ static u64 guest_repeatedly_read(void)
 	return value;
 }
 
-static uint32_t run_vcpu_get_exit_reason(struct kvm_vcpu *vcpu)
+static u32 run_vcpu_get_exit_reason(struct kvm_vcpu *vcpu)
 {
 	int r;
 
@@ -50,7 +50,7 @@ static void test_private_access_memslot_deleted(void)
 	struct kvm_vcpu *vcpu;
 	pthread_t vm_thread;
 	void *thread_return;
-	uint32_t exit_reason;
+	u32 exit_reason;
 
 	vm = vm_create_shape_with_one_vcpu(protected_vm_shape, &vcpu,
 					   guest_repeatedly_read);
@@ -72,7 +72,7 @@ static void test_private_access_memslot_deleted(void)
 	vm_mem_region_delete(vm, EXITS_TEST_SLOT);
 
 	pthread_join(vm_thread, &thread_return);
-	exit_reason = (uint32_t)(u64)thread_return;
+	exit_reason = (u32)(u64)thread_return;
 
 	TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MEMORY_FAULT);
 	TEST_ASSERT_EQ(vcpu->run->memory_fault.flags, KVM_MEMORY_EXIT_FLAG_PRIVATE);
@@ -86,7 +86,7 @@ static void test_private_access_memslot_not_private(void)
 {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
-	uint32_t exit_reason;
+	u32 exit_reason;
 
 	vm = vm_create_shape_with_one_vcpu(protected_vm_shape, &vcpu,
 					   guest_repeatedly_read);
diff --git a/tools/testing/selftests/kvm/x86/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86/set_boot_cpu_id.c
index 49913784bc82..8e3898646c69 100644
--- a/tools/testing/selftests/kvm/x86/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86/set_boot_cpu_id.c
@@ -86,11 +86,11 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
 	}
 }
 
-static struct kvm_vm *create_vm(uint32_t nr_vcpus, uint32_t bsp_vcpu_id,
+static struct kvm_vm *create_vm(u32 nr_vcpus, u32 bsp_vcpu_id,
 				struct kvm_vcpu *vcpus[])
 {
 	struct kvm_vm *vm;
-	uint32_t i;
+	u32 i;
 
 	vm = vm_create(nr_vcpus);
 
@@ -104,7 +104,7 @@ static struct kvm_vm *create_vm(uint32_t nr_vcpus, uint32_t bsp_vcpu_id,
 	return vm;
 }
 
-static void run_vm_bsp(uint32_t bsp_vcpu_id)
+static void run_vm_bsp(u32 bsp_vcpu_id)
 {
 	struct kvm_vcpu *vcpus[2];
 	struct kvm_vm *vm;
diff --git a/tools/testing/selftests/kvm/x86/sev_init2_tests.c b/tools/testing/selftests/kvm/x86/sev_init2_tests.c
index eec093819ff3..8eeba2327c7c 100644
--- a/tools/testing/selftests/kvm/x86/sev_init2_tests.c
+++ b/tools/testing/selftests/kvm/x86/sev_init2_tests.c
@@ -94,7 +94,7 @@ void test_vm_types(void)
 				   "VM type is KVM_X86_SW_PROTECTED_VM");
 }
 
-void test_flags(uint32_t vm_type)
+void test_flags(u32 vm_type)
 {
 	int i;
 
@@ -104,7 +104,7 @@ void test_flags(uint32_t vm_type)
 			"invalid flag");
 }
 
-void test_features(uint32_t vm_type, u64 supported_features)
+void test_features(u32 vm_type, u64 supported_features)
 {
 	int i;
 
diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index 0cec907323d7..352190bd1085 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -74,7 +74,7 @@ static void compare_xsave(u8 *from_host, u8 *from_guest)
 		abort();
 }
 
-static void test_sync_vmsa(uint32_t type, u64 policy)
+static void test_sync_vmsa(u32 type, u64 policy)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -120,7 +120,7 @@ static void test_sync_vmsa(uint32_t type, u64 policy)
 	kvm_vm_free(vm);
 }
 
-static void test_sev(void *guest_code, uint32_t type, u64 policy)
+static void test_sev(void *guest_code, u32 type, u64 policy)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -171,7 +171,7 @@ static void guest_shutdown_code(void)
 	__asm__ __volatile__("ud2");
 }
 
-static void test_sev_shutdown(uint32_t type, u64 policy)
+static void test_sev_shutdown(u32 type, u64 policy)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -188,7 +188,7 @@ static void test_sev_shutdown(uint32_t type, u64 policy)
 	kvm_vm_free(vm);
 }
 
-static void test_sev_smoke(void *guest, uint32_t type, u64 policy)
+static void test_sev_smoke(void *guest, u32 type, u64 policy)
 {
 	const u64 xf_mask = XFEATURE_MASK_X87_AVX;
 
diff --git a/tools/testing/selftests/kvm/x86/ucna_injection_test.c b/tools/testing/selftests/kvm/x86/ucna_injection_test.c
index 27aae6c92a38..df1ec8209c76 100644
--- a/tools/testing/selftests/kvm/x86/ucna_injection_test.c
+++ b/tools/testing/selftests/kvm/x86/ucna_injection_test.c
@@ -251,7 +251,7 @@ static void setup_mce_cap(struct kvm_vcpu *vcpu, bool enable_cmci_p)
 	vcpu_ioctl(vcpu, KVM_X86_SETUP_MCE, &mcg_caps);
 }
 
-static struct kvm_vcpu *create_vcpu_with_mce_cap(struct kvm_vm *vm, uint32_t vcpuid,
+static struct kvm_vcpu *create_vcpu_with_mce_cap(struct kvm_vm *vm, u32 vcpuid,
 						 bool enable_cmci_p, void *guest_code)
 {
 	struct kvm_vcpu *vcpu = vm_vcpu_add(vm, vcpuid, guest_code);
diff --git a/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
index b673c3450886..98b8d285dbb7 100644
--- a/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
@@ -142,9 +142,9 @@ struct kvm_msr_filter no_filter_deny = {
  * Note: Force test_rdmsr() to not be inlined to prevent the labels,
  * rdmsr_start and rdmsr_end, from being defined multiple times.
  */
-static noinline u64 test_rdmsr(uint32_t msr)
+static noinline u64 test_rdmsr(u32 msr)
 {
-	uint32_t a, d;
+	u32 a, d;
 
 	guest_exception_count = 0;
 
@@ -158,10 +158,10 @@ static noinline u64 test_rdmsr(uint32_t msr)
  * Note: Force test_wrmsr() to not be inlined to prevent the labels,
  * wrmsr_start and wrmsr_end, from being defined multiple times.
  */
-static noinline void test_wrmsr(uint32_t msr, u64 value)
+static noinline void test_wrmsr(u32 msr, u64 value)
 {
-	uint32_t a = value;
-	uint32_t d = value >> 32;
+	u32 a = value;
+	u32 d = value >> 32;
 
 	guest_exception_count = 0;
 
@@ -176,9 +176,9 @@ extern char wrmsr_start, wrmsr_end;
  * Note: Force test_em_rdmsr() to not be inlined to prevent the labels,
  * rdmsr_start and rdmsr_end, from being defined multiple times.
  */
-static noinline u64 test_em_rdmsr(uint32_t msr)
+static noinline u64 test_em_rdmsr(u32 msr)
 {
-	uint32_t a, d;
+	u32 a, d;
 
 	guest_exception_count = 0;
 
@@ -192,10 +192,10 @@ static noinline u64 test_em_rdmsr(uint32_t msr)
  * Note: Force test_em_wrmsr() to not be inlined to prevent the labels,
  * wrmsr_start and wrmsr_end, from being defined multiple times.
  */
-static noinline void test_em_wrmsr(uint32_t msr, u64 value)
+static noinline void test_em_wrmsr(u32 msr, u64 value)
 {
-	uint32_t a = value;
-	uint32_t d = value >> 32;
+	u32 a = value;
+	u32 d = value >> 32;
 
 	guest_exception_count = 0;
 
@@ -391,7 +391,7 @@ static void check_for_guest_assert(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void process_rdmsr(struct kvm_vcpu *vcpu, uint32_t msr_index)
+static void process_rdmsr(struct kvm_vcpu *vcpu, u32 msr_index)
 {
 	struct kvm_run *run = vcpu->run;
 
@@ -423,7 +423,7 @@ static void process_rdmsr(struct kvm_vcpu *vcpu, uint32_t msr_index)
 	}
 }
 
-static void process_wrmsr(struct kvm_vcpu *vcpu, uint32_t msr_index)
+static void process_wrmsr(struct kvm_vcpu *vcpu, u32 msr_index)
 {
 	struct kvm_run *run = vcpu->run;
 
@@ -489,14 +489,14 @@ static u64 process_ucall(struct kvm_vcpu *vcpu)
 }
 
 static void run_guest_then_process_rdmsr(struct kvm_vcpu *vcpu,
-					 uint32_t msr_index)
+					 u32 msr_index)
 {
 	vcpu_run(vcpu);
 	process_rdmsr(vcpu, msr_index);
 }
 
 static void run_guest_then_process_wrmsr(struct kvm_vcpu *vcpu,
-					 uint32_t msr_index)
+					 u32 msr_index)
 {
 	vcpu_run(vcpu);
 	process_wrmsr(vcpu, msr_index);
diff --git a/tools/testing/selftests/kvm/x86/vmx_apic_access_test.c b/tools/testing/selftests/kvm/x86/vmx_apic_access_test.c
index dc5c3d1db346..1720113eae79 100644
--- a/tools/testing/selftests/kvm/x86/vmx_apic_access_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_apic_access_test.c
@@ -38,7 +38,7 @@ static void l1_guest_code(struct vmx_pages *vmx_pages, unsigned long high_gpa)
 {
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
-	uint32_t control;
+	u32 control;
 
 	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
 	GUEST_ASSERT(load_vmcs(vmx_pages));
diff --git a/tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c b/tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c
index 7f84cc92feaf..80a4fd1e5bbb 100644
--- a/tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c
@@ -33,7 +33,7 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 {
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
-	uint32_t control;
+	u32 control;
 
 	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
 	GUEST_ASSERT(load_vmcs(vmx_pages));
diff --git a/tools/testing/selftests/kvm/x86/vmx_msrs_test.c b/tools/testing/selftests/kvm/x86/vmx_msrs_test.c
index d61c8c69ade3..c1e8632a1bb6 100644
--- a/tools/testing/selftests/kvm/x86/vmx_msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_msrs_test.c
@@ -12,8 +12,7 @@
 #include "kvm_util.h"
 #include "vmx.h"
 
-static void vmx_fixed1_msr_test(struct kvm_vcpu *vcpu, uint32_t msr_index,
-				  u64 mask)
+static void vmx_fixed1_msr_test(struct kvm_vcpu *vcpu, u32 msr_index, u64 mask)
 {
 	u64 val = vcpu_get_msr(vcpu, msr_index);
 	u64 bit;
@@ -26,8 +25,7 @@ static void vmx_fixed1_msr_test(struct kvm_vcpu *vcpu, uint32_t msr_index,
 	}
 }
 
-static void vmx_fixed0_msr_test(struct kvm_vcpu *vcpu, uint32_t msr_index,
-				u64 mask)
+static void vmx_fixed0_msr_test(struct kvm_vcpu *vcpu, u32 msr_index, u64 mask)
 {
 	u64 val = vcpu_get_msr(vcpu, msr_index);
 	u64 bit;
@@ -40,7 +38,7 @@ static void vmx_fixed0_msr_test(struct kvm_vcpu *vcpu, uint32_t msr_index,
 	}
 }
 
-static void vmx_fixed0and1_msr_test(struct kvm_vcpu *vcpu, uint32_t msr_index)
+static void vmx_fixed0and1_msr_test(struct kvm_vcpu *vcpu, u32 msr_index)
 {
 	vmx_fixed0_msr_test(vcpu, msr_index, GENMASK_ULL(31, 0));
 	vmx_fixed1_msr_test(vcpu, msr_index, GENMASK_ULL(63, 32));
diff --git a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
index add329a3026e..31a0862d352d 100644
--- a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
@@ -52,16 +52,16 @@ static volatile u64 ipis_rcvd;
 
 /* Data struct shared between host main thread and vCPUs */
 struct test_data_page {
-	uint32_t halter_apic_id;
+	u32 halter_apic_id;
 	volatile u64 hlt_count;
 	volatile u64 wake_count;
 	u64 ipis_sent;
 	u64 migrations_attempted;
 	u64 migrations_completed;
-	uint32_t icr;
-	uint32_t icr2;
-	uint32_t halter_tpr;
-	uint32_t halter_ppr;
+	u32 icr;
+	u32 icr2;
+	u32 halter_tpr;
+	u32 halter_ppr;
 
 	/*
 	 *  Record local version register as a cross-check that APIC access
@@ -69,7 +69,7 @@ struct test_data_page {
 	 *  arch/x86/kvm/lapic.c). If test is failing, check that values match
 	 *  to determine whether APIC access exits are working.
 	 */
-	uint32_t halter_lvr;
+	u32 halter_lvr;
 };
 
 struct thread_params {
@@ -128,8 +128,8 @@ static void sender_guest_code(struct test_data_page *data)
 	u64 last_wake_count;
 	u64 last_hlt_count;
 	u64 last_ipis_rcvd_count;
-	uint32_t icr_val;
-	uint32_t icr2_val;
+	u32 icr_val;
+	u32 icr2_val;
 	u64 tsc_start;
 
 	verify_apic_base_addr();
diff --git a/tools/testing/selftests/kvm/x86/xapic_state_test.c b/tools/testing/selftests/kvm/x86/xapic_state_test.c
index b935f525d9d0..bf657e5c5aa5 100644
--- a/tools/testing/selftests/kvm/x86/xapic_state_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_state_test.c
@@ -144,7 +144,7 @@ static void test_icr(struct xapic_vcpu *x)
 
 static void __test_apic_id(struct kvm_vcpu *vcpu, u64 apic_base)
 {
-	uint32_t apic_id, expected;
+	u32 apic_id, expected;
 	struct kvm_lapic_state xapic;
 
 	vcpu_set_msr(vcpu, MSR_IA32_APICBASE, apic_base);
@@ -170,7 +170,7 @@ static void __test_apic_id(struct kvm_vcpu *vcpu, u64 apic_base)
  */
 static void test_apic_id(void)
 {
-	const uint32_t NR_VCPUS = 3;
+	const u32 NR_VCPUS = 3;
 	struct kvm_vcpu *vcpus[NR_VCPUS];
 	u64 apic_base;
 	struct kvm_vm *vm;
diff --git a/tools/testing/selftests/kvm/x86/xapic_tpr_test.c b/tools/testing/selftests/kvm/x86/xapic_tpr_test.c
index 14052e94d553..af1fe833ad4f 100644
--- a/tools/testing/selftests/kvm/x86/xapic_tpr_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_tpr_test.c
@@ -58,7 +58,7 @@ static void tpr_guest_irq_queue(void)
 	if (is_x2apic) {
 		x2apic_write_reg(APIC_SELF_IPI, IRQ_VECTOR);
 	} else {
-		uint32_t icr, icr2;
+		u32 icr, icr2;
 
 		icr = APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED |
 			IRQ_VECTOR;
@@ -71,7 +71,7 @@ static void tpr_guest_irq_queue(void)
 
 static uint8_t tpr_guest_tpr_get(void)
 {
-	uint32_t taskpri;
+	u32 taskpri;
 
 	if (is_x2apic)
 		taskpri = x2apic_read_reg(APIC_TASKPRI);
@@ -83,7 +83,7 @@ static uint8_t tpr_guest_tpr_get(void)
 
 static uint8_t tpr_guest_ppr_get(void)
 {
-	uint32_t procpri;
+	u32 procpri;
 
 	if (is_x2apic)
 		procpri = x2apic_read_reg(APIC_PROCPRI);
diff --git a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
index 83aab75ac792..c6d00205b59d 100644
--- a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
@@ -116,13 +116,13 @@ struct pvclock_wall_clock {
 } __attribute__((__packed__));
 
 struct vcpu_runstate_info {
-	uint32_t state;
+	u32 state;
 	u64 state_entry_time;
 	u64 time[5]; /* Extra field for overrun check */
 };
 
 struct compat_vcpu_runstate_info {
-	uint32_t state;
+	u32 state;
 	u64 state_entry_time;
 	u64 time[5];
 } __attribute__((__packed__));
@@ -145,7 +145,7 @@ struct shared_info {
 	unsigned long evtchn_pending[64];
 	unsigned long evtchn_mask[64];
 	struct pvclock_wall_clock wc;
-	uint32_t wc_sec_hi;
+	u32 wc_sec_hi;
 	/* arch_shared_info here */
 };
 
-- 
2.53.0.414.gf7e9f6c205-goog


