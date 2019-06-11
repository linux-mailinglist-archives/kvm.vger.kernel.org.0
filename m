Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78703CAEF
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 14:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390305AbfFKMR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 08:17:29 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45434 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387814AbfFKMR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 08:17:26 -0400
Received: by mail-pf1-f194.google.com with SMTP id s11so7314925pfm.12;
        Tue, 11 Jun 2019 05:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C85xdLoYButUPajJYZit35xlgLlMDLoD1qAApOa6BQQ=;
        b=UCjxVbrc2tjXQ9WJjYfs1+fB8TWMh9eFrpuYaSJvgT4csH64ottA07RVxknP66eyYR
         pLo7/MJRgPXgIHWmglJyXh+yDfzQxSaAO+fINxbbn7kADkdkGFQbluuG1YmizUCbZjyz
         hBu/oMo350ZPdULEl4NlTYSImkAQc8ogideI10zT7G8nEIjN9kltHRK6Dxa4GZ1zZ4lH
         89a+a0pAQ1HN7dtltAJOj84jVAdd1NfBQoNHfqOCk6KRJVFbmwKW/a/2lNNlHRGz7t7S
         CW/bC1cimoK+oGE3Kkf94qEF0vxCzaL9ikhkgiApWy9ONIJxLmIJ9mkfaCMxHyDc0rXF
         8jRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C85xdLoYButUPajJYZit35xlgLlMDLoD1qAApOa6BQQ=;
        b=LnCp+IOyyhIrHj4tHAIOFfI2q9Cs1PsoZW/7H3iPvl2MibbQa+Cfwn9EO2IOqgINec
         SDbkHpfgLmeQdrsUCiXBgkgEO8PydTLLtHQoYwDLhDslUpj6rnwXdLuLeM3TdWD07gJw
         Ml56G0LfM1U40V3EVOOJy8iPMOHqhN6TwLlSTSwMYrDJOkZEJjvy/9MtJp+aiBNA6mH5
         9lRaS0Jg/Wli0wlOTZDbcSYsEhFre4n6fMQaqsuHMtppxZQXb4ZNRBpqrlEQMSyyQHVT
         +BwAByweH4YTK5NRkRJ4UMZozs43J3EqwkiO1FwbCxm4tYKr4ADOyiQUjuU/l6cPZOlY
         /8tg==
X-Gm-Message-State: APjAAAUBlT615x8dDz3lUGKNlwPiiYRVeuUtoWBSQa67Pvf7xfPPhw3I
        2fcldvF69jvbRTaqRhWVIGAEFDHK
X-Google-Smtp-Source: APXvYqxZpcvhn41T2+H67v0pF71TKx4D4jm06aNhF/Z6TCdp2QktYzTd/iyOfAnVHY4O8PQZj2ESFQ==
X-Received: by 2002:a62:2cc2:: with SMTP id s185mr78701453pfs.106.1560255445743;
        Tue, 11 Jun 2019 05:17:25 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id v4sm19649478pff.45.2019.06.11.05.17.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 11 Jun 2019 05:17:25 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v3 3/4] KVM: LAPIC: Ignore timer migration when lapic timer is injected by posted-interrupt
Date:   Tue, 11 Jun 2019 20:17:08 +0800
Message-Id: <1560255429-7105-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560255429-7105-1-git-send-email-wanpengli@tencent.com>
References: <1560255429-7105-1-git-send-email-wanpengli@tencent.com>
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
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 020599f..c21bab2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2532,7 +2532,8 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 {
 	struct hrtimer *timer;
 
-	if (!lapic_in_kernel(vcpu))
+	if (!lapic_in_kernel(vcpu) ||
+		posted_interrupt_inject_timer_enabled(vcpu))
 		return;
 
 	timer = &vcpu->arch.apic->lapic_timer.timer;
-- 
2.7.4

