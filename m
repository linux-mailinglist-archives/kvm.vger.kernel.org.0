Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D191A63A7
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 09:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgDMH0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 03:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbgDMH0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 03:26:32 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758A7C008651;
        Mon, 13 Apr 2020 00:26:32 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id v23so4172538pfm.1;
        Mon, 13 Apr 2020 00:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bZw6h2yo9U+Mfy3dzljKqyaJpon7bVmdpfdx+JLJk18=;
        b=J+U8Kwzn86Rc4sqH084u496a4YLWjSZok7YynJds7+m7/1NOtP1yztf181dwOfLhDl
         KToGfX1j7pUol8ZgqBsmjUA4lhvipo5wn6lyMD/lFPfZghjWA34eNZRnEyZxugtkNkQt
         ywSzvX2EfqwXDZJlDTD2YelivRnftxkEysc+Z4Egsv7vORdW/eOQArNwHZSQ/o4nf/rj
         mtV9xYDOBvdvSUOdo0gSSFUiImcJGDHkE/wcLGFMdpQyUnhqbwe0NqB3EV6ywT27mP/F
         Rz/CG47h765/07p0N+PMaJOU1irLHtDy1jEKarwdknCXNwal10rq8bfkaz74P854oKDN
         gWWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=bZw6h2yo9U+Mfy3dzljKqyaJpon7bVmdpfdx+JLJk18=;
        b=D3N6Z9h50vXmFKR4dVXua4Zko5oKf4vT+3wcqMe+gxsd+GqKQ0DWrLUCFfSeunfftI
         4qTMjjXHB6nm6ACFqRg3I3N4n0Zh5Jd67jxJ3jMfBMESTfH5mjm43S+jpm+Sp6vMDn6T
         vedR18VvWcl86ADfiIpOaANnFsA+mcuvGa+7Oy+dWCei8zvhoZsjID0R0YxLynzhH0TG
         A5G8B98YvZouMFLMu+8/rxOxgmb6cYIMpkLIEiyNgFvNfUoRLJ/1CuJgXMv6XGd/ZuXo
         4MKNTxHffVcxdy9ave3m0gqz3tQmcMPFRoZsiqIuxTx5ADhyYpvDhmaUTCwhiNjkbYrS
         7L6w==
X-Gm-Message-State: AGi0PuZ/IbzzVC7lawinLoA3JAOL3+wjXQ7OfO8WZN0y2GOsyt+hIXQt
        61xC/gnlVvzQBTaysRZ3bWk=
X-Google-Smtp-Source: APiQypL5+/JpeggvZ2dMsDBr8FlWbIdPo+KXT5Ndgn8wFWn18tzkVgeZUGMujR5wtOclfCatqUrB4A==
X-Received: by 2002:aa7:96f5:: with SMTP id i21mr17105073pfq.248.1586762792074;
        Mon, 13 Apr 2020 00:26:32 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id u8sm7241341pgl.19.2020.04.13.00.26.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2020 00:26:31 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH 09/15] KVM: MIPS: Let indexed cacheops cause guest exit on Loongson-3
Date:   Mon, 13 Apr 2020 15:30:18 +0800
Message-Id: <1586763024-12197-10-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
References: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
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
index e30ebb2..9a228dc 100644
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

