Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186D53EF5FB
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 01:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbhHQXFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 19:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhHQXFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 19:05:47 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF666C061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 16:05:13 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id g73-20020a379d4c000000b003d3ed03ca28so354338qke.23
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 16:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=wtPaX/NHC5Mpryef7m96Oa+iTfpfFBvwLbz1OM3nn/s=;
        b=oUJIJvgjjQGZ5ilghQs64+a1X/LewAieJU9IMGTHKnEoi2qTaga6BgqgFiH3pLg/5Z
         2m4bq+A9EWU3KTFMvFkcEACNkqjDO01p4S20SJIsMnyQP82m6KVYOPpKbS+d7e1uUilG
         /UyHHnw6kRKSikTYJPW2qFPddqaUm9KFxmXO7ETNhZCVfGjcI7UvfuSVUPGK+aStbEKD
         x4JCfIseB4oHnRBR5g0jzpZCmiyMrChQ8Ur7LFlEVho3KXc8rB7EzYu7/tx+noiNIQo8
         vxqK/7QBERcZwXVDiLhMqHUAPu1GjXhFGOWza8Nvfd09MnoMC14BMQ1wkFhzb/h9NxfE
         uMEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=wtPaX/NHC5Mpryef7m96Oa+iTfpfFBvwLbz1OM3nn/s=;
        b=E4/E62ZatVClWgSCmK3b3IEquRrFsup4eqnl0eh96gGmNFkJh0zJZA+E6mRg2YPqNv
         BJ4UoewGsWE792WkHX0Jw7h5u9aoEYWmJmM+ctoyHynOomJ42lHIcq1D9Pf/QVQ0lvvu
         7exGVXV6UcrdWgWCsJutc6aqW72Vh1RQSGK1P8J7qnzvF4BTr9FayOTnzx2vopyfUGWu
         RC1NqSIWSVmN89q5KBG81cmdqoMFjT5qPHY3AE7NevgBC750oYcuqrK3yq2T/t6tes07
         6E1Zz7ROCG4OzQDmVJLuH7Itev7hn85dIrMfuX1fYnh9Az3QXRR0PTdZKqaaqCBxo7sk
         rWyg==
X-Gm-Message-State: AOAM533g6DCX5dPpdeN7y7V7w/Njx9zsgG91L0UY01rkubaBFK7G6On7
        AAN1wHwIsAKxUFnPikz3AWFprzoMjZNc9qRR0L4zKbJGeI5L07Ew+T/rXXXRQLOJKs4YZ1tIhWu
        HOpns9P/U3XZ/8Vb7+UFHdI/XJv+OzAChWbiTDTbjpRtl0hX0iDyM431tkE5/P+dVL/CJ1JM=
X-Google-Smtp-Source: ABdhPJwcAeJMKxlhvezXRvQwa22sZtQmlu0Fp0egn6e+eFz0fN06nsQjp1IifDOoteJKBKWpUUjEj+Pmxcyr6qDBsA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:ad4:500d:: with SMTP id
 s13mr5689691qvo.40.1629241512959; Tue, 17 Aug 2021 16:05:12 -0700 (PDT)
Date:   Tue, 17 Aug 2021 23:05:08 +0000
Message-Id: <20210817230508.142907-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH] KVM: stats: add stats to detect if vcpu is currently halted
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Cannon Matthews <cannonmatthews@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current guest/host/halt stats don't show when we are currently halting
well. If a guest halts for a long period of time they could appear
pathologically blocked but really it's the opposite there's nothing to
do.
Simply count the number of times we enter and leave the kvm_vcpu_block
function per vcpu, if they are unequal, then a VCPU is currently
halting.
The existing stats like halt_exits and halt_wakeups don't quite capture
this. The time spend halted and halt polling is reported eventually, but
not until we wakeup and resume. If a guest were to indefinitely halt one
of it's CPUs we would never know, it may simply appear blocked.

Original-by: Cannon Matthews <cannonmatthews@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 include/linux/kvm_host.h  | 4 +++-
 include/linux/kvm_types.h | 2 ++
 virt/kvm/kvm_main.c       | 2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d447b21cdd73..23d2e19af3ce 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1459,7 +1459,9 @@ struct _kvm_stats_desc {
 	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,	       \
 			HALT_POLL_HIST_COUNT),				       \
 	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,	       \
-			HALT_POLL_HIST_COUNT)
+			HALT_POLL_HIST_COUNT),				       \
+	STATS_DESC_COUNTER(VCPU_GENERIC, halt_block_starts),		       \
+	STATS_DESC_COUNTER(VCPU_GENERIC, halt_block_ends)
 
 extern struct dentry *kvm_debugfs_dir;
 
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index de7fb5f364d8..ea7d26017fa6 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -93,6 +93,8 @@ struct kvm_vcpu_stat_generic {
 	u64 halt_poll_success_hist[HALT_POLL_HIST_COUNT];
 	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
 	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
+	u64 halt_block_starts;
+	u64 halt_block_ends;
 };
 
 #define KVM_STATS_NAME_SIZE	48
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..5c3a21d2fbea 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3206,6 +3206,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	bool waited = false;
 	u64 block_ns;
 
+	++vcpu->stat.generic.halt_block_starts;
 	kvm_arch_vcpu_blocking(vcpu);
 
 	start = cur = poll_end = ktime_get();
@@ -3285,6 +3286,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 
 	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
 	kvm_arch_vcpu_block_finish(vcpu);
+	++vcpu->stat.generic.halt_block_ends;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_block);
 

base-commit: a3e0b8bd99ab098514bde2434301fa6fde040da2
-- 
2.33.0.rc1.237.g0d66db33f3-goog

