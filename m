Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9BC1CF28F
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 12:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbgELKe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 06:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729336AbgELKe2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 06:34:28 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A938C061A0C;
        Tue, 12 May 2020 03:34:28 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j21so5954214pgb.7;
        Tue, 12 May 2020 03:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L2RqfqhSc+H+ePr34TV4/iissQYNA9v85c7Lc6tpCIk=;
        b=O2t1bQi56IwPSCMA8Y5PdU+KtFeunCDRbtTW0+OE5MX5oE/2gq1FrlmxcVlvA4gDPK
         7QiNt010v47uuC+Y5IqNEZoyYgq/+68SI0Gh7GaPLQwsFuaDBtujXhJ9qfBPAtr0U8R7
         kZAMvFG3H48zhfsU2BozduulI1ETPhxipQFxkwXAC1LIAocT7wiGfZpzokkfRHsBWsct
         9uSnt4awqb0AiYzMVPciJC+1Hg55GsEBK30S1dFc8bhe35epGFgTUJiQU3k4HJDlL4Db
         l/KNvah52mKsLUVxUJ5Wp/sQh/Dr3hysJ6inApBAHqQDG20a71qINanrScROoh/qXyFw
         iwZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=L2RqfqhSc+H+ePr34TV4/iissQYNA9v85c7Lc6tpCIk=;
        b=p6sCIO4WZLxGU5aV8xJ+AshDPobM3u0QsP3Ax0heJTIMC2zusLb0gSNJyJmA65KWIs
         Qz8f5/nwgdHtKJGw3bVLFjouYmRJQtCMiVAsILBxiiKRZc2NGjtPuG4nQgWhcJEyLyWv
         q1Gvzfszu0IkkSweYKOSR38gPb/WCfyAHf4Wy/LNfwjO/0Eg/48qLRHL7t49UqHps9GO
         LcZlHzQn/wZz+mQtByIr7mddyQ+05ikxYQw4HcR7Ou3/rFiyTruFkGZpK0Y8eP6OhQ+s
         5bi4yELRCJL7pkqrqPFrsgqCTpXO+rZyd79/ZVds5RldGwBWMtG9V5igAJ7rH/HfQW7/
         +joA==
X-Gm-Message-State: AGi0PuYQ1hB9LEtNA6qckDQr9WnKF31S0sbFml2wlWd5ij0mk1Ow6uTX
        pnZ7g4pY8gYfLSdu1yBIOWk=
X-Google-Smtp-Source: APiQypJdUuO3SbkYIX0ecQAdtWRaRkfRQwM2x4YPjdpRdI52lYG5zQ4LKQb8feTZHssTVGd2nT0Fag==
X-Received: by 2002:a63:cf10:: with SMTP id j16mr11035267pgg.242.1589279667996;
        Tue, 12 May 2020 03:34:27 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id q11sm11617094pfl.97.2020.05.12.03.34.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 May 2020 03:34:27 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V4 08/14] KVM: MIPS: Let indexed cacheops cause guest exit on Loongson-3
Date:   Tue, 12 May 2020 18:31:14 +0800
Message-Id: <1589279480-27722-9-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
References: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3's indexed cache operations need a node-id in the address,
but in KVM guest the node-id may be incorrect. So, let indexed cache
operations cause guest exit on Loongson-3.

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
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

