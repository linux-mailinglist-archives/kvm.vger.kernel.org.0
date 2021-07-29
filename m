Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8272F3D99ED
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 02:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhG2AKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 20:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbhG2AKb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 20:10:31 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16DAC061757
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 17:10:28 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a6-20020a25ae060000b0290551bbd99700so4920102ybj.6
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 17:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gwBBXRuZJgGMnUfzRY6x/WPrbKiPq9hqFSq9KLAopho=;
        b=GRCbwCl8PRjXYJurNPHDvXlZjCsUWllU9vvI6WATIb0mSUd/TdccQava+A9dQ45Pl8
         PuoLb2SoHlHEms7T5ReImxkTSR08wqqKtvlC13zh7MDjRq9X6YhXEPgbQZ38xz1dpMog
         KTvCTQMpCoB/dJGQ3mkUHgS/iP1Gxc6L1jKRRwtoKT/ediSCO2xRalEfAk3eOG6uRDPC
         DIhKENGw6tKBpiJ62jTRce8kvWq5b4hK5ogpZkd1eeYm0gmRNJX5Jng+exV8KIHMrtIq
         kFupb+p4BmcY4OCiTBJcYZFe2sREJ2xGpsidyU88ooBd0/X4kYtBIlKnr08IO+RzUI2j
         0hMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gwBBXRuZJgGMnUfzRY6x/WPrbKiPq9hqFSq9KLAopho=;
        b=IwL05OHBP7xFBgRVDPAhc1Ry1b34dSwBg5/fpMW1UUUcICxYK64X5oOBFC+tKEPqS8
         EmKRr2caBoFxWsUWOgBlCF7YTGTqo+PaFkj3/ePpHs34tRXLpmk7LOelwNfQOHKvzr78
         lCOM5EugRAa8UtPiekSz+AcKN9NzHToszkLmwlZ6nOS4SRhTV02QkZHhQDth+6TekLfB
         uiGv6nP0NS/O3OIKqO1pqkHGu5BAucuqujCAE5VeCLPMshuCpKXjxOnuBy+pm85reavn
         4AIS/f4C0gG+EwQ9Rkh5fKEOsOJOuHTRwn75WnDRr7Dfz0piITl8ZuttovYmTu2NPEyk
         N3LA==
X-Gm-Message-State: AOAM532bCUjO7WZ4r7gL2LbKP4bPtsxfJShL40AKg5IvgkR9XbeZ9HCL
        Zu8fbIdMYtgs6oNlt0aKtKJjyzKudp/gHwlZttutTiSiQED3RpGuApGmHp9SY8HfTgwdZUcJw9J
        LtNkdNuUzZCDbYSH/3lZwGMErQx3SfQh70daLbnY2wfCQZfpC6M2mTLvm0g==
X-Google-Smtp-Source: ABdhPJyIry5dp830kQgdFAcw+/eO64Lwl1/0Oz/NR1ZKHIXmlq6VO06PUalR1WRBDiNnr+E7NteCfG8rS08=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:ba41:: with SMTP id z1mr3010352ybj.169.1627517427848;
 Wed, 28 Jul 2021 17:10:27 -0700 (PDT)
Date:   Thu, 29 Jul 2021 00:10:05 +0000
In-Reply-To: <20210729001012.70394-1-oupton@google.com>
Message-Id: <20210729001012.70394-7-oupton@google.com>
Mime-Version: 1.0
References: <20210729001012.70394-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v4 06/13] selftests: KVM: Fix kvm device helper ioctl assertions
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

