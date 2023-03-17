Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBBBD6BE966
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 13:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjCQMht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 08:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjCQMhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 08:37:47 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD0293C7
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 05:37:02 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id ix20so5148274plb.3
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 05:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679056602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IGrixfxvALez5iC7y5jSzp88ksEIk5PU6pEUFuV6u+I=;
        b=l3n0YBijw6wscEwhxo3xJinQJ9wZs0xJPB12moudZQtIPDNfb3Lv4Z8KHFGw08/5Ca
         6x3tAPZlR+UMqzZ16kCWQfSzAS75RQ+netKObgq+xJ7PMFHyLvt8meVOr4oFC65I+Vby
         XJzNQg2qOb6ZxLwwgpdtt81g23o8l13KRwt0CNhJtkaKSRGTQwdvTZo6gGNVyfAON4fl
         gedyafRgeyP+807zC6n/GGQIwlsxN48ru5w1UR34TCjf0kYziCL2cQViUC2hsxI0K4E2
         0ZepkhwsyYEbD1H2faAGJnbif4po73rMfL8MJ3ngYIjFRYgzw8VpdfMBM2owi2QrDQSx
         pOlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679056602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IGrixfxvALez5iC7y5jSzp88ksEIk5PU6pEUFuV6u+I=;
        b=y3EvtYA5T3fAFlgpNclueUrYGlsogso1ckvItxN7U+On2A0K5JgnKtGGqW6/4BW3oo
         +5p4x1a3aTbIynMil8pPMQktObqphsBtBHFzJbivdT0CGs9IJdENfFPTR/s9C5DDigFe
         YTMxoA7xyqaY/nyjN+pHZcCevZY0kkno+WMWFXXHJ3ks8mG+5wmEnnpLDhXQnaLTk4md
         txSuwTKdqU67O7bukxB9PwvNa9Ixrunc0YtiCXzaSAIwKsECbOQXTO0Epy9wiSZWxheL
         IiaEMpZvjzSEwmGIaAPUPrc6W8ga0gltMxCUCDhkcb7xMbnSh7poVTo2c6uype5KQyo3
         PHAw==
X-Gm-Message-State: AO0yUKUDqBxgjsCS9r9fMRJMacaCVAk/yyd9fwh3yZNKfInBKBtWAPwY
        mH/6zmdF64/a/rgAO74yQ+yJv4LHdHM=
X-Google-Smtp-Source: AK7set8DOmchCV0AGBT2BTU5yIrD1m6yPwDMqTK5iiBDwDMPVSD6dfoqpYDRoYdj6kq34GTSj1v2Fg==
X-Received: by 2002:a17:903:234c:b0:19e:8bfe:7d79 with SMTP id c12-20020a170903234c00b0019e8bfe7d79mr8892343plh.1.1679056602184;
        Fri, 17 Mar 2023 05:36:42 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (121-44-69-75.tpgi.com.au. [121.44.69.75])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902b28400b001a19d4592e1sm1430990plr.282.2023.03.17.05.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 05:36:41 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH 2/7] powerpc: add local variant of SPR test
Date:   Fri, 17 Mar 2023 22:36:09 +1000
Message-Id: <20230317123614.3687163-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230317123614.3687163-1-npiggin@gmail.com>
References: <20230317123614.3687163-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds the non-migration variant of the SPR test to the matrix,
which can be simpler to run and debug.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/unittests.cfg | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index 1e74948..3e41598 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -68,5 +68,9 @@ groups = h_cede_tm
 
 [sprs]
 file = sprs.elf
+groups = sprs
+
+[sprs-migration]
+file = sprs.elf
 extra_params = -append '-w'
 groups = migration
-- 
2.37.2

