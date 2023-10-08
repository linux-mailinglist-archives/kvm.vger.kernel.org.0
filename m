Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F0C7BCEFF
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 16:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344838AbjJHO5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 10:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbjJHO5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 10:57:30 -0400
Received: from AUS01-ME3-obe.outbound.protection.outlook.com (mail-me3aus01olkn2140.outbound.protection.outlook.com [40.92.63.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F11EB6;
        Sun,  8 Oct 2023 07:57:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2aHIwtqVtzsC3fIgp/rS6PKTqWp+BTjtAOOgH9G+lpZhq0W4COHrYAg2Tp1jMonhbuvguwOhKcCuNcQzkYyEVtrCAcccX5aj1sYWc4LW+m16ToJFk2BtwtuwMxQoOIA8faXO2R126DDPEGLMlITyVw+J+hudQXzhm97sXfL4i7f+uQQjH0Y0lgv+ev0sP8fkcoj3ieU7k7mjLSyRxNUUbtujfoFx4Tg+UnK51iyWawqGkvJ//5x7r2eDmZbuGzXSey3Sy8GbBPxS7PM/YdlLDhed7PYpuApU3FRAlAxcjpSt2pp9GIqF1nKXmfqHfAtXx/6CkRlLrByyoAq8DK+XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xaVtEI2qhZS1oaf1GD6pfFXb2t0VmkXD8ySWzedGCOg=;
 b=DD3LT+211aRgc/xu82MIVPJjxxRhS9lpm6BmYQra15ASapkmoNScC7KoPAuNFUEiRq+aXZD7fshPI+YZIloIwAZDfRmZdPZrq8Ff2N3icRtyovuhngzWEOoqg5hqInv29EcAENsefldGLE0qfNNq78VWiP6BGKdasLMEk3A4qtb9yt8RG981SzHx6/PO9N1cbPF4vFirHiWgsmMRWhVc+N0yVtCbD2gmrGDV6qwJCmVkImZXc2GMSBeiUN7QAJyWFwBeV2FRPBv0wlhRixnxNu13U7x4KXx64UoMHLv8kd8ZlJtCOrADuNh6NNAiMb4cPicdN67oHxzBc9zAiZ5Slg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xaVtEI2qhZS1oaf1GD6pfFXb2t0VmkXD8ySWzedGCOg=;
 b=q8ZOJ0nG9CezlFn/JA62IxEMYlsQ89/guLRN2hzSwLUR/jJr6Y86oRdzIaPfDj4EWbOcfydyrJ4BISs8oAt8q1zB67SiHR5TmqwxauvTHavqUT3EI4RfTlWu2MLcezScZNSUQ6etumDj27h62QA7vsyT+r3H2JYilFSUgZAlCzocfUbyXj/e3ofn+EUkWk3NH06iz458294Ie3xVgz2eiqdAUhULq57amQQALw1X0AVBczK2M3pK6D01kM3BbP7XS4F+ezHUChN1k+NTS9jmwJ5hCXpJWjjl9fA4eg+b1j1XNuylTtPKjC95r5/C4CHzi3nnIP4ZMo0G2spFdfGXyA==
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:ac::13) by
 SY4P282MB1371.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:a2::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6813.21; Sun, 8 Oct 2023 14:57:21 +0000
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8]) by SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8%3]) with mapi id 15.20.6838.040; Sun, 8 Oct 2023
 14:57:21 +0000
From:   Tianyi Liu <i.pear@outlook.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, irogers@google.com, adrian.hunter@intel.com,
        Tianyi Liu <i.pear@outlook.com>
