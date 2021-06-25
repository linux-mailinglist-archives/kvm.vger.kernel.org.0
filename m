Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541DC3B46B3
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 17:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhFYPgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 11:36:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56717 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229630AbhFYPgj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 11:36:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624635258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P+irYxL4B6g9k/ospIqhO666waG3AOzkyA4aW0tTUSw=;
        b=GClHkAYfMmEioJE6BY4FC9ETTQ4cguM+mR1Sow9Cffa6ALLSIKPWkewxjdkQFIabyxZ3vQ
        QbHJpPwUY5edjsropCDLS6mqAj2Q0cDwthbiz0tu10b+uMKUCAdg9dfKRg9pDgNkfCUKRW
        W07yA6XQz7Tut61C0a6xr5AcjV6yb2w=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-9KMmvFwsMfqMe54oUXBygQ-1; Fri, 25 Jun 2021 11:34:16 -0400
X-MC-Unique: 9KMmvFwsMfqMe54oUXBygQ-1
Received: by mail-il1-f200.google.com with SMTP id m15-20020a923f0f0000b02901ee102ac952so6412449ila.8
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 08:34:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P+irYxL4B6g9k/ospIqhO666waG3AOzkyA4aW0tTUSw=;
        b=lJN72W7hYlzIjiCJe034MtW9gLKgT4R3ip+gRWP9q0NE+dG0vtIDvFtzMXq8EPhuj1
         mxhVn4JDpvQqSSdn970VLCZ7pctSXXEyvnPA4kwrZ7sJu4qEByGc9E9IqITK/JVfmsY9
         QpX309RbhJa8trAfK7Nyy+qzWZEP91og5b6535Xm/Pw/PK5VLxS4kQWW0tyV07h2X9fv
         aaZf090LqVqviVl8Shv6P7Ab9poEnJJEkGd3P8J8KGuLrGTrdX02hsX7Y3oA+RWXFwNF
         BTL9Slu9SD04EQlrpwlDVY9CabSa76y/Qd4qvT+9gnO06mbTAS3IHFncGuTfQ5OPc1KU
         qn/A==
X-Gm-Message-State: AOAM530wVwvggvWa8+HgXYCSp7z1O2zWQ9RIn7pq7nudzmmWxjPH2iLS
        kRW4Ycj5mLXSyPVMfrM9RsjW6LQ1Umr185s3NP1fzdGExHSqdDUlbmN8e0/wySAqwu/TYy+NpG2
        T9iB0nlm7QkjI
X-Received: by 2002:a6b:6205:: with SMTP id f5mr9020427iog.60.1624635255422;
        Fri, 25 Jun 2021 08:34:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6tjZFUGP/NqbgvCCXLVIQHOsoTMddP4SdvnmyH8q0xAkmsSrB5eK5GxDG+LLmaPOasLYXpw==
X-Received: by 2002:a6b:6205:: with SMTP id f5mr9020417iog.60.1624635255257;
        Fri, 25 Jun 2021 08:34:15 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id l12sm3679281iln.20.2021.06.25.08.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 08:34:14 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com, Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 7/9] KVM: X86: MMU: Tune PTE_LIST_EXT to be bigger
Date:   Fri, 25 Jun 2021 11:34:13 -0400
Message-Id: <20210625153413.43570-1-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210625153214.43106-1-peterx@redhat.com>
References: <20210625153214.43106-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently rmap array element only contains 3 entries.  However for EPT=N there
could have a lot of guest pages that got tens of even hundreds of rmap entry.

A normal distribution of a 6G guest (even if idle) shows this with rmap count
statistics:

Rmap_Count:     0       1       2-3     4-7     8-15    16-31   32-63   64-127  128-255 256-511 512-1023
Level=4K:       3089171 49005   14016   1363    235     212     15      7       0       0       0
Level=2M:       5951    227     0       0       0       0       0       0       0       0       0
Level=1G:       32      0       0       0       0       0       0       0       0       0       0

If we do some more fork some pages will grow even larger rmap counts.

This patch makes PTE_LIST_EXT bigger so it'll be more efficient for the general
use case of EPT=N as we do list reference less and the loops over PTE_LIST_EXT
will be slightly more efficient; but still not too large so less waste when
array not full.

It should not affecting EPT=Y since EPT normally only has zero or one rmap
entry for each page, so no array is even allocated.

With a test case to fork 500 child and recycle them ("./rmap_fork 500" [1]),
this patch speeds up fork time of about 22%.

    Before: 367.20 (+-4.58%)
    After:  302.00 (+-5.30%)

[1] https://github.com/xzpeter/clibs/commit/825436f825453de2ea5aaee4bdb1c92281efe5b3

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b3f738a7c05e..9b093985a2ef 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -137,8 +137,8 @@ module_param(dbg, bool, 0644);
 
 #include <trace/events/kvm.h>
 
-/* make pte_list_desc fit well in cache line */
-#define PTE_LIST_EXT 3
+/* make pte_list_desc fit well in cache lines */
+#define PTE_LIST_EXT 15
 
 struct pte_list_desc {
 	u64 *sptes[PTE_LIST_EXT];
-- 
2.31.1

