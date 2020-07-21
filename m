Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612D5227BA7
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 11:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgGUJYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 05:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGUJYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 05:24:42 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EF5C061794;
        Tue, 21 Jul 2020 02:24:41 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u5so10453613pfn.7;
        Tue, 21 Jul 2020 02:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nCJ0wq1+iNIw82Rl5c0tpfz9VgbOLTbPvMTzVmJqTNI=;
        b=Ao56ZxaYpU6im+Me37kHpBMg7g3MdPOws9kUTJ42ld7wKg3qmsXiusthDnC2DURk+W
         14novEz0jLbWc48DXVvyrr36ptVHF0BKRi/MIxROyWCX3xgzqrXLHTmM8S/byB4Ax4ed
         v0d6R+BXxevNGBDsjNXayJQkL0Jkwwo3VADBkgng4HK2ZO7xMfBAgMM1uQJsPGQz4fyd
         lwaSz92L81F/E7Ty9SGPqBmY/z5kCtzVOkepfe1CjjWFWvbDsOR9l66qkB6TtyLTDpys
         xgbrLpYkKzTarlzMEa8GgOysOFXqQxyW4sh4fE1zCWwYU2timfs9lSbeMrqDw1jkSW/i
         SL2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nCJ0wq1+iNIw82Rl5c0tpfz9VgbOLTbPvMTzVmJqTNI=;
        b=sHNybMybcWcZN3A8/X+JagqhjVeDRu6ORwwktiv0L8bL2UBNp1RF8FZxbD+iytJBLM
         sF+xYLXU75CRermRAhvPlr9wQnkVJC4D6SLFAvaoKgZOTY+V3MxAY7H1xR95bcZm9AB6
         hMW9yVXU37V+EcgoGmMB6sIVJ3evlW1W6K1Gtb2uwqZUmQxrhAI32ptl+U3I9R863lml
         NzWsuFjeF44opUrNz5FXz9rKPoowmYPzjoHF+TcwWHSxPwGeLI6bH6M0QulOIwkaafrX
         hh+ujGRrJYzDT97r0HO01ZQIxv/o2B7qPyPtyInccv5q03Ztld7KMdvSXEOAdGmfRnBK
         e2dQ==
X-Gm-Message-State: AOAM530SslSwl39ARqe7P4CY0bd+FYfEMmp6y8elpq3mq022gJZlP5cQ
        iOZzik86++FNf83USrM54wy1m6sc
X-Google-Smtp-Source: ABdhPJxhQNBFSgIjZmbnWEGJNzFG3rBsfkcbCx4RCO1/lDF7jBAYo6N79YIjtTUSm3oQyKyZR8LQJg==
X-Received: by 2002:aa7:9630:: with SMTP id r16mr24209002pfg.144.1595323481310;
        Tue, 21 Jul 2020 02:24:41 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id l9sm2337685pjy.2.2020.07.21.02.24.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 02:24:40 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 2/2] KVM: LAPIC: Set the TDCR settable bits
Date:   Tue, 21 Jul 2020 17:24:28 +0800
Message-Id: <1595323468-4380-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595323468-4380-1-git-send-email-wanpengli@tencent.com>
References: <1595323468-4380-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Only bits 0, 1, and 3 are settable, others are reserved for APIC_TDCR. 
Let's record the settable value in the virtual apic page.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4ce2ddd..8f7a14d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2068,7 +2068,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	case APIC_TDCR: {
 		uint32_t old_divisor = apic->divide_count;
 
-		kvm_lapic_set_reg(apic, APIC_TDCR, val);
+		kvm_lapic_set_reg(apic, APIC_TDCR, val & 0xb);
 		update_divide_count(apic);
 		if (apic->divide_count != old_divisor &&
 				apic->lapic_timer.period) {
-- 
2.7.4

