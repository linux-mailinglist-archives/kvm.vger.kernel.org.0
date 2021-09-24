Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340FE41758E
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345229AbhIXNZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345971AbhIXNZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:25:00 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550D4C061796
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:43 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id v15-20020adff68f000000b0015df51efa18so7963344wrp.16
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cwm3ilFA18I4Raa0wHdWLMhcRNJhs4J6mMJre+L2FYc=;
        b=je4bpz+fyu10bGVoeoi6Ty4HR9PtcbFNACuFRPupPpY0oUsa9yZ5kNeaIDZcv5QwY6
         CSWs6Xj0h0oAHbTrPGjEnrc19tjy+775oHQ7l2R+CvM0oc6tMMC6N5r96PgmOx00xdqu
         /v1NV17MqFCcglC9pHP1Qbu34U8sSzUZjeotVPNeCTqztX641tRp+ekL3lADIVhvVZgi
         oJRGASUfqkRJNbKb/8Affuh+LcyRMJm2VOkoMhL747e5fqGybD2S3VnDAbcslVNjbnLL
         V/H05WEymc21vdiftZeiBopLIXqyb5J/DJcRcrST4LHoIikUl1cR/NrRfsAcvyRUluMG
         Flyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cwm3ilFA18I4Raa0wHdWLMhcRNJhs4J6mMJre+L2FYc=;
        b=yRG4MYugSyIkc9gyP0S2e6/caNnCUaZhvXY/5FggnHd3b5x8uNA1B4eLM60rVnysCg
         W7Qn/2Jv6Xdsb90NaiPFpn518tTAH28T6Yq48HVD6xpbIXeEH6J2WpEFiLwDkl0um+3b
         rveT+HMVw+VQ8Jw/Wb6obmeAZ/4X0N1UGmdJn1QqDZSIKB+NsWR1vD4QASSBAYkasTi2
         zlKhuNJw9dRKztxilL0eghhVjTsC+x27Xxpny/zcNy+5kH4Pu5fHyhFUug9KDPv0SX43
         f+8uordkPDYLcEu8ttekXfPAc07xkqvInNEHDTFMGx2iytrKySlQ3o9As8k0XszztoxM
         yLyA==
X-Gm-Message-State: AOAM531uftsgNr/knD2otxXOdMv3XfOdHU/Y67FGsD4LDQ0pQdwOSkjP
        VkK5vJ7nDT0FX7/yb/xAH4xs2DlHoQ==
X-Google-Smtp-Source: ABdhPJxkPO4x4XuJuQJSrvaVgGRJ8ovLrP7eMX40+ktCtEBAvOSg0HVW16gwA36lCjJ3bdNlORdKrvWRmA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:c052:: with SMTP id u18mr1931373wmc.105.1632488081942;
 Fri, 24 Sep 2021 05:54:41 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:48 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-20-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 19/30] KVM: arm64: change calls of get_loaded_vcpu to get_loaded_vcpu_ctxt
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

get_loaded_vcpu is used only as a NULL check.
get_loaded_vcpu_ctxt fills the same role and reduces the scope.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/entry.S     | 4 ++--
 arch/arm64/kvm/hyp/nvhe/host.S | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 996bdc9555da..1804be5b7ead 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -81,10 +81,10 @@ alternative_else_nop_endif
 
 SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
 	// x2-x29,lr: vcpu regs
-	// vcpu x0-x1 on the stack
+	// vcpu ctxt x0-x1 on the stack
 
 	// If the hyp context is loaded, go straight to hyp_panic
-	get_loaded_vcpu x0, x1
+	get_loaded_vcpu_ctxt x0, x1
 	cbnz	x0, 1f
 	b	hyp_panic
 
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 2b23400e0fb3..7de2e8716f69 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -134,7 +134,7 @@ SYM_FUNC_END(__hyp_do_panic)
 	.align 7
 	/* If a guest is loaded, panic out of it. */
 	stp	x0, x1, [sp, #-16]!
-	get_loaded_vcpu x0, x1
+	get_loaded_vcpu_ctxt x0, x1
 	cbnz	x0, __guest_exit_panic
 	add	sp, sp, #16
 
-- 
2.33.0.685.g46640cef36-goog

