Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753E03C93DC
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 00:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhGNWde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 18:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbhGNWdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 18:33:33 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B68C061760
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 15:30:40 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id l21-20020a056a0016d5b0290319e1ac27b1so2727634pfc.12
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 15:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cQrvGwwPS02wSpYxaKEKB1xeCe3Pf6yhrdDBd5BAS+M=;
        b=HOUsBolUL7C0/Jr6UlSR2TqjedJlpQ3FY0r8zm9nNAsEJ94XgboBoRcmnst3IDXeOl
         X/X5dvTBSJVFH7NZxOwcyI+el+0d3kaHUiaZCfwVYwB12dON9AlHZ0av9JVzc5ybJJ41
         Wf94pkxEHbkqAIG4ye+/QOqRX4Fvfaw8YnblgMIDSYGYRDAOjgU0X3Kcd53mIVMorToC
         ukdmIYATi3z4PMee4bJK9v8+Oxe0Xp55cs6PfubPUudxdgqvN9NJa1eMGwOoV6VXfNRy
         3SbuhoEXhF5cT+cv8DR8vCdPlI7sEK6XstpphqEItNqmMmcjqfEmbGx8MEe+F9SJd9BV
         emDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cQrvGwwPS02wSpYxaKEKB1xeCe3Pf6yhrdDBd5BAS+M=;
        b=Qp1Y30GCItLBXzGvF2fY6xdTk9hhvL01bDybZtnDZfGIZfMQ5RWLvCHX9U9c/8UUYQ
         IW67++dU3JKGDrrVw+LNnygp1QxymsYNCPWPaIytwr/Jq7an3Rcvw97Zxj/je2o9iaNV
         w8SNmTfX3x11SUdjhf3+XNOv9MR/VYGl9pDl46vt1RBNyvmWZqtoJ2vY/aGhEedO5SO8
         M6Q05IaHDWTQhK9atS3zycNxTf+DzwtuKXiz6I/ZD7KV8aNzovH83d5a+mjhLMkFINQe
         6siBpMdB1P6H0dluHhsD7f64uXmAhhXi7HE71gC3VrQdwKxpScUJrL4bmPaK0vHpqi7l
         xG5g==
X-Gm-Message-State: AOAM533D/smRN5V8zdM/uDSoXnDpJf2POyEJOjTDt7h6/9Ti7QKYcEOX
        xry87LAHwmrOjq2ofZwS2KAt/JzImhgWPR3EiCGPNaD9RHhT8aHuIkN0yDMjFQS9suoO/fU4zpN
        juoc7XElgZFjAbSkoI1txCx5fEUSOosjl8/oRp0L4vlj76+5J7muFBtJNscMAKXIf5SqsaY8=
X-Google-Smtp-Source: ABdhPJxTENLZidlXhfS4Lx3MoS6T4avx/cMc9HuxryU9eVD66KKDLf/p9bUMrMnvRc0ezhURwHLyXaDxuj1NQBdCTg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:d90b:b029:11b:f58c:f3d6 with
 SMTP id c11-20020a170902d90bb029011bf58cf3d6mr341789plz.42.1626301840050;
 Wed, 14 Jul 2021 15:30:40 -0700 (PDT)
Date:   Wed, 14 Jul 2021 22:30:29 +0000
In-Reply-To: <20210714223033.742261-1-jingzhangos@google.com>
Message-Id: <20210714223033.742261-3-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210714223033.742261-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 2/6] KVM: stats: Support linear and logarithmic histogram statistics
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add new types of KVM stats, linear and logarithmic histogram.
Histogram are very useful for observing the value distribution
of time or size related stats.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/guest.c    |  4 ---
 arch/mips/kvm/mips.c      |  4 ---
 arch/powerpc/kvm/book3s.c |  4 ---
 arch/powerpc/kvm/booke.c  |  4 ---
 arch/s390/kvm/kvm-s390.c  |  4 ---
 arch/x86/kvm/x86.c        |  4 ---
 include/linux/kvm_host.h  | 53 ++++++++++++++++++++++++++++-----------
 include/linux/kvm_types.h | 15 +++++++++++
 include/uapi/linux/kvm.h  | 11 +++++---
 virt/kvm/binary_stats.c   | 32 +++++++++++++++++++++++
 10 files changed, 92 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 1dfb83578277..5188184d25d0 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -31,8 +31,6 @@
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS()
 };
