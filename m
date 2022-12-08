Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03A1647661
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiLHTja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiLHTj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:39:28 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C40485D35
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:39:19 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id b4-20020a253404000000b006fad1bb09f4so2547556yba.1
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yTAZyHH91Hz9k7OZtf9gLdlJIIrZMhdblzaFwMket5k=;
        b=GOQt4+sFqigGxf6Aa3fTvktBe1mjQiluGE/Jj6vv/IvtdV7LliPzUDKCSdDx4Qr+HY
         SefezSHoN8FcvlmM5v70XQPk/EyYEeJUQTBJUq5h/NPog1UINNQReWUqbVEFjNE5psNx
         aagqyJsONr1NaCPx7WLFrSAq/6+YU9H0nX9KZhJN95FCQM9/NOhRMdNzFnOuadNLctYN
         G+xWcIxFKNvCVcBGdVMIWulIdzku3X8ojhuncsVZJ/7ZuOiqyWG7OUDtS4/fr9vosjH0
         V6V8OE7BSYaG+WEMOpz2hhgLOVkbabsraMBHq3XN+o9hqQFkHr8FyeB1wUdGuE+kwW+d
         bbVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yTAZyHH91Hz9k7OZtf9gLdlJIIrZMhdblzaFwMket5k=;
        b=updWOekDusI1p4rhI/xsLugSXR71jg5IVIczGYkAGxaiSXj7ufhoCoT2b7kmeA2OkV
         hNRzyiRHvfWCCYFPrGanAKjm7TakC1MRHPNiSM5Vyy5CtRVznL30yr4hyT4dtdb/kzIf
         UzSoQr30nTPGfI9xraYXxX6O2r21wr3DOAYWnyOr/FHS6DGyvzMxS+Fi0zQS4FH6OSdv
         mBdxSzX7JO46CVXGPktj+2t7ptOXXME/r61RHRBqaCsUhzt8oVeSAt0wSwL4ZeBLUTQ2
         8bwbSWBdlKLVFVSNjlUQ9y7ryo9YOZpaZ5v/b3CjvXiHFMWz2ynWNNh6kRLOW2By6L7i
         TNQQ==
X-Gm-Message-State: ANoB5pmWaZoS16S7tUiwUZIcVw/CbIoR3QwFJm2pSqLy06I7ayEwAHhW
        5h3EOys6sxrDO2s1pOzWHHa5meKXJe+WWQ==
X-Google-Smtp-Source: AA0mqf4+9oetgR3uKpdfVrPGzq2N3r/JU0sb91m8xpA2HrSBGD0IqxC3Vg4zr/dJJfrFDGejU78ci1LRJL+iRw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:9f85:0:b0:700:f93d:c7cd with SMTP id
 u5-20020a259f85000000b00700f93dc7cdmr16638924ybq.166.1670528358851; Thu, 08
 Dec 2022 11:39:18 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:27 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-8-dmatlack@google.com>
Subject: [RFC PATCH 07/37] mm: Introduce architecture-neutral PG_LEVEL macros
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce architecture-neutral versions of the x86 macros PG_LEVEL_4K,
PG_LEVEL_2M, etc. The x86 macros are used extensively by KVM/x86's page
table management code. Introducing architecture-neutral version of these
macros paves the way for porting KVM/x86's page table management code to
architecture-neutral code.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/pgtable_types.h | 12 ++++--------
 include/linux/mm_types.h             |  9 +++++++++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index aa174fed3a71..bdf41325f089 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -518,14 +518,10 @@ extern void native_pagetable_init(void);
 struct seq_file;
 extern void arch_report_meminfo(struct seq_file *m);
 
-enum pg_level {
-	PG_LEVEL_NONE,
-	PG_LEVEL_4K,
-	PG_LEVEL_2M,
-	PG_LEVEL_1G,
-	PG_LEVEL_512G,
-	PG_LEVEL_NUM
-};
+#define PG_LEVEL_4K	PG_LEVEL_PTE
+#define PG_LEVEL_2M	PG_LEVEL_PMD
+#define PG_LEVEL_1G	PG_LEVEL_PUD
+#define PG_LEVEL_512G	PG_LEVEL_P4D
 
 #ifdef CONFIG_PROC_FS
 extern void update_page_count(int level, unsigned long pages);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 500e536796ca..0445d0673afe 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1003,4 +1003,13 @@ enum fault_flag {
 
 typedef unsigned int __bitwise zap_flags_t;
 
+enum pg_level {
+	PG_LEVEL_NONE,
+	PG_LEVEL_PTE,
+	PG_LEVEL_PMD,
+	PG_LEVEL_PUD,
+	PG_LEVEL_P4D,
+	PG_LEVEL_NUM
+};
+
 #endif /* _LINUX_MM_TYPES_H */
-- 
2.39.0.rc1.256.g54fd8350bd-goog

