Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88ADA1D6592
	for <lists+kvm@lfdr.de>; Sun, 17 May 2020 06:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgEQEIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 00:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgEQEIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 00:08:52 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6549CC061A0C;
        Sat, 16 May 2020 21:08:52 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s10so782304pgm.0;
        Sat, 16 May 2020 21:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L2RqfqhSc+H+ePr34TV4/iissQYNA9v85c7Lc6tpCIk=;
        b=kvQ6/J5J0u9VO5HSNQwDyd9+dQxJW5Yfjm/Hg67X+0FLiPMAAW5Zcr8sbaoVv0nFWg
         sxpwZmzWf+z87BtHgiUKgXyHHxMkYxb1l8oUgWBaqtrXyAfMyDaZ4MvKGxx+z85kpjXL
         sQ3UEPZWidaIXtpVSMzBm5dlYQ/ghM3QT7x9/HDfjVAFYM8HbMzP8sh9/tgQqWR2ntJM
         l+90eZUEfDScVFaY3XB/j5sYtRPwAagP/s0DrIn5we2JTZjSIBaKD8CsajBcvzLWhD4h
         dOltfBjvpdFvu5CjJgu5FcmsaBH/GPasO+pkygTKMkl8oKgPBa2Rrj+3PuQfw1/L0WTF
         3THA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=L2RqfqhSc+H+ePr34TV4/iissQYNA9v85c7Lc6tpCIk=;
        b=JfoPGoBPI7FUcenFVUTekVzBW+//BkA44Z/IfPZRilDrZvJGz2ob8NFVBt+n16ufJr
         y1gOY+JV+4GeeZkpRtwqYgdkq8GDcnERzbhktUyiPl6M0hoKLmxngcrrEwhtnd6ysbw4
         YwYop8sVab8W+1SB49iyGham8LMrQgz2t1LVcXzjUx9LIXsTI3MyI1VMrlRhr24RIiEh
         ktdTAjUzUvOgqRE8EHDSwVCIArEo90ddLN/qRSf2Pk/HpZYkpsgnToS/AxNNP1Ep9r3s
         xne50S/n9ZM1xs35iyFNpYWc9x9zD6p0FsLNZiwR/lJpmCdjQSDqpyRO1sldi+u1RUPU
         BRUA==
X-Gm-Message-State: AOAM531+0hLcCPigtgxtlfzj7pJhiNdU4IA992ii0FwsOt1AuVD7F/RX
        52xNVpHX+ZEOj+GHogtOymM=
X-Google-Smtp-Source: ABdhPJwwXwxd+I6nW+Yuq4+khrggOi0vSm8LNfbWGQHYTt4uDyFko9eHfxRtvJywK9cLJxgVDdFCPg==
X-Received: by 2002:a63:715a:: with SMTP id b26mr2424051pgn.433.1589688531904;
        Sat, 16 May 2020 21:08:51 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id n9sm5081630pjt.29.2020.05.16.21.08.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 May 2020 21:08:51 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V6 08/15] KVM: MIPS: Let indexed cacheops cause guest exit on Loongson-3
Date:   Sun, 17 May 2020 12:06:05 +0800
Message-Id: <1589688372-3098-9-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
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

