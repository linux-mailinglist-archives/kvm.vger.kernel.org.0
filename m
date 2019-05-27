Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF702B244
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 12:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfE0Kea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 06:34:30 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43648 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbfE0Ke0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 06:34:26 -0400
Received: by mail-pf1-f194.google.com with SMTP id c6so9356532pfa.10;
        Mon, 27 May 2019 03:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i/suq6wlpwcJ3ogbpvRkyctj8x187X3vDma99VWceU4=;
        b=KM/wQeMtXxU5Vx49+QokFlUXZuaHcWVOERnaL+ZNQQ7Iua5QA+FLVFtlfKTucwFSlh
         Yib1TEkh0PHPfc0xVNRM/nfHs/b6biN6VItfQ7uYq2GDrHTJQaFNTdcV4Vmk1Vc3vA96
         JTGc5BDtmAbtYNOa8yNWaXLBroo8wMZYqWuExL+VdOqVdWYO6FCY7bFLvRYloKYpM2Sw
         yYHmPIa8voeA6mhRyJg3hg5FjMOGmv3m4UR4iC241+/SmnU2BYl/GcFglR9zv0RADYYa
         DpApbJDnXqHT4xBUn/YOeHTgMbOB7cjb6dzoZcswmGB3UN3EvZLz7vSZDVfx2EOs9vdS
         TI7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i/suq6wlpwcJ3ogbpvRkyctj8x187X3vDma99VWceU4=;
        b=OXybjskZre2ODLIC080s7VH8Q0cx7va/KzS3p19jiD7qZbKuuW978MIhKzw6tkNPOd
         ggKCOn9D0vCmoMNYtSt664b+NoZkbnVozR+3yK2u1gXY0uiXUpv0rwjXj32J+T9g0dKu
         y8gHKis8MVsknEQbagFz3IfIxPak8nMYUM7tauI/L1N1xF1oOAExZAOeVr3mOT4B6560
         HNzdpJIQn52Fqotyzc0Ph31dm/nQxnUxFAFqv3NjauXxvnTfyDuwheoEnG+ZCceLmHhW
         79Ck7WPvAySMf0L2sGG16KoqjB7dBmz1CD8fTPaB2N9+5K38hN5i7IIDpxQ+tCZZcD+l
         rhgA==
X-Gm-Message-State: APjAAAW+aLnjvLNN5ae6AuY5lanrSigcAvPTZUXMV2wp1XwhijaUeTk9
        Xlj6RM1253qH0duBf9VplhBrt2WF
X-Google-Smtp-Source: APXvYqzAT7QeHLGJyQ/o+5xUOpLK6bOYfK3aacI1sGN1vtBbJwsA7VWvShHuB+34piV9p8/IeVhlCw==
X-Received: by 2002:a63:6647:: with SMTP id a68mr107738296pgc.292.1558953265907;
        Mon, 27 May 2019 03:34:25 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id y16sm19216452pfo.133.2019.05.27.03.34.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 May 2019 03:34:25 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 3/3] KVM: X86: Expose PV_SCHED_YIELD CPUID feature bit to guest
Date:   Mon, 27 May 2019 18:34:15 +0800
Message-Id: <1558953255-9432-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558953255-9432-1-git-send-email-wanpengli@tencent.com>
References: <1558953255-9432-1-git-send-email-wanpengli@tencent.com>
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

