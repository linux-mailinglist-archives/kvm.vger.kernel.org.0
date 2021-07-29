Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BCD3DAA47
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 19:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhG2RdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 13:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbhG2RdO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 13:33:14 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7434C0613C1
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 10:33:10 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id 15-20020a0562140dcfb02902e558bb7a04so4284832qvt.10
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 10:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TH1Yvn79VJJ2udpoO34z2Zst9bnL7g3/15hMs2k9XrU=;
        b=RCcrGmTpe6zYpQ8AAlZ+gcpni5nA36NT5jhbrSl3vbAeWO6T12yCE0WZY0NqLb6qiy
         VF+Fj3BuutHCBqUYzErx+cj/MSmgq2BEOYPXjv5n/rWCGmxg3E4Lt5mSGA+Mv7PSg7Iz
         IpX1c4Lqs43XQxVCJPOqYGhD2F/mUer9TNikayLhKU3HfVB98aanqGxC2nA0+TMKPsnV
         6UATv2svEl1aHfHiKXMGZnSCrzAgFYJwjXxTXqLrU7weJZ3munj8CtOVknEHiajaqTPo
         z6eF+aweEk9vSymTy/fBzUkFqyYpWgxDnPucCJo+puhA7Q2SjGqnVvLr3xQE/cJCIBec
         e8bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TH1Yvn79VJJ2udpoO34z2Zst9bnL7g3/15hMs2k9XrU=;
        b=K3C3uIpmPCJnnjOJyt9ju5zhY5Qzk0o56XdprD9ec7fr1+P15MIedUkpYyW+kMkt4E
         x5kR9ZI5VVcTUBXv/0qMiygxm2nuMeSF9Q8AQivIQYSHQUQnV7lar4d2hBMN+Ii9PIqa
         HBAPIY6Tmw+0dDSlh49nwkpWVQb4bkVPzOmngC0hBgFPBq8gbZVfV6XIiDyIthZQ6X4A
         y4TV1jfPws4eDsUUYB5Dy2jUvtjHx4wFYQE2lC5F4CdCCiQnj6UxbAI8AUAdPzE6cia6
         ZLIY6AW8qORT3DJt+WfaaYhZtq5ksgqN75fTaWmbH13Ugtwfyi2PrcYcjs80NzrKO+iv
         zuaQ==
X-Gm-Message-State: AOAM530NtG5NzkoVf6sVku2xLmc4PSGzXbwij/VgpxbZtH0UB8d0//X8
        R8JGUk8HHEw//MUmnOUWDz4SVNMdmyK2vt6+761zuKFyhuq3ZP+gjoC9BMN+Tbml6QweNxXQrgM
        t81FTxYnu+w1zAKzbcfrkEDUIiEfduHo6W10T8rn1ZWNlxfUV5S/ubM+bzA==
X-Google-Smtp-Source: ABdhPJxJhaIODfs4vcnvGnNLiNAMEqLIdRVuYp2xpMYT1VyfNmqQolmbkLuOOKN177hNR/gEMr029wKo6dU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:84:: with SMTP id
 n4mr6508541qvr.4.1627579990026; Thu, 29 Jul 2021 10:33:10 -0700 (PDT)
Date:   Thu, 29 Jul 2021 17:32:53 +0000
In-Reply-To: <20210729173300.181775-1-oupton@google.com>
Message-Id: <20210729173300.181775-7-oupton@google.com>
Mime-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v5 06/13] selftests: KVM: Fix kvm device helper ioctl assertions
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
2.32.0.432.gabb21c7263-goog

