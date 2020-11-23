Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED102C0C18
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 14:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbgKWNo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 08:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729939AbgKWNo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Nov 2020 08:44:27 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66A8C0613CF;
        Mon, 23 Nov 2020 05:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RydA/us2lnbAjoJ7xmSIIjKk6qIoneLQLLcDUjJYnxM=; b=U9RjAS+s/uGM6Pd4fbRXzPe1KM
        4cjU70YB/r0s6veegEZX2/ID9UVs2g2w7Wrmga4Av7HoJvyzB8HCjxBt0lh6n1TqwfJ4H8BPNl89O
        KIhaST/RMq5ls4KSapEf/Q6y1MdBZKQM+ClOUtBpZEeAcAx2GszgOUlSRnA9b4WaKmlsnyRCywUnh
        vXDHsNJ6jumKfmyLNMg/Aeo8j8lSlrdZ0BpCfqzMFFUESs/Ck5qBZ6Po2Vxy3P3PKNtMfg9nJ2J5z
        CnS28YMDzG9RwB2Zw8XvsCQJKU3GVz9fc12LIsoBs7G9XkQj9WAL8reynr3QvIcEFav40d0mVYp/L
        oe9fweFQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khC7m-0008NA-Cg; Mon, 23 Nov 2020 13:43:22 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A2CC6307958;
        Mon, 23 Nov 2020 14:43:17 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 87D77200C8D27; Mon, 23 Nov 2020 14:43:17 +0100 (CET)
Date:   Mon, 23 Nov 2020 14:43:17 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org, luto@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Deep Shah <sdeep@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 00/12] x86: major paravirt cleanup
Message-ID: <20201123134317.GE3092@hirez.programming.kicks-ass.net>
References: <20201120114630.13552-1-jgross@suse.com>
 <20201120125342.GC3040@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120125342.GC3040@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 20, 2020 at 01:53:42PM +0100, Peter Zijlstra wrote:
> On Fri, Nov 20, 2020 at 12:46:18PM +0100, Juergen Gross wrote:
> >  30 files changed, 325 insertions(+), 598 deletions(-)
> 
> Much awesome ! I'll try and get that objtool thing sorted.

This seems to work for me. It isn't 100% accurate, because it doesn't
know about the direct call instruction, but I can either fudge that or
switching to static_call() will cure that.

It's not exactly pretty, but it should be straight forward.

Index: linux-2.6/tools/objtool/check.c
===================================================================
--- linux-2.6.orig/tools/objtool/check.c
+++ linux-2.6/tools/objtool/check.c
@@ -1090,6 +1090,32 @@ static int handle_group_alt(struct objto
 		return -1;
 	}
 
+	/*
+	 * Add the filler NOP, required for alternative CFI.
+	 */
+	if (special_alt->group && special_alt->new_len < special_alt->orig_len) {
+		struct instruction *nop = malloc(sizeof(*nop));
+		if (!nop) {
+			WARN("malloc failed");
+			return -1;
+		}
+		memset(nop, 0, sizeof(*nop));
+		INIT_LIST_HEAD(&nop->alts);
+		INIT_LIST_HEAD(&nop->stack_ops);
+		init_cfi_state(&nop->cfi);
+
+		nop->sec = last_new_insn->sec;
+		nop->ignore = last_new_insn->ignore;
+		nop->func = last_new_insn->func;
+		nop->alt_group = alt_group;
+		nop->offset = last_new_insn->offset + last_new_insn->len;
+		nop->type = INSN_NOP;
+		nop->len = special_alt->orig_len - special_alt->new_len;
+
+		list_add(&nop->list, &last_new_insn->list);
+		last_new_insn = nop;
+	}
+
 	if (fake_jump)
 		list_add(&fake_jump->list, &last_new_insn->list);
 
