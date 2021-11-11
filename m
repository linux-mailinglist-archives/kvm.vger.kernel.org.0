Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611BC44CE15
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbhKKAGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234336AbhKKAGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:06:19 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29377C061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:31 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id u6-20020a63f646000000b002dbccd46e61so2291596pgj.18
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XiTkYX7gs0cLKe9ierAcN63ncrzHniZEt0Nt4vaBoqs=;
        b=JBJkO23NlOtRou8jWV8NlOEgxzCIshAAQZq5bce81gfGX4Hpv540AszFP9S5VakCwy
         gDPDp018GQ8uwFuwmY2xmZ4sL6vuwkY4KxM2HuB73CnybL22gGJ8GBCEvJ7XywhnhT/1
         ZqcUW+DmxC/LN1RvQXpHMFU73qUAjvHRpkDuCkmSg50A8o3r6anfoliN/xFw7ut2TRQ6
         O+YrykxF3YW4sncE6DYm4ufmec6+2YzyfJpqD8uhL1C4PsR/7bPcYj4QyiuU7vYINHYu
         hAo+hyFRXoKhWjucow9qk2TPQ4Wes7pfiixn/zl1yBt5X+KDrnRmY9kSQJSMCwJWj0Be
         EviQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XiTkYX7gs0cLKe9ierAcN63ncrzHniZEt0Nt4vaBoqs=;
        b=sfvAT6CFUQtUojcA0oTFF2Cf6naFYasrkJtkjbyxt6hUbFuwn9QATjAkBK+eoJ4QwP
         Nv9T5UZIv8XoenVqAi3Q/dvmC/Fes5S9FRw/uY8Ehd4lO0N/sTh/ehiKbX7zZau2hGZq
         5XWKKql9LieUZHmgVO7ajxiLV2MnTG6dZ2iP3yLR+auwQNmVWWIL9nVy/SZDDl6BR4Xm
         X7SfGTBHDnjfVoIXLw2qElp6rRgdKYt28x/vDpyStaOLG7E16jX+mur0ik6a2Dc6S9ok
         CZrqhad+G8ldCv/+oVnDhUIyQR96OOfdzHsVf0wLorKQcQdsQgZHTE2JbyFt4c+bh1iH
         Z3Lg==
X-Gm-Message-State: AOAM531u7X49+6jY12dziiqmu0EK2Yb2QTzK275GWkD3/BbTVAxA3pc+
        KLbFx0OL71Q1kMi90+DYnGgtVBkD3NZw7A==
X-Google-Smtp-Source: ABdhPJyMr0H+YuRUYMr4wmg60T2bvcMvrDXEp9td7Ksv7NbJyW8gwgowgEf6TyKo5Qgjk7XvbCop0wsBmgVp5A==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a63:2a93:: with SMTP id
 q141mr1793040pgq.45.1636589010693; Wed, 10 Nov 2021 16:03:30 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:03:07 +0000
In-Reply-To: <20211111000310.1435032-1-dmatlack@google.com>
Message-Id: <20211111000310.1435032-10-dmatlack@google.com>
Mime-Version: 1.0
References: <20211111000310.1435032-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2 09/12] KVM: selftests: Remove perf_test_args.host_page_size
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

Remove perf_test_args.host_page_size and instead use getpagesize() so
that it's somewhat obvious that, for tests that care about the host page
size, they care about the system page size, not the hardware page size,
e.g. that the logic is unchanged if hugepages are in play.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/include/perf_test_util.h | 1 -
 tools/testing/selftests/kvm/lib/perf_test_util.c     | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index d7cde1ab2a85..9348580dc5be 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -28,7 +28,6 @@ struct perf_test_vcpu_args {
 
 struct perf_test_args {
 	struct kvm_vm *vm;
-	uint64_t host_page_size;
 	uint64_t gpa;
 	uint64_t guest_page_size;
 	int wr_fract;
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 0fc2d834c1c7..a0aded8cfce3 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -60,7 +60,6 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	pta->host_page_size = getpagesize();
 	/*
 	 * Snapshot the non-huge page size.  This is used by the guest code to
 	 * access/dirty pages at the logging granularity.
@@ -70,7 +69,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	guest_num_pages = vm_adjust_num_guest_pages(mode,
 				(vcpus * vcpu_memory_bytes) / pta->guest_page_size);
 
-	TEST_ASSERT(vcpu_memory_bytes % pta->host_page_size == 0,
+	TEST_ASSERT(vcpu_memory_bytes % getpagesize() == 0,
 		    "Guest memory size is not host page size aligned.");
 	TEST_ASSERT(vcpu_memory_bytes % pta->guest_page_size == 0,
 		    "Guest memory size is not guest page size aligned.");
-- 
2.34.0.rc1.387.gb447b232ab-goog

