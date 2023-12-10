Return-Path: <kvm+bounces-4000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AFF2E80B9D3
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 09:16:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DEA71F2109A
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 08:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B6276D3F;
	Sun, 10 Dec 2023 08:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="cF2dG0Hq"
X-Original-To: kvm@vger.kernel.org
Received: from AUS01-SY4-obe.outbound.protection.outlook.com (mail-sy4aus01olkn2173.outbound.protection.outlook.com [40.92.62.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873BBC6;
	Sun, 10 Dec 2023 00:16:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mj0hX3eJ9ZuLGB/elM4zySzuVt0TNhPdFikrBqJnjUpsni6fkF2e0iIop3Y2Q8KZP+DbjNtKY42LWqJ+0AjfDy6XZADwZ2VrN9wUCQ44sWPlsrsLZXM8LzNACFt3hV8WIxj98Bc/wmMemAtuhhtGAh7Xxe0OVLcsMb/JFGJ4uz3dbqDn1Fz/R6CAt1DCQvEJjPqt2UoxeXf6ngDduifHyhBploOv4Vfav4khvyjBfKJ1glYA0UUxQLkSPR0yyAPMx7z+jlnAkJ+enl/OQMkqT4i2hMm5VLX33zEJUlNKAhtPAiUvU7rvkoLFYL29g+hYBJPY7TTTDYPOC+6W2cYaZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Dm06ddVNFaxYjCFCM3kfRfk86yrs5hrGvGUIaB4XIQ=;
 b=H5m3CRJ+h2jkPh1ujCOy/kKiS1guOB3ld9IqmULfn7jXkJrr2oAvx+JTKdvzSWVDmittOziJpSo7X/QwWhuTBoTVjjF72rPjS4RCpk5arW9ERrkbnMlL7c4cp8AMnn5gqUQL6CW6Z6uz/lxYnqZvS9bFbfk0V/ltNRtU9aYNfUcGDBiKh4zn5GTrRhf+PYhd4al7L6uZjohhExfo1aC/am9TOOoXCoPWlJtfPvfXs0w2J6UjJQnN9TKald9pt6hm/+gbJnV9dE2QeirAJEDZdc4OHX6KouEVzJpkM3THYqlDEEf+vUUUD/WgP+ai5hVwylr5lyCIxJu4yPdXSpRshg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Dm06ddVNFaxYjCFCM3kfRfk86yrs5hrGvGUIaB4XIQ=;
 b=cF2dG0Hq01NqygOCJrHGxHm0Xu//oOJLuGLcSqLcnLRcu1ZMsSbbieibiiU/rJ2ukhH3TQvWkU6Xv+hfMr473I85ujQ2+uXKDhZkq+yC+9z+l1QgDiyGnrf6fakfp97/Gf1fzXtsC1qp6zeizlqPQ0H1gfiGNMlAI9WEw8XkuaTVVr6Dtf+xPGibq5a3SYC57vy8XqEHK8siD2mDGtS0a9IrRYkLF9gPt1orfw3hTX1JrG2EJ5qASdOka9ui50FIIL+zF9jo+/hpLSUVD69S5MlPHxti7m21iVS3sYJF6iT4tiYg/BcCfW8Gh+qt0HgTocjSXM0TWNlreyZ7JB7Fkw==
Received: from SYBPR01MB6870.ausprd01.prod.outlook.com (2603:10c6:10:13d::10)
 by MEYPR01MB7339.ausprd01.prod.outlook.com (2603:10c6:220:15f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.31; Sun, 10 Dec
 2023 08:16:08 +0000
Received: from SYBPR01MB6870.ausprd01.prod.outlook.com
 ([fe80::be5a:160f:5418:9deb]) by SYBPR01MB6870.ausprd01.prod.outlook.com
 ([fe80::be5a:160f:5418:9deb%5]) with mapi id 15.20.7068.030; Sun, 10 Dec 2023
 08:16:08 +0000
From: Tianyi Liu <i.pear@outlook.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	mark.rutland@arm.com,
	mlevitsk@redhat.com,
	maz@kernel.org,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	namhyung@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	Tianyi Liu <i.pear@outlook.com>
Subject: [PATCH v3 4/5] perf kvm: Support sampling guest callchains
Date: Sun, 10 Dec 2023 16:15:48 +0800
Message-ID:
 <SYBPR01MB687083237B0E5C03B63EDAB99D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <SYBPR01MB687069BFC9744585B4EEF8C49D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
References: <SYBPR01MB687069BFC9744585B4EEF8C49D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [nxBWVOlGmlQ1xJ5XQuc0c+ocO9VbnVgbjQH4feY1jj5utdNLizQTHA==]
X-ClientProxiedBy: SG2PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:3:18::18) To SYBPR01MB6870.ausprd01.prod.outlook.com
 (2603:10c6:10:13d::10)
X-Microsoft-Original-Message-ID: <20231210081548.2393-1-i.pear@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB6870:EE_|MEYPR01MB7339:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d39b20f-c1d9-4f08-bba9-08dbf95842da
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VhPLNFUfwgorjBnkLaWC5U1szG1SdKQi6pcJe1PewNYQZSkE6BXUaCcxPdkMq3mbvQeYKlOWLWsn0LqLfdkKMdMAetIfSFttTlmUGoKV1Tvsx+koV04M1BqzZLbUWbySzg9xGduQX8yah1csehOEhrHhNfKQ+UtvhwkDRHqlULo/cQBsr6rPlwjuPxm3+EggnCewLEN+FcfHVi4qTjiVGfHVZv0EsEg7sZYVQhXRjP97x6rdqXNNHggnQ9VsBEp1NUzvg9wIMwCHBxZD3/K2BLzPM1tUV+sdwYrd9uYhtZuHrLKzEupgL6Jz0Vqrn1N1wkZh3my/0IONp7QkNu4DE5YFg7myIVm2gkdyGnM3u0IqEcEw5Voq28mfXVekltLyjF7I/NJVyrVLqxzYE4ECf2bfc7qchqdmEeYdG9VO24V2Pc00LCon5owPPGF1+ShcxSHJOULNdWbw6OTlGSkuJid+MiBH/eWHB43wqQ2dj3jbOYr+SzHey+KzJ2jyfmfqeqQ3JDKh/4BpgdTpu5Ls5hQCzDwBMgg7GVoIdbeRqyBA3tGEyuK+0QdtgmmB5Ds2gqbokmEnY1IQHbLcWGquZHSf6Aw2AjUs4j27q7GMo+Q=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+WtLDFreWex/oyTB+gwN0IGw+9NNRbtghoEoDiHw6KMiHj+/oXnrLrNnyaJv?=
 =?us-ascii?Q?AjF7gn3zMR0uzkrW/4nhSzPpXLLE402wCO/Yhh/uuSP4BmhUrI8aUm2f5Sf0?=
 =?us-ascii?Q?ja2v1Pp86BAdGszX1rRJF7TixVEkn79gV5XlYqcYDWwljukt0kYVoUvBKCNm?=
 =?us-ascii?Q?E1XNTd8/VsJ2MxsEL7eNQn/HdRjw48KjxNqcHPIBeqsDwV2VF+ss77GvXAHN?=
 =?us-ascii?Q?2WePb1ECTyEfOA45aBUscN28gnL4d5H2BoYGg5dpK/h86lO7RLAh9htcpzJp?=
 =?us-ascii?Q?jBjz//WBPSWd0rzNP6sF3cPLTuyXXitbH/3kmNnr5RaYYmWKNG9VVPHGKZDk?=
 =?us-ascii?Q?2d18VuveByIOpXpalPQ8edzM6ak3MpbWz8wGASHeb1EEwnj2f1DM5hNset2s?=
 =?us-ascii?Q?pGy5ygQ7gr0jVKZwmgrmZ7LcjIsxjnlSELcLkbJ04ceYIRYFe9jnBDliFulq?=
 =?us-ascii?Q?6p4mTf2FuthkiEnLzenhsh+26N+1u4Pa9RObcpiOqXNM8OpUe4svp55PGF81?=
 =?us-ascii?Q?9LDE+6UatH7nwofd+c+B+0klA/cSHq1jt5DF8x7BO10VR85oE+xfgBB6k61q?=
 =?us-ascii?Q?82lnjuMMB7hQ1G1sR7GvjA2lvVUfiVF7FV+GKH0ZNCW2io9VqTN2q3lzNTwn?=
 =?us-ascii?Q?3qgnMYUlZQF/IGmCn3gFR2TCOlfJwax3O6a4DeLiET4eATqnXKGPq0e+t9di?=
 =?us-ascii?Q?7fwaviiyiB2MgSBz9BdY6XssLo0EItLnuHbq3PLYXXtP6bUAiMM5IMCf5Utq?=
 =?us-ascii?Q?8j0VYjVVC7L6wrXIYxdKnMbCrOL+qJL4dfEhDpwYooO1mKj0EtRxpnvI78CG?=
 =?us-ascii?Q?AId4SxvdNHR+YBiX8RnSYh1+Jr2sIs77F7P75woy8pvWkDBqNcx/TFmChokJ?=
 =?us-ascii?Q?qWyxhWWjPceUzDnKW4htziWeYT/hDfIvEtdUAUXxdS8bhP4WBtvuIwtp7yoP?=
 =?us-ascii?Q?OlyIc0YaOk/BUHsZqkC6YIR6myUJRZIRsaQ7BdPkqSw7fX8/7MXLZb8r+iC4?=
 =?us-ascii?Q?or37WdKPfPPgtxy0DInWxwFXlCzH9Pi1bjDVPkMlukLl2Yas+c1eRCto7HBy?=
 =?us-ascii?Q?q5FG4KJgOZ83HPZatzvjlz0dhFyVHPWBKQgwX5g6WkhOYGkaJ55vAtFRXllA?=
 =?us-ascii?Q?A7snwmDYkkf4TGGkNMGgofqH3hY5kAsXRcwQEE31QhIyXqzBTv0FQEdhWXzc?=
 =?us-ascii?Q?NPX3mU0AwftYxzoLoKr/W+MBK/JE4jRCreNZ82coyUdO9EJnEPMpN8nwKb72?=
 =?us-ascii?Q?PHAY8jkwq2H3ftlJxIJX?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d39b20f-c1d9-4f08-bba9-08dbf95842da
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB6870.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2023 08:16:07.9711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MEYPR01MB7339

This patch provides support for sampling guests' callchains.

The signature of `get_perf_callchain` has been modified to explicitly
specify whether it needs to sample the host or guest callchain. Based on
the context, `get_perf_callchain` will distribute each sampling request
to one of `perf_callchain_user`, `perf_callchain_kernel`,
or `perf_callchain_guest`.

The reason for separately implementing `perf_callchain_user` and
`perf_callchain_kernel` is that the kernel may utilize special unwinders
like `ORC`. However, for the guest, we only support stackframe-based
unwinding, so the implementation is generic and only needs to be
separately implemented for 32-bit and 64-bit.

Signed-off-by: Tianyi Liu <i.pear@outlook.com>
---
 arch/x86/events/core.c     | 63 ++++++++++++++++++++++++++++++++------
 include/linux/perf_event.h |  3 +-
 kernel/bpf/stackmap.c      |  8 ++---
 kernel/events/callchain.c  | 27 +++++++++++++++-
 kernel/events/core.c       |  7 ++++-
 5 files changed, 91 insertions(+), 17 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 40ad1425ffa2..4ff412225217 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2758,11 +2758,6 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
 	struct unwind_state state;
 	unsigned long addr;
 
-	if (perf_guest_state()) {
-		/* TODO: We don't support guest os callchain now */
-		return;
-	}
-
 	if (perf_callchain_store(entry, regs->ip))
 		return;
 
@@ -2778,6 +2773,59 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
 	}
 }
 
