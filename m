Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B31B22C0B8
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 09:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbfE1H4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 03:56:47 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45685 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfE1H4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 03:56:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id w34so5804347pga.12;
        Tue, 28 May 2019 00:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i/suq6wlpwcJ3ogbpvRkyctj8x187X3vDma99VWceU4=;
        b=ECYqfw7gsUzl3sA/NMdyK82zPejq0iU0eFkiPFVAoME0Qa3iZzAwZNgvBuXJkmdANB
         c1xG8te3/3BcbDvLIdQwEuw3vO/W8Cb7R1MwBfUs2fLqFvKl3/ubr3/aS4/PcjQahdQg
         g6ZIide7yY0c4/NlSxHoYnryflJTZuCqc9I7vgLuNsb5gGsnvvJcugKVzwZPTbPap7ll
         2sXVDzGcaaVaGvzfsczAL9f7/UEoy4qWfn7Z3LvgNKzDXWtBxEOT/qdamNv5l9X5SY9X
         2+LbJ7KKndXocJxlSlwkd0YUcf/vtsC3f+pGQTxX7AHHk7Xgz8V45Hgc9SApTu98iqDS
         FemQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i/suq6wlpwcJ3ogbpvRkyctj8x187X3vDma99VWceU4=;
        b=kvA83/YRWTyQGGdJd/6/2DeAKLaoCNXmVokPzqitFyPrPQ1wL6fP/DkyyucImeZ7QO
         eg3BV/qIKpZ5gIigbQfKXFV9fLFXDxXj00AkEbLWydw950NbMgfSeA/sfshyL2ZWc0bp
         obmNaUkWiPDzhF48/afPBHQgCBVKZXkk852QB0CcUr7qU/9zpjSn6iwPz6Y4mpar1mUH
         tjPhfSMl60yJ3MbOwRNvzOBk7q12mtYAOEF+othPoZEjZO4C6mMw6JytSpnF6TyMsLMm
         gc+iEDPO4HFnvNq1A0AebFF3vezp+Q4K9Ez4IxYHEHZGQZV7OgYe4AHsEJouAf0ijV1o
         Qizw==
X-Gm-Message-State: APjAAAVyqNaPrtIaIwB3vI2rbrWQhzXNr8IKzJe4qSooY4pXlwmkON5n
        6Mo233sUOqkWDPuuXEUsQ5HqUy7M
X-Google-Smtp-Source: APXvYqzLwS6S67O6iGxhlvp+de+SklbtDAPQhSBt8APPY0ylnxElE1Ll524sT2mFjHjyUjXlhQH+Aw==
X-Received: by 2002:a65:4b88:: with SMTP id t8mr131708342pgq.374.1559030205498;
        Tue, 28 May 2019 00:56:45 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id t64sm2906920pjb.0.2019.05.28.00.56.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 28 May 2019 00:56:45 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH RESEND v2 3/3] KVM: X86: Expose PV_SCHED_YIELD CPUID feature bit to guest
Date:   Tue, 28 May 2019 15:56:35 +0800
Message-Id: <1559030195-2872-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559030195-2872-1-git-send-email-wanpengli@tencent.com>
References: <1559030195-2872-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Expose PV_SCHED_YIELD feature bit to guest, the guest can check this
feature bit before using paravirtualized sched yield.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 Documentation/virtual/kvm/cpuid.txt | 4 ++++
 arch/x86/kvm/cpuid.c                | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
index 97ca194..1c39683 100644
--- a/Documentation/virtual/kvm/cpuid.txt
+++ b/Documentation/virtual/kvm/cpuid.txt
@@ -66,6 +66,10 @@ KVM_FEATURE_PV_SEND_IPI            ||    11 || guest checks this feature bit
                                    ||       || before using paravirtualized
                                    ||       || send IPIs.
 ------------------------------------------------------------------------------
+KVM_FEATURE_PV_SHED_YIELD          ||    12 || guest checks this feature bit
+                                   ||       || before using paravirtualized
+                                   ||       || sched yield.
+------------------------------------------------------------------------------
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT ||    24 || host will warn if no guest-side
                                    ||       || per-cpu warps are expected in
                                    ||       || kvmclock.
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e18a9f9..c018fc8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -643,7 +643,8 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_PV_UNHALT) |
 			     (1 << KVM_FEATURE_PV_TLB_FLUSH) |
 			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
-			     (1 << KVM_FEATURE_PV_SEND_IPI);
+			     (1 << KVM_FEATURE_PV_SEND_IPI) |
+			     (1 << KVM_FEATURE_PV_SCHED_YIELD);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
-- 
2.7.4

