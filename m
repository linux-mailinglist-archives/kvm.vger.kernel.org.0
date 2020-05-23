Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F301DF5E1
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 10:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387705AbgEWIAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 04:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387500AbgEWIAi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 04:00:38 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3455C061A0E;
        Sat, 23 May 2020 01:00:37 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id k22so5338655pls.10;
        Sat, 23 May 2020 01:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ahbqm97UA9X6sXan9XG+HLCRcdefKOFp3FssCpJpsAM=;
        b=tTUrf1H5rnnophyaxylgRFDHrou4WjrhVnSPC2fjSNC6IFVc9hFgDOC3jjMAZ/VZZ9
         w2RNMD3KPLWX7feueewK8PzNgBvS1OUPp6UTGAf4xcBfULVB+Mskq8nQYxbfGEe0QO0u
         DlpF9ZB0k1mER+BDu6NSOEWt4OdETVZRJHae0U3mLuC1LTZ3SL5XHfaQ48gVCw7fY4pr
         JXL14TyD6PXxM+CGgrqOM+wqbyzjVwLzFM2VZNSvyzONJ1AX0ybjpfenTf7WW1H5kNF9
         6JpUngFyGo3Xf2ID4S/p1FtTKhIe/TO71ehCUiTC7Y8tVcMMiBcuVtRKsm4GIm3aV7EH
         /6YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=Ahbqm97UA9X6sXan9XG+HLCRcdefKOFp3FssCpJpsAM=;
        b=RP/UXgNgeM21IvhiPYRc8AuenF3mj449sMxeAqvgnmVjABj4P78Kddh4nabo6ARN+/
         1LoyDkB7HBHpsh8ZQG5r3zShqsslRwyv1cRdFYgQXjf2SZITRm6pLWar70q6klxKeQyS
         o+RYYOlEWfcIf1oj6wch2K35G6iaCWVKXdsUlqXr5EHfZ3A4iEJNti1/xOeVjOgW0es4
         NRltqi2oaB2H3iWuwyw4ZUvCnMoAgrSlQEMmqlVEdo2UoqSPP00Bm6o5ZZYs+oCUW3So
         oOg7iXHwAQ6j8LT8rB1LatzeKm2kSBPzRwHI5T77DjCaG6OHi6K2Z1j7gGgcGlx0lftt
         NKQg==
X-Gm-Message-State: AOAM532NUA8gSk5lg1xrAksNWLvxLWsl5LJ2C4k6DHjro+CGTShLATHz
        G12rpR8XjZTOYMuXm2mkhL0=
X-Google-Smtp-Source: ABdhPJyS73kpDv8hCgy6gJqOqhbHyT+k0QQcvbEbKCG2urFflurBHI6iOEZd19af770FW2l3MmsmRg==
X-Received: by 2002:a17:90a:23ab:: with SMTP id g40mr9029154pje.224.1590220837307;
        Sat, 23 May 2020 01:00:37 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id w7sm678491pfu.117.2020.05.23.01.00.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 May 2020 01:00:36 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V7 07/15] KVM: MIPS: Use root tlb to control guest's CCA for Loongson-3
Date:   Sat, 23 May 2020 15:56:34 +0800
Message-Id: <1590220602-3547-8-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
References: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM guest has two levels of address translation: guest tlb translates
GVA to GPA, and root tlb translates GPA to HPA. By default guest's CCA
is controlled by guest tlb, but Loongson-3 maintains all cache coherency
by hardware (including multi-core coherency and I/O DMA coherency) so it
prefers all guest mappings be cacheable mappings. Thus, we use root tlb
to control guest's CCA for Loongson-3.

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/kvm/vz.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 422cd06..f9fbbc16 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -2871,6 +2871,12 @@ static int kvm_vz_hardware_enable(void)
 	if (cpu_has_guestctl2)
 		clear_c0_guestctl2(0x3f << 10);
 
+#ifdef CONFIG_CPU_LOONGSON64
+	/* Control guest CCA attribute */
+	if (cpu_has_csr())
+		csr_writel(csr_readl(0xffffffec) | 0x1, 0xffffffec);
+#endif
+
 	return 0;
 }
 
-- 
2.7.0

