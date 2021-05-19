Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF58389764
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 22:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhESUFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 16:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbhESUFP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 16:05:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F3EC061761
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 13:03:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id k34-20020a25b2a20000b02905149e86803eso4856899ybj.9
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 13:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rv0ERumOf71iShog8U1qPBT9mGKIDAJp7FTVCQRkzEM=;
        b=fjxm0c3dD1xUMPOH3FFURwgbNiEivz+zKgnGl4/ugh7HjstMXcxQ8bZUAehPznuLnj
         qEEvM0iUCnDrVQu+uQ/+GW7dj/lQBRbabhpF2qFdGEuQLtdhX04acaoxk9vruMAolv04
         lsGCLIoatDTljSrzUJBKcwpIhnje354lgZQ5Y9Y3ygPBlORSzKwR2d5MMxNsXJbh930v
         S4XCWQGhr7VQzFk/cSA0mh/MErqNXrih6lLO+2LsKRXj7QEUyHO/jIN2rjJRjnBhVRdD
         BFbe5UYtR+RdUnQ7mhaIHyn/nJgRkAbDbWb07xv/RCTZmAAQTG9hLBrFkZ1zHtfLfUuB
         PDGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rv0ERumOf71iShog8U1qPBT9mGKIDAJp7FTVCQRkzEM=;
        b=ANsvMXpSJN4YlryhEsQspQLQSrAwI8RpacalGyhuzHha2dSN801JyG2pEqob3ixz3R
         Eq26790l69HilkO2pDAJQAJDCGgwUPJOnKsew4xV8LQETxKVbJxoAJk2cXfSEjTcLNqe
         caqLIqiBKjKT+jbj9HwWhEhKueUPHfxMJ0kO6naXnV6vbV1TiHspvJrnEMgYuC7106re
         dpuuB32jg17/3s2/pDGgCky1hE4buIOQNhrmmH0YGpG0/7bLbA6fGY30F4NYlXogdB8l
         qMcWC4tLcuFGaY6BtFruVULPw+UZC2WAX3xhanPoef9ENUeSRElSYfHfX9pa4WY55lef
         wDhw==
X-Gm-Message-State: AOAM5303xzQD1gTUAwhFyAj/qZOutTMFBp0nmQ2HoWPAGZhw2k2zYA6O
        3zL1XUJ4YWGtYxEk0h2vwE8EhlkVofEmCzEvMmR9
X-Google-Smtp-Source: ABdhPJz5N3/pd5VJqKk4JxdwQ8jx0ixZaias40sAlDAIQl0ygf8hg+6TyhmnevLNUFsls+UpU62lIM4s8NmBtaMAzqZk
X-Received: from ajr0.svl.corp.google.com ([2620:15c:2cd:203:7eb5:10bb:834a:d5ec])
 (user=axelrasmussen job=sendgmr) by 2002:a25:6c85:: with SMTP id
 h127mr1798049ybc.460.1621454634548; Wed, 19 May 2021 13:03:54 -0700 (PDT)
Date:   Wed, 19 May 2021 13:03:32 -0700
In-Reply-To: <20210519200339.829146-1-axelrasmussen@google.com>
Message-Id: <20210519200339.829146-4-axelrasmussen@google.com>
Mime-Version: 1.0
References: <20210519200339.829146-1-axelrasmussen@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH v2 03/10] KVM: selftests: print a message when skipping KVM tests
From:   Axel Rasmussen <axelrasmussen@google.com>
To:     Aaron Lewis <aaronlewis@google.com>,
        Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Gardon <bgardon@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jacob Xu <jacobhxu@google.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously, if this check failed, we'd just exit quietly with no output.
This can be confusing, so print out a short message indicating why the
test is being skipped.

Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f05ca919cccb..0d6ddee429b9 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -53,8 +53,10 @@ int kvm_check_cap(long cap)
 	int kvm_fd;
 
 	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
-	if (kvm_fd < 0)
+	if (kvm_fd < 0) {
+		print_skip("KVM not available, errno: %d", errno);
 		exit(KSFT_SKIP);
+	}
 
 	ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
 	TEST_ASSERT(ret != -1, "KVM_CHECK_EXTENSION IOCTL failed,\n"
-- 
2.31.1.751.gd2f1c929bd-goog

