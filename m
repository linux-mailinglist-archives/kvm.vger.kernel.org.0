Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B346E60341
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 11:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfGEJlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 05:41:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41589 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbfGEJlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 05:41:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id q4so4060434pgj.8;
        Fri, 05 Jul 2019 02:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gErflyqehGD0sY8p/Fmz9ZhIWtAMGhTaOwLvVAXdYkQ=;
        b=oBd6ONFXQPL1sC/m7kSQNNC4AGu1AnVJHpUuLq1hj+Jx6Jze/Dc29bIvEylmTA7JLZ
         sslJWE8VclaRnWjs98KVbCeUWDmnJeKDnrvVignVkC17co4esfmHnQ+TnSMUVD2QHS8K
         kv5c/eguiFujpRFACPnJpQYY/TuS8Xo/XrD7VtLqI1et7w4tFaF0IMSyxhsVGSrILCak
         PLQxuX0sHT78Kbx4DMpSRAcxEP+Pmz7InIQL8vzTgYK6yr0DgkJV1ERGTGZlOQ5pnF8w
         /paUhE5nG4TV2j0W3zJZ0obPkC8qSIs1KF/bOpR3caUbsad1ZKBE7WTfJ57QphdkPtTh
         YHyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gErflyqehGD0sY8p/Fmz9ZhIWtAMGhTaOwLvVAXdYkQ=;
        b=mlVFw5PV0EynEIR6HOsHDmq6r1/GF/xeK0JF/P4AOqqVcyLYDPhfN4f48x/IUCbdND
         vD49rx882UosJY7nbBZoU+yrBMKmsWiIBoq3ZYNEOsSSFTwYD/tFp9tvyoqLIpOYv9RQ
         Cd7m8b8Dz/77DJGKnJeXHSJ1LxzV8ZKHDJxZTcn5c4QeglWT7CqjOEuIhd9AzB0Gmrb4
         QckIbbDblxW+cFqpIT4+2kMcHx/uV2A5GC2wg/jem2ijDVsHXJV/f2J+Ym1/TfTm4BFG
         AvQReZpXpMcEw1EnJg0mTEbOpt8l3B9XrkDDD9Xtvpyj1Q6Kuj+ozXQu4K4+BG4Y0/wQ
         cn9g==
X-Gm-Message-State: APjAAAVOU6m6g5a8wuUyuYMmRLRDW/pLREsiabvnU0N5waXfi/TNmqbD
        yIAmS8vEsw7m3d5i4iGHCEmTvQerxSg=
X-Google-Smtp-Source: APXvYqyEyy3haoucnzMEm3SvjxWvnWO7frvWk+0jC8LnlTLVN5QJBuxe6s3pUM46EV7SPaTeJ1BSRA==
X-Received: by 2002:a63:2326:: with SMTP id j38mr4384426pgj.134.1562319659550;
        Fri, 05 Jul 2019 02:40:59 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id i1sm11298877pjt.3.2019.07.05.02.40.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 05 Jul 2019 02:40:59 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH] KVM: LAPIC: Reset timer_advance_ns to 1000 after adaptive tuning goes insane
Date:   Fri,  5 Jul 2019 17:40:51 +0800
Message-Id: <1562319651-6992-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Reset timer_advance_ns to the default value 1000ns after adaptive tuning 
goes insane which can happen sporadically in product environment.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 05d8934..454d3dd 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1549,7 +1549,7 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 	if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
 		apic->lapic_timer.timer_advance_adjust_done = true;
 	if (unlikely(timer_advance_ns > 5000)) {
-		timer_advance_ns = 0;
+		timer_advance_ns = 1000;
 		apic->lapic_timer.timer_advance_adjust_done = true;
 	}
 	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
-- 
2.7.4