-static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
-		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vm_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
@@ -52,8 +50,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
 	STATS_DESC_COUNTER(VCPU, exits)
 };
-static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
-		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index af9dd029a4e1..75c6f264c626 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -41,8 +41,6 @@
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS()
 };
-static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
-		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vm_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
@@ -85,8 +83,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, vz_cpucfg_exits),
 #endif
 };
-static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
-		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 79833f78d1da..5cc6e90095b0 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -43,8 +43,6 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_ICOUNTER(VM, num_2M_pages),
 	STATS_DESC_ICOUNTER(VM, num_1G_pages)
 };
-static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
-		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vm_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
@@ -88,8 +86,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, pthru_host),
 	STATS_DESC_COUNTER(VCPU, pthru_bad_aff)
 };
-static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
-		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 551b30d84aee..5ed6c235e059 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -41,8 +41,6 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_ICOUNTER(VM, num_2M_pages),
 	STATS_DESC_ICOUNTER(VM, num_1G_pages)
 };
-static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
-		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vm_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
@@ -79,8 +77,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, pthru_host),
 	STATS_DESC_COUNTER(VCPU, pthru_bad_aff)
 };
-static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
-		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index f9fb1e1d960d..c7f2b1124740 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -66,8 +66,6 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_COUNTER(VM, inject_service_signal),
 	STATS_DESC_COUNTER(VM, inject_virtio)
 };
-static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
-		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vm_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
@@ -174,8 +172,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, diagnose_other),
 	STATS_DESC_COUNTER(VCPU, pfault_sync)
 };
-static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
-		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d715ae9f9108..e1b00597b84f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -236,8 +236,6 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
 	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
 };
-static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
-		sizeof(struct kvm_vm_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vm_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
@@ -277,8 +275,6 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
 	STATS_DESC_ICOUNTER(VCPU, guest_mode)
 };
-static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
-		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
 	.name_size = KVM_STATS_NAME_SIZE,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae7735b490b4..c44cf5029e30 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1273,56 +1273,66 @@ struct _kvm_stats_desc {
 	char name[KVM_STATS_NAME_SIZE];
 };
 
-#define STATS_DESC_COMMON(type, unit, base, exp)			       \
+#define STATS_DESC_COMMON(type, unit, base, exp, sz, bsz)		       \
 	.flags = type | unit | base |					       \
 		 BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |	       \
 		 BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |	       \
 		 BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),	       \
 	.exponent = exp,						       \
-	.size = 1
+	.size = sz,							       \
+	.bucket_size = bsz
 
-#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp)		       \
+#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, bsz)	       \
 	{								       \
 		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp),	       \
+			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
 			.offset = offsetof(struct kvm_vm_stat, generic.stat)   \
 		},							       \
 		.name = #stat,						       \
 	}
-#define VCPU_GENERIC_STATS_DESC(stat, type, unit, base, exp)		       \
+#define VCPU_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, bsz)	       \
 	{								       \
 		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp),	       \
+			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
 			.offset = offsetof(struct kvm_vcpu_stat, generic.stat) \
 		},							       \
 		.name = #stat,						       \
 	}
-#define VM_STATS_DESC(stat, type, unit, base, exp)			       \
+#define VM_STATS_DESC(stat, type, unit, base, exp, sz, bsz)		       \
 	{								       \
 		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp),	       \
+			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
 			.offset = offsetof(struct kvm_vm_stat, stat)	       \
 		},							       \
 		.name = #stat,						       \
 	}
-#define VCPU_STATS_DESC(stat, type, unit, base, exp)			       \
+#define VCPU_STATS_DESC(stat, type, unit, base, exp, sz, bsz)		       \
 	{								       \
 		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp),	       \
+			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
 			.offset = offsetof(struct kvm_vcpu_stat, stat)	       \
 		},							       \
 		.name = #stat,						       \
 	}
 /* SCOPE: VM, VM_GENERIC, VCPU, VCPU_GENERIC */
