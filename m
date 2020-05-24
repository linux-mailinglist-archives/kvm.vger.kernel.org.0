Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0A01DFE8C
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 13:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgEXLTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 May 2020 07:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgEXLTm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 May 2020 07:19:42 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAE4C061A0E;
        Sun, 24 May 2020 04:19:42 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q9so7253005pjm.2;
        Sun, 24 May 2020 04:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ahbqm97UA9X6sXan9XG+HLCRcdefKOFp3FssCpJpsAM=;
        b=A+ETevrSOoBgFOfX9iT7Xf8Uwb/4tf41FtZcN4bkmrzRUDNJoBJ0xWBEXapK6g6j4A
         UN0hIlVJT5ztN+5iWFhv3xDLrHrF9zndpkkg3lp8KqmvaCxUXZCSrqG/KIuhj9ohpk40
         4MS+0XNot2NSUdyzfZGSr9ychAa1ZcWUI6k/OeXRbrZmmP8wkBYD9kTF5985eL1NWvgc
         7wlWNbsn8Y8SpiH+3bnEhSFikhWnIs6hh06YeWdr7MB9rJhwqmu7+LxoQ3kGrEZs65Ic
         P23mokqcuVUyfunx+5WFgc6SXY5++GRdeXHJuqfmB9yztNp/Vlk6pdB34QPxeaHv4Fk+
         80bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=Ahbqm97UA9X6sXan9XG+HLCRcdefKOFp3FssCpJpsAM=;
        b=UcFNap2O6jEfmu7pkCtpgU8/neiy+izXYG8l/FI2tyTYzjEBXhH7k63ZqNz2316aOd
         YpdesLjQvXjY8o+eThPHuoNOVJmv5pdIpEEiQy1KOfI3i+XCl7zSVy6a3G8Wd1mIO1sX
         0fcl9fHqNvWOslV1rJk5Yuo3fNWt4BZOIRWjiVfon49ZDFaHgsc0DtL2eVu4B4aU5YWa
         agpLluK6cY7w4LoLy43FFWcg5ikYxlLweRgAXzb9g3xQ18fSvXYefNwbw8YdIuuhNfoj
         rKiGHSYuP3XA1AcVu4hi9Xwr1DapO5OBAdwZkmOJ8/3H89aJA7tHfzKJ/eBLqge/APmo
         kSmg==
X-Gm-Message-State: AOAM5308pd/XJB7zp7z6Dwqq1OjDSoppFp//db0tdZPIgRc24ziZyFTA
        hVauVBwJVkHD4zwLV1KDqxc=
X-Google-Smtp-Source: ABdhPJwB+h+ew607zsNEoHdctuhSMd1ZeeUdvS0FG1Wq6WmS8qVJ5JxYQJTKxHLcCaJKczwNN4Ev/g==
X-Received: by 2002:a17:902:301:: with SMTP id 1mr22885036pld.65.1590319182182;
        Sun, 24 May 2020 04:19:42 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id 192sm1971719pfu.202.2020.05.24.04.19.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 04:19:41 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V8 07/15] KVM: MIPS: Use root tlb to control guest's CCA for Loongson-3
Date:   Sun, 24 May 2020 19:13:31 +0800
Message-Id: <1590318819-24520-8-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
References: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
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

