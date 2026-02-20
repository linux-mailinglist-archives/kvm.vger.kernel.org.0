Return-Path: <kvm+bounces-71376-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KNqiFACvl2nO5QIAu9opvQ
	(envelope-from <kvm+bounces-71376-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 01:46:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AD5C4163FAC
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 01:46:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9D22B304D943
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 00:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EBA11F5825;
	Fri, 20 Feb 2026 00:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NI+lgcqy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E74321CC58
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 00:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771548162; cv=none; b=A5l0aaUvC6zbtw4uX0ytzVBy/Almwj2s711KWYcPlsl4YxfvO4lOzJQWA/f2LFEwddNvJqF9zrCIELtoeDo1wxxNnnWmvB53LkxwEcOwgf2xaoWvTeNYN8vXEUW2n2H6bXAQAb/Nr4jKMwcTBl+f39JYoyuU7BRERY3xsPC2scA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771548162; c=relaxed/simple;
	bh=Ykx7lurpCZ7IEAcJmDPf+EmVZMoF7jS0tCaPUupoiXc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=snyVsdbJg6kM9q2ZF9w33I4rStF/wcdb8524p6N/lG4P4Bco9QKtF9AsesMyiSKm9u7cM0dfZAcLZnh2ueDcnJxP8no2oiBnPVNd9qDIqbt3DKlYeTiqNVQE7Qt9YVH79xTkUNv2o+9EdkTebfoYaVHRwQ4N9xsP8R78m+Hgheg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NI+lgcqy; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a7d7b87977so16329035ad.0
        for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 16:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771548158; x=1772152958; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=otF58xgiSeogp0X4Z/Kq5mu1+NxC8VKKaPc9x9RngkQ=;
        b=NI+lgcqyFpffHd4EPZnT3tq7pqBzJVZm69q89jdQPDHMMcC0/yNqAdClqSwKy0DiTm
         +4RB/OTXNuxzt8ihvEJlvM2ADcTpZBKEfriEq8e4qiZr8jd2u5GC4r4ELcYL+pWOfcQb
         M0vGc66IHyfQE4xYdHsIQV69G8z2BDNyoD7wn/LwnYvvzT1YM71OdRxr5G34PwGCvgCj
         ydVExR6l5IJ+slABVYWaUZ1C7HMEzothgztmUj7hAeL3XSvHtsHeJOyBOq8wESuVGe9o
         6G7bZb5OSDiEjPB58d1NF0NOdf6KlvEgLvyvITE+SI94ZdWHdiHmRKFO7PJmzA0evT6b
         Lhqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771548158; x=1772152958;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=otF58xgiSeogp0X4Z/Kq5mu1+NxC8VKKaPc9x9RngkQ=;
        b=RlVH8y39pYUha5uN8fw95NrycIhP9VpmQmefaVCGUzZsCoFbHBl0+qVk7aIVVZPE9Y
         lRDV8KeIhp3hSpR3xTmRoeQPwcho0PjVDSvA2yNwiFJp0W1aI7kIB5zLRLXmWp3aYw2M
         iXVlq7Fe3t1S5KUJ4kRvHo3fXSRWOknC8ESqVJnZrDnuDks4Hvjp/cs90M1UK4La4W/E
         eVxZ2ZnNBTza6IxdG5a4VCoD2+L4OsgWwt6+qRhtcnAKQNcGbEtDsUsRTTyjn+pVcEIh
         OeZH2gebFL5UcqsdUpEEf0k5mDZ7rEBb7sDO4vJCmxN2qZl3WE93xW1DS878zQd0/el2
         cFjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsn91fQpGun2PQpk6We4jgCliY3lf69zvd8Ar7YTXnBmGAoQniC7JFuWFmzL3pg0udDb8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya3aOP8HkO5Oqcy4337wo18zuHuyLFMp618arVBjrE8E4FCmyi
	c9uY3u2/ZQeFbYSzYCPezQ8Fe5XzmWcyRMJ4GkK2FzKJqUhd7f06cSmUtWMI3KE+Fym7lc38RM3
	EEp6Or1qtHk/2ZQ==
X-Received: from pllo6.prod.google.com ([2002:a17:902:7786:b0:29d:9755:9c9b])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:b85:b0:2a9:43b0:edd7 with SMTP id d9443c01a7336-2ad50ebd7ebmr64982915ad.20.1771548157401;
 Thu, 19 Feb 2026 16:42:37 -0800 (PST)
Date: Fri, 20 Feb 2026 00:42:15 +0000
In-Reply-To: <20260220004223.4168331-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260220004223.4168331-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260220004223.4168331-3-dmatlack@google.com>
Subject: [PATCH v2 02/10] KVM: selftests: Use gpa_t instead of vm_paddr_t
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71376-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[checkpatch.pl:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AD5C4163FAC
X-Rspamd-Action: no action

Replace all occurrences of vm_paddr_t with gpa_t to align with KVM code
and with the conversion helpers (e.g. addr_hva2gpa()). Also replace
vm_paddr in function names with gpa to align with the new type name.

This commit was generated with the following command:

  git ls-files tools/testing/selftests/kvm | xargs sed -i 's/vm_paddr_/gpa_/g'

Then by manually adjusting whitespace to make checkpatch.pl happy.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../testing/selftests/kvm/arm64/sea_to_user.c |  4 +--
 .../selftests/kvm/arm64/vgic_lpi_stress.c     | 20 ++++++------
 tools/testing/selftests/kvm/dirty_log_test.c  |  2 +-
 .../testing/selftests/kvm/include/arm64/gic.h |  4 +--
 .../selftests/kvm/include/arm64/gic_v3_its.h  |  8 ++---
 .../testing/selftests/kvm/include/kvm_util.h  | 31 +++++++++----------
 .../selftests/kvm/include/kvm_util_types.h    |  2 +-
 .../selftests/kvm/include/riscv/ucall.h       |  2 +-
 .../selftests/kvm/include/s390/ucall.h        |  2 +-
 .../selftests/kvm/include/ucall_common.h      |  4 +--
 tools/testing/selftests/kvm/include/x86/sev.h |  4 +--
 .../testing/selftests/kvm/include/x86/ucall.h |  2 +-
 .../selftests/kvm/kvm_page_table_test.c       |  2 +-
 .../testing/selftests/kvm/lib/arm64/gic_v3.c  |  4 +--
 .../selftests/kvm/lib/arm64/gic_v3_its.c      | 12 +++----
 .../selftests/kvm/lib/arm64/processor.c       |  2 +-
 tools/testing/selftests/kvm/lib/arm64/ucall.c |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++-------
 .../selftests/kvm/lib/loongarch/processor.c   | 10 +++---
 .../selftests/kvm/lib/loongarch/ucall.c       |  2 +-
 tools/testing/selftests/kvm/lib/memstress.c   |  2 +-
 .../selftests/kvm/lib/riscv/processor.c       |  2 +-
 .../selftests/kvm/lib/s390/processor.c        |  4 +--
 .../testing/selftests/kvm/lib/ucall_common.c  |  2 +-
 .../testing/selftests/kvm/lib/x86/processor.c |  2 +-
 tools/testing/selftests/kvm/lib/x86/sev.c     |  2 +-
 .../selftests/kvm/riscv/sbi_pmu_test.c        |  4 +--
 .../selftests/kvm/s390/ucontrol_test.c        |  2 +-
 tools/testing/selftests/kvm/steal_time.c      |  4 +--
 .../testing/selftests/kvm/x86/hyperv_clock.c  |  2 +-
 .../kvm/x86/hyperv_extended_hypercalls.c      |  2 +-
 .../selftests/kvm/x86/hyperv_tlb_flush.c      |  8 ++---
 .../selftests/kvm/x86/kvm_clock_test.c        |  4 +--
 .../kvm/x86/vmx_nested_la57_state_test.c      |  2 +-
 34 files changed, 91 insertions(+), 93 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c b/tools/testing/selftests/kvm/arm64/sea_to_user.c
index 573dd790aeb8..f41987dc726a 100644
--- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
+++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
@@ -51,7 +51,7 @@
 #define EINJ_OFFSET		0x01234badUL
 #define EINJ_GVA		((START_GVA) + (EINJ_OFFSET))
 
-static vm_paddr_t einj_gpa;
+static gpa_t einj_gpa;
 static void *einj_hva;
 static uint64_t einj_hpa;
 static bool far_invalid;
@@ -254,7 +254,7 @@ static struct kvm_vm *vm_create_with_sea_handler(struct kvm_vcpu **vcpu)
 	size_t guest_page_size;
 	size_t alignment;
 	uint64_t num_guest_pages;
-	vm_paddr_t start_gpa;
+	gpa_t start_gpa;
 	enum vm_mem_backing_src_type src_type = VM_MEM_SRC_ANONYMOUS_HUGETLB_1GB;
 	struct kvm_vm *vm;
 
diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
index e857a605f577..d64d434d3f06 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
@@ -23,7 +23,7 @@
 #define GIC_LPI_OFFSET	8192
 
 static size_t nr_iterations = 1000;
-static vm_paddr_t gpa_base;
+static gpa_t gpa_base;
 
 static struct kvm_vm *vm;
 static struct kvm_vcpu **vcpus;
@@ -35,14 +35,14 @@ static struct test_data {
 	u32		nr_devices;
 	u32		nr_event_ids;
 
-	vm_paddr_t	device_table;
-	vm_paddr_t	collection_table;
-	vm_paddr_t	cmdq_base;
+	gpa_t		device_table;
+	gpa_t		collection_table;
+	gpa_t		cmdq_base;
 	void		*cmdq_base_va;
-	vm_paddr_t	itt_tables;
+	gpa_t		itt_tables;
 
-	vm_paddr_t	lpi_prop_table;
-	vm_paddr_t	lpi_pend_tables;
+	gpa_t		lpi_prop_table;
+	gpa_t		lpi_pend_tables;
 } test_data =  {
 	.nr_cpus	= 1,
 	.nr_devices	= 1,
@@ -73,7 +73,7 @@ static void guest_setup_its_mappings(void)
 	/* Round-robin the LPIs to all of the vCPUs in the VM */
 	coll_id = 0;
 	for (device_id = 0; device_id < nr_devices; device_id++) {
-		vm_paddr_t itt_base = test_data.itt_tables + (device_id * SZ_64K);
+		gpa_t itt_base = test_data.itt_tables + (device_id * SZ_64K);
 
 		its_send_mapd_cmd(test_data.cmdq_base_va, device_id,
 				  itt_base, SZ_64K, true);
@@ -188,7 +188,7 @@ static void setup_test_data(void)
 	size_t pages_per_64k = vm_calc_num_guest_pages(vm->mode, SZ_64K);
 	u32 nr_devices = test_data.nr_devices;
 	u32 nr_cpus = test_data.nr_cpus;
-	vm_paddr_t cmdq_base;
+	gpa_t cmdq_base;
 
 	test_data.device_table = vm_phy_pages_alloc(vm, pages_per_64k,
 						    gpa_base,
@@ -224,7 +224,7 @@ static void setup_gic(void)
 
 static void signal_lpi(u32 device_id, u32 event_id)
 {
-	vm_paddr_t db_addr = GITS_BASE_GPA + GITS_TRANSLATER;
+	gpa_t db_addr = GITS_BASE_GPA + GITS_TRANSLATER;
 
 	struct kvm_msi msi = {
 		.address_lo	= db_addr,
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index d58a641b0e6a..f48741ce9aa3 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -670,7 +670,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages);
 
 	/* Cache the HVA pointer of the region */
-	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)guest_test_phys_mem);
+	host_test_mem = addr_gpa2hva(vm, (gpa_t)guest_test_phys_mem);
 
 	/* Export the shared variables to the guest */
 	sync_global_to_guest(vm, host_page_size);
diff --git a/tools/testing/selftests/kvm/include/arm64/gic.h b/tools/testing/selftests/kvm/include/arm64/gic.h
index cc7a7f34ed37..6408f952cb64 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic.h
@@ -59,7 +59,7 @@ bool gic_irq_get_pending(unsigned int intid);
 void gic_irq_set_config(unsigned int intid, bool is_edge);
 void gic_irq_set_group(unsigned int intid, bool group);
 
-void gic_rdist_enable_lpis(vm_paddr_t cfg_table, size_t cfg_table_size,
-			   vm_paddr_t pend_table);
+void gic_rdist_enable_lpis(gpa_t cfg_table, size_t cfg_table_size,
+			   gpa_t pend_table);
 
 #endif /* SELFTEST_KVM_GIC_H */
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h b/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h
index 58feef3eb386..7eb9b814d82f 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h
@@ -5,11 +5,11 @@
 
 #include <linux/sizes.h>
 
-void its_init(vm_paddr_t coll_tbl, size_t coll_tbl_sz,
-	      vm_paddr_t device_tbl, size_t device_tbl_sz,
-	      vm_paddr_t cmdq, size_t cmdq_size);
+void its_init(gpa_t coll_tbl, size_t coll_tbl_sz,
+	      gpa_t device_tbl, size_t device_tbl_sz,
+	      gpa_t cmdq, size_t cmdq_size);
 
-void its_send_mapd_cmd(void *cmdq_base, u32 device_id, vm_paddr_t itt_base,
+void its_send_mapd_cmd(void *cmdq_base, u32 device_id, gpa_t itt_base,
 		       size_t itt_size, bool valid);
 void its_send_mapc_cmd(void *cmdq_base, u32 vcpu_id, u32 collection_id, bool valid);
 void its_send_mapti_cmd(void *cmdq_base, u32 device_id, u32 event_id,
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 2e6124ac969a..3ffbe51d8ef4 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -111,7 +111,7 @@ struct kvm_vm {
 	struct sparsebit *vpages_valid;
 	struct sparsebit *vpages_mapped;
 	bool has_irqchip;
-	vm_paddr_t ucall_mmio_addr;
+	gpa_t ucall_mmio_addr;
 	gva_t handlers;
 	uint32_t dirty_ring_size;
 	uint64_t gpa_tag_mask;
@@ -730,16 +730,16 @@ gva_t gva_alloc_page(struct kvm_vm *vm);
 
 void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	      unsigned int npages);
-void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
+void *addr_gpa2hva(struct kvm_vm *vm, gpa_t gpa);
 void *addr_gva2hva(struct kvm_vm *vm, gva_t gva);
-vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
-void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
+gpa_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
+void *addr_gpa2alias(struct kvm_vm *vm, gpa_t gpa);
 
 #ifndef vcpu_arch_put_guest
 #define vcpu_arch_put_guest(mem, val) do { (mem) = (val); } while (0)
 #endif
 
-static inline vm_paddr_t vm_untag_gpa(struct kvm_vm *vm, vm_paddr_t gpa)
+static inline gpa_t vm_untag_gpa(struct kvm_vm *vm, gpa_t gpa)
 {
 	return gpa & ~vm->gpa_tag_mask;
 }
@@ -990,15 +990,14 @@ void kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing);
 
 const char *exit_reason_str(unsigned int exit_reason);
 
-vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
-			     uint32_t memslot);
-vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-				vm_paddr_t paddr_min, uint32_t memslot,
-				bool protected);
-vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
+gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t paddr_min, uint32_t memslot);
+gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			   gpa_t paddr_min, uint32_t memslot,
+			   bool protected);
+gpa_t vm_alloc_page_table(struct kvm_vm *vm);
 
-static inline vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-					    vm_paddr_t paddr_min, uint32_t memslot)
+static inline gpa_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+				       gpa_t paddr_min, uint32_t memslot)
 {
 	/*
 	 * By default, allocate memory as protected for VMs that support
@@ -1246,9 +1245,9 @@ static inline void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr
  * Returns the VM physical address of the translated VM virtual
  * address given by @gva.
  */
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva);
+gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva);
 
