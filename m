Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8696CACD0
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 20:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbjC0SQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 14:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjC0SQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 14:16:11 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B51830E3
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 11:16:07 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id t10so39721482edd.12
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 11:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1679940966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pgCb2fD5/3eMjp/r7Z39wtlcsNNhW6d832f3xFbu6z0=;
        b=Zy5ZYYDpVCTsv7jGGUVpvVKXsTpTCs98UuI8a0zYES7g0HoozlytNhDZBv0W5v8mXS
         uPN9UwalCtoR6FlE/vE+9RU3EBv1sCC4d+E5PgZBarJb18E0evrEff1OVjWRkImGpUOv
         eqq2P+5YhTpmS3O41xua/aKIzFFBTBzir1ec5VWdOaWS72KE+UOzlS+Emu60DSHoJUrl
         mQJlSFwoE/6S7EQJGOD8Gwjrpj4KlyIx3pUau9NRDdWnC6EQHHmZu97rZGLGVO4WcCO8
         2MLafTVk4TZsxkGRMX5oZnfMtiBqSrPWBlxnjVRAFQgAMNKjJ11OAL8MyxdG5cER8C0s
         jj9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679940966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pgCb2fD5/3eMjp/r7Z39wtlcsNNhW6d832f3xFbu6z0=;
        b=ukwUwZLO0rVZqvHRuOfRjRxZaWAbAHvpd8LrFDYEACmjOKGaEsvDcSBAjWDPj8YtlZ
         LchcZpw6GkSGXw3+RM0j+Z7G54CLTsp4TAH4ZHC/Z8Ld7OJk9WaWvmQrCDd4JjMuGrqs
         TDNIOSk3vcKFqvolt5cOlOy0TdKuDTyfCC4jQwTEvjViWkKJgFYk9Q+QEjzsz3AKzE0A
         y2i+VaEBAkVqsCARCy97K8DwnyzH3YtDame38BKQy4WC1C3NaMK3tp9beR/ojsn/PATI
         BwyKpcgSThhfjCyepEUqfh+wrnBJnhPtN0vHrxkiHT7MrY5cL1uungOnJCTMVwsTd2xD
         XTqw==
X-Gm-Message-State: AAQBX9dCsyGkZYarb9qpkhaZbztgNNa3sTljLvPKg8+skz0jZgkBMr13
        QJ1uHmZF2yPngmruU/SvmXeo60kM6uINOLHSplDbiA==
X-Google-Smtp-Source: AKy350Yh9SbDjDjICbd2mkUgfqkheXum97qedyuLYEO4GuV1MroSAJjDvJhRWLN/cbMXDTUUUgByMA==
X-Received: by 2002:a17:906:b24e:b0:930:21a:c80 with SMTP id ce14-20020a170906b24e00b00930021a0c80mr13715716ejb.47.1679940965953;
        Mon, 27 Mar 2023 11:16:05 -0700 (PDT)
Received: from localhost.localdomain (p4ffe007e.dip0.t-ipconnect.de. [79.254.0.126])
        by smtp.gmail.com with ESMTPSA id 22-20020a170906309600b0092f289b6fdbsm14245396ejv.181.2023.03.27.11.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 11:16:05 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 2/2] x86/access: CR0.WP toggling write access test
Date:   Mon, 27 Mar 2023 20:19:11 +0200
Message-Id: <20230327181911.51655-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327181911.51655-1-minipli@grsecurity.net>
References: <20230327181911.51655-1-minipli@grsecurity.net>
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
 x86/access.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 203353a3f74f..5fe2a89ddfa9 100644
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
@@ -1061,6 +1067,41 @@ err:
 	return 0;
 }
 
+static int check_write_cr0wp(ac_pt_env_t *pt_env)
+{
+	ac_test_t at1;
+
+	ac_test_init(&at1, 0xffff923042007000ul, pt_env);
+
+	at1.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK |
+		    AC_PDE_ACCESSED_MASK | AC_PTE_ACCESSED_MASK |
+		    AC_CPU_CR0_WP_MASK |
+		    AC_ACCESS_WRITE_MASK;
+	ac_test_setup_ptes(&at1);
+
+	/*
+	 * Write to r/o page with cr0.wp=0, then try again
+	 * with cr0.wp=1 and expect a page fault to happen.
+	 */
+	if (!ac_test_do_access(&at1)) {
+		printf("%s: CR0.WP=0 r/o write fail\n", __FUNCTION__);
+		goto err;
+	}
+
+	at1.flags &= ~AC_CPU_CR0_WP_MASK;
+	__ac_set_expected_status(&at1, false);
+
+	if (!ac_test_do_access(&at1)) {
+		printf("%s: CR0.WP=1 r/o write deny fail\n", __FUNCTION__);
+		goto err;
+	}
+
+	return 1;
+
+err:
+	return 0;
+}
+
 static int check_effective_sp_permissions(ac_pt_env_t *pt_env)
 {
 	unsigned long ptr1 = 0xffff923480000000;
@@ -1150,6 +1191,7 @@ const ac_test_fn ac_test_cases[] =
 	check_pfec_on_prefetch_pte,
 	check_large_pte_dirty_for_nowp,
 	check_smep_andnot_wp,
+	check_write_cr0wp,
 	check_effective_sp_permissions,
 };
 
-- 
2.39.2

