Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631F26CA462
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 14:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbjC0Mp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 08:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbjC0Mpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 08:45:53 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA06840DB
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:45:49 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso11672060pjb.3
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679921149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AzsWj+eiYcxcLoP7GVIK4WX+7kW2UTqsrzodaGYiHmg=;
        b=fx1ImSpLScjRgWY3kUgOn6xktNGpbpddsJWPjUXEwpfjYRZyKxfBn3FEd3K4usqAXN
         Afof64W69yr2jaAkSwSGaF92U/IuT7JGgYFVlDRXqpg07OYaFJFkAq7lRKnjJz6k63Tn
         DGxItozWjBYoG/7JVTlzpVml57RxmiBtKagVpyqpIrf959R1DFKa52UAjmU9JYQAUn6x
         KXqTUpM3ysRZyp3KFo6/jRJkrXxEHSsMsPGP+q4ms0WON3/S1MPeGHQSDqjjVOR/hijr
         RDzU6KWo6/2cni17lnA+nHemczxhWRLnwKfZt/91BI1+NoRWhVT9BxIdSU/N6GkT+Azu
         euhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679921149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AzsWj+eiYcxcLoP7GVIK4WX+7kW2UTqsrzodaGYiHmg=;
        b=A2hQHkBjYFCzwuSQ/TBMmF/QQtJyAHFEh4FhiRnDxbyfOiFyotaTqvM3kDoRhbaIeJ
         QJdQ6EFj4vbZNRg3KUXkSfoxQPhoqBJYGOfEah4dkqkO+/+2XCXWj23XWN5e2/sQ0DgL
         qQrRdfmVp3boFzLGI9J0bEQbk3op1IfwEw/PnXdB1SV+1FhXbjFWMtdBby1Wmb4Wu4k2
         KrSHy8c0UpGwstUYF6St9zwadHwTkkIy0y9MFtxFEXQmg0Na9AULBlpY0Ed25QOfrlrS
         IieinRaJQPZ9sS4eYUR4jRRjt3w5tuxVvLnZqZmsDIeUNdQX0BQVbU1JZfcU09aniDfZ
         BsGQ==
X-Gm-Message-State: AAQBX9c0OqGqqDeLvmzqqGJo5+lUT994Esp2D49mWZPTfYS64i6/MzAh
        2EQvGT0nIWXKTC0VJmAKTgexGnUXnLk=
X-Google-Smtp-Source: AKy350bw9djJHToyI+OAtsOmMLKPafwZaaRIUttaH6uy+R+I/Ot4rFpt6ZmYb/iO2rdjX7BwqOjiRg==
X-Received: by 2002:a17:902:e548:b0:1a1:241a:9bd0 with SMTP id n8-20020a170902e54800b001a1241a9bd0mr12257194plf.5.1679921148694;
        Mon, 27 Mar 2023 05:45:48 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([203.221.180.225])
        by smtp.gmail.com with ESMTPSA id ay6-20020a1709028b8600b0019a997bca5csm19053965plb.121.2023.03.27.05.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 05:45:48 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v3 05/13] powerpc: Add ISA v3.1 (POWER10) support to SPR test
Date:   Mon, 27 Mar 2023 22:45:12 +1000
Message-Id: <20230327124520.2707537-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327124520.2707537-1-npiggin@gmail.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