-static inline vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, gva_t gva)
+static inline gpa_t addr_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	return addr_arch_gva2gpa(vm, gva);
 }
@@ -1297,7 +1296,7 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm, unsigned int nr_vcpus);
 void kvm_arch_vm_finalize_vcpus(struct kvm_vm *vm);
 void kvm_arch_vm_release(struct kvm_vm *vm);
 
-bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr);
+bool vm_is_gpa_protected(struct kvm_vm *vm, gpa_t paddr);
 
 uint32_t guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/include/kvm_util_types.h b/tools/testing/selftests/kvm/include/kvm_util_types.h
index a53e04286554..224a29cea790 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_types.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_types.h
@@ -14,7 +14,7 @@
 #define __kvm_static_assert(expr, msg, ...) _Static_assert(expr, msg)
 #define kvm_static_assert(expr, ...) __kvm_static_assert(expr, ##__VA_ARGS__, #expr)
 
-typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
+typedef uint64_t gpa_t; /* Virtual Machine (Guest) physical address */
 typedef uint64_t gva_t; /* Virtual Machine (Guest) virtual address */
 
 #endif /* SELFTEST_KVM_UTIL_TYPES_H */
diff --git a/tools/testing/selftests/kvm/include/riscv/ucall.h b/tools/testing/selftests/kvm/include/riscv/ucall.h
index 41d56254968e..2de7c6a36096 100644
--- a/tools/testing/selftests/kvm/include/riscv/ucall.h
+++ b/tools/testing/selftests/kvm/include/riscv/ucall.h
@@ -7,7 +7,7 @@
 
 #define UCALL_EXIT_REASON       KVM_EXIT_RISCV_SBI
 