Subject: [PATCH v2 4/5] perf kvm: Support sampling guest callchains
Date:   Sun,  8 Oct 2023 22:57:06 +0800
Message-ID: <SY4P282MB108433024762F1F292D47C2A9DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <SY4P282MB1084ECBCC1B176153B9E2A009DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
References: <SY4P282MB1084ECBCC1B176153B9E2A009DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [mxPKa+D4OVm2IXQpeo58T38hSdmEF4oisq/ZqhpUqUk8kXqnb4yeoA==]
X-ClientProxiedBy: SG2PR01CA0169.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::25) To SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:ac::13)
X-Microsoft-Original-Message-ID: <20231008145706.7852-1-i.pear@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY4P282MB1084:EE_|SY4P282MB1371:EE_
X-MS-Office365-Filtering-Correlation-Id: 22d375be-0d9b-4a9c-5446-08dbc80edf01
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S5HEydAcY269XC9TGJCQosaOfFgGHtCzYOydt41s6i3F6LHW06308AEma2GJO4qfscm3oEydZ7A7+J7RfQGV5Xv4q60kkyADqATVPggKRl3y4OVpIXAw05sH1eyeQ8Wu0245/47k4wR9+mdJ+Glyie1P8ZQ3n56TEt8IDzUdY4i562jGuELGLCnc6xyoYMD989cyuWOf13TNTpTF/M5ZoS5kYho9D1HYHOmmM7v09pHahdqdW+BQrJ/psq93wbjyNFBG8NDF1t2jW7rynGG3WvGMjOjqWkPRLmKFxZlHQBf0phPm/XGEzrg/Kp7PELB43zx9He0vFhKw9cA8p19CN4gH6+BP1fqsnlOAK/Erdyou57Aq7nh5pmmojUZSXRvcKec96rW2EBasiplQ7ZXCjZRXZYmIbvaeVzDkZSRfXIp438Z5r4mRg2NisRAgp+my3h5qt9u0GOzKxrdYj4PlhbE/GeDs9alTxbfcNBytFjIts9MaIQ7yZwIpghJKpgpz4OLiHemk8HvAZYCCgr4HSVQzPzHkPiJ5oDd54dPyKbkSCMepiSckSbAvw5qa0DAypvwVFAS2mPc9Rf5s91N4MU5x6/Frg3O2P/w8ozIsLTiU/s3zQ+dVoJAUfC6y2uQE
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UCxwr112mtbwbZKYgG+RF54xsB4PtQeS4trJk0rYIx4YJL53vGetv+qrOB9b?=
 =?us-ascii?Q?SdHqyZVUe4ofdWK+EZiblOJvh4wzSY57Fj/L2cdxIp7jZqgg98b7uqiCsL5w?=
 =?us-ascii?Q?I1WiLu/nmPFUEwNC0SdOml/tikRrotX9qpHhxvqZqSypXhuwu/eniyM4G5lg?=
 =?us-ascii?Q?u7o1keCWgQQ36XQ65rtaw2I3bQo4ugGGDZjWRCJTQp354kgdMaOaU20V2Guy?=
 =?us-ascii?Q?fwmsQx9Ifs1XlKejJ0I8vJ2Az/4AfFnoWYNDdSsTD40ATgrSrMFvMGie7jsa?=
 =?us-ascii?Q?hBaeFo+3tU9pVuhZeOmP0ZqO4xYScxoMT71LlJABHUSqt5wDOG3HJcpHb23b?=
 =?us-ascii?Q?FU+70YnGEF9MN0+tlvNvL6SPgqEnBSWQdiXeWlvzMiVa/qa7qU5N82liQlMV?=
 =?us-ascii?Q?3i4yJU6EEqEeqnaZN/EsSL/ycXurKrxtBDsdRGFrtdHoLh6LkBW8eP2WddiZ?=
 =?us-ascii?Q?fKZCK2TIAsU7kKB3gNMMR8l8RJ0PNcpfq51s6bWf0coYQvhebM9GAb+JqV/O?=
 =?us-ascii?Q?FXR6VpD6I2hyv3Na+Agz0ihadT4ndhgFgQ4MfLjqhV4HxPNW/YSRLZFNCewS?=
 =?us-ascii?Q?9VDaSxiVeMWF6tYCpmxP5FAS0wlegv9fV5hNUFWi9WZSyYB/G0jewyPfdkZR?=
 =?us-ascii?Q?Y0dCPnf0w2ZJ6MhXix4ydhRIuZdbDBak1oTowqu0g3f7MverxtzMIA7e8s2p?=
 =?us-ascii?Q?x3sIr4IpnwzzwuhSweW79VKvg4WGb1Vwre/rVFkxX+NHj/Zzh1+QXX95TrBX?=
 =?us-ascii?Q?Ad182Rjt2rtjqAfg/Hvxg6drEaybd9+aFcMVW8c45+TKknMYYbv+SsoFXIO+?=
 =?us-ascii?Q?jS+ALgj3qgkc4MJ1s5M/nOOReRfsILq3g5lV8JE9ozOC0JWVSzJB21kfDIMt?=
 =?us-ascii?Q?+dZmvKU5KMKOaUw3X7fcmeidGZ+piM48VPqfaoOpOKrPD1fk3CGlDkCe2bYt?=
 =?us-ascii?Q?ICoNdHy6SVnCjh8pkkveTLAAAfc47pqBeaBUeAmgnTpgrGelooDJYeLXp8ID?=
 =?us-ascii?Q?I9QtmdpGVcXtVoE/eN9Ybbh6TqRk7JoALy3prVASWrLuDFP0pQxsU8/cXk+J?=
 =?us-ascii?Q?Sfwhnc+J1QfZ3I24E5kGbt/9yse/SxJwiibC+ZEQOYXLUKFMWmwxoGtAWiyi?=
 =?us-ascii?Q?yOx9zKDaXWEsk8F4B6kyVkRq/G+2ya7x4iFLXwxfCvspn2BQMp71aR5K8QPV?=
 =?us-ascii?Q?9lD5mvkqiJEuWhsjkKScGlqoNMK4BeYmMKAe2KyDrd8r0MX8UvWEMKnKkpGQ?=
 =?us-ascii?Q?r93zJTxHjSAq3aEX3Di2?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22d375be-0d9b-4a9c-5446-08dbc80edf01
