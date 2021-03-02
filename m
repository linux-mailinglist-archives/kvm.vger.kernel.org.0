Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B4E32A701
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1838995AbhCBPzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382698AbhCBJoN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 04:44:13 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73871C061756;
        Tue,  2 Mar 2021 01:43:33 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id c19so1560718pjq.3;
        Tue, 02 Mar 2021 01:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XgF5lKevrjewg9cJezIVWPcOGE+q+9kdUhmV1zB7OvE=;
        b=ODAvLqsyem96UdafeY8cYEiFXYZe+2nrl4gLaY/Bokif91LLDQ9iP7B/CBKLC4gcDR
         t02YasT2QQ25sw5Qc09GZjKKbn7uS4gC6w3dTcFmjWQvboy35cI1aq9lW5tmUPAuQHJa
         wmfR4HuNTyOyVxD2PH3UJXUrGlVt6/5+RIVjnYNMUrQQVIGwLmRKhIFyAyXgxG0ctOB4
         qS02fnfvUM9gk0JRCnAubdWi6dcNhWePu8lF3P1WardnaXdJ3zubwvjE/rPjvhu67ZDP
         XNcQPhQpevm+Qu/NCdGQK08djbvXbZJ2uNb3VsoVBsUMfiZdDICEfXMOZt8GOP7Uh3V9
         xOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XgF5lKevrjewg9cJezIVWPcOGE+q+9kdUhmV1zB7OvE=;
        b=E3nl5VA5aVoRKK45IoZZ5ggZ0ihfGnNehcPkkcKNDs+px9WMogFALlkxeFLZc46qHf
         5qHuqkqpOBOT4picCECuiNWhq1qKn8bPomerTDt7UNiXkqkpEylgMJmk8CUeAlRJVDsQ
         4YGRV7eantPVndwhFo2X6TJgstXsHGuNOGJXtM36iAeOF2IDibYEpCnSZ/09k1KW/DdN
         Tz3FkN458aRIML3rkZXyeVPQT0A5L21gW4puQl8Fr2HxXKtRqZDeTpdi/Z7FN3dgRt+X
         AN3WA+MxpCC3pKEBR9zItdE0ANNL0o3kgsbmwrbPucIqNmzu+zjGKqnMixdgJtsBmUNU
         vcpw==
X-Gm-Message-State: AOAM530XkF4SzcWdJBak0pd9gk8t6AGLiOH9Ay0TFfv216hX22TxcDsv
        kXmTWqE1Rvtr8oxYzqdxQk0m8tIFY+g=
X-Google-Smtp-Source: ABdhPJxIQZMzkXa9Zswjn9fQMvmAsALnBtFmaqhowII7TGPTrOOMql3V5dJTk8dRJIm25Vr3LrpO9g==
X-Received: by 2002:a17:90a:5206:: with SMTP id v6mr3596791pjh.22.1614678212662;
        Tue, 02 Mar 2021 01:43:32 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id mp19sm3211907pjb.2.2021.03.02.01.43.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Mar 2021 01:43:31 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: LAPIC: Advancing the timer expiration on guest initiated write
Date:   Tue,  2 Mar 2021 17:43:22 +0800
Message-Id: <1614678202-10808-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Advancing the timer expiration should only be necessary on guest initiated 
writes. Now, we cancel the timer, clear .pending and clear expired_tscdeadline 
at the same time during state restore.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 45d40bf..f2b6e79 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2595,6 +2595,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 
 	apic_update_ppr(apic);
 	hrtimer_cancel(&apic->lapic_timer.timer);
+	apic->lapic_timer.expired_tscdeadline = 0;
 	apic_update_lvtt(apic);
 	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
 	update_divide_count(apic);
-- 
2.7.4

