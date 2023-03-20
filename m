Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFAA6C0B0A
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 08:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjCTHEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 03:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjCTHEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 03:04:09 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3871ACEF
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:04:02 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id d13so11186652pjh.0
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679295841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YgtM7TlxgAIoKdfgC+k38fH5tECmZ4bBfgi2cHLlGS0=;
        b=CjkhLNm5CeCG8XIRiBF6PK3VJ+SY/fLQd3hDXzjE9Qkd/SBHlfqRWYND38NZoJ+U/Y
         MRyI9kx66QpfyeO0GmdZOUhSSLQdHFusM6JFr/SNc+jY4FS7iQnypXy7HWS6qFnbPOly
         BWMiJvynKcIG6EciSMq6gLUQIwK5Eldvr6W2Ck5qkyKvo5QyUp+6A1ahbj5oxNZKukXP
         JcRysbmdfgrCJ+a05z/S3ccdfGgIktSrdl4HCKDGojUpu/Tct21492gmxD4K6hil4u3W
         xCj/511k9sDRrMa4hRniaAa34Mc95NC85KNT7pJshQq2WPt5Xp+c7myU+SmByG0z970D
         BkDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679295841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YgtM7TlxgAIoKdfgC+k38fH5tECmZ4bBfgi2cHLlGS0=;
        b=peUGrig4dPyfeC8fWBtbHyxAq5WQN21ib0kA9dBdY5aWHwdakahhHadH4Vn1alSlOG
         hjCvqA76iA9eiAF9/vcJRwOHJlsNX2+EFsJHLvHDS45q03xZqhocdPvhd6r5b34xFSZH
         DJW6aFNoMSGwawTMGNWpMm5++17aXkmXE7iAqqFql7mRevXhfqUxqiEkqyd9SOhQ/ka5
         MYENm+Q92MaEvv3vCGtr/TUg/5MruCh69XEvSpROInU3j8AO4YyWNu8nZwfucUiyXKkq
         iuaYa+he1AeA5L/mQsNbPV9HaWSDw52JjFgup+oRRdEEMBujW3fq63dtXMaiAzUJpSaG
         mQvw==
X-Gm-Message-State: AO0yUKWcrbJNEoMTDwqM17ULMM5rZuKU+2LKknRRKOe8LUMnGi78uH8g
        pwosX2WlWQknsHrOjwQHrNAcE1+BOPM=
X-Google-Smtp-Source: AK7set8l8LttOuDE9xEiqTXs3Aficc6Zhwou2AU693HO7yweDxG65R3m3lrsFWiUkoUSeupE+nh+nA==
X-Received: by 2002:a17:90a:4041:b0:23f:9445:318c with SMTP id k1-20020a17090a404100b0023f9445318cmr5460462pjg.38.1679295841474;
        Mon, 20 Mar 2023 00:04:01 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (121-44-69-75.tpgi.com.au. [121.44.69.75])
        by smtp.gmail.com with ESMTPSA id r17-20020a632b11000000b0050f7f783ff0sm1039414pgr.76.2023.03.20.00.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 00:04:00 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v2 04/10] powerpc: Add ISA v3.1 (POWER10) support to SPR test
Date:   Mon, 20 Mar 2023 17:03:33 +1000
Message-Id: <20230320070339.915172-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230320070339.915172-1-npiggin@gmail.com>
References: <20230320070339.915172-1-npiggin@gmail.com>
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
index ba4ddee..6ee6dba 100644
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