@@ -2190,18 +2216,12 @@ static int handle_insn_ops(struct instru
 	struct stack_op *op;
 
 	list_for_each_entry(op, &insn->stack_ops, list) {
-		struct cfi_state old_cfi = state->cfi;
 		int res;
 
 		res = update_cfi_state(insn, &state->cfi, op);
 		if (res)
 			return res;
 
-		if (insn->alt_group && memcmp(&state->cfi, &old_cfi, sizeof(struct cfi_state))) {
-			WARN_FUNC("alternative modifies stack", insn->sec, insn->offset);
-			return -1;
-		}
-
 		if (op->dest.type == OP_DEST_PUSHF) {
 			if (!state->uaccess_stack) {
 				state->uaccess_stack = 1;
@@ -2399,19 +2419,137 @@ static int validate_return(struct symbol
  * unreported (because they're NOPs), such holes would result in CFI_UNDEFINED
  * states which then results in ORC entries, which we just said we didn't want.
  *
- * Avoid them by copying the CFI entry of the first instruction into the whole
- * alternative.
+ * Avoid them by copying the CFI entry of the first instruction into the hole.
  */
-static void fill_alternative_cfi(struct objtool_file *file, struct instruction *insn)
+static void __fill_alt_cfi(struct objtool_file *file, struct instruction *insn)
 {
 	struct instruction *first_insn = insn;
 	int alt_group = insn->alt_group;
 
-	sec_for_each_insn_continue(file, insn) {
+	sec_for_each_insn_from(file, insn) {
 		if (insn->alt_group != alt_group)
 			break;
-		insn->cfi = first_insn->cfi;
+
+		if (!insn->visited)
+			insn->cfi = first_insn->cfi;
+	}
+}
+
+static void fill_alt_cfi(struct objtool_file *file, struct instruction *alt_insn)
+{
+	struct alternative *alt;
+
+	__fill_alt_cfi(file, alt_insn);
+
+	list_for_each_entry(alt, &alt_insn->alts, list)
+		__fill_alt_cfi(file, alt->insn);
+}
+
+static struct instruction *
+__find_unwind(struct objtool_file *file,
+	      struct instruction *insn, unsigned long offset)
+{
+	int alt_group = insn->alt_group;
+	struct instruction *next;
+	unsigned long off = 0;
+
+	while ((off + insn->len) <= offset) {
+		next = next_insn_same_sec(file, insn);
+		if (next && next->alt_group != alt_group)
+			next = NULL;
+
+		if (!next)
+			break;
+
+		off += insn->len;
+		insn = next;
 	}
+
+	return insn;
+}
+
+struct instruction *
+find_alt_unwind(struct objtool_file *file,
+		struct instruction *alt_insn, unsigned long offset)
+{
+	struct instruction *fit;
+	struct alternative *alt;
+	unsigned long fit_off;
+
+	fit = __find_unwind(file, alt_insn, offset);
+	fit_off = (fit->offset - alt_insn->offset);
+
+	list_for_each_entry(alt, &alt_insn->alts, list) {
+		struct instruction *x;
+		unsigned long x_off;
+
+		x = __find_unwind(file, alt->insn, offset);
+		x_off = (x->offset - alt->insn->offset);
+
+		if (fit_off < x_off) {
+			fit = x;
+			fit_off = x_off;
+
+		} else if (fit_off == x_off &&
+			   memcmp(&fit->cfi, &x->cfi, sizeof(struct cfi_state))) {
+
+			char *_str1 = offstr(fit->sec, fit->offset);
+			char *_str2 = offstr(x->sec, x->offset);
+			WARN("%s: equal-offset incompatible alternative: %s\n", _str1, _str2);
+			free(_str1);
+			free(_str2);
+			return fit;
+		}
+	}
+
+	return fit;
+}
+
+static int __validate_unwind(struct objtool_file *file,
+			     struct instruction *alt_insn,
+			     struct instruction *insn)
+{
+	int alt_group = insn->alt_group;
+	struct instruction *unwind;
+	unsigned long offset = 0;
+
+	sec_for_each_insn_from(file, insn) {
+		if (insn->alt_group != alt_group)
+			break;
+
+		unwind = find_alt_unwind(file, alt_insn, offset);
+
+		if (memcmp(&insn->cfi, &unwind->cfi, sizeof(struct cfi_state))) {
+
+			char *_str1 = offstr(insn->sec, insn->offset);
+			char *_str2 = offstr(unwind->sec, unwind->offset);
+			WARN("%s: unwind incompatible alternative: %s (%ld)\n",
+			     _str1, _str2, offset);
+			free(_str1);
+			free(_str2);
+			return 1;
+		}
+
+		offset += insn->len;
+	}
+
+	return 0;
+}
+
+static int validate_alt_unwind(struct objtool_file *file,
+			       struct instruction *alt_insn)
+{
+	struct alternative *alt;
+
+	if (__validate_unwind(file, alt_insn, alt_insn))
+		return 1;
+
+	list_for_each_entry(alt, &alt_insn->alts, list) {
+		if (__validate_unwind(file, alt_insn, alt->insn))
+			return 1;
+	}
+
+	return 0;
 }
 
 /*
@@ -2423,9 +2561,10 @@ static void fill_alternative_cfi(struct
 static int validate_branch(struct objtool_file *file, struct symbol *func,
 			   struct instruction *insn, struct insn_state state)
 {
+	struct instruction *next_insn, *alt_insn = NULL;
 	struct alternative *alt;
-	struct instruction *next_insn;
 	struct section *sec;
+	int alt_group = 0;
 	u8 visited;
 	int ret;
 
@@ -2480,8 +2619,10 @@ static int validate_branch(struct objtoo
 				}
 			}
 
-			if (insn->alt_group)
-				fill_alternative_cfi(file, insn);
+			if (insn->alt_group) {
+				alt_insn = insn;
+				alt_group = insn->alt_group;
+			}
 
 			if (skip_orig)
 				return 0;
@@ -2613,6 +2754,17 @@ static int validate_branch(struct objtoo
 		}
 
 		insn = next_insn;
+
+		if (alt_insn && insn->alt_group != alt_group) {
+			alt_insn->alt_end = insn;
+
+			fill_alt_cfi(file, alt_insn);
+
+			if (validate_alt_unwind(file, alt_insn))
+				return 1;
+
+			alt_insn = NULL;
+		}
 	}
 
 	return 0;
Index: linux-2.6/tools/objtool/check.h
===================================================================
--- linux-2.6.orig/tools/objtool/check.h
+++ linux-2.6/tools/objtool/check.h
@@ -40,6 +40,7 @@ struct instruction {
 	struct instruction *first_jump_src;
 	struct reloc *jump_table;
 	struct list_head alts;
+	struct instruction *alt_end;
 	struct symbol *func;
 	struct list_head stack_ops;
 	struct cfi_state cfi;
@@ -54,6 +55,10 @@ static inline bool is_static_jump(struct
 	       insn->type == INSN_JUMP_UNCONDITIONAL;
 }
 
+struct instruction *
+find_alt_unwind(struct objtool_file *file,
+		struct instruction *alt_insn, unsigned long offset);
+
 struct instruction *find_insn(struct objtool_file *file,
 			      struct section *sec, unsigned long offset);
 
Index: linux-2.6/tools/objtool/orc_gen.c
===================================================================
--- linux-2.6.orig/tools/objtool/orc_gen.c
+++ linux-2.6/tools/objtool/orc_gen.c
@@ -12,75 +12,86 @@
 #include "check.h"
 #include "warn.h"
 
-int create_orc(struct objtool_file *file)
+static int create_orc_insn(struct objtool_file *file, struct instruction *insn)
 {
-	struct instruction *insn;
+	struct orc_entry *orc = &insn->orc;
+	struct cfi_reg *cfa = &insn->cfi.cfa;
+	struct cfi_reg *bp = &insn->cfi.regs[CFI_BP];
+
+	orc->end = insn->cfi.end;
+
+	if (cfa->base == CFI_UNDEFINED) {
+		orc->sp_reg = ORC_REG_UNDEFINED;
+		return 0;
+	}
 
-	for_each_insn(file, insn) {
-		struct orc_entry *orc = &insn->orc;
-		struct cfi_reg *cfa = &insn->cfi.cfa;
-		struct cfi_reg *bp = &insn->cfi.regs[CFI_BP];
+	switch (cfa->base) {
+	case CFI_SP:
+		orc->sp_reg = ORC_REG_SP;
+		break;
+	case CFI_SP_INDIRECT:
+		orc->sp_reg = ORC_REG_SP_INDIRECT;
+		break;
+	case CFI_BP:
+		orc->sp_reg = ORC_REG_BP;
+		break;
+	case CFI_BP_INDIRECT:
+		orc->sp_reg = ORC_REG_BP_INDIRECT;
+		break;
+	case CFI_R10:
+		orc->sp_reg = ORC_REG_R10;
+		break;
+	case CFI_R13:
+		orc->sp_reg = ORC_REG_R13;
+		break;
+	case CFI_DI:
+		orc->sp_reg = ORC_REG_DI;
+		break;
+	case CFI_DX:
+		orc->sp_reg = ORC_REG_DX;
+		break;
+	default:
+		WARN_FUNC("unknown CFA base reg %d",
+			  insn->sec, insn->offset, cfa->base);
+		return -1;
+	}
 
-		if (!insn->sec->text)
-			continue;
+	switch(bp->base) {
+	case CFI_UNDEFINED:
+		orc->bp_reg = ORC_REG_UNDEFINED;
+		break;
+	case CFI_CFA:
+		orc->bp_reg = ORC_REG_PREV_SP;
+		break;
+	case CFI_BP:
+		orc->bp_reg = ORC_REG_BP;
+		break;
+	default:
+		WARN_FUNC("unknown BP base reg %d",
+			  insn->sec, insn->offset, bp->base);
+		return -1;
+	}
 
-		orc->end = insn->cfi.end;
+	orc->sp_offset = cfa->offset;
+	orc->bp_offset = bp->offset;
+	orc->type = insn->cfi.type;
 
-		if (cfa->base == CFI_UNDEFINED) {
-			orc->sp_reg = ORC_REG_UNDEFINED;
-			continue;
-		}
+	return 0;
+}
 
-		switch (cfa->base) {
-		case CFI_SP:
-			orc->sp_reg = ORC_REG_SP;
-			break;
-		case CFI_SP_INDIRECT:
-			orc->sp_reg = ORC_REG_SP_INDIRECT;
-			break;
-		case CFI_BP:
-			orc->sp_reg = ORC_REG_BP;
-			break;
-		case CFI_BP_INDIRECT:
-			orc->sp_reg = ORC_REG_BP_INDIRECT;
-			break;
-		case CFI_R10:
-			orc->sp_reg = ORC_REG_R10;
-			break;
-		case CFI_R13:
-			orc->sp_reg = ORC_REG_R13;
-			break;
-		case CFI_DI:
-			orc->sp_reg = ORC_REG_DI;
-			break;
-		case CFI_DX:
-			orc->sp_reg = ORC_REG_DX;
-			break;
-		default:
-			WARN_FUNC("unknown CFA base reg %d",
-				  insn->sec, insn->offset, cfa->base);
-			return -1;
-		}
+int create_orc(struct objtool_file *file)
+{
+	struct instruction *insn;
 
-		switch(bp->base) {
-		case CFI_UNDEFINED:
-			orc->bp_reg = ORC_REG_UNDEFINED;
-			break;
-		case CFI_CFA:
-			orc->bp_reg = ORC_REG_PREV_SP;
-			break;
-		case CFI_BP:
-			orc->bp_reg = ORC_REG_BP;
-			break;
-		default:
-			WARN_FUNC("unknown BP base reg %d",
-				  insn->sec, insn->offset, bp->base);
-			return -1;
-		}
+	for_each_insn(file, insn) {
+		int ret;
+	       
+		if (!insn->sec->text)
+			continue;
 
-		orc->sp_offset = cfa->offset;
-		orc->bp_offset = bp->offset;
-		orc->type = insn->cfi.type;
+		ret = create_orc_insn(file, insn);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
@@ -166,6 +177,28 @@ int create_orc_sections(struct objtool_f
 
 		prev_insn = NULL;
 		sec_for_each_insn(file, sec, insn) {
+
+			if (insn->alt_end) {
+				unsigned int offset, alt_len;
+				struct instruction *unwind;
+
+				alt_len = insn->alt_end->offset - insn->offset;
+				for (offset = 0; offset < alt_len; offset++) {
+					unwind = find_alt_unwind(file, insn, offset);
+					/* XXX: skipped earlier ! */
+					create_orc_insn(file, unwind);
+					if (!prev_insn ||
+					    memcmp(&unwind->orc, &prev_insn->orc,
+						   sizeof(struct orc_entry))) {
+						idx++;
+//						WARN_FUNC("ORC @ %d/%d", sec, insn->offset+offset, offset, alt_len);
+					}
+					prev_insn = unwind;
+				}
+
+				insn = insn->alt_end;
+			}
+
 			if (!prev_insn ||
 			    memcmp(&insn->orc, &prev_insn->orc,
 				   sizeof(struct orc_entry))) {
@@ -203,6 +236,31 @@ int create_orc_sections(struct objtool_f
 
 		prev_insn = NULL;
 		sec_for_each_insn(file, sec, insn) {
+
+			if (insn->alt_end) {
+				unsigned int offset, alt_len;
+				struct instruction *unwind;
+
+				alt_len = insn->alt_end->offset - insn->offset;
+				for (offset = 0; offset < alt_len; offset++) {
+					unwind = find_alt_unwind(file, insn, offset);
+					if (!prev_insn ||
+					    memcmp(&unwind->orc, &prev_insn->orc,
+						   sizeof(struct orc_entry))) {
+
+						if (create_orc_entry(file->elf, u_sec, ip_relocsec, idx,
+								     insn->sec, insn->offset + offset,
+								     &unwind->orc))
+							return -1;
+
+						idx++;
+					}
+					prev_insn = unwind;
+				}
+
+				insn = insn->alt_end;
+			}
+
 			if (!prev_insn || memcmp(&insn->orc, &prev_insn->orc,
 						 sizeof(struct orc_entry))) {
 