+static inline void
+perf_callchain_guest32(struct perf_callchain_entry_ctx *entry,
+		       const struct perf_kvm_guest_unwind_info *unwind_info)
+{
+	unsigned long ss_base, cs_base;
+	struct stack_frame_ia32 frame;
+	const struct stack_frame_ia32 *fp;
+
+	cs_base = unwind_info->segment_cs_base;
+	ss_base = unwind_info->segment_ss_base;
+
+	fp = (void *)(ss_base + unwind_info->frame_pointer);
+	while (fp && entry->nr < entry->max_stack) {
+		if (!perf_guest_read_virt((unsigned long)&fp->next_frame,
+					  &frame.next_frame, sizeof(frame.next_frame)))
+			break;
+		if (!perf_guest_read_virt((unsigned long)&fp->return_address,
+					  &frame.return_address, sizeof(frame.return_address)))
+			break;
+		perf_callchain_store(entry, cs_base + frame.return_address);
+		fp = (void *)(ss_base + frame.next_frame);
+	}
+}
+
+void
+perf_callchain_guest(struct perf_callchain_entry_ctx *entry)
+{
+	struct stack_frame frame;
+	const struct stack_frame *fp;
+	struct perf_kvm_guest_unwind_info unwind_info;
+
+	if (!perf_guest_get_unwind_info(&unwind_info))
+		return;
+
+	perf_callchain_store(entry, unwind_info.ip_pointer);
+
+	if (unwind_info.is_guest_64bit) {
+		fp = (void *)unwind_info.frame_pointer;
+		while (fp && entry->nr < entry->max_stack) {
+			if (!perf_guest_read_virt((unsigned long)&fp->next_frame,
+				&frame.next_frame, sizeof(frame.next_frame)))
+				break;
+			if (!perf_guest_read_virt((unsigned long)&fp->return_address,
+				&frame.return_address, sizeof(frame.return_address)))
+				break;
+			perf_callchain_store(entry, frame.return_address);
+			fp = (void *)frame.next_frame;
+		}
+	} else {
+		perf_callchain_guest32(entry, &unwind_info);
+	}
+}
+
 static inline int
 valid_user_frame(const void __user *fp, unsigned long size)
 {
@@ -2861,11 +2909,6 @@ perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs
 	struct stack_frame frame;
 	const struct stack_frame __user *fp;
 
-	if (perf_guest_state()) {
-		/* TODO: We don't support guest os callchain now */
-		return;
-	}
-
 	/*
 	 * We don't know what to do with VM86 stacks.. ignore them for now.
 	 */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index dacc1623dcaa..483578672868 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1552,9 +1552,10 @@ DECLARE_PER_CPU(struct perf_callchain_entry, perf_callchain_entry);
 
 extern void perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs);
 extern void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs);
