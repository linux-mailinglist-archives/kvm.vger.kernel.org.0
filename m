Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2D179E0C0
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 09:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238578AbjIMHVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 03:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238572AbjIMHVh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 03:21:37 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A5A1984;
        Wed, 13 Sep 2023 00:21:33 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1bf7a6509deso45321545ad.3;
        Wed, 13 Sep 2023 00:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694589693; x=1695194493; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D/ngkpNgVCwSXdP3HY5FdIgEjBwwJbGVXPOVAzuvL3g=;
        b=c3Ae2kZgj4aZSOSsK37V36RDZxn4FFKdfIK+yd2ImjQ8J8Exx+adYRwXNvLMFjymIk
         874HD5r84TiZe9EkAupqKyTzsU3Un/bxwR0djk/oeZyFDbFiOyQi/lJKTffsXq2VrLaY
         94tQ5jWf4Py4DlhI9eGaecFBN4XCleXJ9BIZYQ3A5QVctiXMJ2QxALeWMFq03nXQcF6t
         vUgBALHbTIofZsXdakHs7OXcJzRvihRfsVfnsF6fl0bfC9f4n9CiiQU+NrsBoXH9AV1e
         Xt3ZDXRLoTroz5x1jwoRBKAuRoj2gHIVIKXGkitzMyiOKFhO/b3Lm4jOYzH1/9ZOx3pQ
         lN+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694589693; x=1695194493;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D/ngkpNgVCwSXdP3HY5FdIgEjBwwJbGVXPOVAzuvL3g=;
        b=JLGVeEg/ZiIMkcxxGpqRus5t69Vj8FWMFq5Etfk1NqXy1SoUxFUUl4AHZGY39YZYY8
         ZrNCh6Q3ajN3H8jRTdi5hrM4Zw900iVa9tZFEl1UHxAKe+VWmVC7xNBf+3hIr/0+ci4B
         KkhYlaZF4VG7VcC30+6U/njP+OVhqXW1PqdoPbg+ki5Kja1TbSjrsEvZRHxj7B8XHmUe
         lHbP0Xl1iqadlby4+UggZ8SuZ25fWJB7H6WXWpuMwC+UP9o1cZx1y+0lu9nszjyflqRi
         P325WKzLTij4hqGFE2Dr5P0V6kSDc8FIT/0vaq7aDpH+SR/G1hs+DhFRJO0X/HwlUlqx
         bblA==
X-Gm-Message-State: AOJu0Yw/VOGSd6PRLrgmd/RtfDTgPKWLn9tUI6kbSc1rfBU+xyE/xtfU
        ZOxAFvqmts90L/ahWKg+98g=
X-Google-Smtp-Source: AGHT+IEGCHwG4VwUhvCzNTy/QaH1rjWUOgIQpid7iI3ZfdVpUimI7jnL6M4OeIfgXOuE7fbtkuQ5AA==
X-Received: by 2002:a17:902:d70a:b0:1c3:8230:30d8 with SMTP id w10-20020a170902d70a00b001c3823030d8mr1973677ply.38.1694589693056;
        Wed, 13 Sep 2023 00:21:33 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id n16-20020a170902e55000b001b0358848b0sm9743153plf.161.2023.09.13.00.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 00:21:32 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5] KVM: x86/tsc: Don't sync TSC on the first write in state restoration
Date:   Wed, 13 Sep 2023 15:21:13 +0800
Message-ID: <20230913072113.78885-1-likexu@tencent.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Add kvm->arch.user_set_tsc to avoid synchronization on the first write
from userspace so as not to misconstrue state restoration after live
migration as an attempt from userspace to synchronize. More precisely,
the problem is that the sync code doesn't differentiate between userspace
initializing the TSC and userspace attempting to synchronize the TSC.

Reported-by: Yong He <alexyonghe@tencent.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217423
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Original-by: Sean Christopherson <seanjc@google.com>
Tested-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
V4 -> V5 Changelog:
- Making kvm_synchronize_tsc(@data) a pointer and passing NULL; (Sean)
- Refine commit message in a more accurate way; (Sean)
V4: https://lore.kernel.org/kvm/20230801034524.64007-1-likexu@tencent.com/

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 25 ++++++++++++++++---------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1a4def36d5bb..9a7dfef9d32d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1324,6 +1324,7 @@ struct kvm_arch {
 	int nr_vcpus_matched_tsc;
 
 	u32 default_tsc_khz;
+	bool user_set_tsc;
 
 	seqcount_raw_spinlock_t pvclock_sc;
 	bool use_master_clock;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6c9c81e82e65..0fef6ed69cbb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2714,8 +2714,9 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	kvm_track_tsc_matching(vcpu);
 }
 
-static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
+static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
 {
+	u64 data = user_value ? *user_value : 0;
 	struct kvm *kvm = vcpu->kvm;
 	u64 offset, ns, elapsed;
 	unsigned long flags;
@@ -2728,14 +2729,17 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	elapsed = ns - kvm->arch.last_tsc_nsec;
 
 	if (vcpu->arch.virtual_tsc_khz) {
+		/*
+		 * Force synchronization when creating or hotplugging a vCPU,
+		 * i.e. when the TSC value is '0', to help keep clocks stable.
+		 * If this is NOT a hotplug/creation case, skip synchronization
+		 * on the first write from userspace so as not to misconstrue
+		 * state restoration after live migration as an attempt from
+		 * userspace to synchronize.
+		 */
 		if (data == 0) {
-			/*
-			 * detection of vcpu initialization -- need to sync
-			 * with other vCPUs. This particularly helps to keep
-			 * kvm_clock stable after CPU hotplug
-			 */
 			synchronizing = true;
-		} else {
+		} else if (kvm->arch.user_set_tsc) {
 			u64 tsc_exp = kvm->arch.last_tsc_write +
 						nsec_to_cycles(vcpu, elapsed);
 			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
@@ -2749,6 +2753,9 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 		}
 	}
 
+	if (user_value)
+		kvm->arch.user_set_tsc = true;
+
 	/*
 	 * For a reliable TSC, we can match TSC offsets, and for an unstable
 	 * TSC, we add elapsed time in this computation.  We could let the
@@ -3777,7 +3784,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_TSC:
 		if (msr_info->host_initiated) {
-			kvm_synchronize_tsc(vcpu, data);
+			kvm_synchronize_tsc(vcpu, &data);
 		} else {
 			u64 adj = kvm_compute_l1_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
 			adjust_tsc_offset_guest(vcpu, adj);
@@ -11959,7 +11966,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	if (mutex_lock_killable(&vcpu->mutex))
 		return;
 	vcpu_load(vcpu);
-	kvm_synchronize_tsc(vcpu, 0);
+	kvm_synchronize_tsc(vcpu, NULL);
 	vcpu_put(vcpu);
 
 	/* poll control enabled by default */

base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
-- 
2.42.0

