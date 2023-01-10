Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9694D664BC7
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 19:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239082AbjAJS7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 13:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239785AbjAJS6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 13:58:38 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B54219010
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 10:58:32 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 23-20020a630017000000b0048d84f2cbbeso5531788pga.9
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 10:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=upUt0tkjVVo5kujG2THDyS9VuwSTirZ5ySsbyf+a2Vk=;
        b=TDmjeQs1Nx35Pnj9WFsSWVj6CGe4OuCAxxe9Uj2I0XxxteOWSUQ6lF/oPghE4q3D1E
         zLr973gqSe9z0IT9vS+MLR6tJHwSAReg7cX1R0FW9HzOmYqWOnnKZyG9AahfgNdgDw6S
         h6hq8qaNf1+r6Cr1qpROqlUJvqnhKvoWtp2O3jC9HoSUkRA/6IS0v1JCetsS+LSO2RRE
         M+8g4WfEY2Wp+9GCiMMWfWpZ5CNkBnaXtCVGULRsRLZg9MguZNelTRpUpFVODgGVBEG/
         sxSvq2ZKnVgjntV7aDOe7nBsabkzLnN/4K7FYwOozz3+oGwXJgovNqB8/VtqFEGS7KTM
         ZZ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=upUt0tkjVVo5kujG2THDyS9VuwSTirZ5ySsbyf+a2Vk=;
        b=Ws2zGKFr0vhBwpt+Jgg9FMZYAR8kXvYdId9vCO2ujkPLXV5Z4R7/e9iuePtXcmsVzt
         T8qUZFWDYlEbHNCZprYJH8ZAcZAbqGiK2IL62WQERcb0ADd15Os5dYG8YDvdto0OCXpe
         Qg1x8dqaceSLBHxKA9So5H4fNQtujOOF/J/XSoczdGKoZnlYAsooHihiTUy4Zz0HXzmy
         64a4MwRdaYybXbnmTbqdvZaeeM98o4MvBe8KEKIcN8keb+9TRdR2Kt2O7+rX4yAllSzg
         iNqc8PMfTgGmE22WDSp4hJnRjPOLAxNzQqk0A+P6PAVoFHJ2iyvGwdcBFvXYHJ7kJyLb
         pPSQ==
X-Gm-Message-State: AFqh2kq6yMrrCw4teemSP7dvUiEQlycPcT2ylbpoqBW9+wcOlTTzhvyJ
        d2YR37tUL261BiHEVlA1AeoXREFM48xSDar/FwqaTMaUnYCkJ28IUX+IvsdFEtvM7S0O5K8SvNA
        DImRIo7keppDKxIfdD3zUC0c8mD6/hkgfKUeL8hEmkbo3r7R6viEadIOP7qBp
X-Google-Smtp-Source: AMrXdXu1jQvfizmHt7HFd3EUElImxYYeXPAtpgr6GxJXnxViMI1A72B4Pd96A1woQGVdxKuC1tSbqdNthWJP
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:90a:d350:b0:223:fa07:7bfb with SMTP id
 i16-20020a17090ad35000b00223fa077bfbmr5690650pjx.38.1673377111533; Tue, 10
 Jan 2023 10:58:31 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 10 Jan 2023 18:58:22 +0000
In-Reply-To: <20230110185823.1856951-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230110185823.1856951-1-mizhang@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230110185823.1856951-4-mizhang@google.com>
Subject: [PATCH 3/4] KVM: selftests: x86: Enable checking on xcomp_bv in amx_test
From:   Mingwei Zhang <mizhang@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After tilerelease instruction, AMX tiles are in INIT state. According to
Intel SDM vol 1. 13.10: "If RFBM[i] = 1, XSTATE_BV[i] is set to the
value of XINUSE[i].", XSTATE_BV[18] should be cleared after xsavec.

On the other hand, according to Intel SDM vol 1. 13.4.3: "If XCOMP_BV[i] =
1, state component i is located at a byte offset locationI from the base
address of the XSAVE area". Since at the time of xsavec, XCR0[18] is set
indicating AMX tile data component is still enabled, xcomp_bv[18] should be
set.

Complete the checks by adding the assert to xcomp_bv[18] after xsavec.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 tools/testing/selftests/kvm/x86_64/amx_test.c | 30 +++++++++++++++++--
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index b2369f956fea..18203e399e9d 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -41,6 +41,12 @@
 
 #define XSAVE_HDR_OFFSET		512
 
+struct xstate_header {
+	u64	xfeatures;
+	u64	xcomp_bv;
+	u64	reserved[6];
+} __packed;
+
 struct xsave_data {
 	u8 area[XSAVE_SIZE];
 } __aligned(64);
@@ -160,12 +166,26 @@ static void set_tilecfg(struct tile_config *cfg)
 
 static void set_xstatebv(void *data, uint64_t bv)
 {
-	*(uint64_t *)(data + XSAVE_HDR_OFFSET) = bv;
+	struct xstate_header *header =
+		(struct xstate_header *)(data + XSAVE_HDR_OFFSET);
+
+	header->xfeatures = bv;
 }
 
 static u64 get_xstatebv(void *data)
 {
-	return *(u64 *)(data + XSAVE_HDR_OFFSET);
+	struct xstate_header *header =
+		(struct xstate_header *)(data + XSAVE_HDR_OFFSET);
+
+	return header->xfeatures;
+}
+
+static u64 get_xcompbv(void *data)
+{
+	struct xstate_header *header =
+		(struct xstate_header *)(data + XSAVE_HDR_OFFSET);
+
+	return header->xcomp_bv;
 }
 
 static void init_regs(void)
@@ -204,10 +224,14 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	GUEST_SYNC(4);
 	__tilerelease();
 	GUEST_SYNC(5);
-	/* bit 18 not in the XSTATE_BV after xsavec() */
+	/*
+	 * After xsavec() bit 18 is cleared in the XSTATE_BV but is set in
+	 * the XCOMP_BV.
+	 */
 	set_xstatebv(xsave_data, XFEATURE_MASK_XTILEDATA);
 	__xsavec(xsave_data, XFEATURE_MASK_XTILEDATA);
 	GUEST_ASSERT((get_xstatebv(xsave_data) & XFEATURE_MASK_XTILEDATA) == 0);
+	GUEST_ASSERT((get_xcompbv(xsave_data) & XFEATURE_MASK_XTILEDATA) == XFEATURE_MASK_XTILEDATA);
 
 	/* xfd=0x40000, disable amx tiledata */
 	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILEDATA);
-- 
2.39.0.314.g84b9a713c41-goog

