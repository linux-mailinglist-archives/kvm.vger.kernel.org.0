Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925855195EA
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 05:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344340AbiEDD2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 23:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344222AbiEDD2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 23:28:42 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB44927B3B
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 20:25:02 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id z5-20020a170902ccc500b0015716eaec65so135860ple.14
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 20:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+AoiNQohcEBqsbFrIdWlY/jTmle8ckchXi1SWA9QWT4=;
        b=kav6fAe1UysMDmLFspwmQhdq94eATQWRRD1D9FV5BfsaCSNOmOrjNgw6Ih/qFB2hFP
         KkA0WphPrzKlAu7jLnUAmQlX9FxYxSL5XR/uR+7vhqMeF14/CJ1Lt7Kk8/RxOE8/HMsv
         9JA82R2w68LQCsjI+e2gky3CzbW1HNlOH5uc/fpUkHWRQJ9nbE4Edyxw55yDZ4+3d6AW
         5DowfDS5+gFo08tAcOKj+dsadR4mQG1ftNfhXsKGd4iAq4zK/Abw/PW3qZYMuB5D+YT7
         AtmKcQmParWgFNt2qlDPmkDx4K/08wQcTSDWA15Oj5c4uttCowpHBr0chaueffn/vOC1
         S9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+AoiNQohcEBqsbFrIdWlY/jTmle8ckchXi1SWA9QWT4=;
        b=Lt0Sze3TDtizTy3lH1lsWh0h3PCImYQObhDvQtQr9lGud0ccTMUrrFm6bfTC2Q0zZH
         n7bN11ugQLHakX0AP+FDwkIfbZQnSVwfaABwmEhgtoAuKeuGbh+AiqhbaJW/bQq10uSq
         BImWNyaS1LSRGj9XrBOsK3NAEvEJuhiTOHYEtuBotqPaAm8+780KystRr8E6kJfr8tt/
         pkWwcGZ4/IPvkOwbEZdsE9EM5XT6R7551z/u6Th4425uaoDTmn7nYMreqRL1O8Xb2iHr
         1hW9rUH/CLmYxvPXXHhFmvoYXAfIiqhDui5RXgRct6u+xBycZcHrUzfydxkYnBFG+DJh
         yz7A==
X-Gm-Message-State: AOAM532zfjJ78Wh8mxvrvlGQmycfshzIZzLvP57ylyEOHGjVUfw1J5b3
        jdEfje2qEVgIQVskWerUgfOfyN0XWdc=
X-Google-Smtp-Source: ABdhPJw5sIvY/+awP297IVop+k4KJmX4BmEL6dH1itNwUhQj0x3knFEX3fPK00huIqDZftTudy2YPYs+Wk8=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a05:6a02:197:b0:382:a4b0:b9a8 with SMTP id
 bj23-20020a056a02019700b00382a4b0b9a8mr16376625pgb.325.1651634702101; Tue, 03
 May 2022 20:25:02 -0700 (PDT)
Date:   Wed,  4 May 2022 03:24:39 +0000
In-Reply-To: <20220504032446.4133305-1-oupton@google.com>
Message-Id: <20220504032446.4133305-6-oupton@google.com>
Mime-Version: 1.0
References: <20220504032446.4133305-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 05/12] KVM: arm64: Return a value from check_vcpu_requests()
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        reijiw@google.com, ricarkol@google.com,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A subsequent change to KVM will introduce a vCPU request that could
result in an exit to userspace. Change check_vcpu_requests() to return a
value and document the function. Unconditionally return 1 for now.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/arm.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 77b8b870c0fc..efe54aba5cce 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -648,7 +648,16 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
-static void check_vcpu_requests(struct kvm_vcpu *vcpu)
+/**
+ * check_vcpu_requests - check and handle pending vCPU requests
+ * @vcpu:	the VCPU pointer
+ *
+ * Return: 1 if we should enter the guest
+ *	   0 if we should exit to userspace
+ *	   < 0 if we should exit to userspace, where the return value indicates
+ *	   an error
+ */
+static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
@@ -678,6 +687,8 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 			kvm_pmu_handle_pmcr(vcpu,
 					    __vcpu_sys_reg(vcpu, PMCR_EL0));
 	}
+
+	return 1;
 }
 
 static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
@@ -793,7 +804,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (!ret)
 			ret = 1;
 
-		check_vcpu_requests(vcpu);
+		if (ret > 0)
+			ret = check_vcpu_requests(vcpu);
 
 		/*
 		 * Preparing the interrupts to be injected also
-- 
2.36.0.464.gb9c8b46e94-goog

