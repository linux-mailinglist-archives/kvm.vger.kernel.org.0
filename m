Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F673593B7
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 06:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhDIETB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 00:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhDIES7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 00:18:59 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69170C061761;
        Thu,  8 Apr 2021 21:18:47 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id l76so2926491pga.6;
        Thu, 08 Apr 2021 21:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MsqyvVn7YBppCO1Fy05Gz6niO5R1x3MO0z1PGcRbBxY=;
        b=EP/Sgod+jeOnf4VL9JfZDQ9Pr5uhtieaqoD05W2JaPAwKkIeH2TSS2/ICzmk11ixoJ
         Mp7kUIvVnHkdFGY2s1YFBw9X2KXTXtXgD156TFWRYtw3vxwGmxv+wNuNV2fMVqyFE7dL
         UgeE3duktk5Pv3DY5JZMIK/QTIX07PDZm4y1yFfYpQys12QZeCwJy2W08DYWxJnoR4wc
         +Hz/OSt+BTrwoz3T3MhvGKXiXBmkcwbfcbsixw8vROZ1hnvNzq+gJBmIxqMtf15Cr/Mp
         RXHo/zZ94Sw6SdFtkXiss3N8+rJajCGzwmTh9LtPav5y2nkAM9M5degZ9AS9Xy3Ws9SZ
         O6qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MsqyvVn7YBppCO1Fy05Gz6niO5R1x3MO0z1PGcRbBxY=;
        b=bu7TNJ+G2YCK5jjOiM9mFo6FCyO56Q/K7O8r/UpWEyH1B33WIO4YbXQLtagqohKRDp
         j2yuFnu4F4WG+1uFBbn4E6os+IMxTkynF5zQIX+0AZjaoPIkhd5e/M4XGs3F33s0ZoUo
         MK9fDv14F01P/JkHMrDYdIUm3WhX3qd9b7dKyqcTzKrKyn6Yqf4GP/nWqRgZ5gK/34K5
         0+Z6zk/YDRQKZxzMzYbC9+JcKGKfgf1cYV0lzDAY8nUKoNPCI7MeYEwHeMzcjxmlw/w9
         g1sI194nt0JmU5E3tAPMmxxiwe4zMFVs7riBQYVHvNRDq85DaFwToOUcMXd9So5CDJ41
         8scw==
X-Gm-Message-State: AOAM5323cgIfXPwd5+CEMEVXaCDaA43e7l8XfXYpI3ZZ6r9eW31ZFFpA
        JWPZcz+u853CGGgMPsmbEmT5A7DvuwY=
X-Google-Smtp-Source: ABdhPJw9hAF280dZWKgB4cI3JFgI/AtnKjbHPUMqQZF6H88Bfz7UmghVe0rFUZ/XIYFv5eyzIpnFVw==
X-Received: by 2002:a63:1a11:: with SMTP id a17mr10968569pga.371.1617941926840;
        Thu, 08 Apr 2021 21:18:46 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id gw24sm765553pjb.42.2021.04.08.21.18.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Apr 2021 21:18:46 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 3/3] KVM: X86: Do not yield to self
Date:   Fri,  9 Apr 2021 12:18:31 +0800
Message-Id: <1617941911-5338-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617941911-5338-1-git-send-email-wanpengli@tencent.com>
References: <1617941911-5338-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

If the target is self we do not need to yield, we can avoid malicious
guest to play this.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * update comments

 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f08e9b4..ce9a1d2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8231,6 +8231,10 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 	if (!target || !READ_ONCE(target->ready))
 		goto no_yield;
 
+	/* Ignore requests to yield to self */
+	if (vcpu == target)
+		goto no_yield;
+
 	if (kvm_vcpu_yield_to(target) <= 0)
 		goto no_yield;
 
-- 
2.7.4

