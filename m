Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB1A31A63A0
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 09:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgDMHZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 03:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbgDMHZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 03:25:46 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5C8C008651;
        Mon, 13 Apr 2020 00:25:46 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id h11so3106460plk.7;
        Mon, 13 Apr 2020 00:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rcr3r7EHKTN20QWo1cHUmhcCCOh7xy4CEyh5IWphRGk=;
        b=hjEyoehEw9UiB64zs266aysB8Fech4XcqTwQUvT8cKrEH/MwgwN0vaZZFZWBXbaxEs
         2VLmeoun9JWg3PbInHrMXSP0qONm/51gRkxx8p6mWe14O07jdRQKL2meU7uk6Xg/sQ0Z
         yi5C13ie0/ddCU+RXouid0RzEhQN1OwesDWaxiVLkAsnHbgqRjkl70h/jyKWMzlgeMeC
         uqUaN3+CSbb8zi+H4NeC0vpHAXeZo3+vsT/CB4zLL9++5c9T3bK/scGget+jFE60g74C
         f1+lNuEjbfD88NpaPXXpyUMbaHv7JUSx4RrOrhIM2FpZ4ZSZ1xAPfEKyNg8ckNizszn7
         /qbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=rcr3r7EHKTN20QWo1cHUmhcCCOh7xy4CEyh5IWphRGk=;
        b=J6kfWxmqSQFJgGzcpB/Fs/Q45u7GnuTA7ui2/+/xJkpAiwmcwVhejcfwXdWwNuwpHV
         M/y+M/1qiR+XChhkaNLqaP6CuPnN9CgC38oIkH6gVTHTdj3Kt2SP2sYqiTz4gnzw2YKg
         bfCbudLqw85LFQiIYfL/QlANstUWxy/xlQkWZb4xVqOSGZXoijhnBrFfGgneFXaJ9xhv
         WglTy3hPUVZCW0WjLDOwZ0dYOOuIC7l3x+SXu4CMkouSuSlo1D5In7N/9+HQ4Qo8LdEx
         Gz9W7z0N9094FpxkNl2qn4yNLVxcsjGwgIgpmZiDtlNJ3XiDK2ss9w2fQnochtLRkWZ6
         M1/g==
X-Gm-Message-State: AGi0PuYX/4gSXmf/ABB6yIEC8OcuIKV/DmvzfbFs+UhuH14MAVyc7tx+
        QU1umGcGJwQULBKMEVIwCnA=
X-Google-Smtp-Source: APiQypJ7sYB35a50kXkyVw2AqbaMP+yLekJXXIv+HR2IAM6iz4MvwvlOfVTeyYhgzICPnycZFBqg+g==
X-Received: by 2002:a17:90a:e50a:: with SMTP id t10mr21330556pjy.110.1586762746231;
        Mon, 13 Apr 2020 00:25:46 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id u8sm7241341pgl.19.2020.04.13.00.25.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2020 00:25:45 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH 08/15] KVM: MIPS: Use root tlb to control guest's CCA for Loongson-3
Date:   Mon, 13 Apr 2020 15:30:17 +0800
Message-Id: <1586763024-12197-9-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
References: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
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
 arch/mips/kvm/vz.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 422cd06..e30ebb2 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -2871,6 +2871,10 @@ static int kvm_vz_hardware_enable(void)
 	if (cpu_has_guestctl2)
 		clear_c0_guestctl2(0x3f << 10);
 
+	/* Control guest CCA attribute */
+	if (cpu_has_csr())
+		csr_writel(csr_readl(0xffffffec) | 0x1, 0xffffffec);
+
 	return 0;
 }
 
-- 
2.7.0

