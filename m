Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD7B748F1E
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 22:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbjGEUn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 16:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbjGEUn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 16:43:27 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C363A19B;
        Wed,  5 Jul 2023 13:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2uvD9mYwUyQ82PXrNwiJR0+WRJM0PQCF8y2F5N/cONE=; b=djk8cOqXqggfU6Ml1I4iR48Y7x
        K1cf8UXkaxjEDlwcadptEwEIaddtNIkZ0QgDE05z3bHQsFK/T5BZk/A8EptDgFhNmtZxPrwNXlvJV
        XqR9O+Eu8jaR3tznarXclGqLXhttQm8PKIkMB2RlU+j6j7xs3SRhCNvr1dqBVjy/o/qjV7pqiuzx2
        dq1/AwZbWVkovVvjc8c9ypAE/fOd7iZIGqbxgefCqqqOg7/4r8r9OHqD5LuscwVdfRwKLVQhf60Zi
        Es6WF26h4jXaLqFM+2HbZbyO0rrMU+w7jsQZkzWgNUV3/3f7udrqYKcc3yQc5ERx5e65xwVlGsfrz
        w+G8Gp6w==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qH9Jr-00CFZa-24;
        Wed, 05 Jul 2023 20:41:50 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 32F36300023;
        Wed,  5 Jul 2023 22:41:43 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0F151200E5E98; Wed,  5 Jul 2023 22:41:43 +0200 (CEST)
Date:   Wed, 5 Jul 2023 22:41:42 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        bpf@vger.kernel.org, x86@kernel.org,
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
        Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
        Juri Lelli <juri.lelli@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Yair Podemsky <ypodemsk@redhat.com>
Subject: Re: [RFC PATCH 08/14] BROKEN: context_tracking: Make
 context_tracking_key __ro_after_init
Message-ID: <20230705204142.GB2813335@hirez.programming.kicks-ass.net>
References: <20230705181256.3539027-1-vschneid@redhat.com>
 <20230705181256.3539027-9-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230705181256.3539027-9-vschneid@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 05, 2023 at 07:12:50PM +0100, Valentin Schneider wrote:

> BROKEN: the struct static_key lives in a read-only mapping after
> mark_rodata_ro(), which falls apart when the KVM module is loaded after
> init and a write to the struct happens due to e.g. guest_state_exit_irqoff()
> relying on the static key:

Right.. so whoever added the whole ro_after_init jump_label support did
a very poor job of it.

That said; I think it is fixable. Since the key cannot be changed, we
don't actually need to track the entries list and can thus avoid the key
update.

Something like the completely untested below...

---
Subject: jump_label: Seal __ro_after_init keys

When a static_key is marked ro_after_init, its state will never change
(after init), therefore jump_label_update() will never need to iterate
the entries, and thus module load won't actually need to track this --
avoiding the static_key::next write.

Therefore, mark these keys such that jump_label_add_module() might
recognise them and avoid the modification.

Use the special state: 'static_key_linked(key) && !static_key_mod(key)'
to denote such keys.

*UNTESTED*

NOT-Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/asm-generic/sections.h |  5 +++++
 include/linux/jump_label.h     |  1 +
 init/main.c                    |  1 +
 kernel/jump_label.c            | 44 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 51 insertions(+)

diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index db13bb620f52..c768de6f19a9 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -180,6 +180,11 @@ static inline bool is_kernel_rodata(unsigned long addr)
 	       addr < (unsigned long)__end_rodata;
 }
 
+static inline bool is_kernel_ro_after_init(unsigned long addr)
+{
+	return addr >= (unsigned long)__start_ro_after_init &&
+	       addr < (unsigned long)__end_ro_after_init;
+}
 /**
  * is_kernel_inittext - checks if the pointer address is located in the
  *                      .init.text section
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index f0a949b7c973..88ef9e776af8 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -216,6 +216,7 @@ extern struct jump_entry __start___jump_table[];
 extern struct jump_entry __stop___jump_table[];
 
 extern void jump_label_init(void);
+extern void jump_label_ro(void);
 extern void jump_label_lock(void);
 extern void jump_label_unlock(void);
 extern void arch_jump_label_transform(struct jump_entry *entry,
diff --git a/init/main.c b/init/main.c
index ad920fac325c..cb5304ca18f4 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1403,6 +1403,7 @@ static void mark_readonly(void)
 		 * insecure pages which are W+X.
 		 */
 		rcu_barrier();
+		jump_label_ro();
 		mark_rodata_ro();
 		rodata_test();
 	} else
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index d9c822bbffb8..40fb72d79d7a 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -530,6 +530,46 @@ void __init jump_label_init(void)
 	cpus_read_unlock();
 }
 
+static inline bool static_key_sealed(struct static_key *key)
+{
+	return (key->type & JUMP_TYPE_LINKED) && !(key->type & ~JUMP_TYPE_MASK);
+}
+
+static inline void static_key_seal(struct static_key *key)
+{
+	unsigned long type = key->type & JUMP_TYPE_TRUE;
+	key->type = JUMP_TYPE_LINKED | type;
+}
+
+void jump_label_ro(void)
+{
+	struct jump_entry *iter_start = __start___jump_table;
+	struct jump_entry *iter_stop = __stop___jump_table;
+	struct static_key *key = NULL;
+	struct jump_entry *iter;
+
+	if (WARN_ON_ONCE(!static_key_initialized))
+		return;
+
+	cpus_read_lock();
+	jump_label_lock();
+
+	for (iter = iter_start; iter < iter_stop; iter++) {
+		struct static_key *iterk = jump_entry_key(iter);
+
+		if (!is_kernel_ro_after_init(iterk))
+			continue;
+
+		if (static_key_sealed(iterk))
+			continue;
+
+		static_key_seal(iterk);
+	}
+
+	jump_label_unlock();
+	cpus_read_unlock();
+}
+
 #ifdef CONFIG_MODULES
 
 enum jump_label_type jump_label_init_type(struct jump_entry *entry)
@@ -650,6 +690,9 @@ static int jump_label_add_module(struct module *mod)
 			static_key_set_entries(key, iter);
 			continue;
 		}
+		if (static_key_sealed(key))
+			goto do_poke;
+
 		jlm = kzalloc(sizeof(struct static_key_mod), GFP_KERNEL);
 		if (!jlm)
 			return -ENOMEM;
@@ -675,6 +718,7 @@ static int jump_label_add_module(struct module *mod)
 		static_key_set_linked(key);
 
 		/* Only update if we've changed from our initial state */
+do_poke:
 		if (jump_label_type(iter) != jump_label_init_type(iter))
 			__jump_label_update(key, iter, iter_stop, true);
 	}