-static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+static inline void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 }
 
diff --git a/tools/testing/selftests/kvm/include/s390/ucall.h b/tools/testing/selftests/kvm/include/s390/ucall.h
index befee84c4609..3907d629304f 100644
--- a/tools/testing/selftests/kvm/include/s390/ucall.h
+++ b/tools/testing/selftests/kvm/include/s390/ucall.h
@@ -6,7 +6,7 @@
 
 #define UCALL_EXIT_REASON       KVM_EXIT_S390_SIEIC
 
-static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+static inline void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 }
 
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index e5499f170834..1db399c00d02 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -29,7 +29,7 @@ struct ucall {
 	struct ucall *hva;
 };
 
-void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
+void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa);
 void ucall_arch_do_ucall(gva_t uc);
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 
@@ -39,7 +39,7 @@ __printf(5, 6) void ucall_assert(uint64_t cmd, const char *exp,
 				 const char *file, unsigned int line,
 				 const char *fmt, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
-void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
+void ucall_init(struct kvm_vm *vm, gpa_t mmio_gpa);
 int ucall_nr_pages_required(uint64_t page_size);
 
 /*
diff --git a/tools/testing/selftests/kvm/include/x86/sev.h b/tools/testing/selftests/kvm/include/x86/sev.h
index 008b4169f5e2..289ff5b3f10c 100644
--- a/tools/testing/selftests/kvm/include/x86/sev.h
+++ b/tools/testing/selftests/kvm/include/x86/sev.h
@@ -120,7 +120,7 @@ static inline void sev_register_encrypted_memory(struct kvm_vm *vm,
 	vm_ioctl(vm, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
 }
 
-static inline void sev_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa,
+static inline void sev_launch_update_data(struct kvm_vm *vm, gpa_t gpa,
 					  uint64_t size)
 {
 	struct kvm_sev_launch_update_data update_data = {
@@ -131,7 +131,7 @@ static inline void sev_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa,
 	vm_sev_ioctl(vm, KVM_SEV_LAUNCH_UPDATE_DATA, &update_data);
 }
 
-static inline void snp_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa,
+static inline void snp_launch_update_data(struct kvm_vm *vm, gpa_t gpa,
 					  uint64_t hva, uint64_t size, uint8_t type)
 {
 	struct kvm_sev_snp_launch_update update_data = {
diff --git a/tools/testing/selftests/kvm/include/x86/ucall.h b/tools/testing/selftests/kvm/include/x86/ucall.h
index d3825dcc3cd9..0e4950041e3e 100644
--- a/tools/testing/selftests/kvm/include/x86/ucall.h
+++ b/tools/testing/selftests/kvm/include/x86/ucall.h
@@ -6,7 +6,7 @@
 
 #define UCALL_EXIT_REASON       KVM_EXIT_IO
 
-static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+static inline void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 }
 
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index 6e909a96b095..6cf1fa092752 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -284,7 +284,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages);
 
 	/* Cache the HVA pointer of the region */
-	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)guest_test_phys_mem);
+	host_test_mem = addr_gpa2hva(vm, (gpa_t)guest_test_phys_mem);
 
 	/* Export shared structure test_args to guest */
 	sync_global_to_guest(vm, test_args);
