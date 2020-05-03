Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BB71C2B30
	for <lists+kvm@lfdr.de>; Sun,  3 May 2020 12:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgECKM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 06:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727916AbgECKM5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 3 May 2020 06:12:57 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00C5C061A0C;
        Sun,  3 May 2020 03:12:57 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t11so7095526pgg.2;
        Sun, 03 May 2020 03:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1g+QKsylunTzCpyzZnzy9jIrZoy724tgHbkXEIPo/IQ=;
        b=VYszNZZ/FEQevLFks5IkRGKPtWwALxnnbwjxgJQAB0H4oF86VgIMysU87+uOJf/C0h
         0/qsTZo4VhNmNXT4Edehgs/IPxCyoR+kRdh2dJ0pQaPL7hFKIowsemETOM0GA6DrMWQh
         dPvMHwYqaj2zXOMjAiwzyTvzuT94gRXeqUPpGRjI081L80daOQUz8/seDbqfG17ZudYx
         tjVBxuz/BvKNlqDkFrEF01oVqnX41HyeAElmb/J5BFq9Wq41XZIeCMtauGXXOA/xiOYC
         UwSy0KNQ8qRHzBGO5Z2EK+Kww9axNZVtEQSyYxzdGWspuOSp64XzFtcWX+VxQQ+GCZ76
         inLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=1g+QKsylunTzCpyzZnzy9jIrZoy724tgHbkXEIPo/IQ=;
        b=sy4BMf35Uf5GX+yDgy00LrB+8KKWIBOXi5ervmsT30aDG252TUony98qKmJPq4wu1b
         ktSjgZxgtnewXfXDiYv9TNGaFT5fxztOUWwkrtObENElbn5GcyjQ0CEEZpKTZtl+/xZs
         +XHvGzTPXKY8/cno5tmOZkxzExM/8Vh5r6X7j2lr83hdpCGHXaa4Jl0FOPtF2i4HENSh
         TquGvgvDEAaGKCiZwlWXIppsqi9zvs9fnlODF2eUlPDeHRptENC2qxAfyhqUoIQYXgL2
         XUu2lLx5e/Li5sZDDmY/4plQjbwlnw2LG/eiOKJfwnpECTfZjgiED2CZrqgn1DYs7egK
         sWKA==
X-Gm-Message-State: AGi0PuaLw6zdv3yU+b0SzyFhk14YvIfIjRagGvR5pfX04BC+ssfVTXHr
        YY0CJ2tOlw2U+/auB8w3aEs=
X-Google-Smtp-Source: APiQypKAitL7UnUt0qbGyf3ym/haLf6qtFe8doUu95dV0GzP2+bKpAL/SmkVdnWiePIQT/0HogRKBg==
X-Received: by 2002:a62:5289:: with SMTP id g131mr13034730pfb.318.1588500777201;
        Sun, 03 May 2020 03:12:57 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id r26sm6329902pfq.75.2020.05.03.03.12.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 May 2020 03:12:56 -0700 (PDT)
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
Subject: [PATCH V3 07/14] KVM: MIPS: Use root tlb to control guest's CCA for Loongson-3
Date:   Sun,  3 May 2020 18:06:00 +0800
Message-Id: <1588500367-1056-8-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
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

