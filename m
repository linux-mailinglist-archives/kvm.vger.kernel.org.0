Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEA741CF2E
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 00:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347201AbhI2W0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 18:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346645AbhI2W0N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 18:26:13 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44E0C06161C
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 15:24:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 124-20020a251182000000b005a027223ed9so5373283ybr.13
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 15:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=AjG3h48lUDqMcNF5y3QM8CAqT3Fqmrpt/5QnIQUhhic=;
        b=O3REYc5rmf2cNAMKQTqwUvlRpx2z41eo5PfxvU+3Yts8q2KclEEXO2XG4WgF55Oj0B
         zvAufXorGchu2mUqlzAwID3iNzZQEDBdZKslM7FZghG1i6bqUr3Dyl+K/pFfirN+uzrB
         ES/dN5lzrCy7+3m6FH4+9vBXGHviADOWUwlJDBE4SybcVcYYdozb191ymUnViGo6+e3R
         WQ6WxrYpzshyyCwpOGEydOw3UXTvvsRS4VpIdNIq+zZiDNLwxMwRY1QNT01FxYSrg+pj
         oialJMAwHmcmXe4EMkybNhE9084x4rBn1qMNNndV17jqEQR71BF6HTKPJmn8sYHqbRW9
         M02g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=AjG3h48lUDqMcNF5y3QM8CAqT3Fqmrpt/5QnIQUhhic=;
        b=B5vj34VWIjXBsA5wxyYTbMidIHhjscs0Zok0Fh9xnXuYo3LzLnCYC/WoHKvkCyjZtx
         H115kzZ4P/neGVVjr0tkIDd3VVSY50z+7w9XLLcaoax1oZncCzX3SOD31FfniRqMpTjn
         zPLEGjO3zfJRfLASnyPTg53F2nZQxJYI6EcxUtLt6w7Meiyer/ysinrR2SfQo2ykrjrG
         TQktxuxaMOtxrAScGkJPl4Rowu7N61dPd227ihAmKjqg10qydF5D4rJt+YWL1vSxpTvd
         NSFU+3AfImQlI6yJmb6D0cOaqtcWVs4Loawds5xx1NwUuqWuffP0VlSWOYeLZNW5MaAx
         r3Ug==
X-Gm-Message-State: AOAM5323v3ulqoifgPxoCkoJZM8yZSR1VIWyJqKQZzOj7Vhe7ETiEqYN
        FLffqeVDO4XWEgm40X/iFu7xYnKwjK0=
X-Google-Smtp-Source: ABdhPJwS3mcbQ5Wz93dyHQNoZXilJv3XIXDCyp75qVpb+Ez5AMf6Zoy9kDPAjDpUz4mKae6SvMIDuSvuVPM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e777:43b7:f76f:da52])
 (user=seanjc job=sendgmr) by 2002:a25:59d5:: with SMTP id n204mr2599356ybb.189.1632954270932;
 Wed, 29 Sep 2021 15:24:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 29 Sep 2021 15:24:25 -0700
In-Reply-To: <20210929222426.1855730-1-seanjc@google.com>
Message-Id: <20210929222426.1855730-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210929222426.1855730-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 1/2] KVM: x86: Swap order of CPUID entry "index" vs.
 "significant flag" checks
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f3985126b746b3d59c9d@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check whether a CPUID entry's index is significant before checking for a
matching index to hack-a-fix an undefined behavior bug due to consuming
uninitialized data.  RESET/INIT emulation uses kvm_cpuid() to retrieve
CPUID.0x1, which does _not_ have a significant index, and fails to
initialize the dummy variable that doubles as EBX/ECX/EDX output _and_
ECX, a.k.a. index, input.

Practically speaking, it's _extremely_  unlikely any compiler will yield
code that causes problems, as the compiler would need to inline the
kvm_cpuid() call to detect the uninitialized data, and intentionally hose
the kernel, e.g. insert ud2, instead of simply ignoring the result of
the index comparison.

Although the sketchy "dummy" pattern was introduced in SVM by commit
66f7b72e1171 ("KVM: x86: Make register state after reset conform to
specification"), it wasn't actually broken until commit 7ff6c0350315
("KVM: x86: Remove stateful CPUID handling") arbitrarily swapped the
order of operations such that "index" was checked before the significant
flag.

Avoid consuming uninitialized data by reverting to checking the flag
before the index purely so that the fix can be easily backported; the
offending RESET/INIT code has been refactored, moved, and consolidated
from vendor code to common x86 since the bug was introduced.  A future
patch will directly address the bad RESET/INIT behavior.

The undefined behavior was detected by syzbot + KernelMemorySanitizer.

  BUG: KMSAN: uninit-value in cpuid_entry2_find arch/x86/kvm/cpuid.c:68
  BUG: KMSAN: uninit-value in kvm_find_cpuid_entry arch/x86/kvm/cpuid.c:1103
  BUG: KMSAN: uninit-value in kvm_cpuid+0x456/0x28f0 arch/x86/kvm/cpuid.c:1183
   cpuid_entry2_find arch/x86/kvm/cpuid.c:68 [inline]
   kvm_find_cpuid_entry arch/x86/kvm/cpuid.c:1103 [inline]
   kvm_cpuid+0x456/0x28f0 arch/x86/kvm/cpuid.c:1183
   kvm_vcpu_reset+0x13fb/0x1c20 arch/x86/kvm/x86.c:10885
   kvm_apic_accept_events+0x58f/0x8c0 arch/x86/kvm/lapic.c:2923
   vcpu_enter_guest+0xfd2/0x6d80 arch/x86/kvm/x86.c:9534
   vcpu_run+0x7f5/0x18d0 arch/x86/kvm/x86.c:9788
   kvm_arch_vcpu_ioctl_run+0x245b/0x2d10 arch/x86/kvm/x86.c:10020

  Local variable ----dummy@kvm_vcpu_reset created at:
   kvm_vcpu_reset+0x1fb/0x1c20 arch/x86/kvm/x86.c:10812
   kvm_apic_accept_events+0x58f/0x8c0 arch/x86/kvm/lapic.c:2923

Reported-by: syzbot+f3985126b746b3d59c9d@syzkaller.appspotmail.com
Reported-by: Alexander Potapenko <glider@google.com>
Fixes: 2a24be79b6b7 ("KVM: VMX: Set EDX at INIT with CPUID.0x1, Family-Model-Stepping")
Fixes: 7ff6c0350315 ("KVM: x86: Remove stateful CPUID handling")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a02a8b0408ff..2d70edb0f323 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -72,8 +72,8 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	for (i = 0; i < nent; i++) {
 		e = &entries[i];
 
-		if (e->function == function && (e->index == index ||
-		    !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
+		if (e->function == function &&
+		    (!(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) || e->index == index))
 			return e;
 	}
 
-- 
2.33.0.685.g46640cef36-goog