diff --git a/tools/testing/selftests/kvm/lib/arm64/gic_v3.c b/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
index 50754a27f493..ae3959f3bb11 100644
--- a/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
@@ -424,8 +424,8 @@ const struct gic_common_ops gicv3_ops = {
 	.gic_irq_set_group = gicv3_set_group,
 };
 
-void gic_rdist_enable_lpis(vm_paddr_t cfg_table, size_t cfg_table_size,
-			   vm_paddr_t pend_table)
+void gic_rdist_enable_lpis(gpa_t cfg_table, size_t cfg_table_size,
+			   gpa_t pend_table)
 {
 	volatile void *rdist_base = gicr_base_cpu(guest_get_vcpuid());
 
diff --git a/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c b/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c
index 7f9fdcf42ae6..f14a57e9d8d6 100644
--- a/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c
+++ b/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c
@@ -54,7 +54,7 @@ static unsigned long its_find_baser(unsigned int type)
 	return -1;
 }
 
-static void its_install_table(unsigned int type, vm_paddr_t base, size_t size)
+static void its_install_table(unsigned int type, gpa_t base, size_t size)
 {
 	unsigned long offset = its_find_baser(type);
 	u64 baser;
@@ -69,7 +69,7 @@ static void its_install_table(unsigned int type, vm_paddr_t base, size_t size)
 	its_write_u64(offset, baser);
 }
 
