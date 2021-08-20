Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E9A3F36D1
	for <lists+kvm@lfdr.de>; Sat, 21 Aug 2021 00:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240900AbhHTWvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 18:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240896AbhHTWvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 18:51:16 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F9DC0617AD
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 15:50:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f64-20020a2538430000b0290593bfc4b046so11044725yba.9
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 15:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Ut0lClAqKM9RGqTS5MESEM+F5WoPZRTQUckNTBRjTyg=;
        b=TA/KEkzCm9eGIgSQhw9KNiaLFa6mERWpjzl8Sm2LP0D8MHshBELhR9PNTUHRE29ifz
         mo90lRoRaNLAOUKwpDqprlo0/pMwtc5l0/AtaGDQuwQPp72yFVvsNL3ynlMO5kSBRj5m
         LzAltW2EylkOxsEkvhRVhVSBOVOdYc11dmbjDqZ/XhKiygxbSFOOyUayIR4kGClbFLgR
         /kFKufJdXalO6BD5koMO2tBk/9JBu0VO4U4stsueIYQrrElmsEUFhO7RIz6hEZLybaDq
         KKumExIW2OSfE2RbrTkormhrvk3570q+R6kLizKIzC3ltGy9bDIK5NfDidM6k/fKRiu/
         zAPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Ut0lClAqKM9RGqTS5MESEM+F5WoPZRTQUckNTBRjTyg=;
        b=DEo1ss8zUXaiDhMp4Ubn+Qnw+9O1r4DrRGcDzPCSIZZ7RnlIEHpyk/7NGmAUrbXI5P
         02D/0sHBe1ucoOFNplb8be5SbhgGxU+LaJynXYz5Q/grSxeOi+w9sqzJuzmkcwV4oZEJ
         2ML1AL029typ6Uaht9xPXlQrFvXmXMUkA3nz6PJDFQVKq4M7y6yvooUnsEfIJTVGFrYU
         YVJybDYlYe22U99cInTYnMRTR8AxfEx9oNmorDefzPTxSI4Nmzs+iNwoK65Zn7GnQSSc
         yKjwLxBKxiOl2iZNZ+vURVTTWMf5b6n/UTbjgVknxZiuNDIg47skbpWE+EO+FAyM9axi
         tA3g==
X-Gm-Message-State: AOAM531oZx/GDMD/ZGO9T/EjXflRdQJuvc/VtmCwunuV3HSHF+UD20cN
        aFp6LqK60lZTj8NZ/W7ntMYFFqJaE0I=
X-Google-Smtp-Source: ABdhPJx3Gy465odAHrKuwh+xxU3EOcrY9EoPkXADk8KHQbivIS4NsZANbgwhJ1nQlBB3M+0Hs3NCAAyvqg4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:f11d:a281:af9b:5de6])
 (user=seanjc job=sendgmr) by 2002:a25:acc4:: with SMTP id x4mr8790476ybd.376.1629499835531;
 Fri, 20 Aug 2021 15:50:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 20 Aug 2021 15:50:02 -0700
In-Reply-To: <20210820225002.310652-1-seanjc@google.com>
Message-Id: <20210820225002.310652-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210820225002.310652-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH v2 5/5] KVM: selftests: Remove __NR_userfaultfd syscall fallback
From:   Sean Christopherson <seanjc@google.com>
To:     Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Guo Ren <guoren@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
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
2.33.0.rc2.250.ged5fa647cd-goog

