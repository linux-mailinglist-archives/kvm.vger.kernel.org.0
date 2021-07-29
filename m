Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9BA3DAEAE
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 00:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbhG2WJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 18:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbhG2WJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 18:09:31 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A46C061765
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 15:09:28 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id x16-20020a9206100000b02902166568c213so3963378ilg.22
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 15:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OUDEC1vqPr7sdUdf2B7zr2nu10+QX6s5o8FUl8jn128=;
        b=afE61tmFlcKYV3syP0+ocrz06Dzk453aCfpsM5SdLvc9pXlbGValTdHId9+zvt7H+M
         wYkB0MblDqvsjNJQs3xi0hlRFhf5T2vW5CS2ZIv7ezpfpvzRtWEk9hygtiKge9mN1F9U
         WnKUVDYfMwPaMVDB778tT5OjBgssPZfqJsShDS+S+hY3M/4XbAe07rjzHqhnrsB3QOlh
         oDO1n0Hr+y+GJtvHFGUarcecAb9fZi4NVCmTTOKOsxmhlfSrIW1+GQ/kW8St9S68/pH6
         ZZ3P18M07QIcvNF07ClKQqYPgHfSkbBLFtoN8V027CGEypWH8yATHh6g3uqpDKBhxT3p
         U58w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OUDEC1vqPr7sdUdf2B7zr2nu10+QX6s5o8FUl8jn128=;
        b=QJrslypHw7mOMzriX3eu17TyD+ynnvnHCeHdI1Oop7ztkLCxgYDqfy3JLixBGhLagk
         AKjyuxNXIWIyiHS/9uMqG7P7vI1s+ZmLggsZOvkL9eH4z9JWE563nvGA11JQafLz63x3
         Y2hv0A0DoQ1BE7YBKinGUFuTFgwE4hIVCJojeQfnMjZlEMTQF2mb7OT5yOPzgztllFz3
         uB4QZk+YTARypzQp3EvgRVwQ7Z5j//g+HOnUj8nU2gdTT44tU0R66nkgoEhx8PtvvyfH
         ab9HkFSWc/ItedDwnvEaa8VYUYFqu6R02f/tG5TnQxssjGFXPkQrG+QV3Prw5NcafYU+
         OoiQ==
X-Gm-Message-State: AOAM5324RXLwo1bR4CaoZ00u/OrquicETKtKEz7GqygwIYX4amNPfSXm
        J+HjgQXtcbFIp1Em0psoWk/ybfQbX2E=
X-Google-Smtp-Source: ABdhPJynKEKZCh3Kk0HnLCvNi7Sc5MHDpzqm8Ql84cT0T630dSbB3HhwdbM09/xE2CFjkssQ6KG4bWN3Y/U=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:b058:: with SMTP id q24mr117122jah.88.1627596567382;
 Thu, 29 Jul 2021 15:09:27 -0700 (PDT)
Date:   Thu, 29 Jul 2021 22:09:15 +0000
In-Reply-To: <20210729220916.1672875-1-oupton@google.com>
Message-Id: <20210729220916.1672875-3-oupton@google.com>
Mime-Version: 1.0
References: <20210729220916.1672875-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v2 2/3] entry: KVM: Allow use of generic KVM entry w/o full
 generic support
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
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some architectures (e.g. arm64) have yet to adopt the generic entry
infrastructure. Despite that, it would be nice to use some common
plumbing for guest entry/exit handling. For example, KVM/arm64 currently
does not handle TIF_NOTIFY_PENDING correctly.

Allow use of only the generic KVM entry code by tightening up the
include list. No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 include/linux/entry-kvm.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
index 136b8d97d8c0..0d7865a0731c 100644
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-kvm.h
@@ -2,7 +2,11 @@
 #ifndef __LINUX_ENTRYKVM_H
 #define __LINUX_ENTRYKVM_H
 
-#include <linux/entry-common.h>
+#include <linux/static_call_types.h>
+#include <linux/tracehook.h>
+#include <linux/syscalls.h>
+#include <linux/seccomp.h>
+#include <linux/sched.h>
 #include <linux/tick.h>
 
 /* Transfer to guest mode work */
-- 
2.32.0.554.ge1b32706d8-goog

