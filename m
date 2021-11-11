Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA9E44CE16
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234346AbhKKAGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbhKKAGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:06:20 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F3AC061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:32 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id u22-20020a170902a61600b00141ab5dd25dso2131203plq.5
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lMvpWUPWJPTO9CE1xh06Zz7pIPVSd/jSPrFlRpXLV78=;
        b=P6Szp+uGt8cjVKSc1jKri6+P9Ocp+G6101tjHladzRC8SeATPnb3LBwo4NgxNLq5U0
         xyJXKn0IvnjJk3jJyJOdHFwr4gj6GRTMUuB02DGkhYGThOgGjDkxip5z8wLrEySSUL4u
         sGkhSSkIwLkuMkxqE8DGikkZaBgU9P3fEnmCXm/ILzwXKVQnd4Z8RIpuhoXiaPPIua5b
         ckkOpJ/Ilq0xx15kSxSsuu7Aj3Q5joufCFK6erKdEcDRVvNbf9WPc1eZ6lonkX5IDaWD
         Njye0+NDbPiyCfRhGejBvH0tJ/Gmeyya/P6nhk+8ZCVyTYI9MSMhz3WHlwgvAADsh4i8
         ovKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lMvpWUPWJPTO9CE1xh06Zz7pIPVSd/jSPrFlRpXLV78=;
        b=1aPSfmva8nWUfye8dXLFEIVj12ejtcn/+QDYJcB9yAlt3CJD8yPlctis7uPThaXinO
         HQSW3rNJ2rcSNReb97HhMbMmIMoxlmBH6IuFnAQn5KnEXzhU10u0Pc5tuovliDJPZAys
         SHwb3QK9ObDlYig5Ld1PPDYIR5xy2WTt3+PHUl7N/K8RuUQFWFFpRWF2TAP/hMX9TR30
         +jb3GOcqv0GEp2XlYJHgeu6qLcbifdo8HC9RWx4oRAZpawEVoy5VGid0chLaCHP/D8aY
         0OvKZfLmBbLfpAG8gy/XRX2PIpLTtvJIiAHq0Pu0j6PuGcjv0NVwrBtxZS6HGWPIBaso
         dgkQ==
X-Gm-Message-State: AOAM530cFkNz9wGpP8/1Uo2pifS6lxQui7Yk+cjHdmJ+vhCO5it/NZ2e
        oJVP3j6wFuNCDA4VUrkZo4lyW5bQ1te80g==
X-Google-Smtp-Source: ABdhPJw/AskE7qHLjkCoROJAnZzjRNrnq3OgfLJLgU7Tq67mKw6KK803jFjceOmbVedTpDBHo88TGwPf0/oanA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:21c6:b0:44c:937:fbf3 with SMTP
 id t6-20020a056a0021c600b0044c0937fbf3mr2949121pfj.2.1636589012300; Wed, 10
 Nov 2021 16:03:32 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:03:08 +0000
In-Reply-To: <20211111000310.1435032-1-dmatlack@google.com>
Message-Id: <20211111000310.1435032-11-dmatlack@google.com>
Mime-Version: 1.0
References: <20211111000310.1435032-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2 10/12] KVM: selftests: Create VM with adjusted number of
 guest pages for perf tests
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

Use the already computed guest_num_pages when creating the so called
extra VM pages for a perf test, and add a comment explaining why the
pages are allocated as extra pages.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/lib/perf_test_util.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index a0aded8cfce3..b3154b5b0cfd 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -77,9 +77,13 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 		    "Guest memory cannot be evenly divided into %d slots.",
 		    slots);
 
+	/*
+	 * Pass guest_num_pages to populate the page tables for test memory.
+	 * The memory is also added to memslot 0, but that's a benign side
+	 * effect as KVM allows aliasing HVAs in meslots.
+	 */
 	vm = vm_create_with_vcpus(mode, vcpus, DEFAULT_GUEST_PHY_PAGES,
-				  (vcpus * vcpu_memory_bytes) / pta->guest_page_size,
-				  0, guest_code, NULL);
+				  guest_num_pages, 0, guest_code, NULL);
 
 	pta->vm = vm;
 
-- 
2.34.0.rc1.387.gb447b232ab-goog

