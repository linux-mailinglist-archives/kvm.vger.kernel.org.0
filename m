Return-Path: <kvm+bounces-53126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 56B8CB0DB41
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 15:47:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 657841C810C5
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 13:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 431502EA475;
	Tue, 22 Jul 2025 13:47:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B947433A8;
	Tue, 22 Jul 2025 13:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192031; cv=none; b=o12KucFNR1DKQqBJcDDmCYhq3xMu1LuhmwjUQfr9vhGZP+UEcxQZFjTCv8a14aqit+tDd76o3PINtTvitpmaemgye3pBmegEVqfqy6IcOBzCyqlRJaPIolVpU6i+jJFFWONPjERfOWm/lLcfTndpzetsZ+tew9CuirPYo+lzdng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192031; c=relaxed/simple;
	bh=/38O0a49Nl2fkTlWe1aq3jycEaW+CNYGPJk/1tyUWAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=BXhDYiKdgeAJd3wu/Xd2vJe6UTaDhAkvxSZ7MUGXKc/YRvqwXopJqzyq009WONxbq8gYz3mhxfbfCTiu+uuL+NzC+xXtI547UQH0QsD2ZheMiM+bvYCjmrbeTXO2cSIR8jAq/YyRgxZet4X5qKzpYDYIeoTxvkM0h4hmLSWae4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C75BE58B89;
	Tue, 22 Jul 2025 13:47:04 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id AC81C6000D;
	Tue, 22 Jul 2025 13:47:02 +0000 (UTC)
Date: Tue, 22 Jul 2025 09:47:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, Linux Trace Kernel
 <linux-trace-kernel@vger.kernel.org>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>
Subject: [PATCH] LoongArch: KVM: Move kvm_iocsr tracepoint out of generic
 code
Message-ID: <20250722094734.4920545b@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AC81C6000D
X-Stat-Signature: cw9yqkxp4a9wi4qx7s15fa4muzpkrsub
X-Rspamd-Server: rspamout02
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19Ftd3lTtUwfr1yCBrITaCewJ6P8z9IiT8=
X-HE-Tag: 1753192022-163098
X-HE-Meta: U2FsdGVkX18UudbkKX+QbAnANaDsrraKoCAGN0Lnp3uc5eXpMlEczEIXMfJqpNJEW6W28wkkInmqYbCTquD3lSySI/TdMScCFNpcDA6Prz87YKiQ2wapK0t4gTKUEsY4eXq7OqUf66t3r/d6GKFWmCFsWfSEkbFvxjSx2+/j1XdHbBDkcVOfvIY+A9EkCMq29qqpvWkHg2OvB9Q5xTnx73vow8z20Vrd5kA+ecU75As4FHttw1oa80dkkcmhbbO9821uGtG8uueLbV37GNFHXJhFNmItj0SV/DIsAcrNFSZ/z17VShqfeVFrDD2u1LXurkJdTz9/Z3YjEBXCiBdU8oZF425hvig5nsQpHE8KRbqaG8bum/OGBADwgxPFnDsb

From: Steven Rostedt <rostedt@goodmis.org>

The tracepoint kvm_iocsr is only used by the loongarch architecture. As
trace events can take up to 5K of memory, move this tracepoint into the
loongarch specific tracing file so that it doesn't waste memory for all
other architectures.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 arch/loongarch/kvm/trace.h | 35 +++++++++++++++++++++++++++++++++++
 include/trace/events/kvm.h | 35 -----------------------------------
 2 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/arch/loongarch/kvm/trace.h b/arch/loongarch/kvm/trace.h
index 145514dab6d5..d73dea8afb74 100644
--- a/arch/loongarch/kvm/trace.h
+++ b/arch/loongarch/kvm/trace.h
@@ -115,6 +115,41 @@ TRACE_EVENT(kvm_exit_gspr,
 			__entry->inst_word)
 );
 
+#define KVM_TRACE_IOCSR_READ_UNSATISFIED 0
+#define KVM_TRACE_IOCSR_READ 1
+#define KVM_TRACE_IOCSR_WRITE 2
+
+#define kvm_trace_symbol_iocsr \
+	{ KVM_TRACE_IOCSR_READ_UNSATISFIED, "unsatisfied-read" }, \
+	{ KVM_TRACE_IOCSR_READ, "read" }, \
+	{ KVM_TRACE_IOCSR_WRITE, "write" }
+
+TRACE_EVENT(kvm_iocsr,
+	TP_PROTO(int type, int len, u64 gpa, void *val),
+	TP_ARGS(type, len, gpa, val),
+
+	TP_STRUCT__entry(
+		__field(	u32,	type	)
+		__field(	u32,	len	)
+		__field(	u64,	gpa	)
+		__field(	u64,	val	)
+	),
+
+	TP_fast_assign(
+		__entry->type		= type;
+		__entry->len		= len;
+		__entry->gpa		= gpa;
+		__entry->val		= 0;
+		if (val)
+			memcpy(&__entry->val, val,
+			       min_t(u32, sizeof(__entry->val), len));
+	),
+
+	TP_printk("iocsr %s len %u gpa 0x%llx val 0x%llx",
+		  __print_symbolic(__entry->type, kvm_trace_symbol_iocsr),
+		  __entry->len, __entry->gpa, __entry->val)
+);
+
 #define KVM_TRACE_AUX_SAVE		0
 #define KVM_TRACE_AUX_RESTORE		1
 #define KVM_TRACE_AUX_ENABLE		2
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 8b7252b8d751..b282e3a86769 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -156,41 +156,6 @@ TRACE_EVENT(kvm_mmio,
 		  __entry->len, __entry->gpa, __entry->val)
 );
 
-#define KVM_TRACE_IOCSR_READ_UNSATISFIED 0
-#define KVM_TRACE_IOCSR_READ 1
-#define KVM_TRACE_IOCSR_WRITE 2
-
-#define kvm_trace_symbol_iocsr \
-	{ KVM_TRACE_IOCSR_READ_UNSATISFIED, "unsatisfied-read" }, \
-	{ KVM_TRACE_IOCSR_READ, "read" }, \
-	{ KVM_TRACE_IOCSR_WRITE, "write" }
-
-TRACE_EVENT(kvm_iocsr,
-	TP_PROTO(int type, int len, u64 gpa, void *val),
-	TP_ARGS(type, len, gpa, val),
-
-	TP_STRUCT__entry(
-		__field(	u32,	type	)
-		__field(	u32,	len	)
-		__field(	u64,	gpa	)
-		__field(	u64,	val	)
-	),
-
-	TP_fast_assign(
-		__entry->type		= type;
-		__entry->len		= len;
-		__entry->gpa		= gpa;
-		__entry->val		= 0;
-		if (val)
-			memcpy(&__entry->val, val,
-			       min_t(u32, sizeof(__entry->val), len));
-	),
-
-	TP_printk("iocsr %s len %u gpa 0x%llx val 0x%llx",
-		  __print_symbolic(__entry->type, kvm_trace_symbol_iocsr),
-		  __entry->len, __entry->gpa, __entry->val)
-);
-
 #define kvm_fpu_load_symbol	\
 	{0, "unload"},		\
 	{1, "load"}
-- 
2.47.2


