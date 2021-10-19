Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B498F4335C5
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 14:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbhJSMVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 08:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhJSMVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 08:21:18 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6C0C06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 05:19:05 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so2518957pjb.4
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 05:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=nTgW/IuVY6FOmd2NIqc+LkXN9w9F4uGLer3FYQNnChY=;
        b=vRVpLNdC0d06O3y1Z0BSlXE+wLrVMVxYcmt1WeBJ6YzJz7ek/pAdvFXjkjl6qJXA1/
         z0tyEzZ+JcRSW//cb6R1MHx2mGuJX7AgNG+3Z9+GI5Rv31hoz3gmV11WDhOgUKsfxaX9
         W6Gx+2/i4OiaTNNEboGj1sCfRpHPTuHW3JzkGs5VJkRYBIb0T0n/nBUakRBy1Yy0p3Kj
         fXfdl7XsB2OCe0IrkGf3eqFGs5W+IGCkgA3BK1fpPeOg1q12Uv9KCeOPj9xATPKA0lzl
         Kmdp1brBk119571HMkeJ5BM3Cr0OJdDPkXdW9Dr22kVXDJpGWR/pOsiDfRKU+iGW+cYg
         O4VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nTgW/IuVY6FOmd2NIqc+LkXN9w9F4uGLer3FYQNnChY=;
        b=RIH8FTGFFU8B12j1CJce/c7R6NsI/72tdnnR0EZQQzWt6sMmoPwUlUnyFYkMd9bw8R
         L/d5FvwzSq7THB0eRFfC5uI8M8pg1dMXZoRz8F8Lns+y5ASelOC396b1ARclW/EL2Jn6
         xKikAITyf2DF0bTPc02U2iI8D0t5z6ohTim6dnbkAz7TsowoAnr4xIN1HYrIDye4xx/d
         AYJ04IDGZJZqqMBGBpaAV5tFoTPm8f3nJ5WbVqHGq8AQmsQU+YAy25qz4yWxJfNbtz7u
         Dd4gIghs5Td84WIvOwn/9ExiC6P4Il2VD7lvab/nFMhSdsbBBaIRevuB3rQfWRA3Uc4X
         3LSg==
X-Gm-Message-State: AOAM532V1nPe8vKjMSkVVokdwvNodwoSh5t/lp/xr5A4Yw9jhq5uCTvp
        nuqUnCLfnvwV/EpcxbwvJMJ0AQ==
X-Google-Smtp-Source: ABdhPJx7mnBn9ls5XGxsDyhP3V4prK+OAh40Vd2NAboQVPTtdY9c8YiI3F3pxxgUXLdN8f+mGrEcow==
X-Received: by 2002:a17:90a:ba94:: with SMTP id t20mr6293863pjr.138.1634645945075;
        Tue, 19 Oct 2021 05:19:05 -0700 (PDT)
Received: from n210-191-019.byted.org ([49.7.44.97])
        by smtp.googlemail.com with ESMTPSA id i12sm16338331pfo.126.2021.10.19.05.18.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Oct 2021 05:19:04 -0700 (PDT)
From:   Li Yu <liyu.yukiteru@bytedance.com>
To:     pbonzini@redhat.com
Cc:     liyu.yukiteru@bytedance.com,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Warn on nx_huge_pages when initializing kvm
Date:   Tue, 19 Oct 2021 20:18:48 +0800
Message-Id: <20211019121848.245347-1-liyu.yukiteru@bytedance.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add warning when `nx_huge_pages` is enabled by kvm mmu for hint that
huge pages may be splited by kernel.

Signed-off-by: Li Yu <liyu.yukiteru@bytedance.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1a64ba5b9437..b75dbaf29f2d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6091,12 +6091,17 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 	return 0;
 }
 
+#define ITLB_MULTIHIT_MSG "iTLB multi-hit CPU bug present and cpu mitigations enabled, huge pages may be splited by kernel for security. See CVE-2018-12207 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/multihit.html for details.\n"
+
 int kvm_mmu_module_init(void)
 {
 	int ret = -ENOMEM;
 
-	if (nx_huge_pages == -1)
+	if (nx_huge_pages == -1) {
 		__set_nx_huge_pages(get_nx_auto_mode());
+		if (is_nx_huge_page_enabled())
+			pr_warn_once(ITLB_MULTIHIT_MSG);
+	}
 
 	/*
 	 * MMU roles use union aliasing which is, generally speaking, an
-- 
2.11.0

