Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001121C2B33
	for <lists+kvm@lfdr.de>; Sun,  3 May 2020 12:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgECKNV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 06:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727916AbgECKNU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 3 May 2020 06:13:20 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06282C061A0C;
        Sun,  3 May 2020 03:13:20 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id fu13so2337532pjb.5;
        Sun, 03 May 2020 03:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6VYOsM5gqxnJ8Fj9mA3NrZhEPwkpUDOyTXJ2jtRSCA0=;
        b=Rf7sJ7XI6zpCzY+HQMRsyEv2lI3WZ8+8eo9hy+ptXjRGPt+YebdFZQRJ5ry6SoVgM8
         /8MbopWe/+nXPJDYzlVmArZdMCkDoTm43KeOpldKhpQxryMo3BJ1lSNOhUerzUsiFqTt
         h/X1vi9Uu8zO+2jKk9j8gPErpaR4ytjGiWc0ZwT4ImfmsJX6Hg9dqjqXReAoNURBXUsY
         FcljPVvLbndpc/VTLEg/DotlC8+7y0Jkf0ENs9J5TpKAwsJgOykW6ieAyeSBvglOuMCV
         Alk/d4ToOZOeOca4jRiNf643DDCxUAGLD81aE+6uDoOoSm+il+AM1XScT2ZMLMzIHB3f
         sXBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=6VYOsM5gqxnJ8Fj9mA3NrZhEPwkpUDOyTXJ2jtRSCA0=;
        b=g9ghYzMbA9AtZ6rtDxB3CYnlh5pR17JBQVFBee4POgiU+s9OyizhVhUIKO9TGwBT3R
         4RtTbwC6RO5QYLVRKfv6AuqKnOMh/hiWg4dPVpUpndj2sD9u+Mdi4y5KCsvae+dqC+J1
         o5nAlf9Nut3MWWqY6ltzFldh6ic8y6ohY/QtrSAMqdMccu95/1G4a5lvg6kxAqreMVgQ
         iHDtLVu8OaJl8kzNis6tCLHBkpfgNdzbDHTVB0tqeVJ3YeQpPhWn7yFX1RM3j+pTXX+R
         BE9DXpoIa61+7ydqKQovFXuwLx+yM+Y415MDIMf5yQ8g75FxJreSM+AcRjPBhGsyhPQ+
         o1oQ==
X-Gm-Message-State: AGi0PuboaAzdesyr9z2BM2crh5CTn/hX4dzU/d0UibTdvHsqoMe5C/I7
        e6exO2ldiUKOqKVl3MHu35bVOWgIGto=
X-Google-Smtp-Source: APiQypKPgjvr2AJSyhutZpYUjv1iT5TowbTMwqWb9qVE78OIwXS0rIgS0FYUofmvX2ixJVRr6RywoA==
X-Received: by 2002:a17:902:fe09:: with SMTP id g9mr12648228plj.65.1588500799612;
        Sun, 03 May 2020 03:13:19 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id r26sm6329902pfq.75.2020.05.03.03.13.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 May 2020 03:13:19 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V3 08/14] KVM: MIPS: Let indexed cacheops cause guest exit on Loongson-3
Date:   Sun,  3 May 2020 18:06:01 +0800
Message-Id: <1588500367-1056-9-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3's indexed cache operations need a node-id in the address,
but in KVM guest the node-id may be incorrect. So, let indexed cache
operations cause guest exit on Loongson-3.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/kvm/vz.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index f9fbbc16..ab320f0 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -2853,8 +2853,12 @@ static int kvm_vz_hardware_enable(void)
 	write_c0_guestctl0(MIPS_GCTL0_CP0 |
 			   (MIPS_GCTL0_AT_GUEST << MIPS_GCTL0_AT_SHIFT) |
 			   MIPS_GCTL0_CG | MIPS_GCTL0_CF);
-	if (cpu_has_guestctl0ext)
-		set_c0_guestctl0ext(MIPS_GCTL0EXT_CGI);
+	if (cpu_has_guestctl0ext) {
+		if (current_cpu_type() != CPU_LOONGSON64)
+			set_c0_guestctl0ext(MIPS_GCTL0EXT_CGI);
+		else
+			clear_c0_guestctl0ext(MIPS_GCTL0EXT_CGI);
+	}
 
 	if (cpu_has_guestid) {
 		write_c0_guestctl1(0);
-- 
2.7.0

