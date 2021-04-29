Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC8736EE11
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 18:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240822AbhD2QXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 12:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240824AbhD2QXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 12:23:37 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AEDC06138B
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 09:22:50 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id a11so4147201plh.3
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 09:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rNKQky1/Pnzp033ZdzLSy1gbwgv/Gccj40dEtj5FDpQ=;
        b=hibuFhOx/LICnV8bWJWt26zjOulR0Bk+h06aknCeZPUayat5uMBozj6Y6URHdxOKmo
         oWCzLOM6a3wwgEM5/IxOEZ13a3PdYvVz8bBYuXVuxSLIhfbSzafbXqxngWI0Y/9iMyaK
         Ov3h8xcebcTNgy+EkIBXedpgumbo+xZkXAEd8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rNKQky1/Pnzp033ZdzLSy1gbwgv/Gccj40dEtj5FDpQ=;
        b=UOKXlSE69XW2tT75rFn5+xYFGDyc/NQEEzFJRbg5a20Dcxf1Dh8zYzX/YGIpwfkbHC
         erAobah+/ceozTAR6hDxMoqjRWdabyW3CqlZ6SmpIqko4ysWQjENrrSGkLnWY8srOEMp
         GxUy+GhE1kUeMqnGlsyPfBQqk/YHZ366QedV8pUXza+v3aLWzhbuzzac5pi5CDmXQv+/
         ZIeapS/95BtyaI5xt+sjbhF3ZKHSQRR/Sw4YLMCIs9IjMh7Op0vemzb/Btk5A/fkLQ3W
         Owhu60eQ7KvzuFKCkrZ1qi6U45gU19XWGdrstLVry2D497a/Jf6tlYLPlVVMlv0xKioF
         Ay2g==
X-Gm-Message-State: AOAM533hGIWasPuierTLi64mkQTiamZRSbdQL8qNcU6nP3O2/Bpu+a0V
        Z+pIYRO/BP7KzTRimTNXUL4OIzahq1hyfw==
X-Google-Smtp-Source: ABdhPJwRmjGWAAnhyPMGDR8T8D/x+9uZM1W3/KEjblGsi/sRhDjOvkBSEMhT6+veMKoprCjdmUF2rQ==
X-Received: by 2002:a17:90b:1bc1:: with SMTP id oa1mr670125pjb.46.1619713369563;
        Thu, 29 Apr 2021 09:22:49 -0700 (PDT)
Received: from portland.c.googlers.com.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id k13sm2884271pfc.50.2021.04.29.09.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 09:22:49 -0700 (PDT)
From:   Venkatesh Srinivas <venkateshs@chromium.org>
To:     kvm@vger.kernel.org, jmattson@google.com, pbonzini@redhat.com,
        dmatlack@google.com
Cc:     Benjamin Segall <bsegall@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>
Subject: [PATCH] kvm: exit halt polling on need_resched() as well
Date:   Thu, 29 Apr 2021 16:22:34 +0000
Message-Id: <20210429162233.116849-1-venkateshs@chromium.org>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Benjamin Segall <bsegall@google.com>

single_task_running() is usually more general than need_resched()
but CFS_BANDWIDTH throttling will use resched_task() when there
is just one task to get the task to block. This was causing
long-need_resched warnings and was likely allowing VMs to
overrun their quota when halt polling.

Signed-off-by: Ben Segall <bsegall@google.com>
Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
---
 virt/kvm/kvm_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2799c6660cce..b9f12da6af0e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2973,7 +2973,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 				goto out;
 			}
 			poll_end = cur = ktime_get();
-		} while (single_task_running() && ktime_before(cur, stop));
+		} while (single_task_running() && !need_resched() &&
+			 ktime_before(cur, stop));
 	}
 
 	prepare_to_rcuwait(&vcpu->wait);
-- 
2.31.1.498.g6c1eba8ee3d-goog

