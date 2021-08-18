Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A726C3F0D54
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 23:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbhHRVaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 17:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhHRVaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 17:30:18 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2F6C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 14:29:43 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id o8-20020a0566021248b029058d0f91164eso2010898iou.1
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 14:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=r0FgUlCJu9+wIAf52h2bi1oS9KbPICUGE0YYTryeif4=;
        b=GGlQqDPl+00f6Sw7Ej0S+LP6MVGJpkd0Q6zAxuztEEw0vrQohIjWqGQtZaUDxPJmBM
         liFqt/gLOvHtLDd3mhe+QH4v24BGdhFnuF4aQUyAnx9fU/JAZjQ+ie+aGO/8dET0tNug
         5/bibVsZwTNmAszZouYcnULfpF/eTGM95aptt9UHk0trQ5h9sX0RfzPVdzEm9rqJU7lh
         jzEAfEMiRGTvGK4tI6rAunZip4C7M9te4LxqdiZ0mF8e7R/nWRl7dc5nu7QIAwNO/4RK
         qlRQ1++dsIzwypVhhXnuYXLG4Iii0HvJy21Jx4itlXOjU5k9POjUu0MSDLvtdc5+zpsQ
         0V0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=r0FgUlCJu9+wIAf52h2bi1oS9KbPICUGE0YYTryeif4=;
        b=no4kA2BPRKbkOW2HnJjX1sVNVHl75nvMDa2suiKycK/RF3JhjmcM8lPTXFOegp/H8z
         hGh8rHb3yM6vT9SiVB6oYBUkuVH9i6zO4P6Y2e47weWj4dabDcCS2Lr9unrQXb22b45G
         Azgw5mAEI7jp3IIT02G+WuVapMtWvZHacDrNZASo96gymHsveNZZhSuROSLiUutWkFIf
         BEXLapi+rkpH0QQtclRboH7J6hoEgwa9iUmDJvVlhmQEqhJvRhizSlQYFGZOF3JuuM/P
         dXyR6T8aF+TsWwwAArVdM4coVVQT5+AFzjr84kKzNQ9J/+axKNnzy9q2sxqHuGUL7sQd
         ivLg==
X-Gm-Message-State: AOAM531nqLPSDRV2B83jUZjjtkHsS46M+H6jOK6PFfOeKdwXG51lgcNa
        rMnbmUW/H/UA7a/3p/D3mv/lixO5IhZK+Nlt3L+iuFrPf17/GT2mVfadSiUk6o+etmO0h/LHm7O
        IjrUBfFf5lzQk99HwQV+8asqeZdZdcjw8/1AbuYh05dkcBKenaTeCJrM3+w==
X-Google-Smtp-Source: ABdhPJz3u9ty537z/NPYa/tLv11Wq28UhMlKAPaNZSneh5bzjU0yVDovnyinmUVLtziNrE8PCJFBj/VpU1g=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:860d:: with SMTP id e13mr9986329jai.12.1629322182458;
 Wed, 18 Aug 2021 14:29:42 -0700 (PDT)
Date:   Wed, 18 Aug 2021 21:29:40 +0000
Message-Id: <20210818212940.1382549-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH] selftests: KVM: Gracefully handle missing vCPU features
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An error of ENOENT for the KVM_ARM_VCPU_INIT ioctl indicates that one of
the requested feature flags is not supported by the kernel/hardware.
Detect the case when KVM doesn't support the requested features and skip
the test rather than failing it.

Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
Applies to 5.14-rc6. Tested by running all selftests on an Ampere Mt.
Jade system.

 .../testing/selftests/kvm/lib/aarch64/processor.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 632b74d6b3ca..b1064a0c5e62 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -216,6 +216,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
 {
 	struct kvm_vcpu_init default_init = { .target = -1, };
 	uint64_t sctlr_el1, tcr_el1;
+	int ret;
 
 	if (!init)
 		init = &default_init;
@@ -226,7 +227,19 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
 		init->target = preferred.target;
 	}
 
-	vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_INIT, init);
+	ret = _vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_INIT, init);
+
+	/*
+	 * Missing kernel feature support should result in skipping the test,
+	 * not failing it.
+	 */
+	if (ret && errno == ENOENT) {
+		print_skip("requested vCPU features not supported; skipping test.");
+		exit(KSFT_SKIP);
+	}
+
+	TEST_ASSERT(!ret, "KVM_ARM_VCPU_INIT failed, rc: %i errno: %i (%s)",
+		    ret, errno, strerror(errno));
 
 	/*
 	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
-- 
2.33.0.rc1.237.g0d66db33f3-goog

