Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1BF2306CE
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 11:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgG1JpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 05:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728545AbgG1JpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 05:45:19 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D6DC061794;
        Tue, 28 Jul 2020 02:45:19 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j19so11546407pgm.11;
        Tue, 28 Jul 2020 02:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ll8WCmZeOpOBPrLRP/0beycTFEf8dKZrUNMUWQ1/JDQ=;
        b=Bd+wINYDCUP8z22guocQAcON4oKrYDx2CgIgsz8nnitTQlq2y+JXpZ6GN/+kc010po
         POfHgEHzAud6glM01h6FgHQ98/JBoLPT2C+XcK64WAs0bZD9vSN4AoGJLvo/EBpvV/Ud
         4AJjxLQPJyLxy9N0ZZ0Kve1ciIIsmicpsinl04IVkDxW0KLwFH6FIWf/RydET4VW+kkJ
         BueZlIgfCf1i6gAdX8sGoXbW8d6yXcqaCtr2CHmmkvbgS08rCMuARrAufwEmAw11eWA3
         WpVTGBRbACsS1CrK+7xHJ19nt1guaMn1CS8qkrAuQh0ysVfSfUogVp2drqcDnxttXl4l
         paig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ll8WCmZeOpOBPrLRP/0beycTFEf8dKZrUNMUWQ1/JDQ=;
        b=hq8BOZRyaGh0dq6JxHPwKlHtKusesrjSouwaIn72jDhhLk1h8HDsDZ85Lb6mdE+Ps/
         qYxFS+C7HRzcewzRIVZJ2ANEm50o2bBPS51V/erajWiZu1rACOcX19xoHA4JU25E3Jlq
         +JjfiuJOGoNIR1b1jT82ZQJUbB1YkhoDLQTd3R+HtNESz7zW6jS3jZer9BNxJzoNXUT1
         efoUXu3/xBa13xGqw8EHYXcDZIrM+1+30Uwi5uk47ZKqFtsrNoP35BCMT+YXzxnHhjp/
         nDRf6FT1czGSZGjWBJblgBhabA3gANh8ELowjSpiJmhJLFbfZCAVaXfApybvOXYzxLpN
         pNKQ==
X-Gm-Message-State: AOAM533hZfKHa0zlBsKvUaFOKEwOROe9osKJzwGfZAcEM63QYPWygHaC
        wlyBn8OqFz4jpH1OpnXv04oFCUVE
X-Google-Smtp-Source: ABdhPJzX4644pR5SThaJH2dX56DH72ENkeS4mx1iIiB2Au6Z2mLpx1MuGv3yo3As09M/O5xzIOYpOQ==
X-Received: by 2002:a62:88d4:: with SMTP id l203mr23287682pfd.205.1595929518202;
        Tue, 28 Jul 2020 02:45:18 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id r17sm17969173pfg.62.2020.07.28.02.45.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 02:45:17 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 2/3] KVM: LAPIC: Set the APIC_TDCR settable bits
Date:   Tue, 28 Jul 2020 17:45:05 +0800
Message-Id: <1595929506-9203-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595929506-9203-1-git-send-email-wanpengli@tencent.com>
References: <1595929506-9203-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

It is a little different between Intel and AMD, Intel's bit 2
is 0 and AMD is reserved. On bare-metal, Intel will refuse to set
APIC_TDCR once bits except 0, 1, 3 are setting, however, AMD will
accept bits 0, 1, 3 and ignore other bits setting as patch does.
Before the patch, we can get back anything what we set to the
APIC_TDCR, this patch improves it.

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

