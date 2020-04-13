Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 403361A6384
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 09:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgDMHWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 03:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:59442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727654AbgDMHWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 03:22:09 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45E4C008651;
        Mon, 13 Apr 2020 00:22:08 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id b7so3520487pju.0;
        Mon, 13 Apr 2020 00:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=unWCB+7tFDxvEbrE324xq/PWVQz1J3pJxb0QQI5akQE=;
        b=eKTR6opBGDmh0WFyXbesHgyM2YLRiQFBHC5uiZl88n0oTzSeL/Tw+NnUNWcgwwMV14
         qKkmx5brwvB6qb6lT84AzMa8YjqZO8gDWvwkYx17LXozZOZwUDRvs5yxrWL2p4Ig/s3u
         X50Y/qv8M0lU4uKxUALpT/12ToTX+eSaLTsgLbN1b9tH/QQvi0RDupAzExbDtqEhZX3n
         slW9tOMpwAZENfYGaOaU6jubumcyoWCclOA95qQU9NBXVvCMZ9AOoKgbLhNYfYfW518z
         RfbMLqTBmwnA6IFH4TSOhP9Nyd0OH0d67QITUHNXc2UrZCBwdv+PcS3/U2DsWN3XhRjG
         0/Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=unWCB+7tFDxvEbrE324xq/PWVQz1J3pJxb0QQI5akQE=;
        b=szivpjFuLABe+2RHDAT5CRln3/tI3IkjOiOimOX6D0UsQ7dBeN0DUFEaqtpxRnT7e9
         FYx6/fv2UyotfcswxfaNWJYkbxz/w93qXRlC95ztrfg7GI+bIUPTL3lotruj3mzIXqiw
         vt8LfjClqJvtHyx2GoJON5lgUgFfuu7TPq7UeMN56dwxvkX9Mph55G+NSmt7z8cLgMgO
         d3qwpZr7TuiqMAO+F/sKOkpoqkf/ZKHAiHACZ5qw9neNVT3liVbc9huJ7rIxYpo2EviS
         s/Rp/CNodiB04vDxbz5IihEg4EjEGvzy001ib1+kVW9XsyZeqU9B70rMxXXVY/o8Isr0
         jyUw==
X-Gm-Message-State: AGi0PuafbeZIWUZsv5zMsN3xfmFhdL39hrLABL79EAHCfBnA9sxN9Gtw
        rFnXiyTLhw0acjhGNGvXGyQ=
X-Google-Smtp-Source: APiQypKG3jjD0bEk/1UaizxYUdFYFTcbzT0+h4p2hEYYr1KO3YnMiBfTuV+NpLNifY8hBLinUgTaew==
X-Received: by 2002:a17:90a:4809:: with SMTP id a9mr20297730pjh.73.1586762528070;
        Mon, 13 Apr 2020 00:22:08 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id u8sm7241341pgl.19.2020.04.13.00.22.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2020 00:22:07 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH 01/15] mips: define pud_index() regardless of page table folding
Date:   Mon, 13 Apr 2020 15:30:10 +0800
Message-Id: <1586763024-12197-2-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
References: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

Commit 31168f033e37 ("mips: drop __pXd_offset() macros that duplicate
pXd_index() ones") is correct that pud_index() & __pud_offset() are the
same when pud_index() is actually provided, however it does not take into
account the __PAGETABLE_PUD_FOLDED case. This has broken MIPS KVM
compilation because it relied on availability of pud_index().

Define pud_index() regardless of page table folded. It will evaluate to
actual index for 4-level pagetables and to 0 for folded PUD level.

Link: https://lore.kernel.org/lkml/20200331154749.5457-1-pbonzini@redhat.com
Tested-by: Bibo Mao <maobibo@loongson.cn>
Tested-by: Huacai Chen <chenhc@lemote.com>
Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
[Huacai: Add Tested-by and take this patch into my series, because my
         series can't build an available kernel if without this patch.]
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 arch/mips/include/asm/pgtable-64.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/pgtable-64.h b/arch/mips/include/asm/pgtable-64.h
index f92716c..ee5dc0c 100644
--- a/arch/mips/include/asm/pgtable-64.h
+++ b/arch/mips/include/asm/pgtable-64.h
@@ -172,6 +172,8 @@
 
 extern pte_t invalid_pte_table[PTRS_PER_PTE];
 
+#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
+
 #ifndef __PAGETABLE_PUD_FOLDED
 /*
  * For 4-level pagetables we defines these ourselves, for 3-level the
@@ -210,8 +212,6 @@ static inline void p4d_clear(p4d_t *p4dp)
 	p4d_val(*p4dp) = (unsigned long)invalid_pud_table;
 }
 
-#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
-
 static inline unsigned long p4d_page_vaddr(p4d_t p4d)
 {
 	return p4d_val(p4d);
-- 
2.7.0

