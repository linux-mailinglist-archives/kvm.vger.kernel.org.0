Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D27574071B
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 02:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjF1AOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 20:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjF1AOl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 20:14:41 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D199A2963
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:14:37 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-66767d628e2so2902137b3a.2
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687911277; x=1690503277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bl2xS0hpaMhLNXGaRDLAye8tC/jIz9OZNyY0aYdzy3U=;
        b=XnE7sHOaoiCiEDBeNgd0++hU1hInSAuTGEsviDuRnsgTiROjl7wXCi0UPgpCNhLZxs
         jlquyq3qXBoDECqebVv+5HJ+HRK62YGd6gcNgoEdoEpu1+76yZBjl+rtS6joGSZopdG4
         kH5hQyzJy9TCtxAUmrwsU+S+2DOpAjOt2nl6TlAbVErCh/OART8zPMqgW5D/a2CnH2Jl
         iGlrOYqV4Khw+5DFAjRRNMhMQb0Ibh2sBI2n/g1DQmZ1V/oRvmwEhv6mT5z037dshhRs
         Um7O/P/kLQqtmMDsDZRv2Tmz3WnVkvyTcoAYHO2WU7W2YAe+krcXaM4gr+xzi2fy/wdj
         lZjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687911277; x=1690503277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bl2xS0hpaMhLNXGaRDLAye8tC/jIz9OZNyY0aYdzy3U=;
        b=KdVOhTE88q3+U5ZhaDN6g1Kp/24ZtZiHccYp4jvxR6FBw4oh4fRpFNFwXO0Mhl1ao6
         87J4WjHQhw7XclCC3k3Aet/7XGKJWjBLehgSNPx4FGKQWUK/3xcoimw3yQ9XNLlIMoaf
         HvKad5r3BUOxEpB/sFNaKVCLVzKVPvirhGrtMVO8n1z9oi+j04TrsXhaVsGK3+lDZMVe
         iu8g9J9IDEvbGSFJQ5jBEiZrQ2Vpabl26tr/MOc1sa05MDelXfpQvOlvg13SXWfUCYFL
         fCpI/zdqV25k33Uu32wj7XHmVfMWJnOH+zH6ZckXh7CxFF+ojzeDA18eAulGZwtyAj8S
         fGNA==
X-Gm-Message-State: AC+VfDz9wK1LRSgNJavH6Qj0psNZnAQg/cfOtsul9CWYGMV1WtOs7xmQ
        tQujqvUskj3oY8aCqM+7IqM=
X-Google-Smtp-Source: ACHHUZ5A7eHI61T59Oo5W/n0/S2XLNxWb6ZKzhIq4esUMRLC0gP+UewjIjEq/P7PoSZ4CFQE3HJIow==
X-Received: by 2002:a05:6a20:7d81:b0:12a:cc8:75dc with SMTP id v1-20020a056a207d8100b0012a0cc875dcmr4706951pzj.31.1687911277047;
        Tue, 27 Jun 2023 17:14:37 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id jd4-20020a170903260400b001b1920cffdasm343796plb.204.2023.06.27.17.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 17:14:36 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH v3 6/6] arm64: dump stack on bad exception
Date:   Wed, 28 Jun 2023 00:13:55 +0000
Message-Id: <20230628001356.2706-8-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230628001356.2706-1-namit@vmware.com>
References: <20230628001356.2706-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Upon a bad exception, the stack is rather useful for debugging, splat it
out.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 lib/arm64/processor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index 831207c..5bcad67 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -130,6 +130,7 @@ static void bad_exception(enum vector v, struct pt_regs *regs,
 	printf("Vector: %d (%s)\n", v, vector_names[v]);
 	printf("ESR_EL1: %8s%08x, ec=%#x (%s)\n", "", esr, ec, ec_names[ec]);
 	printf("FAR_EL1: %016lx (%svalid)\n", far, far_valid ? "" : "not ");
+	dump_stack();
 	printf("Exception frame registers:\n");
 	show_regs(regs);
 	abort();
-- 
2.34.1

