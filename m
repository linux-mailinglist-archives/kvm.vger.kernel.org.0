Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB003DAEAB
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 00:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbhG2WJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 18:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbhG2WJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 18:09:30 -0400
Received: from mail-oi1-x249.google.com (mail-oi1-x249.google.com [IPv6:2607:f8b0:4864:20::249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AAFC061765
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 15:09:27 -0700 (PDT)
Received: by mail-oi1-x249.google.com with SMTP id m20-20020a0568080f14b029025a3cb2429bso3631652oiw.20
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 15:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=quVRBmXT16c8/+OvPaemt4sih+vYkJfmbVpHJfXSYSE=;
        b=ugW9I6GN7pWL34ADNzvmolXeBcl8BcWkp42bUMTI1HufksQY7hkq6QIre1ssegbcDK
         1HingL2dULatPpmnK4uTzlDTe5eHq4aIvslbmDd+0FZDk9o/YhXmqlRUHTKClJqtjIRx
         lO9lAb7lc0X/0//6WYsoJanHg5bq1N/NKju+D9SXdR0TnkG7bI2ZtwBRiaEWf6bOkRAb
         98/5vkebBq7V5Nz4THlbYao4dA+pzlZ/gHl/QwtbvjtosU+04rXIX/8S9Log9/7k7tkG
         h+Dzno/lXwqxLsTSydVwT48EpccvW4FnKhbvPPd1heziD9Z5v6dkZjVLzssvROFfgMNZ
         1Y1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=quVRBmXT16c8/+OvPaemt4sih+vYkJfmbVpHJfXSYSE=;
        b=EU56yBizb+8asvD/S3AAVFEouwG+J9t7RWHLsrt/41+ilsikIEhvy5OpaKz3tt9/6I
         8P35tp7XRWpOA4/B56zKT5WkbODAaZsz8jod5TT1H3pU56RIn4hQy4wcpjCtfEF6Bjzm
         DsuAx6RoaY6mavvF3y3XiziU1MEIRDJu7FSfzcknPD04CaeAcdRAQ+8nXtynl8mndlz/
         +FyA43zrlMBr9N5J49U4FfAbVC3RWgGkgTCQmIvk3ShB/sLsFK9k5JExxSlutors9uFM
         0VR7ypE1WKXRSbBx26BKtpbi6G4TBO+ejNF2CrjDGRKMWXNKKyzc/+fYGeMjIzJy0G7S
         Enbg==
X-Gm-Message-State: AOAM531v9CsXBlmOgTzDRYN/An8cMg9BDW51WUHln+a2xhxvC1dKyT/I
        ohasx1V/vves7uNAfBMHpV7Bl53JzL8=
X-Google-Smtp-Source: ABdhPJzcet3LHyvZdP4E+QC8YrDCMndlQCo3ftaMJDpvwe0sicb30CgU1kH3S2MUtZSb4XXEKENrpPs4SFs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:aca:bf84:: with SMTP id p126mr4508603oif.154.1627596566328;
 Thu, 29 Jul 2021 15:09:26 -0700 (PDT)
Date:   Thu, 29 Jul 2021 22:09:14 +0000
In-Reply-To: <20210729220916.1672875-1-oupton@google.com>
Message-Id: <20210729220916.1672875-2-oupton@google.com>
Mime-Version: 1.0
References: <20210729220916.1672875-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v2 1/3] KVM: arm64: Record number of signal exits as a vCPU stat
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Guangyu Shi <guangyus@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Most other architectures that implement KVM record a statistic
indicating the number of times a vCPU has exited due to a pending
signal. Add support for that stat to arm64.

Reviewed-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/arm.c              | 1 +
 arch/arm64/kvm/guest.c            | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 41911585ae0c..70e129f2b574 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -576,6 +576,7 @@ struct kvm_vcpu_stat {
 	u64 wfi_exit_stat;
 	u64 mmio_exit_user;
 	u64 mmio_exit_kernel;
+	u64 signal_exits;
 	u64 exits;
 };
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9a2b8f27792..60d0a546d7fd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -783,6 +783,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			run->exit_reason = KVM_EXIT_INTR;
+			++vcpu->stat.signal_exits;
 		}
 
 		/*
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 1dfb83578277..853d1e8d2e73 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -50,6 +50,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, wfi_exit_stat),
 	STATS_DESC_COUNTER(VCPU, mmio_exit_user),
 	STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
+	STATS_DESC_COUNTER(VCPU, signal_exits),
 	STATS_DESC_COUNTER(VCPU, exits)
 };
 static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
-- 
2.32.0.554.ge1b32706d8-goog

