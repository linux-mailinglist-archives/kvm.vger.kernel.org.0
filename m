Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42301727958
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 09:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbjFHH64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 03:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbjFHH6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 03:58:53 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62273213C
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 00:58:52 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-64d44b198baso259094b3a.0
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 00:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686211131; x=1688803131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rz2qKoH3DNrsLGjh2uEgTknkQbSjekuqzOD1uG30Q6U=;
        b=QeXYam2TKtQKJlmYK+hS4PipoH7jZSjxhlzJtYatN7aADBYfeYQjB+M4CVMO2YtaYX
         DJ2UYrJzZ5UXG1b+ZkV5fAFGW8kxcJyzUheMdr1RJn2NmTpba6dvrSKzVf3cWvg9Gt95
         6atsVKDvSbtgS4TWqMZoAbBOEDW1pmuhtrA+r1mFHVXu8SuJsEWT4Xu/Pq9DYD+/LUUA
         m7sKplV2sgU3jVFxoai6J6P7B1V/pHe3wQZ35ioBoTXUXoT4qyi8XJ2iyDp7Bm35iuLQ
         w3F/risInMRWJgWHYob9TXd+aNLZjZq4/iLth9pTkksVKKLGHEy8wzNhvOgk31Ubp41Y
         ve+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686211131; x=1688803131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rz2qKoH3DNrsLGjh2uEgTknkQbSjekuqzOD1uG30Q6U=;
        b=Dl3kgA6mq2CYbcnAwbylfVFKZMPl2hiFLmBp3eHD291SsaD5fTl+ufgCUCyq+LyyIQ
         5C4ndwP6Ev2aT61oQRH40gjYxxYMvqEU/phRi8ZzRZNvoQ1w0p5+FTBl9fuoSRgHfl9X
         f7rg6IXdH5PQdrVVZQogtM24FPW9zAmtCvlfrk/bgHb3HPbS/ri/mAWL37AB8CeBc62b
         z6qmvu2Pihvx7WsdarINMvcRZkPPX6A7uV9w6qDBn28CsjAsc7h8upWiuSgt5yfWonQd
         kMnAnUmIomiLmSgFO1Gw7smIyc9hQQYLj98/ev7DIIIotLau/crq+CdTZJkj32gp54AE
         6Lew==
X-Gm-Message-State: AC+VfDwaN6bG8QtwRUdnIjUSLkvD4mT+vZexqVlXJ8DUhjsOeDUjRpwY
        iaFK2en/Amr90u+gHKzHEhoQSUM1aB4=
X-Google-Smtp-Source: ACHHUZ5CkbXbO96YImP08Vnh4l4C7KyGIVtp0KFP01IXjaZyq6CNPW8hQqqQqLpVvC3UWM2LzcAWtA==
X-Received: by 2002:a05:6a21:329b:b0:110:2064:ecb with SMTP id yt27-20020a056a21329b00b0011020640ecbmr1676434pzb.15.1686211131186;
        Thu, 08 Jun 2023 00:58:51 -0700 (PDT)
Received: from wheely.local0.net ([1.146.34.117])
        by smtp.gmail.com with ESMTPSA id 17-20020a630011000000b00542d7720a6fsm673182pga.88.2023.06.08.00.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 00:58:50 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v4 04/12] powerpc: Add ISA v3.1 (POWER10) support to SPR test
Date:   Thu,  8 Jun 2023 17:58:18 +1000
Message-Id: <20230608075826.86217-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608075826.86217-1-npiggin@gmail.com>
References: <20230608075826.86217-1-npiggin@gmail.com>
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

This is a very basic detection that does not include all new SPRs.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/sprs.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index ba4ddee4..6ee6dba6 100644
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
2.40.1

