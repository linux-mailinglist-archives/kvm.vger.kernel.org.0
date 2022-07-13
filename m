Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C28573651
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 14:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbiGMMZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 08:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236387AbiGMMZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 08:25:43 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA5FCC7BF;
        Wed, 13 Jul 2022 05:25:37 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x184so10102106pfx.2;
        Wed, 13 Jul 2022 05:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vMzQD9O55lJzNyZFNJ1xoHaqPwdV3msqkHZ+m49+h34=;
        b=WydBXzVEYu/cVe7J6XyAmfLhj+dAt0yf5xvx+xbKudRn2JX+4II6KY09dQg67oIUj/
         9T01SiKabL7tUSW/s1ymM1a5mrBIJDpbjDKCHJOYtAGdTwdmCGMfMU96c9OZfdb1k4gd
         r2abQ4UZnmkdQv800qzAcvG1NEyqWIVoCt+1KWYhGVD0sanZivzkJjDGTLjDc6zGUpDX
         1jQbR7CMXxBXsp0MduVqg9D/exfIA6EfJQyVOL03aBqELQZSgmSfueu/RxzfgPK5RDlI
         nWO8fjH2tXhbbA0oA6DVl78qt4j+GDWG1Sx8HeRl58rcjCba9naJ5qMoCOdU5PA9tYPo
         Scfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vMzQD9O55lJzNyZFNJ1xoHaqPwdV3msqkHZ+m49+h34=;
        b=lCw3KRe5YuMYLU9ByJxH15AMvkj7uh1UZiu+cJKEXPRzyRd4Rtt+g1zmWYgN7QMn4w
         +p1ANOJHkC7pi8AN2U60XmtThqW7SG4UfPC6T/aQWdLXFGLp6BEUb2IBhWRyC2tjVBhc
         gcrsmBsaftfaJUeR01L7daqc9/9+dLdmnA7M5I1zChJiai6Bs1cJytZceFZduSrCmFQl
         n92uEfqmii25CmPaVizB5zv4UjOtblzBS/4w7ITWTg8CyOUtVKoetfX16e3lNiUwnu+9
         ItjXgcuIDDZbEluNB2TASOYgaHpzMPorE78Ml9FAbA7XWeuyFaKv9BuprLcGiw4h/xjn
         yCkA==
X-Gm-Message-State: AJIora8Y2sLcn63H8xzEpLWdjqhrRN4Hd+iJy4JQNbZfR8LG0Fp4gUly
        Zs9AsgURhXxJ9iYn7hd9jtazcLxYFno=
X-Google-Smtp-Source: AGRyM1tY8so1ixNTckOPXhzC2LOBUE2mscDc3wZqmnE/E+iykXN/TgGwaDMgSj9CKy2VCVzGNiD/2Q==
X-Received: by 2002:a05:6a00:1589:b0:52a:eb00:71d8 with SMTP id u9-20020a056a00158900b0052aeb0071d8mr2850797pfk.38.1657715136251;
        Wed, 13 Jul 2022 05:25:36 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m7-20020a170902bb8700b0016bf1ed3489sm8719233pls.143.2022.07.13.05.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 05:25:35 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 4/7] KVM: x86/pmu: Not to generate PEBS records for emulated instructions
Date:   Wed, 13 Jul 2022 20:25:03 +0800
Message-Id: <20220713122507.29236-5-likexu@tencent.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713122507.29236-1-likexu@tencent.com>
References: <20220713122507.29236-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The KVM accumulate an enabeld counter for at least INSTRUCTIONS or
BRANCH_INSTRUCTION hw event from any KVM emulated instructions,
generating emulated overflow interrupt on counter overflow, which
in theory should also happen when the PEBS counter overflows but
it currently lacks this part of the underlying support (e.g. through
software injection of records in the irq context or a lazy approach).

In this case, KVM skips the injection of this BUFFER_OVF PMI (effectively
dropping one PEBS record) and let the overflow counter move on. The loss
of a single sample does not introduce a loss of accuracy, but is easily
noticeable for certain specific instructions.

This issue is expected to be addressed along with the issue
of PEBS cross-mapped counters with a slow-path proposal.

Fixes: 79f3e3b58386 ("KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 02f9e4f245bd..08ee0fed63d5 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -106,9 +106,14 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 		return;
 
 	if (pmc->perf_event && pmc->perf_event->attr.precise_ip) {
-		/* Indicate PEBS overflow PMI to guest. */
-		skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
-					      (unsigned long *)&pmu->global_status);
+		if (!in_pmi) {
+			/* The emulated instructions does not generate PEBS records. */
+			skip_pmi = true;
+		} else {
+			/* Indicate PEBS overflow PMI to guest. */
+			skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
+						      (unsigned long *)&pmu->global_status);
+		}
 	} else {
 		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
 	}
-- 
2.37.0

