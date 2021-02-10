Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58913173F8
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 00:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbhBJXJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 18:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbhBJXIL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 18:08:11 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E7DC0617AB
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:49 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id p27so2336967qkp.8
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=bqMGTJ5vOw+semy7dsWveGKT1K6fm5k0VBXJ6jv82pA=;
        b=DDPfRlAN3/unXQuVAovsk/1lAj+LjkZkhNvYdbKLUODsxhaiN4I8Oe+oDNQDktWy03
         ar7L13rV4vJTXc2WMNN353xkhag1VI84Fq8McGnYrSqH0/29qG06s4od94m7wsDVAAmc
         asS/uLUCm25RZQHKVBwLbCmqFkZv2UvKEHrrPhV7zUBtgR7WW4RnHvdbCZUleGIuvueY
         WKCs+49ZHXiHfJ1FUA0nwMQS091YhF9fXmlsM98rcDAFBU6J7VEqD6CvgyI2l7xnchJI
         7xkPcSdZHR9Ka+0fHfTe2al7fCT0puVGB1FMkoc5qWPJgSYF5PcBZQUvK/bv/fUeRmiL
         BKGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=bqMGTJ5vOw+semy7dsWveGKT1K6fm5k0VBXJ6jv82pA=;
        b=aImRl+p7aJ7ABOPyKR+py0Z8oYh1QqvqSZsjTuA9TfvyZ9KvUFhzKv2qs33oXSSAK4
         cYjXUPnwdQ72cVKz1AVhLh3ASePmEcA/qqhJL37PVMpnQULVzPOXLsNxB1TqNeye33n+
         Hgz8J/qR6UGgKE2/DiSjU0Yk0pBvXzogGrtJ4QDpOZI5hSN0OeXMZQIxt9t1GUakRjUW
         N63CnupPswQtn+yfL5YWAyNyWIHNDm96/1fB6YkAtZMCyhi0HsG5fGQU0jP2iUtINDcr
         vtpURWPT+G3mPZBcvbHiwwpHqTWbAmiOugRhlhzA32yO4nh13NSci1MOxjwBy3P6X/7d
         kFcg==
X-Gm-Message-State: AOAM530iZKZwfiEvpwWF2P1WoTjWSoDW8As6FWpGpcXqQO1TmiXW6/KV
        JnoEo9sON/tZADy4S2ttyjzpnRPyO84=
X-Google-Smtp-Source: ABdhPJyhA7a+URvhu7VOSpiVDgQ2m//y0GtJoyAE28YOf/D8VPHCX01hw7Ld0JOA7f5dn65bckYASMzIgnM=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
 (user=seanjc job=sendgmr) by 2002:a0c:e5c9:: with SMTP id u9mr5391387qvm.55.1612998408158;
 Wed, 10 Feb 2021 15:06:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 10 Feb 2021 15:06:17 -0800
In-Reply-To: <20210210230625.550939-1-seanjc@google.com>
Message-Id: <20210210230625.550939-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 07/15] KVM: selftests: Capture per-vCPU GPA in perf_test_vcpu_args
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Capture the per-vCPU GPA in perf_test_vcpu_args so that tests can get
the GPA without having to calculate the GPA on their own.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/perf_test_util.h | 1 +
 tools/testing/selftests/kvm/lib/perf_test_util.c     | 9 ++++-----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index 005f2143adeb..4d53238b139f 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -18,6 +18,7 @@
 #define PERF_TEST_MEM_SLOT_INDEX	1
 
 struct perf_test_vcpu_args {
+	uint64_t gpa;
 	uint64_t gva;
 	uint64_t pages;
 
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 73b0fccc28b9..f22ce1836547 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -127,7 +127,6 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
 			   bool partition_vcpu_memory_access)
 {
 	struct perf_test_args *pta = &perf_test_args;
-	vm_paddr_t vcpu_gpa;
 	struct perf_test_vcpu_args *vcpu_args;
 	int vcpu_id;
 
@@ -140,17 +139,17 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
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
 
 		pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
-			 vcpu_id, vcpu_gpa, vcpu_gpa +
+			 vcpu_id, vcpu_args->gpa, vcpu_args->gpa +
 			 (vcpu_args->pages * pta->guest_page_size));
 	}
 }
-- 
2.30.0.478.g8a0d178c01-goog

