Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2147D6308CF
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 02:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbiKSBxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 20:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbiKSBwo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 20:52:44 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806DEC4C09
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 17:34:57 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id x18-20020a170902ec9200b001869f20da7eso5050293plg.10
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 17:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3L4OGgzlwO72UOhCz/yhgDnemDx1svOqEC1kNqY2LlY=;
        b=TVbNKYXyk9Av6G9IU5hbcSdtY604tXdeCj/mxuYUgo562vyrKEnoOwdFmmSYRnZrhU
         LBAmImeVeqCcB52XaO11Dmz+EQI28t/X/Gs+d5+qZTdOdJf7GMrh0NFsTqYcRXm4daLY
         1hASafr2iIbEc1hm+AW2G4MQ9J2SaNiShD66DGhZuBIFahYe4A7PKc4KgX+70SodAs71
         LXrpBgaC8CNiujzkmhmqZsdDxNiUEsMLzhgiL5qXrHvOT5DFgOO6Q4QTpk/DiS8A560t
         FkLFabDChtATnitORRutffp7/vTBioX1ecxNmZ4lOUjomxAKyCBVCCd95HwPrc++VJ5O
         5zWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3L4OGgzlwO72UOhCz/yhgDnemDx1svOqEC1kNqY2LlY=;
        b=7EDzehOgt6AcbS9v+ieSNlkJv4KSCOdZJcFckgo1n9VgoA3W1HFnD2l5FoRPyfGQne
         fieRmPm7fGQA98cRsztDRi6A8EWyyq184wODYJ/twIwYSBcPc3rNwZNUjJyWfWN3DXes
         Xs3MI8R/4SM/GHPpe3oE9SkjS8r26oi9CcSHWBPZUNyk1GcMpmv8H2EUN8gS6b/3QoYV
         14DVYUTXYhzhJKM+/544jcpjvTwJvb8EhMkOyDaK5Kh/N1vsAHNe/ZfUHj0NPM6c8oUj
         6W/gPyd/SuwMe/GH0zcqLnN/AuNMZRtWaAtgiLkuiGeRrbRczEAHMZpId4jr8YLd+/yU
         4udw==
X-Gm-Message-State: ANoB5pnhqqO30u0fQBzkjWMfWr1kH53PtOIkofiQuS/8MxD0aIoe453w
        iCqkZFAXW4F1vN+NgEdWsKsxfl8ubYU=
X-Google-Smtp-Source: AA0mqf4a3EuImoG/D3FXOGGiQ5UvajgyaUYXWjbOt902dSxf64funzGHz6rGaLtUr696UrpKBN8u95QEt7U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4615:b0:218:8f4:bad5 with SMTP id
 w21-20020a17090a461500b0021808f4bad5mr16521916pjg.55.1668821696975; Fri, 18
 Nov 2022 17:34:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 19 Nov 2022 01:34:43 +0000
In-Reply-To: <20221119013450.2643007-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221119013450.2643007-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221119013450.2643007-3-seanjc@google.com>
Subject: [PATCH 2/9] KVM: selftests: Remove unused "vcpu" param to fix build error
From:   Sean Christopherson <seanjc@google.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
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

Drop the vcpu param in the Hyper-V TLB flush test's call to
vm_get_page_table_entry().  Commit 751f280017b6 ("KVM: selftests: Drop
reserved bit checks from PTE accessor") eliminated the param, but the
in-flight patch to add the Hyper-V test didn't get the memo.

Fixes: a105ac64bef6 ("KVM: selftests: Hyper-V PV TLB flush selftest")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
index 44525255f5c8..68f97ff720a7 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
@@ -625,7 +625,7 @@ int main(int argc, char *argv[])
 	 */
 	gva = vm_vaddr_unused_gap(vm, NTEST_PAGES * PAGE_SIZE, KVM_UTIL_MIN_VADDR);
 	for (i = 0; i < NTEST_PAGES; i++) {
-		pte = vm_get_page_table_entry(vm, vcpu[0], data->test_pages + i * PAGE_SIZE);
+		pte = vm_get_page_table_entry(vm, data->test_pages + i * PAGE_SIZE);
 		gpa = addr_hva2gpa(vm, pte);
 		__virt_pg_map(vm, gva + PAGE_SIZE * i, gpa & PAGE_MASK, PG_LEVEL_4K);
 		data->test_pages_pte[i] = gva + (gpa & ~PAGE_MASK);
-- 
2.38.1.584.g0f3c55d4c2-goog

