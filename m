Return-Path: <kvm+bounces-32073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF159D29EA
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 16:43:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5103A282125
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 15:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68FBF1D1318;
	Tue, 19 Nov 2024 15:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HIvWDcbz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDD21D043A
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 15:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732030728; cv=none; b=VSs7QMaLNqzPmBPvJNghHEEXq/amBA4S5ihHAmxGK6L/UiMx2+NZf65MVv6da0sSZz+Kut22w6s7SkjQQy0MkYxGmIxeOPRICCte+atM99NXLXY3gVbTeATE2tobokDSMrzSKrlOqZP/dMJEfa6gWxGnRaacqL+YQxvs7rbN0o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732030728; c=relaxed/simple;
	bh=soZGZa5eZvVq13Yv3+buGnph0yEGo0cZoyN46yk11Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWHKuJEesylIWR5wrXeA5ao0d3Jhl+av9dd2YsrNqOHW6H8/Y6GF8k8BLfo1FDwNZFpRLkf23MGvSKymmHgbczv6HxMyFfCXXG+EQ52woIbCylDINQPI4VgySZjKq0W+3LgJFa7fiODas8fgZE7hRnLDSrZq37ktvc1hpP9ybuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HIvWDcbz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732030725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=URgg3URVd8Hv8WB8p504Oe6mTtzB0H+jxnfnYfZO9Vc=;
	b=HIvWDcbzhnEiJtma39ziZA7zU9vx6h4AMm0GyQJRoJXMUP82K8DaH0T2liVvoFoxUQ6Joj
	RlgwHh52NsaOrVvdIyNc/dgmzDHvH4efrEXARXf9uAb7cINgFY5YMKBjVuB9fbJZ6jmz9E
	buQHtSLU631hkpSWa+JdJ5XZ4jhg3Nc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-99-3C0haj_PPdCTmZEKdqoqww-1; Tue,
 19 Nov 2024 10:38:43 -0500
X-MC-Unique: 3C0haj_PPdCTmZEKdqoqww-1
X-Mimecast-MFC-AGG-ID: 3C0haj_PPdCTmZEKdqoqww
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC0AB193EF53;
	Tue, 19 Nov 2024 15:38:32 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.39.194.94])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 613EB30001A2;
	Tue, 19 Nov 2024 15:38:15 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	x86@kernel.org,
	rcu@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Kees Cook <keescook@chromium.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Juerg Haefliger <juerg.haefliger@canonical.com>,
	Nicolas Saenz Julienne <nsaenz@kernel.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Nadav Amit <namit@vmware.com>,
	Dan Carpenter <error27@gmail.com>,
	Chuang Wang <nashuiliang@gmail.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	Petr Mladek <pmladek@suse.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Song Liu <song@kernel.org>,
	Julian Pidancet <julian.pidancet@oracle.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Dionna Glaze <dionnaglaze@google.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>
Subject: [RFC PATCH v3 10/15] x86/alternatives: Record text_poke's of JUMP_TYPE_FORCEFUL labels
Date: Tue, 19 Nov 2024 16:34:57 +0100
Message-ID: <20241119153502.41361-11-vschneid@redhat.com>
In-Reply-To: <20241119153502.41361-1-vschneid@redhat.com>
References: <20241119153502.41361-1-vschneid@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Forceful static keys are used in early entry code where it is unsafe to
defer the sync_core() IPIs, and flagged as such via their ->type field.

Record that information when creating a text_poke_loc. The
text_poke_loc.old field is written to when first iterating a text_poke()
entry, and as such can be (ab)used to store this information at the start
of text_poke_bp_batch().

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/include/asm/text-patching.h | 12 ++++++++++--
 arch/x86/kernel/alternative.c        | 16 ++++++++++------
 arch/x86/kernel/jump_label.c         |  7 ++++---
 3 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index 6259f1937fe77..e34de36cab61e 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -38,9 +38,17 @@ extern void *text_poke_copy(void *addr, const void *opcode, size_t len);
 extern void *text_poke_copy_locked(void *addr, const void *opcode, size_t len, bool core_ok);
 extern void *text_poke_set(void *addr, int c, size_t len);
 extern int poke_int3_handler(struct pt_regs *regs);
-extern void text_poke_bp(void *addr, const void *opcode, size_t len, const void *emulate);
+extern void __text_poke_bp(void *addr, const void *opcode, size_t len, const void *emulate, bool force_ipi);
+static inline void text_poke_bp(void *addr, const void *opcode, size_t len, const void *emulate)
+{
+	__text_poke_bp(addr, opcode, len, emulate, false);
+}
 
