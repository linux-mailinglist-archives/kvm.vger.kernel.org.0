Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4078F15A929
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 13:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBLM2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 07:28:54 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40291 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgBLM2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 07:28:54 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so2172242wmi.5;
        Wed, 12 Feb 2020 04:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=t4Q1OJdYjIIxxl8hiEppJFQjj2ZAX1Z78z3H6fI5ihw=;
        b=RUCBPiK0KzfTLbmBjqf58NyLqNYH8NtZ4mYkYKzY5lQu1o5xBjeGMK4pVCUodMm3c5
         AGq95P3KX2+llMuF/JbBEGqXbZspUek0Odh3FQSb42+fyn+MyNcyJzSg7Fm+SWtjrH8W
         AvcDfNPAYi1Z1wK8X2nEWVnQvJ+uNzFVJKAMUEWUHaPk2PfJtpPcMWvqWNr+EqbgH303
         VLMouazPFSKoWavfXIUxlKL7V44b1pukn32iLJul+kx/7ccUFFN7SP5dNyRCocE0u+yo
         2TBqdr/h7dLju9WUYy8oe7ErTNIGoXPvau+FW5Dnv9gsbwl7MLKUf6LbL0OUX9utcgmY
         OIXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=t4Q1OJdYjIIxxl8hiEppJFQjj2ZAX1Z78z3H6fI5ihw=;
        b=eGceuNU4JX1rbTUQfW0X6eEJYueNt39DkcD08foMi0/2YrZPtBWSayLH1T7+8CURPu
         WN8subWQO0FMepwPhFHTX1h8myO1en2ySFixzWJdrtReYkCnbp74MhQhOQRzJD5ikgGO
         Ya6lSMHlLEPCV4X2rzl5xKe9BEw4VMnaBBHBTd5QSd1uvBZbsxhIPbyqAOr9imEOk5gG
         tqtK/K0Ivjqo0ckdbpY0DHMp3eQyyXlpq3TbMkMt+xHbpuMjEmIac/x08MHqx9NiDAv3
         rceeAOmuISm50yFl6r8caSJjtZPm5evISoePiiZTmcbObh8NDR7e0CKMf1vRyOkVqrcR
         ECTQ==
X-Gm-Message-State: APjAAAUCK570NsXXCQkWZdExWx3XU2TQ5k014q6pBG7XIlr7zZ5joRQR
        ZLkJ4vHq2oigDw7MB/uupMn6kq8K
X-Google-Smtp-Source: APXvYqyzRtoVd0HNOXCQ12XYPRhWe0kHrAmc7+K+dCm+eaNdrx1pFvWCt6rcZIsMbwMR/JvCy3SMGA==
X-Received: by 2002:a1c:1b93:: with SMTP id b141mr13172375wmb.114.1581510531962;
        Wed, 12 Feb 2020 04:28:51 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 59sm522255wre.29.2020.02.12.04.28.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Feb 2020 04:28:50 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     colin.king@canonical.com, sean.j.christopherson@intel.com
Subject: [PATCH] KVM: x86: fix WARN_ON check of an unsigned less than zero
Date:   Wed, 12 Feb 2020 13:28:48 +0100
Message-Id: <1581510528-19303-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The check cpu->hv_clock.system_time < 0 is redundant since system_time
is a u64 and hence can never be less than zero.  But what was actually
meant is to check that the result is positive, since kernel_ns and
v->kvm->arch.kvmclock_offset are both s64.

Reported-by: Colin King <colin.king@canonical.com>
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Addresses-Coverity: ("Macro compares unsigned to 0")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 54e8142b15d0..359fcd395132 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2444,7 +2444,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
 	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
 	vcpu->last_guest_tsc = tsc_timestamp;
-	WARN_ON(vcpu->hv_clock.system_time < 0);
+	WARN_ON((s64)vcpu->hv_clock.system_time < 0);
 
 	/* If the host uses TSC clocksource, then it is stable */
 	pvclock_flags = 0;
-- 
1.8.3.1

