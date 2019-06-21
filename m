Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1054E41B
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfFUJkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:40:21 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40654 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfFUJkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:40:19 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so3306145pfp.7;
        Fri, 21 Jun 2019 02:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ssaxVBt+HOJY4o+CcZ+fgzEAeEFqlrU5oDky1MfeR1M=;
        b=JlLciLFGVNmSPEBs57P33zbvteXJEkeu+WrbmyatPqD8Mg9AN+UqZA2g5FWmLR4Dyb
         Houb6v583jQlKk45alE6qTKaVl4Tb3r7W5uerz0PnvRmwrflTCK8uytJ0poonhntA1rO
         Dn1Nayq356GS2lCYztCe2aiMn/5GijTJNYNrVomSScfPR/w45f+S4tYpPbXHnVVUf0M3
         ctlu/muNpdWYFRHNC7zx6ScKlDiaA2ahZ73E7N0EogB0R5hBciRXNsPMt9e8JFhPUMSY
         dwid76yUq4Urec+KE3apkBjdIAbDB3kzxDvYM0kC85jyB+M5Tq9+Hk1u445QL9NkLA3r
         sObw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ssaxVBt+HOJY4o+CcZ+fgzEAeEFqlrU5oDky1MfeR1M=;
        b=AfaLg9S3MQkEVmIJyD88f97qyyjjs97j9ZKXdAc0CyRBK2RGEoJYqpSDqNZSqkhJqM
         WHnQmSgEzPce8m4vEXIjUgFqhY7aXrFn2MLSc5SoW2IMXGq2qMcxP69vfj0XQe2+s1oe
         W7L2u5dQvf0Q/mmQcyZRsGLTEkMc5YCuCCkNigdTNs4T3YSO6lN9AT8KuYhla0T0IS9E
         oyjJfhuC0Kgyad2JcEXX3QkD50IMIoCvJ6jO2EFwHO72NZH6T/0TcwhIkxDYPJwenpdx
         EW3AtV5ttx8DibJcimN1311SfLk68kttrMoG7kd7DiydEHNYmCPd/57WUu1mL/QvGozh
         me1A==
X-Gm-Message-State: APjAAAUZ+j8RlP/uq+U/8Q4oCIquDu7Lqq8hKg0XLJPeODyeydfqlzlD
        XN3C93mTS9MnQ16+YxdZOfagF3/H
X-Google-Smtp-Source: APXvYqwmZ13S/4DNBKZTJLsbvlfecUprbxubEC/r1spqJpjqv0ZEQyKq22ydotn+96NRSpJr9pd9Jw==
X-Received: by 2002:a17:90a:214e:: with SMTP id a72mr5610906pje.0.1561110018979;
        Fri, 21 Jun 2019 02:40:18 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id y14sm1999506pjr.13.2019.06.21.02.40.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 21 Jun 2019 02:40:18 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v5 3/4] KVM: LAPIC: Ignore timer migration when lapic timer is injected by pi
Date:   Fri, 21 Jun 2019 17:40:01 +0800
Message-Id: <1561110002-4438-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561110002-4438-1-git-send-email-wanpengli@tencent.com>
References: <1561110002-4438-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

When lapic timer is injected by posted-interrupt, the emulated timer is
offload to the housekeeping cpu. The timer interrupt will be delivered
properly, no need to migrate timer.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8869d30..ae575c0 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2522,7 +2522,8 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 {
 	struct hrtimer *timer;
 
-	if (!lapic_in_kernel(vcpu))
+	if (!lapic_in_kernel(vcpu) ||
+		posted_interrupt_inject_timer(vcpu))
 		return;
 
 	timer = &vcpu->arch.apic->lapic_timer.timer;
-- 
2.7.4

