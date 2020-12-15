Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6D22DAF86
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 15:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgLOO4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 09:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730062AbgLOOz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 09:55:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A3EC06179C;
        Tue, 15 Dec 2020 06:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=i7/Dmdf/9/KX5OWMc6gqbQ/znmDaWWCIUvdqdmOq2yg=; b=poBbcvBpz4LX1hoYM4wbTihWDX
        uOy0rPE2W9evHPNElzxZmHkhNfRbIlBLmxgHkpUY8gE0iDzhzDgUAouRD4qerv1VQ37nUxBOY/QS+
        iSEtiFHDyHBWEO/MHXmljfdRTMcm7xSieGyq2r/smem57sLPSUzdCkAII0fwBLX5d2KUgEFSbAI/X
        Oc1HurNdTe8wrQjE8tSrWRk815zD0WPgBYvHJRJ6PLlHQdZlcNcBDhHfCTaphqHwiaemBhk9VEqyt
        V5Jg2P6IdKLXSx2xJlOtzRE0tRdV074jsVCOx2Qr/NIRSOXmR5R7p1XsDdC3EE0yMxgE8V43+75Co
        ZNKvsQUQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kpBiO-00050k-Al; Tue, 15 Dec 2020 14:54:12 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DF3A93059DD;
        Tue, 15 Dec 2020 15:54:08 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C0B352C7DB779; Tue, 15 Dec 2020 15:54:08 +0100 (CET)
Date:   Tue, 15 Dec 2020 15:54:08 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
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
Message-ID: <20201215145408.GR3092@hirez.programming.kicks-ass.net>
References: <20201120114630.13552-1-jgross@suse.com>
 <20201120125342.GC3040@hirez.programming.kicks-ass.net>
 <20201123134317.GE3092@hirez.programming.kicks-ass.net>
 <6771a12c-051d-1655-fb3a-cc45a3c82e29@suse.com>
 <20201215141834.GG3040@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215141834.GG3040@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 15, 2020 at 03:18:34PM +0100, Peter Zijlstra wrote:
> Ah, I was waiting for Josh to have an opinion (and then sorta forgot
> about the whole thing again). Let me refresh and provide at least a
> Changelog.

How's this then?

---
Subject: objtool: Alternatives vs ORC, the hard way
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon, 23 Nov 2020 14:43:17 +0100

Alternatives pose an interesting problem for unwinders because from
the unwinders PoV we're just executing instructions, it has no idea
the text is modified, nor any way of retrieving what with.

Therefore the stance has been that alternatives must not change stack
state, as encoded by commit: 7117f16bf460 ("objtool: Fix ORC vs
alternatives"). This obviously guarantees that whatever actual
instructions end up in the text, the unwind information is correct.

However, there is one additional source of text patching that isn't
currently visible to objtool: paravirt immediate patching. And it
turns out one of these violates the rule.

As part of cleaning that up, the unfortunate reality is that objtool
now has to deal with alternatives modifying unwind state and validate
the combination is valid and generate ORC data to match.

The problem is that a single instance of unwind information (ORC) must
capture and correctly unwind all alternatives. Since the trivially
correct mandate is out, implement the straight forward brute-force
approach:

 1) generate CFI information for each alternative

 2) unwind every alternative with the merge-sort of the previously
    generated CFI information -- O(n^2)

 3) for any possible conflict: yell.

 4) Generate ORC with merge-sort

Specifically for 3 there are two possible classes of conflicts:

 - the merge-sort itself could find conflicting CFI for the same
   offset.

 - the unwind can fail with the merged CFI.

In specific, this allows us to deal with:

	Alt1			Alt2			Alt3

 0x00	CALL *pv_ops.save_fl	CALL xen_save_fl	PUSHF
 0x01							POP %RAX
 0x02							NOP
 ...
 0x05				NOP
 ...
 0x07   <insn>

The unwind information for offset-0x00 is identical for all 3
alternatives. Similarly offset-0x05 and higher also are identical (and
the same as 0x00). However offset-0x01 has deviating CFI, but that is
only relevant for Alt3, neither of the other alternative instruction
streams will ever hit that offset.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 tools/objtool/check.c   |  180 ++++++++++++++++++++++++++++++++++++++++++++----
 tools/objtool/check.h   |    5 +
 tools/objtool/orc_gen.c |  180 +++++++++++++++++++++++++++++++-----------------
 3 files changed, 290 insertions(+), 75 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1096,6 +1096,32 @@ static int handle_group_alt(struct objto
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
 
@@ -2237,18 +2263,12 @@ static int handle_insn_ops(struct instru
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
@@ -2460,19 +2480,137 @@ static int validate_return(struct symbol
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
@@ -2484,9 +2622,10 @@ static void fill_alternative_cfi(struct
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
 
@@ -2541,8 +2680,10 @@ static int validate_branch(struct objtoo
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
@@ -2697,6 +2838,17 @@ static int validate_branch(struct objtoo
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
--- a/tools/objtool/check.h
+++ b/tools/objtool/check.h
@@ -41,6 +41,7 @@ struct instruction {
 	struct instruction *first_jump_src;
 	struct reloc *jump_table;
 	struct list_head alts;
+	struct instruction *alt_end;
 	struct symbol *func;
 	struct list_head stack_ops;
 	struct cfi_state cfi;
@@ -55,6 +56,10 @@ static inline bool is_static_jump(struct
 	       insn->type == INSN_JUMP_UNCONDITIONAL;
 }
 
+struct instruction *
+find_alt_unwind(struct objtool_file *file,
+		struct instruction *alt_insn, unsigned long offset);
+
 struct instruction *find_insn(struct objtool_file *file,
 			      struct section *sec, unsigned long offset);
 
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
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
 