+extern void perf_callchain_guest(struct perf_callchain_entry_ctx *entry);
 extern struct perf_callchain_entry *
 get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
-		   u32 max_stack, bool crosstask, bool add_mark);
+		   bool host, bool guest, u32 max_stack, bool crosstask, bool add_mark);
 extern int get_callchain_buffers(int max_stack);
 extern void put_callchain_buffers(void);
 extern struct perf_callchain_entry *get_callchain_entry(int *rctx);
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index d6b277482085..5ca41ca08d8a 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -294,8 +294,8 @@ BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, map,
 	if (max_depth > sysctl_perf_event_max_stack)
 		max_depth = sysctl_perf_event_max_stack;
 
-	trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
-				   false, false);
+	trace = get_perf_callchain(regs, 0, kernel, user, true, false,
+				   max_depth, false, false);
 
 	if (unlikely(!trace))
 		/* couldn't fetch the stack trace */
@@ -420,8 +420,8 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 	else if (kernel && task)
 		trace = get_callchain_entry_for_task(task, max_depth);
 	else
-		trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
-					   false, false);
+		trace = get_perf_callchain(regs, 0, kernel, user, true, false,
+					   max_depth, false, false);
 	if (unlikely(!trace))
 		goto err_fault;
 
diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 1273be84392c..7e80729e95d0 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -45,6 +45,10 @@ __weak void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 {
 }
 
