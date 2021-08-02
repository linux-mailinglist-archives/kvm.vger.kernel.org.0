Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490E13DE012
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 21:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhHBT22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 15:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbhHBT20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 15:28:26 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283D4C061760
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 12:28:16 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id h17-20020a92d0910000b029020269661e11so8883921ilh.13
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 12:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OUDEC1vqPr7sdUdf2B7zr2nu10+QX6s5o8FUl8jn128=;
        b=UGdnaf0Z5zkw/NSqrI8i5gZcNR0jvyngA3yzdo3qsADSiJEY6hBCd+mpE/zuWfHHRK
         1uu3eDJRyuFQ2ZFJORG7LWmLah5k/+OgglzudgvK4iTfUlNbWqThqIgSaY5vTYXHBOHe
         VSNGHmflOtl8HILOX35h8lv6KZ27Eg6gCVfW1TSSp6TuuN0kIBefed3k0k+pTHI93Ppj
         /YVEfDB/dDnXAWmDJXHRiBWcrGjzys2+pKWHoje00bxlY+OaXkMAzjZqwCsOcjlMqaYu
         sSnh4SFsoRSWsaWU93DH+gz+BGSC54rKvFG6GeqZJVeELDYvCIyKollPVH04QqV4NaTI
         88sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OUDEC1vqPr7sdUdf2B7zr2nu10+QX6s5o8FUl8jn128=;
        b=jwjoUdSOyrNHsGnvPjwpblWBffX5eXVXoD05cmqfnLpWATMtVOFEFBKmvc2p1OxIfZ
         3wTHuhizqOC3px+B5iwnd3kWh+HgIApVhmjigBTXy6jIQyZv5mZYepkxXM40yiJHvKwD
         c32XD5VV2VaiJA3EPPjdvbCRnGoFZ9V0JEethgDpkA1yMazzQVYZX+K8sJKS/IecYFQI
         l5zNvVu5XbuBIplH4niE2LVXrquhv5+pss3xZgcBANVcyjDah+ueJbq4Xxy/bgvUICuq
         TAS4Dq+9gpWo9Q79o6yZhdDepD3BQQ49QSeRphmv5ypRYrCaS3DMyR9AYkKqMg8iVf0F
         hsFQ==
X-Gm-Message-State: AOAM533UX6vDuSLxd5IYwWmi1/AdR3IMRZdDC/084WpdSdumFrCYLxKn
        E5GMX7rdBJzsvv1PP/Acl8Yn8+kTojY=
X-Google-Smtp-Source: ABdhPJw9BuQeA1J7hyFa/wKhd4oWSoC8qIUMN6Ku6i73EKILJHTfLU4lRZ39Qjqel47OyIbrpzh0uk5O0G4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:3404:: with SMTP id
 n4mr724981ioz.31.1627932495517; Mon, 02 Aug 2021 12:28:15 -0700 (PDT)
Date:   Mon,  2 Aug 2021 19:28:08 +0000
In-Reply-To: <20210802192809.1851010-1-oupton@google.com>
Message-Id: <20210802192809.1851010-3-oupton@google.com>
Mime-Version: 1.0
References: <20210802192809.1851010-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3 2/3] entry: KVM: Allow use of generic KVM entry w/o full
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

