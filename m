Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD2BA11EF11
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 01:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfLNAPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 19:15:31 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:50524 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfLNAPb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 19:15:31 -0500
Received: by mail-pf1-f201.google.com with SMTP id b8so2530823pfr.17
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 16:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jIKJ9N/ETJ338wl+brbYLGhW31otadw6BJugqRS16DQ=;
        b=aA+4fq0lue77AcufPjxvhCQO54vKV3+dfUe3EgeEgbMWFuE8KgYHDq/gmL82rN/2mJ
         wW0nyxTpdUGodeDVQOKSG2uwWUsdUDdbPC2JrWH4y2iXu30mKsStmF7K+O6qJaUMTmjU
         +ly0HfvaQF0rK7myU05EIsgM1XsyIPuWWC7ByvWfMGhpGvuWztkMZViIoR1Vrbhg9NSc
         kCYd7ZKrhHEZh4QEfIxDqwIAHGmKIZohcNjQgwq+baILg37I0WAq16f2mLaQEkQYm5wO
         5xbFI1XTjqPjLZPsfV3pu4qvV6pKU3OP/zTEM+GuhpcG7bWITpq1Ltrdx40Eg0+fBJAL
         qIfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jIKJ9N/ETJ338wl+brbYLGhW31otadw6BJugqRS16DQ=;
        b=PxZAiweJeulHixMQnDE7D8agLEjgNqE0issUa6qU5uITTcASQyFGRD/fYS8ZgvU2Ug
         i4AFUcqiE47yF2v7AwAMVuFwA7ZN4vAsk0T63bLdSLl6JysUVD7LhurC7+x79EqR1RNc
         PuFpRItu9ihYZ3Y55jGQ3WnhrfG0vfg1FIvk9Rspjf7sGpoXs5mmwUbyTgxR/ty2zVSG
         1yTo9mMVw03PLyhQB7fxOZ+LnR9UhDRTHaUAPrwugWDu4Jju0SPuLkikXmyH+QgK2fKx
         Em+sGg2aJ2HeLwN/nyRZbhKJZbKrpU9tA5LhaTIqnw56YuObVyARZLBudSdA4hdEFLVj
         P6DQ==
X-Gm-Message-State: APjAAAXg+f7BL+xkGoZQY16cfPIZn1E951Onvk+WQrwhd9jVCmxAAyV6
        oX2yWvY/ZCkrO8sEX6+6GLLiG+QEaGHLTxbyetBW0NRESDyfrg3fdpLTyvtFnDeGy+kDa7zEZnP
        Qm1FQwcPGGEGXCMptcNkV6lCVq5590z4T/62NZSUs3W6wyyvbrg0ZWGKd7GDEiB8=
X-Google-Smtp-Source: APXvYqxUurlJm4DTx6fgXV9C9qBuYZmq7iL7efzxu/qUB7OTyTGkXIh4dUcs4rtwWk+RVAhegRaM0mbUvQUb4w==
X-Received: by 2002:a63:3f47:: with SMTP id m68mr2497548pga.411.1576282530132;
 Fri, 13 Dec 2019 16:15:30 -0800 (PST)
Date:   Fri, 13 Dec 2019 16:15:16 -0800
In-Reply-To: <20191214001516.137526-1-jmattson@google.com>
Message-Id: <20191214001516.137526-2-jmattson@google.com>
Mime-Version: 1.0
References: <20191214001516.137526-1-jmattson@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH 2/2] kvm: x86: Host feature SSBD doesn't imply guest feature AMD_SSBD
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Jacob Xu <jacobhxu@google.com>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The host reports support for the synthetic feature X86_FEATURE_SSBD
when any of the three following hardware features are set:
  CPUID.(EAX=7,ECX=0):EDX.SSBD[bit 31]
  CPUID.80000008H:EBX.AMD_SSBD[bit 24]
  CPUID.80000008H:EBX.VIRT_SSBD[bit 25]

Either of the first two hardware features implies the existence of the
IA32_SPEC_CTRL MSR, but CPUID.80000008H:EBX.VIRT_SSBD[bit 25] does
not. Therefore, CPUID.80000008H:EBX.AMD_SSBD[bit 24] should only be
set in the guest if CPUID.(EAX=7,ECX=0):EDX.SSBD[bit 31] or
CPUID.80000008H:EBX.AMD_SSBD[bit 24] is set on the host.

Fixes: 4c6903a0f9d76 ("KVM: x86: fix reporting of AMD speculation bug CPUID leaf")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Jacob Xu <jacobhxu@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d70a08dec9b6..cf55629ff0ff 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -760,7 +760,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 			entry->ebx |= F(AMD_IBRS);
 		if (boot_cpu_has(X86_FEATURE_STIBP))
 			entry->ebx |= F(AMD_STIBP);
-		if (boot_cpu_has(X86_FEATURE_SSBD))
+		if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
+		    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 			entry->ebx |= F(AMD_SSBD);
 		if (!boot_cpu_has_bug(X86_BUG_SPEC_STORE_BYPASS))
 			entry->ebx |= F(AMD_SSB_NO);
-- 
2.24.1.735.g03f4e72817-goog

