Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0F31B72BA
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 13:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgDXLLG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 07:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgDXLLG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 07:11:06 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702F8C09B045;
        Fri, 24 Apr 2020 04:11:06 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id fu13so3185477pjb.5;
        Fri, 24 Apr 2020 04:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1g+QKsylunTzCpyzZnzy9jIrZoy724tgHbkXEIPo/IQ=;
        b=TcjehTf1/jmkxgfAZubU13aYIaqsjCtKManRtnC3GBLA9or964xmijVzHIyDIhFydl
         /d+WVpvhOhASaGJj0a83t3PYhmCEU4U3fqBrcT7ql7fsIiOcW36pcaKR2M1G6YWTB8vQ
         56BHmmOeqAh/clZ3Q0ioBLLHNScKsqdBzc5FXjVfuHYBOQ95oCF44JlasIoVNw19ZpdP
         IN8+H8+U/eWtYJ9UastGFlw2HSKQ5007eF436OIwKW54a2wY6SO0k/XSTKsfqneJFAJG
         QMWXGxlRrcUznEXGALR4kUPPnSGQEdCSrOEId6jYqbKiwukmfcIbqo2AP2zV83/OnpY4
         noGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=1g+QKsylunTzCpyzZnzy9jIrZoy724tgHbkXEIPo/IQ=;
        b=TTUndpMiY7IDd6ucIyD3UygdSrglNft/CxYltUhai2RJbvbVE48jN6T+i4w+m8CnSc
         yM2bbv1WRmJr+X10D9Ixzh6CCw7oUP24CEkQSY6vpGWDFA7VMB5XnxFRLcEGZf36D4KA
         EfovO+rVR28VvBVoa3QXxOmb+o+obS2zXHauXBJiQYgHqhr3mfIu0Lk+qfWjbWc5zOaB
         gwdyQ0tcHXa5KRdVFtxwvQ9hOONyW0GY2s/xb1fYOwoOhJYLj9nkIVyoewHCFK6hB3g5
         zMGbAsLb32tVqrWVfqVEuPUAoTiu2CclxBm0v/E9gj249nplffxv75xjZhUn50kF+39s
         oQvQ==
X-Gm-Message-State: AGi0PuZhv4Q4myDl7R/E/KARUndmcTcKc/HJGhH3o8Yn0BVnksdQdmNb
        y/oiWD5KU7LnnQBtIWtX2n1xbuoA+IU=
X-Google-Smtp-Source: APiQypKRvaJczm0uTa7mSZc2UAdJNGHpasYPjq9Y1mT3Ie5ykD3wu//p8OSWVtXUc80KQh/njEhFIQ==
X-Received: by 2002:a17:90a:718c:: with SMTP id i12mr5645038pjk.58.1587726665948;
        Fri, 24 Apr 2020 04:11:05 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id y10sm5470110pfb.53.2020.04.24.04.11.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 04:11:05 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V2 07/14] KVM: MIPS: Use root tlb to control guest's CCA for Loongson-3
Date:   Fri, 24 Apr 2020 19:15:26 +0800
Message-Id: <1587726933-31757-8-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
References: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
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

