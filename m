Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BE144CE29
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbhKKAP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbhKKAPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:15:55 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7884CC06127A
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:13:07 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id g142-20020a625294000000b004946d789d14so2876839pfb.3
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2sCX7CweXC67Abnd37AsNrYg4TDAsmuRvoSvasuyj6g=;
        b=VBsPGn3S6eT+oHi/47Q2U7PozSs06LEMgFVti1cW4iUgR7mRgzFy9JA7EcE7Flt50r
         craw3krli46jBhsarHsBuQAtEmQ0TWCKHzYDvIixEDAlKMDZZVH97xU2xgC3YyzOJ5d4
         Ev/BiqPY4qjwWdjeHZWH1CFG0+NYjJy0BFiCeKNHZ/yanTJMiQ93WPheTYHXgpmb+CjY
         1t1LkpKgJYLrmhRLeZ3/oUun/pTKVlpF42J++O1ZTyOMgXJjdyZYesY33VE25cnxMJb7
         J7djp2xwtAMHqaPWZ5xX9h2MGUhqCbKo9eegicRlTkes7jzdmzL6FEC8W7rgheWyzkX9
         iqIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2sCX7CweXC67Abnd37AsNrYg4TDAsmuRvoSvasuyj6g=;
        b=NmjP77Js09nrLP/q5q2RUMSLSq5Zy5dqqjw8QWE56Iie8q8DpvLxrDmJAh2M38OW4E
         o2Vn9UqJRgsivAkoDIgvmj5RH1qaSjANkElwgnICG1Yx+IaaCqhRJeQk95lum+VJRO+z
         FP4Yk7sUsKqmSjyXU7UBDPlBj9TYQHAzfZUd+aaIN8PoZ4SCo7BGbNhYEM0KpSzmR70C
         557oJVRV5NLdVzLRZcXvYeUXv4UVGVBsOYfdeVcFTjuJugW43YUGlaDybYd8Zj+mR4TU
         Oq6287K+wely/Ed3eMXZuqPIFOWJZbACmH78gK2TmCPfAZvrFo5ax96HsrD4dlkW5h/R
         VBHw==
X-Gm-Message-State: AOAM530Ad5NWHXlNgBHUkUa2FjpVrewyKGgeRzWBA43+mZ2IFTKMW37H
        BeKuz1OHNXuXSbfjdlKJSEs0fKsPQ/ZwoA==
X-Google-Smtp-Source: ABdhPJxLgInxOGkOa22sQvKniPjROMEAYUZuEaZazGb+3gI1SJUhq1zmfWso87xYrR8SLm817e53e3nT80z8Iw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:15c1:b0:49f:d21f:1d63 with SMTP
 id o1-20020a056a0015c100b0049fd21f1d63mr2871509pfu.18.1636589586940; Wed, 10
 Nov 2021 16:13:06 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:12:57 +0000
In-Reply-To: <20211111001257.1446428-1-dmatlack@google.com>
Message-Id: <20211111001257.1446428-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20211111001257.1446428-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH 4/4] KVM: selftests: Use perf_test_destroy_vm in memslot_modification_stress_test
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

Change memslot_modification_stress_test to use perf_test_destroy_vm
instead of manually calling ucall_uninit and kvm_vm_free.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/memslot_modification_stress_test.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 5bd0b076f57f..1410d0a9141a 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -116,8 +116,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	perf_test_join_vcpu_threads(nr_vcpus);
 	pr_info("All vCPU threads joined\n");
 
-	ucall_uninit(vm);
-	kvm_vm_free(vm);
+	perf_test_destroy_vm(vm);
 }
 
 static void help(char *name)
-- 
2.34.0.rc1.387.gb447b232ab-goog

