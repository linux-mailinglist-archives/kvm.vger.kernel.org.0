Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F727BF3A
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 13:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbfGaL1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 07:27:24 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42696 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfGaL1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 07:27:23 -0400
Received: by mail-pl1-f193.google.com with SMTP id ay6so30399978plb.9;
        Wed, 31 Jul 2019 04:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jyl7Q+fNfa4JowIqcItEgbQqxdMDKkuTAtedoCYt2UY=;
        b=rR8nivXt3VGb0fDD2orZENlGfFMWpJdAptZe46xvNyKt1xFErw1szWcxJ5+3aqK4e0
         FbinTes/wrEWvPX+g8ruWPjaFdy7hJVis8gDjaktFCvKPS+cnLdyUjBKWhBgf6TWv5yb
         fYprXUDjTROH2nXfaPvqXGX3y1nSZj3EP9U7LxQLsKcAs6/XnSJh1n1qxlBr4H/ag72f
         wmMG/bxWT5qb1P2gpjJFqxojI7LjW1GVjrfx+q/lz1CA9JWwLZySeCmEb5NDuKZ5xdL+
         oEE+KhfmBHswKTfz3M6PmnBaj8ZJ/2KOmDwpgjTY+olfhFVXSOleIa998TGVl2FZkdwG
         Xr+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jyl7Q+fNfa4JowIqcItEgbQqxdMDKkuTAtedoCYt2UY=;
        b=Y2kO5SA1lP7LcKoCvwLHC6q3Glo9+6xe09mGPebq9cguoVVFujB+8bmQMU8+oHRrpR
         xqPapRGxbW0iCexdR8Efj5kvJQd7H9fZAPBoaseD1Vwp5X/9KY9bS8E80hxC270gnQJP
         eKLP6exJpzrw2rXGkYQljhY7/mJToZTbyibhITviFhN4LoGk9J1AB58cQ6KUckxJX6r3
         U7SdhycvjNeCxDP8BSsnfc7VkM3ccRD2hpPjMo9Y80dU51/E2XUYQRq68RoOYw5Gjkdt
         S8Vm5Fhod3C8yR51AHIGP37LZ1bapQ6VytwvLCcwynKA7ACVaLmtXVKOLTfnMEFXm3Ak
         Pmyg==
X-Gm-Message-State: APjAAAUoYKqdkNCv1n3yVndtz4fckvEOx4qFyM0isWtlWBn/5ThtNo0B
        AzRgCEDpM+7x+LeIBbGOwbfFJV22AVU=
X-Google-Smtp-Source: APXvYqwYkfllzMYOfWgLQxB4pcShgB0fDQyELULrcRsAQRTCKlJ0kbPsYGxBPYDbNJ5BjxSACyTiwA==
X-Received: by 2002:a17:902:f216:: with SMTP id gn22mr117209690plb.118.1564572442981;
        Wed, 31 Jul 2019 04:27:22 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id e3sm1211441pgm.64.2019.07.31.04.27.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 31 Jul 2019 04:27:22 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 1/3] KVM: Don't need to wakeup vCPU twice afer timer fire
Date:   Wed, 31 Jul 2019 19:27:16 +0800
Message-Id: <1564572438-15518-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

kvm_set_pending_timer() will take care to wake up the sleeping vCPU which 
has pending timer, don't need to check this in apic_timer_expired() again.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0aa1586..685d17c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1548,7 +1548,6 @@ static void kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
 static void apic_timer_expired(struct kvm_lapic *apic)
 {
 	struct kvm_vcpu *vcpu = apic->vcpu;
-	struct swait_queue_head *q = &vcpu->wq;
 	struct kvm_timer *ktimer = &apic->lapic_timer;
 
 	if (atomic_read(&apic->lapic_timer.pending))
@@ -1566,13 +1565,6 @@ static void apic_timer_expired(struct kvm_lapic *apic)
 
 	atomic_inc(&apic->lapic_timer.pending);
 	kvm_set_pending_timer(vcpu);
-
-	/*
-	 * For x86, the atomic_inc() is serialized, thus
-	 * using swait_active() is safe.
-	 */
-	if (swait_active(q))
-		swake_up_one(q);
 }
 
 static void start_sw_tscdeadline(struct kvm_lapic *apic)
-- 
2.7.4

