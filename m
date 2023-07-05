Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DE6748B76
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 20:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbjGESSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 14:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbjGESRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 14:17:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D531731
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 11:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688581009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J8rXW514UBch39kVc1ygiPYqeRYBiljQKIWLWtG0jLw=;
        b=iUBwR4gU01hJGczrgZMoE6bIoLmoqbpg6gQtTHGuIbn9mVRAvzKdjBYhI60uoGZVACSnFX
        bFovQ4lk7gjoGkg+hMrdaP0+P+9lNuQAfLBqjF4+mYCQzIqWDwvpA3tC4+gjKzstxj10qK
        XFQ007/9WC61i/asA1O64tGDuI3BgLw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-9oeIA5OgNLqp_60MHHVNcQ-1; Wed, 05 Jul 2023 14:16:43 -0400
X-MC-Unique: 9oeIA5OgNLqp_60MHHVNcQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8779810BB4;
        Wed,  5 Jul 2023 18:16:41 +0000 (UTC)
Received: from vschneid.remote.csb (unknown [10.42.28.164])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A081B18EB4;
        Wed,  5 Jul 2023 18:16:36 +0000 (UTC)
From:   Valentin Schneider <vschneid@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        bpf@vger.kernel.org, x86@kernel.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
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
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Song Liu <song@kernel.org>,
        Julian Pidancet <julian.pidancet@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Juri Lelli <juri.lelli@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Yair Podemsky <ypodemsk@redhat.com>
Subject: [RFC PATCH 07/14] objtool: Warn about non __ro_after_init static key usage in .noinstr
Date:   Wed,  5 Jul 2023 19:12:49 +0100
Message-Id: <20230705181256.3539027-8-vschneid@redhat.com>
In-Reply-To: <20230705181256.3539027-1-vschneid@redhat.com>
References: <20230705181256.3539027-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Later commits will depend on having no runtime-mutable text in early entry
code. (ab)use the .noinstr section as a marker of early entry code and warn
about static keys used in it that can be flipped at runtime.

Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 tools/objtool/check.c                   | 20 ++++++++++++++++++++
 tools/objtool/include/objtool/check.h   |  1 +
 tools/objtool/include/objtool/special.h |  2 ++
 tools/objtool/special.c                 |  3 +++
 4 files changed, 26 insertions(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index fe62232f218f9..7f8d210ec88c3 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2032,6 +2032,9 @@ static int add_special_section_alts(struct objtool_file *file)
 		alt->next = orig_insn->alts;
 		orig_insn->alts = alt;
 
+		if (special_alt->key_sym)
+			orig_insn->key_sym = special_alt->key_sym;
+
 		list_del(&special_alt->list);
 		free(special_alt);
 	}
@@ -3520,6 +3523,20 @@ static int validate_return(struct symbol *func, struct instruction *insn, struct
 	return 0;
 }
 
+static int validate_static_key(struct instruction *insn, struct insn_state *state)
+{
+	if (state->noinstr && state->instr <= 0) {
+		if ((strcmp(insn->key_sym->sec->name, ".data..ro_after_init"))) {
+			WARN_INSN(insn,
+				  "Non __ro_after_init static key \"%s\" in .noinstr section",
+				  insn->key_sym->name);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 static struct instruction *next_insn_to_validate(struct objtool_file *file,
 						 struct instruction *insn)
 {
@@ -3670,6 +3687,9 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 		if (handle_insn_ops(insn, next_insn, &state))
 			return 1;
 
+		if (insn->key_sym)
+			validate_static_key(insn, &state);
+
 		switch (insn->type) {
 
 		case INSN_RETURN:
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index daa46f1f0965a..35dd21f8f41e1 100644
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -77,6 +77,7 @@ struct instruction {
 	struct symbol *sym;
 	struct stack_op *stack_ops;
 	struct cfi_state *cfi;
+	struct symbol *key_sym;
 };
 
 static inline struct symbol *insn_func(struct instruction *insn)
diff --git a/tools/objtool/include/objtool/special.h b/tools/objtool/include/objtool/special.h
index 86d4af9c5aa9d..0e61f34fe3a28 100644
--- a/tools/objtool/include/objtool/special.h
+++ b/tools/objtool/include/objtool/special.h
@@ -27,6 +27,8 @@ struct special_alt {
 	struct section *new_sec;
 	unsigned long new_off;
 
+	struct symbol *key_sym;
+
 	unsigned int orig_len, new_len; /* group only */
 };
 
diff --git a/tools/objtool/special.c b/tools/objtool/special.c
index baa85c31526b3..830e6abf173a2 100644
--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -127,6 +127,9 @@ static int get_alt_entry(struct elf *elf, const struct special_entry *entry,
 			return -1;
 		}
 		alt->key_addend = key_reloc->addend;
+
+		reloc_to_sec_off(key_reloc, &sec, &offset);
+		alt->key_sym = find_symbol_by_offset(sec, offset & ~2);
 	}
 
 	return 0;
-- 
2.31.1

