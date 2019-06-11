Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E57F03CB27
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 14:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389125AbfFKMYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 08:24:07 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46803 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389014AbfFKMYC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 08:24:02 -0400
Received: by mail-pf1-f196.google.com with SMTP id 81so7326786pfy.13;
        Tue, 11 Jun 2019 05:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jpK78n7EuwzwuUYa9uLDGGpmavtbv1Fbssm0HIpkmiA=;
        b=V4KwM3GLF7HCRFJQBiPn0U0u3Yoq3BpbibnG1fmmwO4ZjhuKm5myUMGG1TFMWlClpo
         P8JMYHtkcGHvWtDoTgrA8Kyze2rcwUkcgE3vzogbTcBG9+oHJqZFcaQmEJ7mW4FgQLqU
         UpQkPWnK75g4Wx7sM9bBlItGeVBxl9U8IdYU53ZGmkl9eONwB88AwrvJ+/DegmNS+vnB
         z/zRVEO89+JJ4m1g4zo6hk779nyb1gWqbQ5OFGFoOR7NWRSSOAte30ANIc3H8yKJRKUu
         LrlqSgV6ngJ1MA/VMMQob1JnseU5xbbz0gpHBksces9aOZ95CWmmk/tcJ/faHr5Jx1Be
         ifeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jpK78n7EuwzwuUYa9uLDGGpmavtbv1Fbssm0HIpkmiA=;
        b=Z2qePusxNFkeu+gTgoq9Eb61TpE94riAzM2OuKYgnAFSIU0MvtOtShFBUv+nk6hQQ3
         x9kyZ9N3ORf2AFj3Lb5gLZHaA5WPl8VCAH/knYRcFBBy9Q3hOqm4U1Li9mjrezBwcwxa
         XVZvz9SRYOQ8vysDPIqIgkqq3ImPpJdpEs+0NL0jmQBAnUM88Th6HNLw0IEbHg7DcWbb
         eIOIlhujvwoNqwfCcrKJuD+sVh13jzaY5JU1m8RJeOqdIH1zhnrATuQ16sekmTYNf/F1
         6gx1ClfsQmpQymtSbZtpZqtKsnjPSjipdh9p6lHkH/1AOtDOKCTGvP40rD49Dd22LtDe
         gfuQ==
X-Gm-Message-State: APjAAAWi/jNICoS/2S0i9jRfoYHoM06F4SD1SKT6m0t1GNuGRzcII/8x
        iHEfPi6b2wOsw1be10KD2+X018/Q
X-Google-Smtp-Source: APXvYqwUCQThZamEpHtqoJvNjZFPGs7bzsmpbp1MOs9ez3BVKjK/e0lKZvGo0G0RX7J3ChoivEUPkA==
X-Received: by 2002:a65:4b88:: with SMTP id t8mr20722333pgq.374.1560255841015;
        Tue, 11 Jun 2019 05:24:01 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 127sm14832271pfc.159.2019.06.11.05.23.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 11 Jun 2019 05:24:00 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v4 3/3] KVM: X86: Expose PV_SCHED_YIELD CPUID feature bit to guest
Date:   Tue, 11 Jun 2019 20:23:50 +0800
Message-Id: <1560255830-8656-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560255830-8656-1-git-send-email-wanpengli@tencent.com>
References: <1560255830-8656-1-git-send-email-wanpengli@tencent.com>
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
Cc: Liran Alon <liran.alon@oracle.com>
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
index 60f87ba..38fc653 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -653,7 +653,8 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
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

