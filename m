Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFD84CAB6E
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243620AbiCBRWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241203AbiCBRWd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:22:33 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38078C7E85
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 09:21:50 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id y28-20020aa793dc000000b004e160274e3eso1587325pff.18
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 09:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oSxJZdPqBmTb0v45xyGXjRQvnkzVXUBcU5Q8keBTlIw=;
        b=Y7ps/54eC/0QA3ldUb8EKnBlECJIsXK8QHT8pMevwQ09ueCFk5C9ccYoNSdU7XcEew
         ViEDOXicHKjz+H4fnuKYAYB78gRMqWxFOtAto/ppQLmGFpu4XhILCDGVc5SuzrLkAobn
         w/WvGLrpiNSD58tnMGaAOxfGOmXmKFCPQ5IquJoJumjqCfx67Z/YUefIBIC6D94hTYkr
         cXER52zKa/CTCzdAW8nPcOA3UdS3lBBwQO9WXJhzAlExe2SveVMVR4NGFFLCKLKuRtlE
         +Loiw2cJANf+b16FYRteXLwsNVj0FcWB0PxweSdbtCC15DhrnKRk+xzt6xHXoeDkRNbC
         wfJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oSxJZdPqBmTb0v45xyGXjRQvnkzVXUBcU5Q8keBTlIw=;
        b=K1Pt8giQ4ZwuHqcySqYi+d5vBC3xW8PIWp1hcZNq/Smi3HbYxQDy1y3E5IGvYiBkbR
         npoaldBsQZNmNuHe5M/hIV60yGeZ7jt2BvggSwe4btggQHcLYBG13kxNJ6kcdYENrOn7
         JOD3c3Rqk5OjtpnNFWMYn0ILO026VmFRgqhNjG1jBa+sNuG70AIyiDO8q9ljh3QFb8Sl
         aDtvyA211uHPks9OzvJQ4V4sUpL9WdZV06EocvESWhoz5VXbZF0+6CHRoLwtoNErL/Fh
         IVr/sM5ZHUeTdmA2183FlFpMykB6zuu7ztbCRAoVYnXJLlJf1uTqyz8HDM1Y9Gamh+lk
         B06w==
X-Gm-Message-State: AOAM533t8ix3kov0lxetUd8V9QLBg4fafGdQDquvJ76eUhjXgcKBSYob
        JvlvEvB/tB9zrVtEocIWh/VmrObK+xFaq8ANVy66hG1H1fxAsjCfPC1f3fRoC/qvGW0Oe4aGVXM
        KrY2izxT/ULURm/qhykFH/EobQ/0xGJwF6IcDcYIs+P14ubrq9UFBFCHsx+cESbU=
X-Google-Smtp-Source: ABdhPJxa86h9ycOOhd+6pnQ3kRI6Am1texhgSG+wImUc8MVyXQMzuu0pRRJkDxa4oX0fEsBIFeLKVjtQvn5H5Q==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:9292:b0:1bd:1bf0:30e6 with SMTP
 id n18-20020a17090a929200b001bd1bf030e6mr831494pjo.73.1646241709583; Wed, 02
 Mar 2022 09:21:49 -0800 (PST)
Date:   Wed,  2 Mar 2022 09:21:42 -0800
In-Reply-To: <20220302172144.2734258-1-ricarkol@google.com>
Message-Id: <20220302172144.2734258-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220302172144.2734258-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH 1/3] KVM: arm64: selftests: add timer_get_tval() lib function
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add timer_get_tval() into the arch timer library functions in
selftests/kvm. Bonus: change the set_tval function to get an int32_t
(tval is signed).

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/arch_timer.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
index cb7c03de3a21..93f35a4fc1aa 100644
--- a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
+++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
@@ -79,7 +79,7 @@ static inline uint64_t timer_get_cval(enum arch_timer timer)
 	return 0;
 }
 
-static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
+static inline void timer_set_tval(enum arch_timer timer, int32_t tval)
 {
 	switch (timer) {
 	case VIRTUAL:
@@ -95,6 +95,22 @@ static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
 	isb();
 }
 
+static inline int32_t timer_get_tval(enum arch_timer timer)
+{
+	isb();
+	switch (timer) {
+	case VIRTUAL:
+		return (int32_t)read_sysreg(cntv_tval_el0);
+	case PHYSICAL:
+		return (int32_t)read_sysreg(cntp_tval_el0);
+	default:
+		GUEST_ASSERT_1(0, timer);
+	}
+
+	/* We should not reach here */
+	return 0;
+}
+
 static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
 {
 	switch (timer) {
-- 
2.35.1.574.g5d30c73bfb-goog

