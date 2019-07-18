Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F02906D40E
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 20:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfGRSiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 14:38:22 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:52668 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbfGRSiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 14:38:22 -0400
Received: by mail-pf1-f202.google.com with SMTP id a20so17089703pfn.19
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2019 11:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=n8VorecpPGmR7cZwCga8Jqx3nBBTF8cHAFyZf3z5/Dc=;
        b=OKg+YDslZgql7NzppycnzhnaaEHSefuv6GvCgntPJSplHAjZc3Wj2+Akp5UvKETYp1
         T95Eqc0Yasu59LBHw+0leU9b3aeA25+xjGThT62o0QUFVDhsg8mkcJLFc2UkvYeHU0xT
         T0MQWY0cbXxMWiww9TDF4UxcgRMmcqOcdHl/kdvRtuqgAg5uLKYmBSFps3EvfrY90UkK
         TObrzh8/82mfVxce6YozV1BoeMpA7KBT+H6bCnsdVijB6UUUNe5EtRnZrOFdmrIGp52h
         dV4qy52Rh+nnaH2Lrrvg+oU8dAybxCIS9itOR2snqSJCazsi7y7Zdn/LAKMdiqRF2s3V
         AhtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=n8VorecpPGmR7cZwCga8Jqx3nBBTF8cHAFyZf3z5/Dc=;
        b=Dm/c/2/NNY7qWoBiCJTBgE1cJAfAZhGVxZteQ9r7UYSnu+h/aZr9TNkWxMp26YBSTY
         uRUM6LV4WWH9q/eJOBXWhjGN7BDeCrt+jcD928xg7S8qdmkyhMouFsxHie9HCzQbhdSp
         KphXKOBubhIiyBIHfsgQVBfbmGqNUacsNw7abp18AwbYJZenQyq9AiT82j9v/tDDxL0O
         4PXPnMWdrM/Uf3VoQcCqAlMV6tWtGFcwYqWsRTAwOX5zHTxetACfCrktvSWuxQo9dfBn
         /vTJ/nFj0afZzFHByLA8jZrLVxNeaU7i+v8lbEKGtuvhMO+2AVrwmTzprLYHqge0gY1M
         sr5Q==
X-Gm-Message-State: APjAAAXuPHR5pA2eR4+j+o7aN2QWLaqF6lfcrB632OkzVPMLHMmkYVwh
        C52tB95YpkaldZc7WKQ33IdHmwFYHkrnhy0=
X-Google-Smtp-Source: APXvYqwW4ad1ldW7ulsb5U6WAMuDEcP6FnqUzvb+QMVND8OUDZGmfLBJdLJmNttOYZYKkh8hw/ddZU7cMQ+RCiQ=
X-Received: by 2002:a63:e5a:: with SMTP id 26mr47410389pgo.3.1563475101281;
 Thu, 18 Jul 2019 11:38:21 -0700 (PDT)
Date:   Thu, 18 Jul 2019 11:38:18 -0700
Message-Id: <20190718183818.190051-1-ehankland@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
Subject: [PATCH] KVM: x86: Add fixed counters to PMU filter
From:   Eric Hankland <ehankland@google.com>
To:     Wei Wang <wei.w.wang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        ehankland <ehankland@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: ehankland <ehankland@google.com>

Updates KVM_CAP_PMU_EVENT_FILTER so it can also whitelist or blacklist
fixed counters.

Signed-off-by: ehankland <ehankland@google.com>
---
 Documentation/virtual/kvm/api.txt | 13 ++++++++-----
 arch/x86/include/uapi/asm/kvm.h   |  9 ++++++---
 arch/x86/kvm/pmu.c                | 30 +++++++++++++++++++++++++-----
 3 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 2cd6250b2896..96bcf1aa1931 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -4090,17 +4090,20 @@ Parameters: struct kvm_pmu_event_filter (in)
 Returns: 0 on success, -1 on error
 
 struct kvm_pmu_event_filter {
-       __u32 action;
-       __u32 nevents;
-       __u64 events[0];
+	__u32 action;
+	__u32 nevents;
+	__u32 fixed_counter_bitmap;
+	__u32 flags;
+	__u32 pad[4];
+	__u64 events[0];
 };
 
 This ioctl restricts the set of PMU events that the guest can program.
 The argument holds a list of events which will be allowed or denied.
 The eventsel+umask of each event the guest attempts to program is compared
 against the events field to determine whether the guest should have access.
-This only affects general purpose counters; fixed purpose counters can
-be disabled by changing the perfmon CPUID leaf.
+The events field only controls general purpose counters; fixed purpose
+counters are controlled by the fixed_counter_bitmap.
 
 Valid values for 'action':
 #define KVM_PMU_EVENT_ALLOW 0
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index e901b0ab116f..503d3f42da16 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -435,9 +435,12 @@ struct kvm_nested_state {
 
 /* for KVM_CAP_PMU_EVENT_FILTER */
 struct kvm_pmu_event_filter {
-       __u32 action;
-       __u32 nevents;
-       __u64 events[0];
+	__u32 action;
+	__u32 nevents;
+	__u32 fixed_counter_bitmap;
+	__u32 flags;
+	__u32 pad[4];
+	__u64 events[0];
 };
 
 #define KVM_PMU_EVENT_ALLOW 0
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index aa5a2597305a..ae5cd1b02086 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -19,8 +19,8 @@
 #include "lapic.h"
 #include "pmu.h"
 
-/* This keeps the total size of the filter under 4k. */
-#define KVM_PMU_EVENT_FILTER_MAX_EVENTS 63
+/* This is enough to filter the vast majority of currently defined events. */
+#define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300
 
 /* NOTE:
  * - Each perf counter is defined as "struct kvm_pmc";
@@ -206,12 +206,25 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 {
 	unsigned en_field = ctrl & 0x3;
 	bool pmi = ctrl & 0x8;
+	struct kvm_pmu_event_filter *filter;
+	struct kvm *kvm = pmc->vcpu->kvm;
+
 
 	pmc_stop_counter(pmc);
 
 	if (!en_field || !pmc_is_enabled(pmc))
 		return;
 
+	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
+	if (filter) {
+		if (filter->action == KVM_PMU_EVENT_DENY &&
+		    test_bit(idx, (ulong *)&filter->fixed_counter_bitmap))
+			return;
+		if (filter->action == KVM_PMU_EVENT_ALLOW &&
+		    !test_bit(idx, (ulong *)&filter->fixed_counter_bitmap))
+			return;
+	}
+
 	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
 			      kvm_x86_ops->pmu_ops->find_fixed_event(idx),
 			      !(en_field & 0x2), /* exclude user */
@@ -376,7 +389,7 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_pmu_event_filter tmp, *filter;
 	size_t size;
-	int r;
+	int r, i;
 
 	if (copy_from_user(&tmp, argp, sizeof(tmp)))
 		return -EFAULT;
@@ -385,6 +398,13 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	    tmp.action != KVM_PMU_EVENT_DENY)
 		return -EINVAL;
 
+	if (tmp.flags != 0)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(tmp.pad); i++)
+		if (tmp.pad[i] != 0)
+			return -EINVAL;
+
 	if (tmp.nevents > KVM_PMU_EVENT_FILTER_MAX_EVENTS)
 		return -E2BIG;
 
@@ -406,8 +426,8 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	mutex_unlock(&kvm->lock);
 
 	synchronize_srcu_expedited(&kvm->srcu);
- 	r = 0;
+	r = 0;
 cleanup:
 	kfree(filter);
- 	return r;
+	return r;
 }
