Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D211D6590
	for <lists+kvm@lfdr.de>; Sun, 17 May 2020 06:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgEQEIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 00:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgEQEIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 00:08:42 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45AFC061A0C;
        Sat, 16 May 2020 21:08:42 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id nu7so502215pjb.0;
        Sat, 16 May 2020 21:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ahbqm97UA9X6sXan9XG+HLCRcdefKOFp3FssCpJpsAM=;
        b=Q4zNAs5liCT959Quarek5cZ9AFn8vc3mxuDah3LGe7U7IASBt7tIoiqlsUPkuRPXSf
         01jPxu/sgYbiHYzs0gdzneuhSTGwrjNI+W/hmWoer3FAJ4+CxGaWNI9Ame7qRGAmdQJp
         esENKFD5u8rQxsEpJYOeMN9uHJcTmkzXARuMMy0grL+4wP4E8rAno0nUCaqrQcs28wnk
         +E2IaCddKQ07k8fIe+Qp+oOFUOOr+rI2IwA00PdczVgbkLSYt4MBys54BggKDiW5gA3t
         HwFUYH18NapAZVLwt6kuwZWoL2T7w54hwww3v5hktmUQGruY/hHvbct4r85mgzfEm9FX
         CNrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=Ahbqm97UA9X6sXan9XG+HLCRcdefKOFp3FssCpJpsAM=;
        b=gTHfHeaZAkdfysC6gfmOFK5C+Py3822oG1gNsn4MquE2BtLCITzshjkLhpjATwabOH
         yOlZrbuBgRT0LrmuL8P/rxc7/ZPa9TZX4ndyJeTFFb9jHtXu7Rdkdnm7gvafoR0XEEYV
         ktRnfrvdLClNglKdaLR9DL1XBewJLLSsPndduycnlnE387ffRlJz3/NmP80ZmyjYOVRW
         4a4GwoZwxlDgRBsGCRpYwFRZSwYm6pabxfo+rv1HT7A34mg5ABMhFeq6oZGWvL38xq/y
         5J5ptCVuhkV28jEM+NHAdD2jLTtfDS3goiIDQ3eba2kpwa0qghDT0HlvCNrYuq78zVb9
         i65w==
X-Gm-Message-State: AOAM533+F9kFL52+7ygj7qs+IV7PdC8DEd/GGbdIGFzzP94KD37dq94x
        +0ly4x3Kqocf5CfDr2GDDBE=
X-Google-Smtp-Source: ABdhPJzJCa8OY3yzBpOednuXeYARj1Q888HVZozWzh4XviY+Ey1VhvYj8Nbd8g5cfllicCAThxmcCw==
X-Received: by 2002:a17:90a:9302:: with SMTP id p2mr11966432pjo.230.1589688522525;
        Sat, 16 May 2020 21:08:42 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id n9sm5081630pjt.29.2020.05.16.21.08.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 May 2020 21:08:42 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V6 07/15] KVM: MIPS: Use root tlb to control guest's CCA for Loongson-3
Date:   Sun, 17 May 2020 12:06:04 +0800
Message-Id: <1589688372-3098-8-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
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

