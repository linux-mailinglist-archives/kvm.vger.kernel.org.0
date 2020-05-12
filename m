Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD0A1CF28C
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 12:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgELKeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 06:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729336AbgELKeN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 06:34:13 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E51C061A0C;
        Tue, 12 May 2020 03:34:13 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id a7so9181465pju.2;
        Tue, 12 May 2020 03:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ahbqm97UA9X6sXan9XG+HLCRcdefKOFp3FssCpJpsAM=;
        b=NVNpTVigdLBPU6s8FGbGQTFErOn//3CWOt481/9mOZjpdIzRucAzoKMM5j8pl8Rj+v
         17MZUbYyiWRDBAhu5FhGtpbePKFxq6uVwuhALY5yRSAfGLcTT6BSoaQpbSzmwRwZdAE1
         MY3/Xbb+ZfFZAchMQitv2Lw0h/o9YC7+t2velTCb2QYE4U53dm8SkroC3ILgn5Axe3iL
         SaPC6LW2Pg+Un92VgR56CRmiRRghnQZa5f0h7R2JYStPZhDcVx/nP7vYlpuovGfnCavL
         ylNdYhngM1scDj592fTNpqcUuV3hkJcHc/sdw79o4gQ99MXuxKomVwER1Pyxx+3Ku8s4
         wWZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=Ahbqm97UA9X6sXan9XG+HLCRcdefKOFp3FssCpJpsAM=;
        b=U/9i86a//mIiXlCNSjpjdDVkkDE2uzmN61zeDV8EXg38CfRp1frwZXFzYjImeZgYkm
         1wVeWIOYPcYIsDFP79dOXbo5Cqe4EnLqJiB2D3t2kmRJRBIIm6DBDhOoWb1dKPTFKRFv
         1S9oUqLTOdC6aS0Kx5ybrQ7HlLyFtKKnKnN6BVSCpPFUuq6bOeOhhC0RQn8ziHxQ67a9
         rG0jJHoAHoGMkCQ73z+J5ni0ObCDK/DoA68qDvmTinF7OAqz5OgXkF3xyQ/fu3gsEYmE
         0a+7yiBIBcQEIkiLJMgf1eDAr+DMip1liU6jSkEEhIxDbMG3oMPJcf9h1bOf0WGKSKqs
         X0fg==
X-Gm-Message-State: AGi0PuYIWBDYaNoq8AWaxAYOTLbmAZCMolUW/LkNjooLv+/q4X7zf9qq
        kWH8bJ2W6VSdjgaz/CtI6vE=
X-Google-Smtp-Source: APiQypJfHrQlVPqlEL3pEUleud2EPcz3knZFhoRe3RnTtpI7sVHpJGjzHWF7P1OcfVrKAHexPDBO6A==
X-Received: by 2002:a17:90a:1984:: with SMTP id 4mr28851748pji.36.1589279652865;
        Tue, 12 May 2020 03:34:12 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id q11sm11617094pfl.97.2020.05.12.03.34.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 May 2020 03:34:12 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V4 07/14] KVM: MIPS: Use root tlb to control guest's CCA for Loongson-3
Date:   Tue, 12 May 2020 18:31:13 +0800
Message-Id: <1589279480-27722-8-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
References: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
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

