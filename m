Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507756D21D9
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 15:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbjCaN5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 09:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjCaN5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 09:57:31 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC850CA2E
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 06:57:27 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id eh3so89857723edb.11
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 06:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680271046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=29EJFXydcv/KKtfone2szoiYAFJhB160ko5K2W2bkyY=;
        b=A8YZPGp2rY+tKBTGPcC+/qBhtUqj+YNRhqLiQRujB+7SzkVhRsm7IzCaoKJJxjmLW4
         mqK1qDLvwT3EbXkJkj/6CWx0VVlAiXqNSyT57cxd16b1fQKkacKkz4zhnGA+C8e8Qlcm
         2ubhANcUayyhY2sqFGRz8xEh1Zq29+z7tbOExMjsUo27ptoW4A5iZvm2t+iT9rvDES2S
         EbTNTvTq7fxDEol0267TfTXlDbwQPLTx02iFWlrvCOlHHu61SpeWfCvnka/TgsTUEx9+
         ViPJO/thMR7qB0nqFTJyT4wiYrr00DH5BXrRPR9bEQc/U90B0lgOoOFwiar6N6Glo4ok
         DyjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680271046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=29EJFXydcv/KKtfone2szoiYAFJhB160ko5K2W2bkyY=;
        b=40ZN6JxzocFyy4bCgfW5+ylezum1eOBmfIwp9a4OzJYYEdHVDArURnhs0YmD9tTG7O
         bI+uXzgrWiOQmiOLMzXfn40FqJqBaU5aT2P4WRf1qSK+X0WVZsveJED9rv4KKK5GMCWc
         QL54XvzrJIu+rsZqxn7m8Gwl09NC0oQrv+HQMykjmhqMPKcWiQewcIClE75zTsUZPLng
         BuByYdWChN9Kgoud0i0tWGEtR1ygjnpxEhlZFf8feVo0Kb4CgtMAI36+YLCFGpq4as6T
         9zT1rUx+7g2J0XOnlg1w5zKoYWjnclMXS0ipBj2UThe/nRwmyH3Ddq/28WTkmLcUfxoG
         +PJQ==
X-Gm-Message-State: AAQBX9djzKQuRURa775063GMBdBxlTcObauIm69BhBS2y+BZ5tTbCpHE
        eY7JvZ6u+v/7ruo/8lxO/w+gAfdzeJjhhYfTNjUP3A==
X-Google-Smtp-Source: AKy350ZhBJd4TClGivE25/45dmy7AoKpnME3lDCbVJeoDrjxc2fTplWXutTcbne06XdGWuRZDpqNLg==
X-Received: by 2002:a17:906:1d0a:b0:8b1:7b10:61d5 with SMTP id n10-20020a1709061d0a00b008b17b1061d5mr28772455ejh.33.1680271046085;
        Fri, 31 Mar 2023 06:57:26 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af1a510052e55a748e5a73cd.dip0.t-ipconnect.de. [2003:f6:af1a:5100:52e5:5a74:8e5a:73cd])
        by smtp.gmail.com with ESMTPSA id ay20-20020a170906d29400b00928de86245fsm996888ejb.135.2023.03.31.06.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 06:57:25 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 2/4] x86/access: CR0.WP toggling write to r/o data test
Date:   Fri, 31 Mar 2023 15:57:07 +0200
Message-Id: <20230331135709.132713-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230331135709.132713-1-minipli@grsecurity.net>
References: <20230331135709.132713-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We already have tests that verify a write access to an r/o page is
successful when CR0.WP=0, but we lack a test that explicitly verifies
that the same access will fail after we set CR0.WP=1 without flushing
any associated TLB entries either explicitly (INVLPG) or implicitly
(write to CR3). Add such a test.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/access.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 203353a3f74f..d1ec99b4fa73 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -575,9 +575,10 @@ fault:
 		at->expected_error &= ~PFERR_FETCH_MASK;
 }
 
-static void ac_set_expected_status(ac_test_t *at)
+static void __ac_set_expected_status(ac_test_t *at, bool flush)
 {
-	invlpg(at->virt);
+	if (flush)
+		invlpg(at->virt);
 
 	if (at->ptep)
 		at->expected_pte = *at->ptep;
@@ -599,6 +600,11 @@ static void ac_set_expected_status(ac_test_t *at)
 	ac_emulate_access(at, at->flags);
 }
 
+static void ac_set_expected_status(ac_test_t *at)
+{
+	__ac_set_expected_status(at, true);
+}
+
 static pt_element_t ac_get_pt(ac_test_t *at, int i, pt_element_t *ptep)
 {
 	pt_element_t pte;
@@ -1061,6 +1067,51 @@ err:
 	return 0;
 }
 
+static int check_write_cr0wp(ac_pt_env_t *pt_env)
+{
+	ac_test_t at;
+	int err = 0;
+
+	ac_test_init(&at, 0xffff923042007000ul, pt_env);
+	at.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK |
+		   AC_PDE_ACCESSED_MASK | AC_PTE_ACCESSED_MASK |
+		   AC_ACCESS_WRITE_MASK;
+	ac_test_setup_ptes(&at);
+
+	/*
+	 * Under VMX the guest might own the CR0.WP bit, requiring KVM to
+	 * manually keep track of its state where needed, e.g. in the guest
+	 * page table walker.
+	 *
+	 * We load CR0.WP with the inverse value of what would be used during
+	 * the access test and toggle EFER.NX to flush and rebuild the current
+	 * MMU context based on that value.
+	 */
+
+	set_cr0_wp(1);
+	set_efer_nx(1);
+	set_efer_nx(0);
+
+	if (!ac_test_do_access(&at)) {
+		printf("%s: CR0.WP=0 r/o write fail\n", __FUNCTION__);
+		err++;
+	}
+
+	at.flags |= AC_CPU_CR0_WP_MASK;
+	__ac_set_expected_status(&at, false);
+
+	set_cr0_wp(0);
+	set_efer_nx(1);
+	set_efer_nx(0);
+
+	if (!ac_test_do_access(&at)) {
+		printf("%s: CR0.WP=1 r/o write deny fail\n", __FUNCTION__);
+		err++;
+	}
+
+	return err == 0;
+}
+
 static int check_effective_sp_permissions(ac_pt_env_t *pt_env)
 {
 	unsigned long ptr1 = 0xffff923480000000;
@@ -1150,6 +1201,7 @@ const ac_test_fn ac_test_cases[] =
 	check_pfec_on_prefetch_pte,
 	check_large_pte_dirty_for_nowp,
 	check_smep_andnot_wp,
+	check_write_cr0wp,
 	check_effective_sp_permissions,
 };
 
-- 
2.39.2

