Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70463EF6AD
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbhHRANJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237273AbhHRANG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:13:06 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00C4C0617AE
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:12:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f3-20020a25cf030000b029055a2303fc2dso961193ybg.11
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=wc2+C6r6Lzc5JqLepnjKBoA3R/oqdnaY+wA2WFQYFmk=;
        b=jzEI2eyoLjuCiAckr9iQTqnFUXwzAh4Bi/ACxivwK6KOsY26ctm9j6orvh4F448pPb
         b8xexsGPPAIYpwhpqZpbmxtpFVoPnNsKXQISPtnNBm0/2ryyGFAMDsHQAPkvUeB2ltPx
         nIXoNCHbxHh6z06UUYfxKd42NrbnHGNigYvC5+elZGIC3Qjg5ghQQBat4Rx30JZFsRsa
         Lvu96COE1hCjQpq94rCM95+H6SGRURxQyBIC6xzLPq76Nc+SxV3gXU8GXnCkwxbvoTv1
         CXl1N4IeWINdS+i53o8pkiyjKWOUtFTjxnWmVwypp8QYBjwroTmp7dRVf29c3a4/VkuI
         f/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=wc2+C6r6Lzc5JqLepnjKBoA3R/oqdnaY+wA2WFQYFmk=;
        b=eFohKj25Pad4czzTwmIPd3B57RAelfqLyGL2szjwqJQC8yR6e6AkqYAW30N5dY8cg7
         Qaf1xHc6M7Wcn/7i+sZ09O19oKgROx2d15bg/DjZlzxspbN9BzPMgbE0zpQkn+RRqpwF
         HbvODPC8/msL/xS/PYO0GVHTHQZiZhfcJOlhCaaFYow1cxDrjRH+TiCRlxWiVwGxH07E
         crNB0Yu2vv5gnSwtYPFqNH0ggehBqcLu/pYzSitj2Lh+1HDGyoetpSD/uH0VJYBIR7pv
         IQz6oDk/H8DrOJxyjKlBIK6UDjbuIJs+F6oXH+YtDl39U34KyshqkiKA99M0CQ4rx6+9
         WntQ==
X-Gm-Message-State: AOAM531Ljj6k47BKbZR1s6PJpU+H5Vr4CT4DC0OBOToNPzUt2tSBMFhl
        YQ5F0zbE1OIOL58mtrwb3GxEhCZIqvg=
X-Google-Smtp-Source: ABdhPJw6f++95Q1JylrDXYmhiUqYl37K7vOLkaBu5Wdz0eJB64tcPEMCwyRm7Y5uUGuVcrpQtJ7YIbfkBgE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:158e:55a:74dd:5197])
 (user=seanjc job=sendgmr) by 2002:a25:3717:: with SMTP id e23mr1721295yba.66.1629245550144;
 Tue, 17 Aug 2021 17:12:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 17 Aug 2021 17:12:08 -0700
In-Reply-To: <20210818001210.4073390-1-seanjc@google.com>
Message-Id: <20210818001210.4073390-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210818001210.4073390-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 3/5] tools: Move x86 syscall number fallbacks to .../uapi/
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

Move unistd_{32,64}.h from x86/include/asm to x86/include/uapi/asm so
that tools/selftests that install kernel headers, e.g. KVM selftests, can
include non-uapi tools headers, e.g. to get 'struct list_head', without
effectively overriding the installed non-tool uapi headers.

Swapping KVM's search order, e.g. to search the kernel headers before
tool headers, is not a viable option as doing results in linux/type.h and
other core headers getting pulled from the kernel headers, which do not
have the kernel-internal typedefs that are used through tools, including
many files outside of selftests/kvm's control.

Prior to commit cec07f53c398 ("perf tools: Move syscall number fallbacks
from perf-sys.h to tools/arch/x86/include/asm/"), the handcoded numbers
were actual fallbacks, i.e. overriding unistd_{32,64}.h from the kernel
headers was unintentional.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/arch/x86/include/{ => uapi}/asm/unistd_32.h | 0
 tools/arch/x86/include/{ => uapi}/asm/unistd_64.h | 0
 2 files changed, 0 insertions(+), 0 deletions(-)
 rename tools/arch/x86/include/{ => uapi}/asm/unistd_32.h (100%)
 rename tools/arch/x86/include/{ => uapi}/asm/unistd_64.h (100%)

diff --git a/tools/arch/x86/include/asm/unistd_32.h b/tools/arch/x86/include/uapi/asm/unistd_32.h
similarity index 100%
rename from tools/arch/x86/include/asm/unistd_32.h
rename to tools/arch/x86/include/uapi/asm/unistd_32.h
diff --git a/tools/arch/x86/include/asm/unistd_64.h b/tools/arch/x86/include/uapi/asm/unistd_64.h
similarity index 100%
rename from tools/arch/x86/include/asm/unistd_64.h
rename to tools/arch/x86/include/uapi/asm/unistd_64.h
-- 
2.33.0.rc1.237.g0d66db33f3-goog

