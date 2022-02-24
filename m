Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A5A4C3256
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 17:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiBXQ4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 11:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiBXQ4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 11:56:18 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22A025C46
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 08:55:48 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id 187-20020a1c19c4000000b0037cc0d56524so118077wmz.2
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 08:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3UAm59KDixqFfoef0ljTGT0yrk00dLv4gMpJOzI1zE8=;
        b=UTC9j5VDOPq2RCkEnvcZlXk4MXhXwmAMZJs/aVBFLf5fmnutKqxbr7cAACbP0p6982
         1kg4j3nnGK2yLbodd6JNw+I1GY/kiwJftH1U58qV9wt7R0G2Ut2ATqQ8TzSLtuzDHlmE
         174B/pbRW+jP+nxe1ty0WdxbIexYZ8bPJzELaicucm9Gy5J7DRE2aFLIg8Rp58sMTahU
         mGrYu5xMEEVqDL73Imv22uOR+k07yY5gGya57bZu3YV/EU5w79/yhOASRkJPOGqidqjS
         vJA+6hVMCcp9e7Dclk83Yk+jpYyk9kcyf3chS0/w82Er/nR5m/PqZImESKypMspQkI5K
         B3cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3UAm59KDixqFfoef0ljTGT0yrk00dLv4gMpJOzI1zE8=;
        b=uWsPGlRl3vh772ZNpFClHMqxF15V5SWnfu0KWSnhI8emNZKIOtaGEo86k5enpFwtoQ
         8wg7he+TC9+3xsLIxDPLe1D7hb8nR4VWMNNC+4jeazCnJUCQAiu8F+phrmldYLgzdSOV
         avEr3k9SqZRlO/PDlirWaEIGGsN9/vSwYSK1htNaZ24H8GFFGVHgN8kSOLBUdZD28FM7
         DH/c90kSgWIRNRCMxdILY2lAfCIJEybDR7ThD1bWMj55UPHltgr8YJwhbhqjzHg5Yj5U
         syynIlE19C0Tdl4cN1aRhKyX8lic4eqr24rRbLnbiVQS8jYxeRQN8Us2kLhqDk8XD6V8
         ejtQ==
X-Gm-Message-State: AOAM530I02Ypc2CVHO3RCMmEni74vzv0A1tYBH8jUevzsDdboBCUyV3v
        TqyZoEqIXCQCijwYLH5GRY/xTDMf1CSBQ0dIpXucg6uNaTmBSzowy26jYtX3Rme6JZ2hVSUrhvV
        c2cTSaAbOr26MoXsX57rPxyaHOemTaXjur4Bvr3mRXLxyXqh0vXa3U+rLfEyQjUk0ppEKJ5EffQ
        ==
X-Google-Smtp-Source: ABdhPJweSypprU2//1adFOt+scXePFLmka+aoQVmYLh6J9nO4iBzaGIi8FFKN/REX4tSGV8l795usgi7UXfG+/iQnnU=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:418b:b0:380:e493:660a with
 SMTP id p11-20020a05600c418b00b00380e493660amr3022320wmh.189.1645721747528;
 Thu, 24 Feb 2022 08:55:47 -0800 (PST)
Date:   Thu, 24 Feb 2022 16:51:05 +0000
In-Reply-To: <20220224165103.1157358-1-sebastianene@google.com>
Message-Id: <20220224165103.1157358-4-sebastianene@google.com>
Mime-Version: 1.0
References: <20220224165103.1157358-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH kvmtool v4 3/3] Add --no-pvtime command line argument
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com,
        Sebastian Ene <sebastianene@google.com>
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

The command line argument disables the stolen time functionality when is
specified.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 builtin-run.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/builtin-run.c b/builtin-run.c
index 9a1a0c1..7c8be9d 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -128,6 +128,8 @@ void kvm_run_set_wrapper_sandbox(void)
 			" rootfs"),					\
 	OPT_STRING('\0', "hugetlbfs", &(cfg)->hugetlbfs_path, "path",	\
 			"Hugetlbfs path"),				\
+	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"	\
+			" stolen time"),				\
 									\
 	OPT_GROUP("Kernel options:"),					\
 	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
-- 
2.35.1.473.g83b2b277ed-goog