-static void its_install_cmdq(vm_paddr_t base, size_t size)
+static void its_install_cmdq(gpa_t base, size_t size)
 {
 	u64 cbaser;
 
@@ -82,9 +82,9 @@ static void its_install_cmdq(vm_paddr_t base, size_t size)
 	its_write_u64(GITS_CBASER, cbaser);
 }
 
-void its_init(vm_paddr_t coll_tbl, size_t coll_tbl_sz,
-	      vm_paddr_t device_tbl, size_t device_tbl_sz,
-	      vm_paddr_t cmdq, size_t cmdq_size)
+void its_init(gpa_t coll_tbl, size_t coll_tbl_sz,
+	      gpa_t device_tbl, size_t device_tbl_sz,
+	      gpa_t cmdq, size_t cmdq_size)
 {
 	u32 ctlr;
 
@@ -204,7 +204,7 @@ static void its_send_cmd(void *cmdq_base, struct its_cmd_block *cmd)
 	}
 }
 
-void its_send_mapd_cmd(void *cmdq_base, u32 device_id, vm_paddr_t itt_base,
+void its_send_mapd_cmd(void *cmdq_base, u32 device_id, gpa_t itt_base,
 		       size_t itt_size, bool valid)
 {
 	struct its_cmd_block cmd = {};
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 34339fd2b2c5..55e8f90714d3 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -230,7 +230,7 @@ uint64_t *virt_get_pte_hva(struct kvm_vm *vm, gva_t gva)
 	return virt_get_pte_hva_at_level(vm, gva, 3);
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
+gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	uint64_t *ptep = virt_get_pte_hva(vm, gva);
 
diff --git a/tools/testing/selftests/kvm/lib/arm64/ucall.c b/tools/testing/selftests/kvm/lib/arm64/ucall.c
index a1a3b4dcdce1..62109407a1ff 100644
--- a/tools/testing/selftests/kvm/lib/arm64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/arm64/ucall.c
@@ -8,7 +8,7 @@
 
 gva_t *ucall_exit_mmio_addr;
 
-void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 	gva_t mmio_gva = gva_unused_gap(vm, vm->page_size, KVM_UTIL_MIN_VADDR);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e252e5b1f785..3fa8cc678d76 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1466,7 +1466,7 @@ static gva_t ____gva_alloc(struct kvm_vm *vm, size_t sz,
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
-	vm_paddr_t paddr = __vm_phy_pages_alloc(vm, pages,
+	gpa_t paddr = __vm_phy_pages_alloc(vm, pages,
 						KVM_UTIL_MIN_PFN * vm->page_size,
 						vm->memslots[type], protected);
 
@@ -1617,7 +1617,7 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
  * address providing the memory to the vm physical address is returned.
  * A TEST_ASSERT failure occurs if no region containing gpa exists.
  */
-void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
+void *addr_gpa2hva(struct kvm_vm *vm, gpa_t gpa)
 {
 	struct userspace_mem_region *region;
 
@@ -1650,7 +1650,7 @@ void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
  * VM physical address is returned. A TEST_ASSERT failure occurs if no
  * region containing hva exists.
  */
-vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
+gpa_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
 {
 	struct rb_node *node;
 
@@ -1661,7 +1661,7 @@ vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
 		if (hva >= region->host_mem) {
 			if (hva <= (region->host_mem
 				+ region->region.memory_size - 1))
-				return (vm_paddr_t)((uintptr_t)
+				return (gpa_t)((uintptr_t)
 					region->region.guest_phys_addr
 					+ (hva - (uintptr_t)region->host_mem));
 
@@ -1693,7 +1693,7 @@ vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
  * memory without mapping said memory in the guest's address space. And, for
  * userfaultfd-based demand paging, to do so without triggering userfaults.
  */
-void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa)
+void *addr_gpa2alias(struct kvm_vm *vm, gpa_t gpa)
 {
 	struct userspace_mem_region *region;
 	uintptr_t offset;
@@ -2097,9 +2097,9 @@ const char *exit_reason_str(unsigned int exit_reason)
  * and their base address is returned. A TEST_ASSERT failure occurs if
  * not enough pages are available at or above paddr_min.
  */
-vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-				vm_paddr_t paddr_min, uint32_t memslot,
-				bool protected)
+gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			   gpa_t paddr_min, uint32_t memslot,
+			   bool protected)
 {
 	struct userspace_mem_region *region;
 	sparsebit_idx_t pg, base;
@@ -2143,13 +2143,12 @@ vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 	return base * vm->page_size;
 }
 
-vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
-			     uint32_t memslot)
+gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t paddr_min, uint32_t memslot)
 {
 	return vm_phy_pages_alloc(vm, 1, paddr_min, memslot);
 }
 
-vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
+gpa_t vm_alloc_page_table(struct kvm_vm *vm)
 {
 	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
 				 vm->memslots[MEM_REGION_PT]);
@@ -2363,7 +2362,7 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	kvm_selftest_arch_init();
 }
 
-bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr)
+bool vm_is_gpa_protected(struct kvm_vm *vm, gpa_t paddr)
 {
 	sparsebit_idx_t pg = 0;
 	struct userspace_mem_region *region;
diff --git a/tools/testing/selftests/kvm/lib/loongarch/processor.c b/tools/testing/selftests/kvm/lib/loongarch/processor.c
index e2b94640c76f..818b8284a067 100644
--- a/tools/testing/selftests/kvm/lib/loongarch/processor.c
+++ b/tools/testing/selftests/kvm/lib/loongarch/processor.c
@@ -11,7 +11,7 @@
 #define LOONGARCH_PAGE_TABLE_PHYS_MIN		0x200000
 #define LOONGARCH_GUEST_STACK_VADDR_MIN		0x200000
 
-static vm_paddr_t invalid_pgtable[4];
+static gpa_t invalid_pgtable[4];
 static gva_t exception_handlers;
 
 static uint64_t virt_pte_index(struct kvm_vm *vm, gva_t gva, int level)
@@ -34,7 +34,7 @@ static uint64_t ptrs_per_pte(struct kvm_vm *vm)
 	return 1 << (vm->page_shift - 3);
 }
 
-static void virt_set_pgtable(struct kvm_vm *vm, vm_paddr_t table, vm_paddr_t child)
+static void virt_set_pgtable(struct kvm_vm *vm, gpa_t table, gpa_t child)
 {
 	uint64_t *ptep;
 	int i, ptrs_per_pte;
@@ -48,7 +48,7 @@ static void virt_set_pgtable(struct kvm_vm *vm, vm_paddr_t table, vm_paddr_t chi
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
 	int i;
-	vm_paddr_t child, table;
+	gpa_t child, table;
 
 	if (vm->mmu.pgd_created)
 		return;
@@ -75,7 +75,7 @@ static uint64_t *virt_populate_pte(struct kvm_vm *vm, gva_t gva, int alloc)
 {
 	int level;
 	uint64_t *ptep;
-	vm_paddr_t child;
+	gpa_t child;
 
 	if (!vm->mmu.pgd_created)
 		goto unmapped_gva;
@@ -105,7 +105,7 @@ static uint64_t *virt_populate_pte(struct kvm_vm *vm, gva_t gva, int alloc)
 	exit(EXIT_FAILURE);
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
+gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	uint64_t *ptep;
 
diff --git a/tools/testing/selftests/kvm/lib/loongarch/ucall.c b/tools/testing/selftests/kvm/lib/loongarch/ucall.c
index ed76a0fde6c9..2b46b59fd6d0 100644
--- a/tools/testing/selftests/kvm/lib/loongarch/ucall.c
+++ b/tools/testing/selftests/kvm/lib/loongarch/ucall.c
@@ -11,7 +11,7 @@
  */
 gva_t *ucall_exit_mmio_addr;
 
-void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 	gva_t mmio_gva = gva_unused_gap(vm, vm->page_size, KVM_UTIL_MIN_VADDR);
 
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index 557c0a0a5658..860823092c0c 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -207,7 +207,7 @@ struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	/* Add extra memory slots for testing */
 	for (i = 0; i < slots; i++) {
 		uint64_t region_pages = guest_num_pages / slots;
-		vm_paddr_t region_start = args->gpa + region_pages * args->guest_page_size * i;
+		gpa_t region_start = args->gpa + region_pages * args->guest_page_size * i;
 
 		vm_userspace_mem_region_add(vm, backing_src, region_start,
 					    MEMSTRESS_MEM_SLOT_INDEX + i,
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index b93570673954..3ef9eaf98eb0 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -119,7 +119,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 		PGTBL_PTE_PERM_MASK | PGTBL_PTE_VALID_MASK;
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
+gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	uint64_t *ptep;
 	int level = vm->mmu.pgtable_levels - 1;
diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
index 812fa34e0367..e9a4f1243b33 100644
--- a/tools/testing/selftests/kvm/lib/s390/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390/processor.c
@@ -12,7 +12,7 @@
 
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
-	vm_paddr_t paddr;
+	gpa_t paddr;
 
 	TEST_ASSERT(vm->page_size == PAGE_SIZE, "Unsupported page size: 0x%x",
 		    vm->page_size);
@@ -86,7 +86,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa)
 	entry[idx] = gpa;
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
+gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	int ri, idx;
 	uint64_t *entry;
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 3a72169b61ac..60297819d508 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -25,7 +25,7 @@ int ucall_nr_pages_required(uint64_t page_size)
  */
 static struct ucall_header *ucall_pool;
 
-void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+void ucall_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 	struct ucall_header *hdr;
 	struct ucall *uc;
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 4b16ecd9db5c..bb0dcfcc7c94 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -615,7 +615,7 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_segment *segp)
 	segp->present = true;
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
+gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	int level = PG_LEVEL_NONE;
 	uint64_t *pte = __vm_get_page_table_entry(vm, &vm->mmu, gva, &level);
diff --git a/tools/testing/selftests/kvm/lib/x86/sev.c b/tools/testing/selftests/kvm/lib/x86/sev.c
index c3a9838f4806..aecef6048ff1 100644
--- a/tools/testing/selftests/kvm/lib/x86/sev.c
+++ b/tools/testing/selftests/kvm/lib/x86/sev.c
@@ -18,7 +18,7 @@ static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *regio
 			   uint8_t page_type, bool private)
 {
 	const struct sparsebit *protected_phy_pages = region->protected_phy_pages;
-	const vm_paddr_t gpa_base = region->region.guest_phys_addr;
+	const gpa_t gpa_base = region->region.guest_phys_addr;
 	const sparsebit_idx_t lowest_page_in_region = gpa_base >> vm->page_shift;
 	sparsebit_idx_t i, j;
 
diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
index 49e0f2679083..9ecac8521a99 100644
--- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
@@ -24,7 +24,7 @@ union sbi_pmu_ctr_info ctrinfo_arr[RISCV_MAX_PMU_COUNTERS];
 /* Snapshot shared memory data */
 #define PMU_SNAPSHOT_GPA_BASE		BIT(30)
 static void *snapshot_gva;
-static vm_paddr_t snapshot_gpa;
+static gpa_t snapshot_gpa;
 
 static int vcpu_shared_irq_count;
 static int counter_in_use;
@@ -259,7 +259,7 @@ static inline void verify_sbi_requirement_assert(void)
 		__GUEST_ASSERT(0, "SBI implementation version doesn't support PMU Snapshot");
 }
 
-static void snapshot_set_shmem(vm_paddr_t gpa, unsigned long flags)
+static void snapshot_set_shmem(gpa_t gpa, unsigned long flags)
 {
 	unsigned long lo = (unsigned long)gpa;
 #if __riscv_xlen == 32
diff --git a/tools/testing/selftests/kvm/s390/ucontrol_test.c b/tools/testing/selftests/kvm/s390/ucontrol_test.c
index 50bc1c38225a..f773ba0f4641 100644
--- a/tools/testing/selftests/kvm/s390/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390/ucontrol_test.c
@@ -111,7 +111,7 @@ FIXTURE(uc_kvm)
 	uintptr_t base_hva;
 	uintptr_t code_hva;
 	int kvm_run_size;
-	vm_paddr_t pgd;
+	gpa_t pgd;
 	void *vm_mem;
 	int vcpu_fd;
 	int kvm_fd;
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 7994882ba58a..eb55480ea24b 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -210,7 +210,7 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 /* SBI STA shmem must have 64-byte alignment */
 #define STEAL_TIME_SIZE		((sizeof(struct sta_struct) + 63) & ~63)
 
-static vm_paddr_t st_gpa[NR_VCPUS];
+static gpa_t st_gpa[NR_VCPUS];
 
 struct sta_struct {
 	uint32_t sequence;
@@ -220,7 +220,7 @@ struct sta_struct {
 	uint8_t pad[47];
 } __packed;
 
-static void sta_set_shmem(vm_paddr_t gpa, unsigned long flags)
+static void sta_set_shmem(gpa_t gpa, unsigned long flags)
 {
 	unsigned long lo = (unsigned long)gpa;
 #if __riscv_xlen == 32
diff --git a/tools/testing/selftests/kvm/x86/hyperv_clock.c b/tools/testing/selftests/kvm/x86/hyperv_clock.c
index 046d33ec69fc..dd8ce5686736 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_clock.c
@@ -98,7 +98,7 @@ static inline void check_tsc_msr_tsc_page(struct ms_hyperv_tsc_page *tsc_page)
 	GUEST_ASSERT(r2 >= t1 && r2 - t2 < 100000);
 }
 
-static void guest_main(struct ms_hyperv_tsc_page *tsc_page, vm_paddr_t tsc_page_gpa)
+static void guest_main(struct ms_hyperv_tsc_page *tsc_page, gpa_t tsc_page_gpa)
 {
 	u64 tsc_scale, tsc_offset;
 
diff --git a/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c b/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
index 43e1c5149d97..f2d990ce4e2b 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
@@ -15,7 +15,7 @@
 /* Any value is fine */
 #define EXT_CAPABILITIES 0xbull
 
-static void guest_code(vm_paddr_t in_pg_gpa, vm_paddr_t out_pg_gpa,
+static void guest_code(gpa_t in_pg_gpa, gpa_t out_pg_gpa,
 		       gva_t out_pg_gva)
 {
 	uint64_t *output_gva;
diff --git a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
index 4fe8855aa66c..157a8bd79fe3 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
@@ -62,7 +62,7 @@ struct hv_tlb_flush_ex {
  */
 struct test_data {
 	gva_t hcall_gva;
-	vm_paddr_t hcall_gpa;
+	gpa_t hcall_gpa;
 	gva_t test_pages;
 	gva_t test_pages_pte[NTEST_PAGES];
 };
@@ -133,7 +133,7 @@ static void set_expected_val(void *addr, u64 val, int vcpu_id)
  * Update PTEs swapping two test pages.
  * TODO: use swap()/xchg() when these are provided.
  */
-static void swap_two_test_pages(vm_paddr_t pte_gva1, vm_paddr_t pte_gva2)
+static void swap_two_test_pages(gpa_t pte_gva1, gpa_t pte_gva2)
 {
 	uint64_t tmp = *(uint64_t *)pte_gva1;
 
@@ -201,7 +201,7 @@ static void sender_guest_code(gva_t test_data)
 	struct test_data *data = (struct test_data *)test_data;
 	struct hv_tlb_flush *flush = (struct hv_tlb_flush *)data->hcall_gva;
 	struct hv_tlb_flush_ex *flush_ex = (struct hv_tlb_flush_ex *)data->hcall_gva;
-	vm_paddr_t hcall_gpa = data->hcall_gpa;
+	gpa_t hcall_gpa = data->hcall_gpa;
 	int i, stage = 1;
 
 	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
@@ -582,7 +582,7 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu[3];
 	pthread_t threads[2];
 	gva_t test_data_page, gva;
-	vm_paddr_t gpa;
+	gpa_t gpa;
 	uint64_t *pte;
 	struct test_data *data;
 	struct ucall uc;
diff --git a/tools/testing/selftests/kvm/x86/kvm_clock_test.c b/tools/testing/selftests/kvm/x86/kvm_clock_test.c
index b335ee2a8e97..ada4b2abf55d 100644
--- a/tools/testing/selftests/kvm/x86/kvm_clock_test.c
+++ b/tools/testing/selftests/kvm/x86/kvm_clock_test.c
@@ -31,7 +31,7 @@ static struct test_case test_cases[] = {
 #define GUEST_SYNC_CLOCK(__stage, __val)			\
 		GUEST_SYNC_ARGS(__stage, __val, 0, 0, 0)
 
-static void guest_main(vm_paddr_t pvti_pa, struct pvclock_vcpu_time_info *pvti)
+static void guest_main(gpa_t pvti_pa, struct pvclock_vcpu_time_info *pvti)
 {
 	int i;
 
@@ -136,7 +136,7 @@ int main(void)
 {
 	struct kvm_vcpu *vcpu;
 	gva_t pvti_gva;
-	vm_paddr_t pvti_gpa;
+	gpa_t pvti_gpa;
 	struct kvm_vm *vm;
 	int flags;
 
diff --git a/tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c b/tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c
index 4ffa11a6bcd8..f13dee317383 100644
--- a/tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c
@@ -30,7 +30,7 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	u64 guest_cr4;
-	vm_paddr_t pml5_pa, pml4_pa;
+	gpa_t pml5_pa, pml4_pa;
 	u64 *pml5;
 	u64 exit_reason;
 
-- 
2.53.0.414.gf7e9f6c205-goog


