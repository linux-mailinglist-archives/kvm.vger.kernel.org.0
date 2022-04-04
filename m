Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C474F1EDC
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 00:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242787AbiDDWYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 18:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350605AbiDDWUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 18:20:45 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924E41098
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 14:46:48 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id lr15-20020a17090b4b8f00b001c646e432baso306257pjb.3
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 14:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=X0Eqwo1ZquA6BfDuIBc3jv4V/VhgN11Hle1bIEmosEc=;
        b=RvR9/xm2sTOKqL4Ey7mY8e6IBFYpDTDkZb7nMkyCptp6xczgVBQJ0GHp1KQBqXMea0
         AyMVPgW60UGoArOqgkLM5AmUn2GD8ry6vw5en7ZWwNLm9ti0rqfYNWh6kS6FSaa6hU8N
         TMYHlznwFItOJZruV0bSzznwi0bwcDqXIyTnT+vDYRsABnXLq1TrTyrnln4xFtIYlPhc
         cKn5Pw+jseSynJMMw9dFe089573EY5dCWvPpiZvr3IAKrri7OfIx50hd6rYhjOjBRQtJ
         0CD0FN0fE+O31HR83627xsCqft1PBWqn9TIx3h2o9r3eopjBUI5AO+KeIawNcX22WXWg
         h93Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=X0Eqwo1ZquA6BfDuIBc3jv4V/VhgN11Hle1bIEmosEc=;
        b=Z6UBGyzVS3yV9JkePFUDefOEsHFx2ILVgJeFt5rT+T88S1YVH1RofJv40Vxx/g597m
         75/RPFnCv7E/4a13CdseehYnH8IoLylyeZFQ8eF6IIbpd6zBIDpyFsH3GbmIFEXaIQlu
         aDW53OnfpJIp+xwVX7nP8KcJeMAx8lC/9cGChdy7txvlheDwry1eSojE8RF5F2ek+aNj
         CEQ/9CQuYPcYh8mzJOg895uCFDhHWp753PwgTtjb8KS9Odu3j0hccnozA04ma5ADw6q2
         e+jX8B8Qvd/3GSrrCr2yZGvZ3lmEytS5pCSaWXwwdWvFvqLfYAx7XxGtlP0MmzWBnZEn
         Uo1g==
X-Gm-Message-State: AOAM533BESOEdSwe7LCMsbbcGuIW55of6TFfW4yqFxikOztYxqJwCVhO
        4PA1lNr2uf7yCTZtnb+fshOJkt4oMioBDhiECcG3aty8jkBmNF/8pF72HV3Yj6/InQwGJRZYbRp
        QHALBf4kV/nL4EHH161CAUb1NdLCzNIkn7CarbhTG21h4h4F2fMYs3cov6aD7L1s=
X-Google-Smtp-Source: ABdhPJzWUiVyZnp4hJzDOKmy+w+tHcRBborB+zzQYM4y5M3UwVHtIXcVRL7fth5SAn7e2ZEZ0Y91i+LtJoj5/Q==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:bd95:b0:14f:40ab:270e with SMTP
 id q21-20020a170902bd9500b0014f40ab270emr215490pls.101.1649108807930; Mon, 04
 Apr 2022 14:46:47 -0700 (PDT)
Date:   Mon,  4 Apr 2022 14:46:39 -0700
In-Reply-To: <20220404214642.3201659-1-ricarkol@google.com>
Message-Id: <20220404214642.3201659-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220404214642.3201659-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v4 1/4] KVM: arm64: selftests: add timer_get_tval() lib function
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
2.35.1.1094.g7c7d902a7c-goog

