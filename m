Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B366A3EFF92
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 10:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbhHRIvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 04:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhHRIvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 04:51:33 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40CAC061796
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 01:50:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s205-20020a252cd6000000b0059449776539so2064585ybs.22
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 01:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DspQEBuuNTP9Bq7Hjczs55/n66cjehtUP3MVQic92Uw=;
        b=d8YQgwF8kuiNURI/c1QYvU6zzDLbI6X3ENm5vQ2Km5NMelVr6e+EfpEnn4+5nDCbnA
         sBJy039P9fixXoQtw3D6Xys6fwAbDLRKT11qwbp9IhABvc2jCvgE5Ju3CelpTV5CH/9t
         U7AG6IwjHmpjjyzBR8BQeV1tzbgfUFaQiu0y374iezdAhNGfVK87yRvmBuMOoA3OtK09
         Ze/+8zhG1aBmpDoMQkK3sM6XntNmZ2XqvsJkuFOJiOElsrHI1XOufwYv4FgeC8Q/mLse
         GGuIJPLdK0jAQlFk7s1zh3XZGTPoqfGsVd8+Rqjg2d8vYS6702FhvtB+XHPNCYIz4PyF
         M3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DspQEBuuNTP9Bq7Hjczs55/n66cjehtUP3MVQic92Uw=;
        b=K3g4EszLe3/l+Uzns/cb7LZeFpbxSU3AHMH0hvSmNVFzn/905wAuQJTFL7pAgNZXEg
         36ClM1sZqSxwgUsB0F5z+atJ3KMNF0hWFY9yrQEVC/FmWJ4wA8lwIsMYtuR08hDWQFqT
         rDhZLHuW6m6Mc579wbX3Lb6OrbnaZ6x4Bby5iubBcy1983umStXmMqkNaOtMLRzO9slB
         HK550jv21FVnIFBOdyyS+K6reiTSMdNwnHVf5a3or4jD91jMrAjA9Pu1WL/Hh7CQPlv4
         FccTk+WDfMnGPU6AGz3BjT8CLx99GNqwS7FhdyYbpFkKa1Y8knwP10jE+XsjYoWq5hDr
         Sd4A==
X-Gm-Message-State: AOAM531tY1Ops3RIZUoGe1bg1ERq1qqMyldTnfmR9o16TNdRJn0NjDOf
        Ul5Fh4e6eVWb9ZSLN+Uwpt2A/BiO8VKSZYviDFIHsQeUSuqpoY8ZtOUzQbhpXJZUgNGXqUvE9xp
        kTWS1YLrDWbSt37fceN3xlVsaFF22MmrLFvQsQE3sRaLBU9pJeiOrI099iQ==
X-Google-Smtp-Source: ABdhPJz8bUl+O8hBODHIOgKlHWEgrJLWQc8EpGlIAkpoRfRXwfEhJfPc5yYBs4v3vq707g0eqs2ujbCAlxY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:7a03:: with SMTP id v3mr10801375ybc.202.1629276658180;
 Wed, 18 Aug 2021 01:50:58 -0700 (PDT)
Date:   Wed, 18 Aug 2021 08:50:45 +0000
In-Reply-To: <20210818085047.1005285-1-oupton@google.com>
Message-Id: <20210818085047.1005285-3-oupton@google.com>
Mime-Version: 1.0
References: <20210818085047.1005285-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 2/4] KVM: arm64: Handle PSCI resets before userspace touches
 vCPU state
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The CPU_ON PSCI call takes a payload that KVM uses to configure a
destination vCPU to run. This payload is non-architectural state and not
exposed through any existing UAPI. Effectively, we have a race between
CPU_ON and userspace saving/restoring a guest: if the target vCPU isn't
ran again before the VMM saves its state, the requested PC and context
ID are lost. When restored, the target vCPU will be runnable and start
executing at its old PC.

We can avoid this race by making sure the reset payload is serviced
before userspace can access a vCPU's state. This is, of course, a hairy
ugly hack. A benefit of such a hack, though, is that we've managed to
massage the reset state into the architected state, thereby making it
migratable without forcing userspace to play our game with a UAPI
addition.

Fixes: 358b28f09f0a ("arm/arm64: KVM: Allow a VCPU to fully reset itself")
Signed-off-by: Oliver Upton <oupton@google.com>
---
I really hate this, but my imagination is failing me on any other way to
cure the race without cluing in userspace. Any ideas?

 arch/arm64/kvm/arm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0de4b41c3706..6b124c29c663 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1216,6 +1216,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (copy_from_user(&reg, argp, sizeof(reg)))
 			break;
 
+		/*
+		 * ugly hack. We could owe a reset due to PSCI and not yet
+		 * serviced it. Prevent userspace from reading/writing state
+		 * that will be clobbered by the eventual handling of the reset
+		 * bit.
+		 */
+		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
+			kvm_reset_vcpu(vcpu);
+
 		if (ioctl == KVM_SET_ONE_REG)
 			r = kvm_arm_set_reg(vcpu, &reg);
 		else
-- 
2.33.0.rc1.237.g0d66db33f3-goog

