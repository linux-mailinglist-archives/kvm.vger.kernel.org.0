Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CA34CA78B
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 15:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbiCBOK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 09:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbiCBOK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 09:10:28 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B8D396BA
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 06:09:16 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id f14-20020adfc98e000000b001e8593b40b0so673629wrh.14
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 06:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=98qRkgzqUA4uIyFb6DyG2/PM4ohLc28A3d+n2FMoR2g=;
        b=FjxCZDlfXaxRwHfpStekSFRfty5xR39pRWkcjDvKdnGVMygWG5Mwi+p0hhjxdw/RT2
         sZSpglnEdw1J1FLxCmkWlzkjjFqTlgFdneuWtn/VZiz9KrQyDBi3A8C66BXHBQrBQ2NO
         lTfe9Ou0aW1Bw+l71ugkWDjPZbQ/e0aAysoLvMk5o/TH2A6atIOo1ftOQMRMO4PfH5ah
         lybUOWtbbltwTZIn6pMI+i+8lXxQEEqopn5tSgIBSpPBsKTQ9+AV7Fi+TIvm7WPhKXYV
         2UgFKIurGc9dlxk/efmb6yCIQYWiRZbOqkbiiHsB4so1a8yJ8W0vmhOLrjF/hzAMdTR1
         a80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=98qRkgzqUA4uIyFb6DyG2/PM4ohLc28A3d+n2FMoR2g=;
        b=PBmRz9Sk6CdzTsYgmBBNHPIWuRC1+AJTX+5N7015IbfRyZ0N07vaGhySZzGe977Hg5
         g5ZdPvbRWNPvlrqjaZbdvJeSmzMO8Cbpem3Oh9MMHZHtiii/VvT2ph4OprDSDE9YqmC+
         oqze+OmZPF7TaElwuvCKAoZWJIVKZsSTCgieOwO59Grt+a3VDqBQaE4WHD1fzYtDwN7I
         IOPr4tPsf1c1wkwTFEPID6g1JqezIeguL+bJi+kGFzflnwO9ltmNeWEzQ85Tl8lNy/O2
         SOr65/aoXq3Jgo86E3ZXvrntDgGqXQq8/znJxsYvpj05eIfyqu/yGQEC+HAiPgip78j5
         0NUg==
X-Gm-Message-State: AOAM531bTxcDU/PtkNNWDkghKOK2p7hEdfQ/dq7YvSfFqxP2f7zR/P00
        ohaaFiWNkfR+ciV8JwYV+4Uqi+Jfax+r0pe//eUbZyWj2Nx4QFytWJa4Sjy1arVKDFGaY/ZoZZo
        tJePS0fE0L14nqALClpY9AOTzFI7x4eHhgIcZ5HXw95MoF97v7RG/Gh2zry/L6RQL68+J9XT1nQ
        ==
X-Google-Smtp-Source: ABdhPJwb6hZ17w5iUMZyIGJw+t2Y/ZKStR5guKfZp+57tXdK+IVwLkH7uUwCv2Y/UGJ66duGol11rRcqTuqz5sVj3jg=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:430c:b0:380:dc2a:b2c1 with
 SMTP id p12-20020a05600c430c00b00380dc2ab2c1mr20010516wme.39.1646230148618;
 Wed, 02 Mar 2022 06:09:08 -0800 (PST)
Date:   Wed,  2 Mar 2022 14:07:36 +0000
In-Reply-To: <20220302140734.1015958-1-sebastianene@google.com>
Message-Id: <20220302140734.1015958-4-sebastianene@google.com>
Mime-Version: 1.0
References: <20220302140734.1015958-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v7 3/3] Add --no-pvtime command line argument
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com,
        Sebastian Ene <sebastianene@google.com>
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
2.35.1.574.g5d30c73bfb-goog