+__weak void perf_callchain_guest(struct perf_callchain_entry_ctx *entry)
+{
+}
+
 static void release_callchain_buffers_rcu(struct rcu_head *head)
 {
 	struct callchain_cpus_entries *entries;
@@ -178,11 +182,12 @@ put_callchain_entry(int rctx)
 
 struct perf_callchain_entry *
 get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
-		   u32 max_stack, bool crosstask, bool add_mark)
+		   bool host, bool guest, u32 max_stack, bool crosstask, bool add_mark)
 {
 	struct perf_callchain_entry *entry;
 	struct perf_callchain_entry_ctx ctx;
 	int rctx;
+	unsigned int guest_state;
 
 	entry = get_callchain_entry(&rctx);
 	if (!entry)
@@ -194,6 +199,26 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 	ctx.contexts       = 0;
 	ctx.contexts_maxed = false;
 
+	guest_state = perf_guest_state();
+	if (guest_state) {
+		if (!guest)
+			goto exit_put;
+		if (user && (guest_state & PERF_GUEST_USER)) {
+			if (add_mark)
+				perf_callchain_store_context(&ctx, PERF_CONTEXT_GUEST_USER);
+			perf_callchain_guest(&ctx);
+		}
+		if (kernel && !(guest_state & PERF_GUEST_USER)) {
+			if (add_mark)
+				perf_callchain_store_context(&ctx, PERF_CONTEXT_GUEST_KERNEL);
+			perf_callchain_guest(&ctx);
+		}
+		goto exit_put;
+	}
+
+	if (unlikely(!host))
+		goto exit_put;
+
 	if (kernel && !user_mode(regs)) {
 		if (add_mark)
 			perf_callchain_store_context(&ctx, PERF_CONTEXT_KERNEL);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4c5e35006217..3dea3fe840e6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7607,6 +7607,8 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
 {
 	bool kernel = !event->attr.exclude_callchain_kernel;
 	bool user   = !event->attr.exclude_callchain_user;
+	bool host   = !event->attr.exclude_host;
+	bool guest  = !event->attr.exclude_guest;
 	/* Disallow cross-task user callchains. */
 	bool crosstask = event->ctx->task && event->ctx->task != current;
 	const u32 max_stack = event->attr.sample_max_stack;
@@ -7615,7 +7617,10 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
 	if (!kernel && !user)
 		return &__empty_callchain;
 
-	callchain = get_perf_callchain(regs, 0, kernel, user,
+	if (!host && !guest)
+		return &__empty_callchain;
+
+	callchain = get_perf_callchain(regs, 0, kernel, user, host, guest,
 				       max_stack, crosstask, true);
 	return callchain ?: &__empty_callchain;
 }
-- 
2.34.1


