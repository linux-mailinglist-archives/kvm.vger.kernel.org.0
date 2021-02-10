Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812353173F6
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 00:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbhBJXIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 18:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbhBJXIP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 18:08:15 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C4EC061223
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:58 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 127so4194283ybc.19
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5PnXDF9tiDkGPbh/VAWaDwby96Avt0+QuG4w822UbjY=;
        b=Ta/BJY4l1df5MvQ8o8wCs579FL0qBg6e+Ev+44fO/sCFPAmHqrzszh1h1b1aidhjgy
         sA3TU6A6ir+0rKWWoK8QsIiw9+1u1PqhcDkh7V11tiARPiHCVZuNLrgyOvcxbMLWC2MI
         O/M5epUclP33pX0tTZNA3hVu91cJZBVI2nt8mqMfBRqdxnCDXu6O5hINNLTg2Qvd05ib
         UqIYB2q7oHinhOVSdWe4lovNE7wHuWKEgLZgDlfQ9chtRBn1ZFSF8+kFxuXwSDFcedlN
         NHN2rKgG+xttQynNlbxKZUjWtu0GfJ5iPDC8MqCCGhq8GKT62i4n/eS/iR0NFb2nSyYO
         cSBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5PnXDF9tiDkGPbh/VAWaDwby96Avt0+QuG4w822UbjY=;
        b=eJIbu7Gtgw4Iz4sqsnGk+5G35uYV3WSre/dWspqKmTGR40ostbRbaLyzm3ax74iZh6
         E9ZP8dVDb/R7y03tUyrfZgKGMw/Bu3ryjK6kh1Fp6DH6RI9mG5Ujuba/WVDjKUS3XN6g
         MTJSfOgpRRde845xkTfQ1DPzPBymla3fbA+oVFtNZNT+bBZLHRBZ2ipORRzES4r+fYd3
         yrj6dMtAwM9WQXIWWWoC9JVvbTE271Qmj/IRrhCSwxCDjup9BLQUtYIEJkB3DgHOAle8
         XtkudakykSwSspQAmVOk4SoNz8fY4N8BruLwZtA1YetSDShqd7ZqFlPDWlPpIXmHKb5+
         mO+A==
X-Gm-Message-State: AOAM53125vCbvcmNTzj5dyPLPHabt1UaYooeH47sRpSsCenHJgbmPEcN
        By0hTmLotgwaaa7SMmbkjJXdYro+oaA=
X-Google-Smtp-Source: ABdhPJyR9/fdNiRPhxrZzkdXH7T1uATs09X8c4/hJiN89SB3JEmCg1rr6cfyZFCkcMjrZMghlHfrJlRlaEc=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
 (user=seanjc job=sendgmr) by 2002:a25:67d6:: with SMTP id b205mr1035523ybc.394.1612998417404;
 Wed, 10 Feb 2021 15:06:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 10 Feb 2021 15:06:21 -0800
In-Reply-To: <20210210230625.550939-1-seanjc@google.com>
Message-Id: <20210210230625.550939-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 11/15] KVM: selftests: Create VM with adjusted number of guest
 pages for perf tests
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

Use the already computed guest_num_pages when creating the so called
extra VM pages for a perf test, and add a comment explaining why the
pages are allocated as extra pages.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/perf_test_util.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 982a86c8eeaa..9b0cfdf10772 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -71,9 +71,12 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	TEST_ASSERT(vcpu_memory_bytes % pta->guest_page_size == 0,
 		    "Guest memory size is not guest page size aligned.");
 
-	vm = vm_create_with_vcpus(mode, vcpus,
-				  (vcpus * vcpu_memory_bytes) / pta->guest_page_size,
-				  0, guest_code, NULL);
+	/*
+	 * Pass guest_num_pages to populate the page tables for test memory.
+	 * The memory is also added to memslot 0, but that's a benign side
+	 * effect as KVM allows aliasing HVAs in memslots.
+	 */
+	vm = vm_create_with_vcpus(mode, vcpus, 0, guest_num_pages, guest_code, NULL);
 	pta->vm = vm;
 
 	/*
-- 
2.30.0.478.g8a0d178c01-goog