X-MS-Exchange-CrossTenant-AuthSource: SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2023 14:57:21.1465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY4P282MB1371
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch provides support for sampling guests' callchains.

The signature of `get_perf_callchain` has been modified to explicitly
specify whether it needs to sample the host or guest callchain.
Based on the context, it will distribute the sampling request to one of
`perf_callchain_user`, `perf_callchain_kernel`, or `perf_callchain_guest`.

The reason for separately implementing `perf_callchain_user` and
`perf_callchain_kernel` is that the kernel may utilize special unwinders
such as `ORC`. However, for the guest, we only support stackframe-based
unwinding, so the implementation is generic and only needs to be
separately implemented for 32-bit and 64-bit.

Signed-off-by: Tianyi Liu <i.pear@outlook.com>
---
 arch/x86/events/core.c     | 56 +++++++++++++++++++++++++++++++-------
 include/linux/perf_event.h |  3 +-
 kernel/bpf/stackmap.c      |  8 +++---
 kernel/events/callchain.c  | 27 +++++++++++++++++-
 kernel/events/core.c       |  7 ++++-
 5 files changed, 84 insertions(+), 17 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 185f902e5..ea4c86175 100644
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
 
@@ -2778,6 +2773,52 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
 	}
 }
 
+static inline void
+perf_callchain_guest32(struct perf_callchain_entry_ctx *entry)
+{
+	struct stack_frame_ia32 frame;
+	const struct stack_frame_ia32 *fp;
+
+	fp = (void *)perf_guest_get_frame_pointer();
+	while (fp && entry->nr < entry->max_stack) {
+		if (!perf_guest_read_virt(&fp->next_frame, &frame.next_frame,
+			sizeof(frame.next_frame)))
+			break;
+		if (!perf_guest_read_virt(&fp->return_address, &frame.return_address,
+			sizeof(frame.return_address)))
+			break;
+		perf_callchain_store(entry, frame.return_address);
+		fp = (void *)frame.next_frame;
+	}
+}
+
+void
+perf_callchain_guest(struct perf_callchain_entry_ctx *entry)
+{
+	struct stack_frame frame;
+	const struct stack_frame *fp;
+	unsigned int guest_state;
+
+	guest_state = perf_guest_state();
+	perf_callchain_store(entry, perf_guest_get_ip());
+
+	if (guest_state & PERF_GUEST_64BIT) {
+		fp = (void *)perf_guest_get_frame_pointer();
+		while (fp && entry->nr < entry->max_stack) {
+			if (!perf_guest_read_virt(&fp->next_frame, &frame.next_frame,
+				sizeof(frame.next_frame)))
+				break;
+			if (!perf_guest_read_virt(&fp->return_address, &frame.return_address,
+				sizeof(frame.return_address)))
+				break;
+			perf_callchain_store(entry, frame.return_address);
+			fp = (void *)frame.next_frame;
+		}
+	} else {
+		perf_callchain_guest32(entry);
+	}
+}
+
 static inline int
 valid_user_frame(const void __user *fp, unsigned long size)
 {
@@ -2861,11 +2902,6 @@ perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs
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
index d0f937a62..a2baf4856 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1545,9 +1545,10 @@ DECLARE_PER_CPU(struct perf_callchain_entry, perf_callchain_entry);
 
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
index 458bb80b1..2e88d4639 100644
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
index 1273be843..7e80729e9 100644
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
index eaba00ec2..b3401f403 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7559,6 +7559,8 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
 {
 	bool kernel = !event->attr.exclude_callchain_kernel;
 	bool user   = !event->attr.exclude_callchain_user;
+	bool host   = !event->attr.exclude_host;
+	bool guest  = !event->attr.exclude_guest;
 	/* Disallow cross-task user callchains. */
 	bool crosstask = event->ctx->task && event->ctx->task != current;
 	const u32 max_stack = event->attr.sample_max_stack;
@@ -7567,7 +7569,10 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
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
2.42.0

