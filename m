Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E95DE6224
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2019 12:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfJ0LMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 07:12:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:12498 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbfJ0LMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 07:12:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 04:12:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,236,1569308400"; 
   d="scan'208";a="282690181"
Received: from unknown (HELO snr.jf.intel.com) ([10.54.39.141])
  by orsmga001.jf.intel.com with ESMTP; 27 Oct 2019 04:12:42 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, thomas.lendacky@amd.com,
        peterz@infradead.org, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 8/8] perf/x86: Add event owner check when PEBS output to Intel PT
Date:   Sun, 27 Oct 2019 19:11:17 -0400
Message-Id: <1572217877-26484-9-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For PEBS output to Intel PT, a Intel PT event should be the group
leader of an PEBS counter event in host. For Intel PT
virtualization enabling in KVM guest, the PT facilities will be
passthrough to guest and do not allocate PT event from host perf
event framework. This is different with PMU virtualization.

Intel new hardware feature that can make PEBS enabled in KVM guest
by output PEBS records to Intel PT buffer. KVM need to allocate
a event counter for this PEBS event without Intel PT event leader.

This patch add event owner check for PEBS output to PT event that
only non-kernel event need group leader(PT).

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/events/core.c     | 3 ++-
 include/linux/perf_event.h | 1 +
 kernel/events/core.c       | 2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 7b21455..214041a 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1014,7 +1014,8 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
 		 * away, the group was broken down and this singleton event
 		 * can't schedule any more.
 		 */
-		if (is_pebs_pt(leader) && !leader->aux_event)
+		if (is_pebs_pt(leader) && !leader->aux_event &&
+					!is_kernel_event(leader))
 			return -EINVAL;
 
 		/*
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 61448c1..22ef4b0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -928,6 +928,7 @@ int perf_event_read_local(struct perf_event *event, u64 *value,
 extern u64 perf_event_read_value(struct perf_event *event,
 				 u64 *enabled, u64 *running);
 
+extern bool is_kernel_event(struct perf_event *event);
 
 struct perf_sample_data {
 	/*
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9ec0b0b..00f943b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -166,7 +166,7 @@ static void perf_ctx_unlock(struct perf_cpu_context *cpuctx,
 
 #define TASK_TOMBSTONE ((void *)-1L)
 
-static bool is_kernel_event(struct perf_event *event)
+bool is_kernel_event(struct perf_event *event)
 {
 	return READ_ONCE(event->owner) == TASK_TOMBSTONE;
 }
-- 
1.8.3.1

