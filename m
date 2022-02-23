Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46924C0BAB
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbiBWFYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237716AbiBWFYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:24:20 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516EE694A9
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:23:53 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id s22-20020a252d56000000b00624652ac3e1so11129304ybe.16
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=o+K8zCWcV59JiWXD4aWine0/FDtELjiPI/RbdPNAHQc=;
        b=gL62Qc22CZ6FeqYe4RTaen0CJKVsVLhWP6XuIpy8wtIhquKE7Hq2aAgjM0cnFrMx//
         B9jyIFrBZPnR4ZblulS8U7l5+BX78tipmOGn+uNc7HwBgNSyCtAgwmuxuLupc9yf33fw
         sG7BRSGiBqlxsiI4E0nPILyGbfSDlu+DOPd9cNUxoIqlK1SF5LShFZNMYNQ5wWc1UUUq
         JRgPAlM6n7K8F/7k32Qk1plHhKLU8qRnhntMmXKxbAFtecCJ3vVWG8s4ryjAHjKMNW6w
         HoGY4yajLvjwNYPSxXLVJpFkRwFJsLHr1WAWSZWkzlHrdQQ5OWrVIF2pqwZ0e1qUQPaz
         mArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=o+K8zCWcV59JiWXD4aWine0/FDtELjiPI/RbdPNAHQc=;
        b=Emestt3Ac8bLX/aT9FijF89EvfyV4KCKLvJx/L02KdNWqLPYTYs3Ob6PsGipm43Ht8
         oGm5BBfF/yoJWlLwUVaRYQQL7I92C/ycTTo5KTc5hQzPePp3qTDqR9pQ+r5AY/2zmjn1
         bzhGQ/7IhY/J0vKwvL81KSKu8T5coKZoRg/Zj7X5Rjtowyu84Dv6ZNbF+ry7CcgNyp1m
         LAaQIPjPSBY+AhjZwn4U63nVuXUaOhfvXVzU/gEQm2GyILooIboj9wB2g8f4lih86TJE
         Puz7wdNS4Q4yYyqHtrDXZ83OgjUaOWJNOrBOTToVQ2TLjYfBfpiyHZlE8OLh9Qga3dp3
         oKSA==
X-Gm-Message-State: AOAM533uBPp4gDBhtqhPjW/uGe656iGFd/huhPTzU8fBRG3+cD/H/rgG
        ecxFDt9NK447Zfc5RlL4RHXltD4ppskO
X-Google-Smtp-Source: ABdhPJyhZCUKb1E/Ab+htpmdItbzaBqk6IfSNwdQ2cMPET/cQ9m/cxN2+Idkkun2NTapLkyPe3v/k6Dz4k/E
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a25:a486:0:b0:61d:a523:acd0 with SMTP id
 g6-20020a25a486000000b0061da523acd0mr25432547ybi.203.1645593832574; Tue, 22
 Feb 2022 21:23:52 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:39 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-4-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 03/47] mm: asi: Switch to unrestricted address space when
 entering scheduler
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To keep things simpler, we run the scheduler only in the full
unrestricted address space for the time being.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 kernel/sched/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 77563109c0ea..44ea197c16ea 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -19,6 +19,7 @@
 
 #include <asm/switch_to.h>
 #include <asm/tlb.h>
+#include <asm/asi.h>
 
 #include "../workqueue_internal.h"
 #include "../../fs/io-wq.h"
@@ -6141,6 +6142,10 @@ static void __sched notrace __schedule(unsigned int sched_mode)
 	rq = cpu_rq(cpu);
 	prev = rq->curr;
 
+	/* This could possibly be delayed to just before the context switch. */
+	VM_WARN_ON(!asi_is_target_unrestricted());
+	asi_exit();
+
 	schedule_debug(prev, !!sched_mode);
 
 	if (sched_feat(HRTICK) || sched_feat(HRTICK_DL))
-- 
2.35.1.473.g83b2b277ed-goog

