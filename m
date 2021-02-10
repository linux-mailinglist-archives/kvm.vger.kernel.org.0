Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D40317401
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 00:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbhBJXKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 18:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbhBJXJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 18:09:31 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE5DC0611BE
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:07:05 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id l197so4234116ybf.17
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=0O47gXh514nfPDoLIe0tEYtVLi+SLooBrwujOdhUj5c=;
        b=R53vF2RPZ+cJSdkvPJG7YJQe/6soGIV3FT/czqFkJub5LyyaDo/gy9/ZXpebn9oFFK
         3XT5gzQt2AnBDDlwJyGjPe+oppvCWF/EFPX7qsqH6lEr/4Mb6RMIR7hZwAPqlOVdrKjL
         0i07ym41KhfeJXlA3iPdoyhIDLsDRCwdP2rj9vbTGoAnomVO8RJGmOqTrBZNRdZZvWPG
         mLnN6Pws3AoVyXzqkxLrImeKvW5512ZJhiJZAx9wWocq24JSrxwX7iOdugwVr8H7uDos
         vjUKdbpvKsJ5JxX1caTX6cVCkrfooReEGbT2Ho2DT3zS7sb6P+Q+Aj6asZ+YqEmDcbiZ
         yfdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=0O47gXh514nfPDoLIe0tEYtVLi+SLooBrwujOdhUj5c=;
        b=sOn6lYXS+bycfcstgktNiZsmCLz8awpKTWEh+9qL9Weq4qVLS8bn8Y209GhHsZmvKV
         KVe1mpbLInNpokfKWoSLuic78/3Rzowi8CiggttLCqDmBodng4mZuRzkOClzyRINJlds
         u1qRFoJrb+EcpRSRyESF7IUl5VywE6QUDLF9PZYcijHB9kPcVGFoGE5TYl9kjLrUJL5U
         2zXXxnYbYG1424N4eHzpGg284ts2HteYBJgXjW750oC3DPUNjxFmMkVwvOwE2zvuig1k
         TgziBXP6vCs+ofr+f+m6nmgy0cvBVN73lrkIDd0kkEaZxLTtaYx6KJ64iwWOu4O2P7Nw
         PSHQ==
X-Gm-Message-State: AOAM533oyJcaAEqNcBEKWA9a/5pIAsC7pEg2uN2qTxNXQchddNI86AlK
        twiNxwTWA6d0gBFzI0Qmut+1jyeZqYE=
X-Google-Smtp-Source: ABdhPJzqySYZiZAN5x2B4E4ONnbmA2MSSJV6p8sSGxQeVOJ+OQQVG8MFENrToeIODXJ0kRahIpfSBqMpxSw=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
 (user=seanjc job=sendgmr) by 2002:a25:7693:: with SMTP id r141mr2748225ybc.49.1612998424575;
 Wed, 10 Feb 2021 15:07:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 10 Feb 2021 15:06:24 -0800
In-Reply-To: <20210210230625.550939-1-seanjc@google.com>
Message-Id: <20210210230625.550939-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 14/15] KVM: selftests: Track size of per-VM memslot in perf_test_args
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

Capture the final size of the dedicated memslot created by perf_test_args
so that tests don't have to try and guesstimate the final result.  This
will be used by the memslots modification test to remove some truly
mind-boggling code.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/perf_test_util.h | 1 +
 tools/testing/selftests/kvm/lib/perf_test_util.c     | 8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index 330e528f206f..4da2d2dbf4c2 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -30,6 +30,7 @@ struct perf_test_args {
 	struct kvm_vm *vm;
 	uint64_t gpa;
 	uint64_t guest_page_size;
+	uint64_t nr_bytes;
 	int wr_fract;
 
 	struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 6f41fe2685cb..00953d15388f 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -80,8 +80,6 @@ static void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
 	}
 }
 
-
-
 struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 				   uint64_t vcpu_memory_bytes,
 				   enum vm_mem_backing_src_type backing_src,
@@ -104,7 +102,11 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 
 	guest_num_pages = vm_adjust_num_guest_pages(mode,
 				(vcpus * vcpu_memory_bytes) / pta->guest_page_size);
-	vcpu_memory_bytes = (guest_num_pages * pta->guest_page_size) / vcpus;
+	pta->nr_bytes = guest_num_pages * pta->guest_page_size;
+
+	TEST_ASSERT(pta->nr_bytes % vcpus == 0,
+		    "Guest pages adjustment yielded a weird number of pages.");
+	vcpu_memory_bytes = pta->nr_bytes / vcpus;
 
 	TEST_ASSERT(vcpu_memory_bytes % getpagesize() == 0,
 		    "Guest memory size is not host page size aligned.");
-- 
2.30.0.478.g8a0d178c01-goog