-#define STATS_DESC(SCOPE, stat, type, unit, base, exp)			       \
-	SCOPE##_STATS_DESC(stat, type, unit, base, exp)
+#define STATS_DESC(SCOPE, stat, type, unit, base, exp, sz, bsz)		       \
+	SCOPE##_STATS_DESC(stat, type, unit, base, exp, sz, bsz)
 
 #define STATS_DESC_CUMULATIVE(SCOPE, name, unit, base, exponent)	       \
-	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_CUMULATIVE, unit, base, exponent)
+	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_CUMULATIVE,		       \
+		unit, base, exponent, 1, 0)
 #define STATS_DESC_INSTANT(SCOPE, name, unit, base, exponent)		       \
-	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_INSTANT, unit, base, exponent)
+	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_INSTANT,			       \
+		unit, base, exponent, 1, 0)
 #define STATS_DESC_PEAK(SCOPE, name, unit, base, exponent)		       \
-	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_PEAK, unit, base, exponent)
+	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_PEAK,			       \
+		unit, base, exponent, 1, 0)
+#define STATS_DESC_LINEAR_HIST(SCOPE, name, unit, base, exponent, sz, bsz)     \
+	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_LINEAR_HIST,		       \
+		unit, base, exponent, sz, bsz)
+#define STATS_DESC_LOG_HIST(SCOPE, name, unit, base, exponent, sz)	       \
+	STATS_DESC(SCOPE, name, KVM_STATS_TYPE_LOG_HIST,		       \
+		unit, base, exponent, sz, 0)
 
 /* Cumulative counter, read/write */
 #define STATS_DESC_COUNTER(SCOPE, name)					       \
