Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC993ECC01
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbhHPAN1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbhHPAN0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:13:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D95C061764
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b127-20020a25e485000000b005943f1efa05so5412946ybh.15
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QYCRxSU6hzRxEScdPZjEavlvSGqLDqGY95R82nilknU=;
        b=nPrPgAfdfNekGbCmGN2vEq+MyvMfwzlUHjKLDCtKxgS8K2/fHTzB2r4moPCptUD6eg
         5WWLr9m6Y5nHElPsYh4I+p/6d1611nEo0QJGGr+PRdF8iTApIzLk4fA1+UHlvxMtjfkE
         PpVnPyjufYcn1I11QAs6aaPOnKNa9rRFlfIhFu3yAIATOYzl3BSkOSqNnGdLNr3nH7Hw
         YOZGu29M8HAWwFl8SS3MavUWgxnyF7GuGmy+RyZ7ihZlSHfq8BDMqyI6mlBxCj1Wjskz
         pBU4/XcfXM84/5LFENjJjdg3s+rA7FLTgrAzw7OrpUjZDQH7wU+vpqsDYzuYfjxWOkmP
         GjHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QYCRxSU6hzRxEScdPZjEavlvSGqLDqGY95R82nilknU=;
        b=LaoKuTikkVAbG6XNJu+gauhcoKgbCPWMBHBqTg7ZS8LHctklI5OxC9Vy3oxD3KQSE7
         XPugr+f/RJNVV/oTofr7fUew1OlS7ST2NlbVKyNkbxVCkUSPNvvcowLWvZPAK+CI046B
         Spfn0P9t9ZARxm/bFb6w5AcXnRfchgvX1WS+S4UliOvheNF93nAadQ4svtyfCt3Ahgqn
         YXW7z/6pT9VTrpTfgmNsMlsHn/bX66bJ9WBM8WOQz6iOQlJPDg509otBbu/fBfWTW94r
         5umeJZMfm4vA9Dhh6E4jx/J7ERzH5FLFNkNta/5AmmLuaf6NMzmhAXXkjhgCvpGji81/
         9Tag==
X-Gm-Message-State: AOAM533CT6XLQzSiMDzhaXVrU/bqLNKomF5xo2mbF9zqOUqk58o+COWE
        JOFaxkAKOfckBvWtFu0neUWs5f2jY3PA7U/yFgNTIH/dSW8FY0K1RBDR5hCAZJPiQIRzoEVXDFR
        4Y8McrZVtM6L8sh3E23jvBI9H8AVVV0xSIQPMBiHPpgqAaOufdMWG5lJsoQ==
X-Google-Smtp-Source: ABdhPJyFSNI5zwQDtft85GbhMjZlrSiGF5KmrBvQv4f2CVXAK7KuRny2Z8kdgnXXItSvoMx7C3nhgmhqLYg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6902:102f:: with SMTP id
 x15mr17251492ybt.30.1629072775027; Sun, 15 Aug 2021 17:12:55 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:12:40 +0000
In-Reply-To: <20210816001246.3067312-1-oupton@google.com>
Message-Id: <20210816001246.3067312-4-oupton@google.com>
Mime-Version: 1.0
References: <20210816001246.3067312-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 3/9] selftests: KVM: Fix kvm device helper ioctl assertions
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_CREATE_DEVICE and KVM_{GET,SET}_DEVICE_ATTR ioctls are defined
to return a value of zero on success. As such, tighten the assertions in
the helper functions to only pass if the return code is zero.

Suggested-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 10a8ed691c66..0ffc2d39c80d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1984,7 +1984,7 @@ int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr)
 {
 	int ret = _kvm_device_check_attr(dev_fd, group, attr);
 
-	TEST_ASSERT(ret >= 0, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
+	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
 	return ret;
 }
 
@@ -2008,7 +2008,7 @@ int kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test)
 	ret = _kvm_create_device(vm, type, test, &fd);
 
 	if (!test) {
-		TEST_ASSERT(ret >= 0,
+		TEST_ASSERT(!ret,
 			    "KVM_CREATE_DEVICE IOCTL failed, rc: %i errno: %i", ret, errno);
 		return fd;
 	}
@@ -2036,7 +2036,7 @@ int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 {
 	int ret = _kvm_device_access(dev_fd, group, attr, val, write);
 
-	TEST_ASSERT(ret >= 0, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
+	TEST_ASSERT(!ret, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
 	return ret;
 }
 
-- 
2.33.0.rc1.237.g0d66db33f3-goog