-extern void text_poke_queue(void *addr, const void *opcode, size_t len, const void *emulate);
+extern void __text_poke_queue(void *addr, const void *opcode, size_t len, const void *emulate, bool force_ipi);
+static inline void text_poke_queue(void *addr, const void *opcode, size_t len, const void *emulate)
+{
+	__text_poke_queue(addr, opcode, len, emulate, false);
+}
 extern void text_poke_finish(void);
 
 #define INT3_INSN_SIZE		1
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index d17518ca19b8b..954c4c0f7fc58 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -2098,7 +2098,10 @@ struct text_poke_loc {
 	u8 opcode;
 	const u8 text[POKE_MAX_OPCODE_SIZE];
 	/* see text_poke_bp_batch() */
-	u8 old;
+	union {
+		u8 old;
+		u8 force_ipi;
+	};
 };
 
 struct bp_patching_desc {
@@ -2385,7 +2388,7 @@ static void text_poke_bp_batch(struct text_poke_loc *tp, unsigned int nr_entries
 }
 
 static void text_poke_loc_init(struct text_poke_loc *tp, void *addr,
-			       const void *opcode, size_t len, const void *emulate)
+			       const void *opcode, size_t len, const void *emulate, bool force_ipi)
 {
 	struct insn insn;
 	int ret, i = 0;
@@ -2402,6 +2405,7 @@ static void text_poke_loc_init(struct text_poke_loc *tp, void *addr,
 	tp->rel_addr = addr - (void *)_stext;
 	tp->len = len;
 	tp->opcode = insn.opcode.bytes[0];
+	tp->force_ipi = force_ipi;
 
 	if (is_jcc32(&insn)) {
 		/*
@@ -2493,14 +2497,14 @@ void text_poke_finish(void)
 	text_poke_flush(NULL);
 }
 
-void __ref text_poke_queue(void *addr, const void *opcode, size_t len, const void *emulate)
+void __ref __text_poke_queue(void *addr, const void *opcode, size_t len, const void *emulate, bool force_ipi)
 {
 	struct text_poke_loc *tp;
 
 	text_poke_flush(addr);
 
 	tp = &tp_vec[tp_vec_nr++];
-	text_poke_loc_init(tp, addr, opcode, len, emulate);
+	text_poke_loc_init(tp, addr, opcode, len, emulate, force_ipi);
 }
 
 /**
@@ -2514,10 +2518,10 @@ void __ref text_poke_queue(void *addr, const void *opcode, size_t len, const voi
  * dynamically allocated memory. This function should be used when it is
  * not possible to allocate memory.
  */
-void __ref text_poke_bp(void *addr, const void *opcode, size_t len, const void *emulate)
+void __ref __text_poke_bp(void *addr, const void *opcode, size_t len, const void *emulate, bool force_ipi)
 {
 	struct text_poke_loc tp;
 
-	text_poke_loc_init(&tp, addr, opcode, len, emulate);
+	text_poke_loc_init(&tp, addr, opcode, len, emulate, force_ipi);
 	text_poke_bp_batch(&tp, 1);
 }
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index f5b8ef02d172c..e03a4f56b30fd 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -101,8 +101,8 @@ __jump_label_transform(struct jump_entry *entry,
 		text_poke_early((void *)jump_entry_code(entry), jlp.code, jlp.size);
 		return;
 	}
-
-	text_poke_bp((void *)jump_entry_code(entry), jlp.code, jlp.size, NULL);
+	__text_poke_bp((void *)jump_entry_code(entry), jlp.code, jlp.size, NULL,
+		     jump_entry_key(entry)->type & JUMP_TYPE_FORCEFUL);
 }
 
 static void __ref jump_label_transform(struct jump_entry *entry,
@@ -135,7 +135,8 @@ bool arch_jump_label_transform_queue(struct jump_entry *entry,
 
 	mutex_lock(&text_mutex);
 	jlp = __jump_label_patch(entry, type);
-	text_poke_queue((void *)jump_entry_code(entry), jlp.code, jlp.size, NULL);
+	__text_poke_queue((void *)jump_entry_code(entry), jlp.code, jlp.size, NULL,
+			jump_entry_key(entry)->type & JUMP_TYPE_FORCEFUL);
 	mutex_unlock(&text_mutex);
 	return true;
 }
-- 
2.43.0