@@ -1341,6 +1351,14 @@ struct _kvm_stats_desc {
 #define STATS_DESC_TIME_NSEC(SCOPE, name)				       \
 	STATS_DESC_CUMULATIVE(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
 		KVM_STATS_BASE_POW10, -9)
+/* Linear histogram for time in nanosecond */
+#define STATS_DESC_LINHIST_TIME_NSEC(SCOPE, name, sz, bsz)		       \
+	STATS_DESC_LINEAR_HIST(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
+		KVM_STATS_BASE_POW10, -9, sz, bsz)
+/* Logarithmic histogram for time in nanosecond */
+#define STATS_DESC_LOGHIST_TIME_NSEC(SCOPE, name, sz)			       \
+	STATS_DESC_LOG_HIST(SCOPE, name, KVM_STATS_UNIT_SECONDS,	       \
+		KVM_STATS_BASE_POW10, -9, sz)
 
 #define KVM_GENERIC_VM_STATS()						       \
 	STATS_DESC_COUNTER(VM_GENERIC, remote_tlb_flush)
@@ -1354,10 +1372,15 @@ struct _kvm_stats_desc {
 	STATS_DESC_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_ns)
 
 extern struct dentry *kvm_debugfs_dir;
+
 ssize_t kvm_stats_read(char *id, const struct kvm_stats_header *header,
 		       const struct _kvm_stats_desc *desc,
 		       void *stats, size_t size_stats,
 		       char __user *user_buffer, size_t size, loff_t *offset);
+void kvm_stats_linear_hist_update(u64 *data, size_t size,
+				  u64 value, size_t bucket_size);
+void kvm_stats_log_hist_update(u64 *data, size_t size, u64 value);
+
 extern const struct kvm_stats_header kvm_vm_stats_header;
 extern const struct _kvm_stats_desc kvm_vm_stats_desc[];
 extern const struct kvm_stats_header kvm_vcpu_stats_header;
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index ed6a985c5680..723f8a77a8ea 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -76,6 +76,21 @@ struct kvm_mmu_memory_cache {
 };
 #endif
 
+/* Constants used for histogram stats */
+#define LINHIST_SIZE_SMALL			10
+#define LINHIST_SIZE_MEDIUM			20
+#define LINHIST_SIZE_LARGE			50
+#define LINHIST_SIZE_XLARGE			100
+#define LINHIST_BUCKET_SIZE_SMALL		10
+#define LINHIST_BUCKET_SIZE_MEDIUM		100
+#define LINHIST_BUCKET_SIZE_LARGE		1000
+#define LINHIST_BUCKET_SIZE_XLARGE		10000
+
+#define LOGHIST_BUCKET_COUNT_SMALL		8
+#define LOGHIST_BUCKET_COUNT_MEDIUM		16
+#define LOGHIST_BUCKET_COUNT_LARGE		32
+#define LOGHIST_BUCKET_COUNT_XLARGE		64
+
 struct kvm_vm_stat_generic {
 	u64 remote_tlb_flush;
 };
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d9e4aabcb31a..a067410ebea5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1965,7 +1965,9 @@ struct kvm_stats_header {
 #define KVM_STATS_TYPE_CUMULATIVE	(0x0 << KVM_STATS_TYPE_SHIFT)
 #define KVM_STATS_TYPE_INSTANT		(0x1 << KVM_STATS_TYPE_SHIFT)
 #define KVM_STATS_TYPE_PEAK		(0x2 << KVM_STATS_TYPE_SHIFT)
-#define KVM_STATS_TYPE_MAX		KVM_STATS_TYPE_PEAK
+#define KVM_STATS_TYPE_LINEAR_HIST	(0x3 << KVM_STATS_TYPE_SHIFT)
+#define KVM_STATS_TYPE_LOG_HIST		(0x4 << KVM_STATS_TYPE_SHIFT)
+#define KVM_STATS_TYPE_MAX		KVM_STATS_TYPE_LOG_HIST
 
 #define KVM_STATS_UNIT_SHIFT		4
 #define KVM_STATS_UNIT_MASK		(0xF << KVM_STATS_UNIT_SHIFT)
@@ -1988,8 +1990,9 @@ struct kvm_stats_header {
  * @size: The number of data items for this stats.
  *        Every data item is of type __u64.
  * @offset: The offset of the stats to the start of stat structure in
- *          struture kvm or kvm_vcpu.
- * @unused: Unused field for future usage. Always 0 for now.
+ *          structure kvm or kvm_vcpu.
+ * @bucket_size: A parameter value used for histogram stats. It is only used
+ *		for linear histogram stats, specifying the size of the bucket;
  * @name: The name string for the stats. Its size is indicated by the
  *        &kvm_stats_header->name_size.
  */
@@ -1998,7 +2001,7 @@ struct kvm_stats_desc {
 	__s16 exponent;
 	__u16 size;
 	__u32 offset;
-	__u32 unused;
+	__u32 bucket_size;
 	char name[];
 };
 
diff --git a/virt/kvm/binary_stats.c b/virt/kvm/binary_stats.c
index e609d428811a..c134383f43a8 100644
--- a/virt/kvm/binary_stats.c
+++ b/virt/kvm/binary_stats.c
@@ -144,3 +144,35 @@ ssize_t kvm_stats_read(char *id, const struct kvm_stats_header *header,
 	*offset = pos;
 	return len;
 }
+
+/**
+ * kvm_stats_linear_hist_update() - Update bucket value for linear histogram
+ * statistics data.
+ *
+ * @data: start address of the stats data
+ * @size: the number of bucket of the stats data
+ * @value: the new value used to update the linear histogram's bucket
+ * @bucket_size: the size (width) of a bucket
+ */
+void kvm_stats_linear_hist_update(u64 *data, size_t size,
+				  u64 value, size_t bucket_size)
+{
+	size_t index = min((size_t)div64_u64(value, bucket_size), size - 1);
+
+	++data[index];
+}
+
+/**
+ * kvm_stats_log_hist_update() - Update bucket value for logarithmic histogram
+ * statistics data.
+ *
+ * @data: start address of the stats data
+ * @size: the number of bucket of the stats data
+ * @value: the new value used to update the logarithmic histogram's bucket
+ */
+void kvm_stats_log_hist_update(u64 *data, size_t size, u64 value)
+{
+	size_t index = min((size_t)fls64(value), size - 1);
+
+	++data[index];
+}
-- 
2.32.0.402.g57bb445576-goog

