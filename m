Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B30F79B577
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236985AbjIKUuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243924AbjIKSUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 14:20:25 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795D6110
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 11:20:21 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-27372e336b2so5878621a91.1
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 11:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694456420; x=1695061220; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6uCXmp8XWw8KcKiUlypuJlmIP4lP5mWVlaSdBhgumQk=;
        b=YvVZMbf4QaZf6jnugZ6uEMctmcOuIII5DwZyUf2+bOB6t3ulStrII+9sovOu+W0rgh
         UrhPXWV1peNridMOLRlmbYaaS8APcbukIQ5pqBC4kbd3x/CXgAV3I86RqyQxZLo8Fh3p
         5Pn6Z608c47du/4XgHTQLGb2DjqafNbVj0EL4MXXp88CIAeTLkZcl5uI21rlN4YZGlwn
         NGPqFBr87UQwEuQc3SDkbFjmrmfNqAqKmxuBeFxw51tb3rKIuvsMlhqb6kEjMFijECld
         MhyvxS12zWVYDhMKAByx2fQQKMkNelSYX2IKljdI1gQxJPYhMIOegn6s1J805/hZCWXw
         hsqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694456420; x=1695061220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6uCXmp8XWw8KcKiUlypuJlmIP4lP5mWVlaSdBhgumQk=;
        b=fsrfuWXeqdYswTlPBS75rIXX6vopkcbpd6R3rJCYyayRBgP/aZ2rjgk4rVU7BmLNyn
         ZetMh6RrQiR2e0h8oqRGwuUBkYsm7eQv8hzKzXwLckpKe82dguuPaCBioTlkzWUsu2Wp
         pAMHZhZYSlSwaG+b9gRWV/q0zJ8Ptq2oWJOBpRBI+XtI7sDxIiQK202L3DXrQW2pu7O8
         CW2HTjO3x7kwNw5HErDKpriBxK7UjU2sYOQ8C7WMPUxAYntl8C0/dZSS8Q5efoI0e+PS
         fd7p8ZYl4YHhuPlTbrOGsY+5kBVVN5CypsF+2y88c6f7fLCNDNeFQAqQl/y1W7MvP+0C
         I7xg==
X-Gm-Message-State: AOJu0Yxl1t9sixn9NK1Fzp5cJCay38M3lf2qOqe2ohtk4A7A0e8BEfww
        HuQyNyAPLJQSWJOtTgPZ45MYdEow8dk=
X-Google-Smtp-Source: AGHT+IH4ncEhQm6BMvyP+YUnDS+5NrDiO/S64fH2TSdfs9VSXvxdTjFve09Gu4JsKwlBFOk+1f+GfQ1pybI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4ce3:b0:271:df54:4167 with SMTP id
 k90-20020a17090a4ce300b00271df544167mr77417pjh.3.1694456419958; Mon, 11 Sep
 2023 11:20:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 11 Sep 2023 11:20:12 -0700
In-Reply-To: <20230911182013.333559-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230911182013.333559-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230911182013.333559-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/3] nVMX: Use setup_dummy_ept() to configure
 EPT for test_ept_eptp() test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use setup_dummy_ept() instead of open coding a rough equivalent in
test_ept_eptp().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 907cbe1c..9afca475 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4658,28 +4658,17 @@ static void test_ept_eptp(void)
 	u32 primary_saved = vmcs_read(CPU_EXEC_CTRL0);
 	u32 secondary_saved = vmcs_read(CPU_EXEC_CTRL1);
 	u64 eptp_saved = vmcs_read(EPTP);
-	u32 primary = primary_saved;
-	u32 secondary = secondary_saved;
-	u64 eptp = eptp_saved;
+	u32 secondary;
+	u64 eptp;
 	u32 i, maxphysaddr;
 	u64 j, resv_bits_mask = 0;
 
-	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
-	    (ctrl_cpu_rev[1].clr & CPU_EPT))) {
-		report_skip("%s : \"CPU secondary\" and/or \"enable EPT\" exec control not supported", __func__);
-		return;
-	}
-
-	/* Support for 4-level EPT is mandatory. */
 	report(is_4_level_ept_supported(), "4-level EPT support check");
 
-	primary |= CPU_SECONDARY;
-	vmcs_write(CPU_EXEC_CTRL0, primary);
-	secondary |= CPU_EPT;
-	vmcs_write(CPU_EXEC_CTRL1, secondary);
-	eptp = (eptp & ~EPTP_PG_WALK_LEN_MASK) |
-	    (3ul << EPTP_PG_WALK_LEN_SHIFT);
-	vmcs_write(EPTP, eptp);
+	setup_dummy_ept();
+
+	secondary = vmcs_read(CPU_EXEC_CTRL1);
+	eptp = vmcs_read(EPTP);
 
 	for (i = 0; i < 8; i++) {
 		eptp = (eptp & ~EPT_MEM_TYPE_MASK) | i;
-- 
2.42.0.283.g2d96d420d3-goog

