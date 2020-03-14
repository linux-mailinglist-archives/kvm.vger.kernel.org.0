Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E84F5185A01
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 05:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgCOEKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Mar 2020 00:10:19 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38925 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgCOEKT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Mar 2020 00:10:19 -0400
Received: by mail-wm1-f66.google.com with SMTP id f7so14380797wml.4;
        Sat, 14 Mar 2020 21:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=7NszvAXb9CGNqwT7dYeN3INhVSTlKBvqRmiaZIGgUzM=;
        b=n+liN5FZupOzuGmaL8W0VktGX+braNF2HwHqE4seR4kZiiex5TQZtj04W8EtxZmx4U
         N7mE03CKIQLzpncNE7yyQ09H6quoTKYstglmWXP3LhUtIZFh0jpumW8LqsW4n0aYNu5E
         9Zsda/e4+bVvPPea+hDL96ZY/Un+MMEko9W15c6R4h0gGHl1FKReRQ+O/qaUHi4rpz31
         mE8oVXifg5I+uCgDvF8+B0njfnmctgZY6IZAk4BeeTta8N+fg++CYNS1dtGmFiAHuhNJ
         h9ef3+9fGWIBNBEcI944HQfRxvk6l3tz04Tl6SJ4M+8dLIsYsa1ro7rfgL8rD96BGbKW
         EFTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=7NszvAXb9CGNqwT7dYeN3INhVSTlKBvqRmiaZIGgUzM=;
        b=Tmlno+NuQnDfIWyxElYaw53OfcDweB5O4gV7uqc5XUONjouwFXkJKepnLOpXfHUweR
         8Lf+0qmlovwbiCArmHdB8Dwl+NOdq1/V/HJMQdVeZ2FJ1KEeuTpQ1tnYBX3NsosQYCIW
         AT9ddpWDsLofJgLlkJTKQ99DPlMxnCz4/3X+QqQqhxPYLYTaQQk3IgYRxR5hXIYtnv/g
         ND1/QijKCNmT7699V512yMe8jz5HS/Jo63NFNXGcsQFB7naOKIpQyJr3OdDNLOO8AZql
         Xj251NdVHoSaPqc2zoD0KEXSJMu+ahoY1SZjfyYvPnI5wcitSRfnjTJFswQWxm36l9GC
         Okzw==
X-Gm-Message-State: ANhLgQ0M4z43tTly+GEgvbFRzY4e8i4c5wXJmhxBhXwJmwob8HCyUkuo
        v9NlcWsMox4bHAEMOBdDBDiQCZp+
X-Google-Smtp-Source: ADFU+vttRMhC6z4KeEiI90Sln9kvzZ3oD5DpV2H2KhdjIUk7TSHX42UtdII4c1he6JrDUQ6cxbKKBQ==
X-Received: by 2002:a7b:cb17:: with SMTP id u23mr16873136wmj.12.1584185482872;
        Sat, 14 Mar 2020 04:31:22 -0700 (PDT)
Received: from 640k.localdomain ([93.56.174.5])
        by smtp.gmail.com with ESMTPSA id n186sm454515wme.25.2020.03.14.04.31.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Mar 2020 04:31:22 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linmiaohe@huawei.com, vkuznets@redhat.com
Subject: [PATCH] KVM: X86: correct meaningless kvm_apicv_activated() check
Date:   Sat, 14 Mar 2020 12:31:20 +0100
Message-Id: <1584185480-3556-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After test_and_set_bit() for kvm->arch.apicv_inhibit_reasons, we will
always get false when calling kvm_apicv_activated() because it's sure
apicv_inhibit_reasons do not equal to 0.

What the code wants to do, is check whether APICv was *already* active
and if so skip the costly request; we can do this using cmpxchg.

Reported-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a7cb85231330..49efa4529662 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8049,19 +8049,26 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
  */
 void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 {
+	unsigned long old, new, expected;
+
 	if (!kvm_x86_ops->check_apicv_inhibit_reasons ||
 	    !kvm_x86_ops->check_apicv_inhibit_reasons(bit))
 		return;
 
-	if (activate) {
-		if (!test_and_clear_bit(bit, &kvm->arch.apicv_inhibit_reasons) ||
-		    !kvm_apicv_activated(kvm))
-			return;
-	} else {
-		if (test_and_set_bit(bit, &kvm->arch.apicv_inhibit_reasons) ||
-		    kvm_apicv_activated(kvm))
-			return;
-	}
+	old = READ_ONCE(kvm->arch.apicv_inhibit_reasons);
+	do {
+		expected = new = old;
+		if (activate)
+			__clear_bit(bit, &new);
+		else
+			__set_bit(bit, &new);
+		if (new == old)
+			break;
+		old = cmpxchg(&kvm->arch.apicv_inhibit_reasons, expected, new);
+	} while (old != expected);
+
+	if ((old == 0) == (new == 0))
+		return;
 
 	trace_kvm_apicv_update_request(activate, bit);
 	if (kvm_x86_ops->pre_update_apicv_exec_ctrl)
-- 
1.8.3.1

