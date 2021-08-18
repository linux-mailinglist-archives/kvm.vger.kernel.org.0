Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE933EF6BB
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237411AbhHRANT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237004AbhHRANO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:13:14 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87241C0617AD
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:12:35 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id p21-20020ac846150000b02902982d999bfbso116529qtn.7
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=b+D2wYBAlQke3x9JmkHfnRLEolzYl7vtoLkPYastC9U=;
        b=SPf96yhVitla9fan3IPn+20/DnpTxFcV2rJEUslNb4wU2oCEHWEr0TqYuejQIpJC6o
         jNSlYG+qBG8JbfyX7VG4m902MAYzTMIKxE+J/MrcopqG+WhchVZGJ22ACD9otOp/g1MJ
         y8nklKpCoREBa48CLrIfCPmMdB2GYVCrgtlvmB4GKsIMsEqBcxosOyXpoGKbtYzFUxZP
         Mm1I083bv5z0TQY7dAZh75UyzcpU/oojg63UuFCwEtyUQLcR51nv2dL3CjfuKg5iKWol
         K+EQ3dmDwhxcBXzNf+59Mx+svVE9z+9may7ss8OC49FzSgAQttlvHK9DI1ILn8qo818b
         bPkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=b+D2wYBAlQke3x9JmkHfnRLEolzYl7vtoLkPYastC9U=;
        b=L8s2qo3DR6tu51o0MjArBmAm5Tl00qZM2mJ2PjhFkdKF8nF9Vo7XdcjByeZVvzPfKi
         VpsRmxdYqmQgZYyVBWmNsj4XWmMAwZtfJlHWD5tPigd6g2iHl3IFtZdCR5m82fUTgMw9
         Okdf2xW1bITFvQYYcDbK9rtiMHf8Qw40mFz0bKz9YZgyKRd1i7uwzqctk2e24HnZzXk1
         44Zz0hUWtaoSWAa+J4Lc/Bo5YKzH6yYUuOit4EEdtJ0YpFF9s/FiFO5HZ3nYwq6vUrfg
         CKMbLLna1KwUtD5z48v9z5XierHcXVn1bUCQeHc36ertNCqanar8b5ltoJFbyo6+FBLJ
         6hGA==
X-Gm-Message-State: AOAM530i4ghwBSXrgneUWzM0iTlMeOMNlDvZUnKwpE6sPsVr+ODjXWO2
        mk2GG+D4PsjqVt7N1Zq4IJa66HKWca8=
X-Google-Smtp-Source: ABdhPJwjcybq5SY8/j4KCEcr/HLmkC+uHYVjqMZ/h+nMujuHcP7O+f1gmxV0bp94O0yeV50pIPXQ8l0qs8Q=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:158e:55a:74dd:5197])
 (user=seanjc job=sendgmr) by 2002:ad4:46cb:: with SMTP id g11mr6107577qvw.45.1629245554714;
 Tue, 17 Aug 2021 17:12:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 17 Aug 2021 17:12:10 -0700
In-Reply-To: <20210818001210.4073390-1-seanjc@google.com>
Message-Id: <20210818001210.4073390-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210818001210.4073390-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 5/5] KVM: selftests: Remove __NR_userfaultfd syscall fallback
From:   Sean Christopherson <seanjc@google.com>
To:     Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Guo Ren <guoren@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-csky@vger.kernel.org, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Peter Foley <pefoley@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Revert the __NR_userfaultfd syscall fallback added for KVM selftests now
that x86's unistd_{32,63}.h overrides are under uapi/ and thus not in
KVM sefltests' search path, i.e. now that KVM gets x86 syscall numbers
from the installed kernel headers.

No functional change intended.

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/arch/x86/include/uapi/asm/unistd_64.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/arch/x86/include/uapi/asm/unistd_64.h b/tools/arch/x86/include/uapi/asm/unistd_64.h
index 4205ed4158bf..cb52a3a8b8fc 100644
--- a/tools/arch/x86/include/uapi/asm/unistd_64.h
+++ b/tools/arch/x86/include/uapi/asm/unistd_64.h
@@ -1,7 +1,4 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __NR_userfaultfd
-#define __NR_userfaultfd 282
-#endif
 #ifndef __NR_perf_event_open
 # define __NR_perf_event_open 298
 #endif
-- 
2.33.0.rc1.237.g0d66db33f3-goog

