Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90266748B90
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 20:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbjGEST0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 14:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233383AbjGESSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 14:18:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8A31BFD
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 11:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688581041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O0XyYRqaKclSpF/kJo4Izh2sg6d7OQ7Oy14ALgDyLr0=;
        b=jE1QJBXJxYWRKXUM7JGPZzZaHZW35aDfenAFgmKF+/qwKucoKMZHOKiNAeHfgwhSXpanVZ
        cw/wCMtY+ATasc1AgdO0aD+0cHuU5YmN8IQW3pba74XTYfFL2tSD3bkpsxz330rxyH2Lwo
        BGmGVARbFVwV+vgR/TDKMix5EDYyhXg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-mFoTFqj8OM6TsS7Ok5gs8A-1; Wed, 05 Jul 2023 14:17:17 -0400
X-MC-Unique: mFoTFqj8OM6TsS7Ok5gs8A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44FAB185A792;
        Wed,  5 Jul 2023 18:17:15 +0000 (UTC)
Received: from vschneid.remote.csb (unknown [10.42.28.164])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C6AE518EB4;
        Wed,  5 Jul 2023 18:17:08 +0000 (UTC)
From:   Valentin Schneider <vschneid@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        bpf@vger.kernel.org, x86@kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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
Subject: [RFC PATCH 13/14] context_tracking,x86: Add infrastructure to defer kernel TLBI
Date:   Wed,  5 Jul 2023 19:12:55 +0100
Message-Id: <20230705181256.3539027-14-vschneid@redhat.com>
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

Kernel TLB invalidation IPIs are a common source of interference on
NOHZ_FULL CPUs. Given NOHZ_FULL CPUs executing in userspace are not
accessing any kernel addresses, these invalidations do not need to happen
immediately, and can be deferred until the next user->kernel transition.

Rather than make __flush_tlb_all() noinstr, add a minimal noinstr
variant that doesn't try to leverage INVPCID.

FIXME: not fully noinstr compliant
XXX: same issue as with ins patching, when do we access data that should be
invalidated?

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/include/asm/context_tracking_work.h |  4 ++++
 arch/x86/include/asm/tlbflush.h              |  1 +
 arch/x86/mm/tlb.c                            | 17 +++++++++++++++++
 include/linux/context_tracking_work.h        |  2 ++
 4 files changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/context_tracking_work.h b/arch/x86/include/asm/context_tracking_work.h
index 2c66687ce00e2..9d4f021b5a45b 100644
--- a/arch/x86/include/asm/context_tracking_work.h
+++ b/arch/x86/include/asm/context_tracking_work.h
@@ -3,6 +3,7 @@
 #define _ASM_X86_CONTEXT_TRACKING_WORK_H
 
 #include <asm/sync_core.h>
+#include <asm/tlbflush.h>
 
 static __always_inline void arch_context_tracking_work(int work)
 {
@@ -10,6 +11,9 @@ static __always_inline void arch_context_tracking_work(int work)
 	case CONTEXT_WORK_SYNC:
 		sync_core();
 		break;
+	case CONTEXT_WORK_TLBI:
+		__flush_tlb_all_noinstr();
+		break;
 	}
 }
 
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 75bfaa4210303..9064aa0027d05 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -15,6 +15,7 @@
 #include <asm/pgtable.h>
 
 void __flush_tlb_all(void);
+void noinstr __flush_tlb_all_noinstr(void);
 
 #define TLB_FLUSH_ALL	-1UL
 #define TLB_GENERATION_INVALID	0
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 267acf27480af..631df9189ded4 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -1237,6 +1237,23 @@ void __flush_tlb_all(void)
 }
 EXPORT_SYMBOL_GPL(__flush_tlb_all);
 
+void noinstr __flush_tlb_all_noinstr(void)
+{
+	/*
+	 * This is for invocation in early entry code that cannot be
+	 * instrumented. A RMW to CR4 works for most cases, but relies on
+	 * being able to flip either of the PGE or PCIDE bits. Flipping CR4.PCID
+	 * would require also resetting CR3.PCID, so just try with CR4.PGE, else
+	 * do the CR3 write.
+	 *
+	 * TODO: paravirt
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_PGE))
+		__native_tlb_flush_global(this_cpu_read(cpu_tlbstate.cr4));
+	else
+		flush_tlb_local();
+}
+
 void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 {
 	struct flush_tlb_info *info;
diff --git a/include/linux/context_tracking_work.h b/include/linux/context_tracking_work.h
index b0c7463048b60..c084a60d2fec5 100644
--- a/include/linux/context_tracking_work.h
+++ b/include/linux/context_tracking_work.h
@@ -7,12 +7,14 @@
 enum {
 	CONTEXT_WORK_DISABLED_OFFSET,
 	CONTEXT_WORK_SYNC_OFFSET,
+	CONTEXT_WORK_TLBI_OFFSET,
 	CONTEXT_WORK_MAX_OFFSET
 };
 
 enum ct_work {
 	CONTEXT_WORK_DISABLED = BIT(CONTEXT_WORK_DISABLED_OFFSET),
 	CONTEXT_WORK_SYNC     = BIT(CONTEXT_WORK_SYNC_OFFSET),
+	CONTEXT_WORK_TLBI     = BIT(CONTEXT_WORK_TLBI_OFFSET),
 	CONTEXT_WORK_MAX      = BIT(CONTEXT_WORK_MAX_OFFSET)
 };
 
-- 
2.31.1

