Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCCE44CE11
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbhKKAGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234319AbhKKAGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:06:14 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA604C06127A
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:26 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id z3-20020a170903018300b0014224dca4a1so2178860plg.0
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sFLbWO4bOI5I9JoMGkKQ6ckt7pYNE6wIcP4cuGr2rxs=;
        b=OJU6vrgnj3uSZ8ycvuKmSQR63UBrpBUMkDD76zH8p79gq0uiRL7U/o80DIp7as0HeS
         y3UFG8IcseXw+b1ZjLL5NvowOx/vwofPs2Bjxxpbrx4FXwsqHpwjFcKbXQS0ZiHrgRva
         hHTcNGwqBlUmeZKQtPifXyR59f3tXKD2nNAFQ+T0lUY87p+7r7usSjvKPZ73ROb7Gka0
         UowXlSmrhlrF94CH5ohf7uGFjLxAA5zM8b2rQYSshpGV5lhu6EK0VTcTit48lvEVlS/M
         AyR0VNrdeKBGcfeN+AYfF3jxgx8pzqShEmV3pV5P+zjxlRifbLtP56puh2pl2haoPZCb
         5hdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sFLbWO4bOI5I9JoMGkKQ6ckt7pYNE6wIcP4cuGr2rxs=;
        b=6xCpKXfXHoR8J/Ie6c1Go3qGZaVatQAX1XDpRHi3lKa97YKQBeZugA+DuFVhQ6kkLt
         nqAPEBno1N7lC7ayeCYRcRp0T6SBq/VZ/Qi5+vDqwQBtW7PdIaIqy6wekqTS8xQmA7R/
         0n05NRwRBwVxViuDw/7ockrCav66VDz7xCa97h7B1bkEG30Ch3iplFINylFVlsEhUhvt
         rDWQgMk44rIghrq6KnW8hsZ6o3jFAxLhw/r4Drw6rpPPUM8Y/0K2ylqiBf/zMUMbb2o8
         iMYFw7W25ZKfS1lkOSX8CSOWTYBSCRQzEhIyYH0zB/eQwVUg/dQw6fSoV93Up6pDVGHY
         YjMA==
X-Gm-Message-State: AOAM530JpXsfr/uIMiZRko5hl2G7Jk4pH+MeIDwUFmXfSPdL44aIx7nN
        Co//5iUK6ZB7/iWOiPr3veEhhWT8ZDHlNA==
X-Google-Smtp-Source: ABdhPJwTiTvkmcRFNfX2YNbZMhTDBXnt/PWSC+XeuI1UXlYstFyUaxR3Pc9jLIfNmo38Pu8RoqFIqFtyAXdDnw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:654d:b0:141:7df3:b94 with SMTP id
 d13-20020a170902654d00b001417df30b94mr3295949pln.60.1636589006192; Wed, 10
 Nov 2021 16:03:26 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:03:04 +0000
In-Reply-To: <20211111000310.1435032-1-dmatlack@google.com>
Message-Id: <20211111000310.1435032-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20211111000310.1435032-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2 06/12] KVM: selftests: Capture per-vCPU GPA in perf_test_vcpu_args
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Capture the per-vCPU GPA in perf_test_vcpu_args so that tests can get
the GPA without having to calculate the GPA on their own.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/include/perf_test_util.h | 1 +
 tools/testing/selftests/kvm/lib/perf_test_util.c     | 9 ++++-----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index df9f1a3a3ffb..20aec72fe7b8 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -18,6 +18,7 @@
 #define PERF_TEST_MEM_SLOT_INDEX	1
 
 struct perf_test_vcpu_args {
+	uint64_t gpa;
 	uint64_t gva;
 	uint64_t pages;
 
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index ccdc950c829e..d9c6bcb7964d 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -136,7 +136,6 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
 			   bool partition_vcpu_memory_access)
 {
 	struct perf_test_args *pta = &perf_test_args;
-	vm_paddr_t vcpu_gpa;
 	struct perf_test_vcpu_args *vcpu_args;
 	int vcpu_id;
 
@@ -149,19 +148,19 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
 					 (vcpu_id * vcpu_memory_bytes);
 			vcpu_args->pages = vcpu_memory_bytes /
 					   pta->guest_page_size;
-			vcpu_gpa = guest_test_phys_mem +
-				   (vcpu_id * vcpu_memory_bytes);
+			vcpu_args->gpa = guest_test_phys_mem +
+					 (vcpu_id * vcpu_memory_bytes);
 		} else {
 			vcpu_args->gva = guest_test_virt_mem;
 			vcpu_args->pages = (vcpus * vcpu_memory_bytes) /
 					   pta->guest_page_size;
-			vcpu_gpa = guest_test_phys_mem;
+			vcpu_args->gpa = guest_test_phys_mem;
 		}
 
 		vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
 
 		pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
-			 vcpu_id, vcpu_gpa, vcpu_gpa +
+			 vcpu_id, vcpu_args->gpa, vcpu_args->gpa +
 			 (vcpu_args->pages * pta->guest_page_size));
 	}
 }
-- 
2.34.0.rc1.387.gb447b232ab-goog

