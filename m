Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E17E9FB2CE
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 15:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbfKMOrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 09:47:23 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42519 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727427AbfKMOrX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 09:47:23 -0500
Received: by mail-wr1-f66.google.com with SMTP id a15so2664378wrf.9;
        Wed, 13 Nov 2019 06:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=qTf6OInkFeP/tR4a5XNbnzc1z5smkpFf/IpOmURtbuc=;
        b=vZuLGk/nVtijHr9Kilg6ZBK895kTu/XM7cKyHKf9COBFgxzrbQr1CjqtyKhRJtF4P+
         IRa7btP+Z+0cR6dgHFYgwYKm87q7pzXKpJTJ2h0GzWm9nzD6CYCg5fp1mg0Z6j7k6Atx
         rQjBOee1tpDjsW7R2gBEypGysSfCruxIJIFWY0+Gtg0hPTk9g4wzlR7XdYGKYdj7JEpm
         3HHN/tl+sYVcmkbPzVbfr7XpobEjGuY3ox4pcFAU69DglvdfDEO/IJTURFpCKS2qW2On
         am9TgSJ7bb/PItdJ93PZ8sS57wU+Qcub/xeOeQF4d+Q0OZ8qrP/BMxabGbYD240odgEb
         olVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=qTf6OInkFeP/tR4a5XNbnzc1z5smkpFf/IpOmURtbuc=;
        b=Rp6Djwi2h0zPrITPtrLVNDhjAgDrV/wiT2gM2iIG/x+tAidXcHWnkk/6nRtp3cAbLY
         IIwrRyLLPfbn8vTpXPgQfVZGhR+uwH9RQQVeZul1MpU/kskiVWo43RJJIJKRbLjUJinn
         t/RzFc3k7xnpjXqCnk3Lq8j+mYUJF4cveVIjVRpx25nn2Xq8YxYVS1X9ioe3q/IunUuY
         J3SKKC4XLXN8bXAijnwZnvUDpL22lREH2WGEHeF1o3v6Eo8NhO/ZlxYhIX3o7o0g6jaP
         GdnR0/eHYZWZ0Nknlc37w9bcSTVyB5K0R2xCPP6dJ0OrdJVJ7u3EwVVlS33zyU4WQRIK
         K1Jw==
X-Gm-Message-State: APjAAAXgruR1uaHKk9VSWKdRrAcc206RKNb28+74rz88elCDmo9aET+8
        r9ufjYfw2hidX2uu20GkdgfbB9zG
X-Google-Smtp-Source: APXvYqzo/tFGlzvRU9JFceav+G+zHg9Teitj9o8fi17xEh3Hfl1qOfNKyMDpGEHPNxCZPr4ImVLvEA==
X-Received: by 2002:adf:c449:: with SMTP id a9mr3097160wrg.240.1573656440997;
        Wed, 13 Nov 2019 06:47:20 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 189sm2807631wme.28.2019.11.13.06.47.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Nov 2019 06:47:20 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] kvm: x86: disable shattered huge page recovery for PREEMPT_RT.
Date:   Wed, 13 Nov 2019 15:47:19 +0100
Message-Id: <1573656439-16252-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a huge page is recovered (and becomes no executable) while another
thread is executing it, the resulting contention on mmu_lock can cause
latency spikes.  Disabling recovery for PREEMPT_RT kernels fixes this
issue.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index fd6012eef9c9..cf718fa23dff 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -51,7 +51,12 @@
 extern bool itlb_multihit_kvm_mitigation;
 
 static int __read_mostly nx_huge_pages = -1;
+#ifdef CONFIG_PREEMPT_RT
+/* Recovery can cause latency spikes, disable it for PREEMPT_RT.  */
+static uint __read_mostly nx_huge_pages_recovery_ratio = 0;
+#else
 static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
+#endif
 
 static int set_nx_huge_pages(const char *val, const struct kernel_param *kp);
 static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel_param *kp);
-- 
1.8.3.1

