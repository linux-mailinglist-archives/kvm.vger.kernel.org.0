Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A13E557CE
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 21:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbfFYTcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 15:32:53 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43734 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfFYTcw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 15:32:52 -0400
Received: by mail-pf1-f196.google.com with SMTP id i189so9988190pfg.10
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2019 12:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DOSmBNtGVGiKZQlIkSIiudQMAdtpDAF3oUbvXblt2VE=;
        b=Bjhs6k/0JrBulBvg8q71WoreZ6NJLY+Sb7dhd2Q6dF5VzvzLXfMuAEfCjLHWQMP2ua
         x9Sk+Z1LzQbf7Yk79dGUC0pkoCPJ8QLb0kW0BhGPSj9sXJ+i0kNyhsGV/8TWidgzy9F5
         gt0lYx2vjtR2j7q3E3rhClTadIPaoPUlVgtkmy/QLOJ869DBS6eGmHz9eH6vjTyDR+vj
         vEUpBqVUEi7P374vMosyVp9rPUhuI19E/7HbMvekZ/ZM/Ctv6tqRQGayW5AG1aZzXnA4
         X12EIT/eMdRPZ7jvY1NGgyhYfmYhhZ9rIvYqte9VDbM+y+PQLW5XgEaBoAGhLvyh5cOi
         d7Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DOSmBNtGVGiKZQlIkSIiudQMAdtpDAF3oUbvXblt2VE=;
        b=o5zzm9MmeQymsBa5wP2JYO+plt6thP/rRNC3o3ozL+LvFCUI4RiOBG5GneJYWZWD9M
         pVvni9dyR7lDLn+ur/UzbLxYLn66/0Uhp/3Xjp9CEdZn0M9r0+j5vabWst7ApALzfd8b
         lF1DPNMqbCQas/W2SvNXKcoG8C+ZIQwOyXYRzgfAS8Q0gwHxeZ4D2+q3MqEp0qWBdKQ1
         2XI0EdseZLoGb6v+qb1Q9n+GTvQf4Z2QiPvRg5zY0JPuX8H8AGmAqqxbf9EPmfqgjzCd
         NTIvHDaBQWBkwsdsKxr7im768ExLchVg4KtAaBgSm5OMYheh4f18aeBcNR60DMl1S25i
         To/A==
X-Gm-Message-State: APjAAAU2pCzpT9C+O3tpMNheYeb3+qylcWqSaOrzQp8DUMebE+/8Osk+
        Je7dybsIKLcEtCpPps0VbOk=
X-Google-Smtp-Source: APXvYqyL5XKcggaJIvZliTKed0sgMzlhE1nrhEdbrtCOe4U0rHQ1ZMhRhcV6I5+oisw7zYQKsvW2Lg==
X-Received: by 2002:a63:1962:: with SMTP id 34mr1736471pgz.175.1561491172143;
        Tue, 25 Jun 2019 12:32:52 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id o12sm25645pjr.22.2019.06.25.12.32.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 12:32:51 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH] x86: Reset lapic after boot
Date:   Tue, 25 Jun 2019 05:10:42 -0700
Message-Id: <20190625121042.8957-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not assume that the local APIC is in a xAPIC mode after reset.
Instead reset it first, since it might be in x2APIC mode, from which a
transition in xAPIC is invalid.

Note that we do not use the existing disable_apic() for the matter,
since it also re-initializes apic_ops.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/cstart64.S | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/x86/cstart64.S b/x86/cstart64.S
index 9791282..03726a6 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -118,6 +118,15 @@ MSR_GS_BASE = 0xc0000101
 	wrmsr
 .endm
 
+lapic_reset:
+	mov $0x1b, %ecx
+	rdmsr
+	and $~(APIC_EN | APIC_EXTD), %eax
+	wrmsr
+	or $(APIC_EN), %eax
+	wrmsr
+	ret
+
 .macro setup_segments
 	mov $MSR_GS_BASE, %ecx
 	rdmsr
@@ -228,6 +237,7 @@ save_id:
 	retq
 
 ap_start64:
+	call lapic_reset
 	call load_tss
 	call enable_apic
 	call save_id
@@ -240,6 +250,7 @@ ap_start64:
 	jmp 1b
 
 start64:
+	call lapic_reset
 	call load_tss
 	call mask_pic_interrupts
 	call enable_apic
-- 
2.17.1

