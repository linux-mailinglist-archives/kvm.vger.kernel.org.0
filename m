Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 840971FDE7
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 05:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbfEPDGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 23:06:34 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35677 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbfEPDGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 23:06:30 -0400
Received: by mail-pf1-f196.google.com with SMTP id t87so1036481pfa.2;
        Wed, 15 May 2019 20:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SwGzI5XfH1K4vXAfrjZTodx1XMnoUAT4N0Igdk71XCY=;
        b=CxCK8+hWXUC/IsZttM/3bc0OlKs2wOHmKNiQQVDA+rXljOvT9HmjNnpIlTby+T9ypA
         p4wJgF9iBHZf477hKUEELAoJptIOEcQqhEAuti/hXhXNpELDi00Ai8SwSaAPsSD1svdD
         5bbWuYXXw6nLzqV72ERgK7lNHfOt4AaReShmJU2Iz2yKRy/Bb53iCIQowQeezC1Py0vd
         lA77LOYZgcosRzQ1w3fxxL0+xgYOV9+0PRnbq1FvccrtnX9JP8x91l1J26EWhi4fTVZy
         8UTYrteBIYJCitMCoKQLMjyOvqQXsUtFkR1wsKtvsUkMFHU9jDtcioIcl7dAi/LSJK6u
         ARaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SwGzI5XfH1K4vXAfrjZTodx1XMnoUAT4N0Igdk71XCY=;
        b=BxykZxIgaTI4tiiJiGnpYAssoXqm+5Pw7YlKxYUBZZKwms4pX13mMXm+H0sOhSALjA
         Ibg0GwGMzHfy77xapXybtQEBb8e+23T9dWJTp+spNZoSw6vESDAgijvCEqPtx2OeFKKj
         T0ejTTROfHFwYEBAy5p0QABJPQux6XozBBk0KEXM+xqJJPwFKDyQE1WcL+0sRftmVxeb
         eTVPvJar6YB6cRYJXCjDvPfS0ettGOm44vvCVMxCaorhq7jARns7mv8PEVv2jqLXDPWz
         Dkk2myDmjgVTAbuV1IUlQaF+PC3lM+SYurroWC85mnuSwgm+aCy36fetangXgiYfHNxd
         pKlA==
X-Gm-Message-State: APjAAAXhmWdzCwTUVp2s8eE+VSI5aq0sOLZfu3aI2wyhE/Nwa8WuRX4C
        DjSZxfoytCYm4IrZPRHxxbDYPsZA
X-Google-Smtp-Source: APXvYqyQRbNYUpi6AM3QFqVjthzxMSwLs5tUPma0gt9fm3Qcg/xpDvVCfZjCz448TEeT9nqUonGldw==
X-Received: by 2002:a62:3605:: with SMTP id d5mr30017505pfa.28.1557975989597;
        Wed, 15 May 2019 20:06:29 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 204sm4247614pgh.50.2019.05.15.20.06.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 15 May 2019 20:06:29 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v3 2/5] KVM: LAPIC: Fix lapic_timer_advance_ns parameter overflow
Date:   Thu, 16 May 2019 11:06:17 +0800
Message-Id: <1557975980-9875-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557975980-9875-1-git-send-email-wanpengli@tencent.com>
References: <1557975980-9875-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

After commit c3941d9e0 (KVM: lapic: Allow user to disable adaptive tuning of
timer advancement), '-1' enables adaptive tuning starting from default
advancment of 1000ns. However, we should expose an int instead of an overflow
uint module parameter.

Before patch:

/sys/module/kvm/parameters/lapic_timer_advance_ns:4294967295

After patch:

/sys/module/kvm/parameters/lapic_timer_advance_ns:-1

Fixes: c3941d9e0 (KVM: lapic: Allow user to disable adaptive tuning of timer advancement)
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b63e7b0..f2e3847 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -143,7 +143,7 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
  * tuning, i.e. allows priveleged userspace to set an exact advancement time.
  */
 static int __read_mostly lapic_timer_advance_ns = -1;
-module_param(lapic_timer_advance_ns, uint, S_IRUGO | S_IWUSR);
+module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
 
 static bool __read_mostly vector_hashing = true;
 module_param(vector_hashing, bool, S_IRUGO);
-- 
2.7.4

