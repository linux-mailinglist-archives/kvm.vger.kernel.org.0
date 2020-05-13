Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6E61D0B1F
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 10:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730296AbgEMIp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 04:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730213AbgEMIp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 04:45:56 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E98C061A0C;
        Wed, 13 May 2020 01:45:56 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id b8so6553134plm.11;
        Wed, 13 May 2020 01:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L2RqfqhSc+H+ePr34TV4/iissQYNA9v85c7Lc6tpCIk=;
        b=FAxWV5qgJ5/rWYAw2Ikxhr06vwFKeKQLPMnt1twZu/O38MghvslqT1CjwiXSCE2GZN
         4Q9GC3+ZXZN6Q9pqHatkrmPBJ+h/7j4v6ICkpczOJcKde5yR8G0PNAbMBtO4MPZm+NRt
         ixMmSbYViXxqniYf0gXK5ctxVq0WZA0Bl7qm+4sYTR/8FNmWjdiM8a8+IGwl7YzCIgtp
         oozA3En7SwVNgF4k2YMjfUci3ydo/R4D2BdzMN7huBof3PGRXUFNPigSWb2F9IM4XClL
         hE9lm970OS5o7dnSIc68p2tkW73GkAz5Xj4RqanBxIO9TYF/ywJVZtX088oRmcwtTTmE
         9UmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=L2RqfqhSc+H+ePr34TV4/iissQYNA9v85c7Lc6tpCIk=;
        b=IDdY/HAzWPgIV5Xc21BLjnDOAX4w4v7m9gfqvgp3/ctsWpf9o/YhJPdSqq1iXz2qMT
         ulcUuru1VU9+KpSM9Q4uuY7/q82fN4XFkGfPCRQOYNYhGh+1neHnYaz9BXTJg+dDbskH
         XA9rlu+3xIafqUkz5UMrDQOkcZsGcq2YiGS+55NKleUjsdGvxjPEFWP3S6ruh6Ml/EyI
         LPHhHrD/XLfwAjQAFqj0ktP9uPMDK+wI6hZbq1v+ljntrKthDYImBQp26iGDZ1blth/+
         zTdhNz3XhPROur66bcTyE4NX3Jq3dyyVfcweitYtaHZ622cFrVrDjl9GPnZMNqEDEUep
         quDg==
X-Gm-Message-State: AGi0PuaSm0X/hiSgq3k2t18kEGqjA1gR5UvRPGCTJoCcf009aJ9cQ8dL
        aRyztlwwSX9IuzBSXMBSYUo=
X-Google-Smtp-Source: APiQypJu8dtu8vgNJlbGkvSv63g6MtziL8A7gJxae8L9eNAuiPmff2QkDwaFzhAZENttA7VcWxqPFA==
X-Received: by 2002:a17:90a:784c:: with SMTP id y12mr33911867pjl.124.1589359556043;
        Wed, 13 May 2020 01:45:56 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id o21sm14645570pjr.37.2020.05.13.01.45.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 01:45:55 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V5 08/15] KVM: MIPS: Let indexed cacheops cause guest exit on Loongson-3
Date:   Wed, 13 May 2020 16:42:39 +0800
Message-Id: <1589359366-1669-9-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
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

