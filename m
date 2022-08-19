Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9A8599AC1
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 13:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348711AbiHSLKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 07:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348708AbiHSLKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 07:10:11 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDE2FBA6A
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:11 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so4541913pjf.2
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=c216Il+C/yqgokZi4GVwSSSatg+JxksECsNr0y7HZCI=;
        b=OgxgUa9jARhd43kvqO1LfMR8lnynBFoE700aj5dA7F1V8x5XQL9lqcHGvhTZoB3XYp
         7tvn9pDiJuCAXDYayJi/m/4vbDcGncdzMYtKyVJ7SFTotJpjHsI/6XV2BjwPkjQjvPw0
         eyFpc3XH5E2xWPfwaznyXawD3henoh3vb1kigzVDm95KMRdzkDL96BMKJA/0Klo5fpA1
         w1AvGdCXE9ocyBafwi6PwNeG3YSiBDGz9X/iRq9Iv+gh8C1RIhuJRNMZrul8e/W/8CkO
         ADxpC4sC3+hlU5905LtWXk2D1yzXz9oXtERI0F6OzijrLOiOBfHYByG4TFvdd7VfKmPP
         acUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=c216Il+C/yqgokZi4GVwSSSatg+JxksECsNr0y7HZCI=;
        b=w8jgcaWnLfjoEqiWdnKSZuob5nE6usXJ66H5uPr6Ny/A1TSNC5vpZA+jca2hdEMmyu
         JwquxurAiYxZRU2dnWSnPM3ofNrjlrtUcwx6MamuOZ/sB0lQcyu3tzC1daNW/NKZ6n+D
         PTln1H/lmhBw423o/3CcjuJYMwyGHQcl/3ySRcwZFzefWap36tplepNHQ5psLmQQDQni
         K/1DzW016soDSNPf4/8JCvpxCqRWsipFKokrlWmZVcBisCrkxMnq2cZ6GIecT4sDmDEo
         XhJQxJn3gjUXXbpa4X5sqgpybwdkK7PvWRLDbDnidPA6uLzq45LR1b2ZJasMP5EXALcn
         0kWg==
X-Gm-Message-State: ACgBeo0emkPsMrSsUnlod8E7S25Bro81ZJyxB1H6NARGwW8eXSI8A3eV
        RTBmgORqiGa/Z1dfHEAJtU+IHG1duyD2HA==
X-Google-Smtp-Source: AA6agR4ZUI1woj9YSbhTHhzB1vRWTEt4kzOQHgzfedlkrjeRLrXcfCZhaTDzHs1k3SY08xcujJozog==
X-Received: by 2002:a17:902:e804:b0:172:812f:ad0b with SMTP id u4-20020a170902e80400b00172812fad0bmr6791421plg.26.1660907410667;
        Fri, 19 Aug 2022 04:10:10 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jd7-20020a170903260700b0016bfbd99f64sm2957778plb.118.2022.08.19.04.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 04:10:10 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 07/13] x86/pmu: Pop up FW prefix to avoid out-of-context propagation
Date:   Fri, 19 Aug 2022 19:09:33 +0800
Message-Id: <20220819110939.78013-8-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819110939.78013-1-likexu@tencent.com>
References: <20220819110939.78013-1-likexu@tencent.com>
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

The inappropriate prefix may be propagated to later test cases if any.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 9262f3c..4eb92d8 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -674,6 +674,7 @@ int main(int ac, char **av)
 		report_prefix_push("full-width writes");
 		check_counters();
 		check_gp_counters_write_width();
+		report_prefix_pop();
 	}
 
 	return report_summary();
-- 
2.37.2

