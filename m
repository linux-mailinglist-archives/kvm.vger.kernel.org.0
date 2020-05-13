Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3241D0B1C
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 10:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732385AbgEMIpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 04:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732279AbgEMIpm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 04:45:42 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C749C061A0C;
        Wed, 13 May 2020 01:45:42 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id hi11so10798116pjb.3;
        Wed, 13 May 2020 01:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ahbqm97UA9X6sXan9XG+HLCRcdefKOFp3FssCpJpsAM=;
        b=Cyo5mZQoz+HYBuOPfBwO4Kaobsr+tcraBby7lhjEwFbUdYOPO5leOhoa9FTVl92XZr
         woSMZtD6+1BdBVq35F5rW3GCwU1v1NYxb/o+L5+l5LlstTi77SjaKuQ0No+nCImIGUXZ
         IYq7egJod/CUn4u48OSu4DikSJDuNaBen7K2GKALkvI3/vh6RCy+sy7kw1KNuehxxJGV
         gESR644H2dAWDkvSchoGyZdmJMm8yXSQ8Eehixj1bxs7ZRhnWv1OXm5hntnH8KYVri6M
         vmBqVVZ0aM5Ey/zrLJdBGA+Lfj642dtXQ68aWq4dvqTjvdQVznuLiuzkRrUMOnpG7pYt
         Lrwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=Ahbqm97UA9X6sXan9XG+HLCRcdefKOFp3FssCpJpsAM=;
        b=qk0Gb/SdfKLo72Hp2jeZ4rEygzYDpOBpMRJls0pvVsxigJYpIi1p+RDczXrmqWZnJL
         d9pXBKnq7CipQd8Sybe49XvIQJ8MhNyn69eUg723BIU/mX3vJyktSGjiU1uWz9nO171h
         TxavQ/PDYob4ros9j87acyD20+FgmMagkMwJTQCq2gi4xgX7/jRQWFA5t+Lpxtn1V/Fl
         O6P40jVfRxdDfCsYGTY/kzJc5HJUliq5Uy5z8geGh0oZ0ECexoJBJo99c8KKf+n2PCyR
         Bdf2qBmO0jpVphy8y5l+2fXxS0qVrppqwAdV2aP/nKZM8zkHeV/Ye8Y9B+eSRBjwH0zD
         5OUA==
X-Gm-Message-State: AGi0PuYTEXOs3aVFgSP3yVJGhhwHtufy9IItCrRcmZ4ePoBOtW16UNp1
        SmPb9jbz5EXMKtIOcNDRlXs=
X-Google-Smtp-Source: APiQypJvrF9bKDxlIGesdD5AFp6aa6tu3kHwCP0WR3OcpMEAKTSsIpEwDYC3hc/Xq9OMs5/aZbSsDw==
X-Received: by 2002:a17:902:c40c:: with SMTP id k12mr24918627plk.238.1589359541633;
        Wed, 13 May 2020 01:45:41 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id o21sm14645570pjr.37.2020.05.13.01.45.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 01:45:41 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V5 07/15] KVM: MIPS: Use root tlb to control guest's CCA for Loongson-3
Date:   Wed, 13 May 2020 16:42:38 +0800
Message-Id: <1589359366-1669-8-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
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

