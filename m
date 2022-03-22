Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8154E44F6
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239555AbiCVRYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239560AbiCVRYy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:24:54 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8BD13FA0
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:23:24 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id b5-20020a170902b60500b001532ec9005aso2717848pls.10
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7ggpAtHNiDJ+NnsLo7ScZ5icbm1fKGUxqGcBJCAEY6Y=;
        b=mqg3pc+6i6V/WC/2nUh0x/0RXtMDSlRE8rCEA2QSpbd1/19ON/Ef3H/Q8YD6UH990U
         m5SSErCS/i5EZsNXySHNv0yPxAr6sKj6Id5hTc7JjuTIkR7k354RVJ20WCuPNIP8Dsii
         z3pujgswQD40fhtW31IvyoXmCvfKEP8wlB/HWBP5bWl2cO2YiRaeAVCry5w+6q4qmysy
         6wED+XCVQ1UVCxtFf9om1e+mzHzxzR92DpatXmSRRuUDR46jm38sUkojVr9OxBILR2QD
         4OclWsiNpSxfBpE2qlcj7w7lHF0etmhBlMBUjYdfD+juEHJbC/PpMSWGjBvg6JX+7e1/
         CtoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7ggpAtHNiDJ+NnsLo7ScZ5icbm1fKGUxqGcBJCAEY6Y=;
        b=XPJ4vIDP0XJoEOClmWZMt0bzyo+fry7/EJA6jIK1+utv+7oW2j4CMPUIxdpWy6vifV
         W/gnp4gOAO9hacEBSRa8msy+yl8wcqiKpPSoxQ16jy4xMg5xZNY1IWSASFpqqhkkO6Ws
         Jy4d8iYWOouK2IP2YrTsRhVnQ1B3CZCzArCAJe7JwA8ltU16zT/ttT3HlYs0eyIHgEmO
         m5nn5T3mWPZhanaq1J2z5NZj5aXmDjQn9+q7ndFE9qBx6x9irIYvmIGO/ndm6O8lv7Y8
         6leby57T6xYlgm0B78yqzkQUXTR/UTlGqMtkj/irdKlO5EN2ngOf1qCFHfqJro2dscqH
         Oi2A==
X-Gm-Message-State: AOAM5319IFu+dQLfvyzFS5EC7JOQrnU/Vl9/dYRjV+Mdc3hSDdcEW11P
        w5Tb5gi2ED7IYLQ5KeIef8x/1JzU7T+BOrvDO1qmyFtPY0ydWP06MheNJ/8Dr4trO7KRh8gDyyh
        T8tZIPvHqu4kBoC22Hx3ijDNCjCLcyMjPtMehZRDbHQgtVDo9XPKrPcndS5dqaVM=
X-Google-Smtp-Source: ABdhPJyhU7hmeOiqa0P0D3pB5tvCb/IIOpleA1rmE8VxLD5P5L6UlLlxLsc3gmLGCUOoq3qoZytbYSHsU4UJ7Q==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:2288:b0:154:50ba:2e31 with SMTP
 id b8-20020a170903228800b0015450ba2e31mr12250063plh.132.1647969804148; Tue,
 22 Mar 2022 10:23:24 -0700 (PDT)
Date:   Tue, 22 Mar 2022 10:23:16 -0700
In-Reply-To: <20220322172319.2943101-1-ricarkol@google.com>
Message-Id: <20220322172319.2943101-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220322172319.2943101-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v3 1/4] KVM: arm64: selftests: add timer_get_tval() lib function
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
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

Reviewed-by: Oliver Upton <oupton@google.com>
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
2.35.1.894.gb6a874cedc-goog

