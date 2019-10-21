Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 153F4DF8B4
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 01:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730331AbfJUXeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 19:34:02 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:43993 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730320AbfJUXeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 19:34:02 -0400
Received: by mail-vk1-f201.google.com with SMTP id w1so6846621vkd.10
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 16:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OqOZju9RKnbhVqWacaEhaH+SHbqA+diLsNw/+SjmwPs=;
        b=IhWj62dTmkrROqQaazxCILFoTalPIJjZDtxC5du7gIqBLjfnxVmSc+X++fw37O9xZ3
         jqXs3cKhJynygP5/MrJiQQ7I8rep6Y2HwN8miFfnqHjLJl9mtRFw2WtjTUNu7eWHQV3y
         8eov2HkU4JhMxwlq3splTJyEhMBhyRKLGkn26WPVHbAirp14ZOi8cuAu/q6seQscPQIm
         v8NaeVs06U0hawIAo46nA3eaw70tF9CSmEi4+FDpPPCZYmsxdEOPaBymbK0rklSC9rvZ
         USmMrZKQjksNaZdDFw9VfKetPcv8M6tewR3XpYdN6d6hNkMN8do/FRxSi/Tz3lv8VLTE
         N2ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OqOZju9RKnbhVqWacaEhaH+SHbqA+diLsNw/+SjmwPs=;
        b=XPogMRfR5OKeLykVT3zX37X8xkDkF7T/oEJj12o9ou4OVL1BVBd6oI1xFSjkdWhHMn
         13Oz2ayN9XK+zSpKEiV59QQL1MGyvNLLP0QPxrA1cTtGZftiEDwo6w5SAgac3rA+yL8M
         tmcUHV6apLLZZDB44cKRN9lHuJiGztTI2Llvkel31hi5iVj4LY+x/mWhp0xuSjoiB4i0
         BrzDC0VjpRGvQWPIIj9MCB9PSzPr/zGOa3JWot2XgDK7wWwEQ3miQqX1/IfU+a2wyAi7
         eo63RgW1xuktacbw7HSx+7JAAA6RGBumS1BDF1zaxm6bCBA+PBoclAiiOfa/yeMYuXiC
         2gww==
X-Gm-Message-State: APjAAAV8EKlnkUBEMxl/tuVmCO5B/23v0sbYDtLhPecJ+mcznnqj1QnP
        enZSD5/JXWrGPUoUfAss6zK+cjf4ZEEjTOMj
X-Google-Smtp-Source: APXvYqy1kkSZtw5oiFhDbR4OIceRK+DLB3sybEOM/KssnnCWfMdd/ayEoTI9cWeI8GGweEtrThl4PX2okUo1HTZx
X-Received: by 2002:a1f:364d:: with SMTP id d74mr328831vka.63.1571700839587;
 Mon, 21 Oct 2019 16:33:59 -0700 (PDT)
Date:   Mon, 21 Oct 2019 16:30:27 -0700
In-Reply-To: <20191021233027.21566-1-aaronlewis@google.com>
Message-Id: <20191021233027.21566-9-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191021233027.21566-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v3 8/9] kvm: svm: Update svm_xsaves_supported
From:   Aaron Lewis <aaronlewis@google.com>
To:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD CPUs now support XSAVES in a limited fashion (they require IA32_XSS
to be zero).

AMD has no equivalent of Intel's "Enable XSAVES/XRSTORS" VM-execution
control. Instead, XSAVES is always available to the guest when supported
on the host.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Change-Id: I40dc2c682eb0d38c2208d95d5eb7bbb6c47f6317
---
 arch/x86/kvm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 36d1cfd45c60..dd8a6418d56c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5965,7 +5965,7 @@ static bool svm_mpx_supported(void)
 
 static bool svm_xsaves_supported(void)
 {
-	return false;
+	return boot_cpu_has(X86_FEATURE_XSAVES);
 }
 
 static bool svm_umip_emulated(void)
-- 
2.23.0.866.gb869b98d4c-goog

