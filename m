Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F021A3DE00C
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 21:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhHBT20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 15:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhHBT2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 15:28:24 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DD2C06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 12:28:15 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id w19-20020ac87e930000b029025a2609eb04so10490210qtj.17
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 12:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=quVRBmXT16c8/+OvPaemt4sih+vYkJfmbVpHJfXSYSE=;
        b=JIWAzTD8mW/5i0lrePS1nmrHncrYMDBLUNta3fNF8Ym8CYZT1LUk485ozHVMBMDP3O
         QZrHPlUeWTuJF0oW+YnAumjLhjKHbXgy+pcl7q8c6osX3dCzZTpAjWjFcoNK9LoWBW0d
         Kqj87dr4gptUzqRPoLcm/S498Tbiqy2yQxKq48t2nLaQ9K9XyaXz2y+iqZVv9QEm1jPD
         Y5hI3hGYVSBEJzDRk15+/YPLJc2vTS5ZmzyLkBmRWgaOpuT7eps9fvzT6BBQjtHwKYON
         qQubl5pEdkRCv4fdLNsa0o7a8cWRy7YPFuAsNgjwl8cHNB+VLhFnxcNyWeYt8hzkt+C1
         R/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=quVRBmXT16c8/+OvPaemt4sih+vYkJfmbVpHJfXSYSE=;
        b=tIdcVqXwm3nOcEphgyxB2yjmoNB9v+uj6pE9MKu5FRDfufIDcjIpN0C6gaSqgXnnuJ
         8nWgCrWouiDS+Dm8V06APYDcItaS8nGqldAeg/bca0MMQnqfg9jcsnRvamgKZA7dq9fP
         xZfJYMSs3Op39GRZtZtLM/U8SJkeFtZq9iyUMoFgsyNDCJQfmDGQtkujhhm/l3Q6wIPL
         q60LqVW4/SexWL1I9nL5RPhieUYy/CGDKCSQnQ81FFAY6Akk7AbJXZ2IKYLcJ9Jt9lQI
         PSia7DawPWzhFb1ISva4RV4+dkDMUfaPusinAzcvEf3MLZxWdAUkFFovg7E5yYTTgHGD
         uy/A==
X-Gm-Message-State: AOAM532iBVZA6YC4YBK4llA5YMyPUhsu+w+YlL9pwoQI+eI9IyqlBGMG
        6lDyddM4wldm/pIzmkRDosdR4B8JaYQ=
X-Google-Smtp-Source: ABdhPJz1DQuSneO2f/+7Ncn9bFUKrFi6AUVYWFhFUwzGMFfXQ0w8T9ZZ7K0LwD0TDiocdSA4H4YvhPjht+k=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a0c:e508:: with SMTP id l8mr16364594qvm.41.1627932494378;
 Mon, 02 Aug 2021 12:28:14 -0700 (PDT)
Date:   Mon,  2 Aug 2021 19:28:07 +0000
In-Reply-To: <20210802192809.1851010-1-oupton@google.com>
Message-Id: <20210802192809.1851010-2-oupton@google.com>
Mime-Version: 1.0
References: <20210802192809.1851010-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3 1/3] KVM: arm64: Record number of signal exits as a vCPU stat
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

