Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A839AC818
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2019 19:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403994AbfIGRZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Sep 2019 13:25:49 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:34089 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395132AbfIGRZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Sep 2019 13:25:49 -0400
Received: by mail-oi1-f194.google.com with SMTP id g128so7595751oib.1;
        Sat, 07 Sep 2019 10:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=kSopJtjN0Bct/j9/oVkg8pXbs8bfoPtfq3tp15cWbFA=;
        b=GP196UxhtesI4DpzLroLGitq6AT3yCg6JIv7eHeX5bE512Bt2rY5UX8Owl6UWaLuqS
         KBU4alhzy/RjfOR2TD2kzxNOol1Dd7elx6QeLBSjvXAWYZ6J72Ui7zxbgwBqcpRN3GUw
         HM+GqbVngxARkCzWLz6bcneox7MpCZMhaZa7BbElkS22E1/H9BVwFHjSHB7D8HdTnNB8
         s9D7U+SPL6HVQH4GdqLxg+X1sIFEo1PwYNdUecPhL42WU/f2CPZGoIfUWj2ABQ0FomHv
         p1CyrMS2490/kosLr9EtAAYUk6zgj+NGlrqlwd2lM4GhpruzQf8L1+BRJ/tGzqsdCmoi
         ndmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=kSopJtjN0Bct/j9/oVkg8pXbs8bfoPtfq3tp15cWbFA=;
        b=Nl27ysNru90fZ2hpaMtHlbX0S0pT6Iqa8OOzxZ3BMMxhQ+8NJu0HwEvAxxQmQaT7tL
         EFxOnvC7AAD5lw1RiXpPOCXs4HPsSVt08gab9hStD3aFr3b+e3QvDKTnv7kHlPSZulm+
         MbNcsOcafDx9vZylUZIHfcAJfc0g6oK2skISF53zBoXUEr/FrXTy/77SUVfNy0xEKUfL
         s2gj1eJBPqqF9G0meo2Xdxr/fiasKfAUJ5HlHn6AGUVrbB18kD38QqZNdpvg/9RBxvxf
         bVVInHZkGwaORXu3xkZj8u+EPydfhEE5oJInZyE8n5OjiBSXRbOdxksp/B62CV8wXYpf
         tZsw==
X-Gm-Message-State: APjAAAWekbYXtPRGL6Nz+Llc3nKWPxMQPau+WGTETVZA/KvLl1rLjEsQ
        1APuWpchm7wNUT5ECTekxUU=
X-Google-Smtp-Source: APXvYqx2weNfO8K71L99snv6nx65rVmU19IskIQeolfUre8SXryHDBsQbX2DReh7lqCg7Zl0p2XdAA==
X-Received: by 2002:aca:2105:: with SMTP id 5mr9598351oiz.84.1567877148171;
        Sat, 07 Sep 2019 10:25:48 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id x6sm4135651ote.69.2019.09.07.10.25.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 10:25:47 -0700 (PDT)
Subject: [PATCH v9 5/8] arm64: Move hugetlb related definitions out of
 pgtable.h to page-defs.h
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        alexander.h.duyck@linux.intel.com, kirill.shutemov@linux.intel.com
Date:   Sat, 07 Sep 2019 10:25:45 -0700
Message-ID: <20190907172545.10910.88045.stgit@localhost.localdomain>
In-Reply-To: <20190907172225.10910.34302.stgit@localhost.localdomain>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Move the static definition for things such as HUGETLB_PAGE_ORDER out of
asm/pgtable.h and place it in page-defs.h. By doing this the includes
become much easier to deal with as currently arm64 is the only architecture
that didn't include this definition in the asm/page.h file or a file
included by it.

It also makes logical sense as PAGE_SHIFT was already defined in
page-defs.h so now we also have HPAGE_SHIFT defined there as well.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 arch/arm64/include/asm/page-def.h |    9 +++++++++
 arch/arm64/include/asm/pgtable.h  |    9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/page-def.h b/arch/arm64/include/asm/page-def.h
index f99d48ecbeef..1c5b079e2482 100644
--- a/arch/arm64/include/asm/page-def.h
+++ b/arch/arm64/include/asm/page-def.h
@@ -20,4 +20,13 @@
 #define CONT_SIZE		(_AC(1, UL) << (CONT_SHIFT + PAGE_SHIFT))
 #define CONT_MASK		(~(CONT_SIZE-1))
 
+/*
+ * Hugetlb definitions.
+ */
+#define HUGE_MAX_HSTATE		4
+#define HPAGE_SHIFT		PMD_SHIFT
+#define HPAGE_SIZE		(_AC(1, UL) << HPAGE_SHIFT)
+#define HPAGE_MASK		(~(HPAGE_SIZE - 1))
+#define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
+
 #endif /* __ASM_PAGE_DEF_H */
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 7576df00eb50..06a376de9bd6 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -305,15 +305,6 @@ static inline int pte_same(pte_t pte_a, pte_t pte_b)
  */
 #define pte_mkhuge(pte)		(__pte(pte_val(pte) & ~PTE_TABLE_BIT))
 
-/*
- * Hugetlb definitions.
- */
-#define HUGE_MAX_HSTATE		4
-#define HPAGE_SHIFT		PMD_SHIFT
-#define HPAGE_SIZE		(_AC(1, UL) << HPAGE_SHIFT)
-#define HPAGE_MASK		(~(HPAGE_SIZE - 1))
-#define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
-
 static inline pte_t pgd_pte(pgd_t pgd)
 {
 	return __pte(pgd_val(pgd));

