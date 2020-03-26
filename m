Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBFE1935CC
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 03:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgCZCUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 22:20:17 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:34980 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbgCZCUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 22:20:17 -0400
Received: by mail-pj1-f67.google.com with SMTP id g9so1805504pjp.0;
        Wed, 25 Mar 2020 19:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qDBMnluBEIKHHnYAEDKv+uJNUJGj8Te28Rln44SHO8E=;
        b=F1LxSMfimwN3imJWkTMpv1Ri55oBYP5f5KoUR6cLAlBzGPJ7PeGsjDP/ps2VHuexyk
         N1hgmnpHVwXNPv7gU5xMpmJ8N0APDSLOc12OUdtaOpWxNEMKrLpNA2fJ+oF9aF8oqL1Z
         DC8r7yDGm6mXPIOporC8Bb7e+kKM4Job5dMn+9pYU3G/gjeRFiCcvxsUbpw9nx+Oa+U4
         bc9lQSgKmMew7NSY0rd6PxTJ0BWkipCoJA3mHdQ2TBdeS3ndNIj/644nizmPJxZLWdPN
         nyYpp2YTC9vJ4/aIiRRaMkXthP7fIy06FBukde5WhwA5hBIUvkInfiqIZdFy5G5s83Fu
         m1UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qDBMnluBEIKHHnYAEDKv+uJNUJGj8Te28Rln44SHO8E=;
        b=gaPSxDUjgfZ54TtZxLjrPungrxBAFHVUodN+Ly3np9myaJXm9XsNMJVtEbid+luVxY
         Js2do5Ampc6XMR/oftQpu8x/ydlIjOt7fyMErsRoTFwbHNb9wm0w1S4GCzwne/lwsB+o
         mr7DSQi0lfo7+p8XIi3d1l8LnckLAwRrZG1rNJEs4AEz+MniPdN9BXRgClZm8XbZoDhv
         UtjxRqR0Yor+GGYvxnFLA2sISUKOPsQzl0Fd9IemRto1kTHjZ4F0r68BE0c+olJfvJ1e
         eCzw1RIuKF/8qRIJVmsQkzyMkGxVgllTKTl7Ocr4wv6wUWP7qM1VthQGaoUXID84zuQM
         o0fg==
X-Gm-Message-State: ANhLgQ0MwtYUKgQFrhp+c8vpXctQefao7QY8K6qTWLgWWnKYbTfgNOqZ
        SWOEQ/pq+USUidRFrWQM334T34c9
X-Google-Smtp-Source: ADFU+vsDOt+koJGV7OQZXsBtSoSJra3SJ5LO8pyMovhgNC5OYrs0HUtc61ROfkcpYLJHgnUt49SfZQ==
X-Received: by 2002:a17:902:70cb:: with SMTP id l11mr6118046plt.127.1585189216114;
        Wed, 25 Mar 2020 19:20:16 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id mq18sm452975pjb.6.2020.03.25.19.20.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 25 Mar 2020 19:20:15 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 1/3] KVM: X86: Delay read msr data iff writes ICR MSR
Date:   Thu, 26 Mar 2020 10:20:00 +0800
Message-Id: <1585189202-1708-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585189202-1708-1-git-send-email-wanpengli@tencent.com>
References: <1585189202-1708-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Delay read msr data until we identify guest accesses ICR MSR to avoid
to penalize all other MSR writes.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3156e25..9232b15 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1568,11 +1568,12 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
 enum exit_fastpath_completion handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 msr = kvm_rcx_read(vcpu);
-	u64 data = kvm_read_edx_eax(vcpu);
+	u64 data;
 	int ret = 0;
 
 	switch (msr) {
 	case APIC_BASE_MSR + (APIC_ICR >> 4):
+		data = kvm_read_edx_eax(vcpu);
 		ret = handle_fastpath_set_x2apic_icr_irqoff(vcpu, data);
 		break;
 	default:
-- 
2.7.4

