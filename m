Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86AF36BE968
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 13:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjCQMhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 08:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjCQMhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 08:37:47 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A141E9C6
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 05:37:06 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id u5so5135666plq.7
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 05:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679056608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BgrFyKL0mkQqzfd3lw9FAzsbWeu2gcn/ROX5EFuiTaU=;
        b=Qfpi+iuXM1w/WHrL+cK8ZdUQoGQX8+OPSP5cEF0YEEKWuMjtYcnnHG+G0UvJ4++W5r
         xvReBfEicKE/neiF01ppuDvK69IVL65w6AGVUYXilEl1mCUNxoo8L1qhywP2hGu4tufq
         TUvabdh+ryfldzUxWPY7bh5IchpNjjp8yLcRW9hHHh3rYSrJqr05ooMmHL4k8d/q9Hro
         7WN03HM5houo1F0eG10L6LnW33u2ss8KpFTthTn4TxneRqmbbs+Rm0x6HsEYtHajmU+7
         TthDQTWxKs7RHSm9mCl4y5MMEyJQl5P+bRfbnO0mq2lVhOR4ZIj0EDSNcfNCpXFoOuQh
         SQMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679056608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BgrFyKL0mkQqzfd3lw9FAzsbWeu2gcn/ROX5EFuiTaU=;
        b=A/7yHym2zk0WJnlmLFoYzd5tOYz1usXqoGbTorDJxXbxqTfPKM/xWrt44DGriAmcyr
         aRUXcjwiCycYGpBXky5/3AH0knevAbveDD2B18lqUcL2q9S3/Dta1FYjObH/yUzYDIkS
         9wufUisOE+6HmHRlauwyhSfSiNESsnOHyKlwOCyvfcX0pOXT04RuToWsa/rPdyuOnH+w
         hlRVHMwoHJsXVJME/tvtegpab9jGFjCVOIVh34o70pkcQuc+8HpVv3GFzaNMAi++sBXA
         In9YTezPoerC/i3dx/kB1pOQ3KGrhi1M2lr/ulgUCKNoYGl8BOAwkT/AZYzfoFiv2chu
         lxAg==
X-Gm-Message-State: AO0yUKXs/WNVJqoTPXHfKsn9XMsOmh7ZwDlsuTs1HRdF8fwhyCXWEuss
        NU4WAsdMIpxC+yICBPtfmMhFqhzuNrQ=
X-Google-Smtp-Source: AK7set8VVnF/eahtQSwmgDCRAgLIrEC12yNJlSdMxmpFXMYod+HltJkz8Hu+U2tHN+Jo09C4DTe92w==
X-Received: by 2002:a17:902:cecd:b0:19e:9f97:f427 with SMTP id d13-20020a170902cecd00b0019e9f97f427mr8445311plg.10.1679056608399;
        Fri, 17 Mar 2023 05:36:48 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (121-44-69-75.tpgi.com.au. [121.44.69.75])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902b28400b001a19d4592e1sm1430990plr.282.2023.03.17.05.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 05:36:47 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH 4/7] powerpc: Add ISA v3.1 (POWER10) support to SPR test
Date:   Fri, 17 Mar 2023 22:36:11 +1000
Message-Id: <20230317123614.3687163-4-npiggin@gmail.com>
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

This is a very basic detection that does not include all new SPRs.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/sprs.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index 161a6ba..45f77a5 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -117,6 +117,15 @@ static void set_sprs_book3s_300(uint64_t val)
 	mtspr(823, val);	/* PSSCR */
 }
 
+/* SPRs from Power ISA Version 3.1B */
+static void set_sprs_book3s_31(uint64_t val)
+{
+	set_sprs_book3s_207(val);
+	mtspr(48, val);		/* PIDR */
+	/* 3.1 removes TIDR */
+	mtspr(823, val);	/* PSSCR */
+}
+
 static void set_sprs(uint64_t val)
 {
 	uint32_t pvr = mfspr(287);	/* Processor Version Register */
@@ -137,6 +146,9 @@ static void set_sprs(uint64_t val)
 	case 0x4e:			/* POWER9 */
 		set_sprs_book3s_300(val);
 		break;
+	case 0x80:                      /* POWER10 */
+		set_sprs_book3s_31(val);
+		break;
 	default:
 		puts("Warning: Unknown processor version!\n");
 	}
@@ -220,6 +232,13 @@ static void get_sprs_book3s_300(uint64_t *v)
 	v[823] = mfspr(823);	/* PSSCR */
 }
 
+static void get_sprs_book3s_31(uint64_t *v)
+{
+	get_sprs_book3s_207(v);
+	v[48] = mfspr(48);	/* PIDR */
+	v[823] = mfspr(823);	/* PSSCR */
+}
+
 static void get_sprs(uint64_t *v)
 {
 	uint32_t pvr = mfspr(287);	/* Processor Version Register */
@@ -240,6 +259,9 @@ static void get_sprs(uint64_t *v)
 	case 0x4e:			/* POWER9 */
 		get_sprs_book3s_300(v);
 		break;
+	case 0x80:                      /* POWER10 */
+		get_sprs_book3s_31(v);
+		break;
 	}
 }
 
-- 
2.37.2

