Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA2B1DFE8F
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 13:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgEXLU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 May 2020 07:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgEXLUz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 May 2020 07:20:55 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4F0C061A0E;
        Sun, 24 May 2020 04:20:54 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id n15so7244299pjt.4;
        Sun, 24 May 2020 04:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L2RqfqhSc+H+ePr34TV4/iissQYNA9v85c7Lc6tpCIk=;
        b=s9Died6PbXTchUyED1MkohG1ttioFovAARhFp8u/FITaTvxtKtPEBiv3mpD65M6TnD
         /Ocn2fjrnguP40C1M6ezzXXwAzA+owIINBt+PpSifOGWV+XV3oXgFEnjgzaHu7i/+NEM
         /CTzqX0qHK0Amhojwo8ZjDin9bLYjxLfA8ls2vEn4J08/bRh0/pNijMminWREKfeUmCs
         K5WMVRG9kjmTYFd6U3CQAMnPmyPrh9UwwK79cPgff1qWuAY/e5nWuGiY4zDrue80qvUG
         oFHkfVU3JOCIHEYlnAZt3L53MEpgGbqi1zgYcrt6kzkcIJnjTvRgERLfw7U4QkmHXqry
         /xkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=L2RqfqhSc+H+ePr34TV4/iissQYNA9v85c7Lc6tpCIk=;
        b=tMFhYha2Z9nvUvWF77zit/w036OCPiF4jZoaSNa5jNqTl5o12vfHdN0LuNU4Vy5nXc
         eOrdW+WguaXgFeew0MMq0RJeHwpFH5nL75/a9DY0rgOg2yqtueu1h/dr5AvGBmTAwsdf
         VZqqanbhbHZNCk+ydajF6ZOvErtFaLbzlMKDiEWAWjyVsNqbNg2Uwp04FxpfX7hVFND1
         qcteBHAvYCXBBEfcK8GffzLJSrikP54wbDYErBoK2NT39gOo8WC+JwXH97gUgof+byRR
         XlpiFGjG4+b8iU+ZsFLVphcWEeJIS+zPf1nPr5D2Vjkw1SNzl7i5eNP/qlYAEzXIDj+T
         cHFA==
X-Gm-Message-State: AOAM530xkt6Lx6mgtKW662D4RHQ/LaumZWusX3BU3hEqf8TbHuMeubW4
        +BXDyxkwIcyXvFNBCYw6dcM=
X-Google-Smtp-Source: ABdhPJw5hfP6gkQXluPmNQJzNuaVBObaxBbP/0ZlACO5GGv8VOkSy+b+zRB33yHpJnJybT/ZYlQQHw==
X-Received: by 2002:a17:902:c212:: with SMTP id 18mr7436945pll.162.1590319254162;
        Sun, 24 May 2020 04:20:54 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id 192sm1971719pfu.202.2020.05.24.04.20.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 04:20:53 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V8 08/15] KVM: MIPS: Let indexed cacheops cause guest exit on Loongson-3
Date:   Sun, 24 May 2020 19:13:32 +0800
Message-Id: <1590318819-24520-9-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
References: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
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

